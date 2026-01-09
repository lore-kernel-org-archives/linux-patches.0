Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BC235B14E;
	Fri,  9 Jan 2026 12:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962400; cv=none; b=aDx5ZPfY/zlOCRwUONrFagcj75mH1IW5v8etJmyP0wCaaxAxAdvhR9ZhjN1+dWCK8sWbBrLu1WHYd75VK1RxCn8QgWTd7aJD4mBTRveBH9IG9srLzipVGPC2xSC7LNFHonmusNNpiGYZw0h+pVMTeb4gDRq7kp4ArfHjEXG0hWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962400; c=relaxed/simple;
	bh=je+7vTdfpRFhgchpl+UvZdzuaNfwMfHFOkHNH/H2KUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EthOgYeRM2ULlzBPMQAc5A27dYDlzoSkqwktZq3HoKx37mRwfE2ZzmGjLLYOPzLRuIHu6cQcymqSGbpTVKiXAmBS/zOi4xaG40B4rWq0MEBeIF6zvXQ0cdazlJ4uBEq9mM3A0Q/Swnhhf8hk2vkJJ5kUuu8Ii5I7Ql18WQr5mtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=md32XB6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="md32XB6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5897BC4AF09;
	Fri,  9 Jan 2026 12:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962399;
	bh=je+7vTdfpRFhgchpl+UvZdzuaNfwMfHFOkHNH/H2KUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=md32XB6SWm8vEFvxnijottH0eAenDJuevb68xZjKYo3d5JMj7a85rOGEDwKD56GPY
	 +TeeZgAIvEMA8RqHriigkcxDx8MqNVwVuChUeheX5L0kJq73dXEIyCXfa3ZEdk2VHd
	 NKelu8/67Zqq4Z6q5Pk5KPpF4GCKEOo5sAcvC86E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarthak Garg <sarthak.garg@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 319/634] mmc: sdhci-msm: Avoid early clock doubling during HS400 transition
Date: Fri,  9 Jan 2026 12:39:57 +0100
Message-ID: <20260109112129.535287556@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarthak Garg <sarthak.garg@oss.qualcomm.com>

commit b1f856b1727c2eaa4be2c6d7cd7a8ed052bbeb87 upstream.

According to the hardware programming guide, the clock frequency must
remain below 52MHz during the transition to HS400 mode.

However,in the current implementation, the timing is set to HS400 (a
DDR mode) before adjusting the clock. This causes the clock to double
prematurely to 104MHz during the transition phase, violating the
specification and potentially resulting in CRC errors or CMD timeouts.

This change ensures that clock doubling is avoided during intermediate
transitions and is applied only when the card requires a 200MHz clock
for HS400 operation.

Signed-off-by: Sarthak Garg <sarthak.garg@oss.qualcomm.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-msm.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -340,41 +340,43 @@ static void sdhci_msm_v5_variant_writel_
 	writel_relaxed(val, host->ioaddr + offset);
 }
 
-static unsigned int msm_get_clock_mult_for_bus_mode(struct sdhci_host *host)
+static unsigned int msm_get_clock_mult_for_bus_mode(struct sdhci_host *host,
+						    unsigned int clock,
+						    unsigned int timing)
 {
-	struct mmc_ios ios = host->mmc->ios;
 	/*
 	 * The SDHC requires internal clock frequency to be double the
 	 * actual clock that will be set for DDR mode. The controller
 	 * uses the faster clock(100/400MHz) for some of its parts and
 	 * send the actual required clock (50/200MHz) to the card.
 	 */
-	if (ios.timing == MMC_TIMING_UHS_DDR50 ||
-	    ios.timing == MMC_TIMING_MMC_DDR52 ||
-	    ios.timing == MMC_TIMING_MMC_HS400 ||
+	if (timing == MMC_TIMING_UHS_DDR50 ||
+	    timing == MMC_TIMING_MMC_DDR52 ||
+	    (timing == MMC_TIMING_MMC_HS400 &&
+	    clock == MMC_HS200_MAX_DTR) ||
 	    host->flags & SDHCI_HS400_TUNING)
 		return 2;
 	return 1;
 }
 
 static void msm_set_clock_rate_for_bus_mode(struct sdhci_host *host,
-					    unsigned int clock)
+					    unsigned int clock,
+					    unsigned int timing)
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
-	struct mmc_ios curr_ios = host->mmc->ios;
 	struct clk *core_clk = msm_host->bulk_clks[0].clk;
 	unsigned long achieved_rate;
 	unsigned int desired_rate;
 	unsigned int mult;
 	int rc;
 
-	mult = msm_get_clock_mult_for_bus_mode(host);
+	mult = msm_get_clock_mult_for_bus_mode(host, clock, timing);
 	desired_rate = clock * mult;
 	rc = dev_pm_opp_set_rate(mmc_dev(host->mmc), desired_rate);
 	if (rc) {
 		pr_err("%s: Failed to set clock at rate %u at timing %d\n",
-		       mmc_hostname(host->mmc), desired_rate, curr_ios.timing);
+		       mmc_hostname(host->mmc), desired_rate, timing);
 		return;
 	}
 
@@ -393,7 +395,7 @@ static void msm_set_clock_rate_for_bus_m
 	msm_host->clk_rate = desired_rate;
 
 	pr_debug("%s: Setting clock at rate %lu at timing %d\n",
-		 mmc_hostname(host->mmc), achieved_rate, curr_ios.timing);
+		 mmc_hostname(host->mmc), achieved_rate, timing);
 }
 
 /* Platform specific tuning */
@@ -1235,7 +1237,7 @@ static int sdhci_msm_execute_tuning(stru
 	 */
 	if (host->flags & SDHCI_HS400_TUNING) {
 		sdhci_msm_hc_select_mode(host);
-		msm_set_clock_rate_for_bus_mode(host, ios.clock);
+		msm_set_clock_rate_for_bus_mode(host, ios.clock, ios.timing);
 		host->flags &= ~SDHCI_HS400_TUNING;
 	}
 
@@ -1860,6 +1862,7 @@ static void sdhci_msm_set_clock(struct s
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
+	struct mmc_ios ios = host->mmc->ios;
 
 	if (!clock) {
 		host->mmc->actual_clock = msm_host->clk_rate = 0;
@@ -1868,7 +1871,7 @@ static void sdhci_msm_set_clock(struct s
 
 	sdhci_msm_hc_select_mode(host);
 
-	msm_set_clock_rate_for_bus_mode(host, clock);
+	msm_set_clock_rate_for_bus_mode(host, ios.clock, ios.timing);
 out:
 	__sdhci_msm_set_clock(host, clock);
 }


