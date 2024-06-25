Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E47B148FE5;
	Tue, 25 Jun 2024 09:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308565; cv=none; b=UazyHEm55DUBsEbtS7nKcOhjFBzLStM4xThaLvh7FAno4Nc10aDYRijIaNdY0Tj7svB0YyHqwiGcws+4/xWFnfsVeWcn1WVVDBF3uDnuBGKQ2Wu7OuhShwrZdrbtHH3hIaQ0zNHSV3c4+aRQ+6Fhelrik8BETbs1xQ3DVpWJJHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308565; c=relaxed/simple;
	bh=CvuO6FHFvigCzXBUVH9MIiTxoY7Vmcp1f5CKU8NiBJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xsuz1fSzujYvqwkNUXtAq02jYAIcexsKwggXR1AdAHPBFWOSP8PcRNR3IkDanISch+ClLyg/RbYF+LxpbkKkkbz3Rl7PIVVgPHaxcNzqQ6x5sIJl1g+mMxj1F3MTUFw6rL6ZOn43dSH2MA/lewkqA6LSx1sYTCW90bdPzzJ0Ezw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fb+CBIcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fb+CBIcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128D9C32781;
	Tue, 25 Jun 2024 09:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308565;
	bh=CvuO6FHFvigCzXBUVH9MIiTxoY7Vmcp1f5CKU8NiBJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fb+CBIcXUSHbojggmaWYLz/Ep4ZiGTziRXPCsynaccTqpt/DXIaVZ1/1PMfpyG2jx
	 2C41DCOMaghMlNf+bcCef5SSEUmcqowPiwghki/AW1o3XW0X5hr7pcZTnduJ5A0i7n
	 SOsjHuT5zYNbFSHwTiwYJvH9C2ov4N1t5ZATFjTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heng Qi <hengqi@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 133/250] virtio_net: fixing XDP for fully checksummed packets handling
Date: Tue, 25 Jun 2024 11:31:31 +0200
Message-ID: <20240625085553.168138457@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heng Qi <hengqi@linux.alibaba.com>

[ Upstream commit 703eec1b242276f2d97d98f04790ddad319ddde4 ]

The XDP program can't correctly handle partially checksummed
packets, but works fine with fully checksummed packets. If the
device has already validated fully checksummed packets, then
the driver doesn't need to re-validate them, saving CPU resources.

Additionally, the driver does not drop all partially checksummed
packets when VIRTIO_NET_F_GUEST_CSUM is not negotiated. This is
not a bug, as the driver has always done this.

Fixes: 436c9453a1ac ("virtio-net: keep vnet header zeroed after processing XDP")
Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 633de371762b6..290bec2926463 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1225,6 +1225,10 @@ static struct sk_buff *receive_small_xdp(struct net_device *dev,
 	if (unlikely(hdr->hdr.gso_type))
 		goto err_xdp;
 
+	/* Partially checksummed packets must be dropped. */
+	if (unlikely(hdr->hdr.flags & VIRTIO_NET_HDR_F_NEEDS_CSUM))
+		goto err_xdp;
+
 	buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
 		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
@@ -1542,6 +1546,10 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
 	if (unlikely(hdr->hdr.gso_type))
 		return NULL;
 
+	/* Partially checksummed packets must be dropped. */
+	if (unlikely(hdr->hdr.flags & VIRTIO_NET_HDR_F_NEEDS_CSUM))
+		return NULL;
+
 	/* Now XDP core assumes frag size is PAGE_SIZE, but buffers
 	 * with headroom may add hole in truesize, which
 	 * make their length exceed PAGE_SIZE. So we disabled the
@@ -1808,6 +1816,7 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 	struct net_device *dev = vi->dev;
 	struct sk_buff *skb;
 	struct virtio_net_common_hdr *hdr;
+	u8 flags;
 
 	if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
 		pr_debug("%s: short packet %i\n", dev->name, len);
@@ -1816,6 +1825,15 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 		return;
 	}
 
+	/* 1. Save the flags early, as the XDP program might overwrite them.
+	 * These flags ensure packets marked as VIRTIO_NET_HDR_F_DATA_VALID
+	 * stay valid after XDP processing.
+	 * 2. XDP doesn't work with partially checksummed packets (refer to
+	 * virtnet_xdp_set()), so packets marked as
+	 * VIRTIO_NET_HDR_F_NEEDS_CSUM get dropped during XDP processing.
+	 */
+	flags = ((struct virtio_net_common_hdr *)buf)->hdr.flags;
+
 	if (vi->mergeable_rx_bufs)
 		skb = receive_mergeable(dev, vi, rq, buf, ctx, len, xdp_xmit,
 					stats);
@@ -1831,7 +1849,7 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 	if (dev->features & NETIF_F_RXHASH && vi->has_rss_hash_report)
 		virtio_skb_set_hash(&hdr->hash_v1_hdr, skb);
 
-	if (hdr->hdr.flags & VIRTIO_NET_HDR_F_DATA_VALID)
+	if (flags & VIRTIO_NET_HDR_F_DATA_VALID)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 	if (virtio_net_hdr_to_skb(skb, &hdr->hdr,
-- 
2.43.0



