Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5CF25228D;
	Tue, 29 Apr 2025 18:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949734; cv=none; b=LKCLPoCEAuDipvIeJ5t40+tNfImlMb/lN8QSsVyo1L1U0qxDXXti0NFTfcZHNVZY8oVEUkMkiJE6xaFuuK6jZdoGLBjVEosoc67qqozsx5ZSILBDcEuVRBS+WcBmvIOUjaoQKxLJ2XZRvaMpbIGe8CuZzHZM2wiJfvJV8ho3DQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949734; c=relaxed/simple;
	bh=XKduWQlQ8zUvVoeEYdZCkYqW8QEvRJM4Gvw6qe8k8tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCgAQUBJbo5hbyzryJjXP+1fyrlLjTbLkVCHhXaIVtvYyVW0bKtzI7Llc3+MYA1svOAgmQ3DV5SE84tzNIvl4N+9C/p6UueC7x/B57LRBUubk+/04OYqhkuYKBVZJFHrESfrX8HzFnsoRraDdiqDmVfRYKkX9aOjObhfdHfhhMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CbYtpjWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbYtpjWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC4DC4CEF4;
	Tue, 29 Apr 2025 18:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949733;
	bh=XKduWQlQ8zUvVoeEYdZCkYqW8QEvRJM4Gvw6qe8k8tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CbYtpjWOoqZJXKkmyQw/q2sCsaPHSoc9dl7t0l1fc5NaOwvFJHPPYk3lF8jscGPZf
	 dqchp+XWp+DAQZjMEoL6lh7/4uaJ0xFX5v8YVo9k54qqZWFIjXvTK4MvpHnjJifl32
	 NyWADWCsI9IzrOrzGQChe6MG2FTyBcmLvYHp+/D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/167] ASoC: qcom: q6dsp: add support to more display ports
Date: Tue, 29 Apr 2025 18:42:28 +0200
Message-ID: <20250429161053.377987662@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 90848a2557fec0a6f1a35e58031a1f6f5e44e7d6 ]

Existing code base only supports one display port, this patch adds
support upto 8 display ports. This support is required to allow platforms
like X13s which have 3 display ports, and some of the Qualcomm SoCs
there are upto 7 Display ports.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org
Link: https://lore.kernel.org/r/20230509112202.21471-4-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org
Stable-dep-of: a31a4934b31f ("ASoC: qcom: Fix sc7280 lpass potential buffer overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../sound/qcom,q6dsp-lpass-ports.h            |  8 ++++
 sound/soc/qcom/qdsp6/q6dsp-lpass-ports.c      | 43 ++++++++++++-------
 2 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/include/dt-bindings/sound/qcom,q6dsp-lpass-ports.h b/include/dt-bindings/sound/qcom,q6dsp-lpass-ports.h
index 9f7c5103bc82b..39f203256c4f6 100644
--- a/include/dt-bindings/sound/qcom,q6dsp-lpass-ports.h
+++ b/include/dt-bindings/sound/qcom,q6dsp-lpass-ports.h
@@ -131,6 +131,14 @@
 #define RX_CODEC_DMA_RX_7	126
 #define QUINARY_MI2S_RX		127
 #define QUINARY_MI2S_TX		128
+#define DISPLAY_PORT_RX_0	DISPLAY_PORT_RX
+#define DISPLAY_PORT_RX_1	129
+#define DISPLAY_PORT_RX_2	130
+#define DISPLAY_PORT_RX_3	131
+#define DISPLAY_PORT_RX_4	132
+#define DISPLAY_PORT_RX_5	133
+#define DISPLAY_PORT_RX_6	134
+#define DISPLAY_PORT_RX_7	135
 
 #define LPASS_CLK_ID_PRI_MI2S_IBIT	1
 #define LPASS_CLK_ID_PRI_MI2S_EBIT	2
diff --git a/sound/soc/qcom/qdsp6/q6dsp-lpass-ports.c b/sound/soc/qcom/qdsp6/q6dsp-lpass-ports.c
index f67c16fd90b9b..ac937a6bf909b 100644
--- a/sound/soc/qcom/qdsp6/q6dsp-lpass-ports.c
+++ b/sound/soc/qcom/qdsp6/q6dsp-lpass-ports.c
@@ -79,6 +79,22 @@
 		.id = did,						\
 	}
 
+#define Q6AFE_DP_RX_DAI(did) {						\
+		.playback = {						\
+			.stream_name = #did" Playback",			\
+			.rates = SNDRV_PCM_RATE_48000 |			\
+				SNDRV_PCM_RATE_96000 |			\
+				SNDRV_PCM_RATE_192000,			\
+			.formats = SNDRV_PCM_FMTBIT_S16_LE |		\
+				   SNDRV_PCM_FMTBIT_S24_LE,		\
+			.channels_min = 2,				\
+			.channels_max = 8,				\
+			.rate_min = 48000,				\
+			.rate_max = 192000,				\
+		},							\
+		.name = #did,						\
+		.id = did,						\
+	}
 
 static struct snd_soc_dai_driver q6dsp_audio_fe_dais[] = {
 	{
@@ -528,22 +544,14 @@ static struct snd_soc_dai_driver q6dsp_audio_fe_dais[] = {
 	Q6AFE_TDM_CAP_DAI("Quinary", 5, QUINARY_TDM_TX_5),
 	Q6AFE_TDM_CAP_DAI("Quinary", 6, QUINARY_TDM_TX_6),
 	Q6AFE_TDM_CAP_DAI("Quinary", 7, QUINARY_TDM_TX_7),
-	{
-		.playback = {
-			.stream_name = "Display Port Playback",
-			.rates = SNDRV_PCM_RATE_48000 |
-				 SNDRV_PCM_RATE_96000 |
-				 SNDRV_PCM_RATE_192000,
-			.formats = SNDRV_PCM_FMTBIT_S16_LE |
-				   SNDRV_PCM_FMTBIT_S24_LE,
-			.channels_min = 2,
-			.channels_max = 8,
-			.rate_max =     192000,
-			.rate_min =	48000,
-		},
-		.id = DISPLAY_PORT_RX,
-		.name = "DISPLAY_PORT",
-	},
+	Q6AFE_DP_RX_DAI(DISPLAY_PORT_RX_0),
+	Q6AFE_DP_RX_DAI(DISPLAY_PORT_RX_1),
+	Q6AFE_DP_RX_DAI(DISPLAY_PORT_RX_2),
+	Q6AFE_DP_RX_DAI(DISPLAY_PORT_RX_3),
+	Q6AFE_DP_RX_DAI(DISPLAY_PORT_RX_4),
+	Q6AFE_DP_RX_DAI(DISPLAY_PORT_RX_5),
+	Q6AFE_DP_RX_DAI(DISPLAY_PORT_RX_6),
+	Q6AFE_DP_RX_DAI(DISPLAY_PORT_RX_7),
 	Q6AFE_CDC_DMA_RX_DAI(WSA_CODEC_DMA_RX_0),
 	Q6AFE_CDC_DMA_TX_DAI(WSA_CODEC_DMA_TX_0),
 	Q6AFE_CDC_DMA_RX_DAI(WSA_CODEC_DMA_RX_1),
@@ -603,6 +611,9 @@ struct snd_soc_dai_driver *q6dsp_audio_ports_set_config(struct device *dev,
 		case DISPLAY_PORT_RX:
 			q6dsp_audio_fe_dais[i].ops = cfg->q6hdmi_ops;
 			break;
+		case DISPLAY_PORT_RX_1 ... DISPLAY_PORT_RX_7:
+			q6dsp_audio_fe_dais[i].ops = cfg->q6hdmi_ops;
+			break;
 		case SLIMBUS_0_RX ... SLIMBUS_6_TX:
 			q6dsp_audio_fe_dais[i].ops = cfg->q6slim_ops;
 			break;
-- 
2.39.5



