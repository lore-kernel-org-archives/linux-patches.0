Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799021946C8;
	Fri,  9 Jan 2026 12:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960468; cv=none; b=cUSexoRBm67hDeDdzWH4yV2Ax8QTTq2I/ktUQTFGT/iijDrkvj061k6WX3zyWanAyQ+iZjHGOGIXZEeUBybgW7of3Ti/WCCsswqLp2FH6T6Q2lOmx4YopbUhzSLs9l/6TuxjhZ7dzNtn+R6vlbtuABMADV/wLg1nLEI53pDOQh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960468; c=relaxed/simple;
	bh=E/pDEk2uDMC3F4w0+ALzdlhC8sW9Nvs8mM6aNPnUyOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUBPD3GR87bXXR3LOnXG6/9cUEwaJMZl9RPoWioAmkSACwPXVgCYsVbcQh6I0vGJwhaLXrSfiWDHXIk6YKFvgUz1NyOHRUMxrK+dfhU+z4+ZXAALtGQC6EkWVKaNpbjCVqn4pq96r/2Bm/+h/TxFM4YSWcauJ7ekkSegPrdlVbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z129mKHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z129mKHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012D8C4CEF1;
	Fri,  9 Jan 2026 12:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960468;
	bh=E/pDEk2uDMC3F4w0+ALzdlhC8sW9Nvs8mM6aNPnUyOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z129mKHYeOJAa13IgsCPraa9F41i0DZkTv4aB1SjuwwJT8MdB7hIi/oytsMFcSChI
	 Ikbk8STzHuqSo3w2JohMUzM+B66qaTsCtYOhS3afp/MtYr6FffyGy5IO0PrN904xqV
	 xtmqXLoZs0IeGRkO9O3L6NZ5NGIhhWj1WEhf/yak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarthak Garg <sarthak.garg@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 414/737] mmc: sdhci-msm: Avoid early clock doubling during HS400 transition
Date: Fri,  9 Jan 2026 12:39:13 +0100
Message-ID: <20260109112149.570960786@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -344,41 +344,43 @@ static void sdhci_msm_v5_variant_writel_
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
 
@@ -397,7 +399,7 @@ static void msm_set_clock_rate_for_bus_m
 	msm_host->clk_rate = desired_rate;
 
 	pr_debug("%s: Setting clock at rate %lu at timing %d\n",
-		 mmc_hostname(host->mmc), achieved_rate, curr_ios.timing);
+		 mmc_hostname(host->mmc), achieved_rate, timing);
 }
 
 /* Platform specific tuning */
@@ -1239,7 +1241,7 @@ static int sdhci_msm_execute_tuning(stru
 	 */
 	if (host->flags & SDHCI_HS400_TUNING) {
 		sdhci_msm_hc_select_mode(host);
-		msm_set_clock_rate_for_bus_mode(host, ios.clock);
+		msm_set_clock_rate_for_bus_mode(host, ios.clock, ios.timing);
 		host->flags &= ~SDHCI_HS400_TUNING;
 	}
 
@@ -1864,6 +1866,7 @@ static void sdhci_msm_set_clock(struct s
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
+	struct mmc_ios ios = host->mmc->ios;
 
 	if (!clock) {
 		host->mmc->actual_clock = msm_host->clk_rate = 0;
@@ -1872,7 +1875,7 @@ static void sdhci_msm_set_clock(struct s
 
 	sdhci_msm_hc_select_mode(host);
 
-	msm_set_clock_rate_for_bus_mode(host, clock);
+	msm_set_clock_rate_for_bus_mode(host, ios.clock, ios.timing);
 out:
 	__sdhci_msm_set_clock(host, clock);
 }


