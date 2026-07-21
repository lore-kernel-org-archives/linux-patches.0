Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DB040587A;
	Tue, 21 Jul 2026 17:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655318; cv=none; b=unxxdIO3j+GptSekQVmMo36MUMWrEJQbccO2YEzGfpFeYekLVd0em99urwtOWo2BdTRxpn23MBwcwgWogn33bOD0bTdWLDZBHPid6qY51DH1yEtRlPZkQIeNT++VFaoebv59EWlBv5E4rsgmEJBeeJ6a9bPWkPGSsoJ+BbGdno8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655318; c=relaxed/simple;
	bh=32kijakUzOJ8TY66bzUXxW2i/jvxdRbkHtVkrkTtuFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ry8h4NKtfc4lacEIh2uN0j6O4Y3G1tSSHiBHWN+Z7LUz0mKhLxjbLroskdRIniE5QQ7t9s5BLdpSZTDTnCkiTrzQEo74865DOXlMdU/zyzmNQNbcVqDF9dC17iNHVD8u4c6qwb8i3ASp6QL9YMz+OPE7ALkZ0+Gh+uGadWJY4FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1MJFZjZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1MJFZjZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68621F000E9;
	Tue, 21 Jul 2026 17:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655317;
	bh=xTFUzchI2qju0cx36faBGFkuV+4724ZJSQgvKcCJSu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1MJFZjZhbnaNoyztZA0fvT9wmmuV2bPsPidaEpjmvkAlc2oE1op7ZR4ei1Fs4bDdq
	 xHhRcbHMEP/ynty7+SeHPIonl9shxwIeCfCK2PFPySEOF6ejUOjmmA6aMPz1h1zL96
	 LMGSIwpA+WEDp1kh12fIQNxmmd0WMztoIYE2C+Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 2039/2077] mmc: sdhci-esdhc-imx: fix esdhc_change_pinstate() to allow default state restore
Date: Tue, 21 Jul 2026 17:28:32 +0200
Message-ID: <20260721152640.790743352@linuxfoundation.org>
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

commit 5adc14cd4b905629d5b9163b3a416dcab24c7ce2 upstream.

esdhc_change_pinstate() checks for pins_100mhz and pins_200mhz at the
top of the function and returns -EINVAL if either is not defined. This
prevents the default case from ever being reached, which means devices
with a sleep pinctrl state but without high-speed pin states (100mhz/
200mhz) can never restore their default pin configuration.

Move the IS_ERR checks for pins_100mhz and pins_200mhz into their
respective switch cases.

Fixes: 676a83855614 ("mmc: host: sdhci-esdhc-imx: refactor the system PM logic")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1326,19 +1326,21 @@ static int esdhc_change_pinstate(struct
 
 	dev_dbg(mmc_dev(host->mmc), "change pinctrl state for uhs %d\n", uhs);
 
-	if (IS_ERR(imx_data->pinctrl) ||
-		IS_ERR(imx_data->pins_100mhz) ||
-		IS_ERR(imx_data->pins_200mhz))
+	if (IS_ERR(imx_data->pinctrl))
 		return -EINVAL;
 
 	switch (uhs) {
 	case MMC_TIMING_UHS_SDR50:
 	case MMC_TIMING_UHS_DDR50:
+		if (IS_ERR(imx_data->pins_100mhz))
+			return -EINVAL;
 		pinctrl = imx_data->pins_100mhz;
 		break;
 	case MMC_TIMING_UHS_SDR104:
 	case MMC_TIMING_MMC_HS200:
 	case MMC_TIMING_MMC_HS400:
+		if (IS_ERR(imx_data->pins_200mhz))
+			return -EINVAL;
 		pinctrl = imx_data->pins_200mhz;
 		break;
 	default:


