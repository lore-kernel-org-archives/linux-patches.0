Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807F515484
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fe5LdUHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB23C433C8;
	Mon, 23 Oct 2023 11:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059990;
	bh=SMJr7FbW95kA4WpSWcWzWzFSp7nKaEOGdTkAWV9t8Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fe5LdUHQrkzDFPIl+zTsu/DD0ZhqYmFmkEJ1Z2xCGVq7ps0fac8EGbKMcpeQzUZIV
	 dIXRj/GLs/fUGWtw+C/Oue/aUT3nE2TpnQiyuoKr2yO+lkPQC97W0/p2xb5M+/FUE6
	 Np2LCMwMzfqIvSfrS1AySSi43Qd4H7QFnDQur61o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.1 005/196] igc: Add qbv_config_change_errors counter
Date: Mon, 23 Oct 2023 12:54:30 +0200
Message-ID: <20231023104828.640779088@linuxfoundation.org>
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

commit ae4fe46983007bc46d87dcb284a5e5851c3e1c84 upstream.

Add ConfigChangeError(qbv_config_change_errors) when user try to set the
AdminBaseTime to past value while the current GCL is still running.

The ConfigChangeError counter should not be increased when a gate control
list is scheduled into the future.

User can use "ethtool -S <interface> | grep qbv_config_change_errors"
command to check the counter values.

Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igc/igc.h         |    1 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c |    1 +
 drivers/net/ethernet/intel/igc/igc_main.c    |    1 +
 drivers/net/ethernet/intel/igc/igc_tsn.c     |   12 ++++++++++++
 4 files changed, 15 insertions(+)

--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -186,6 +186,7 @@ struct igc_adapter {
 	ktime_t base_time;
 	ktime_t cycle_time;
 	bool qbv_enable;
+	u32 qbv_config_change_errors;
 
 	/* OS defined structs */
 	struct pci_dev *pdev;
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -67,6 +67,7 @@ static const struct igc_stats igc_gstrin
 	IGC_STAT("rx_hwtstamp_cleared", rx_hwtstamp_cleared),
 	IGC_STAT("tx_lpi_counter", stats.tlpic),
 	IGC_STAT("rx_lpi_counter", stats.rlpic),
+	IGC_STAT("qbv_config_change_errors", qbv_config_change_errors),
 };
 
 #define IGC_NETDEV_STAT(_net_stat) { \
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6106,6 +6106,7 @@ static int igc_tsn_clear_schedule(struct
 
 	adapter->base_time = 0;
 	adapter->cycle_time = NSEC_PER_SEC;
+	adapter->qbv_config_change_errors = 0;
 
 	for (i = 0; i < adapter->num_tx_queues; i++) {
 		struct igc_ring *ring = adapter->tx_ring[i];
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -84,6 +84,7 @@ static int igc_tsn_disable_offload(struc
 static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
+	bool tsn_mode_reconfig = false;
 	u32 tqavctrl, baset_l, baset_h;
 	u32 sec, nsec, cycle;
 	ktime_t base_time, systim;
@@ -196,6 +197,10 @@ skip_cbs:
 	}
 
 	tqavctrl = rd32(IGC_TQAVCTRL) & ~IGC_TQAVCTRL_FUTSCDDIS;
+
+	if (tqavctrl & IGC_TQAVCTRL_TRANSMIT_MODE_TSN)
+		tsn_mode_reconfig = true;
+
 	tqavctrl |= IGC_TQAVCTRL_TRANSMIT_MODE_TSN | IGC_TQAVCTRL_ENHANCED_QAV;
 
 	cycle = adapter->cycle_time;
@@ -209,6 +214,13 @@ skip_cbs:
 		s64 n = div64_s64(ktime_sub_ns(systim, base_time), cycle);
 
 		base_time = ktime_add_ns(base_time, (n + 1) * cycle);
+
+		/* Increase the counter if scheduling into the past while
+		 * Gate Control List (GCL) is running.
+		 */
+		if ((rd32(IGC_BASET_H) || rd32(IGC_BASET_L)) &&
+		    tsn_mode_reconfig)
+			adapter->qbv_config_change_errors++;
 	} else {
 		/* According to datasheet section 7.5.2.9.3.3, FutScdDis bit
 		 * has to be configured before the cycle time and base time.


