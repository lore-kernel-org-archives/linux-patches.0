Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3800653365;
	Thu, 12 Dec 2024 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023876; cv=none; b=DLs6QJ5ax5NmnQXmTUvxm8qf1TSbVUbcux4iMn25cG01Ao0K/3rFKNw+1OhlUhhsFi5nNibM25MlhaarBrNDhXd3q6b4fBtPGJvuAPWrLDAMEQQqTrC95ANRV0fFYD0u4KOAGIiyYWzDGqp7Lj0XwZk56lpVWk9Ed+vmiyYakmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023876; c=relaxed/simple;
	bh=XKiUqX2+NhyihMbdgIQKykC7yHYPQgtXhwSSWN27cCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFqRY9BwprsOeKz1fZ97D04ZkjK3+TaoUtgu50loawUXPAP3RTarIwZcXMUcRUQerM0Ws36q7szos/N5IuGyg3eEePWHHpoAfm+sk6/wR/O+weF/FLLOw1Ayi6JOx3nrfKnrNkH7YmgtuaS05icbYw8wEwruaublF9hbeh1cIqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciOrAW/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciOrAW/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E176C4CED0;
	Thu, 12 Dec 2024 17:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023875;
	bh=XKiUqX2+NhyihMbdgIQKykC7yHYPQgtXhwSSWN27cCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciOrAW/aa+SCqMh61od663jUe4YRMfX7ZhW84kIaTtuw1clpg64CQ/j0eeM70qNNo
	 JThOO9M5pHfF1kfp3Ol8L+kCIN41rQ3poKMDY4o+BYB52aTEE8gH2NnjnweJLj24Fv
	 j5fcH5CnkTC6sDeQe9i5UjzEWkygQdRkJ6UI5dRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/459] ASoC: fsl_micfil: use GENMASK to define register bit fields
Date: Thu, 12 Dec 2024 15:57:29 +0100
Message-ID: <20241212144257.899149073@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 17f2142bae4b6f2e27f19ce57d79fc42ba5ef659 ]

Use GENMASK along with FIELD_PREP and FIELD_GET to access bitfields in
registers to straighten register access and to drop a lot of defines.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://lore.kernel.org/r/20220414162249.3934543-6-s.hauer@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 06df673d2023 ("ASoC: fsl_micfil: fix regmap_write_bits usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c |  52 ++++++-------
 sound/soc/fsl/fsl_micfil.h | 147 ++++++++-----------------------------
 2 files changed, 58 insertions(+), 141 deletions(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 13d963a840333..20215303fa34b 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright 2018 NXP
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
@@ -115,23 +116,22 @@ static inline int get_pdm_clk(struct fsl_micfil *micfil,
 	int bclk;
 
 	regmap_read(micfil->regmap, REG_MICFIL_CTRL2, &ctrl2_reg);
-	osr = 16 - ((ctrl2_reg & MICFIL_CTRL2_CICOSR_MASK)
-		    >> MICFIL_CTRL2_CICOSR_SHIFT);
-	qsel = ctrl2_reg & MICFIL_CTRL2_QSEL_MASK;
+	osr = 16 - FIELD_GET(MICFIL_CTRL2_CICOSR, ctrl2_reg);
+	qsel = FIELD_GET(MICFIL_CTRL2_QSEL, ctrl2_reg);
 
 	switch (qsel) {
-	case MICFIL_HIGH_QUALITY:
+	case MICFIL_QSEL_HIGH_QUALITY:
 		bclk = rate * 8 * osr / 2; /* kfactor = 0.5 */
 		break;
-	case MICFIL_MEDIUM_QUALITY:
-	case MICFIL_VLOW0_QUALITY:
+	case MICFIL_QSEL_MEDIUM_QUALITY:
+	case MICFIL_QSEL_VLOW0_QUALITY:
 		bclk = rate * 4 * osr * 1; /* kfactor = 1 */
 		break;
-	case MICFIL_LOW_QUALITY:
-	case MICFIL_VLOW1_QUALITY:
+	case MICFIL_QSEL_LOW_QUALITY:
+	case MICFIL_QSEL_VLOW1_QUALITY:
 		bclk = rate * 2 * osr * 2; /* kfactor = 2 */
 		break;
-	case MICFIL_VLOW2_QUALITY:
+	case MICFIL_QSEL_VLOW2_QUALITY:
 		bclk = rate * osr * 4; /* kfactor = 4 */
 		break;
 	default:
@@ -265,8 +265,8 @@ static int fsl_micfil_trigger(struct snd_pcm_substream *substream, int cmd,
 		 * 11 - reserved
 		 */
 		ret = regmap_update_bits(micfil->regmap, REG_MICFIL_CTRL1,
-					 MICFIL_CTRL1_DISEL_MASK,
-					 (1 << MICFIL_CTRL1_DISEL_SHIFT));
+				MICFIL_CTRL1_DISEL,
+				FIELD_PREP(MICFIL_CTRL1_DISEL, MICFIL_CTRL1_DISEL_DMA));
 		if (ret) {
 			dev_err(dev, "failed to update DISEL bits\n");
 			return ret;
@@ -295,8 +295,8 @@ static int fsl_micfil_trigger(struct snd_pcm_substream *substream, int cmd,
 		}
 
 		ret = regmap_update_bits(micfil->regmap, REG_MICFIL_CTRL1,
-					 MICFIL_CTRL1_DISEL_MASK,
-					 (0 << MICFIL_CTRL1_DISEL_SHIFT));
+				MICFIL_CTRL1_DISEL,
+				FIELD_PREP(MICFIL_CTRL1_DISEL, MICFIL_CTRL1_DISEL_DISABLE));
 		if (ret) {
 			dev_err(dev, "failed to update DISEL bits\n");
 			return ret;
@@ -321,8 +321,8 @@ static int fsl_set_clock_params(struct device *dev, unsigned int rate)
 
 	/* set CICOSR */
 	ret |= regmap_update_bits(micfil->regmap, REG_MICFIL_CTRL2,
-				 MICFIL_CTRL2_CICOSR_MASK,
-				 MICFIL_CTRL2_OSR_DEFAULT);
+				 MICFIL_CTRL2_CICOSR,
+				 FIELD_PREP(MICFIL_CTRL2_CICOSR, MICFIL_CTRL2_CICOSR_DEFAULT));
 	if (ret)
 		dev_err(dev, "failed to set CICOSR in reg 0x%X\n",
 			REG_MICFIL_CTRL2);
@@ -333,7 +333,8 @@ static int fsl_set_clock_params(struct device *dev, unsigned int rate)
 		ret = -EINVAL;
 
 	ret |= regmap_update_bits(micfil->regmap, REG_MICFIL_CTRL2,
-				 MICFIL_CTRL2_CLKDIV_MASK, clk_div);
+				 MICFIL_CTRL2_CLKDIV,
+				 FIELD_PREP(MICFIL_CTRL2_CLKDIV, clk_div));
 	if (ret)
 		dev_err(dev, "failed to set CLKDIV in reg 0x%X\n",
 			REG_MICFIL_CTRL2);
@@ -409,13 +410,13 @@ static int fsl_micfil_dai_probe(struct snd_soc_dai *cpu_dai)
 {
 	struct fsl_micfil *micfil = dev_get_drvdata(cpu_dai->dev);
 	struct device *dev = cpu_dai->dev;
-	unsigned int val;
 	int ret;
 	int i;
 
 	/* set qsel to medium */
 	ret = regmap_update_bits(micfil->regmap, REG_MICFIL_CTRL2,
-				 MICFIL_CTRL2_QSEL_MASK, MICFIL_MEDIUM_QUALITY);
+			MICFIL_CTRL2_QSEL,
+			FIELD_PREP(MICFIL_CTRL2_QSEL, MICFIL_QSEL_MEDIUM_QUALITY));
 	if (ret) {
 		dev_err(dev, "failed to set quality mode bits, reg 0x%X\n",
 			REG_MICFIL_CTRL2);
@@ -431,10 +432,9 @@ static int fsl_micfil_dai_probe(struct snd_soc_dai *cpu_dai)
 				  &micfil->dma_params_rx);
 
 	/* FIFO Watermark Control - FIFOWMK*/
-	val = MICFIL_FIFO_CTRL_FIFOWMK(micfil->soc->fifo_depth) - 1;
 	ret = regmap_update_bits(micfil->regmap, REG_MICFIL_FIFO_CTRL,
-				 MICFIL_FIFO_CTRL_FIFOWMK_MASK,
-				 val);
+			MICFIL_FIFO_CTRL_FIFOWMK,
+			FIELD_PREP(MICFIL_FIFO_CTRL_FIFOWMK, micfil->soc->fifo_depth - 1));
 	if (ret) {
 		dev_err(dev, "failed to set FIFOWMK\n");
 		return ret;
@@ -596,11 +596,11 @@ static irqreturn_t micfil_isr(int irq, void *devid)
 	regmap_read(micfil->regmap, REG_MICFIL_CTRL1, &ctrl1_reg);
 	regmap_read(micfil->regmap, REG_MICFIL_FIFO_STAT, &fifo_stat_reg);
 
-	dma_enabled = MICFIL_DMA_ENABLED(ctrl1_reg);
+	dma_enabled = FIELD_GET(MICFIL_CTRL1_DISEL, ctrl1_reg) == MICFIL_CTRL1_DISEL_DMA;
 
 	/* Channel 0-7 Output Data Flags */
 	for (i = 0; i < MICFIL_OUTPUT_CHANNELS; i++) {
-		if (stat_reg & MICFIL_STAT_CHXF_MASK(i))
+		if (stat_reg & MICFIL_STAT_CHXF(i))
 			dev_dbg(&pdev->dev,
 				"Data available in Data Channel %d\n", i);
 		/* if DMA is not enabled, field must be written with 1
@@ -609,17 +609,17 @@ static irqreturn_t micfil_isr(int irq, void *devid)
 		if (!dma_enabled)
 			regmap_write_bits(micfil->regmap,
 					  REG_MICFIL_STAT,
-					  MICFIL_STAT_CHXF_MASK(i),
+					  MICFIL_STAT_CHXF(i),
 					  1);
 	}
 
 	for (i = 0; i < MICFIL_FIFO_NUM; i++) {
-		if (fifo_stat_reg & MICFIL_FIFO_STAT_FIFOX_OVER_MASK(i))
+		if (fifo_stat_reg & MICFIL_FIFO_STAT_FIFOX_OVER(i))
 			dev_dbg(&pdev->dev,
 				"FIFO Overflow Exception flag for channel %d\n",
 				i);
 
-		if (fifo_stat_reg & MICFIL_FIFO_STAT_FIFOX_UNDER_MASK(i))
+		if (fifo_stat_reg & MICFIL_FIFO_STAT_FIFOX_UNDER(i))
 			dev_dbg(&pdev->dev,
 				"FIFO Underflow Exception flag for channel %d\n",
 				i);
diff --git a/sound/soc/fsl/fsl_micfil.h b/sound/soc/fsl/fsl_micfil.h
index 11ccc08523b2e..5cecae2519795 100644
--- a/sound/soc/fsl/fsl_micfil.h
+++ b/sound/soc/fsl/fsl_micfil.h
@@ -39,82 +39,45 @@
 #define MICFIL_CTRL1_DBG		BIT(28)
 #define MICFIL_CTRL1_SRES		BIT(27)
 #define MICFIL_CTRL1_DBGE		BIT(26)
-#define MICFIL_CTRL1_DISEL_SHIFT	24
-#define MICFIL_CTRL1_DISEL_WIDTH	2
-#define MICFIL_CTRL1_DISEL_MASK		((BIT(MICFIL_CTRL1_DISEL_WIDTH) - 1) \
-					 << MICFIL_CTRL1_DISEL_SHIFT)
+
+#define MICFIL_CTRL1_DISEL_DISABLE	0
+#define MICFIL_CTRL1_DISEL_DMA		1
+#define MICFIL_CTRL1_DISEL_IRQ		2
+#define MICFIL_CTRL1_DISEL		GENMASK(25, 24)
 #define MICFIL_CTRL1_ERREN		BIT(23)
-#define MICFIL_CTRL1_CHEN_SHIFT		0
-#define MICFIL_CTRL1_CHEN_WIDTH		8
-#define MICFIL_CTRL1_CHEN_MASK(x)	(BIT(x) << MICFIL_CTRL1_CHEN_SHIFT)
-#define MICFIL_CTRL1_CHEN(x)		(MICFIL_CTRL1_CHEN_MASK(x))
+#define MICFIL_CTRL1_CHEN(ch)		BIT(ch)
 
 /* MICFIL Control Register 2 -- REG_MICFILL_CTRL2 0x04 */
 #define MICFIL_CTRL2_QSEL_SHIFT		25
-#define MICFIL_CTRL2_QSEL_WIDTH		3
-#define MICFIL_CTRL2_QSEL_MASK		((BIT(MICFIL_CTRL2_QSEL_WIDTH) - 1) \
-					 << MICFIL_CTRL2_QSEL_SHIFT)
-#define MICFIL_HIGH_QUALITY		BIT(MICFIL_CTRL2_QSEL_SHIFT)
-#define MICFIL_MEDIUM_QUALITY		(0 << MICFIL_CTRL2_QSEL_SHIFT)
-#define MICFIL_LOW_QUALITY		(7 << MICFIL_CTRL2_QSEL_SHIFT)
-#define MICFIL_VLOW0_QUALITY		(6 << MICFIL_CTRL2_QSEL_SHIFT)
-#define MICFIL_VLOW1_QUALITY		(5 << MICFIL_CTRL2_QSEL_SHIFT)
-#define MICFIL_VLOW2_QUALITY		(4 << MICFIL_CTRL2_QSEL_SHIFT)
-
-#define MICFIL_CTRL2_CICOSR_SHIFT	16
-#define MICFIL_CTRL2_CICOSR_WIDTH	4
-#define MICFIL_CTRL2_CICOSR_MASK	((BIT(MICFIL_CTRL2_CICOSR_WIDTH) - 1) \
-					 << MICFIL_CTRL2_CICOSR_SHIFT)
-#define MICFIL_CTRL2_CICOSR(v)		(((v) << MICFIL_CTRL2_CICOSR_SHIFT) \
-					 & MICFIL_CTRL2_CICOSR_MASK)
-#define MICFIL_CTRL2_CLKDIV_SHIFT	0
-#define MICFIL_CTRL2_CLKDIV_WIDTH	8
-#define MICFIL_CTRL2_CLKDIV_MASK	((BIT(MICFIL_CTRL2_CLKDIV_WIDTH) - 1) \
-					 << MICFIL_CTRL2_CLKDIV_SHIFT)
-#define MICFIL_CTRL2_CLKDIV(v)		(((v) << MICFIL_CTRL2_CLKDIV_SHIFT) \
-					 & MICFIL_CTRL2_CLKDIV_MASK)
+#define MICFIL_CTRL2_QSEL		GENMASK(27, 25)
+#define MICFIL_QSEL_MEDIUM_QUALITY	0
+#define MICFIL_QSEL_HIGH_QUALITY	1
+#define MICFIL_QSEL_LOW_QUALITY		7
+#define MICFIL_QSEL_VLOW0_QUALITY	6
+#define MICFIL_QSEL_VLOW1_QUALITY	5
+#define MICFIL_QSEL_VLOW2_QUALITY	4
+
+#define MICFIL_CTRL2_CICOSR		GENMASK(19, 16)
+#define MICFIL_CTRL2_CICOSR_DEFAULT	0
+#define MICFIL_CTRL2_CLKDIV		GENMASK(7, 0)
 
 /* MICFIL Status Register -- REG_MICFIL_STAT 0x08 */
 #define MICFIL_STAT_BSY_FIL		BIT(31)
 #define MICFIL_STAT_FIR_RDY		BIT(30)
 #define MICFIL_STAT_LOWFREQF		BIT(29)
-#define MICFIL_STAT_CHXF_SHIFT(v)	(v)
-#define MICFIL_STAT_CHXF_MASK(v)	BIT(MICFIL_STAT_CHXF_SHIFT(v))
-#define MICFIL_STAT_CHXF(v)		BIT(MICFIL_STAT_CHXF_SHIFT(v))
+#define MICFIL_STAT_CHXF(ch)		BIT(ch)
 
 /* MICFIL FIFO Control Register -- REG_MICFIL_FIFO_CTRL 0x10 */
-#define MICFIL_FIFO_CTRL_FIFOWMK_SHIFT	0
-#define MICFIL_FIFO_CTRL_FIFOWMK_WIDTH	3
-#define MICFIL_FIFO_CTRL_FIFOWMK_MASK	((BIT(MICFIL_FIFO_CTRL_FIFOWMK_WIDTH) - 1) \
-					 << MICFIL_FIFO_CTRL_FIFOWMK_SHIFT)
-#define MICFIL_FIFO_CTRL_FIFOWMK(v)	(((v) << MICFIL_FIFO_CTRL_FIFOWMK_SHIFT) \
-					 & MICFIL_FIFO_CTRL_FIFOWMK_MASK)
+#define MICFIL_FIFO_CTRL_FIFOWMK	GENMASK(2, 0)
 
 /* MICFIL FIFO Status Register -- REG_MICFIL_FIFO_STAT 0x14 */
-#define MICFIL_FIFO_STAT_FIFOX_OVER_SHIFT(v)	(v)
-#define MICFIL_FIFO_STAT_FIFOX_OVER_MASK(v)	BIT(MICFIL_FIFO_STAT_FIFOX_OVER_SHIFT(v))
-#define MICFIL_FIFO_STAT_FIFOX_UNDER_SHIFT(v)	((v) + 8)
-#define MICFIL_FIFO_STAT_FIFOX_UNDER_MASK(v)	BIT(MICFIL_FIFO_STAT_FIFOX_UNDER_SHIFT(v))
+#define MICFIL_FIFO_STAT_FIFOX_OVER(ch)	BIT(ch)
+#define MICFIL_FIFO_STAT_FIFOX_UNDER(ch)	BIT((ch) + 8)
 
 /* MICFIL HWVAD0 Control 1 Register -- REG_MICFIL_VAD0_CTRL1*/
-#define MICFIL_VAD0_CTRL1_CHSEL_SHIFT	24
-#define MICFIL_VAD0_CTRL1_CHSEL_WIDTH	3
-#define MICFIL_VAD0_CTRL1_CHSEL_MASK	((BIT(MICFIL_VAD0_CTRL1_CHSEL_WIDTH) - 1) \
-					 << MICFIL_VAD0_CTRL1_CHSEL_SHIFT)
-#define MICFIL_VAD0_CTRL1_CHSEL(v)	(((v) << MICFIL_VAD0_CTRL1_CHSEL_SHIFT) \
-					 & MICFIL_VAD0_CTRL1_CHSEL_MASK)
-#define MICFIL_VAD0_CTRL1_CICOSR_SHIFT	16
-#define MICFIL_VAD0_CTRL1_CICOSR_WIDTH	4
-#define MICFIL_VAD0_CTRL1_CICOSR_MASK	((BIT(MICFIL_VAD0_CTRL1_CICOSR_WIDTH) - 1) \
-					 << MICFIL_VAD0_CTRL1_CICOSR_SHIFT)
-#define MICFIL_VAD0_CTRL1_CICOSR(v)	(((v) << MICFIL_VAD0_CTRL1_CICOSR_SHIFT) \
-					 & MICFIL_VAD0_CTRL1_CICOSR_MASK)
-#define MICFIL_VAD0_CTRL1_INITT_SHIFT	8
-#define MICFIL_VAD0_CTRL1_INITT_WIDTH	5
-#define MICFIL_VAD0_CTRL1_INITT_MASK	((BIT(MICFIL_VAD0_CTRL1_INITT_WIDTH) - 1) \
-					 << MICFIL_VAD0_CTRL1_INITT_SHIFT)
-#define MICFIL_VAD0_CTRL1_INITT(v)	(((v) << MICFIL_VAD0_CTRL1_INITT_SHIFT) \
-					 & MICFIL_VAD0_CTRL1_INITT_MASK)
+#define MICFIL_VAD0_CTRL1_CHSEL_SHIFT	GENMASK(26, 24)
+#define MICFIL_VAD0_CTRL1_CICOSR_SHIFT	GENMASK(19, 16)
+#define MICFIL_VAD0_CTRL1_INITT_SHIFT	GENMASK(12, 8)
 #define MICFIL_VAD0_CTRL1_ST10		BIT(4)
 #define MICFIL_VAD0_CTRL1_ERIE		BIT(3)
 #define MICFIL_VAD0_CTRL1_IE		BIT(2)
@@ -125,66 +88,26 @@
 #define MICFIL_VAD0_CTRL2_FRENDIS	BIT(31)
 #define MICFIL_VAD0_CTRL2_PREFEN	BIT(30)
 #define MICFIL_VAD0_CTRL2_FOUTDIS	BIT(28)
-#define MICFIL_VAD0_CTRL2_FRAMET_SHIFT	16
-#define MICFIL_VAD0_CTRL2_FRAMET_WIDTH	6
-#define MICFIL_VAD0_CTRL2_FRAMET_MASK	((BIT(MICFIL_VAD0_CTRL2_FRAMET_WIDTH) - 1) \
-					 << MICFIL_VAD0_CTRL2_FRAMET_SHIFT)
-#define MICFIL_VAD0_CTRL2_FRAMET(v)	(((v) << MICFIL_VAD0_CTRL2_FRAMET_SHIFT) \
-					 & MICFIL_VAD0_CTRL2_FRAMET_MASK)
-#define MICFIL_VAD0_CTRL2_INPGAIN_SHIFT	8
-#define MICFIL_VAD0_CTRL2_INPGAIN_WIDTH	4
-#define MICFIL_VAD0_CTRL2_INPGAIN_MASK	((BIT(MICFIL_VAD0_CTRL2_INPGAIN_WIDTH) - 1) \
-					 << MICFIL_VAD0_CTRL2_INPGAIN_SHIFT)
-#define MICFIL_VAD0_CTRL2_INPGAIN(v)	(((v) << MICFIL_VAD0_CTRL2_INPGAIN_SHIFT) \
-					& MICFIL_VAD0_CTRL2_INPGAIN_MASK)
-#define MICFIL_VAD0_CTRL2_HPF_SHIFT	0
-#define MICFIL_VAD0_CTRL2_HPF_WIDTH	2
-#define MICFIL_VAD0_CTRL2_HPF_MASK	((BIT(MICFIL_VAD0_CTRL2_HPF_WIDTH) - 1) \
-					 << MICFIL_VAD0_CTRL2_HPF_SHIFT)
-#define MICFIL_VAD0_CTRL2_HPF(v)	(((v) << MICFIL_VAD0_CTRL2_HPF_SHIFT) \
-					 & MICFIL_VAD0_CTRL2_HPF_MASK)
+#define MICFIL_VAD0_CTRL2_FRAMET	GENMASK(21, 16)
+#define MICFIL_VAD0_CTRL2_INPGAIN	GENMASK(11, 8)
+#define MICFIL_VAD0_CTRL2_HPF		GENMASK(1, 0)
 
 /* MICFIL HWVAD0 Signal CONFIG Register -- REG_MICFIL_VAD0_SCONFIG */
 #define MICFIL_VAD0_SCONFIG_SFILEN		BIT(31)
 #define MICFIL_VAD0_SCONFIG_SMAXEN		BIT(30)
-#define MICFIL_VAD0_SCONFIG_SGAIN_SHIFT		0
-#define MICFIL_VAD0_SCONFIG_SGAIN_WIDTH		4
-#define MICFIL_VAD0_SCONFIG_SGAIN_MASK		((BIT(MICFIL_VAD0_SCONFIG_SGAIN_WIDTH) - 1) \
-						<< MICFIL_VAD0_SCONFIG_SGAIN_SHIFT)
-#define MICFIL_VAD0_SCONFIG_SGAIN(v)		(((v) << MICFIL_VAD0_SCONFIG_SGAIN_SHIFT) \
-						 & MICFIL_VAD0_SCONFIG_SGAIN_MASK)
+#define MICFIL_VAD0_SCONFIG_SGAIN		GENMASK(3, 0)
 
 /* MICFIL HWVAD0 Noise CONFIG Register -- REG_MICFIL_VAD0_NCONFIG */
 #define MICFIL_VAD0_NCONFIG_NFILAUT		BIT(31)
 #define MICFIL_VAD0_NCONFIG_NMINEN		BIT(30)
 #define MICFIL_VAD0_NCONFIG_NDECEN		BIT(29)
 #define MICFIL_VAD0_NCONFIG_NOREN		BIT(28)
-#define MICFIL_VAD0_NCONFIG_NFILADJ_SHIFT	8
-#define MICFIL_VAD0_NCONFIG_NFILADJ_WIDTH	5
-#define MICFIL_VAD0_NCONFIG_NFILADJ_MASK	((BIT(MICFIL_VAD0_NCONFIG_NFILADJ_WIDTH) - 1) \
-						 << MICFIL_VAD0_NCONFIG_NFILADJ_SHIFT)
-#define MICFIL_VAD0_NCONFIG_NFILADJ(v)		(((v) << MICFIL_VAD0_NCONFIG_NFILADJ_SHIFT) \
-						 & MICFIL_VAD0_NCONFIG_NFILADJ_MASK)
-#define MICFIL_VAD0_NCONFIG_NGAIN_SHIFT		0
-#define MICFIL_VAD0_NCONFIG_NGAIN_WIDTH		4
-#define MICFIL_VAD0_NCONFIG_NGAIN_MASK		((BIT(MICFIL_VAD0_NCONFIG_NGAIN_WIDTH) - 1) \
-						 << MICFIL_VAD0_NCONFIG_NGAIN_SHIFT)
-#define MICFIL_VAD0_NCONFIG_NGAIN(v)		(((v) << MICFIL_VAD0_NCONFIG_NGAIN_SHIFT) \
-						 & MICFIL_VAD0_NCONFIG_NGAIN_MASK)
+#define MICFIL_VAD0_NCONFIG_NFILADJ		GENMASK(12, 8)
+#define MICFIL_VAD0_NCONFIG_NGAIN		GENMASK(3, 0)
 
 /* MICFIL HWVAD0 Zero-Crossing Detector - REG_MICFIL_VAD0_ZCD */
-#define MICFIL_VAD0_ZCD_ZCDTH_SHIFT	16
-#define MICFIL_VAD0_ZCD_ZCDTH_WIDTH	10
-#define MICFIL_VAD0_ZCD_ZCDTH_MASK	((BIT(MICFIL_VAD0_ZCD_ZCDTH_WIDTH) - 1) \
-					 << MICFIL_VAD0_ZCD_ZCDTH_SHIFT)
-#define MICFIL_VAD0_ZCD_ZCDTH(v)	(((v) << MICFIL_VAD0_ZCD_ZCDTH_SHIFT)\
-					 & MICFIL_VAD0_ZCD_ZCDTH_MASK)
-#define MICFIL_VAD0_ZCD_ZCDADJ_SHIFT	8
-#define MICFIL_VAD0_ZCD_ZCDADJ_WIDTH	4
-#define MICFIL_VAD0_ZCD_ZCDADJ_MASK	((BIT(MICFIL_VAD0_ZCD_ZCDADJ_WIDTH) - 1)\
-					 << MICFIL_VAD0_ZCD_ZCDADJ_SHIFT)
-#define MICFIL_VAD0_ZCD_ZCDADJ(v)	(((v) << MICFIL_VAD0_ZCD_ZCDADJ_SHIFT)\
-					 & MICFIL_VAD0_ZCD_ZCDADJ_MASK)
+#define MICFIL_VAD0_ZCD_ZCDTH		GENMASK(25, 16)
+#define MICFIL_VAD0_ZCD_ZCDADJ_SHIFT	GENMASK(11, 8)
 #define MICFIL_VAD0_ZCD_ZCDAND		BIT(4)
 #define MICFIL_VAD0_ZCD_ZCDAUT		BIT(2)
 #define MICFIL_VAD0_ZCD_ZCDEN		BIT(0)
@@ -199,11 +122,6 @@
 #define MICFIL_OUTGAIN_CHX_SHIFT(v)	(4 * (v))
 
 /* Constants */
-#define MICFIL_DMA_IRQ_DISABLED(v)	((v) & MICFIL_CTRL1_DISEL_MASK)
-#define MICFIL_DMA_ENABLED(v)		((0x1 << MICFIL_CTRL1_DISEL_SHIFT) \
-					 == ((v) & MICFIL_CTRL1_DISEL_MASK))
-#define MICFIL_IRQ_ENABLED(v)		((0x2 << MICFIL_CTRL1_DISEL_SHIFT) \
-					 == ((v) & MICFIL_CTRL1_DISEL_MASK))
 #define MICFIL_OUTPUT_CHANNELS		8
 #define MICFIL_FIFO_NUM			8
 
@@ -215,6 +133,5 @@
 #define MICFIL_SLEEP_MIN		90000 /* in us */
 #define MICFIL_SLEEP_MAX		100000 /* in us */
 #define MICFIL_DMA_MAXBURST_RX		6
-#define MICFIL_CTRL2_OSR_DEFAULT	(0 << MICFIL_CTRL2_CICOSR_SHIFT)
 
 #endif /* _FSL_MICFIL_H */
-- 
2.43.0



