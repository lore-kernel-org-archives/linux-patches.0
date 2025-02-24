Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A670824A3;
	Mon, 24 Feb 2025 14:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408529; cv=none; b=RxpUcIdNJnn54n16TKa67AzXOlwu4kbETd+r9x/uqhA3oAw9+dxAmVHLnoPj2kW2xB7mcunvYyhFprGcc/FCTVnY/PcB7tB4ZeFx86YrXeV0927mVM8EiIEErW3aRNHGByw0dG+yZ7H88SDFtLazT16Yewbr09cb6U+GNgxBsYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408529; c=relaxed/simple;
	bh=hvLopu9rYW3y5+Ez9k4j3CtxZ0xV4WjgZQ0KCyjXiBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqP+ra30btzoAVX5/wOjbgxE9JNc4O5EBrin2zR5mGBzLKcyBfiabTSLCOUOiQVzpaNu8XD+PqniKZFdWHiU+rKy90qRxyrHqfbk3miLi6lammeUNBf3mzEiP9f4cMDIYifluViinFBIXnISnxCnOcvpogAv/ty0p/yxH5ODo0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahstDnYC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahstDnYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B1FC4CED6;
	Mon, 24 Feb 2025 14:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408529;
	bh=hvLopu9rYW3y5+Ez9k4j3CtxZ0xV4WjgZQ0KCyjXiBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahstDnYC1JuqHdF0mnF1mq8ACxnRAhT8QdlSqW0eIH4dFB5VfsWTonYvu5KGVU35E
	 n/NNoqtFhNJ0JWWKAIcULrMGmVQv/S0mzj+ci3ZSv8NNK4blNq5usJMRgTyXw2SLhq
	 OIWmmTw0bbVs3RGscu/LNtX27h5m943NhJQcf5q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/154] ibmvnic: Add stat for tx direct vs tx batched
Date: Mon, 24 Feb 2025 15:34:16 +0100
Message-ID: <20250224142609.319606832@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Child <nnac123@linux.ibm.com>

[ Upstream commit 2ee73c54a615b74d2e7ee6f20844fd3ba63fc485 ]

Allow tracking of packets sent with send_subcrq direct vs
indirect. `ethtool -S <dev>` will now provide a counter
of the number of uses of each xmit method. This metric will
be useful in performance debugging.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241001163531.1803152-1-nnac123@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: bdf5d13aa05e ("ibmvnic: Don't reference skb after sending to VIOS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 23 ++++++++++++++++-------
 drivers/net/ethernet/ibm/ibmvnic.h |  3 ++-
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 97425c06e1ed7..cca2ed6ad2899 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2310,7 +2310,7 @@ static void ibmvnic_tx_scrq_clean_buffer(struct ibmvnic_adapter *adapter,
 		tx_buff = &tx_pool->tx_buff[index];
 		adapter->netdev->stats.tx_packets--;
 		adapter->netdev->stats.tx_bytes -= tx_buff->skb->len;
-		adapter->tx_stats_buffers[queue_num].packets--;
+		adapter->tx_stats_buffers[queue_num].batched_packets--;
 		adapter->tx_stats_buffers[queue_num].bytes -=
 						tx_buff->skb->len;
 		dev_kfree_skb_any(tx_buff->skb);
@@ -2402,7 +2402,8 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	unsigned int tx_map_failed = 0;
 	union sub_crq indir_arr[16];
 	unsigned int tx_dropped = 0;
-	unsigned int tx_packets = 0;
+	unsigned int tx_dpackets = 0;
+	unsigned int tx_bpackets = 0;
 	unsigned int tx_bytes = 0;
 	dma_addr_t data_dma_addr;
 	struct netdev_queue *txq;
@@ -2575,6 +2576,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		if (lpar_rc != H_SUCCESS)
 			goto tx_err;
 
+		tx_dpackets++;
 		goto early_exit;
 	}
 
@@ -2603,6 +2605,8 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 			goto tx_err;
 	}
 
+	tx_bpackets++;
+
 early_exit:
 	if (atomic_add_return(num_entries, &tx_scrq->used)
 					>= adapter->req_tx_entries_per_subcrq) {
@@ -2610,7 +2614,6 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		netif_stop_subqueue(netdev, queue_num);
 	}
 
-	tx_packets++;
 	tx_bytes += skb->len;
 	txq_trans_cond_update(txq);
 	ret = NETDEV_TX_OK;
@@ -2640,10 +2643,11 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	rcu_read_unlock();
 	netdev->stats.tx_dropped += tx_dropped;
 	netdev->stats.tx_bytes += tx_bytes;
-	netdev->stats.tx_packets += tx_packets;
+	netdev->stats.tx_packets += tx_bpackets + tx_dpackets;
 	adapter->tx_send_failed += tx_send_failed;
 	adapter->tx_map_failed += tx_map_failed;
-	adapter->tx_stats_buffers[queue_num].packets += tx_packets;
+	adapter->tx_stats_buffers[queue_num].batched_packets += tx_bpackets;
+	adapter->tx_stats_buffers[queue_num].direct_packets += tx_dpackets;
 	adapter->tx_stats_buffers[queue_num].bytes += tx_bytes;
 	adapter->tx_stats_buffers[queue_num].dropped_packets += tx_dropped;
 
@@ -3808,7 +3812,10 @@ static void ibmvnic_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 		memcpy(data, ibmvnic_stats[i].name, ETH_GSTRING_LEN);
 
 	for (i = 0; i < adapter->req_tx_queues; i++) {
-		snprintf(data, ETH_GSTRING_LEN, "tx%d_packets", i);
+		snprintf(data, ETH_GSTRING_LEN, "tx%d_batched_packets", i);
+		data += ETH_GSTRING_LEN;
+
+		snprintf(data, ETH_GSTRING_LEN, "tx%d_direct_packets", i);
 		data += ETH_GSTRING_LEN;
 
 		snprintf(data, ETH_GSTRING_LEN, "tx%d_bytes", i);
@@ -3873,7 +3880,9 @@ static void ibmvnic_get_ethtool_stats(struct net_device *dev,
 				      (adapter, ibmvnic_stats[i].offset));
 
 	for (j = 0; j < adapter->req_tx_queues; j++) {
-		data[i] = adapter->tx_stats_buffers[j].packets;
+		data[i] = adapter->tx_stats_buffers[j].batched_packets;
+		i++;
+		data[i] = adapter->tx_stats_buffers[j].direct_packets;
 		i++;
 		data[i] = adapter->tx_stats_buffers[j].bytes;
 		i++;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 94ac36b1408be..a189038d88df0 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -213,7 +213,8 @@ struct ibmvnic_statistics {
 
 #define NUM_TX_STATS 3
 struct ibmvnic_tx_queue_stats {
-	u64 packets;
+	u64 batched_packets;
+	u64 direct_packets;
 	u64 bytes;
 	u64 dropped_packets;
 };
-- 
2.39.5



