Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84D834889F;
	Tue, 16 Jun 2026 15:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624306; cv=none; b=DaM4Dsbu9Ci1qZuuK6DvdVe71WxjwlKOr7/GUNDpS0ncfX1Iopwr3Zzmuulf4sfy75m3wy564L804JJ1Z/Y9vfzL47c+P3uW7h5RBdYMu0dB6q5ROBq3v5Xz7Ll9B3D/izUSokg5uzUeHqLOC0mU7gOMFaJX0HzzjiosZiQ3wyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624306; c=relaxed/simple;
	bh=lag4pSLh0H+JuFdEhe+7MAtTOLMrarH9xbRTR7WxELQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVEt2FZ1pOauW9YTH1H0EVjIqPISU67UbirpnvGw4LwfBuxEyu7s3r3ZnHJnGBg+Bp6guIRNFfDrtwnFEQdJTPQkSIHPVj0BwTQD2skimjNFnqStiParTDSBBkAyse91vcKhKOty4iGw2BrY/ifQfis7TLWga5dj2wO/pkskmaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfdX6Lxm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfdX6Lxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8160D1F000E9;
	Tue, 16 Jun 2026 15:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624304;
	bh=55E7az65Dhx8cXETbsvF+F1biIVO07rbebvigVmUYrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MfdX6LxmKFpX8X70MHoKTe1GOTfEbt/XA8jA/JM1MSJ9BfXw3ylaTIVLS4mqZCsC8
	 ejz77vNMq31znktMXaKAovBQpMCg8IrQKsx9bl3NzXIVtaRvn1JlToGGwSiRQJUO6q
	 HJSfOfsnfGUCHmT2ay+FogMbslSuiWFnSqbVllOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huan He <hehuan1@eswincomputing.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.0 311/378] mmc: sdhci-of-dwcmshc: Fix reset, clk, and SDIO support for Eswin EIC7700
Date: Tue, 16 Jun 2026 20:29:02 +0530
Message-ID: <20260616145126.588668097@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huan He <hehuan1@eswincomputing.com>

commit 8d4ae34e997062076a9098602eaca43353665bd9 upstream.

The EIC7700 code in sdhci-of-dwcmshc uses host->mmc->caps2 to select
different configuration paths for different card types. The current logic
distinguishes eMMC and SD, but does not handle SDIO separately.

Update the EIC7700 card-type checks so that eMMC, SD and SDIO are
distinguished explicitly.

Switch the reset path to dwcmshc_reset() so that pending interrupt state
is cleared consistently, and use sdhci_enable_clk() so the clock enable
sequence follows the standard SDHCI flow.

Fixes: 32b2633219d3 ("mmc: sdhci-of-dwcmshc: Add support for Eswin EIC7700")
Signed-off-by: Huan He <hehuan1@eswincomputing.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c |   44 ++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -251,6 +251,7 @@
 #define PHY_DELAY_CODE_MAX		0x7f
 #define PHY_DELAY_CODE_EMMC		0x17
 #define PHY_DELAY_CODE_SD		0x55
+#define PHY_DELAY_CODE_SDIO		0x29
 
 enum dwcmshc_rk_type {
 	DWCMSHC_RK3568,
@@ -1273,10 +1274,7 @@ static void sdhci_eic7700_set_clock(stru
 	clk_set_rate(pltfm_host->clk, clock);
 
 	clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
-	clk |= SDHCI_CLOCK_INT_EN;
-	sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
-
-	dwcmshc_enable_card_clk(host);
+	sdhci_enable_clk(host, clk);
 }
 
 static void sdhci_eic7700_config_phy_delay(struct sdhci_host *host, int delay)
@@ -1337,7 +1335,7 @@ static void sdhci_eic7700_config_phy(str
 
 static void sdhci_eic7700_reset(struct sdhci_host *host, u8 mask)
 {
-	sdhci_reset(host, mask);
+	dwcmshc_reset(host, mask);
 
 	/* after reset all, the phy's config will be clear */
 	if (mask == SDHCI_RESET_ALL)
@@ -1434,18 +1432,17 @@ static int sdhci_eic7700_phase_code_tuni
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct dwcmshc_priv *priv = sdhci_pltfm_priv(pltfm_host);
-	u32 sd_caps = MMC_CAP2_NO_MMC | MMC_CAP2_NO_SDIO;
+	u32 emmc_caps = MMC_CAP2_NO_SD | MMC_CAP2_NO_SDIO;
 	int phase_code = -1;
 	int code_range = -1;
-	bool is_sd = false;
 	int code_min = -1;
 	int code_max = -1;
 	int cmd_error = 0;
+	bool is_emmc;
 	int ret = 0;
 	int i = 0;
 
-	if ((host->mmc->caps2 & sd_caps) == sd_caps)
-		is_sd = true;
+	is_emmc = (host->mmc->caps2 & emmc_caps) == emmc_caps;
 
 	for (i = 0; i <= MAX_PHASE_CODE; i++) {
 		/* Centered Phase code */
@@ -1454,8 +1451,8 @@ static int sdhci_eic7700_phase_code_tuni
 		host->ops->reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
 
 		if (ret) {
-			/* SD specific range tracking */
-			if (is_sd && code_min != -1 && code_max != -1) {
+			/* SD/SDIO specific range tracking */
+			if (!is_emmc && code_min != -1 && code_max != -1) {
 				if (code_max - code_min > code_range) {
 					code_range = code_max - code_min;
 					phase_code = (code_min + code_max) / 2;
@@ -1466,17 +1463,17 @@ static int sdhci_eic7700_phase_code_tuni
 				code_max = -1;
 			}
 			/* EMMC breaks after first valid range */
-			if (!is_sd && code_min != -1 && code_max != -1)
+			if (is_emmc && code_min != -1 && code_max != -1)
 				break;
 		} else {
 			/* Track valid phase code range */
 			if (code_min == -1) {
 				code_min = i;
-				if (!is_sd)
+				if (is_emmc)
 					continue;
 			}
 			code_max = i;
-			if (is_sd && i == MAX_PHASE_CODE) {
+			if (!is_emmc && i == MAX_PHASE_CODE) {
 				if (code_max - code_min > code_range) {
 					code_range = code_max - code_min;
 					phase_code = (code_min + code_max) / 2;
@@ -1486,19 +1483,19 @@ static int sdhci_eic7700_phase_code_tuni
 	}
 
 	/* Handle tuning failure case */
-	if ((is_sd && phase_code == -1) ||
-	    (!is_sd && code_min == -1 && code_max == -1)) {
+	if ((!is_emmc && phase_code == -1) ||
+	    (is_emmc && code_min == -1 && code_max == -1)) {
 		pr_err("%s: phase code tuning failed!\n", mmc_hostname(host->mmc));
 		sdhci_writew(host, 0, priv->vendor_specific_area1 + DWCMSHC_AT_STAT);
 		return -EIO;
 	}
-	if (!is_sd)
+	if (is_emmc)
 		phase_code = (code_min + code_max) / 2;
 
 	sdhci_writew(host, phase_code, priv->vendor_specific_area1 + DWCMSHC_AT_STAT);
 
-	/* SD specific final verification */
-	if (is_sd) {
+	/* SD/SDIO specific final verification */
+	if (!is_emmc) {
 		ret = mmc_send_tuning(host->mmc, opcode, &cmd_error);
 		host->ops->reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
 		if (ret) {
@@ -1596,9 +1593,9 @@ static void sdhci_eic7700_set_uhs_signal
 
 static void sdhci_eic7700_set_uhs_wrapper(struct sdhci_host *host, unsigned int timing)
 {
-	u32 sd_caps = MMC_CAP2_NO_MMC | MMC_CAP2_NO_SDIO;
+	u32 emmc_caps = MMC_CAP2_NO_SD | MMC_CAP2_NO_SDIO;
 
-	if ((host->mmc->caps2 & sd_caps) == sd_caps)
+	if ((host->mmc->caps2 & emmc_caps) != emmc_caps)
 		sdhci_set_uhs_signaling(host, timing);
 	else
 		sdhci_eic7700_set_uhs_signaling(host, timing);
@@ -1607,6 +1604,7 @@ static void sdhci_eic7700_set_uhs_wrappe
 static int eic7700_init(struct device *dev, struct sdhci_host *host, struct dwcmshc_priv *dwc_priv)
 {
 	u32 emmc_caps = MMC_CAP2_NO_SD | MMC_CAP2_NO_SDIO;
+	u32 sd_caps = MMC_CAP2_NO_MMC | MMC_CAP2_NO_SDIO;
 	unsigned int val, hsp_int_status, hsp_pwr_ctrl;
 	static const char * const clk_ids[] = {"axi"};
 	struct of_phandle_args args;
@@ -1661,8 +1659,10 @@ static int eic7700_init(struct device *d
 
 	if ((host->mmc->caps2 & emmc_caps) == emmc_caps)
 		dwc_priv->delay_line = PHY_DELAY_CODE_EMMC;
-	else
+	else if ((host->mmc->caps2 & sd_caps) == sd_caps)
 		dwc_priv->delay_line = PHY_DELAY_CODE_SD;
+	else
+		dwc_priv->delay_line = PHY_DELAY_CODE_SDIO;
 
 	if (!of_property_read_u32(dev->of_node, "eswin,drive-impedance-ohms", &val))
 		priv->drive_impedance = eic7700_convert_drive_impedance_ohm(dev, val);


