Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45EA258EC2;
	Thu, 15 Jan 2026 17:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497616; cv=none; b=hjRbtBior5eHZ8QDY4lHijvozM/TDyUut1hA2SJ5q8VuJk2sOySP+pHJrtkLgBMVzk0R7hvmy7bh1Oy/0dCYG4iMqci4M0RaVZ+dMsQrO3fSjXWK1FyP5fPaqm8T7IGdGwxa30jP+bn4PbXOuLFPOe7FHuIE5mKpdjjug7Qh4LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497616; c=relaxed/simple;
	bh=v3JFKz2CFqYS1034a8DcbUyll1mQdyYbj5RQmrHUkSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpidKEeyRKdcloZZSPOfV2/OeoE6UoiIMdqfCQH2QovD12tPtZ8PUNONFS4jopQVg4DoGmNiKgeu2cAYyhEO25X5zkMAJqTt1cRFeVMakguEgHBCTwzK4Q6yC/RhsdxUxV3z3bjU2Nh+X9Ju7sx/rQb/fHS/+je8P1G0Lw4zwZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IpKJO3UC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IpKJO3UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31691C16AAE;
	Thu, 15 Jan 2026 17:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497615;
	bh=v3JFKz2CFqYS1034a8DcbUyll1mQdyYbj5RQmrHUkSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IpKJO3UCJRNX1sQgKMV2mtMT/b6M3rQtt3p3yUD2YnpzsrUkMl71wXEYvwGzNqqzh
	 nwQSUBQZvjORkbw3kP7wjnOvstgqA/uebhk0EAGiYNBX9r6qA8knStaq/fDZznwXaF
	 +9G13jY26GiAMNkg6KMghAKfkV5ue5hMWgqDBODw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/554] ASoC: fsl_xcvr: Add support for i.MX93 platform
Date: Thu, 15 Jan 2026 17:43:30 +0100
Message-ID: <20260115164251.463189353@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit e240b9329a300af7b7c1eba2ce0abbf19e6c540b ]

Add compatible string and specific soc data to support XCVR on i.MX93
platform. XCVR IP on i.MX93 is cut to SPDIF only by removing external
PHY.

Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://lore.kernel.org/r/20230104023953.2973362-3-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 73b97d46dde6 ("ASoC: fsl_xcvr: clear the channel status control memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 143 ++++++++++++++++++++++++++-------------
 sound/soc/fsl/fsl_xcvr.h |   7 ++
 2 files changed, 102 insertions(+), 48 deletions(-)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index 1feb5758245f0..3fee1aa03363b 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -21,6 +21,7 @@
 
 struct fsl_xcvr_soc_data {
 	const char *fw_name;
+	bool spdif_only;
 };
 
 struct fsl_xcvr {
@@ -261,6 +262,9 @@ static int fsl_xcvr_en_phy_pll(struct fsl_xcvr *xcvr, u32 freq, bool tx)
 	u32 i, div = 0, log2;
 	int ret;
 
+	if (xcvr->soc_data->spdif_only)
+		return 0;
+
 	for (i = 0; i < ARRAY_SIZE(fsl_xcvr_pll_cfg); i++) {
 		if (fsl_xcvr_pll_cfg[i].fout % freq == 0) {
 			div = fsl_xcvr_pll_cfg[i].fout / freq;
@@ -353,6 +357,7 @@ static int fsl_xcvr_en_aud_pll(struct fsl_xcvr *xcvr, u32 freq)
 	struct device *dev = &xcvr->pdev->dev;
 	int ret;
 
+	freq = xcvr->soc_data->spdif_only ? freq / 10 : freq;
 	clk_disable_unprepare(xcvr->phy_clk);
 	ret = clk_set_rate(xcvr->phy_clk, freq);
 	if (ret < 0) {
@@ -365,6 +370,8 @@ static int fsl_xcvr_en_aud_pll(struct fsl_xcvr *xcvr, u32 freq)
 		return ret;
 	}
 
+	if (xcvr->soc_data->spdif_only)
+		return 0;
 	/* Release AI interface from reset */
 	ret = regmap_write(xcvr->regmap, FSL_XCVR_PHY_AI_CTRL_SET,
 			   FSL_XCVR_PHY_AI_CTRL_AI_RESETN);
@@ -547,10 +554,12 @@ static int fsl_xcvr_startup(struct snd_pcm_substream *substream,
 
 	xcvr->streams |= BIT(substream->stream);
 
-	/* Disable XCVR controls if there is stream started */
-	fsl_xcvr_activate_ctl(dai, fsl_xcvr_mode_kctl.name, false);
-	fsl_xcvr_activate_ctl(dai, fsl_xcvr_arc_mode_kctl.name, false);
-	fsl_xcvr_activate_ctl(dai, fsl_xcvr_earc_capds_kctl.name, false);
+	if (!xcvr->soc_data->spdif_only) {
+		/* Disable XCVR controls if there is stream started */
+		fsl_xcvr_activate_ctl(dai, fsl_xcvr_mode_kctl.name, false);
+		fsl_xcvr_activate_ctl(dai, fsl_xcvr_arc_mode_kctl.name, false);
+		fsl_xcvr_activate_ctl(dai, fsl_xcvr_earc_capds_kctl.name, false);
+	}
 
 	return 0;
 }
@@ -567,12 +576,13 @@ static void fsl_xcvr_shutdown(struct snd_pcm_substream *substream,
 
 	/* Enable XCVR controls if there is no stream started */
 	if (!xcvr->streams) {
-		fsl_xcvr_activate_ctl(dai, fsl_xcvr_mode_kctl.name, true);
-		fsl_xcvr_activate_ctl(dai, fsl_xcvr_arc_mode_kctl.name,
-				      (xcvr->mode == FSL_XCVR_MODE_ARC));
-		fsl_xcvr_activate_ctl(dai, fsl_xcvr_earc_capds_kctl.name,
-				      (xcvr->mode == FSL_XCVR_MODE_EARC));
-
+		if (!xcvr->soc_data->spdif_only) {
+			fsl_xcvr_activate_ctl(dai, fsl_xcvr_mode_kctl.name, true);
+			fsl_xcvr_activate_ctl(dai, fsl_xcvr_arc_mode_kctl.name,
+						(xcvr->mode == FSL_XCVR_MODE_ARC));
+			fsl_xcvr_activate_ctl(dai, fsl_xcvr_earc_capds_kctl.name,
+						(xcvr->mode == FSL_XCVR_MODE_EARC));
+		}
 		ret = regmap_update_bits(xcvr->regmap, FSL_XCVR_EXT_IER0,
 					 FSL_XCVR_IRQ_EARC_ALL, 0);
 		if (ret < 0) {
@@ -673,7 +683,10 @@ static int fsl_xcvr_trigger(struct snd_pcm_substream *substream, int cmd,
 					dev_err(dai->dev, "Failed to stop DATA_TX: %d\n", ret);
 					return ret;
 				}
-				fallthrough;
+				if (xcvr->soc_data->spdif_only)
+					break;
+				else
+					fallthrough;
 			case FSL_XCVR_MODE_EARC:
 				/* clear ISR_CMDC_TX_EN, W1C */
 				ret = regmap_write(xcvr->regmap,
@@ -877,9 +890,13 @@ static int fsl_xcvr_dai_probe(struct snd_soc_dai *dai)
 
 	snd_soc_dai_init_dma_data(dai, &xcvr->dma_prms_tx, &xcvr->dma_prms_rx);
 
-	snd_soc_add_dai_controls(dai, &fsl_xcvr_mode_kctl, 1);
-	snd_soc_add_dai_controls(dai, &fsl_xcvr_arc_mode_kctl, 1);
-	snd_soc_add_dai_controls(dai, &fsl_xcvr_earc_capds_kctl, 1);
+	if (xcvr->soc_data->spdif_only)
+		xcvr->mode = FSL_XCVR_MODE_SPDIF;
+	else {
+		snd_soc_add_dai_controls(dai, &fsl_xcvr_mode_kctl, 1);
+		snd_soc_add_dai_controls(dai, &fsl_xcvr_arc_mode_kctl, 1);
+		snd_soc_add_dai_controls(dai, &fsl_xcvr_earc_capds_kctl, 1);
+	}
 	snd_soc_add_dai_controls(dai, fsl_xcvr_tx_ctls,
 				 ARRAY_SIZE(fsl_xcvr_tx_ctls));
 	snd_soc_add_dai_controls(dai, fsl_xcvr_rx_ctls,
@@ -929,10 +946,11 @@ static const struct reg_default fsl_xcvr_reg_defaults[] = {
 	{ FSL_XCVR_ISR_SET,	0x00000000 },
 	{ FSL_XCVR_ISR_CLR,	0x00000000 },
 	{ FSL_XCVR_ISR_TOG,	0x00000000 },
-	{ FSL_XCVR_RX_DPTH_CTRL,	0x00002C89 },
-	{ FSL_XCVR_RX_DPTH_CTRL_SET,	0x00002C89 },
-	{ FSL_XCVR_RX_DPTH_CTRL_CLR,	0x00002C89 },
-	{ FSL_XCVR_RX_DPTH_CTRL_TOG,	0x00002C89 },
+	{ FSL_XCVR_CLK_CTRL,	0x0000018F },
+	{ FSL_XCVR_RX_DPTH_CTRL,	0x00040CC1 },
+	{ FSL_XCVR_RX_DPTH_CTRL_SET,	0x00040CC1 },
+	{ FSL_XCVR_RX_DPTH_CTRL_CLR,	0x00040CC1 },
+	{ FSL_XCVR_RX_DPTH_CTRL_TOG,	0x00040CC1 },
 	{ FSL_XCVR_RX_DPTH_CNTR_CTRL,	0x00000000 },
 	{ FSL_XCVR_RX_DPTH_CNTR_CTRL_SET, 0x00000000 },
 	{ FSL_XCVR_RX_DPTH_CNTR_CTRL_CLR, 0x00000000 },
@@ -965,6 +983,12 @@ static const struct reg_default fsl_xcvr_reg_defaults[] = {
 
 static bool fsl_xcvr_readable_reg(struct device *dev, unsigned int reg)
 {
+	struct fsl_xcvr *xcvr = dev_get_drvdata(dev);
+
+	if (xcvr->soc_data->spdif_only)
+		if ((reg >= FSL_XCVR_IER && reg <= FSL_XCVR_PHY_AI_RDATA) ||
+		    reg > FSL_XCVR_TX_DPTH_BCRR)
+			return false;
 	switch (reg) {
 	case FSL_XCVR_VERSION:
 	case FSL_XCVR_EXT_CTRL:
@@ -990,6 +1014,12 @@ static bool fsl_xcvr_readable_reg(struct device *dev, unsigned int reg)
 	case FSL_XCVR_RX_DPTH_CTRL_SET:
 	case FSL_XCVR_RX_DPTH_CTRL_CLR:
 	case FSL_XCVR_RX_DPTH_CTRL_TOG:
+	case FSL_XCVR_RX_CS_DATA_0:
+	case FSL_XCVR_RX_CS_DATA_1:
+	case FSL_XCVR_RX_CS_DATA_2:
+	case FSL_XCVR_RX_CS_DATA_3:
+	case FSL_XCVR_RX_CS_DATA_4:
+	case FSL_XCVR_RX_CS_DATA_5:
 	case FSL_XCVR_RX_DPTH_CNTR_CTRL:
 	case FSL_XCVR_RX_DPTH_CNTR_CTRL_SET:
 	case FSL_XCVR_RX_DPTH_CNTR_CTRL_CLR:
@@ -1026,6 +1056,11 @@ static bool fsl_xcvr_readable_reg(struct device *dev, unsigned int reg)
 
 static bool fsl_xcvr_writeable_reg(struct device *dev, unsigned int reg)
 {
+	struct fsl_xcvr *xcvr = dev_get_drvdata(dev);
+
+	if (xcvr->soc_data->spdif_only)
+		if (reg >= FSL_XCVR_IER && reg <= FSL_XCVR_PHY_AI_RDATA)
+			return false;
 	switch (reg) {
 	case FSL_XCVR_EXT_CTRL:
 	case FSL_XCVR_EXT_IER0:
@@ -1102,32 +1137,34 @@ static irqreturn_t irq0_isr(int irq, void *devid)
 	if (isr & FSL_XCVR_IRQ_NEW_CS) {
 		dev_dbg(dev, "Received new CS block\n");
 		isr_clr |= FSL_XCVR_IRQ_NEW_CS;
-		/* Data RAM is 4KiB, last two pages: 8 and 9. Select page 8. */
-		regmap_update_bits(xcvr->regmap, FSL_XCVR_EXT_CTRL,
-				   FSL_XCVR_EXT_CTRL_PAGE_MASK,
-				   FSL_XCVR_EXT_CTRL_PAGE(8));
-
-		/* Find updated CS buffer */
-		reg_ctrl = xcvr->ram_addr + FSL_XCVR_RX_CS_CTRL_0;
-		reg_buff = xcvr->ram_addr + FSL_XCVR_RX_CS_BUFF_0;
-		memcpy_fromio(&val, reg_ctrl, sizeof(val));
-		if (!val) {
-			reg_ctrl = xcvr->ram_addr + FSL_XCVR_RX_CS_CTRL_1;
-			reg_buff = xcvr->ram_addr + FSL_XCVR_RX_CS_BUFF_1;
+		if (!xcvr->soc_data->spdif_only) {
+			/* Data RAM is 4KiB, last two pages: 8 and 9. Select page 8. */
+			regmap_update_bits(xcvr->regmap, FSL_XCVR_EXT_CTRL,
+					   FSL_XCVR_EXT_CTRL_PAGE_MASK,
+					   FSL_XCVR_EXT_CTRL_PAGE(8));
+
+			/* Find updated CS buffer */
+			reg_ctrl = xcvr->ram_addr + FSL_XCVR_RX_CS_CTRL_0;
+			reg_buff = xcvr->ram_addr + FSL_XCVR_RX_CS_BUFF_0;
 			memcpy_fromio(&val, reg_ctrl, sizeof(val));
-		}
+			if (!val) {
+				reg_ctrl = xcvr->ram_addr + FSL_XCVR_RX_CS_CTRL_1;
+				reg_buff = xcvr->ram_addr + FSL_XCVR_RX_CS_BUFF_1;
+				memcpy_fromio(&val, reg_ctrl, sizeof(val));
+			}
 
-		if (val) {
-			/* copy CS buffer */
-			memcpy_fromio(&xcvr->rx_iec958.status, reg_buff,
-				      sizeof(xcvr->rx_iec958.status));
-			for (i = 0; i < 6; i++) {
-				val = *(u32 *)(xcvr->rx_iec958.status + i*4);
-				*(u32 *)(xcvr->rx_iec958.status + i*4) =
-					bitrev32(val);
+			if (val) {
+				/* copy CS buffer */
+				memcpy_fromio(&xcvr->rx_iec958.status, reg_buff,
+					      sizeof(xcvr->rx_iec958.status));
+				for (i = 0; i < 6; i++) {
+					val = *(u32 *)(xcvr->rx_iec958.status + i*4);
+					*(u32 *)(xcvr->rx_iec958.status + i*4) =
+						bitrev32(val);
+				}
+				/* clear CS control register */
+				memset_io(reg_ctrl, 0, sizeof(val));
 			}
-			/* clear CS control register */
-			memset_io(reg_ctrl, 0, sizeof(val));
 		}
 	}
 	if (isr & FSL_XCVR_IRQ_NEW_UD) {
@@ -1167,8 +1204,13 @@ static const struct fsl_xcvr_soc_data fsl_xcvr_imx8mp_data = {
 	.fw_name = "imx/xcvr/xcvr-imx8mp.bin",
 };
 
+static const struct fsl_xcvr_soc_data fsl_xcvr_imx93_data = {
+	.spdif_only = true,
+};
+
 static const struct of_device_id fsl_xcvr_dt_ids[] = {
 	{ .compatible = "fsl,imx8mp-xcvr", .data = &fsl_xcvr_imx8mp_data },
+	{ .compatible = "fsl,imx93-xcvr", .data = &fsl_xcvr_imx93_data},
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, fsl_xcvr_dt_ids);
@@ -1228,7 +1270,7 @@ static int fsl_xcvr_probe(struct platform_device *pdev)
 		return PTR_ERR(xcvr->regmap);
 	}
 
-	xcvr->reset = devm_reset_control_get_exclusive(dev, NULL);
+	xcvr->reset = devm_reset_control_get_optional_exclusive(dev, NULL);
 	if (IS_ERR(xcvr->reset)) {
 		dev_err(dev, "failed to get XCVR reset control\n");
 		return PTR_ERR(xcvr->reset);
@@ -1297,12 +1339,14 @@ static __maybe_unused int fsl_xcvr_runtime_suspend(struct device *dev)
 	if (ret < 0)
 		dev_err(dev, "Failed to clear IER0: %d\n", ret);
 
-	/* Assert M0+ reset */
-	ret = regmap_update_bits(xcvr->regmap, FSL_XCVR_EXT_CTRL,
-				 FSL_XCVR_EXT_CTRL_CORE_RESET,
-				 FSL_XCVR_EXT_CTRL_CORE_RESET);
-	if (ret < 0)
-		dev_err(dev, "Failed to assert M0+ core: %d\n", ret);
+	if (!xcvr->soc_data->spdif_only) {
+		/* Assert M0+ reset */
+		ret = regmap_update_bits(xcvr->regmap, FSL_XCVR_EXT_CTRL,
+					FSL_XCVR_EXT_CTRL_CORE_RESET,
+					FSL_XCVR_EXT_CTRL_CORE_RESET);
+		if (ret < 0)
+			dev_err(dev, "Failed to assert M0+ core: %d\n", ret);
+	}
 
 	regcache_cache_only(xcvr->regmap, true);
 
@@ -1358,6 +1402,9 @@ static __maybe_unused int fsl_xcvr_runtime_resume(struct device *dev)
 		goto stop_spba_clk;
 	}
 
+	if (xcvr->soc_data->spdif_only)
+		return 0;
+
 	ret = reset_control_deassert(xcvr->reset);
 	if (ret) {
 		dev_err(dev, "failed to deassert M0+ reset.\n");
diff --git a/sound/soc/fsl/fsl_xcvr.h b/sound/soc/fsl/fsl_xcvr.h
index 4769b0fca21de..044058fc6aa24 100644
--- a/sound/soc/fsl/fsl_xcvr.h
+++ b/sound/soc/fsl/fsl_xcvr.h
@@ -49,6 +49,13 @@
 #define FSL_XCVR_RX_DPTH_CTRL_CLR	0x188
 #define FSL_XCVR_RX_DPTH_CTRL_TOG	0x18c
 
+#define FSL_XCVR_RX_CS_DATA_0		0x190
+#define FSL_XCVR_RX_CS_DATA_1		0x194
+#define FSL_XCVR_RX_CS_DATA_2		0x198
+#define FSL_XCVR_RX_CS_DATA_3		0x19C
+#define FSL_XCVR_RX_CS_DATA_4		0x1A0
+#define FSL_XCVR_RX_CS_DATA_5		0x1A4
+
 #define FSL_XCVR_RX_DPTH_CNTR_CTRL	0x1C0
 #define FSL_XCVR_RX_DPTH_CNTR_CTRL_SET	0x1C4
 #define FSL_XCVR_RX_DPTH_CNTR_CTRL_CLR	0x1C8
-- 
2.51.0



