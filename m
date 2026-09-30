Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC71B51CF4D;
	Wed, 30 Sep 2026 16:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785068; cv=none; b=BOv8Nj2LYQSJ6BsfpKjvGUWVVFlFQJS9t1IO3Zqa4gILY3wgifF12mlZOENrYsgqJbnLXvIBy797+uE9oEuj28fBS2kqAm4IZIAcWkoNCJ3QWO9oMgT2bu9+wh4iX7ZV88T1ZwL0EjeK6Ql8hcXZi6o8GRXhCiBksQQLAReSO50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785068; c=relaxed/simple;
	bh=nCRpymLPMo0yW3EwKn/Ib7+v5NeQLkJRujhUHjTGyJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMtkA7VDZzLQMgrHfjXxx3PiSaaSG9LU+H12aaS2GcDqtnMDmNrAjE6/W8qZp177aS2vU4C9HHjukfwmJHAnbk2kpwieMJ87jqmp+JVojOQav+CEalVyJnfmGT8bDzNB6ixuz+Tgc26FSirPGgTOA//FXmOf21TKgi+pTRp/bdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTN0bypV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTN0bypV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990881F00898;
	Wed, 30 Sep 2026 16:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785062;
	bh=Ggi80z7M1ZcC09+mqJru3l9gXCAuydDxwyiqoBjBVCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XTN0bypVCdYEk3UbWtQrarMT84Es9wOYVsKsLEbEsSGDVm/LweHX3a2RyjbojHYFM
	 9ScduavuhhVtrfTFBxe9cTk8827AN+krNo6wmYiqjiKl3MFyT5QIxkrF0Qo1JCfto8
	 HHZsWI1D7VItwqGKHLsFoHg/LNDmMwxJf22AeO2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 376/982] ASoC: ux500: Validate MSP DAI configuration
Date: Wed, 30 Sep 2026 17:18:32 +0200
Message-ID: <20260930152424.888044299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 9ccbacf5a0120964fc1ffacb8151e3347bee9287 ]

Installing channel constraints from hw_params is too late to affect the
parameters being committed. The driver consequently accepts channel
counts which disagree with the I2S or TDM setup. It also silently
truncates out-of-range slot masks and accepts inverted bit clock formats
which prepare then rejects.

Validate the selected channel count directly, reject invalid masks
before changing cached TDM state, and implement all four standard clock
and frame inversion combinations. Use the requested format in
validation diagnostics.

Fixes: 3592b7f69a54 ("ASoC: Ux500: Add MSP I2S-driver")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260902-ux500-msp-fixes-v2-4-4b60b002d55a@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ux500/ux500_msp_dai.c | 41 ++++++++++++++++++++++-----------
 sound/soc/ux500/ux500_msp_i2s.c |  7 ++++--
 sound/soc/ux500/ux500_msp_i2s.h |  1 +
 3 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index 1b01f53aeff6d..ad26185c54943 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -130,7 +130,16 @@ static int setup_clocking(struct snd_soc_dai *dai,
 	case SND_SOC_DAIFMT_NB_IF:
 		msp_config->tx_fsync_pol ^= 1 << TFSPOL_SHIFT;
 		msp_config->rx_fsync_pol ^= 1 << RFSPOL_SHIFT;
+		break;
+
+	case SND_SOC_DAIFMT_IB_NF:
+		msp_config->bclk_inverted = true;
+		break;
 
+	case SND_SOC_DAIFMT_IB_IF:
+		msp_config->bclk_inverted = true;
+		msp_config->tx_fsync_pol ^= 1 << TFSPOL_SHIFT;
+		msp_config->rx_fsync_pol ^= 1 << RFSPOL_SHIFT;
 		break;
 
 	default:
@@ -453,7 +462,6 @@ static int ux500_msp_dai_hw_params(struct snd_pcm_substream *substream,
 				struct snd_soc_dai *dai)
 {
 	unsigned int mask, slots_active;
-	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct ux500_msp_i2s_drvdata *drvdata = dev_get_drvdata(dai->dev);
 
 	dev_dbg(dai->dev, "%s: MSP %d (%s): Enter.\n",
@@ -461,9 +469,8 @@ static int ux500_msp_dai_hw_params(struct snd_pcm_substream *substream,
 
 	switch (drvdata->fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
-		snd_pcm_hw_constraint_minmax(runtime,
-				SNDRV_PCM_HW_PARAM_CHANNELS,
-				1, 2);
+		if (params_channels(params) < 1 || params_channels(params) > 2)
+			return -EINVAL;
 		break;
 
 	case SND_SOC_DAIFMT_DSP_B:
@@ -475,9 +482,8 @@ static int ux500_msp_dai_hw_params(struct snd_pcm_substream *substream,
 		slots_active = hweight32(mask);
 		dev_dbg(dai->dev, "TDM-slots active: %d", slots_active);
 
-		snd_pcm_hw_constraint_single(runtime,
-				SNDRV_PCM_HW_PARAM_CHANNELS,
-				slots_active);
+		if (!slots_active || params_channels(params) != slots_active)
+			return -EINVAL;
 		break;
 
 	default:
@@ -510,20 +516,21 @@ static int ux500_msp_dai_set_dai_fmt(struct snd_soc_dai *dai,
 	default:
 		dev_err(dai->dev,
 			"%s: Error: Unsupported protocol/master (fmt = 0x%x)!\n",
-			__func__, drvdata->fmt);
+			__func__, fmt);
 		return -EINVAL;
 	}
 
 	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
 	case SND_SOC_DAIFMT_NB_NF:
 	case SND_SOC_DAIFMT_NB_IF:
+	case SND_SOC_DAIFMT_IB_NF:
 	case SND_SOC_DAIFMT_IB_IF:
 		break;
 
 	default:
 		dev_err(dai->dev,
 			"%s: Error: Unsupported inversion (fmt = 0x%x)!\n",
-			__func__, drvdata->fmt);
+			__func__, fmt);
 		return -EINVAL;
 	}
 
@@ -557,17 +564,23 @@ static int ux500_msp_dai_set_tdm_slot(struct snd_soc_dai *dai,
 			__func__, slots);
 		return -EINVAL;
 	}
-	drvdata->slots = slots;
 
-	if (!(slot_width == 16)) {
+	if (slot_width != 16) {
 		dev_err(dai->dev, "%s: Error: Unsupported slot-width (%d)!\n",
 			__func__, slot_width);
 		return -EINVAL;
 	}
-	drvdata->slot_width = slot_width;
 
-	drvdata->tx_mask = tx_mask & cap;
-	drvdata->rx_mask = rx_mask & cap;
+	if ((tx_mask | rx_mask) & ~cap) {
+		dev_err(dai->dev, "%s: Slot mask exceeds %d slots\n",
+			__func__, slots);
+		return -EINVAL;
+	}
+
+	drvdata->slots = slots;
+	drvdata->slot_width = slot_width;
+	drvdata->tx_mask = tx_mask;
+	drvdata->rx_mask = rx_mask;
 
 	return 0;
 }
diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index d1f00cb7d21ce..81187ed8669c8 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -201,10 +201,12 @@ static int configure_protocol(struct ux500_msp *msp,
 
 	/* The code below should not be separated. */
 	temp_reg = readl(msp->registers + MSP_GCR) & ~TX_CLK_POL_RISING;
-	temp_reg |= MSP_TX_CLKPOL_BIT(~protdesc->tx_clk_pol);
+	temp_reg |= MSP_TX_CLKPOL_BIT(!protdesc->tx_clk_pol ^
+					  config->bclk_inverted);
 	writel(temp_reg, msp->registers + MSP_GCR);
 	temp_reg = readl(msp->registers + MSP_GCR) & ~RX_CLK_POL_RISING;
-	temp_reg |= MSP_RX_CLKPOL_BIT(protdesc->rx_clk_pol);
+	temp_reg |= MSP_RX_CLKPOL_BIT(protdesc->rx_clk_pol ^
+					  config->bclk_inverted);
 	writel(temp_reg, msp->registers + MSP_GCR);
 
 	return 0;
@@ -455,6 +457,7 @@ static bool ux500_msp_config_compatible(struct ux500_msp *msp,
 	       active->data_size == config->data_size &&
 	       active->def_elem_len == config->def_elem_len &&
 	       active->clock_provider == config->clock_provider &&
+	       active->bclk_inverted == config->bclk_inverted &&
 	       !memcmp(&active->protdesc, &config->protdesc,
 		       sizeof(active->protdesc));
 }
diff --git a/sound/soc/ux500/ux500_msp_i2s.h b/sound/soc/ux500/ux500_msp_i2s.h
index 5bba201ebe52a..fd48f85b7bf8d 100644
--- a/sound/soc/ux500/ux500_msp_i2s.h
+++ b/sound/soc/ux500/ux500_msp_i2s.h
@@ -459,6 +459,7 @@ struct ux500_msp_config {
 	unsigned int def_elem_len;
 	unsigned int iodelay;
 	bool clock_provider;
+	bool bclk_inverted;
 };
 
 struct ux500_msp_dma_params {
-- 
2.53.0



