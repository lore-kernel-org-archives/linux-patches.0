Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E502C1788;
	Thu, 17 Sep 2026 15:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660503; cv=none; b=Z5koM2Onnn0s7I7h/iCWPXE8ecaL5PXUIPE/chWqQLlTXyP7r/U5m5ykgguabFcTVi+vweVrchCS594EQrauqPqDO98QoWnaxJqwCxrTayYw02hVLFF8KoDl9Ioc6ey+LVEmwlpvf+iihEYod4Gybm2q9cFAvlXSVZu35NdDbjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660503; c=relaxed/simple;
	bh=V6IIwcgIUadBm3p83nFguFzXRWG8Q2x6BrWHBbxyJLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCAJ8XjK3xRNTbgwieOvo9rEysAqwDNbf7q148ALmEt8wz23AfEeG8dhzllK8OwX/qRG3zY1dDXyP362MhXKYVXQssDAeHG3d/U3dPnSZqlyPfBgy6u/6jc7dPS1pumHsoxFe33oPgto2OwovZ0n6LtQs6u1+0UE3J7xIpvadHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=am5RwabY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="am5RwabY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1211F000FF;
	Thu, 17 Sep 2026 15:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660498;
	bh=P2gIJOvvnCcBsmkDf3t6UWd4lEdgCwCB9v4NbCIZXX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=am5RwabYasbyUWQP+FNfDWx+W1johGdijlQXP3+mKRTg1w+Xd0Mok6hKigxZEm9Ft
	 naO7wkOxck++ppEQlv/yugI1djr77RsZVqCYzHS2NbuJgD7OZJrcjg2yPnE27j24LY
	 cT/LvDG3Ce6Hf85AHsbnbDcHnXDUpFaXsDg2i62Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 611/733] bnxt_en: Prevent queue stop with deferred completions
Date: Thu, 17 Sep 2026 16:15:19 +0100
Message-ID: <20260917151407.722568810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <joe@dama.to>

commit 39b23c1c40e1f73d2b94a09282cc476af647e438 upstream.

When the driver receives a burst of packets, it can mark a BD with the
NO_CMPL bit to defer completions. The expectation is that the last
packet in the ring will have this bit unset and the completion generated
by that packet will cleanup that packet and the ones preceding it. This
helps to reduce the number of completions fired.

The suppressed completions are controlled by the driver and the number
of packets with suppressed completions scales with the size of the ring.
SW USO packets, on the other hand, have an upper bound on the maximum
number of BDs which can be consumed which does not scale with the ring
size.

So, for small rings it is possible that: a burst of packets is handed to
the driver, the driver defers completions for all of the packets because
the number of free descriptors stays above the threshold in the driver.
Then, a USO packet arrives, but the number of BDs available is not
enough and the USO code exits early.

In this case, you end up in a state where the ring is full of packets
with their completions suppressed, which can cause the queue to stop and
never be restarted.

Assuming default CONFIG_MAX_SKB_FRAGS, this is only possible for small
rings (<= 457 descriptors, below the driver default value) when
a burst of packets fills the ring, followed by a large USO packet that
can't fit. For larger rings, the delta between the completion
suppression threshold and the BDs required for SW USO is large enough
that completions will fire and this case is unreachable.

This issue was pointed out by Sashiko and while it seems fairly unlikely
given that the queue size must be small to trigger this, it is indeed
possible.

Fix this by tracking the last BD which deferred completions and
centralizing the logic for deciding when to ring the doorbell. The NO_CMPL
bit is now cleared in bnxt_txr_db_kick(), so every doorbell site is
covered, including the SW USO early exit. This guarantees the ring always
ends in a BD which generates a completion to clean it and wake the queue.

Fixes: cc5d90667db8 ("net: bnxt: Implement software USO")
Cc: <stable@vger.kernel.org> # v7.1+: 4e15e89faac9: net: bnxt: ring the doorbell when SW USO exits early
Signed-off-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260902213956.4160615-1-joe@dama.to
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   42 ++++++++++++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_gso.c |   21 +++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt_gso.h |    6 +--
 4 files changed, 48 insertions(+), 22 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -462,6 +462,16 @@ u16 bnxt_xmit_get_cfa_action(struct sk_b
 static void bnxt_txr_db_kick(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
 			     u16 prod)
 {
+	/* If the most recent BD has its completion suppressed, unset the bit
+	 * so that a completion is generated, otherwise nothing is left to
+	 * clean the ring and wake the queue.
+	 */
+	if (txr->kick_txbd0) {
+		txr->kick_txbd0->tx_bd_len_flags_type &=
+			cpu_to_le32(~TX_BD_FLAGS_NO_CMPL);
+		txr->kick_txbd0 = NULL;
+	}
+
 	/* Sync BD data before updating doorbell */
 	wmb();
 	bnxt_db_write(bp, &txr->tx_db, prod);
@@ -485,7 +495,6 @@ static netdev_tx_t bnxt_start_xmit(struc
 	struct bnxt_sw_tx_bd *tx_buf;
 	__le32 lflags = 0;
 	skb_frag_t *frag;
-	netdev_tx_t ret;
 
 	i = skb_get_queue_mapping(skb);
 	if (unlikely(i >= bp->tx_nr_rings)) {
@@ -509,11 +518,22 @@ static netdev_tx_t bnxt_start_xmit(struc
 	if (skb_is_gso(skb) &&
 	    (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) &&
 	    !(bp->flags & BNXT_FLAG_UDP_GSO_CAP)) {
-		ret = bnxt_sw_udp_gso_xmit(bp, txr, txq, skb);
-		if (txr->kick_pending)
+		int rc = bnxt_sw_udp_gso_xmit(bp, txr, txq, skb);
+
+		/* if SW USO queued a packet, the doorbell will be written
+		 * below and there is no reason to track the last BD with
+		 * suppressed completions
+		 */
+		if (rc > 0)
+			txr->kick_txbd0 = NULL;
+
+		/* if a packet was queued by SW USO or a doorbell was pending
+		 * from a previous xmit that was deferred, write the doorbell.
+		 */
+		if (rc > 0 || txr->kick_pending)
 			bnxt_txr_db_kick(bp, txr, txr->tx_prod);
 
-		return ret;
+		return rc < 0 ? NETDEV_TX_BUSY : NETDEV_TX_OK;
 	}
 
 	free_size = bnxt_tx_avail(bp, txr);
@@ -751,23 +771,23 @@ normal_tx:
 	prod = NEXT_TX(prod);
 	WRITE_ONCE(txr->tx_prod, prod);
 
+	txr->kick_txbd0 = NULL;
 	if (!netdev_xmit_more() || netif_xmit_stopped(txq)) {
 		bnxt_txr_db_kick(bp, txr, prod);
 	} else {
-		if (free_size >= bp->tx_wake_thresh)
+		if (free_size >= bp->tx_wake_thresh) {
 			txbd0->tx_bd_len_flags_type |=
 				cpu_to_le32(TX_BD_FLAGS_NO_CMPL);
+			txr->kick_txbd0 = txbd0;
+		}
 		txr->kick_pending = 1;
 	}
 
 tx_done:
 
 	if (unlikely(bnxt_tx_avail(bp, txr) <= MAX_SKB_FRAGS + 1)) {
-		if (netdev_xmit_more() && !tx_buf->is_push) {
-			txbd0->tx_bd_len_flags_type &=
-				cpu_to_le32(~TX_BD_FLAGS_NO_CMPL);
+		if (txr->kick_pending)
 			bnxt_txr_db_kick(bp, txr, prod);
-		}
 
 		netif_txq_try_stop(txq, bnxt_tx_avail(bp, txr),
 				   bp->tx_wake_thresh);
@@ -5435,6 +5455,8 @@ static void bnxt_clear_ring_indices(stru
 			txr->tx_prod = 0;
 			txr->tx_cons = 0;
 			txr->tx_hw_cons = 0;
+			txr->kick_pending = 0;
+			txr->kick_txbd0 = NULL;
 		}
 
 		rxr = bnapi->rx_ring;
@@ -11785,6 +11807,8 @@ static int bnxt_tx_queue_start(struct bn
 		txr->tx_prod = 0;
 		txr->tx_cons = 0;
 		txr->tx_hw_cons = 0;
+		txr->kick_pending = 0;
+		txr->kick_txbd0 = NULL;
 start_tx:
 		WRITE_ONCE(txr->dev_state, 0);
 		synchronize_net();
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -992,6 +992,7 @@ struct bnxt_tx_ring_info {
 	u16			txq_index;
 	u8			tx_napi_idx;
 	u8			kick_pending;
+	struct tx_bd		*kick_txbd0;
 	struct bnxt_db_info	tx_db;
 
 	struct tx_bd		*tx_desc_ring[MAX_TX_PAGES];
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_gso.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_gso.c
@@ -31,10 +31,14 @@ static u32 bnxt_sw_gso_lhint(unsigned in
 		return TX_BD_FLAGS_LHINT_2048_AND_LARGER;
 }
 
-netdev_tx_t bnxt_sw_udp_gso_xmit(struct bnxt *bp,
-				 struct bnxt_tx_ring_info *txr,
-				 struct netdev_queue *txq,
-				 struct sk_buff *skb)
+/* Transmit an skb requiring software UDP segmentation.
+ *
+ * Returns 1 if the skb was queued and new BDs were produced, 0 if the skb
+ * was dropped, or -1 if the ring is full and the skb should be retried.
+ * The caller owns the doorbell for all three cases.
+ */
+int bnxt_sw_udp_gso_xmit(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
+			 struct netdev_queue *txq, struct sk_buff *skb)
 {
 	unsigned int last_unmap_len __maybe_unused = 0;
 	dma_addr_t last_unmap_addr __maybe_unused = 0;
@@ -69,7 +73,7 @@ netdev_tx_t bnxt_sw_udp_gso_xmit(struct
 	if (unlikely(bnxt_tx_avail(bp, txr) < bds_needed)) {
 		netif_txq_try_stop(txq, bnxt_tx_avail(bp, txr),
 				   bp->tx_wake_thresh);
-		return NETDEV_TX_BUSY;
+		return -1;
 	}
 
 	/* BD backpressure alone cannot prevent overwriting in-flight
@@ -77,7 +81,7 @@ netdev_tx_t bnxt_sw_udp_gso_xmit(struct
 	 */
 	if (!netif_txq_maybe_stop(txq, bnxt_inline_avail(txr),
 				  num_segs, num_segs))
-		return NETDEV_TX_BUSY;
+		return -1;
 
 	if (unlikely(tso_dma_map_init(&map, &pdev->dev, skb, hdr_len)))
 		goto drop;
@@ -223,16 +227,15 @@ netdev_tx_t bnxt_sw_udp_gso_xmit(struct
 	netdev_tx_sent_queue(txq, skb->len);
 
 	WRITE_ONCE(txr->tx_prod, prod);
-	txr->kick_pending = 1;
 
 	if (unlikely(bnxt_tx_avail(bp, txr) <= bp->tx_wake_thresh))
 		netif_txq_try_stop(txq, bnxt_tx_avail(bp, txr),
 				   bp->tx_wake_thresh);
 
-	return NETDEV_TX_OK;
+	return 1;
 
 drop:
 	dev_kfree_skb_any(skb);
 	dev_core_stats_tx_dropped_inc(bp->dev);
-	return NETDEV_TX_OK;
+	return 0;
 }
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_gso.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_gso.h
@@ -38,9 +38,7 @@ static inline int bnxt_min_tx_desc_cnt(s
 	return BNXT_MIN_TX_DESC_CNT;
 }
 
-netdev_tx_t bnxt_sw_udp_gso_xmit(struct bnxt *bp,
-				 struct bnxt_tx_ring_info *txr,
-				 struct netdev_queue *txq,
-				 struct sk_buff *skb);
+int bnxt_sw_udp_gso_xmit(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
+			 struct netdev_queue *txq, struct sk_buff *skb);
 
 #endif


