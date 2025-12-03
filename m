Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2363164D0;
	Wed,  3 Dec 2025 16:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779959; cv=none; b=tKnIe/dYdbjkz6vwb3Arl3bMMqJsda2/QpmX11CD4NhJYzVjd+8A9AtHRb3TULFTQwJ99pKHpwzEUKYKxr2p5Q+YnvdSfWU76Rrww/K3Afr+5HSLnokGnwXZTCg/uZtYvT9bEx/kJZzIep6ExBHg0TOGFgYMSyxh1W9BE2P7s/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779959; c=relaxed/simple;
	bh=Syh1M6dps5uPFlOKQLAHuihooVn/rYA3lIgwiKs+9N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZDpam0jfI1pLWCjIbRvK2BESM9QC9SD2DQgRJJNuzebzJPx3vvaFFCv5wOQRKB1NSjzUBzvjTjR7wso8JSofTxS7j6NNwd6c9+aeIA4uZyUaEWn8WbQqvrknrOMiGluO6BxeOqYt/c2sF4iHgCyXtSl/P/4vukrcjFE3I8jdYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duZnd7sJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duZnd7sJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A00C4CEF5;
	Wed,  3 Dec 2025 16:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779958;
	bh=Syh1M6dps5uPFlOKQLAHuihooVn/rYA3lIgwiKs+9N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duZnd7sJCj029dUxnB/L0WD0ZXoc4SvNmJ0IZQDrOJUX0SfeLxXlaIc3lPMvwtEhg
	 e2GYl1IlPbz8H6CWxNbmj1ylFttZvTOlF4o524S4dAMySgdfC3zERqNJ8FS78ayYgu
	 RDdQSYcEG0vXHjqSfbCKqO3TsRn/rNrgLCK/Ny44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Lei Yang <leiyang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 413/568] virtio-net: fix received length check in big packets
Date: Wed,  3 Dec 2025 16:26:55 +0100
Message-ID: <20251203152455.818643972@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bui Quang Minh <minhquangbui99@gmail.com>

[ Upstream commit 0c716703965ffc5ef4311b65cb5d84a703784717 ]

Since commit 4959aebba8c0 ("virtio-net: use mtu size as buffer length
for big packets"), when guest gso is off, the allocated size for big
packets is not MAX_SKB_FRAGS * PAGE_SIZE anymore but depends on
negotiated MTU. The number of allocated frags for big packets is stored
in vi->big_packets_num_skbfrags.

Because the host announced buffer length can be malicious (e.g. the host
vhost_net driver's get_rx_bufs is modified to announce incorrect
length), we need a check in virtio_net receive path. Currently, the
check is not adapted to the new change which can lead to NULL page
pointer dereference in the below while loop when receiving length that
is larger than the allocated one.

This commit fixes the received length check corresponding to the new
change.

Fixes: 4959aebba8c0 ("virtio-net: use mtu size as buffer length for big packets")
Cc: stable@vger.kernel.org
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Link: https://patch.msgid.link/20251030144438.7582-1-minhquangbui99@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adapted page_to_skb() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -542,17 +542,6 @@ static struct sk_buff *page_to_skb(struc
 		goto ok;
 	}
 
-	/*
-	 * Verify that we can indeed put this data into a skb.
-	 * This is here to handle cases when the device erroneously
-	 * tries to receive more than is possible. This is usually
-	 * the case of a broken device.
-	 */
-	if (unlikely(len > MAX_SKB_FRAGS * PAGE_SIZE)) {
-		net_dbg_ratelimited("%s: too much data\n", skb->dev->name);
-		dev_kfree_skb(skb);
-		return NULL;
-	}
 	BUG_ON(offset >= PAGE_SIZE);
 	while (len) {
 		unsigned int frag_size = min((unsigned)PAGE_SIZE - offset, len);
@@ -955,8 +944,19 @@ static struct sk_buff *receive_big(struc
 				   struct virtnet_rq_stats *stats)
 {
 	struct page *page = buf;
-	struct sk_buff *skb =
-		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0, 0);
+	struct sk_buff *skb;
+
+	/* Make sure that len does not exceed the size allocated in
+	 * add_recvbuf_big.
+	 */
+	if (unlikely(len > (vi->big_packets_num_skbfrags + 1) * PAGE_SIZE)) {
+		pr_debug("%s: rx error: len %u exceeds allocated size %lu\n",
+			 dev->name, len,
+			 (vi->big_packets_num_skbfrags + 1) * PAGE_SIZE);
+		goto err;
+	}
+
+	skb = page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0, 0);
 
 	stats->bytes += len - vi->hdr_len;
 	if (unlikely(!skb))


