Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21A537A488;
	Mon,  9 Feb 2026 14:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648405; cv=none; b=qmQoJ/acucCYzE+9mpIHzJyNrhjUPu4uHE8uR27VJw4h3imV4kU3FJIG1B5Y5/8l9JJskYFa7DAKkAh2fiLEzE3z1+s+pz8Hh+zzqr2QivCkmturve3C2U60IX6o7JDfwuMb2EYubFPDXj/oemFxSJ+pKXTds3Mrwx56X7lYAD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648405; c=relaxed/simple;
	bh=ImvAQWU6W1UX0gFcNFtpk+q3R967r7QLb8J4aV8sbtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqeFYOvPjqzHPB8lzSv54WmTK/qTL6JjsZNHTGI1v3/y+dnvsQ3oOigEMEvZQKcUzkHDYUTfAwG+2DaOn8tyCxQph+CZ6wM+9J+GVG7RqodPyW4nIPSRjdCBG9bfzgnLxANnU+ZccTFPiITR65LgoyQSdM0ZEauLIq2x+lZ6ZBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DW2MufU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DW2MufU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D287C16AAE;
	Mon,  9 Feb 2026 14:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648404;
	bh=ImvAQWU6W1UX0gFcNFtpk+q3R967r7QLb8J4aV8sbtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DW2MufU15eFC6tYiqSuRb/X+ZFeC+nsmpRr6vxW8m6aVVqv2B9WC4nzwTXv/xh2OF
	 vacbRzLkXlQk9jnD3TzioOUAdmpUW8kTtY5mmcQDKi9e5zLHhp00oeyuEtau9Mgu23
	 rlTWhME/yv0XA7ndmGgSXqvYtDDrOeerY9Ark/X8=
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
Subject: [PATCH 6.6 20/86] gve: Fix stats report corruption on queue count change
Date: Mon,  9 Feb 2026 15:23:43 +0100
Message-ID: <20260209142305.506720279@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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
[ no stopped-queue feature in older trees ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c |   41 +++++++++++++++++---------
 drivers/net/ethernet/google/gve/gve_main.c    |    4 +-
 2 files changed, 30 insertions(+), 15 deletions(-)

--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -159,7 +159,8 @@ gve_get_ethtool_stats(struct net_device
 		tmp_tx_pkts, tmp_tx_bytes;
 	u64 rx_buf_alloc_fail, rx_desc_err_dropped_pkt, rx_pkts,
 		rx_skb_alloc_fail, rx_bytes, tx_pkts, tx_bytes, tx_dropped;
-	int stats_idx, base_stats_idx, max_stats_idx;
+	int rx_base_stats_idx, max_rx_stats_idx, max_tx_stats_idx;
+	int stats_idx, stats_region_len, nic_stats_len;
 	struct stats *report_stats;
 	int *rx_qid_to_stats_idx;
 	int *tx_qid_to_stats_idx;
@@ -246,14 +247,32 @@ gve_get_ethtool_stats(struct net_device
 	data[i++] = priv->stats_report_trigger_cnt;
 	i = GVE_MAIN_STATS_LEN;
 
-	/* For rx cross-reporting stats, start from nic rx stats in report */
-	base_stats_idx = GVE_TX_STATS_REPORT_NUM * num_tx_queues +
-		GVE_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues;
-	max_stats_idx = NIC_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues +
-		base_stats_idx;
+	rx_base_stats_idx = 0;
+	max_rx_stats_idx = 0;
+	max_tx_stats_idx = 0;
+	stats_region_len = priv->stats_report_len -
+				sizeof(struct gve_stats_report);
+	nic_stats_len = (NIC_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues +
+		NIC_TX_STATS_REPORT_NUM * num_tx_queues) * sizeof(struct stats);
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
+			num_tx_queues +
+			max_rx_stats_idx;
+	}
 	/* Preprocess the stats report for rx, map queue id to start index */
 	skip_nic_stats = false;
-	for (stats_idx = base_stats_idx; stats_idx < max_stats_idx;
+	for (stats_idx = rx_base_stats_idx; stats_idx < max_rx_stats_idx;
 		stats_idx += NIC_RX_STATS_REPORT_NUM) {
 		u32 stat_name = be32_to_cpu(report_stats[stats_idx].stat_name);
 		u32 queue_id = be32_to_cpu(report_stats[stats_idx].queue_id);
@@ -323,13 +342,9 @@ gve_get_ethtool_stats(struct net_device
 		i += priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS;
 	}
 
-	/* For tx cross-reporting stats, start from nic tx stats in report */
-	base_stats_idx = max_stats_idx;
-	max_stats_idx = NIC_TX_STATS_REPORT_NUM * num_tx_queues +
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
@@ -186,9 +186,9 @@ static int gve_alloc_stats_report(struct
 	int tx_stats_num, rx_stats_num;
 
 	tx_stats_num = (GVE_TX_STATS_REPORT_NUM + NIC_TX_STATS_REPORT_NUM) *
-		       gve_num_tx_queues(priv);
+				priv->tx_cfg.max_queues;
 	rx_stats_num = (GVE_RX_STATS_REPORT_NUM + NIC_RX_STATS_REPORT_NUM) *
-		       priv->rx_cfg.num_queues;
+				priv->rx_cfg.max_queues;
 	priv->stats_report_len = struct_size(priv->stats_report, stats,
 					     size_add(tx_stats_num, rx_stats_num));
 	priv->stats_report =


