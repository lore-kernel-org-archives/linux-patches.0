Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DD5471262;
	Tue, 21 Jul 2026 18:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659408; cv=none; b=rdVmD0k08So06bQMgc3MPMW4UYnXetj/mQ1xzgVob/3Kp1279whfCCcNgNFJen+Eq937Roa+OtDifsj/wRW0Lc+bHgKknjdPaopxgz/oKYAP1/7YdxZN4oaxOGFHv4juup8qcsK0DDYJnVsv+zKQ2z+7FBWInqgj8ZXl8akdQSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659408; c=relaxed/simple;
	bh=tYmtemzoAJpP3C0gr0JGtl7hbneEAzhjy5k/S9nGahs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yvu26Jprchk96qXGe1Db6y3nFHcXMZ4IWwxp/s5yF1mPtVXHulcse/tPMOyt8fUqCcba9Oz4lVq6EiklhA9VlupIhi6olx5H1gj7QmATV6xO/m0VvAUiWfWEpC62nMpEF/7fKbXcCyYxqvXNG2hyvIS+9MZC7MLYdMg3UaAYwr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJwCkd3H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJwCkd3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799711F000E9;
	Tue, 21 Jul 2026 18:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659407;
	bh=6S0Ik92Ox2DQSSpwHf/Tuk3EtsgDTAk1T+KOI3AhXi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJwCkd3HRDzXzekD2nMaVcKURmxiQq/wlkcu3Mnlc0sdic0TWdu+luHD3rLzWPzZA
	 85H+jASAYMgLn9GOOMHCDkvGKJej5cvg84TDj/UvXcWbMoVzplcgjY+NBNxVl+EP5A
	 P0FduxwC4e1PgsNbaZg1O/acz9Ts5dfSBbb0xMqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 1509/1611] mmc: sdhci-esdhc-imx: restore DLL override for DDR modes on resume
Date: Tue, 21 Jul 2026 17:27:05 +0200
Message-ID: <20260721152549.383385548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1338,6 +1338,23 @@ static int esdhc_change_pinstate(struct
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
@@ -1393,7 +1410,6 @@ static void esdhc_set_uhs_signaling(stru
 	u32 m;
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct pltfm_imx_data *imx_data = sdhci_pltfm_priv(pltfm_host);
-	struct esdhc_platform_data *boarddata = &imx_data->boarddata;
 
 	/* disable ddr mode and disable HS400 mode */
 	m = readl(host->ioaddr + ESDHC_MIX_CTRL);
@@ -1414,15 +1430,7 @@ static void esdhc_set_uhs_signaling(stru
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
@@ -2106,9 +2114,18 @@ static int sdhci_esdhc_resume(struct dev
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


