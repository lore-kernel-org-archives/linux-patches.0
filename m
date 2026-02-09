Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF9137997A;
	Mon,  9 Feb 2026 14:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648723; cv=none; b=G9aD3UPnx/q7E+HaGg7JyoR1KKDjRDe2t43Sk5Q5Wq2XDBP7s66b/uNshOqZXQvnGU3cePCHKHyhVC6SXO95yUFrpKd8X3ii4zHtqeu/RmToBCAMZmnmO8Jvgao8Ufunbg9NPv1+V7csDm/8x22Fj6C8Ya8vIpuBEN/JPI/aI6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648723; c=relaxed/simple;
	bh=Q0VPcTWBsdmzMxNexktaLoAViUMz4wWc/fs94gcf/4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEH6wj2m2hFvdIxSN0jToKU8tzzj93bfBc4hKQi6cZUDubemEVsic6Z40NJBGqT2DjbTWiFuWoUrdEOWEnJjBLLDGBcbsyW0apDQ8J+U1MTK5+kDRgMsOLPybfyF1PwDVjOMd74U8S2cRz0lw1y/D1XHYr2QLqRrBzrk3UXV46E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KALLc2GU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KALLc2GU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F3FC116C6;
	Mon,  9 Feb 2026 14:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648723;
	bh=Q0VPcTWBsdmzMxNexktaLoAViUMz4wWc/fs94gcf/4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KALLc2GU9gJVEUCJfdDo43Xmc392WutufKTr9wbnVbUfcqTHaS6iN9Au/5FuUIvII
	 Zs0DFJ7HrnO21K0jG/E+dYKinTs1C4dpj35Le2wZLykBz4CfjrkBSBCximL81ihXCm
	 JO3btqYNOavev2GIOXVorkkBrJ8/eMsnWKS/Yegg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Debarghya Kundu <debarghyak@google.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 38/41] gve: Fix stats report corruption on queue count change
Date: Mon,  9 Feb 2026 15:24:59 +0100
Message-ID: <20260209142258.191326277@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Debarghya Kundu <debarghyak@google.com>

[ Upstream commit 7b9ebcce0296e104a0d82a6b09d68564806158ff ]

The driver and the NIC share a region in memory for stats reporting.
The NIC calculates its offset into this region based on the total size
of the stats region and the size of the NIC's stats.

When the number of queues is changed, the driver's stats region is
resized. If the queue count is increased, the NIC can write past
the end of the allocated stats region, causing memory corruption.
If the queue count is decreased, there is a gap between the driver
and NIC stats, leading to incorrect stats reporting.

This change fixes the issue by allocating stats region with maximum
size, and the offset calculation for NIC stats is changed to match
with the calculation of the NIC.

Cc: stable@vger.kernel.org
Fixes: 24aeb56f2d38 ("gve: Add Gvnic stats AQ command and ethtool show/set-priv-flags.")
Signed-off-by: Debarghya Kundu <debarghyak@google.com>
Reviewed-by: Joshua Washington <joshwash@google.com>
Signed-off-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260202193925.3106272-2-hramamurthy@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Same changes as 6.1 + context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c |   42 +++++++++++++++++---------
 drivers/net/ethernet/google/gve/gve_main.c    |    4 +-
 2 files changed, 31 insertions(+), 15 deletions(-)

--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -140,7 +140,8 @@ gve_get_ethtool_stats(struct net_device
 		tmp_rx_desc_err_dropped_pkt, tmp_tx_pkts, tmp_tx_bytes;
 	u64 rx_buf_alloc_fail, rx_desc_err_dropped_pkt, rx_pkts,
 		rx_skb_alloc_fail, rx_bytes, tx_pkts, tx_bytes;
-	int stats_idx, base_stats_idx, max_stats_idx;
+	int rx_base_stats_idx, max_rx_stats_idx, max_tx_stats_idx;
+	int stats_idx, stats_region_len, nic_stats_len;
 	struct stats *report_stats;
 	int *rx_qid_to_stats_idx;
 	int *tx_qid_to_stats_idx;
@@ -226,14 +227,33 @@ gve_get_ethtool_stats(struct net_device
 	data[i++] = priv->stats_report_trigger_cnt;
 	i = GVE_MAIN_STATS_LEN;
 
-	/* For rx cross-reporting stats, start from nic rx stats in report */
-	base_stats_idx = GVE_TX_STATS_REPORT_NUM * priv->tx_cfg.num_queues +
-		GVE_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues;
-	max_stats_idx = NIC_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues +
-		base_stats_idx;
+	rx_base_stats_idx = 0;
+	max_rx_stats_idx = 0;
+	max_tx_stats_idx = 0;
+	stats_region_len = priv->stats_report_len -
+				sizeof(struct gve_stats_report);
+	nic_stats_len = (NIC_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues +
+		NIC_TX_STATS_REPORT_NUM * priv->tx_cfg.num_queues) *
+		sizeof(struct stats);
+	if (unlikely((stats_region_len -
+				nic_stats_len) % sizeof(struct stats))) {
+		net_err_ratelimited("Starting index of NIC stats should be multiple of stats size");
+	} else {
+		/* For rx cross-reporting stats,
+		 * start from nic rx stats in report
+		 */
+		rx_base_stats_idx = (stats_region_len - nic_stats_len) /
+							sizeof(struct stats);
+		max_rx_stats_idx = NIC_RX_STATS_REPORT_NUM *
+			priv->rx_cfg.num_queues +
+			rx_base_stats_idx;
+		max_tx_stats_idx = NIC_TX_STATS_REPORT_NUM *
+			priv->tx_cfg.num_queues +
+			max_rx_stats_idx;
+	}
 	/* Preprocess the stats report for rx, map queue id to start index */
 	skip_nic_stats = false;
-	for (stats_idx = base_stats_idx; stats_idx < max_stats_idx;
+	for (stats_idx = rx_base_stats_idx; stats_idx < max_rx_stats_idx;
 		stats_idx += NIC_RX_STATS_REPORT_NUM) {
 		u32 stat_name = be32_to_cpu(report_stats[stats_idx].stat_name);
 		u32 queue_id = be32_to_cpu(report_stats[stats_idx].queue_id);
@@ -286,13 +306,9 @@ gve_get_ethtool_stats(struct net_device
 		i += priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS;
 	}
 
-	/* For tx cross-reporting stats, start from nic tx stats in report */
-	base_stats_idx = max_stats_idx;
-	max_stats_idx = NIC_TX_STATS_REPORT_NUM * priv->tx_cfg.num_queues +
-		max_stats_idx;
-	/* Preprocess the stats report for tx, map queue id to start index */
 	skip_nic_stats = false;
-	for (stats_idx = base_stats_idx; stats_idx < max_stats_idx;
+	/* NIC TX stats start right after NIC RX stats */
+	for (stats_idx = max_rx_stats_idx; stats_idx < max_tx_stats_idx;
 		stats_idx += NIC_TX_STATS_REPORT_NUM) {
 		u32 stat_name = be32_to_cpu(report_stats[stats_idx].stat_name);
 		u32 queue_id = be32_to_cpu(report_stats[stats_idx].queue_id);
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -124,9 +124,9 @@ static int gve_alloc_stats_report(struct
 	int tx_stats_num, rx_stats_num;
 
 	tx_stats_num = (GVE_TX_STATS_REPORT_NUM + NIC_TX_STATS_REPORT_NUM) *
-		       priv->tx_cfg.num_queues;
+				priv->tx_cfg.max_queues;
 	rx_stats_num = (GVE_RX_STATS_REPORT_NUM + NIC_RX_STATS_REPORT_NUM) *
-		       priv->rx_cfg.num_queues;
+				priv->rx_cfg.max_queues;
 	priv->stats_report_len = struct_size(priv->stats_report, stats,
 					     size_add(tx_stats_num, rx_stats_num));
 	priv->stats_report =


