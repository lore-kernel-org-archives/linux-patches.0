Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBF32FFFA2;
	Tue, 11 Nov 2025 01:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824940; cv=none; b=GxKeO5KhsPjLYOkL4/+0tbWvdpUnYE102SRFBJTSNPvNBnVvhbYEMPN9x439gKqbPKVOOKmKtGqhdJ3KaeO3j2tBKFI/0O6z2nTy73l9bA/o7epTx/6bg/mYawFPct9s0zo3VkSzFLe56IykGAsovzn67JOLHykmFfMW3ei5x70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824940; c=relaxed/simple;
	bh=rOGvzcoJg2PhWzLU3DV7eru5eJhgZmBOmrcmVHUwR+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsTuGNUJS1nALjoClUxKE8JcisfAmlP7upijtbA09BZgRizsdVr1zn7djToP5Y77JdeulIidgSYlr+hQiazXFZtc5u1GJnQauBLG/n+26x0QKr7agQEFS5irKg71HIQbOIeUpwHpF/N0K9TBJj/c/vIVDbacbuyFKxckZIRk3PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=of/n+cMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="of/n+cMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35761C4CEFB;
	Tue, 11 Nov 2025 01:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824940;
	bh=rOGvzcoJg2PhWzLU3DV7eru5eJhgZmBOmrcmVHUwR+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=of/n+cMC9wFpTG6e7JneKvIzz9R61x9Hs0hOeM43x/Vb/mJtFGlyiMO2SBVPhI/c6
	 yRnnvKBkTogt3apDk4UspBPHUeqvvY7j8mYMVy78wba2Y9kXUSMXCD5CJrK9fi8B6j
	 qy+D9fCX8TmPgy/KCUE8NJPEZ9AaaWUFv3+2UtwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Lei Yang <leiyang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 554/565] virtio-net: fix received length check in big packets
Date: Tue, 11 Nov 2025 09:46:50 +0900
Message-ID: <20251111004539.467092243@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bui Quang Minh <minhquangbui99@gmail.com>

commit 0c716703965ffc5ef4311b65cb5d84a703784717 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -868,17 +868,6 @@ static struct sk_buff *page_to_skb(struc
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
@@ -1928,9 +1917,19 @@ static struct sk_buff *receive_big(struc
 				   struct virtnet_rq_stats *stats)
 {
 	struct page *page = buf;
-	struct sk_buff *skb =
-		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, 0);
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
 
+	skb = page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, 0);
 	u64_stats_add(&stats->bytes, len - vi->hdr_len);
 	if (unlikely(!skb))
 		goto err;


