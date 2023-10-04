Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7E91D6B0
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yb8f062D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC66C433CC;
	Wed,  4 Oct 2023 18:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444018;
	bh=8+tG61t4Og3P/xaY/R1aOzVCPQR+P6J6n0XruEYnAek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yb8f062D3TDB/WtXFMXGKbVmapCZL8FEoallO9ewZbLAC94qqPlOjM6go5FwrXC6a
	 7axGWfCizX9mEdbrug3NXEn1y1L8k7Ft6l0M+n07UZbn2XKNWMh3f3R4NW4K+dnxkw
	 A9uZObTqfXpgUewq3DOyMSFF5wcOqIbsoBF0mMoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 102/321] igc: Expose tx-usecs coalesce setting to user
Date: Wed,  4 Oct 2023 19:54:07 +0200
Message-ID: <20231004175233.963959620@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

[ Upstream commit 1703b2e0de653b459ca6230be32ce7f2ea0ae7ee ]

When users attempt to obtain the coalesce setting using the
ethtool command, current code always returns 0 for tx-usecs.
This is because I225/6 always uses a queue pair setting, hence
tx_coalesce_usecs does not return a value during the
igc_ethtool_get_coalesce() callback process. The pair queue
condition checking in igc_ethtool_get_coalesce() is removed by
this patch so that the user gets information of the value of tx-usecs.

Even if i225/6 is using queue pair setting, there is no harm in
notifying the user of the tx-usecs. The implementation of the current
code may have previously been a copy of the legacy code i210.
Since I225 has the queue pair setting enabled, tx-usecs will always adhere
to the user-set rx-usecs value. An error message will appear when the user
attempts to set the tx-usecs value for the input parameters because,
by default, they should only set the rx-usecs value.

This patch also adds the helper function to get the
previous rx coalesce value similar to tx coalesce.

How to test:
User can get the coalesce value using ethtool command.

Example command:
Get: ethtool -c <interface>

Previous output:

rx-usecs: 3
rx-frames: n/a
rx-usecs-irq: n/a
rx-frames-irq: n/a

tx-usecs: 0
tx-frames: n/a
tx-usecs-irq: n/a
tx-frames-irq: n/a

New output:

rx-usecs: 3
rx-frames: n/a
rx-usecs-irq: n/a
rx-frames-irq: n/a

tx-usecs: 3
tx-frames: n/a
tx-usecs-irq: n/a
tx-frames-irq: n/a

Fixes: 8c5ad0dae93c ("igc: Add ethtool support")
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20230919170331.1581031-1-anthony.l.nguyen@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 31 ++++++++++++--------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 93bce729be76a..7ab6dd58e4001 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -868,6 +868,18 @@ static void igc_ethtool_get_stats(struct net_device *netdev,
 	spin_unlock(&adapter->stats64_lock);
 }
 
+static int igc_ethtool_get_previous_rx_coalesce(struct igc_adapter *adapter)
+{
+	return (adapter->rx_itr_setting <= 3) ?
+		adapter->rx_itr_setting : adapter->rx_itr_setting >> 2;
+}
+
+static int igc_ethtool_get_previous_tx_coalesce(struct igc_adapter *adapter)
+{
+	return (adapter->tx_itr_setting <= 3) ?
+		adapter->tx_itr_setting : adapter->tx_itr_setting >> 2;
+}
+
 static int igc_ethtool_get_coalesce(struct net_device *netdev,
 				    struct ethtool_coalesce *ec,
 				    struct kernel_ethtool_coalesce *kernel_coal,
@@ -875,17 +887,8 @@ static int igc_ethtool_get_coalesce(struct net_device *netdev,
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
-	if (adapter->rx_itr_setting <= 3)
-		ec->rx_coalesce_usecs = adapter->rx_itr_setting;
-	else
-		ec->rx_coalesce_usecs = adapter->rx_itr_setting >> 2;
-
-	if (!(adapter->flags & IGC_FLAG_QUEUE_PAIRS)) {
-		if (adapter->tx_itr_setting <= 3)
-			ec->tx_coalesce_usecs = adapter->tx_itr_setting;
-		else
-			ec->tx_coalesce_usecs = adapter->tx_itr_setting >> 2;
-	}
+	ec->rx_coalesce_usecs = igc_ethtool_get_previous_rx_coalesce(adapter);
+	ec->tx_coalesce_usecs = igc_ethtool_get_previous_tx_coalesce(adapter);
 
 	return 0;
 }
@@ -910,8 +913,12 @@ static int igc_ethtool_set_coalesce(struct net_device *netdev,
 	    ec->tx_coalesce_usecs == 2)
 		return -EINVAL;
 
-	if ((adapter->flags & IGC_FLAG_QUEUE_PAIRS) && ec->tx_coalesce_usecs)
+	if ((adapter->flags & IGC_FLAG_QUEUE_PAIRS) &&
+	    ec->tx_coalesce_usecs != igc_ethtool_get_previous_tx_coalesce(adapter)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Queue Pair mode enabled, both Rx and Tx coalescing controlled by rx-usecs");
 		return -EINVAL;
+	}
 
 	/* If ITR is disabled, disable DMAC */
 	if (ec->rx_coalesce_usecs == 0) {
-- 
2.40.1



