Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426FF2192F2;
	Tue, 26 Aug 2025 14:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217200; cv=none; b=oNqWSCPkUlYSXp6+Ctqo7XwlN8zdf0sKfWZ3U+0FnIMh9wdcbPmHedE/3v31Dn2IYEVQdu1yb6rrs+S/M0X8tNAfrGbNtcPFm3AhrMK7xEfH70o2zy2SktyhRkxzqck0d4KbI4bYDs5dB6DCWLJVEC8MUqkNCqzLIoNBBHjKz54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217200; c=relaxed/simple;
	bh=luFQrnHwPf9684fAPp2uAqyGsRF8GZ9i8pKqJia7OFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XssJB611DzzW48CP8j3u0o0PtuC0eNC1M7gHDiKfkJq1mrjZnSOYsTNCpQoMd/pOTF8ppP1CTGdaqTfvOGUg27jaEbiJFgHQ9lp0/HF8DwS70L4c9CXrAFl//1Ck9Lvc3yNAOqZNxTuGX6juq1TOCsDUSpLqKYwjZX3Cbmj2OGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOS0JPHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOS0JPHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA71FC113CF;
	Tue, 26 Aug 2025 14:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217200;
	bh=luFQrnHwPf9684fAPp2uAqyGsRF8GZ9i8pKqJia7OFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOS0JPHoJi+UypARgZZyY3K1zJVZsy2y8KjzHzPjnJOStpLFyxFr9syJ20wXZBqqU
	 N59086UAn/7l1SOj75Sw/yCh1ouYgfhjZnXW8bgZAMi3y/u9TUTMSsxNxt9ybBJKu+
	 YQaCDdXaViot8EVcDl/K7zRsRsmscUgsXKXs14sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/523] virtio-net: ensure the received length does not exceed allocated size
Date: Tue, 26 Aug 2025 13:04:23 +0200
Message-ID: <20250826110925.903845524@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ adapted virtqueue_get_buf() to virtqueue_get_buf_ctx() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -394,6 +394,26 @@ static unsigned int mergeable_ctx_to_tru
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
@@ -639,7 +659,8 @@ static unsigned int virtnet_get_headroom
  * across multiple buffers (num_buf > 1), and we make sure buffers
  * have enough headroom.
  */
-static struct page *xdp_linearize_page(struct receive_queue *rq,
+static struct page *xdp_linearize_page(struct net_device *dev,
+				       struct receive_queue *rq,
 				       u16 *num_buf,
 				       struct page *p,
 				       int offset,
@@ -659,18 +680,27 @@ static struct page *xdp_linearize_page(s
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
@@ -745,7 +775,7 @@ static struct sk_buff *receive_small(str
 			headroom = vi->hdr_len + header_offset;
 			buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
 				 SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-			xdp_page = xdp_linearize_page(rq, &num_buf, page,
+			xdp_page = xdp_linearize_page(dev, rq, &num_buf, page,
 						      offset, header_offset,
 						      &tlen);
 			if (!xdp_page)
@@ -916,7 +946,7 @@ static struct sk_buff *receive_mergeable
 		if (unlikely(num_buf > 1 ||
 			     headroom < virtnet_get_headroom(vi))) {
 			/* linearize data for XDP */
-			xdp_page = xdp_linearize_page(rq, &num_buf,
+			xdp_page = xdp_linearize_page(dev, rq, &num_buf,
 						      page, offset,
 						      VIRTIO_XDP_HEADROOM,
 						      &len);


