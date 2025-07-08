Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3D28F5B;
	Tue,  8 Jul 2025 16:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993258; cv=none; b=DCbUVIdtjmixaFLFoPrTeZB1vb41HI1pbgAEc7lXZHC35N6AIBWypr2XWGaFzvo6NuMzxYPWGTjSusYW5tgzMGRXGJ69FiOCt2L8lYlmSQ2QHFKjijUA+v0AdHi5DPl1Okc5m7Wc9qQyshtH8nG3y7dSXn5ugLiP45nSpPR0+YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993258; c=relaxed/simple;
	bh=H27B9QnMrwIFjm7vJY5qFjm6sJ4Y3z3nccrWBirb8yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/qbc03PFlHzbcGHMJYH9HAsxME/1K4bRgzUNhYh7UntYzSX4ONcLtj5t4EMw45Ppmtqx6T1AkjyUCIlwhDQYutNESrZnR7uGEP0JFNqb22o6PNWSgvJitdSwNECH6VEguTtutNqyzqvdNVMG7+NCEvS584FxRSmYjTab8qhbEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORliLfXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORliLfXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8F3C4CEED;
	Tue,  8 Jul 2025 16:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993258;
	bh=H27B9QnMrwIFjm7vJY5qFjm6sJ4Y3z3nccrWBirb8yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORliLfXGAztGL2UnJ9K0nxEY9Tj5RAMTd1F9xozQGOX2mZL6TAF/hLVbpch83r97+
	 gn3UJ94jso97PpyvIMsWRUT7ICLaUPs+qFhHG3Qr+8aXa1T+a6GFVC+trK8rerUV51
	 DQhC/qvSPUw6eYGeCB5zApIC62E0LMgm5k9+5Qd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.15 005/178] virtio-net: ensure the received length does not exceed allocated size
Date: Tue,  8 Jul 2025 18:20:42 +0200
Message-ID: <20250708162236.695152926@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bui Quang Minh <minhquangbui99@gmail.com>

commit 315dbdd7cdf6aa533829774caaf4d25f1fd20e73 upstream.

In xdp_linearize_page, when reading the following buffers from the ring,
we forget to check the received length with the true allocate size. This
can lead to an out-of-bound read. This commit adds that missing check.

Cc: <stable@vger.kernel.org>
Fixes: 4941d472bf95 ("virtio-net: do not reset during XDP set")
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://patch.msgid.link/20250630144212.48471-2-minhquangbui99@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -778,6 +778,26 @@ static unsigned int mergeable_ctx_to_tru
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
+		DEV_STATS_INC(dev, rx_length_errors);
+		return -1;
+	}
+
+	return 0;
+}
+
 static struct sk_buff *virtnet_build_skb(void *buf, unsigned int buflen,
 					 unsigned int headroom,
 					 unsigned int len)
@@ -1811,7 +1831,8 @@ static unsigned int virtnet_get_headroom
  * across multiple buffers (num_buf > 1), and we make sure buffers
  * have enough headroom.
  */
-static struct page *xdp_linearize_page(struct receive_queue *rq,
+static struct page *xdp_linearize_page(struct net_device *dev,
+				       struct receive_queue *rq,
 				       int *num_buf,
 				       struct page *p,
 				       int offset,
@@ -1831,18 +1852,27 @@ static struct page *xdp_linearize_page(s
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
 
-		buf = virtnet_rq_get_buf(rq, &buflen, NULL);
+		buf = virtnet_rq_get_buf(rq, &buflen, &ctx);
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
@@ -1931,7 +1961,7 @@ static struct sk_buff *receive_small_xdp
 		headroom = vi->hdr_len + header_offset;
 		buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
 			SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-		xdp_page = xdp_linearize_page(rq, &num_buf, page,
+		xdp_page = xdp_linearize_page(dev, rq, &num_buf, page,
 					      offset, header_offset,
 					      &tlen);
 		if (!xdp_page)
@@ -2266,7 +2296,7 @@ static void *mergeable_xdp_get_buf(struc
 	 */
 	if (!xdp_prog->aux->xdp_has_frags) {
 		/* linearize data for XDP */
-		xdp_page = xdp_linearize_page(rq, num_buf,
+		xdp_page = xdp_linearize_page(vi->dev, rq, num_buf,
 					      *page, offset,
 					      XDP_PACKET_HEADROOM,
 					      len);


