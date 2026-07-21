Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870B9363081;
	Tue, 21 Jul 2026 17:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655315; cv=none; b=mufIpgbOir7ImbvQ0T2Mt+OOweGKpOegHmZQyp7vhEp0tFYOexmdcX75ufXlAYAQoYeG19at3ff5rBOnY+qMyVrLwKEKECllycFAA2fz4sFCLJeW6PwUf/ZJrN2wRI8qiUMM2Xkktpj/Vl7Zj0wHXjoLsbRpoDjYsNZkE6eFJFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655315; c=relaxed/simple;
	bh=Ai8uAabkkdFxXj9yAsBCZ30auDfJHXIeIS0f0si6t/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjpQHTh1qojgExmz3tqvMo0BS49VcWgIE+YX7S+/eqd6K8bUJ9qCsrrPp4umAaIRtP7wUXS4BI0eaQwWSoRznjepSJod5HuW0sC/439akWyhcu89d46xYr2xeA6kFmgaLd/m25VbV35nCYzl2669PP3tClHvQ9gLWAO/h3iN1Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MR/MY1qq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MR/MY1qq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2C21F000E9;
	Tue, 21 Jul 2026 17:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655314;
	bh=KLLUBU3lnaf2uHHSUCYMaFKL8epHYCMzcKRUNwm2GJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MR/MY1qqOCiutU/GfEwR9038ppUU6cyagO51KcuDb0Imu8S62ny59VSxxei+IZ16D
	 6kOYUZ0DKGuJVkuhcq1or859wW7xAEdN3E0cahyT1Yz689+2iCXRhxXOibC4CN6OYa
	 0BTilBi+dadDvinU4YWXVoVpOKrQQoGn1drzKvcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 2038/2077] mmc: sdhci-esdhc-imx: restore DLL override for DDR modes on resume
Date: Tue, 21 Jul 2026 17:28:31 +0200
Message-ID: <20260721152640.767618025@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke Wang <ziniu.wang_1@nxp.com>

commit 2439becd91bad6883b135044f85f83a0538b96a6 upstream.

sdhci_esdhc_imx_hwinit() unconditionally clears ESDHC_DLL_CTRL by
writing zero. For SDIO devices that keep power during system suspend
and operate in DDR mode, the card remains in DDR timing while the host
DLL override configuration is lost.

Extract the DLL override setup from esdhc_set_uhs_signaling() into
a helper esdhc_set_dll_override(), and call it on the resume path
when the card kept power and is using a DDR timing mode.

Fixes: 676a83855614 ("mmc: host: sdhci-esdhc-imx: refactor the system PM logic")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |   39 ++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1349,6 +1349,23 @@ static int esdhc_change_pinstate(struct
 	return pinctrl_select_state(imx_data->pinctrl, pinctrl);
 }
 
+static void esdhc_set_dll_override(struct sdhci_host *host)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
+	struct esdhc_platform_data *boarddata = &imx_data->boarddata;
+	u32 v;
+
+	if (!boarddata->delay_line)
+		return;
+
+	v = boarddata->delay_line << ESDHC_DLL_OVERRIDE_VAL_SHIFT |
+	    (1 << ESDHC_DLL_OVERRIDE_EN_SHIFT);
+	if (is_imx53_esdhc(imx_data))
+		v <<= 1;
+	writel(v, host->ioaddr + ESDHC_DLL_CTRL);
+}
+
 /*
  * For HS400 eMMC, there is a data_strobe line. This signal is generated
  * by the device and used for data output and CRC status response output
@@ -1404,7 +1421,6 @@ static void esdhc_set_uhs_signaling(stru
 	u32 m;
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
-	struct esdhc_platform_data *boarddata = &imx_data->boarddata;
 
 	/* disable ddr mode and disable HS400 mode */
 	m = readl(host->ioaddr + ESDHC_MIX_CTRL);
@@ -1425,15 +1441,7 @@ static void esdhc_set_uhs_signaling(stru
 		m |= ESDHC_MIX_CTRL_DDREN;
 		writel(m, host->ioaddr + ESDHC_MIX_CTRL);
 		imx_data->is_ddr = 1;
-		if (boarddata->delay_line) {
-			u32 v;
-			v = boarddata->delay_line <<
-				ESDHC_DLL_OVERRIDE_VAL_SHIFT |
-				(1 << ESDHC_DLL_OVERRIDE_EN_SHIFT);
-			if (is_imx53_esdhc(imx_data))
-				v <<= 1;
-			writel(v, host->ioaddr + ESDHC_DLL_CTRL);
-		}
+		esdhc_set_dll_override(host);
 		break;
 	case MMC_TIMING_MMC_HS400:
 		m |= ESDHC_MIX_CTRL_DDREN | ESDHC_MIX_CTRL_HS400_EN;
@@ -2129,9 +2137,18 @@ static int sdhci_esdhc_resume(struct dev
 	 * restore the saved tuning delay value for the device which keep
 	 * power during system PM.
 	 */
-	if (mmc_card_keep_power(host->mmc) && esdhc_is_usdhc(imx_data))
+	if (mmc_card_keep_power(host->mmc) && esdhc_is_usdhc(imx_data)) {
 		sdhc_esdhc_tuning_restore(host);
 
+		/*
+		 * Restore DLL override for DDR modes. hwinit unconditionally
+		 * clears ESDHC_DLL_CTRL, but the card is still in DDR mode.
+		 */
+		if (host->timing == MMC_TIMING_UHS_DDR50 ||
+		    host->timing == MMC_TIMING_MMC_DDR52)
+			esdhc_set_dll_override(host);
+	}
+
 	pm_runtime_put_autosuspend(dev);
 
 	return ret;


