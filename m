Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9C7185924;
	Fri, 15 Nov 2024 06:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653544; cv=none; b=Dg+mZvRtOPOVRs71BO64CEUgeUOPiYJ2j3VHT5tGaC16pjEd8cedbltLaTlm+haPsHCOvz3gc/aQ8umNEsYkpUR2vH5VtNkTB05Ow5z2QX2PfU2Om1nQmRkSIQLLJ92V3WQOSIUSPM6WrJmiDgltdVAHFZpzfge9+etHP3LSgfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653544; c=relaxed/simple;
	bh=FnoiFPD5ly6G0BKct9r6XpmB065JuIDIA1nxzigmx5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olZE5kMkAwP7bGGvAzBCNbRmgLPVdLlUc8OHxg0n2aPv+b0JuohgWy3R9/pK5YlmzrR1B9TCikiW/H9VrR6TFHfpqnnrxPHSttKoMljBjT6kqTVx2cvidEaeBiOqR3OCCDei1G1c7Lvtc6bbWJEpUAeFt7Xr9eb15WmWxMUaaXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfZS5eNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfZS5eNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C3AC4CECF;
	Fri, 15 Nov 2024 06:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653544;
	bh=FnoiFPD5ly6G0BKct9r6XpmB065JuIDIA1nxzigmx5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cfZS5eNH+6b7yES426P65P9nHrHRvDjeM6YhM+lu4E8Arr1+jJimU3qdmwokzd3Ao
	 57QMzfT7PR7rwnuoOnuXcmm6f0olVSetwW5sPVv6pe9Mz2WjOxbXh9qaaj4xaVlyNH
	 6EWPASbssHHIntsqZqC5hrmSN66sqLQK7Jkwq6fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 37/48] ASoC: fsl_micfil: Add sample rate constraint
Date: Fri, 15 Nov 2024 07:38:26 +0100
Message-ID: <20241115063724.304219545@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit b9a8ecf81066e01e8a3de35517481bc5aa0439e5 ]

On some platforms, for example i.MX93, there is only one
audio PLL source, so some sample rate can't be supported.
If the PLL source is used for 8kHz series rates, then 11kHz
series rates can't be supported.

So add constraints according to the frequency of available
clock sources, then alsa-lib will help to convert the
unsupported rate for the driver.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/1728884313-6778-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 9407179af5d57..8478a4ac59f9d 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -28,6 +28,13 @@
 
 #define MICFIL_OSR_DEFAULT	16
 
+#define MICFIL_NUM_RATES	7
+#define MICFIL_CLK_SRC_NUM	3
+/* clock source ids */
+#define MICFIL_AUDIO_PLL1	0
+#define MICFIL_AUDIO_PLL2	1
+#define MICFIL_CLK_EXT3		2
+
 enum quality {
 	QUALITY_HIGH,
 	QUALITY_MEDIUM,
@@ -45,9 +52,12 @@ struct fsl_micfil {
 	struct clk *mclk;
 	struct clk *pll8k_clk;
 	struct clk *pll11k_clk;
+	struct clk *clk_src[MICFIL_CLK_SRC_NUM];
 	struct snd_dmaengine_dai_dma_data dma_params_rx;
 	struct sdma_peripheral_config sdmacfg;
 	struct snd_soc_card *card;
+	struct snd_pcm_hw_constraint_list constraint_rates;
+	unsigned int constraint_rates_list[MICFIL_NUM_RATES];
 	unsigned int dataline;
 	char name[32];
 	int irq[MICFIL_IRQ_LINES];
@@ -475,12 +485,34 @@ static int fsl_micfil_startup(struct snd_pcm_substream *substream,
 			      struct snd_soc_dai *dai)
 {
 	struct fsl_micfil *micfil = snd_soc_dai_get_drvdata(dai);
+	unsigned int rates[MICFIL_NUM_RATES] = {8000, 11025, 16000, 22050, 32000, 44100, 48000};
+	int i, j, k = 0;
+	u64 clk_rate;
 
 	if (!micfil) {
 		dev_err(dai->dev, "micfil dai priv_data not set\n");
 		return -EINVAL;
 	}
 
+	micfil->constraint_rates.list = micfil->constraint_rates_list;
+	micfil->constraint_rates.count = 0;
+
+	for (j = 0; j < MICFIL_NUM_RATES; j++) {
+		for (i = 0; i < MICFIL_CLK_SRC_NUM; i++) {
+			clk_rate = clk_get_rate(micfil->clk_src[i]);
+			if (clk_rate != 0 && do_div(clk_rate, rates[j]) == 0) {
+				micfil->constraint_rates_list[k++] = rates[j];
+				micfil->constraint_rates.count++;
+				break;
+			}
+		}
+	}
+
+	if (micfil->constraint_rates.count > 0)
+		snd_pcm_hw_constraint_list(substream->runtime, 0,
+					   SNDRV_PCM_HW_PARAM_RATE,
+					   &micfil->constraint_rates);
+
 	return 0;
 }
 
@@ -1165,6 +1197,12 @@ static int fsl_micfil_probe(struct platform_device *pdev)
 	fsl_asoc_get_pll_clocks(&pdev->dev, &micfil->pll8k_clk,
 				&micfil->pll11k_clk);
 
+	micfil->clk_src[MICFIL_AUDIO_PLL1] = micfil->pll8k_clk;
+	micfil->clk_src[MICFIL_AUDIO_PLL2] = micfil->pll11k_clk;
+	micfil->clk_src[MICFIL_CLK_EXT3] = devm_clk_get(&pdev->dev, "clkext3");
+	if (IS_ERR(micfil->clk_src[MICFIL_CLK_EXT3]))
+		micfil->clk_src[MICFIL_CLK_EXT3] = NULL;
+
 	/* init regmap */
 	regs = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(regs))
-- 
2.43.0



