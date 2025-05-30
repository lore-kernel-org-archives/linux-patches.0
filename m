Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD59322DF87;
	Fri, 30 May 2025 12:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608786; cv=none; b=Po60t/9F7uHTJTUdglirSNcZAhwm+c3KRqn6P+WpbfFHSnJfzs2CiK2P98gT5oeUSkL0NW5rslg8adPQKLs6nsf2szRCGg9Gt/gtfiYRnIO458FZblVir3wGy5Hi5gDisuCN4CldSw+1XQ+I7cwgREHvEcI/3R26/rGtyrcj2gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608786; c=relaxed/simple;
	bh=WCfPEgF7U60SODsr12OJ4UDT8DSIMuvTRTm+GCIA8F0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G7npqcmfD27ThJE5OjKAxsyTVaFkppOjdShcLjP4ebcEvVRgSLEeRhDi2v9QGzPP/c/0Y7rl7E4jiKsbBWJw+X8uSd251XN6+XEGDp3BmutmZcVlgM+OtVN/WOrTbGMAZ5fzOA968vs3ULoJQMnTlY1inPRdpSCxo8Jxrt56lsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QugkCWIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QugkCWIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E54C4CEF0;
	Fri, 30 May 2025 12:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608786;
	bh=WCfPEgF7U60SODsr12OJ4UDT8DSIMuvTRTm+GCIA8F0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QugkCWIk+lc+prLUscbvxu03O1lou4bXaxBNeV49i7Y3LGfDzkdnYkJrZa/kFwkQz
	 4525Y2hIW6ZiY3p+fnYmCZJ+CsgzJNcjTlkNepTxC1wyLQ66RiDWsMc8K7SNHd2CX0
	 I04DiEjyc8wi0IhC9EIuGL8JAGUpCbdtv2w7t0GRyoBQ4QeHl0yXIDP/YKfDH44rxp
	 +GET6VwFRtLrvuCmuAmzvkENx3SLJBXGkFhHaOwx+JBElZLwrPhf0+8t5jZvJsrIGC
	 hqsRAaTSITpnYE4mC5LgHWyccUo8AIKjnfgWUbTDMSy8rY6U2oQavg1iDekTGILR7u
	 bWybTzfjKlJfQ==
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
Subject: [PATCH AUTOSEL 6.14 09/28] mmc: sdhci-esdhc-imx: Save tuning value when card stays powered in suspend
Date: Fri, 30 May 2025 08:39:15 -0400
Message-Id: <20250530123934.2574748-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530123934.2574748-1-sashal@kernel.org>
References: <20250530123934.2574748-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
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
index ff78a7c6a04c9..7e8addaed697e 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -81,6 +81,8 @@
 #define  ESDHC_TUNE_CTRL_STEP		1
 #define  ESDHC_TUNE_CTRL_MIN		0
 #define  ESDHC_TUNE_CTRL_MAX		((1 << 7) - 1)
+#define  ESDHC_TUNE_CTRL_STATUS_TAP_SEL_PRE_MASK	GENMASK(30, 24)
+#define  ESDHC_TUNE_CTRL_STATUS_DLY_CELL_SET_PRE_MASK	GENMASK(14, 8)
 
 /* strobe dll register */
 #define ESDHC_STROBE_DLL_CTRL		0x70
@@ -235,6 +237,7 @@ struct esdhc_platform_data {
 	unsigned int tuning_step;       /* The delay cell steps in tuning procedure */
 	unsigned int tuning_start_tap;	/* The start delay cell point in tuning procedure */
 	unsigned int strobe_dll_delay_target;	/* The delay cell for strobe pad (read clock) */
+	unsigned int saved_tuning_delay_cell;	/* save the value of tuning delay cell */
 };
 
 struct esdhc_soc_data {
@@ -1057,7 +1060,7 @@ static void esdhc_reset_tuning(struct sdhci_host *host)
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
-	u32 ctrl;
+	u32 ctrl, tuning_ctrl;
 	int ret;
 
 	/* Reset the tuning circuit */
@@ -1071,6 +1074,16 @@ static void esdhc_reset_tuning(struct sdhci_host *host)
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
@@ -1149,7 +1162,8 @@ static void esdhc_prepare_tuning(struct sdhci_host *host, u32 val)
 	reg |= ESDHC_MIX_CTRL_EXE_TUNE | ESDHC_MIX_CTRL_SMPCLK_SEL |
 			ESDHC_MIX_CTRL_FBCLK_SEL;
 	writel(reg, host->ioaddr + ESDHC_MIX_CTRL);
-	writel(val << 8, host->ioaddr + ESDHC_TUNE_CTRL_STATUS);
+	writel(FIELD_PREP(ESDHC_TUNE_CTRL_STATUS_DLY_CELL_SET_PRE_MASK, val),
+	       host->ioaddr + ESDHC_TUNE_CTRL_STATUS);
 	dev_dbg(mmc_dev(host->mmc),
 		"tuning with delay 0x%x ESDHC_TUNE_CTRL_STATUS 0x%x\n",
 			val, readl(host->ioaddr + ESDHC_TUNE_CTRL_STATUS));
@@ -1569,6 +1583,57 @@ static void sdhci_esdhc_imx_hwinit(struct sdhci_host *host)
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
@@ -1900,6 +1965,15 @@ static int sdhci_esdhc_suspend(struct device *dev)
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
@@ -1916,6 +1990,8 @@ static int sdhci_esdhc_suspend(struct device *dev)
 static int sdhci_esdhc_resume(struct device *dev)
 {
 	struct sdhci_host *host = dev_get_drvdata(dev);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
 	int ret;
 
 	ret = pinctrl_pm_select_default_state(dev);
@@ -1929,6 +2005,14 @@ static int sdhci_esdhc_resume(struct device *dev)
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

