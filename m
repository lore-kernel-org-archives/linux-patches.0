Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6B21C68C;
	Sun,  1 Sep 2024 16:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208838; cv=none; b=IO78y50TnAAGYGYHsfocWCimT6IDuYXUvZJSOzv6Aq2bPX8dHjILPuNx/bJW02KrO8TswZaDUNTbLt2LrEYdfm2rkhNPEMiU0tHXqqODqp+rURjey3eefToI7cYSkGxeZnHYLKfM8nqKv1EC31hKW3L7WDM/ae6V4SPXizoh5Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208838; c=relaxed/simple;
	bh=gGyE7gjJzCKcroMXJx+heZEhZ4Sjma37MEQ3+yuBiZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3xLIl31EmvlGY2W0hspK488Sth9O7qyRqQopGICNBmn99t3STWruRd7KXGKxmKBln6GlwgnyYXjmJoV6H/OoT0v+x+oecKWdTY1liFMQE6+5BGoGAVaL/uRP7Bi26iJeguFSYGgEskXR4dIN7DFianqq4ViA1CDN/7GpcwiChU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DhIh+OQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DhIh+OQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8979DC4CEC3;
	Sun,  1 Sep 2024 16:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208837;
	bh=gGyE7gjJzCKcroMXJx+heZEhZ4Sjma37MEQ3+yuBiZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhIh+OQZz9uxIIyCR+Aoj2CqTd40pdyOpXzwWfVgGvLy9yW4Z6iGVu8LUP4CwbASJ
	 Cbtg97Y33OcRq60IJhapuW9RvzHG/O95HH4IRZcoCWLNpligvxeSnMAD2cYgyezdWC
	 MYjLtKEdes/nMsxCgGp5ypuksZVf2nq+9uFeCFrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/134] net: axienet: Check for DMA mapping errors
Date: Sun,  1 Sep 2024 18:16:08 +0200
Message-ID: <20240901160810.944574724@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 71791dc8bdea55eeb2a0caefe98a0b7450c6e0af ]

Especially with the default 32-bit DMA mask, DMA buffers are a limited
resource, so their allocation can fail.
So as the DMA API documentation requires, add error checking code after
dma_map_single() calls to catch the case where we run out of "low" memory.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9ff2f816e2aa ("net: axienet: Fix register defines comment description")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 31 ++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 4467719095432..88bb3b0663ae4 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -249,6 +249,11 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 						     skb->data,
 						     lp->max_frm_size,
 						     DMA_FROM_DEVICE);
+		if (dma_mapping_error(ndev->dev.parent, lp->rx_bd_v[i].phys)) {
+			netdev_err(ndev, "DMA mapping error\n");
+			goto out;
+		}
+
 		lp->rx_bd_v[i].cntrl = lp->max_frm_size;
 	}
 
@@ -680,6 +685,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	dma_addr_t tail_p;
 	struct axienet_local *lp = netdev_priv(ndev);
 	struct axidma_bd *cur_p;
+	u32 orig_tail_ptr = lp->tx_bd_tail;
 
 	num_frag = skb_shinfo(skb)->nr_frags;
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
@@ -715,9 +721,15 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		cur_p->app0 |= 2; /* Tx Full Checksum Offload Enabled */
 	}
 
-	cur_p->cntrl = skb_headlen(skb) | XAXIDMA_BD_CTRL_TXSOF_MASK;
 	cur_p->phys = dma_map_single(ndev->dev.parent, skb->data,
 				     skb_headlen(skb), DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(ndev->dev.parent, cur_p->phys))) {
+		if (net_ratelimit())
+			netdev_err(ndev, "TX DMA mapping error\n");
+		ndev->stats.tx_dropped++;
+		return NETDEV_TX_OK;
+	}
+	cur_p->cntrl = skb_headlen(skb) | XAXIDMA_BD_CTRL_TXSOF_MASK;
 
 	for (ii = 0; ii < num_frag; ii++) {
 		if (++lp->tx_bd_tail >= lp->tx_bd_num)
@@ -728,6 +740,16 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 					     skb_frag_address(frag),
 					     skb_frag_size(frag),
 					     DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(ndev->dev.parent, cur_p->phys))) {
+			if (net_ratelimit())
+				netdev_err(ndev, "TX DMA mapping error\n");
+			ndev->stats.tx_dropped++;
+			axienet_free_tx_chain(ndev, orig_tail_ptr, ii + 1,
+					      NULL);
+			lp->tx_bd_tail = orig_tail_ptr;
+
+			return NETDEV_TX_OK;
+		}
 		cur_p->cntrl = skb_frag_size(frag);
 	}
 
@@ -808,6 +830,13 @@ static void axienet_recv(struct net_device *ndev)
 		cur_p->phys = dma_map_single(ndev->dev.parent, new_skb->data,
 					     lp->max_frm_size,
 					     DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(ndev->dev.parent, cur_p->phys))) {
+			if (net_ratelimit())
+				netdev_err(ndev, "RX DMA mapping error\n");
+			dev_kfree_skb(new_skb);
+			return;
+		}
+
 		cur_p->cntrl = lp->max_frm_size;
 		cur_p->status = 0;
 		cur_p->skb = new_skb;
-- 
2.43.0



