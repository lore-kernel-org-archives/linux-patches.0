Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36A72E54C3;
	Tue,  8 Jul 2025 16:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992588; cv=none; b=MOph3iFY9IVFF+iJa/4WowL0TY8yHOkMvAqP3j87hoOTdTJYbhy4DKqhoYNn1VyPv2Jzr0ESL3Yw+FW4hEN8zr7lRG6bW+85qu+ZLIfxapUi4SZyyPGw/Bo6UNreqcE+eGv8SlYA7/FAxZbQySpEtW06zQCLBZ12q8Km9dO3K4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992588; c=relaxed/simple;
	bh=n1tkC4GaGGVg9bLOg7LX5NlGjqS/XutsYkiXn5xLEh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkUQ7iFMVo7f8RkNwe/jtmv9XqaW5rs50F25fEIk2SMAbtBwB0FJUDYfBq8G04hPZee57OH1COaMq2p/JTzShKBebe3TWjLh82CXDAcYwBuATkxE/IdzVkZldhSFLyn995W+21SaWfqSnnzyOngMOv+Nx+Zdq3Rx/ISdkv7cyb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmITmKVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmITmKVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EFEC4CEED;
	Tue,  8 Jul 2025 16:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992588;
	bh=n1tkC4GaGGVg9bLOg7LX5NlGjqS/XutsYkiXn5xLEh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmITmKVUxZT0dh57DfZs75iK3SCugqGcG5n+Ycy/aKOWFZr/UG2sjL9Q1fT+EhJV7
	 CWbYNkIvlKhVDkIWBOB2SRxEkR9MqQDypV36/OLvcfIA902EaWZO3volGnTQ6DtU3I
	 0dwEkncGrHSrZ0R5vz3kEufqzUmV6ELbMEI5ZCsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 005/232] virtio-net: ensure the received length does not exceed allocated size
Date: Tue,  8 Jul 2025 18:20:01 +0200
Message-ID: <20250708162241.572921978@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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
@@ -765,6 +765,26 @@ static unsigned int mergeable_ctx_to_tru
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
@@ -1663,7 +1683,8 @@ static unsigned int virtnet_get_headroom
  * across multiple buffers (num_buf > 1), and we make sure buffers
  * have enough headroom.
  */
-static struct page *xdp_linearize_page(struct receive_queue *rq,
+static struct page *xdp_linearize_page(struct net_device *dev,
+				       struct receive_queue *rq,
 				       int *num_buf,
 				       struct page *p,
 				       int offset,
@@ -1683,18 +1704,27 @@ static struct page *xdp_linearize_page(s
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
@@ -1783,7 +1813,7 @@ static struct sk_buff *receive_small_xdp
 		headroom = vi->hdr_len + header_offset;
 		buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
 			SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-		xdp_page = xdp_linearize_page(rq, &num_buf, page,
+		xdp_page = xdp_linearize_page(dev, rq, &num_buf, page,
 					      offset, header_offset,
 					      &tlen);
 		if (!xdp_page)
@@ -2118,7 +2148,7 @@ static void *mergeable_xdp_get_buf(struc
 	 */
 	if (!xdp_prog->aux->xdp_has_frags) {
 		/* linearize data for XDP */
-		xdp_page = xdp_linearize_page(rq, num_buf,
+		xdp_page = xdp_linearize_page(vi->dev, rq, num_buf,
 					      *page, offset,
 					      XDP_PACKET_HEADROOM,
 					      len);


