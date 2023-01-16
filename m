Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666D033EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20A7C433EF;
	Mon, 16 Jan 2023 16:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885089;
	bh=rrLrsdszX674Md0sinJm4j8EoHx8+R2PSABKYAthVZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+l13mTZj9EEJT6drVxI2KvTEy0HugwsFsiqpVObaEYVawij3vnRlL14ukKVcvd+c
	 hxl3qkEoTwoqYp/D0aGKX8h65ElS4ocXo7vivMw1O6eCDd2gliGFjzLRHRkUO9CQI2
	 AsmPDmyN40kYKwRfajFn/XU6E83qwf1Y4R9qk8/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher S Hall <christopher.s.hall@intel.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Sasha Neftin <sasha.neftin@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 71/86] igc: Fix PPS delta between two synchronized end-points
Date: Mon, 16 Jan 2023 16:51:45 +0100
Message-Id: <20230116154750.015996027@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christopher S Hall <christopher.s.hall@intel.com>

[ Upstream commit 5e91c72e560cc85f7163bbe3d14197268de31383 ]

This patch fix the pulse per second output delta between
two synchronized end-points.

Based on Intel Discrete I225 Software User Manual Section
4.2.15 TimeSync Auxiliary Control Register, ST0[Bit 4] and
ST1[Bit 7] must be set to ensure that clock output will be
toggles based on frequency value defined. This is to ensure
that output of the PPS is aligned with the clock.

How to test:

1) Running time synchronization on both end points.
Ex: ptp4l --step_threshold=1 -m -f gPTP.cfg -i <interface name>

2) Configure PPS output using below command for both end-points
Ex: SDP0 on I225 REV4 SKU variant

./testptp -d /dev/ptp0 -L 0,2
./testptp -d /dev/ptp0 -p 1000000000

3) Measure the output using analyzer for both end-points

Fixes: 87938851b6ef ("igc: enable auxiliary PHC functions for the i225")
Signed-off-by: Christopher S Hall <christopher.s.hall@intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_defines.h |  2 ++
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 10 ++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index f171bc99e58c..60d0ca69ceca 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -469,7 +469,9 @@
 #define IGC_TSAUXC_EN_TT0	BIT(0)  /* Enable target time 0. */
 #define IGC_TSAUXC_EN_TT1	BIT(1)  /* Enable target time 1. */
 #define IGC_TSAUXC_EN_CLK0	BIT(2)  /* Enable Configurable Frequency Clock 0. */
+#define IGC_TSAUXC_ST0		BIT(4)  /* Start Clock 0 Toggle on Target Time 0. */
 #define IGC_TSAUXC_EN_CLK1	BIT(5)  /* Enable Configurable Frequency Clock 1. */
+#define IGC_TSAUXC_ST1		BIT(7)  /* Start Clock 1 Toggle on Target Time 1. */
 #define IGC_TSAUXC_EN_TS0	BIT(8)  /* Enable hardware timestamp 0. */
 #define IGC_TSAUXC_AUTT0	BIT(9)  /* Auxiliary Timestamp Taken. */
 #define IGC_TSAUXC_EN_TS1	BIT(10) /* Enable hardware timestamp 0. */
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 8e521f99b80a..fbde7826927b 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -323,7 +323,7 @@ static int igc_ptp_feature_enable_i225(struct ptp_clock_info *ptp,
 		ts = ns_to_timespec64(ns);
 		if (rq->perout.index == 1) {
 			if (use_freq) {
-				tsauxc_mask = IGC_TSAUXC_EN_CLK1;
+				tsauxc_mask = IGC_TSAUXC_EN_CLK1 | IGC_TSAUXC_ST1;
 				tsim_mask = 0;
 			} else {
 				tsauxc_mask = IGC_TSAUXC_EN_TT1;
@@ -334,7 +334,7 @@ static int igc_ptp_feature_enable_i225(struct ptp_clock_info *ptp,
 			freqout = IGC_FREQOUT1;
 		} else {
 			if (use_freq) {
-				tsauxc_mask = IGC_TSAUXC_EN_CLK0;
+				tsauxc_mask = IGC_TSAUXC_EN_CLK0 | IGC_TSAUXC_ST0;
 				tsim_mask = 0;
 			} else {
 				tsauxc_mask = IGC_TSAUXC_EN_TT0;
@@ -348,10 +348,12 @@ static int igc_ptp_feature_enable_i225(struct ptp_clock_info *ptp,
 		tsauxc = rd32(IGC_TSAUXC);
 		tsim = rd32(IGC_TSIM);
 		if (rq->perout.index == 1) {
-			tsauxc &= ~(IGC_TSAUXC_EN_TT1 | IGC_TSAUXC_EN_CLK1);
+			tsauxc &= ~(IGC_TSAUXC_EN_TT1 | IGC_TSAUXC_EN_CLK1 |
+				    IGC_TSAUXC_ST1);
 			tsim &= ~IGC_TSICR_TT1;
 		} else {
-			tsauxc &= ~(IGC_TSAUXC_EN_TT0 | IGC_TSAUXC_EN_CLK0);
+			tsauxc &= ~(IGC_TSAUXC_EN_TT0 | IGC_TSAUXC_EN_CLK0 |
+				    IGC_TSAUXC_ST0);
 			tsim &= ~IGC_TSICR_TT0;
 		}
 		if (on) {
-- 
2.35.1



