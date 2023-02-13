Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15978F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781E9C4339B;
	Mon, 13 Feb 2023 14:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300341;
	bh=mIjf3ZqVHPgpkRPH6h9Ftih37dSotH6SKZd+nhZYJTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTL2+xhTOGa8idRjdLFouNusvD4T+fAZzlWzWDgkvcGuu5V8Oas8VxwOm+kun0AQU
	 yyQPBRBn1jB3JRa+ByaEUEQCSdy9K1D43o4y1b400+p0/54CjLOnp9Dhm5oHIoFiXP
	 AsOrCnajd4VV0qYbx0dTar9lZOYfK5aHXZCzRuw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Neftin <sasha.neftin@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 38/67] igc: Add ndo_tx_timeout support
Date: Mon, 13 Feb 2023 15:49:19 +0100
Message-Id: <20230213144734.182620041@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
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
index 3726c8413c741..bde3fea2c442e 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2892,7 +2892,9 @@ static bool igc_clean_tx_irq(struct igc_q_vector *q_vector, int napi_budget)
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
@@ -5019,6 +5021,24 @@ static int igc_change_mtu(struct net_device *netdev, int new_mtu)
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
@@ -5446,7 +5466,7 @@ static void igc_watchdog_task(struct work_struct *work)
 			case SPEED_100:
 			case SPEED_1000:
 			case SPEED_2500:
-				adapter->tx_timeout_factor = 7;
+				adapter->tx_timeout_factor = 1;
 				break;
 			}
 
@@ -6264,6 +6284,7 @@ static const struct net_device_ops igc_netdev_ops = {
 	.ndo_set_rx_mode	= igc_set_rx_mode,
 	.ndo_set_mac_address	= igc_set_mac,
 	.ndo_change_mtu		= igc_change_mtu,
+	.ndo_tx_timeout		= igc_tx_timeout,
 	.ndo_get_stats64	= igc_get_stats64,
 	.ndo_fix_features	= igc_fix_features,
 	.ndo_set_features	= igc_set_features,
-- 
2.39.0



