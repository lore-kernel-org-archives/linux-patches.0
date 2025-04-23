Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0931128540E;
	Wed, 23 Apr 2025 15:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420588; cv=none; b=MKMGb+/1PZ/9OaNmYrr8+wVEFl7TYagUPMbS7D57J41i+tKHROpe9akCotwRIYrlsy169DeiXhITk20y6PznmfUTu+3t6P0505fXMl+Zd63H0fOLJs9Tk7KUJuLYK1KKC41wupEZRG9+WvRZhre1YLnkFcycYEvDFajpwyNZ7N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420588; c=relaxed/simple;
	bh=1DRMyqhgHRzttT8cCMvsEJ+P15ynU9UgvD9xiT2dY2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwT8r4OeJaWJ7o2xwht4LPdReiHwaDioTc1QkoTu+zrFz1yrPCfnPQcoj/rHvag4GW7omyvgotfqaM6C290sWVaQJHjU8/KiHSSmhP7usZ5X4Z8wLBWXbbCcoVOW3rNXDPEa8lAGh8PgDMa1tLDCKk3HMeM7OvHd5mBwPgxFJzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKnqd5At; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKnqd5At"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7E3C4CEEB;
	Wed, 23 Apr 2025 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420587;
	bh=1DRMyqhgHRzttT8cCMvsEJ+P15ynU9UgvD9xiT2dY2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKnqd5Atvdd/6O+2scIde9AQUNKKcdguyNmK1bO/tLtxLcpvzesZvixqXBGZdZXyW
	 w9oc7QJUMKZsJMgM4QKvie+BDY8oMvh1SFqJpTR+pilTHxpbBlVwwbcNyba7uHtMGN
	 8MQhlr6H5FD6GOPGQhkPLS1KKlTlnV2G8TLauVrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.14 105/241] ASoC: codecs:lpass-wsa-macro: Fix vi feedback rate
Date: Wed, 23 Apr 2025 16:42:49 +0200
Message-ID: <20250423142624.868551464@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit d7bff1415e85b889dc8908be6aedba8807ae5e37 upstream.

Currently the VI feedback rate is set to fixed 8K, fix this by getting
the correct rate from params_rate.

Without this patch incorrect rate will be set on the VI feedback
recording resulting in rate miss match and audio artifacts.

Fixes: 2c4066e5d428 ("ASoC: codecs: lpass-wsa-macro: add dapm widgets and route")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20250403160209.21613-2-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/lpass-wsa-macro.c |   39 ++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/lpass-wsa-macro.c
+++ b/sound/soc/codecs/lpass-wsa-macro.c
@@ -63,6 +63,10 @@
 #define CDC_WSA_TX_SPKR_PROT_CLK_DISABLE	0
 #define CDC_WSA_TX_SPKR_PROT_PCM_RATE_MASK	GENMASK(3, 0)
 #define CDC_WSA_TX_SPKR_PROT_PCM_RATE_8K	0
+#define CDC_WSA_TX_SPKR_PROT_PCM_RATE_16K	1
+#define CDC_WSA_TX_SPKR_PROT_PCM_RATE_24K	2
+#define CDC_WSA_TX_SPKR_PROT_PCM_RATE_32K	3
+#define CDC_WSA_TX_SPKR_PROT_PCM_RATE_48K	4
 #define CDC_WSA_TX0_SPKR_PROT_PATH_CFG0		(0x0248)
 #define CDC_WSA_TX1_SPKR_PROT_PATH_CTL		(0x0264)
 #define CDC_WSA_TX1_SPKR_PROT_PATH_CFG0		(0x0268)
@@ -407,6 +411,7 @@ struct wsa_macro {
 	int ear_spkr_gain;
 	int spkr_gain_offset;
 	int spkr_mode;
+	u32 pcm_rate_vi;
 	int is_softclip_on[WSA_MACRO_SOFTCLIP_MAX];
 	int softclip_clk_users[WSA_MACRO_SOFTCLIP_MAX];
 	struct regmap *regmap;
@@ -1280,6 +1285,7 @@ static int wsa_macro_hw_params(struct sn
 			       struct snd_soc_dai *dai)
 {
 	struct snd_soc_component *component = dai->component;
+	struct wsa_macro *wsa = snd_soc_component_get_drvdata(component);
 	int ret;
 
 	switch (substream->stream) {
@@ -1292,6 +1298,11 @@ static int wsa_macro_hw_params(struct sn
 			return ret;
 		}
 		break;
+	case SNDRV_PCM_STREAM_CAPTURE:
+		if (dai->id == WSA_MACRO_AIF_VI)
+			wsa->pcm_rate_vi = params_rate(params);
+
+		break;
 	default:
 		break;
 	}
@@ -1465,6 +1476,28 @@ static int wsa_macro_enable_vi_feedback(
 	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
 	struct wsa_macro *wsa = snd_soc_component_get_drvdata(component);
 	u32 tx_reg0, tx_reg1;
+	u32 rate_val;
+
+	switch (wsa->pcm_rate_vi) {
+	case 8000:
+		rate_val = CDC_WSA_TX_SPKR_PROT_PCM_RATE_8K;
+		break;
+	case 16000:
+		rate_val = CDC_WSA_TX_SPKR_PROT_PCM_RATE_16K;
+		break;
+	case 24000:
+		rate_val = CDC_WSA_TX_SPKR_PROT_PCM_RATE_24K;
+		break;
+	case 32000:
+		rate_val = CDC_WSA_TX_SPKR_PROT_PCM_RATE_32K;
+		break;
+	case 48000:
+		rate_val = CDC_WSA_TX_SPKR_PROT_PCM_RATE_48K;
+		break;
+	default:
+		rate_val = CDC_WSA_TX_SPKR_PROT_PCM_RATE_8K;
+		break;
+	}
 
 	if (test_bit(WSA_MACRO_TX0, &wsa->active_ch_mask[WSA_MACRO_AIF_VI])) {
 		tx_reg0 = CDC_WSA_TX0_SPKR_PROT_PATH_CTL;
@@ -1476,7 +1509,7 @@ static int wsa_macro_enable_vi_feedback(
 
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMU:
-			/* Enable V&I sensing */
+		/* Enable V&I sensing */
 		snd_soc_component_update_bits(component, tx_reg0,
 					      CDC_WSA_TX_SPKR_PROT_RESET_MASK,
 					      CDC_WSA_TX_SPKR_PROT_RESET);
@@ -1485,10 +1518,10 @@ static int wsa_macro_enable_vi_feedback(
 					      CDC_WSA_TX_SPKR_PROT_RESET);
 		snd_soc_component_update_bits(component, tx_reg0,
 					      CDC_WSA_TX_SPKR_PROT_PCM_RATE_MASK,
-					      CDC_WSA_TX_SPKR_PROT_PCM_RATE_8K);
+					      rate_val);
 		snd_soc_component_update_bits(component, tx_reg1,
 					      CDC_WSA_TX_SPKR_PROT_PCM_RATE_MASK,
-					      CDC_WSA_TX_SPKR_PROT_PCM_RATE_8K);
+					      rate_val);
 		snd_soc_component_update_bits(component, tx_reg0,
 					      CDC_WSA_TX_SPKR_PROT_CLK_EN_MASK,
 					      CDC_WSA_TX_SPKR_PROT_CLK_ENABLE);


