Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26550238C09;
	Mon,  2 Jun 2025 15:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876817; cv=none; b=RylRE9SmzjDnC9IFYlX8OwffmI5FZpUhma/YmieqkufNpOeqSgffyWN2Q2baxsERgmI41RhoZgaOA0OXJPKZquvn/HtUHj5IiN4Xa8Lik19WTdcGMbyABhiFw6Ijto3B5eUxglcRSEHQHeeFMc0qxvLzYZ4ZVWVxxreXMehd8PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876817; c=relaxed/simple;
	bh=TGzt59R7FUu/hK5Ogc+cc4Xlo3n4ggmeklJFeAFJQgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ov4h8iyWfatpEHRxcecAUZT6QZAyDCjAOZVPGZdw2tp85e/SKyJR+5AOiiwRQ6pV+wNVHaeFSHEGKTTC7K7+/xd+LtC4ZbWsB1CHHvAaeS7yXS5TsF6xJLxva61kIwuj6OgPHckGwluGh1dE35IAp2AGI+8vcOlX2OMRD1Jdm1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEVVqXy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEVVqXy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB29C4CEEB;
	Mon,  2 Jun 2025 15:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876817;
	bh=TGzt59R7FUu/hK5Ogc+cc4Xlo3n4ggmeklJFeAFJQgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEVVqXy+py/C3GO6V7DSTfFQ19Az8FMMOTVr0Ce4VZj7t3KvqKB6NVCLTPCrzEnvp
	 2Hga3lKEs4E1GWtRgTG+uNbq6YswcOOtc0zF844idw6A7frLB06ykuM3RBwqvx5IGI
	 9u2zeSBS9YRCuBNcuNRO/aG0nZKV0d5XBXyQJsFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/325] mmc: dw_mmc: add exynos7870 DW MMC support
Date: Mon,  2 Jun 2025 15:46:00 +0200
Message-ID: <20250602134323.196446534@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

From: Kaustabh Chakraborty <kauschluss@disroot.org>

[ Upstream commit 7cbe799ac10fd8be85af5e0615c4337f81e575f3 ]

Add support for Exynos7870 DW MMC controllers, for both SMU and non-SMU
variants. These controllers require a quirk to access 64-bit FIFO in 32-bit
accesses (DW_MMC_QUIRK_FIFO64_32).

Signed-off-by: Kaustabh Chakraborty <kauschluss@disroot.org>
Link: https://lore.kernel.org/r/20250219-exynos7870-mmc-v2-3-b4255a3e39ed@disroot.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/dw_mmc-exynos.c | 41 +++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
index 9f20ac524c8b8..2a5c3c822f6af 100644
--- a/drivers/mmc/host/dw_mmc-exynos.c
+++ b/drivers/mmc/host/dw_mmc-exynos.c
@@ -28,6 +28,8 @@ enum dw_mci_exynos_type {
 	DW_MCI_TYPE_EXYNOS5420_SMU,
 	DW_MCI_TYPE_EXYNOS7,
 	DW_MCI_TYPE_EXYNOS7_SMU,
+	DW_MCI_TYPE_EXYNOS7870,
+	DW_MCI_TYPE_EXYNOS7870_SMU,
 	DW_MCI_TYPE_ARTPEC8,
 };
 
@@ -70,6 +72,12 @@ static struct dw_mci_exynos_compatible {
 	}, {
 		.compatible	= "samsung,exynos7-dw-mshc-smu",
 		.ctrl_type	= DW_MCI_TYPE_EXYNOS7_SMU,
+	}, {
+		.compatible	= "samsung,exynos7870-dw-mshc",
+		.ctrl_type	= DW_MCI_TYPE_EXYNOS7870,
+	}, {
+		.compatible	= "samsung,exynos7870-dw-mshc-smu",
+		.ctrl_type	= DW_MCI_TYPE_EXYNOS7870_SMU,
 	}, {
 		.compatible	= "axis,artpec8-dw-mshc",
 		.ctrl_type	= DW_MCI_TYPE_ARTPEC8,
@@ -86,6 +94,8 @@ static inline u8 dw_mci_exynos_get_ciu_div(struct dw_mci *host)
 		return EXYNOS4210_FIXED_CIU_CLK_DIV;
 	else if (priv->ctrl_type == DW_MCI_TYPE_EXYNOS7 ||
 			priv->ctrl_type == DW_MCI_TYPE_EXYNOS7_SMU ||
+			priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870 ||
+			priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870_SMU ||
 			priv->ctrl_type == DW_MCI_TYPE_ARTPEC8)
 		return SDMMC_CLKSEL_GET_DIV(mci_readl(host, CLKSEL64)) + 1;
 	else
@@ -101,7 +111,8 @@ static void dw_mci_exynos_config_smu(struct dw_mci *host)
 	 * set for non-ecryption mode at this time.
 	 */
 	if (priv->ctrl_type == DW_MCI_TYPE_EXYNOS5420_SMU ||
-		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7_SMU) {
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7_SMU ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870_SMU) {
 		mci_writel(host, MPSBEGIN0, 0);
 		mci_writel(host, MPSEND0, SDMMC_ENDING_SEC_NR_MAX);
 		mci_writel(host, MPSCTRL0, SDMMC_MPSCTRL_SECURE_WRITE_BIT |
@@ -127,6 +138,12 @@ static int dw_mci_exynos_priv_init(struct dw_mci *host)
 				DQS_CTRL_GET_RD_DELAY(priv->saved_strobe_ctrl);
 	}
 
+	if (priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870 ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870_SMU) {
+		/* Quirk needed for certain Exynos SoCs */
+		host->quirks |= DW_MMC_QUIRK_FIFO64_32;
+	}
+
 	if (priv->ctrl_type == DW_MCI_TYPE_ARTPEC8) {
 		/* Quirk needed for the ARTPEC-8 SoC */
 		host->quirks |= DW_MMC_QUIRK_EXTENDED_TMOUT;
@@ -144,6 +161,8 @@ static void dw_mci_exynos_set_clksel_timing(struct dw_mci *host, u32 timing)
 
 	if (priv->ctrl_type == DW_MCI_TYPE_EXYNOS7 ||
 		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7_SMU ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870 ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870_SMU ||
 		priv->ctrl_type == DW_MCI_TYPE_ARTPEC8)
 		clksel = mci_readl(host, CLKSEL64);
 	else
@@ -153,6 +172,8 @@ static void dw_mci_exynos_set_clksel_timing(struct dw_mci *host, u32 timing)
 
 	if (priv->ctrl_type == DW_MCI_TYPE_EXYNOS7 ||
 		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7_SMU ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870 ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870_SMU ||
 		priv->ctrl_type == DW_MCI_TYPE_ARTPEC8)
 		mci_writel(host, CLKSEL64, clksel);
 	else
@@ -223,6 +244,8 @@ static int dw_mci_exynos_resume_noirq(struct device *dev)
 
 	if (priv->ctrl_type == DW_MCI_TYPE_EXYNOS7 ||
 		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7_SMU ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870 ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870_SMU ||
 		priv->ctrl_type == DW_MCI_TYPE_ARTPEC8)
 		clksel = mci_readl(host, CLKSEL64);
 	else
@@ -231,6 +254,8 @@ static int dw_mci_exynos_resume_noirq(struct device *dev)
 	if (clksel & SDMMC_CLKSEL_WAKEUP_INT) {
 		if (priv->ctrl_type == DW_MCI_TYPE_EXYNOS7 ||
 			priv->ctrl_type == DW_MCI_TYPE_EXYNOS7_SMU ||
+			priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870 ||
+			priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870_SMU ||
 			priv->ctrl_type == DW_MCI_TYPE_ARTPEC8)
 			mci_writel(host, CLKSEL64, clksel);
 		else
@@ -410,6 +435,8 @@ static inline u8 dw_mci_exynos_get_clksmpl(struct dw_mci *host)
 
 	if (priv->ctrl_type == DW_MCI_TYPE_EXYNOS7 ||
 		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7_SMU ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870 ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870_SMU ||
 		priv->ctrl_type == DW_MCI_TYPE_ARTPEC8)
 		return SDMMC_CLKSEL_CCLK_SAMPLE(mci_readl(host, CLKSEL64));
 	else
@@ -423,6 +450,8 @@ static inline void dw_mci_exynos_set_clksmpl(struct dw_mci *host, u8 sample)
 
 	if (priv->ctrl_type == DW_MCI_TYPE_EXYNOS7 ||
 		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7_SMU ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870 ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870_SMU ||
 		priv->ctrl_type == DW_MCI_TYPE_ARTPEC8)
 		clksel = mci_readl(host, CLKSEL64);
 	else
@@ -430,6 +459,8 @@ static inline void dw_mci_exynos_set_clksmpl(struct dw_mci *host, u8 sample)
 	clksel = SDMMC_CLKSEL_UP_SAMPLE(clksel, sample);
 	if (priv->ctrl_type == DW_MCI_TYPE_EXYNOS7 ||
 		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7_SMU ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870 ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870_SMU ||
 		priv->ctrl_type == DW_MCI_TYPE_ARTPEC8)
 		mci_writel(host, CLKSEL64, clksel);
 	else
@@ -444,6 +475,8 @@ static inline u8 dw_mci_exynos_move_next_clksmpl(struct dw_mci *host)
 
 	if (priv->ctrl_type == DW_MCI_TYPE_EXYNOS7 ||
 		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7_SMU ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870 ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870_SMU ||
 		priv->ctrl_type == DW_MCI_TYPE_ARTPEC8)
 		clksel = mci_readl(host, CLKSEL64);
 	else
@@ -454,6 +487,8 @@ static inline u8 dw_mci_exynos_move_next_clksmpl(struct dw_mci *host)
 
 	if (priv->ctrl_type == DW_MCI_TYPE_EXYNOS7 ||
 		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7_SMU ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870 ||
+		priv->ctrl_type == DW_MCI_TYPE_EXYNOS7870_SMU ||
 		priv->ctrl_type == DW_MCI_TYPE_ARTPEC8)
 		mci_writel(host, CLKSEL64, clksel);
 	else
@@ -633,6 +668,10 @@ static const struct of_device_id dw_mci_exynos_match[] = {
 			.data = &exynos_drv_data, },
 	{ .compatible = "samsung,exynos7-dw-mshc-smu",
 			.data = &exynos_drv_data, },
+	{ .compatible = "samsung,exynos7870-dw-mshc",
+			.data = &exynos_drv_data, },
+	{ .compatible = "samsung,exynos7870-dw-mshc-smu",
+			.data = &exynos_drv_data, },
 	{ .compatible = "axis,artpec8-dw-mshc",
 			.data = &artpec_drv_data, },
 	{},
-- 
2.39.5



