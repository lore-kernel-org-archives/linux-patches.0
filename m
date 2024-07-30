Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE90D146D6B;
	Tue, 30 Jul 2024 16:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357495; cv=none; b=bSIVUsU8lQycHkPXE7qyaJX89yV/VEUOVzBY8zVWoMMz9C5J2zZaBVm0LMy5OizLQYcjEmIuhw+2+jMcu+HI3x0fI0m1ylZS6g2tmiLnCVv/phi0dbTlfzztsMWnASWo9A6Iiq186MItjtbgf6ES7ZHLGJxTK8fJTWIF61LaMzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357495; c=relaxed/simple;
	bh=Kdc3Evp9caPee8prR2ZsRKdmJzgvtUIrsGsUpZ0z7Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xl8GtwzMvvD03gj8NxgFprawHcw2XLFRjtaZOONDNpy7w6pQtbwS4pfVT9HpCisRyK8+/9IxPh0O51Fne0Fd6HhAizdDNOXRbXN7UlzzTK8GjZqZOYr0JWzL289q7fRCEQEToj2obS01gKxKP0eEbU7KuSJfv6i4+7XlJ26FYP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8EwQIoI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8EwQIoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02413C4AF11;
	Tue, 30 Jul 2024 16:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357495;
	bh=Kdc3Evp9caPee8prR2ZsRKdmJzgvtUIrsGsUpZ0z7Xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8EwQIoIXT4jH3+ZVTi11zEE5RNpi7dtkWxVz0vN1nz9DR7NtlaCJPD687xCSfy9k
	 IE0Drbk2/9HCkaJiAUmzP17ZPl43/Nnjpsr70ou/2QWr1CTphRhcWy7mWLFelixL7n
	 rF6cNx0JfSrV+/UZm2/HXRY4E0YkfeF0b+jcKVdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 259/809] virtio_net: add support for Byte Queue Limits
Date: Tue, 30 Jul 2024 17:42:15 +0200
Message-ID: <20240730151734.824711848@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit c8bd1f7f3e61fc6c562c806045f3ccd2cc819c01 ]

Add support for Byte Queue Limits (BQL).

Tested on qemu emulated virtio_net device with 1, 2 and 4 queues.
Tested with fq_codel and pfifo_fast. Super netperf with 50 threads is
running in background. Netperf TCP_RR results:

NOBQL FQC 1q:  159.56  159.33  158.50  154.31    agv: 157.925
NOBQL FQC 2q:  184.64  184.96  174.73  174.15    agv: 179.62
NOBQL FQC 4q:  994.46  441.96  416.50  499.56    agv: 588.12
NOBQL PFF 1q:  148.68  148.92  145.95  149.48    agv: 148.2575
NOBQL PFF 2q:  171.86  171.20  170.42  169.42    agv: 170.725
NOBQL PFF 4q: 1505.23 1137.23 2488.70 3507.99    agv: 2159.7875
  BQL FQC 1q: 1332.80 1297.97 1351.41 1147.57    agv: 1282.4375
  BQL FQC 2q:  768.30  817.72  864.43  974.40    agv: 856.2125
  BQL FQC 4q:  945.66  942.68  878.51  822.82    agv: 897.4175
  BQL PFF 1q:  149.69  151.49  149.40  147.47    agv: 149.5125
  BQL PFF 2q: 2059.32  798.74 1844.12  381.80    agv: 1270.995
  BQL PFF 4q: 1871.98 4420.02 4916.59 13268.16   agv: 6119.1875

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://lore.kernel.org/r/20240618144456.1688998-1-jiri@resnulli.us
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f8321fa75102 ("virtio_net: Fix napi_skb_cache_put warning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 81 ++++++++++++++++++++++++++++------------
 1 file changed, 57 insertions(+), 24 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ea10db9a09fa2..b1f8b720733e5 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -47,7 +47,8 @@ module_param(napi_tx, bool, 0644);
 #define VIRTIO_XDP_TX		BIT(0)
 #define VIRTIO_XDP_REDIR	BIT(1)
 
-#define VIRTIO_XDP_FLAG	BIT(0)
+#define VIRTIO_XDP_FLAG		BIT(0)
+#define VIRTIO_ORPHAN_FLAG	BIT(1)
 
 /* RX packet size EWMA. The average packet size is used to determine the packet
  * buffer size when refilling RX rings. As the entire RX ring may be refilled
@@ -85,6 +86,8 @@ struct virtnet_stat_desc {
 struct virtnet_sq_free_stats {
 	u64 packets;
 	u64 bytes;
+	u64 napi_packets;
+	u64 napi_bytes;
 };
 
 struct virtnet_sq_stats {
@@ -506,29 +509,50 @@ static struct xdp_frame *ptr_to_xdp(void *ptr)
 	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
 }
 
-static void __free_old_xmit(struct send_queue *sq, bool in_napi,
-			    struct virtnet_sq_free_stats *stats)
+static bool is_orphan_skb(void *ptr)
+{
+	return (unsigned long)ptr & VIRTIO_ORPHAN_FLAG;
+}
+
+static void *skb_to_ptr(struct sk_buff *skb, bool orphan)
+{
+	return (void *)((unsigned long)skb | (orphan ? VIRTIO_ORPHAN_FLAG : 0));
+}
+
+static struct sk_buff *ptr_to_skb(void *ptr)
+{
+	return (struct sk_buff *)((unsigned long)ptr & ~VIRTIO_ORPHAN_FLAG);
+}
+
+static void __free_old_xmit(struct send_queue *sq, struct netdev_queue *txq,
+			    bool in_napi, struct virtnet_sq_free_stats *stats)
 {
 	unsigned int len;
 	void *ptr;
 
 	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
-		++stats->packets;
-
 		if (!is_xdp_frame(ptr)) {
-			struct sk_buff *skb = ptr;
+			struct sk_buff *skb = ptr_to_skb(ptr);
 
 			pr_debug("Sent skb %p\n", skb);
 
-			stats->bytes += skb->len;
+			if (is_orphan_skb(ptr)) {
+				stats->packets++;
+				stats->bytes += skb->len;
+			} else {
+				stats->napi_packets++;
+				stats->napi_bytes += skb->len;
+			}
 			napi_consume_skb(skb, in_napi);
 		} else {
 			struct xdp_frame *frame = ptr_to_xdp(ptr);
 
+			stats->packets++;
 			stats->bytes += xdp_get_frame_len(frame);
 			xdp_return_frame(frame);
 		}
 	}
+	netdev_tx_completed_queue(txq, stats->napi_packets, stats->napi_bytes);
 }
 
 /* Converting between virtqueue no. and kernel tx/rx queue no.
@@ -955,21 +979,22 @@ static void virtnet_rq_unmap_free_buf(struct virtqueue *vq, void *buf)
 	virtnet_rq_free_buf(vi, rq, buf);
 }
 
-static void free_old_xmit(struct send_queue *sq, bool in_napi)
+static void free_old_xmit(struct send_queue *sq, struct netdev_queue *txq,
+			  bool in_napi)
 {
 	struct virtnet_sq_free_stats stats = {0};
 
-	__free_old_xmit(sq, in_napi, &stats);
+	__free_old_xmit(sq, txq, in_napi, &stats);
 
 	/* Avoid overhead when no packets have been processed
 	 * happens when called speculatively from start_xmit.
 	 */
-	if (!stats.packets)
+	if (!stats.packets && !stats.napi_packets)
 		return;
 
 	u64_stats_update_begin(&sq->stats.syncp);
-	u64_stats_add(&sq->stats.bytes, stats.bytes);
-	u64_stats_add(&sq->stats.packets, stats.packets);
+	u64_stats_add(&sq->stats.bytes, stats.bytes + stats.napi_bytes);
+	u64_stats_add(&sq->stats.packets, stats.packets + stats.napi_packets);
 	u64_stats_update_end(&sq->stats.syncp);
 }
 
@@ -1003,7 +1028,9 @@ static void check_sq_full_and_disable(struct virtnet_info *vi,
 	 * early means 16 slots are typically wasted.
 	 */
 	if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
-		netif_stop_subqueue(dev, qnum);
+		struct netdev_queue *txq = netdev_get_tx_queue(dev, qnum);
+
+		netif_tx_stop_queue(txq);
 		u64_stats_update_begin(&sq->stats.syncp);
 		u64_stats_inc(&sq->stats.stop);
 		u64_stats_update_end(&sq->stats.syncp);
@@ -1012,7 +1039,7 @@ static void check_sq_full_and_disable(struct virtnet_info *vi,
 				virtqueue_napi_schedule(&sq->napi, sq->vq);
 		} else if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
 			/* More just got used, free them then recheck. */
-			free_old_xmit(sq, false);
+			free_old_xmit(sq, txq, false);
 			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
 				netif_start_subqueue(dev, qnum);
 				u64_stats_update_begin(&sq->stats.syncp);
@@ -1138,7 +1165,8 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	}
 
 	/* Free up any pending old buffers before queueing new ones. */
-	__free_old_xmit(sq, false, &stats);
+	__free_old_xmit(sq, netdev_get_tx_queue(dev, sq - vi->sq),
+			false, &stats);
 
 	for (i = 0; i < n; i++) {
 		struct xdp_frame *xdpf = frames[i];
@@ -2331,7 +2359,7 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
 
 		do {
 			virtqueue_disable_cb(sq->vq);
-			free_old_xmit(sq, true);
+			free_old_xmit(sq, txq, true);
 		} while (unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
 
 		if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS) {
@@ -2430,6 +2458,7 @@ static int virtnet_enable_queue_pair(struct virtnet_info *vi, int qp_index)
 		goto err_xdp_reg_mem_model;
 
 	virtnet_napi_enable(vi->rq[qp_index].vq, &vi->rq[qp_index].napi);
+	netdev_tx_reset_queue(netdev_get_tx_queue(vi->dev, qp_index));
 	virtnet_napi_tx_enable(vi, vi->sq[qp_index].vq, &vi->sq[qp_index].napi);
 
 	return 0;
@@ -2489,7 +2518,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	txq = netdev_get_tx_queue(vi->dev, index);
 	__netif_tx_lock(txq, raw_smp_processor_id());
 	virtqueue_disable_cb(sq->vq);
-	free_old_xmit(sq, true);
+	free_old_xmit(sq, txq, true);
 
 	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS) {
 		if (netif_tx_queue_stopped(txq)) {
@@ -2523,7 +2552,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 	return 0;
 }
 
-static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
+static int xmit_skb(struct send_queue *sq, struct sk_buff *skb, bool orphan)
 {
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
@@ -2567,7 +2596,8 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 			return num_sg;
 		num_sg++;
 	}
-	return virtqueue_add_outbuf(sq->vq, sq->sg, num_sg, skb, GFP_ATOMIC);
+	return virtqueue_add_outbuf(sq->vq, sq->sg, num_sg,
+				    skb_to_ptr(skb, orphan), GFP_ATOMIC);
 }
 
 static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -2577,24 +2607,25 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct send_queue *sq = &vi->sq[qnum];
 	int err;
 	struct netdev_queue *txq = netdev_get_tx_queue(dev, qnum);
-	bool kick = !netdev_xmit_more();
+	bool xmit_more = netdev_xmit_more();
 	bool use_napi = sq->napi.weight;
+	bool kick;
 
 	/* Free up any pending old buffers before queueing new ones. */
 	do {
 		if (use_napi)
 			virtqueue_disable_cb(sq->vq);
 
-		free_old_xmit(sq, false);
+		free_old_xmit(sq, txq, false);
 
-	} while (use_napi && kick &&
+	} while (use_napi && !xmit_more &&
 	       unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
 
 	/* timestamp packet in software */
 	skb_tx_timestamp(skb);
 
 	/* Try to transmit */
-	err = xmit_skb(sq, skb);
+	err = xmit_skb(sq, skb, !use_napi);
 
 	/* This should not happen! */
 	if (unlikely(err)) {
@@ -2616,7 +2647,9 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	check_sq_full_and_disable(vi, dev, sq);
 
-	if (kick || netif_xmit_stopped(txq)) {
+	kick = use_napi ? __netdev_tx_sent_queue(txq, skb->len, xmit_more) :
+			  !xmit_more || netif_xmit_stopped(txq);
+	if (kick) {
 		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
 			u64_stats_update_begin(&sq->stats.syncp);
 			u64_stats_inc(&sq->stats.kicks);
-- 
2.43.0



