Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4BD1E0493;
	Tue, 17 Dec 2024 17:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456136; cv=none; b=sPRXdiBe9Pg7aLCLyzguQrlNe8MpdScm2KxVGVJGG65OxWyCe0cr73qz1MBQlloXEcvu9wgBisLkcrVenKdgOg2NhCUZLDaI1R3ha697TfsmrIJWASH5BdKAx7KQP5VCqJ018kHeRdoqLY6rgyT74U9Hshp4H92OvXl2JEj50/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456136; c=relaxed/simple;
	bh=f3Ozzg8Xrz1+xp8mhDY1agm3VyRdsZ3a9Y/hc3q3fAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ma+aACaBJGoJGJi4JU/cQcIrC+vk/SHKue2+ny/c4cBsF1Hkv4QnJUqg8f/OKU3byvwubjZ/mDcd0ypHqlabU5Gru9/2rQ/75nzYH6cJyRd+89x8C9e0lT+L8eNUAXkUJXRVBLk3SUEiVHEuTNDrPKuA4fqvWbnoufeAPOeEHNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ql++vaEp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ql++vaEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45632C4CED3;
	Tue, 17 Dec 2024 17:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456136;
	bh=f3Ozzg8Xrz1+xp8mhDY1agm3VyRdsZ3a9Y/hc3q3fAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ql++vaEplYqnOTFVCjnWyPqBz/IPJrreP85KjlxNYFwiQu+Gug/CaZLb7Ndp4DfkS
	 QqAqryvWGI/YyO5GgTSwUvs+yHyS38KVwNTQAF5SMOsZ6sJ4PMbf+qSouLFvQY9w6E
	 0rchcqu/vrmRenvCD0uUlYAleQrc2fx4lPrJmB5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/109] net: rswitch: Add jumbo frames handling for TX
Date: Tue, 17 Dec 2024 18:07:57 +0100
Message-ID: <20241217170536.432005101@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit d2c96b9d5f83e4327cf044d00d7f713edd7fecfd ]

If the driver would like to transmit a jumbo frame like 2KiB or more,
it should be split into multiple queues. In the near future, to support
this, add handling specific descriptor types F{START,MID,END}. However,
such jumbo frames will not happen yet because the maximum MTU size is
still default for now.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0c9547e6ccf4 ("net: renesas: rswitch: fix race window between tx start and complete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 56 +++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index c01b4bd3f812..17be2479654a 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1561,15 +1561,44 @@ static bool rswitch_ext_desc_set(struct rswitch_device *rdev,
 	return true;
 }
 
+static u8 rswitch_ext_desc_get_die_dt(unsigned int nr_desc, unsigned int index)
+{
+	if (nr_desc == 1)
+		return DT_FSINGLE | DIE;
+	if (index == 0)
+		return DT_FSTART;
+	if (nr_desc - 1 == index)
+		return DT_FEND | DIE;
+	return DT_FMID;
+}
+
+static u16 rswitch_ext_desc_get_len(u8 die_dt, unsigned int orig_len)
+{
+	switch (die_dt & DT_MASK) {
+	case DT_FSINGLE:
+	case DT_FEND:
+		return (orig_len % RSWITCH_DESC_BUF_SIZE) ?: RSWITCH_DESC_BUF_SIZE;
+	case DT_FSTART:
+	case DT_FMID:
+		return RSWITCH_DESC_BUF_SIZE;
+	default:
+		return 0;
+	}
+}
+
 static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct rswitch_device *rdev = netdev_priv(ndev);
 	struct rswitch_gwca_queue *gq = rdev->tx_queue;
+	dma_addr_t dma_addr, dma_addr_orig;
 	netdev_tx_t ret = NETDEV_TX_OK;
 	struct rswitch_ext_desc *desc;
-	dma_addr_t dma_addr;
+	unsigned int i, nr_desc;
+	u8 die_dt;
+	u16 len;
 
-	if (rswitch_get_num_cur_queues(gq) >= gq->ring_size - 1) {
+	nr_desc = (skb->len - 1) / RSWITCH_DESC_BUF_SIZE + 1;
+	if (rswitch_get_num_cur_queues(gq) >= gq->ring_size - nr_desc) {
 		netif_stop_subqueue(ndev, 0);
 		return NETDEV_TX_BUSY;
 	}
@@ -1577,25 +1606,32 @@ static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd
 	if (skb_put_padto(skb, ETH_ZLEN))
 		return ret;
 
-	dma_addr = dma_map_single(ndev->dev.parent, skb->data, skb->len, DMA_TO_DEVICE);
-	if (dma_mapping_error(ndev->dev.parent, dma_addr))
+	dma_addr_orig = dma_map_single(ndev->dev.parent, skb->data, skb->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(ndev->dev.parent, dma_addr_orig))
 		goto err_kfree;
 
 	gq->skbs[gq->cur] = skb;
-	gq->unmap_addrs[gq->cur] = dma_addr;
-	desc = &gq->tx_ring[gq->cur];
-	if (!rswitch_ext_desc_set(rdev, skb, desc, dma_addr, skb->len, DT_FSINGLE | DIE))
-		goto err_unmap;
+	gq->unmap_addrs[gq->cur] = dma_addr_orig;
+
+	/* DT_FSTART should be set at last. So, this is reverse order. */
+	for (i = nr_desc; i-- > 0; ) {
+		desc = &gq->tx_ring[rswitch_next_queue_index(gq, true, i)];
+		die_dt = rswitch_ext_desc_get_die_dt(nr_desc, i);
+		dma_addr = dma_addr_orig + i * RSWITCH_DESC_BUF_SIZE;
+		len = rswitch_ext_desc_get_len(die_dt, skb->len);
+		if (!rswitch_ext_desc_set(rdev, skb, desc, dma_addr, len, die_dt))
+			goto err_unmap;
+	}
 
 	wmb();	/* gq->cur must be incremented after die_dt was set */
 
-	gq->cur = rswitch_next_queue_index(gq, true, 1);
+	gq->cur = rswitch_next_queue_index(gq, true, nr_desc);
 	rswitch_modify(rdev->addr, GWTRC(gq->index), 0, BIT(gq->index % 32));
 
 	return ret;
 
 err_unmap:
-	dma_unmap_single(ndev->dev.parent, dma_addr, skb->len, DMA_TO_DEVICE);
+	dma_unmap_single(ndev->dev.parent, dma_addr_orig, skb->len, DMA_TO_DEVICE);
 
 err_kfree:
 	dev_kfree_skb_any(skb);
-- 
2.39.5



