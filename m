Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A69192D8A;
	Tue, 15 Jul 2025 13:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586166; cv=none; b=ktWHeWq0s46WzEe9GqMxG0e1ND2n6yCEwxnt77pB/5FbaznvhoJZClxYqx7lmZAtO0Ne99kHJozAK8swEy6L78UfD/gZxc1ecO047hJvqVL5bsPwxenoG3nUBQYjVMtzRLafWx0b6Q8WcmTwn1kiZZPRhEAnmrpg+9aA7wxNT1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586166; c=relaxed/simple;
	bh=EKanGoLWzK1JLA6mZihGGWGcyhCK6Z+v26QWmpU08UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2QEAXqMRdb7a6A3209Xxei5Z7eVRafxVyU4jfvdpKYF80hwiJ54g3EP5B5J1Q6oz6wCCIl1vnKJ1kcsp/tzm4zXozRJMzTip+/75br+Yb853AyH5FuwH/SQWXujbuavUKoVZu4NLTZ7AiQ8aI4P8uAWJX5/Ib+4QJ/sqU9F0CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prq8Mm9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prq8Mm9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB3FC4CEF1;
	Tue, 15 Jul 2025 13:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586165;
	bh=EKanGoLWzK1JLA6mZihGGWGcyhCK6Z+v26QWmpU08UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prq8Mm9tof65p2LsrXgj1crDbLjrNucOt3gmHUR6TbYDEbNXKYRmokSHb3Ppx9Xqn
	 oW9zLJ/a/UqC1zV1dQO1N3UliPVGUVfTk5Ukv0Pr2xhoSveteJn/S5JnFWIvQp7ufA
	 U1o2TKSqM9W8Mc7V0V8tYZay71o0gSrmc/e1hrsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 41/77] virtio-net: ensure the received length does not exceed allocated size
Date: Tue, 15 Jul 2025 15:13:40 +0200
Message-ID: <20250715130753.357409619@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bui Quang Minh <minhquangbui99@gmail.com>

[ Upstream commit 315dbdd7cdf6aa533829774caaf4d25f1fd20e73 ]

In xdp_linearize_page, when reading the following buffers from the ring,
we forget to check the received length with the true allocate size. This
can lead to an out-of-bound read. This commit adds that missing check.

Cc: <stable@vger.kernel.org>
Fixes: 4941d472bf95 ("virtio-net: do not reset during XDP set")
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://patch.msgid.link/20250630144212.48471-2-minhquangbui99@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 44 ++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d8138ad4f865a..ed27dd5c7fc8d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -394,6 +394,26 @@ static unsigned int mergeable_ctx_to_truesize(void *mrg_ctx)
 	return (unsigned long)mrg_ctx & ((1 << MRG_CTX_HEADER_SHIFT) - 1);
 }
 
+static int check_mergeable_len(struct net_device *dev, void *mrg_ctx,
+			       unsigned int len)
+{
+	unsigned int headroom, tailroom, room, truesize;
+
+	truesize = mergeable_ctx_to_truesize(mrg_ctx);
+	headroom = mergeable_ctx_to_headroom(mrg_ctx);
+	tailroom = headroom ? sizeof(struct skb_shared_info) : 0;
+	room = SKB_DATA_ALIGN(headroom + tailroom);
+
+	if (len > truesize - room) {
+		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
+			 dev->name, len, (unsigned long)(truesize - room));
+		dev->stats.rx_length_errors++;
+		return -1;
+	}
+
+	return 0;
+}
+
 /* Called from bottom half context */
 static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 				   struct receive_queue *rq,
@@ -672,8 +692,9 @@ static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
  * across multiple buffers (num_buf > 1), and we make sure buffers
  * have enough headroom.
  */
-static struct page *xdp_linearize_page(struct receive_queue *rq,
-				       u16 *num_buf,
+static struct page *xdp_linearize_page(struct net_device *dev,
+				       struct receive_queue *rq,
+				       int *num_buf,
 				       struct page *p,
 				       int offset,
 				       int page_off,
@@ -692,18 +713,27 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
 	memcpy(page_address(page) + page_off, page_address(p) + offset, *len);
 	page_off += *len;
 
+	/* Only mergeable mode can go inside this while loop. In small mode,
+	 * *num_buf == 1, so it cannot go inside.
+	 */
 	while (--*num_buf) {
 		unsigned int buflen;
 		void *buf;
+		void *ctx;
 		int off;
 
-		buf = virtqueue_get_buf(rq->vq, &buflen);
+		buf = virtqueue_get_buf_ctx(rq->vq, &buflen, &ctx);
 		if (unlikely(!buf))
 			goto err_buf;
 
 		p = virt_to_head_page(buf);
 		off = buf - page_address(p);
 
+		if (check_mergeable_len(dev, ctx, buflen)) {
+			put_page(p);
+			goto err_buf;
+		}
+
 		/* guard against a misconfigured or uncooperative backend that
 		 * is sending packet larger than the MTU.
 		 */
@@ -771,14 +801,14 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		if (unlikely(xdp_headroom < virtnet_get_headroom(vi))) {
 			int offset = buf - page_address(page) + header_offset;
 			unsigned int tlen = len + vi->hdr_len;
-			u16 num_buf = 1;
+			int num_buf = 1;
 
 			xdp_headroom = virtnet_get_headroom(vi);
 			header_offset = VIRTNET_RX_PAD + xdp_headroom;
 			headroom = vi->hdr_len + header_offset;
 			buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
 				 SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-			xdp_page = xdp_linearize_page(rq, &num_buf, page,
+			xdp_page = xdp_linearize_page(dev, rq, &num_buf, page,
 						      offset, header_offset,
 						      &tlen);
 			if (!xdp_page)
@@ -949,10 +979,12 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		if (unlikely(num_buf > 1 ||
 			     headroom < virtnet_get_headroom(vi))) {
 			/* linearize data for XDP */
-			xdp_page = xdp_linearize_page(rq, &num_buf,
+			int _num_buf = num_buf;
+			xdp_page = xdp_linearize_page(dev, rq, &_num_buf,
 						      page, offset,
 						      VIRTIO_XDP_HEADROOM,
 						      &len);
+			num_buf = _num_buf;
 			frame_sz = PAGE_SIZE;
 
 			if (!xdp_page)
-- 
2.39.5



