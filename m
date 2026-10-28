Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214893;
	b=GIDSAZl8EJMZXnFWvy21d9At/S1jEzhQ3xYPacudPgsIVSv9JNbUTZmWXx8N9d0VhNIa
	 JSkKSdxfdik64/n+2zbfGR4iriOqXOqVlZe4b00ILQezipuVb093InRiBOkiJlOjlrKBG
	 t+QTXsmgMHBEizDSckk9wKPIggnfMPS/BwMOCqqPgse/5CidjOGOMttkxLnk8AtOlQ1rL
	 2yWXHTFKexe9VnwbUhI/oIMpIwo107hdeHyTEgVCxgT5cqZ7ArzRF+uA+RBA8yb8KB9BJ
	 9Qh0lzXRjiu4h4n6t16HLTUoGl8xu6vD5jSOmEuMhY4ReXC9S4yQ9zOkj2+8cYH7Txg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jy9gpCS9vsJYyRWFsE9QEL6cV6jjIYPzkoMMrdR2T+Y=;
	b=JfodBIj+Ap/n3EsNMR5ao3TxWS+goVLDHnt47+6OExgO0hbaiFq9y/Y07xbrXcsbneSC
	 e0H0EdEQ6PODDEoFdTbQMcGeo2vdBcdCbjZsHPD6BKB+R0mw4K3PLe4ja2au20M2igrYx
	 qa27Na75DfrudlhEU6+w+EBBixzon7lVbr3CNNHiyBstRNGfn0ehlEXLtfLrMvn+yy7zY
	 rG6sWRvYX1Ks4T33/YEc+vbPu2t/t0UeXfKJmblYLAKb+3Q7yoDHF+13b+Z5I18XSHz/z
	 Em399JQs+TRY/5L+eJfAvCkpxFf8CNCYYfr5TiEexKvt66UF+vnG+u1HLkEjg0kCRng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFPJwY4T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9989F606A31C;
	Wed, 28 Oct 2026 19:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFPJwY4T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98611F01825;
	Wed, 28 Oct 2026 19:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214892;
	bh=jy9gpCS9vsJYyRWFsE9QEL6cV6jjIYPzkoMMrdR2T+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFPJwY4T1cHe4/QgrnH71ZJUGzMETzG/Kw3zEBu2bEvynPCL3AcAFhinTrzoLam4Z
	 +xKJ8xk4vByCzuwltYa19LwibrOFClirNiqC3B9I2bOgP8v0LkPOj+2J1bLHprRyDD
	 5opiG2RHdKCMK1787oHX4mCjTWADmmyANrxDmxdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1019/1887] ASoC: amd: acp: Refactor i2s clocks programming sequence
Date: Wed, 28 Oct 2026 17:51:55 +0100
Message-ID: <20261028170522.605003765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit ca9d237994db63dca68f2b04e257a4738847deee ]

Refactor i2s clock values based on hw_params and use srate and
bclk_ratio variables in clock enable API instead hard-code values.

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Link: https://lore.kernel.org/r/20230109132104.1259479-4-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 30c64fb98399 ("ASoC: amd: acp-mach-common: Add missing error check for clock acquisition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-mach-common.c | 169 ++++++++++++++++------------
 1 file changed, 94 insertions(+), 75 deletions(-)

diff --git a/sound/soc/amd/acp/acp-mach-common.c b/sound/soc/amd/acp/acp-mach-common.c
index 543d1fdc4976a..1d9eab824145c 100644
--- a/sound/soc/amd/acp/acp-mach-common.c
+++ b/sound/soc/amd/acp/acp-mach-common.c
@@ -54,10 +54,11 @@ static const struct snd_pcm_hw_constraint_list constraints_channels = {
 	.mask = 0,
 };
 
-static int acp_clk_enable(struct acp_card_drvdata *drvdata)
+static int acp_clk_enable(struct acp_card_drvdata *drvdata,
+			  unsigned int srate, unsigned int bclk_ratio)
 {
-	clk_set_rate(drvdata->wclk, 48000);
-	clk_set_rate(drvdata->bclk, 48000 * 64);
+	clk_set_rate(drvdata->wclk, srate);
+	clk_set_rate(drvdata->bclk, srate * bclk_ratio);
 
 	return clk_prepare_enable(drvdata->wclk);
 }
@@ -86,27 +87,6 @@ static int acp_card_rt5682_init(struct snd_soc_pcm_runtime *rtd)
 	if (drvdata->hs_codec_id != RT5682)
 		return -EINVAL;
 
-	ret = snd_soc_dai_set_pll(codec_dai, RT5682_PLL2, RT5682_PLL2_S_MCLK,
-				  PCO_PLAT_CLK, RT5682_PLL_FREQ);
-	if (ret < 0) {
-		dev_err(rtd->dev, "Failed to set codec PLL: %d\n", ret);
-		return ret;
-	}
-
-	ret = snd_soc_dai_set_sysclk(codec_dai, RT5682_SCLK_S_PLL2,
-				     RT5682_PLL_FREQ, SND_SOC_CLOCK_IN);
-	if (ret < 0) {
-		dev_err(rtd->dev, "Failed to set codec SYSCLK: %d\n", ret);
-		return ret;
-	}
-
-	/* Set tdm/i2s1 master bclk ratio */
-	ret = snd_soc_dai_set_bclk_ratio(codec_dai, 64);
-	if (ret < 0) {
-		dev_err(rtd->dev, "Failed to set rt5682 tdm bclk ratio: %d\n", ret);
-		return ret;
-	}
-
 	drvdata->wclk = clk_get(component->dev, "rt5682-dai-wclk");
 	drvdata->bclk = clk_get(component->dev, "rt5682-dai-bclk");
 
@@ -161,16 +141,6 @@ static int acp_card_hs_startup(struct snd_pcm_substream *substream)
 	snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_RATE,
 				      &constraints_rates);
 
-	if (strcmp(codec_dai->name, "rt5682s-aif1") && strcmp(codec_dai->name, "rt5682s-aif2")) {
-		if (!drvdata->soc_mclk) {
-			ret = acp_clk_enable(drvdata);
-			if (ret < 0) {
-				dev_err(rtd->card->dev, "Failed to enable HS clk: %d\n", ret);
-				return ret;
-			}
-		}
-	}
-
 	return ret;
 }
 
@@ -193,7 +163,11 @@ static int acp_card_rt5682_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_dai *codec_dai = asoc_rtd_to_codec(rtd, 0);
 	struct snd_soc_dai *cpu_dai = asoc_rtd_to_cpu(rtd, 0);
 	int ret;
-	unsigned int fmt;
+	unsigned int fmt, srate, ch, format;
+
+	srate = params_rate(params);
+	ch = params_channels(params);
+	format = 8 * params_format(params);
 
 	if (drvdata->soc_mclk)
 		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBC_CFC;
@@ -212,6 +186,35 @@ static int acp_card_rt5682_hw_params(struct snd_pcm_substream *substream,
 		return ret;
 	}
 
+	ret = snd_soc_dai_set_pll(codec_dai, RT5682_PLL2, RT5682_PLL2_S_MCLK,
+				  PCO_PLAT_CLK, RT5682_PLL_FREQ);
+	if (ret < 0) {
+		dev_err(rtd->dev, "Failed to set codec PLL: %d\n", ret);
+		return ret;
+	}
+
+	ret = snd_soc_dai_set_sysclk(codec_dai, RT5682_SCLK_S_PLL2,
+				     RT5682_PLL_FREQ, SND_SOC_CLOCK_IN);
+	if (ret < 0) {
+		dev_err(rtd->dev, "Failed to set codec SYSCLK: %d\n", ret);
+		return ret;
+	}
+
+	/* Set tdm/i2s1 master bclk ratio */
+	ret = snd_soc_dai_set_bclk_ratio(codec_dai, ch * format);
+	if (ret < 0) {
+		dev_err(rtd->dev, "Failed to set rt5682 tdm bclk ratio: %d\n", ret);
+		return ret;
+	}
+
+	if (!drvdata->soc_mclk) {
+		ret = acp_clk_enable(drvdata, srate, ch * format);
+		if (ret < 0) {
+			dev_err(rtd->card->dev, "Failed to enable HS clk: %d\n", ret);
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
@@ -244,27 +247,6 @@ static int acp_card_rt5682s_init(struct snd_soc_pcm_runtime *rtd)
 	if (drvdata->hs_codec_id != RT5682S)
 		return -EINVAL;
 
-	ret = snd_soc_dai_set_pll(codec_dai, RT5682S_PLL2, RT5682S_PLL_S_MCLK,
-				  PCO_PLAT_CLK, RT5682_PLL_FREQ);
-	if (ret < 0) {
-		dev_err(rtd->dev, "Failed to set codec PLL: %d\n", ret);
-		return ret;
-	}
-
-	ret = snd_soc_dai_set_sysclk(codec_dai, RT5682S_SCLK_S_PLL2,
-				     RT5682_PLL_FREQ, SND_SOC_CLOCK_IN);
-	if (ret < 0) {
-		dev_err(rtd->dev, "Failed to set codec SYSCLK: %d\n", ret);
-		return ret;
-	}
-
-	/* Set tdm/i2s1 master bclk ratio */
-	ret = snd_soc_dai_set_bclk_ratio(codec_dai, 64);
-	if (ret < 0) {
-		dev_err(rtd->dev, "Failed to set rt5682 tdm bclk ratio: %d\n", ret);
-		return ret;
-	}
-
 	if (!drvdata->soc_mclk) {
 		drvdata->wclk = clk_get(component->dev, "rt5682-dai-wclk");
 		drvdata->bclk = clk_get(component->dev, "rt5682-dai-bclk");
@@ -303,7 +285,11 @@ static int acp_card_rt5682s_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_dai *codec_dai = asoc_rtd_to_codec(rtd, 0);
 	struct snd_soc_dai *cpu_dai = asoc_rtd_to_cpu(rtd, 0);
 	int ret;
-	unsigned int fmt;
+	unsigned int fmt, srate, ch, format;
+
+	srate = params_rate(params);
+	ch = params_channels(params);
+	format = 8 * params_format(params);
 
 	if (drvdata->soc_mclk)
 		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBC_CFC;
@@ -322,6 +308,30 @@ static int acp_card_rt5682s_hw_params(struct snd_pcm_substream *substream,
 		return ret;
 	}
 
+	ret = snd_soc_dai_set_pll(codec_dai, RT5682S_PLL2, RT5682S_PLL_S_MCLK,
+				  PCO_PLAT_CLK, RT5682_PLL_FREQ);
+	if (ret < 0) {
+		dev_err(rtd->dev, "Failed to set codec PLL: %d\n", ret);
+		return ret;
+	}
+
+	ret = snd_soc_dai_set_sysclk(codec_dai, RT5682S_SCLK_S_PLL2,
+				     RT5682_PLL_FREQ, SND_SOC_CLOCK_IN);
+	if (ret < 0) {
+		dev_err(rtd->dev, "Failed to set codec SYSCLK: %d\n", ret);
+		return ret;
+	}
+
+	/* Set tdm/i2s1 master bclk ratio */
+	ret = snd_soc_dai_set_bclk_ratio(codec_dai, ch * format);
+	if (ret < 0) {
+		dev_err(rtd->dev, "Failed to set rt5682 tdm bclk ratio: %d\n", ret);
+		return ret;
+	}
+
+	clk_set_rate(drvdata->wclk, srate);
+	clk_set_rate(drvdata->bclk, srate * ch * format);
+
 	return 0;
 }
 
@@ -397,10 +407,12 @@ static int acp_card_rt1019_hw_params(struct snd_pcm_substream *substream,
 	struct acp_card_drvdata *drvdata = card->drvdata;
 	struct snd_soc_dai *codec_dai;
 	struct snd_soc_dai *cpu_dai = asoc_rtd_to_cpu(rtd, 0);
-	int srate, i, ret = 0;
-	unsigned int fmt;
+	int i, ret = 0;
+	unsigned int fmt, srate, ch, format;
 
 	srate = params_rate(params);
+	ch = params_channels(params);
+	format = 8 * params_format(params);
 
 	if (drvdata->amp_codec_id != RT1019)
 		return -EINVAL;
@@ -421,7 +433,7 @@ static int acp_card_rt1019_hw_params(struct snd_pcm_substream *substream,
 			continue;
 
 		ret = snd_soc_dai_set_pll(codec_dai, 0, RT1019_PLL_S_BCLK,
-					  64 * srate, 256 * srate);
+					  ch * format * srate, 256 * srate);
 		if (ret < 0)
 			return ret;
 
@@ -431,16 +443,20 @@ static int acp_card_rt1019_hw_params(struct snd_pcm_substream *substream,
 			return ret;
 	}
 
+	if (!drvdata->soc_mclk) {
+		ret = acp_clk_enable(drvdata, srate, ch * format);
+		if (ret < 0) {
+			dev_err(rtd->card->dev, "Failed to enable AMP clk: %d\n", ret);
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
 static int acp_card_amp_startup(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
-	struct snd_soc_card *card = rtd->card;
-	struct acp_card_drvdata *drvdata = card->drvdata;
-	int ret = 0;
 
 	runtime->hw.channels_max = DUAL_CHANNEL;
 	snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_CHANNELS,
@@ -448,14 +464,7 @@ static int acp_card_amp_startup(struct snd_pcm_substream *substream)
 	snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_RATE,
 				      &constraints_rates);
 
-	if (!drvdata->soc_mclk) {
-		ret = acp_clk_enable(drvdata);
-		if (ret < 0) {
-			dev_err(rtd->card->dev, "Failed to enable AMP clk: %d\n", ret);
-			return ret;
-		}
-	}
-	return ret;
+	return 0;
 }
 
 static const struct snd_soc_ops acp_card_rt1019_ops = {
@@ -491,9 +500,13 @@ static int acp_card_maxim_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_card *card = rtd->card;
 	struct acp_card_drvdata *drvdata = card->drvdata;
 	struct snd_soc_dai *cpu_dai = asoc_rtd_to_cpu(rtd, 0);
-	unsigned int fmt;
+	unsigned int fmt, srate, ch, format;
 	int ret;
 
+	srate = params_rate(params);
+	ch = params_channels(params);
+	format = 8 * params_format(params);
+
 	if (drvdata->soc_mclk)
 		fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBC_CFC;
 	else
@@ -504,6 +517,14 @@ static int acp_card_maxim_hw_params(struct snd_pcm_substream *substream,
 		dev_err(rtd->dev, "Failed to set dai fmt: %d\n", ret);
 		return ret;
 	}
+
+	if (!drvdata->soc_mclk) {
+		ret = acp_clk_enable(drvdata, srate, ch * format);
+		if (ret < 0) {
+			dev_err(rtd->card->dev, "Failed to enable AMP clk: %d\n", ret);
+			return ret;
+		}
+	}
 	return 0;
 }
 
@@ -688,8 +709,6 @@ static int acp_rtk_set_bias_level(struct snd_soc_card *card,
 	switch (level) {
 	case SND_SOC_BIAS_STANDBY:
 		if (snd_soc_dapm_get_bias_level(dapm) == SND_SOC_BIAS_OFF) {
-			clk_set_rate(drvdata->wclk, 48000);
-			clk_set_rate(drvdata->bclk, 48000 * 64);
 
 			/* Increase bclk's enable_count */
 			ret = clk_prepare_enable(drvdata->bclk);
-- 
2.53.0



