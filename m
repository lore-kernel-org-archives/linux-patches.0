Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19EC1C68C;
	Sun,  1 Sep 2024 16:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209897; cv=none; b=hLYmqa5G5l/AoP3ee3QuSWoiWMa+daBoy+ftokXZm0P/ZRna0slZDyX1UswnXI0BDkJ7aMwwUlpixUlz1CVH3UMc5pElceyE97hPEtoYzWpc++Rh9v4791BYg7gQcXQ6WX5gotYaS9Bh1/HmBbLjfflIooq3nUzXdGG/TXNUofs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209897; c=relaxed/simple;
	bh=nyPwlwYooYN5LDuTTloFRHHF+i1tWx3AQr424Fve4zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euQc3bo92FpTDUPckdTuV/NeRJ/dolNFZ3KFVXhPRETQk6ijwrA7QwqY7NRaN1JyMC+WqwiRrp1tpCDy4Yai1+SRsuCzPCdRk00Ro+dTbxdosKtfrjE/+rSrvsLRWOXnwDkQT3Eg4b0bAFtFxJKQGlrJ0zxTgEOtx83ZmrfXHG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcUQsyS3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcUQsyS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D558C4CEC3;
	Sun,  1 Sep 2024 16:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209896;
	bh=nyPwlwYooYN5LDuTTloFRHHF+i1tWx3AQr424Fve4zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcUQsyS35Au9ga3dnA5AO2IJQlJ3SZvaVLq6Sz471gS2U5QcuVilMzpvrgTS3WLQ6
	 vT9RmDlg9ixN3fI40+vKdEI3NOyz6GutVWtuYMmKmPt/uyjmjdQdNV4YqkF7GNY03E
	 L/7sr8KCkbvkoYyDzwpIxeD432wVHOMwwsPeKYJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tan Tee Min <tee.min.tan@linux.intel.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/215] igc: remove I226 Qbv BaseTime restriction
Date: Sun,  1 Sep 2024 18:15:38 +0200
Message-ID: <20240901160824.251305556@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

[ Upstream commit b8897dc54e3bc9d25281bbb42a7d730782ff4588 ]

Remove the Qbv BaseTime restriction for I226 so that the BaseTime can be
scheduled to the future time. A new register bit of Tx Qav Control
(Bit-7: FutScdDis) was introduced to allow I226 scheduling future time as
Qbv BaseTime and not having the Tx hang timeout issue.

Besides, according to datasheet section 7.5.2.9.3.3, FutScdDis bit has to
be configured first before the cycle time and base time.

Indeed the FutScdDis bit is only active on re-configuration, thus we have
to set the BASET_L to zero and then only set it to the desired value.

Please also note that the Qbv configuration flow is moved around based on
the Qbv programming guideline that is documented in the latest datasheet.

Co-developed-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: e037a26ead18 ("igc: Fix packet still tx after gate close by reducing i226 MAC retry buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_base.c    | 29 +++++++++++++
 drivers/net/ethernet/intel/igc/igc_base.h    |  2 +
 drivers/net/ethernet/intel/igc/igc_defines.h |  1 +
 drivers/net/ethernet/intel/igc/igc_main.c    |  5 ++-
 drivers/net/ethernet/intel/igc/igc_tsn.c     | 44 +++++++++++++-------
 5 files changed, 65 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index 84f142f5e472e..be095c6531b68 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -402,6 +402,35 @@ void igc_rx_fifo_flush_base(struct igc_hw *hw)
 	rd32(IGC_MPC);
 }
 
+bool igc_is_device_id_i225(struct igc_hw *hw)
+{
+	switch (hw->device_id) {
+	case IGC_DEV_ID_I225_LM:
+	case IGC_DEV_ID_I225_V:
+	case IGC_DEV_ID_I225_I:
+	case IGC_DEV_ID_I225_K:
+	case IGC_DEV_ID_I225_K2:
+	case IGC_DEV_ID_I225_LMVP:
+	case IGC_DEV_ID_I225_IT:
+		return true;
+	default:
+		return false;
+	}
+}
+
+bool igc_is_device_id_i226(struct igc_hw *hw)
+{
+	switch (hw->device_id) {
+	case IGC_DEV_ID_I226_LM:
+	case IGC_DEV_ID_I226_V:
+	case IGC_DEV_ID_I226_K:
+	case IGC_DEV_ID_I226_IT:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static struct igc_mac_operations igc_mac_ops_base = {
 	.init_hw		= igc_init_hw_base,
 	.check_for_link		= igc_check_for_copper_link,
diff --git a/drivers/net/ethernet/intel/igc/igc_base.h b/drivers/net/ethernet/intel/igc/igc_base.h
index 52849f5e8048d..9f3827eda157c 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.h
+++ b/drivers/net/ethernet/intel/igc/igc_base.h
@@ -7,6 +7,8 @@
 /* forward declaration */
 void igc_rx_fifo_flush_base(struct igc_hw *hw);
 void igc_power_down_phy_copper_base(struct igc_hw *hw);
+bool igc_is_device_id_i225(struct igc_hw *hw);
+bool igc_is_device_id_i226(struct igc_hw *hw);
 
 /* Transmit Descriptor - Advanced */
 union igc_adv_tx_desc {
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 95282dde6b8bc..4f2021a940fb3 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -527,6 +527,7 @@
 /* Transmit Scheduling */
 #define IGC_TQAVCTRL_TRANSMIT_MODE_TSN	0x00000001
 #define IGC_TQAVCTRL_ENHANCED_QAV	0x00000008
+#define IGC_TQAVCTRL_FUTSCDDIS		0x00000080
 
 #define IGC_TXQCTL_QUEUE_MODE_LAUNCHT	0x00000001
 #define IGC_TXQCTL_STRICT_CYCLE		0x00000002
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index eb8c24318fdac..7605115e6a1b2 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5991,6 +5991,7 @@ static bool validate_schedule(struct igc_adapter *adapter,
 			      const struct tc_taprio_qopt_offload *qopt)
 {
 	int queue_uses[IGC_MAX_TX_QUEUES] = { };
+	struct igc_hw *hw = &adapter->hw;
 	struct timespec64 now;
 	size_t n;
 
@@ -6003,8 +6004,10 @@ static bool validate_schedule(struct igc_adapter *adapter,
 	 * in the future, it will hold all the packets until that
 	 * time, causing a lot of TX Hangs, so to avoid that, we
 	 * reject schedules that would start in the future.
+	 * Note: Limitation above is no longer in i226.
 	 */
-	if (!is_base_time_past(qopt->base_time, &now))
+	if (!is_base_time_past(qopt->base_time, &now) &&
+	    igc_is_device_id_i225(hw))
 		return false;
 
 	for (n = 0; n < qopt->num_entries; n++) {
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 93518c785c7d2..066444675aade 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -2,6 +2,7 @@
 /* Copyright (c)  2019 Intel Corporation */
 
 #include "igc.h"
+#include "igc_hw.h"
 #include "igc_tsn.h"
 
 static bool is_any_launchtime(struct igc_adapter *adapter)
@@ -92,7 +93,8 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 
 	tqavctrl = rd32(IGC_TQAVCTRL);
 	tqavctrl &= ~(IGC_TQAVCTRL_TRANSMIT_MODE_TSN |
-		      IGC_TQAVCTRL_ENHANCED_QAV);
+		      IGC_TQAVCTRL_ENHANCED_QAV | IGC_TQAVCTRL_FUTSCDDIS);
+
 	wr32(IGC_TQAVCTRL, tqavctrl);
 
 	for (i = 0; i < adapter->num_tx_queues; i++) {
@@ -117,20 +119,10 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 	ktime_t base_time, systim;
 	int i;
 
-	cycle = adapter->cycle_time;
-	base_time = adapter->base_time;
-
 	wr32(IGC_TSAUXC, 0);
 	wr32(IGC_DTXMXPKTSZ, IGC_DTXMXPKTSZ_TSN);
 	wr32(IGC_TXPBS, IGC_TXPBSIZE_TSN);
 
-	tqavctrl = rd32(IGC_TQAVCTRL);
-	tqavctrl |= IGC_TQAVCTRL_TRANSMIT_MODE_TSN | IGC_TQAVCTRL_ENHANCED_QAV;
-	wr32(IGC_TQAVCTRL, tqavctrl);
-
-	wr32(IGC_QBVCYCLET_S, cycle);
-	wr32(IGC_QBVCYCLET, cycle);
-
 	for (i = 0; i < adapter->num_tx_queues; i++) {
 		struct igc_ring *ring = adapter->tx_ring[i];
 		u32 txqctl = 0;
@@ -233,21 +225,43 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 		wr32(IGC_TXQCTL(i), txqctl);
 	}
 
+	tqavctrl = rd32(IGC_TQAVCTRL);
+	tqavctrl |= IGC_TQAVCTRL_TRANSMIT_MODE_TSN | IGC_TQAVCTRL_ENHANCED_QAV;
+
+	cycle = adapter->cycle_time;
+	base_time = adapter->base_time;
+
 	nsec = rd32(IGC_SYSTIML);
 	sec = rd32(IGC_SYSTIMH);
 
 	systim = ktime_set(sec, nsec);
-
 	if (ktime_compare(systim, base_time) > 0) {
-		s64 n;
+		s64 n = div64_s64(ktime_sub_ns(systim, base_time), cycle);
 
-		n = div64_s64(ktime_sub_ns(systim, base_time), cycle);
 		base_time = ktime_add_ns(base_time, (n + 1) * cycle);
+	} else {
+		/* According to datasheet section 7.5.2.9.3.3, FutScdDis bit
+		 * has to be configured before the cycle time and base time.
+		 */
+		if (igc_is_device_id_i226(hw))
+			tqavctrl |= IGC_TQAVCTRL_FUTSCDDIS;
 	}
 
-	baset_h = div_s64_rem(base_time, NSEC_PER_SEC, &baset_l);
+	wr32(IGC_TQAVCTRL, tqavctrl);
+
+	wr32(IGC_QBVCYCLET_S, cycle);
+	wr32(IGC_QBVCYCLET, cycle);
 
+	baset_h = div_s64_rem(base_time, NSEC_PER_SEC, &baset_l);
 	wr32(IGC_BASET_H, baset_h);
+
+	/* In i226, Future base time is only supported when FutScdDis bit
+	 * is enabled and only active for re-configuration.
+	 * In this case, initialize the base time with zero to create
+	 * "re-configuration" scenario then only set the desired base time.
+	 */
+	if (tqavctrl & IGC_TQAVCTRL_FUTSCDDIS)
+		wr32(IGC_BASET_L, 0);
 	wr32(IGC_BASET_L, baset_l);
 
 	return 0;
-- 
2.43.0



