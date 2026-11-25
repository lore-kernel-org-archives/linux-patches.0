Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620931;
	b=2XIUwFEIOqD0WGbCMr7MKkjCW7oMSQugM04bjpojOb6JOMPQyA3G6RDs38tEhJzg252Q
	 yzMw0QsOd6W6NQa2qD4wMclzk+ABJtAGOeMRrESd+x4MkEQXHVzbOORjA5Jt2URuZ0xiL
	 o9t3AFPerLfymaMateKbNfxg8NjdQSD+D297OE0/WtPM4ystmEXnvr/uXf9686KXTUQR1
	 AzMPSPfkvLd+JXJMrQaYYoaXA8y8Y9xKjwFmSse7pnl7Opu9agqzGz90O0ILja7R4hNB/
	 SWTMUihBGTIzXYh/yVXgzJRKIEJkM7rdE428R+27tqZJWsX8aqCgAni4FCEzK+AJnWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8V2jxLNiawlkO6/HC5UjapiLbwoPkpuhlLBM4IjF6yM=;
	b=tGOqzRK1Q6+SZtZJ/SuwKVQoTzHxIYLRjW5XiRSF4S835o0txsNsYozIElAgsUWMcRnL
	 oJxIy7VhKXSLavIWKsJNDiC8IcLE/9X6xkRTb0rAhBfqSmSiAY+SzD6G6RAc6Fv/JOVyv
	 YH5MaK3iSjaR2LhHueyj83uI69fOVvP0tmLrUlixwjeTMbeaeHrLGw+EBo9Cg318rYnxx
	 55Jp4o2N4O2IgZyMEzsaBSRn3sl3TSgd/FWXph+A3Nh7sCHy/ZOjy9tceeBj+vpMUgUjs
	 wLjOA87B0YbQLbYB0ZwetD/kS/5UXu1P74Krqoq0bPlpHb0KjEWJTnNokZ8UDcfrZZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U0uyvfDQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB11606A69C;
	Wed, 25 Nov 2026 15:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U0uyvfDQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFC81F01807;
	Wed, 25 Nov 2026 15:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620931;
	bh=8V2jxLNiawlkO6/HC5UjapiLbwoPkpuhlLBM4IjF6yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U0uyvfDQQxXb6q2LDmCI1DM7Hau3Z7xU9jLegxjrzf9uCgwB2QvK94NcVjdmmflnb
	 W71OT7mXGQpxov9HfLAywSNGbqcn67n7c+sLxrIwNSRu4OKAinBhS0eIypHnXSPetc
	 1J37oEW7GzU7x1XFlKSbnZ1MOuphQYHsilu2VOGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolai Kalinin <nikolai@kalinidze.me>,
	Vladimir Petrzhikovskii <vladimir@dfb.sh>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 023/990] virtio_net: check RX buffer length before DMA sync
Date: Wed, 25 Nov 2026 15:23:10 +0100
Message-ID: <20261125143822.630778312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Petrzhikovskii <vladimir@dfb.sh>

[ Upstream commit 29dfa436bc488056a84ee423ba82336db453e2a6 ]

An RX queue that uses the DMA API (rq->use_page_pool_dma, for example
with VIRTIO_F_ACCESS_PLATFORM) syncs each received buffer with
page_pool_dma_sync_for_cpu() using the length the device wrote to the
used ring, and checks that length against the posted buffer only after
the sync.

With SWIOTLB bouncing (swiotlb=force, or a confidential-computing
guest), the sync copies from the shared bounce buffer into the guest's
private page, so an oversized length also copies the bytes the device
wrote past the posted buffer over the neighbouring page pool fragments.
The later check drops the packet, but the copy has already happened. A
malicious device, such as a host the confidential guest does not
trust, can overwrite guest kernel memory next to an RX buffer with
bytes it chooses, which is enough to take an unprivileged guest
process to root.

Check the length before the sync in the per-fragment loops.
receive_buf() has to sync the header before the length check, because
the mergeable error path reads num_buffers from it, so limit that sync
to the posted length. A device that reports correct lengths sees no
change.

The driver has synced with the device's length since
commit 295525e29a5b ("virtio_net: merge dma operations when filling
mergeable buffers"), at first in virtnet_rq_unmap(). Commit 24fbd3967f3f
("virtio_net: add page_pool support for buffer allocation") moved the
sync to the page_pool call sites that this patch changes, so the patch
applies to v7.1 and later. Older kernels need a separate backport that
limits the sync in virtnet_rq_unmap().

Found by an LLM code review agent auditing users of the DMA API; the
fix and this changelog were also written with an LLM coding assistant
and reviewed by us. Reproduced in QEMU with swiotlb=force and
iommu_platform=on, a test-only device change that reports a used length
64 bytes past the posted buffer and writes a marker there, and a guest
kprobe module that reads the buffer after the sync: without this patch
the marker reaches the guest page for small and mergeable buffers; with
it the packets are dropped and counted in rx_length_errors. The
virtio_net selftest basic_features.sh passes with and without mergeable
buffers.

Fixes: 295525e29a5b ("virtio_net: merge dma operations when filling mergeable buffers")
Cc: stable@vger.kernel.org
Co-developed-by: Nikolai Kalinin <nikolai@kalinidze.me>
Signed-off-by: Nikolai Kalinin <nikolai@kalinidze.me>
Signed-off-by: Vladimir Petrzhikovskii <vladimir@dfb.sh>
Link: https://patch.msgid.link/20261110-b4-virtionet-rxlen-v2-1-6ec5aa0edf9f@dfb.sh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ vladimir: 6.18.y has no page_pool RX buffers. The driver syncs small
  and mergeable RX buffers in virtnet_rq_get_buf() with the length from
  the used ring, before any length check. Limit that sync to the length
  of the posted buffer; the existing checks then drop the packet. Tested
  with the reproducer described above: without this patch the marker
  reaches the guest page for small and mergeable buffers; with it the
  sync stops at the posted length and the packets are counted in
  rx_length_errors. ]
Signed-off-by: Vladimir Petrzhikovskii <vladimir@dfb.sh>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 47 ++++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 59da65040d047..254f7ff304399 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -805,19 +805,32 @@ static unsigned int mergeable_ctx_to_truesize(void *mrg_ctx)
 	return (unsigned long)mrg_ctx & ((1 << MRG_CTX_HEADER_SHIFT) - 1);
 }
 
-static int check_mergeable_len(struct net_device *dev, void *mrg_ctx,
-			       unsigned int len)
+/* Length of the mergeable buffer that add_recvbuf_mergeable() posted. */
+static unsigned int mergeable_ctx_to_buflen(void *mrg_ctx)
 {
-	unsigned int headroom, tailroom, room, truesize;
+	unsigned int headroom, tailroom, room;
 
-	truesize = mergeable_ctx_to_truesize(mrg_ctx);
 	headroom = mergeable_ctx_to_headroom(mrg_ctx);
 	tailroom = headroom ? sizeof(struct skb_shared_info) : 0;
 	room = SKB_DATA_ALIGN(headroom + tailroom);
 
-	if (len > truesize - room) {
-		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
-			 dev->name, len, (unsigned long)(truesize - room));
+	return mergeable_ctx_to_truesize(mrg_ctx) - room;
+}
+
+/* Length of the small buffer that add_recvbuf_small() posts. */
+static unsigned int small_buflen(const struct virtnet_info *vi)
+{
+	return vi->hdr_len + GOOD_PACKET_LEN;
+}
+
+static int check_mergeable_len(struct net_device *dev, void *mrg_ctx,
+			       unsigned int len)
+{
+	unsigned int buflen = mergeable_ctx_to_buflen(mrg_ctx);
+
+	if (len > buflen) {
+		pr_debug("%s: rx error: len %u exceeds buffer length %u\n",
+			 dev->name, len, buflen);
 		DEV_STATS_INC(dev, rx_length_errors);
 		return -1;
 	}
@@ -974,13 +987,25 @@ static void virtnet_rq_unmap(struct receive_queue *rq, void *buf, u32 len)
 static void *virtnet_rq_get_buf(struct receive_queue *rq, u32 *len, void **ctx)
 {
 	struct virtnet_info *vi = rq->vq->vdev->priv;
+	void *buf_ctx;
+	u32 buflen;
 	void *buf;
 
 	BUG_ON(vi->big_packets && !vi->mergeable_rx_bufs);
 
-	buf = virtqueue_get_buf_ctx(rq->vq, len, ctx);
-	if (buf)
-		virtnet_rq_unmap(rq, buf, *len);
+	buf = virtqueue_get_buf_ctx(rq->vq, len, &buf_ctx);
+	if (!buf)
+		return NULL;
+
+	/* The device chooses *len. Sync only the buffer that was posted, so
+	 * that a larger *len cannot copy over the buffers next to it.
+	 */
+	buflen = vi->mergeable_rx_bufs ? mergeable_ctx_to_buflen(buf_ctx) :
+					 small_buflen(vi);
+	virtnet_rq_unmap(rq, buf, min(*len, buflen));
+
+	if (ctx)
+		*ctx = buf_ctx;
 
 	return buf;
 }
@@ -2698,7 +2723,7 @@ static int add_recvbuf_small(struct virtnet_info *vi, struct receive_queue *rq,
 
 	buf += VIRTNET_RX_PAD + xdp_headroom;
 
-	virtnet_rq_init_one_sg(rq, buf, vi->hdr_len + GOOD_PACKET_LEN);
+	virtnet_rq_init_one_sg(rq, buf, small_buflen(vi));
 
 	err = virtqueue_add_inbuf_premapped(rq->vq, rq->sg, 1, buf, ctx, gfp);
 	if (err < 0) {
-- 
2.53.0



