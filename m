Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C9D1DED7D;
	Wed, 19 Feb 2025 08:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954452; cv=none; b=W37JnBER0HCH+faVQfpSFX2W24RfosbvDuRexEnDP75OEuQ4HN/BBN3T1iH71IE60fFc4NMbvkWzvpvm9q8S1I3748jvk4oyaNXwOW88aGZXXkImgSvLi5TbsaJ2H3ustSmnGJWSv6po6wuaICejeVrDGFInFjr0oRFx2L3Rs9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954452; c=relaxed/simple;
	bh=eco0mV7knLbXSz7cC+b+4oHqBd5YwB62spuBYXmnAP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbQ2EtyDU4SOoVXhLA+ATu6E1nfh5Y2XKBo5kUQHtWtFOAHHsm2N1BG+yaYCavjJvIAuEpxPuq73NPBdt+unIEFa5Pa5LIO/PjZpRcJrs2Wduak02DAUyDa0JzDWrGMPLlnU4pEX6nsgaWuSUN8ha+RkJ6N85Kf5aSoA2o8Z7Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WuQZCla/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WuQZCla/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5C3C2BCB7;
	Wed, 19 Feb 2025 08:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954452;
	bh=eco0mV7knLbXSz7cC+b+4oHqBd5YwB62spuBYXmnAP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WuQZCla/N2Edw82oxIUuzl8zpLE8FctWLZKzoafDI2nN3rFFiA+InLy+2NiUn35gq
	 beZnGRWDRcYIj/2H5UtSp42NINvqGdaxjBmaOIS1V4jifGiGN/BfHC67ezQpZXqvij
	 LRKVUvlP+U9cmp6ZC3Wd5DXB2/lcyKJ3Ww0Tf7/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.13 178/274] Revert "mmc: sdhci_am654: Add sdhci_am654_start_signal_voltage_switch"
Date: Wed, 19 Feb 2025 09:27:12 +0100
Message-ID: <20250219082616.555279364@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

commit ac5a41b472b4ef8bb37d7550796d059b377b4646 upstream.

This reverts commit 941a7abd4666912b84ab209396fdb54b0dae685d.

This commit uses presence of device-tree properties vmmc-supply and
vqmmc-supply for deciding whether to enable a quirk affecting timing of
clock and data.
The intention was to address issues observed with eMMC and SD on AM62
platforms.

This new quirk is however also enabled for AM64 breaking microSD access
on the SolidRun HimmingBoard-T which is supported in-tree since v6.11,
causing a regression. During boot microSD initialization now fails with
the error below:

[    2.008520] mmc1: SDHCI controller on fa00000.mmc [fa00000.mmc] using ADMA 64-bit
[    2.115348] mmc1: error -110 whilst initialising SD card

The heuristics for enabling the quirk are clearly not correct as they
break at least one but potentially many existing boards.

Revert the change and restore original behaviour until a more
appropriate method of selecting the quirk is derived.

Fixes: 941a7abd4666 ("mmc: sdhci_am654: Add sdhci_am654_start_signal_voltage_switch")
Closes: https://lore.kernel.org/linux-mmc/a70fc9fc-186f-4165-a652-3de50733763a@solid-run.com/
Cc: stable@vger.kernel.org
Signed-off-by: Josua Mayer <josua@solid-run.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250127-am654-mmc-regression-v2-1-9bb39fb12810@solid-run.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_am654.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index b73f673db92b..f75c31815ab0 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -155,7 +155,6 @@ struct sdhci_am654_data {
 	u32 tuning_loop;
 
 #define SDHCI_AM654_QUIRK_FORCE_CDTEST BIT(0)
-#define SDHCI_AM654_QUIRK_SUPPRESS_V1P8_ENA BIT(1)
 };
 
 struct window {
@@ -357,29 +356,6 @@ static void sdhci_j721e_4bit_set_clock(struct sdhci_host *host,
 	sdhci_set_clock(host, clock);
 }
 
-static int sdhci_am654_start_signal_voltage_switch(struct mmc_host *mmc, struct mmc_ios *ios)
-{
-	struct sdhci_host *host = mmc_priv(mmc);
-	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-	struct sdhci_am654_data *sdhci_am654 = sdhci_pltfm_priv(pltfm_host);
-	int ret;
-
-	if ((sdhci_am654->quirks & SDHCI_AM654_QUIRK_SUPPRESS_V1P8_ENA) &&
-	    ios->signal_voltage == MMC_SIGNAL_VOLTAGE_180) {
-		if (!IS_ERR(mmc->supply.vqmmc)) {
-			ret = mmc_regulator_set_vqmmc(mmc, ios);
-			if (ret < 0) {
-				pr_err("%s: Switching to 1.8V signalling voltage failed,\n",
-				       mmc_hostname(mmc));
-				return -EIO;
-			}
-		}
-		return 0;
-	}
-
-	return sdhci_start_signal_voltage_switch(mmc, ios);
-}
-
 static u8 sdhci_am654_write_power_on(struct sdhci_host *host, u8 val, int reg)
 {
 	writeb(val, host->ioaddr + reg);
@@ -868,11 +844,6 @@ static int sdhci_am654_get_of_property(struct platform_device *pdev,
 	if (device_property_read_bool(dev, "ti,fails-without-test-cd"))
 		sdhci_am654->quirks |= SDHCI_AM654_QUIRK_FORCE_CDTEST;
 
-	/* Suppress v1p8 ena for eMMC and SD with vqmmc supply */
-	if (!!of_parse_phandle(dev->of_node, "vmmc-supply", 0) ==
-	    !!of_parse_phandle(dev->of_node, "vqmmc-supply", 0))
-		sdhci_am654->quirks |= SDHCI_AM654_QUIRK_SUPPRESS_V1P8_ENA;
-
 	sdhci_get_of_property(pdev);
 
 	return 0;
@@ -969,7 +940,6 @@ static int sdhci_am654_probe(struct platform_device *pdev)
 		goto err_pltfm_free;
 	}
 
-	host->mmc_host_ops.start_signal_voltage_switch = sdhci_am654_start_signal_voltage_switch;
 	host->mmc_host_ops.execute_tuning = sdhci_am654_execute_tuning;
 
 	pm_runtime_get_noresume(dev);
-- 
2.48.1



