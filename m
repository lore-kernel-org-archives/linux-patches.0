Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A791196C89;
	Thu,  6 Jun 2024 14:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683477; cv=none; b=N3SuyiD8d4SwCjeDZYZ3kUHXDeynUZkign9E5nHkN4xPJLW+kfsg4OZwhq+yNxFF97PbYJsLUBrxq888wy8jKBW6Hkmx4qzpqoyttLlRhHAvQYXgQH49ZutCvzHOXpGY0fmtz09U5bikBa3oHVrEjDx8/8z24LX12hlam5RvQ/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683477; c=relaxed/simple;
	bh=s70To0Y57xHZfgD8diaO3F5951nsLv3Op2dd6O+1cIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOkJUoka0gCKt5rjnvHs7Js1rWVL50AM6lWY8urUtmaYUQNKW/FlsctG0d3mmaz90qe4bNwDVuHGEK4uQo0ITMnNcAjwl0orbHbED9wBQwq7cjbbqd9+eKEZqzV8bj0D1jLR5TxJrAZ7Gz130VDqWI5Mvda3tEaEgO5vEjH2Qpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tExIIRVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tExIIRVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED95BC32781;
	Thu,  6 Jun 2024 14:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683477;
	bh=s70To0Y57xHZfgD8diaO3F5951nsLv3Op2dd6O+1cIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tExIIRViHEjUDcVMDKWMxR8FK964bN2FQwVBXpqvlU5AmWaIe8AwMHx/LVQXE9iWN
	 zqaLOYFWmTXyrbJrOkn1D9Y+jxhPIeYdmoSzx9w+Jy+GbFeoEIUXel39EFbs3iazdw
	 ebicPmpPF0twKCh5k6BmbAxrRmYA/NJU3MPjCw0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 363/473] mmc: sdhci_am654: Drop lookup for deprecated ti,otap-del-sel
Date: Thu,  6 Jun 2024 16:04:52 +0200
Message-ID: <20240606131711.914420800@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 5cb2f9286a31f33dc732c57540838ad9339393ab ]

ti,otap-del-sel has been deprecated since v5.7 and there are no users of
this property and no documentation in the DT bindings either.
Drop the fallback code looking for this property, this makes
sdhci_am654_get_otap_delay() much easier to read as all the TAP values
can be handled via a single iterator loop.

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20231122060215.2074799-1-vigneshr@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 387c1bf7dce0 ("mmc: sdhci_am654: Add OTAP/ITAP delay enable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci_am654.c | 37 ++++++----------------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index fb410a8a40799..2350f7d693709 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -140,7 +140,6 @@ static const struct timing_data td[] = {
 
 struct sdhci_am654_data {
 	struct regmap *base;
-	bool legacy_otapdly;
 	int otap_del_sel[ARRAY_SIZE(td)];
 	int itap_del_sel[ARRAY_SIZE(td)];
 	int clkbuf_sel;
@@ -278,11 +277,7 @@ static void sdhci_am654_set_clock(struct sdhci_host *host, unsigned int clock)
 	sdhci_set_clock(host, clock);
 
 	/* Setup DLL Output TAP delay */
-	if (sdhci_am654->legacy_otapdly)
-		otap_del_sel = sdhci_am654->otap_del_sel[0];
-	else
-		otap_del_sel = sdhci_am654->otap_del_sel[timing];
-
+	otap_del_sel = sdhci_am654->otap_del_sel[timing];
 	otap_del_ena = (timing > MMC_TIMING_UHS_SDR25) ? 1 : 0;
 
 	mask = OTAPDLYENA_MASK | OTAPDLYSEL_MASK;
@@ -324,10 +319,7 @@ static void sdhci_j721e_4bit_set_clock(struct sdhci_host *host,
 	u32 mask, val;
 
 	/* Setup DLL Output TAP delay */
-	if (sdhci_am654->legacy_otapdly)
-		otap_del_sel = sdhci_am654->otap_del_sel[0];
-	else
-		otap_del_sel = sdhci_am654->otap_del_sel[timing];
+	otap_del_sel = sdhci_am654->otap_del_sel[timing];
 
 	mask = OTAPDLYENA_MASK | OTAPDLYSEL_MASK;
 	val = (0x1 << OTAPDLYENA_SHIFT) |
@@ -649,32 +641,15 @@ static int sdhci_am654_get_otap_delay(struct sdhci_host *host,
 	int i;
 	int ret;
 
-	ret = device_property_read_u32(dev, td[MMC_TIMING_LEGACY].otap_binding,
-				 &sdhci_am654->otap_del_sel[MMC_TIMING_LEGACY]);
-	if (ret) {
-		/*
-		 * ti,otap-del-sel-legacy is mandatory, look for old binding
-		 * if not found.
-		 */
-		ret = device_property_read_u32(dev, "ti,otap-del-sel",
-					       &sdhci_am654->otap_del_sel[0]);
-		if (ret) {
-			dev_err(dev, "Couldn't find otap-del-sel\n");
-
-			return ret;
-		}
-
-		dev_info(dev, "Using legacy binding ti,otap-del-sel\n");
-		sdhci_am654->legacy_otapdly = true;
-
-		return 0;
-	}
-
 	for (i = MMC_TIMING_LEGACY; i <= MMC_TIMING_MMC_HS400; i++) {
 
 		ret = device_property_read_u32(dev, td[i].otap_binding,
 					       &sdhci_am654->otap_del_sel[i]);
 		if (ret) {
+			if (i == MMC_TIMING_LEGACY) {
+				dev_err(dev, "Couldn't find mandatory ti,otap-del-sel-legacy\n");
+				return ret;
+			}
 			dev_dbg(dev, "Couldn't find %s\n",
 				td[i].otap_binding);
 			/*
-- 
2.43.0



