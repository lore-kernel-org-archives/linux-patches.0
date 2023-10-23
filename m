Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7949115484
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxlnKXOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4562C433C7;
	Mon, 23 Oct 2023 11:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059981;
	bh=NuLOjatT2690W5n/TceQOxtxbW/Uegw5caIfb8oWP60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxlnKXOiI0dCvHFMLmki31KK9urwRNi/RJeZb3UAFf+YcNixcgJIoDGJsDjoeseyD
	 brMzggMJeqOM4d89sYlru9smtvznzCxh5vEa6t1MK8dEC2sS9Kro8xfL9zTk7gedhz
	 +tN+jpwBkLAHlEixKsOtBym3TWhSukvWAN2Ob1DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tan Tee Min <tee.min.tan@linux.intel.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.1 002/196] igc: remove I226 Qbv BaseTime restriction
Date: Mon, 23 Oct 2023 12:54:27 +0200
Message-ID: <20231023104828.560245055@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

commit b8897dc54e3bc9d25281bbb42a7d730782ff4588 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igc/igc_base.c    |   29 +++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_base.h    |    2 +
 drivers/net/ethernet/intel/igc/igc_defines.h |    1 
 drivers/net/ethernet/intel/igc/igc_main.c    |    5 ++-
 drivers/net/ethernet/intel/igc/igc_tsn.c     |   44 +++++++++++++++++----------
 5 files changed, 65 insertions(+), 16 deletions(-)

--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -396,6 +396,35 @@ void igc_rx_fifo_flush_base(struct igc_h
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
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -515,6 +515,7 @@
 /* Transmit Scheduling */
 #define IGC_TQAVCTRL_TRANSMIT_MODE_TSN	0x00000001
 #define IGC_TQAVCTRL_ENHANCED_QAV	0x00000008
+#define IGC_TQAVCTRL_FUTSCDDIS		0x00000080
 
 #define IGC_TXQCTL_QUEUE_MODE_LAUNCHT	0x00000001
 #define IGC_TXQCTL_STRICT_CYCLE		0x00000002
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6035,6 +6035,7 @@ static bool validate_schedule(struct igc
 			      const struct tc_taprio_qopt_offload *qopt)
 {
 	int queue_uses[IGC_MAX_TX_QUEUES] = { };
+	struct igc_hw *hw = &adapter->hw;
 	struct timespec64 now;
 	size_t n;
 
@@ -6047,8 +6048,10 @@ static bool validate_schedule(struct igc
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
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -2,6 +2,7 @@
 /* Copyright (c)  2019 Intel Corporation */
 
 #include "igc.h"
+#include "igc_hw.h"
 #include "igc_tsn.h"
 
 static bool is_any_launchtime(struct igc_adapter *adapter)
@@ -62,7 +63,8 @@ static int igc_tsn_disable_offload(struc
 
 	tqavctrl = rd32(IGC_TQAVCTRL);
 	tqavctrl &= ~(IGC_TQAVCTRL_TRANSMIT_MODE_TSN |
-		      IGC_TQAVCTRL_ENHANCED_QAV);
+		      IGC_TQAVCTRL_ENHANCED_QAV | IGC_TQAVCTRL_FUTSCDDIS);
+
 	wr32(IGC_TQAVCTRL, tqavctrl);
 
 	for (i = 0; i < adapter->num_tx_queues; i++) {
@@ -87,20 +89,10 @@ static int igc_tsn_enable_offload(struct
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
@@ -203,21 +195,43 @@ skip_cbs:
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


