Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB88B8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C080C433EF;
	Mon, 13 Feb 2023 14:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300075;
	bh=tZaWJ5H3qm0ZMPi2E3N7e6IwUbJ+SWaGkuA3WNusPtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvSQMdQe+mzFB0ThKSttReU0DyV8IXdRf/nX0jOmc3sIbIVrQd7cFSIpigpgeXE1g
	 GEkmU//+5BU407nSiVVNHKGmFqF0PfZaPzUV7HnH2ij30NHa3XWlPhldsGPEvLexBe
	 7Cd1NQXjEoIozae8OjMCJ8Ut6GpOhn9D4GJ4fEBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Neftin <sasha.neftin@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/114] igc: Add ndo_tx_timeout support
Date: Mon, 13 Feb 2023 15:48:09 +0100
Message-Id: <20230213144745.015411156@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sasha Neftin <sasha.neftin@intel.com>

[ Upstream commit 9b275176270efd18f2f4e328b32be1bad34c4c0d ]

On some platforms, 100/1000/2500 speeds seem to have sometimes problems
reporting false positive tx unit hang during stressful UDP traffic. Likely
other Intel drivers introduce responses to a tx hang. Update the 'tx hang'
comparator with the comparison of the head and tail of ring pointers and
restore the tx_timeout_factor to the previous value (one).

This can be test by using netperf or iperf3 applications.
Example:
iperf3 -s -p 5001
iperf3 -c 192.168.0.2 --udp -p 5001 --time 600 -b 0

netserver -p 16604
netperf -H 192.168.0.2 -l 600 -p 16604 -t UDP_STREAM -- -m 64000

Fixes: b27b8dc77b5e ("igc: Increase timeout value for Speed 100/1000/2500")
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20230206235818.662384-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 25 +++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 34db1c006b20a..3b5b36206c44b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2942,7 +2942,9 @@ static bool igc_clean_tx_irq(struct igc_q_vector *q_vector, int napi_budget)
 		if (tx_buffer->next_to_watch &&
 		    time_after(jiffies, tx_buffer->time_stamp +
 		    (adapter->tx_timeout_factor * HZ)) &&
-		    !(rd32(IGC_STATUS) & IGC_STATUS_TXOFF)) {
+		    !(rd32(IGC_STATUS) & IGC_STATUS_TXOFF) &&
+		    (rd32(IGC_TDH(tx_ring->reg_idx)) !=
+		     readl(tx_ring->tail))) {
 			/* detected Tx unit hang */
 			netdev_err(tx_ring->netdev,
 				   "Detected Tx Unit Hang\n"
@@ -5068,6 +5070,24 @@ static int igc_change_mtu(struct net_device *netdev, int new_mtu)
 	return 0;
 }
 
+/**
+ * igc_tx_timeout - Respond to a Tx Hang
+ * @netdev: network interface device structure
+ * @txqueue: queue number that timed out
+ **/
+static void igc_tx_timeout(struct net_device *netdev,
+			   unsigned int __always_unused txqueue)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	struct igc_hw *hw = &adapter->hw;
+
+	/* Do the reset outside of interrupt context */
+	adapter->tx_timeout_count++;
+	schedule_work(&adapter->reset_task);
+	wr32(IGC_EICS,
+	     (adapter->eims_enable_mask & ~adapter->eims_other));
+}
+
 /**
  * igc_get_stats64 - Get System Network Statistics
  * @netdev: network interface device structure
@@ -5495,7 +5515,7 @@ static void igc_watchdog_task(struct work_struct *work)
 			case SPEED_100:
 			case SPEED_1000:
 			case SPEED_2500:
-				adapter->tx_timeout_factor = 7;
+				adapter->tx_timeout_factor = 1;
 				break;
 			}
 
@@ -6313,6 +6333,7 @@ static const struct net_device_ops igc_netdev_ops = {
 	.ndo_set_rx_mode	= igc_set_rx_mode,
 	.ndo_set_mac_address	= igc_set_mac,
 	.ndo_change_mtu		= igc_change_mtu,
+	.ndo_tx_timeout		= igc_tx_timeout,
 	.ndo_get_stats64	= igc_get_stats64,
 	.ndo_fix_features	= igc_fix_features,
 	.ndo_set_features	= igc_set_features,
-- 
2.39.0



