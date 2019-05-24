Shader "Unlit/NewUnlitShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed2 random2(float2 st) {
				st = float2(dot(st, fixed2(127.1, 311.7)),
					        dot(st, fixed2(269.5, 183.3)));
				return -1.0 + 2.0*frac(sin(st)*43758.5453123);
			}

			float Noise(float2 st)
			{
				float2 p = floor(st);
				float2 f = frac(st);
				float2 u = f * f * (3.0 - 2.0*f);

				float v00 = random2(p + fixed2(0, 0));
				float v10 = random2(p + fixed2(1, 0));
				float v01 = random2(p + fixed2(0, 1));
				float v11 = random2(p + fixed2(1, 1));

				return lerp(lerp(dot(random2(p + float2(0.0, 0.0)), f - float2(0.0, 0.0)),
					             dot(random2(p + float2(1.0, 0.0)), f - float2(1.0, 0.0)), u.x),
				         	lerp(dot(random2(p + float2(0.0, 1.0)), f - float2(0.0, 1.0)),
				             	 dot(random2(p + float2(1.0, 1.0)), f - float2(1.0, 1.0)), u.x), u.y);
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = fixed4(0,0,0,1);
				col.xyz = (Noise(i.uv * 4.0  + _Time.y * 0.05))
					    + (Noise(i.uv * 8.0  + _Time.y * 0.20)) * 0.5
						+ (Noise(i.uv * 16.0 + _Time.y * 0.80)) * 0.25;
				return col / (1.0 + 0.5 + 0.25) * 0.5 + 0.5;
//				return sin(100 * col / (1.0 + 0.5 + 0.25)) * 0.5 + 0.5;
			}
			ENDCG
		}
	}
}
