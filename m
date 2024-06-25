Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B110148851;
	Tue, 25 Jun 2024 09:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309098; cv=none; b=J6oqlQEKNtwO6IVDUjQ5OKEmCtXeVLVd5qzeB3zVH1A+2HzeCFAZ8Jv6dp/cxKBYp9WjxTwlXfdB3HnXTMfHVlJxtnsLGqWeZDLe1OrwPwgw6rNt0VVhDzqjs83Y5A6+7rpqkjYIS1EYFAEjFARk65LALno3uh3oZ7Bp1XgvzbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309098; c=relaxed/simple;
	bh=FNfmBUgrypOUof2vTuWki//VF2dU8wl08AG286GStHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evK6ekYb/cxt6aXYJMTkCLIPT0xmqmMi1FfAX6GnBERNzlsIxNdZPQQ0lP2n7jqkcsJhBPMEZ757oB9qVgniK+ZS2M/N2OOjb/5TSlLuaxqW0rUikg6ghwXm8Kzbyr4jcl0JhYXDa715b/kXMZVgiHLRZ59QTlmJp7a45zFKapM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJWJtIly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJWJtIly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4ABC32781;
	Tue, 25 Jun 2024 09:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309098;
	bh=FNfmBUgrypOUof2vTuWki//VF2dU8wl08AG286GStHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJWJtIly9t0Gx4s9MHGnZG2AAUP/GZDGgYMxa1vNAx2LVhTJPA1DLLDWYbetyAaOh
	 S8xiytXyL7KjvSWFwksKzXRc4JtFT4Ej6ZE0fZWAMoVxEaw86zXqhRBpey9720qmL5
	 bhX767V4TwFC16VsYcoTPDtADjZ6ltbVgYqaU4Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heng Qi <hengqi@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/192] virtio_net: fixing XDP for fully checksummed packets handling
Date: Tue, 25 Jun 2024 11:32:47 +0200
Message-ID: <20240625085540.825512479@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 32867e7637ad4..51ade909c84f0 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1190,6 +1190,10 @@ static struct sk_buff *receive_small_xdp(struct net_device *dev,
 	if (unlikely(hdr->hdr.gso_type))
 		goto err_xdp;
 
+	/* Partially checksummed packets must be dropped. */
+	if (unlikely(hdr->hdr.flags & VIRTIO_NET_HDR_F_NEEDS_CSUM))
+		goto err_xdp;
+
 	buflen = SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
 		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
@@ -1507,6 +1511,10 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
 	if (unlikely(hdr->hdr.gso_type))
 		return NULL;
 
+	/* Partially checksummed packets must be dropped. */
+	if (unlikely(hdr->hdr.flags & VIRTIO_NET_HDR_F_NEEDS_CSUM))
+		return NULL;
+
 	/* Now XDP core assumes frag size is PAGE_SIZE, but buffers
 	 * with headroom may add hole in truesize, which
 	 * make their length exceed PAGE_SIZE. So we disabled the
@@ -1773,6 +1781,7 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 	struct net_device *dev = vi->dev;
 	struct sk_buff *skb;
 	struct virtio_net_common_hdr *hdr;
+	u8 flags;
 
 	if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
 		pr_debug("%s: short packet %i\n", dev->name, len);
@@ -1781,6 +1790,15 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
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
@@ -1796,7 +1814,7 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 	if (dev->features & NETIF_F_RXHASH && vi->has_rss_hash_report)
 		virtio_skb_set_hash(&hdr->hash_v1_hdr, skb);
 
-	if (hdr->hdr.flags & VIRTIO_NET_HDR_F_DATA_VALID)
+	if (flags & VIRTIO_NET_HDR_F_DATA_VALID)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 	if (virtio_net_hdr_to_skb(skb, &hdr->hdr,
-- 
2.43.0



