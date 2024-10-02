Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97311D150B;
	Wed,  2 Oct 2024 14:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879096; cv=none; b=YWXkt87L0PB82J3noI4A0hZTSVbKSKztWs5s0dprMLbJdhk1Xz9i0sZNV502KuHqRPrxhZF5ub9LofQPAUxujNtxnqDsFKJ9Yn3CQB74CS8NdrVWug5E0EC6PkauJ+9hqOeqJHnZtsG0xHKs7rd5qyW65jmymMGLRgYGeBQy5XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879096; c=relaxed/simple;
	bh=W3Kabk60nDGK2C2D+IPsjP7qyBqCRvRE5rJZ2M1HAeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJPnRfo8v4HmzRxfB+310CVMI7QgTvZVjJc98UKOh5OWcaGPpAJpK/xn0MFSZ1zp0UByOFVdqNNiKyxiyRy0QgvuHqNiCQ9ZTuJ+t2BJlSyAiTy3TD5Pjyw+gVvIE97i2+NIYyEqwu2GJYCdzMV1C7JGoxEMH7aHNwrptZbzwew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePscCgZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePscCgZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F80C4CEC2;
	Wed,  2 Oct 2024 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879095;
	bh=W3Kabk60nDGK2C2D+IPsjP7qyBqCRvRE5rJZ2M1HAeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePscCgZGlZ3h/hU5oyeCHS9veSSyf+DC2V4CWwqMoyEDAHUTkyGXj+JOUF6B+aTNq
	 XZg5k4h0RY9QaT7fA/kjC8DUP7hi3IQHp4U+lI8ysZKLVoSRCM0FJkaCUtzVXASq5l
	 1zuDWRySOvpeSDgWKX0KE4sihmG7J6/ms8hUnmMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 609/634] idpf: merge singleq and splitq &net_device_ops
Date: Wed,  2 Oct 2024 15:01:49 +0200
Message-ID: <20241002125835.156278522@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit 14f662b43bf8c765114f73d184af2702b2280436 ]

It makes no sense to have a second &net_device_ops struct (800 bytes of
rodata) with only one difference in .ndo_start_xmit, which can easily
be just one `if`. This `if` is a drop in the ocean and you won't see
any difference.
Define unified idpf_xmit_start(). The preparation for sending is the
same, just call either idpf_tx_splitq_frame() or idpf_tx_singleq_frame()
depending on the active model to actually map and send the skb.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: e4b398dd82f5 ("idpf: fix netdev Tx queue stop/wake")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c    | 26 +++-------------
 .../ethernet/intel/idpf/idpf_singleq_txrx.c   | 31 ++-----------------
 drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 17 ++++++----
 drivers/net/ethernet/intel/idpf/idpf_txrx.h   |  9 ++----
 4 files changed, 20 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 1ab679a719c77..5e336f64bc25e 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -4,8 +4,7 @@
 #include "idpf.h"
 #include "idpf_virtchnl.h"
 
-static const struct net_device_ops idpf_netdev_ops_splitq;
-static const struct net_device_ops idpf_netdev_ops_singleq;
+static const struct net_device_ops idpf_netdev_ops;
 
 /**
  * idpf_init_vector_stack - Fill the MSIX vector stack with vector index
@@ -765,10 +764,7 @@ static int idpf_cfg_netdev(struct idpf_vport *vport)
 	}
 
 	/* assign netdev_ops */
-	if (idpf_is_queue_model_split(vport->txq_model))
-		netdev->netdev_ops = &idpf_netdev_ops_splitq;
-	else
-		netdev->netdev_ops = &idpf_netdev_ops_singleq;
+	netdev->netdev_ops = &idpf_netdev_ops;
 
 	/* setup watchdog timeout value to be 5 second */
 	netdev->watchdog_timeo = 5 * HZ;
@@ -2353,24 +2349,10 @@ void idpf_free_dma_mem(struct idpf_hw *hw, struct idpf_dma_mem *mem)
 	mem->pa = 0;
 }
 
-static const struct net_device_ops idpf_netdev_ops_splitq = {
-	.ndo_open = idpf_open,
-	.ndo_stop = idpf_stop,
-	.ndo_start_xmit = idpf_tx_splitq_start,
-	.ndo_features_check = idpf_features_check,
-	.ndo_set_rx_mode = idpf_set_rx_mode,
-	.ndo_validate_addr = eth_validate_addr,
-	.ndo_set_mac_address = idpf_set_mac,
-	.ndo_change_mtu = idpf_change_mtu,
-	.ndo_get_stats64 = idpf_get_stats64,
-	.ndo_set_features = idpf_set_features,
-	.ndo_tx_timeout = idpf_tx_timeout,
-};
-
-static const struct net_device_ops idpf_netdev_ops_singleq = {
+static const struct net_device_ops idpf_netdev_ops = {
 	.ndo_open = idpf_open,
 	.ndo_stop = idpf_stop,
-	.ndo_start_xmit = idpf_tx_singleq_start,
+	.ndo_start_xmit = idpf_tx_start,
 	.ndo_features_check = idpf_features_check,
 	.ndo_set_rx_mode = idpf_set_rx_mode,
 	.ndo_validate_addr = eth_validate_addr,
diff --git a/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
index 9864a3992f0c3..8630db24f63a7 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
@@ -351,8 +351,8 @@ static void idpf_tx_singleq_build_ctx_desc(struct idpf_tx_queue *txq,
  *
  * Returns NETDEV_TX_OK if sent, else an error code
  */
-static netdev_tx_t idpf_tx_singleq_frame(struct sk_buff *skb,
-					 struct idpf_tx_queue *tx_q)
+netdev_tx_t idpf_tx_singleq_frame(struct sk_buff *skb,
+				  struct idpf_tx_queue *tx_q)
 {
 	struct idpf_tx_offload_params offload = { };
 	struct idpf_tx_buf *first;
@@ -408,33 +408,6 @@ static netdev_tx_t idpf_tx_singleq_frame(struct sk_buff *skb,
 	return idpf_tx_drop_skb(tx_q, skb);
 }
 
-/**
- * idpf_tx_singleq_start - Selects the right Tx queue to send buffer
- * @skb: send buffer
- * @netdev: network interface device structure
- *
- * Returns NETDEV_TX_OK if sent, else an error code
- */
-netdev_tx_t idpf_tx_singleq_start(struct sk_buff *skb,
-				  struct net_device *netdev)
-{
-	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
-	struct idpf_tx_queue *tx_q;
-
-	tx_q = vport->txqs[skb_get_queue_mapping(skb)];
-
-	/* hardware can't handle really short frames, hardware padding works
-	 * beyond this point
-	 */
-	if (skb_put_padto(skb, IDPF_TX_MIN_PKT_LEN)) {
-		idpf_tx_buf_hw_update(tx_q, tx_q->next_to_use, false);
-
-		return NETDEV_TX_OK;
-	}
-
-	return idpf_tx_singleq_frame(skb, tx_q);
-}
-
 /**
  * idpf_tx_singleq_clean - Reclaim resources from queue
  * @tx_q: Tx queue to clean
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index cdb01c54213f9..7b06ca7b9732a 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -4,6 +4,9 @@
 #include "idpf.h"
 #include "idpf_virtchnl.h"
 
+static bool idpf_chk_linearize(struct sk_buff *skb, unsigned int max_bufs,
+			       unsigned int count);
+
 /**
  * idpf_buf_lifo_push - push a buffer pointer onto stack
  * @stack: pointer to stack struct
@@ -2702,8 +2705,8 @@ static bool __idpf_chk_linearize(struct sk_buff *skb, unsigned int max_bufs)
  * E.g.: a packet with 7 fragments can require 9 DMA transactions; 1 for TSO
  * header, 1 for segment payload, and then 7 for the fragments.
  */
-bool idpf_chk_linearize(struct sk_buff *skb, unsigned int max_bufs,
-			unsigned int count)
+static bool idpf_chk_linearize(struct sk_buff *skb, unsigned int max_bufs,
+			       unsigned int count)
 {
 	if (likely(count < max_bufs))
 		return false;
@@ -2849,14 +2852,13 @@ static netdev_tx_t idpf_tx_splitq_frame(struct sk_buff *skb,
 }
 
 /**
- * idpf_tx_splitq_start - Selects the right Tx queue to send buffer
+ * idpf_tx_start - Selects the right Tx queue to send buffer
  * @skb: send buffer
  * @netdev: network interface device structure
  *
  * Returns NETDEV_TX_OK if sent, else an error code
  */
-netdev_tx_t idpf_tx_splitq_start(struct sk_buff *skb,
-				 struct net_device *netdev)
+netdev_tx_t idpf_tx_start(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
 	struct idpf_tx_queue *tx_q;
@@ -2878,7 +2880,10 @@ netdev_tx_t idpf_tx_splitq_start(struct sk_buff *skb,
 		return NETDEV_TX_OK;
 	}
 
-	return idpf_tx_splitq_frame(skb, tx_q);
+	if (idpf_is_queue_model_split(vport->txq_model))
+		return idpf_tx_splitq_frame(skb, tx_q);
+	else
+		return idpf_tx_singleq_frame(skb, tx_q);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
index 704aec5c383b6..5b3f19200255a 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -1148,14 +1148,11 @@ void idpf_tx_dma_map_error(struct idpf_tx_queue *txq, struct sk_buff *skb,
 			   struct idpf_tx_buf *first, u16 ring_idx);
 unsigned int idpf_tx_desc_count_required(struct idpf_tx_queue *txq,
 					 struct sk_buff *skb);
-bool idpf_chk_linearize(struct sk_buff *skb, unsigned int max_bufs,
-			unsigned int count);
 int idpf_tx_maybe_stop_common(struct idpf_tx_queue *tx_q, unsigned int size);
 void idpf_tx_timeout(struct net_device *netdev, unsigned int txqueue);
-netdev_tx_t idpf_tx_splitq_start(struct sk_buff *skb,
-				 struct net_device *netdev);
-netdev_tx_t idpf_tx_singleq_start(struct sk_buff *skb,
-				  struct net_device *netdev);
+netdev_tx_t idpf_tx_singleq_frame(struct sk_buff *skb,
+				  struct idpf_tx_queue *tx_q);
+netdev_tx_t idpf_tx_start(struct sk_buff *skb, struct net_device *netdev);
 bool idpf_rx_singleq_buf_hw_alloc_all(struct idpf_rx_queue *rxq,
 				      u16 cleaned_count);
 int idpf_tso(struct sk_buff *skb, struct idpf_tx_offload_params *off);
-- 
2.43.0



