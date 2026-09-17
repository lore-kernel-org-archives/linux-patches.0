Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3360C4E5327;
	Thu, 17 Sep 2026 18:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668959; cv=none; b=L/wnhdRfAITYLjYc1Pv/5VIE0J8B7j9BkZZk0hFKUZD/S94SHcj3dD4Vs7yNxPVjl9Ykgf5A1jrN5J9QKWK643ocou0w/mRnint3knEKD7V85hzx5mI/ON0oZG2S6XKw7MBoK/QdIfWHGWKxEyuE1DTcYzV2yTi48IYUciK8MgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668959; c=relaxed/simple;
	bh=wqjNo8ad7oivReTMUKjX+8M4rQLKY4HMvl8Sxr6HP1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XatbzvgwbzWQJJWySHpD1SULK/CBiZ6BFrFdbDRR02Kh3lS/hTsJfFnROZcUbKccGKyqI861l9gABt+TIhwENQfo6fVmoplO1D9DOQBwUD+hNdXnvdO5NRZnSzklatIbdZM3jFeo9obaJ9k+iD4WOXLf1GNLoUBOnVIwnpIlPa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eh+R5uys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eh+R5uys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838211F000FF;
	Thu, 17 Sep 2026 18:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668958;
	bh=hiiRBpQrz/efXBqQ4Vmj7HKqq0RBA60kRuyRRX7Rd+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eh+R5uysLT9EiS4Jdlry36MUkCxUNwgeCGhMvWlrcg/zjn+QCmwvj62AIXNEYgpw1
	 sFW8/C0EpCImiYdhwP8paUiVO6t50h6Felw1dH9vf0nYgCv7KPDiwqc4uze6DIbS3s
	 z9LZnGqbgq5iclOWNLbYNfEinlI5vAOjIfG8Mvcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0559/1102] ASoC: ab8500: Correct digital interface format setup
Date: Thu, 17 Sep 2026 16:08:22 +0100
Message-ID: <20260917151553.899871432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20260917150822.hkg2O-3kdVRmr9yVVgm6LpKbs7gbh7vVTy77D6_pP9A@z>

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit f98785adf004db6b1c9f4cea9dadae7b800db72f ]

The codec programs I2S as an undelayed left-aligned format, although the
hardware manual defines delayed left-aligned as I2S compatible. It also
enables the master generator when the codec is a clock consumer, changes
registers before the complete format has been validated, and discards
register I/O errors.

Build all three interface register values before writing them, use the
required one-bit I2S delay, only run the master generator for a provider
configuration, and propagate write failures.

Fixes: 679d7abdc754 ("ASoC: codecs: Add AB8500 codec-driver")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260831-ab8500-codec-fixes-v1-3-f85024e717e3@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ab8500-codec.c | 175 ++++++++++++--------------------
 1 file changed, 64 insertions(+), 111 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 2c7e3b7a386ae..595d378d02320 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -2016,149 +2016,91 @@ static int ab8500_audio_set_ear_cmv(struct snd_soc_component *component,
 	return 0;
 }
 
-static int ab8500_audio_set_bit_delay(struct snd_soc_dai *dai,
-				unsigned int delay)
-{
-	unsigned int mask, val;
-	struct snd_soc_component *component = dai->component;
-
-	mask = BIT(AB8500_DIGIFCONF2_IF0DEL);
-	val = 0;
-
-	switch (delay) {
-	case 0:
-		break;
-	case 1:
-		val |= BIT(AB8500_DIGIFCONF2_IF0DEL);
-		break;
-	default:
-		dev_err(dai->component->dev,
-			"%s: ERROR: Unsupported bit-delay (0x%x)!\n",
-			__func__, delay);
-		return -EINVAL;
-	}
-
-	dev_dbg(dai->component->dev, "%s: IF0 Bit-delay: %d bits.\n",
-		__func__, delay);
-	snd_soc_component_update_bits(component, AB8500_DIGIFCONF2, mask, val);
-
-	return 0;
-}
-
-/* Gates clocking according format mask */
-static int ab8500_codec_set_dai_clock_gate(struct snd_soc_component *component,
-					unsigned int fmt)
-{
-	unsigned int mask;
-	unsigned int val;
-
-	mask = BIT(AB8500_DIGIFCONF1_ENMASTGEN) |
-			BIT(AB8500_DIGIFCONF1_ENFSBITCLK0);
-
-	val = BIT(AB8500_DIGIFCONF1_ENMASTGEN);
-
-	switch (fmt & SND_SOC_DAIFMT_CLOCK_MASK) {
-	case SND_SOC_DAIFMT_CONT: /* continuous clock */
-		dev_dbg(component->dev, "%s: IF0 Clock is continuous.\n",
-			__func__);
-		val |= BIT(AB8500_DIGIFCONF1_ENFSBITCLK0);
-		break;
-	case SND_SOC_DAIFMT_GATED: /* clock is gated */
-		dev_dbg(component->dev, "%s: IF0 Clock is gated.\n",
-			__func__);
-		break;
-	default:
-		dev_err(component->dev,
-			"%s: ERROR: Unsupported clock mask (0x%x)!\n",
-			__func__, fmt & SND_SOC_DAIFMT_CLOCK_MASK);
-		return -EINVAL;
-	}
-
-	snd_soc_component_update_bits(component, AB8500_DIGIFCONF1, mask, val);
-
-	return 0;
-}
-
 static int ab8500_codec_set_dai_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 {
-	unsigned int mask;
-	unsigned int val;
 	struct snd_soc_component *component = dai->component;
-	int status;
+	unsigned int conf1_mask, conf1_val = 0;
+	unsigned int conf2_mask, conf2_val = 0;
+	unsigned int conf3_mask, conf3_val = 0;
+	bool provider = false;
+	int ret;
 
 	dev_dbg(component->dev, "%s: Enter (fmt = 0x%x)\n", __func__, fmt);
 
-	mask = BIT(AB8500_DIGIFCONF3_IF1DATOIF0AD) |
+	conf3_mask = BIT(AB8500_DIGIFCONF3_IF1DATOIF0AD) |
 			BIT(AB8500_DIGIFCONF3_IF1CLKTOIF0CLK) |
 			BIT(AB8500_DIGIFCONF3_IF0BFIFOEN) |
 			BIT(AB8500_DIGIFCONF3_IF0MASTER);
-	val = 0;
 
 	switch (fmt & SND_SOC_DAIFMT_CLOCK_PROVIDER_MASK) {
 	case SND_SOC_DAIFMT_CBP_CFP:
-		dev_dbg(dai->component->dev,
+		dev_dbg(component->dev,
 			"%s: IF0 Master-mode: AB8500 provider.\n", __func__);
-		val |= BIT(AB8500_DIGIFCONF3_IF0MASTER);
+		conf3_val |= BIT(AB8500_DIGIFCONF3_IF0MASTER);
+		provider = true;
 		break;
 	case SND_SOC_DAIFMT_CBC_CFC:
-		dev_dbg(dai->component->dev,
+		dev_dbg(component->dev,
 			"%s: IF0 Master-mode: AB8500 consumer.\n", __func__);
 		break;
 	case SND_SOC_DAIFMT_CBC_CFP:
 	case SND_SOC_DAIFMT_CBP_CFC:
-		dev_err(dai->component->dev,
+		dev_err(component->dev,
 			"%s: ERROR: The device is either a provider or a consumer.\n",
 			__func__);
 		fallthrough;
 	default:
-		dev_err(dai->component->dev,
-			"%s: ERROR: Unsupporter clocking mask 0x%x\n",
+		dev_err(component->dev,
+			"%s: ERROR: Unsupported clocking mask 0x%x\n",
 			__func__, fmt & SND_SOC_DAIFMT_CLOCK_PROVIDER_MASK);
 		return -EINVAL;
 	}
 
-	snd_soc_component_update_bits(component, AB8500_DIGIFCONF3, mask, val);
-
-	/* Set clock gating */
-	status = ab8500_codec_set_dai_clock_gate(component, fmt);
-	if (status) {
-		dev_err(dai->component->dev,
-			"%s: ERROR: Failed to set clock gate (%d).\n",
-			__func__, status);
-		return status;
+	conf1_mask = BIT(AB8500_DIGIFCONF1_ENMASTGEN) |
+		     BIT(AB8500_DIGIFCONF1_ENFSBITCLK0);
+	switch (fmt & SND_SOC_DAIFMT_CLOCK_MASK) {
+	case SND_SOC_DAIFMT_CONT:
+		if (provider)
+			conf1_val = conf1_mask;
+		break;
+	case SND_SOC_DAIFMT_GATED:
+		if (provider)
+			conf1_val = BIT(AB8500_DIGIFCONF1_ENMASTGEN);
+		break;
+	default:
+		dev_err(component->dev, "%s: Unsupported clock mask 0x%x\n",
+			__func__, fmt & SND_SOC_DAIFMT_CLOCK_MASK);
+		return -EINVAL;
 	}
 
-	/* Setting data transfer format */
-
-	mask = BIT(AB8500_DIGIFCONF2_IF0FORMAT0) |
-		BIT(AB8500_DIGIFCONF2_IF0FORMAT1) |
-		BIT(AB8500_DIGIFCONF2_FSYNC0P) |
-		BIT(AB8500_DIGIFCONF2_BITCLK0P);
-	val = 0;
+	conf2_mask = BIT(AB8500_DIGIFCONF2_IF0FORMAT0) |
+		     BIT(AB8500_DIGIFCONF2_IF0FORMAT1) |
+		     BIT(AB8500_DIGIFCONF2_IF0DEL) |
+		     BIT(AB8500_DIGIFCONF2_FSYNC0P) |
+		     BIT(AB8500_DIGIFCONF2_BITCLK0P);
 
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S: /* I2S mode */
-		dev_dbg(dai->component->dev, "%s: IF0 Protocol: I2S\n", __func__);
-		val |= BIT(AB8500_DIGIFCONF2_IF0FORMAT1);
-		ab8500_audio_set_bit_delay(dai, 0);
+		dev_dbg(component->dev, "%s: IF0 Protocol: I2S\n", __func__);
+		conf2_val |= BIT(AB8500_DIGIFCONF2_IF0FORMAT1) |
+			     BIT(AB8500_DIGIFCONF2_IF0DEL);
 		break;
 
 	case SND_SOC_DAIFMT_DSP_A: /* L data MSB after FRM LRC */
-		dev_dbg(dai->component->dev,
+		dev_dbg(component->dev,
 			"%s: IF0 Protocol: DSP A (TDM)\n", __func__);
-		val |= BIT(AB8500_DIGIFCONF2_IF0FORMAT0);
-		ab8500_audio_set_bit_delay(dai, 1);
+		conf2_val |= BIT(AB8500_DIGIFCONF2_IF0FORMAT0) |
+			     BIT(AB8500_DIGIFCONF2_IF0DEL);
 		break;
 
 	case SND_SOC_DAIFMT_DSP_B: /* L data MSB during FRM LRC */
-		dev_dbg(dai->component->dev,
+		dev_dbg(component->dev,
 			"%s: IF0 Protocol: DSP B (TDM)\n", __func__);
-		val |= BIT(AB8500_DIGIFCONF2_IF0FORMAT0);
-		ab8500_audio_set_bit_delay(dai, 0);
+		conf2_val |= BIT(AB8500_DIGIFCONF2_IF0FORMAT0);
 		break;
 
 	default:
-		dev_err(dai->component->dev,
+		dev_err(component->dev,
 			"%s: ERROR: Unsupported format (0x%x)!\n",
 			__func__, fmt & SND_SOC_DAIFMT_FORMAT_MASK);
 		return -EINVAL;
@@ -2166,39 +2108,50 @@ static int ab8500_codec_set_dai_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 
 	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
 	case SND_SOC_DAIFMT_NB_NF: /* normal bit clock + frame */
-		dev_dbg(dai->component->dev,
+		dev_dbg(component->dev,
 			"%s: IF0: Normal bit clock, normal frame\n",
 			__func__);
 		break;
 	case SND_SOC_DAIFMT_NB_IF: /* normal BCLK + inv FRM */
-		dev_dbg(dai->component->dev,
+		dev_dbg(component->dev,
 			"%s: IF0: Normal bit clock, inverted frame\n",
 			__func__);
-		val |= BIT(AB8500_DIGIFCONF2_FSYNC0P);
+		conf2_val |= BIT(AB8500_DIGIFCONF2_FSYNC0P);
 		break;
 	case SND_SOC_DAIFMT_IB_NF: /* invert BCLK + nor FRM */
-		dev_dbg(dai->component->dev,
+		dev_dbg(component->dev,
 			"%s: IF0: Inverted bit clock, normal frame\n",
 			__func__);
-		val |= BIT(AB8500_DIGIFCONF2_BITCLK0P);
+		conf2_val |= BIT(AB8500_DIGIFCONF2_BITCLK0P);
 		break;
 	case SND_SOC_DAIFMT_IB_IF: /* invert BCLK + FRM */
-		dev_dbg(dai->component->dev,
+		dev_dbg(component->dev,
 			"%s: IF0: Inverted bit clock, inverted frame\n",
 			__func__);
-		val |= BIT(AB8500_DIGIFCONF2_FSYNC0P);
-		val |= BIT(AB8500_DIGIFCONF2_BITCLK0P);
+		conf2_val |= BIT(AB8500_DIGIFCONF2_FSYNC0P) |
+			     BIT(AB8500_DIGIFCONF2_BITCLK0P);
 		break;
 	default:
-		dev_err(dai->component->dev,
+		dev_err(component->dev,
 			"%s: ERROR: Unsupported INV mask 0x%x\n",
 			__func__, fmt & SND_SOC_DAIFMT_INV_MASK);
 		return -EINVAL;
 	}
 
-	snd_soc_component_update_bits(component, AB8500_DIGIFCONF2, mask, val);
+	ret = snd_soc_component_update_bits(component, AB8500_DIGIFCONF3,
+					    conf3_mask, conf3_val);
+	if (ret < 0)
+		return ret;
 
-	return 0;
+	ret = snd_soc_component_update_bits(component, AB8500_DIGIFCONF1,
+					    conf1_mask, conf1_val);
+	if (ret < 0)
+		return ret;
+
+	ret = snd_soc_component_update_bits(component, AB8500_DIGIFCONF2,
+					    conf2_mask, conf2_val);
+
+	return ret < 0 ? ret : 0;
 }
 
 static int ab8500_codec_set_dai_tdm_slot(struct snd_soc_dai *dai,
-- 
2.53.0



