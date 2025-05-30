Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A3D265CC0;
	Fri, 30 May 2025 12:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608858; cv=none; b=jqaJOJ/ijnxmIGH/sGFYsWV7PNDEhJR+d+cKGMHPNUnM0kTD2tB/aKAVogvXl8lpZpSPSBlaxmUddqu8ZUuv/kmSBCv1j2C2XrbsgU3WIFx/oc5f4CajgHSNioN95iOgejUuiwzWcF7vtTyPj50otH8YkKV/hkrFYBsX88GbaX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608858; c=relaxed/simple;
	bh=UD+5TLB2bz4d2xUkoAyU+8q0CipzLr4x2rwxkiGKeyk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aMLRK9FYl9mI6N+ap2q5IC5HE1EOsuWawWBQxNP52SHT8aUipyQVCT817r8yODgNK1bArXgUPjsUmhAzRVWSuppSkuOKCN8dJKvJeTFV1zLd+wAkWuhHc3rLLarx6jlZDDdAoO45aDWNCI9S78mxLI1e372G1uhkylsmJgGO/F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qlLH3YOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qlLH3YOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE49FC4CEE9;
	Fri, 30 May 2025 12:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608858;
	bh=UD+5TLB2bz4d2xUkoAyU+8q0CipzLr4x2rwxkiGKeyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qlLH3YOnKGEb1XBki6M+VUxudpjrHwBKbnjSyHsjxQOww6YVHwprMPM06CzIu2B1v
	 yfHDRLcfjnWGT2ElwYBbLCS7i+VXjBgY5YnGvNK3/YrxjMLaUvHkRI9MUp97lDpGJt
	 X03+3nsH6gGOFT28eZpTz34hx7Pa61xCWG6ieBOIUcXxc/LzkKeEaLfO6yPwggmkQB
	 NoHTlJlqBUB6s2r4KgbOOyY+wl+AzHQprOhK8fqD5RViC27j7u78klf/dpG8i0djI2
	 EajNBAdm7Aj5XuTdNdoTqSN3Bs2kzoXjNHJUroMHdaBYbjNIWgrfi+oWHgyWIqzddx
	 KyoJpKp62Qneg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Luke Wang <ziniu.wang_1@nxp.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	shawnguo@kernel.org,
	linux-mmc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 08/18] mmc: sdhci-esdhc-imx: Save tuning value when card stays powered in suspend
Date: Fri, 30 May 2025 08:40:37 -0400
Message-Id: <20250530124047.2575954-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530124047.2575954-1-sashal@kernel.org>
References: <20250530124047.2575954-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.92
Content-Transfer-Encoding: 8bit

From: Luke Wang <ziniu.wang_1@nxp.com>

[ Upstream commit c63d25cdc59ae2891b39ba2da950910291d9bcbf ]

For SoCs like i.MX6UL(L/Z) and i.MX7D, USDHC powers off completely during
system power management (PM), causing the internal tuning status to be
lost. To address this, save the tuning value when system suspend and
restore it for any command issued after system resume when re-tuning is
held.

A typical case involves SDIO WiFi devices with the MMC_PM_KEEP_POWER and
MMC_PM_WAKE_SDIO_IRQ flag, which retain power during system PM. To
conserve power, WiFi switches to 1-bit mode and restores 4-bit mode upon
resume. As per the specification, tuning commands are not supported in
1-bit mode. When sending CMD52 to restore 4-bit mode, re-tuning must be
held. However, CMD52 still requires a correct sample point to avoid CRC
errors, necessitating preservation of the previous tuning value.

Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250328112517.2624806-1-ziniu.wang_1@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the commit message, code changes, and
examination of the kernel repository, here is my assessment: **YES**
This commit should be backported to stable kernel trees. **Extensive
Analysis:** **1. Bug Fix Nature:** This commit fixes a specific bug
affecting SDIO WiFi devices on i.MX6UL(L/Z) and i.MX7D SoCs during
system suspend/resume cycles. The problem occurs when: - SDIO devices
maintain power during suspend (MMC_PM_KEEP_POWER) - USDHC hardware
completely loses power despite software flags - Tuning values are lost,
causing CRC errors on resume - This affects real-world WiFi
functionality **2. Code Analysis - Key Changes:** The commit adds three
main components: a) **Data Structure Addition** (line ~241): ```c
unsigned int saved_tuning_delay_cell; /bin /bin.usr-is-merged /boot /dev
/etc /home /init /lib /lib.usr-is-merged /lib64 /lost+found /media /mnt
/opt /proc /root /run /sbin /sbin.usr-is-merged /snap /srv /sys /tmp
/usr /var save the value of tuning delay cell model/ prompt/ src/
target/ ``` This adds storage for the tuning value in the platform data
structure. b) **Tuning Save Function** (`sdhc_esdhc_tuning_save`): ```c
if (host->timing == MMC_TIMING_UHS_SDR50 || host->timing ==
MMC_TIMING_UHS_SDR104) { reg = readl(host->ioaddr +
ESDHC_TUNE_CTRL_STATUS); reg =
FIELD_GET(ESDHC_TUNE_CTRL_STATUS_TAP_SEL_PRE_MASK, reg);
imx_data->boarddata.saved_tuning_delay_cell = reg; } ``` This safely
reads and stores the current tuning delay value for modes that require
tuning. c) **Tuning Restore Function** (`sdhc_esdhc_tuning_restore`):
```c reg = readl(host->ioaddr + ESDHC_TUNING_CTRL); reg &=
~ESDHC_STD_TUNING_EN; writel(reg, host->ioaddr + ESDHC_TUNING_CTRL); reg
= readl(host->ioaddr + ESDHC_MIX_CTRL); reg |= ESDHC_MIX_CTRL_SMPCLK_SEL
| ESDHC_MIX_CTRL_FBCLK_SEL; writel(reg, host->ioaddr + ESDHC_MIX_CTRL);
writel(FIELD_PREP(ESDHC_TUNE_CTRL_STATUS_DLY_CELL_SET_PRE_MASK,
imx_data->boarddata.saved_tuning_delay_cell), host->ioaddr +
ESDHC_TUNE_CTRL_STATUS); ``` This carefully restores the tuning value by
manually configuring the hardware registers. **3. Risk Assessment - Very
Low Risk:** - **Conditional Execution**: Both save/restore functions
only execute when specific conditions are met: -
`mmc_card_keep_power(host->mmc)` AND `mmc_card_wake_sdio_irq(host->mmc)`
AND `esdhc_is_usdhc(imx_data)` - Only affects SDR50/SDR104 timing modes
- Only targets specific SoC families (i.MX6UL(L/Z), i.MX7D) - **Register
Manipulation Safety**: The code uses proper field masking (`FIELD_GET`,
`FIELD_PREP`) and follows existing patterns in the driver - **No
Architectural Changes**: This is purely a state preservation mechanism,
doesn't change driver architecture **4. Comparison with Similar
Commits:** Looking at the reference commits: - **Similar Commit #4
(YES)**: Also fixes SDIO suspend/resume tuning issues with
`mmc_retune_hold_now()` - **Similar Commit #5 (YES)**: Also addresses
tuning-related problems by disabling CMD CRC checks This new commit
follows the same pattern of fixing specific SDIO tuning issues with
targeted, low-risk changes. **5. Hardware-Specific Nature:** The fix
targets specific hardware (i.MX SoCs) where USDHC loses power despite
software flags. This hardware-specific bug affects real users with SDIO
WiFi cards and has a clear, contained solution. **6. Clear Problem
Statement:** The commit message clearly describes the problem: "CMD52
still requires a correct sample point to avoid CRC errors, necessitating
preservation of the previous tuning value." This is a well-defined
technical issue with a specific solution. **Conclusion:** This is a
contained, hardware-specific bug fix that addresses real-world WiFi
functionality issues on specific i.MX SoCs. The changes are
conservative, well-guarded by conditions, and follow established
patterns in the subsystem. The risk of regression is very low while the
benefit to affected users is significant.

 drivers/mmc/host/sdhci-esdhc-imx.c | 88 +++++++++++++++++++++++++++++-
 1 file changed, 86 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index e4e9b84f210b2..28ece6839aead 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -80,6 +80,8 @@
 #define  ESDHC_TUNE_CTRL_STEP		1
 #define  ESDHC_TUNE_CTRL_MIN		0
 #define  ESDHC_TUNE_CTRL_MAX		((1 << 7) - 1)
+#define  ESDHC_TUNE_CTRL_STATUS_TAP_SEL_PRE_MASK	GENMASK(30, 24)
+#define  ESDHC_TUNE_CTRL_STATUS_DLY_CELL_SET_PRE_MASK	GENMASK(14, 8)
 
 /* strobe dll register */
 #define ESDHC_STROBE_DLL_CTRL		0x70
@@ -231,6 +233,7 @@ struct esdhc_platform_data {
 	unsigned int tuning_step;       /* The delay cell steps in tuning procedure */
 	unsigned int tuning_start_tap;	/* The start delay cell point in tuning procedure */
 	unsigned int strobe_dll_delay_target;	/* The delay cell for strobe pad (read clock) */
+	unsigned int saved_tuning_delay_cell;	/* save the value of tuning delay cell */
 };
 
 struct esdhc_soc_data {
@@ -1052,7 +1055,7 @@ static void esdhc_reset_tuning(struct sdhci_host *host)
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
-	u32 ctrl;
+	u32 ctrl, tuning_ctrl;
 	int ret;
 
 	/* Reset the tuning circuit */
@@ -1066,6 +1069,16 @@ static void esdhc_reset_tuning(struct sdhci_host *host)
 			writel(0, host->ioaddr + ESDHC_TUNE_CTRL_STATUS);
 		} else if (imx_data->socdata->flags & ESDHC_FLAG_STD_TUNING) {
 			writel(ctrl, host->ioaddr + ESDHC_MIX_CTRL);
+			/*
+			 * enable the std tuning just in case it cleared in
+			 * sdhc_esdhc_tuning_restore.
+			 */
+			tuning_ctrl = readl(host->ioaddr + ESDHC_TUNING_CTRL);
+			if (!(tuning_ctrl & ESDHC_STD_TUNING_EN)) {
+				tuning_ctrl |= ESDHC_STD_TUNING_EN;
+				writel(tuning_ctrl, host->ioaddr + ESDHC_TUNING_CTRL);
+			}
+
 			ctrl = readl(host->ioaddr + SDHCI_AUTO_CMD_STATUS);
 			ctrl &= ~ESDHC_MIX_CTRL_SMPCLK_SEL;
 			ctrl &= ~ESDHC_MIX_CTRL_EXE_TUNE;
@@ -1144,7 +1157,8 @@ static void esdhc_prepare_tuning(struct sdhci_host *host, u32 val)
 	reg |= ESDHC_MIX_CTRL_EXE_TUNE | ESDHC_MIX_CTRL_SMPCLK_SEL |
 			ESDHC_MIX_CTRL_FBCLK_SEL;
 	writel(reg, host->ioaddr + ESDHC_MIX_CTRL);
-	writel(val << 8, host->ioaddr + ESDHC_TUNE_CTRL_STATUS);
+	writel(FIELD_PREP(ESDHC_TUNE_CTRL_STATUS_DLY_CELL_SET_PRE_MASK, val),
+	       host->ioaddr + ESDHC_TUNE_CTRL_STATUS);
 	dev_dbg(mmc_dev(host->mmc),
 		"tuning with delay 0x%x ESDHC_TUNE_CTRL_STATUS 0x%x\n",
 			val, readl(host->ioaddr + ESDHC_TUNE_CTRL_STATUS));
@@ -1532,6 +1546,57 @@ static void sdhci_esdhc_imx_hwinit(struct sdhci_host *host)
 	}
 }
 
+static void sdhc_esdhc_tuning_save(struct sdhci_host *host)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
+	u32 reg;
+
+	/*
+	 * SD/eMMC do not need this tuning save because it will re-init
+	 * after system resume back.
+	 * Here save the tuning delay value for SDIO device since it may
+	 * keep power during system PM. And for usdhc, only SDR50 and
+	 * SDR104 mode for SDIO device need to do tuning, and need to
+	 * save/restore.
+	 */
+	if (host->timing == MMC_TIMING_UHS_SDR50 ||
+	    host->timing == MMC_TIMING_UHS_SDR104) {
+		reg = readl(host->ioaddr + ESDHC_TUNE_CTRL_STATUS);
+		reg = FIELD_GET(ESDHC_TUNE_CTRL_STATUS_TAP_SEL_PRE_MASK, reg);
+		imx_data->boarddata.saved_tuning_delay_cell = reg;
+	}
+}
+
+static void sdhc_esdhc_tuning_restore(struct sdhci_host *host)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
+	u32 reg;
+
+	if (host->timing == MMC_TIMING_UHS_SDR50 ||
+	    host->timing == MMC_TIMING_UHS_SDR104) {
+		/*
+		 * restore the tuning delay value actually is a
+		 * manual tuning method, so clear the standard
+		 * tuning enable bit here. Will set back this
+		 * ESDHC_STD_TUNING_EN in esdhc_reset_tuning()
+		 * when trigger re-tuning.
+		 */
+		reg = readl(host->ioaddr + ESDHC_TUNING_CTRL);
+		reg &= ~ESDHC_STD_TUNING_EN;
+		writel(reg, host->ioaddr + ESDHC_TUNING_CTRL);
+
+		reg = readl(host->ioaddr + ESDHC_MIX_CTRL);
+		reg |= ESDHC_MIX_CTRL_SMPCLK_SEL | ESDHC_MIX_CTRL_FBCLK_SEL;
+		writel(reg, host->ioaddr + ESDHC_MIX_CTRL);
+
+		writel(FIELD_PREP(ESDHC_TUNE_CTRL_STATUS_DLY_CELL_SET_PRE_MASK,
+				  imx_data->boarddata.saved_tuning_delay_cell),
+		       host->ioaddr + ESDHC_TUNE_CTRL_STATUS);
+	}
+}
+
 static void esdhc_cqe_enable(struct mmc_host *mmc)
 {
 	struct sdhci_host *host = mmc_priv(mmc);
@@ -1856,6 +1921,15 @@ static int sdhci_esdhc_suspend(struct device *dev)
 	if (host->tuning_mode != SDHCI_TUNING_MODE_3)
 		mmc_retune_needed(host->mmc);
 
+	/*
+	 * For the device need to keep power during system PM, need
+	 * to save the tuning delay value just in case the usdhc
+	 * lost power during system PM.
+	 */
+	if (mmc_card_keep_power(host->mmc) && mmc_card_wake_sdio_irq(host->mmc) &&
+	    esdhc_is_usdhc(imx_data))
+		sdhc_esdhc_tuning_save(host);
+
 	ret = sdhci_suspend_host(host);
 	if (ret)
 		return ret;
@@ -1872,6 +1946,8 @@ static int sdhci_esdhc_suspend(struct device *dev)
 static int sdhci_esdhc_resume(struct device *dev)
 {
 	struct sdhci_host *host = dev_get_drvdata(dev);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
 	int ret;
 
 	ret = pinctrl_pm_select_default_state(dev);
@@ -1885,6 +1961,14 @@ static int sdhci_esdhc_resume(struct device *dev)
 	if (ret)
 		return ret;
 
+	/*
+	 * restore the saved tuning delay value for the device which keep
+	 * power during system PM.
+	 */
+	if (mmc_card_keep_power(host->mmc) && mmc_card_wake_sdio_irq(host->mmc) &&
+	    esdhc_is_usdhc(imx_data))
+		sdhc_esdhc_tuning_restore(host);
+
 	if (host->mmc->caps2 & MMC_CAP2_CQE)
 		ret = cqhci_resume(host->mmc);
 
-- 
2.39.5

