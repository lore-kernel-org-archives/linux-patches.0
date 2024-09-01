Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D32E183CAA;
	Sun,  1 Sep 2024 16:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208745; cv=none; b=JX8S0REpaKCvLzeO6KgMaJ0i+neS01fewORVdDgLCHeY5b3MbsSfpVNrbAN3W/7MENStqhENWsRyBvF3VYMeSMHGnz0n1fS0EMTq46C3OH8tdCxY+fORyLW2CUEXLfQ7hdMPk3CY6YpXpkC/VdVnxJMxqlsSQiws2svNOxnv+74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208745; c=relaxed/simple;
	bh=OhSHsgbXLSMZg2qIl3ylAgQ7vSJzZzp+MaYrd+AqL2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MarIf0p1tctrni8gUfbcsKuo69bLypICOQwTQm2h85rP7xsl+0DNMd8aQN3qxYgFu5fWmrUxf+ytW59FOPjQVuQq3Vp2uxLPrFJLIQq60tBXCtft5vy09ZkbTbG26aXSORrqV2Ppy6rwhHrOZ2lj8w5a9Y4rs/JMMvRFqTcLxCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Ap/EG6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Ap/EG6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54B0C4CEC3;
	Sun,  1 Sep 2024 16:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208745;
	bh=OhSHsgbXLSMZg2qIl3ylAgQ7vSJzZzp+MaYrd+AqL2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Ap/EG6EvNQvYxCg3orOjFOCue8Bs+Tp/c1toUPIeuiIndiL0sXCWxblv55bADEnK
	 XYa7OSBkyBxJZed6fpE6028W4CA54yHZ+HXAPhz61LNFQOB17qeweSh6cUzoeW4EGh
	 dEG972fXxmX75Qo0G7gQHXdRlsTEKJ2dnYn+92ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/134] net: axienet: Fix DMA descriptor cleanup path
Date: Sun,  1 Sep 2024 18:16:05 +0200
Message-ID: <20240901160810.833929451@linuxfoundation.org>
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

[ Upstream commit f26667a373f34ace925c90a1e881b1774d640dc8 ]

When axienet_dma_bd_init() bails out during the initialisation process,
it might do so with parts of the structure already allocated and
initialised, while other parts have not been touched yet. Before
returning in this case, we call axienet_dma_bd_release(), which does not
take care of this corner case.
This is most obvious by the first loop happily dereferencing
lp->rx_bd_v, which we actually check to be non NULL *afterwards*.

Make sure we only unmap or free already allocated structures, by:
- directly returning with -ENOMEM if nothing has been allocated at all
- checking for lp->rx_bd_v to be non-NULL *before* using it
- only unmapping allocated DMA RX regions

This avoids NULL pointer dereferences when initialisation fails.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9ff2f816e2aa ("net: axienet: Fix register defines comment description")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 43 ++++++++++++-------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index bbc1cf288d25f..27901bb7cd5b5 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -161,24 +161,37 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 	int i;
 	struct axienet_local *lp = netdev_priv(ndev);
 
+	/* If we end up here, tx_bd_v must have been DMA allocated. */
+	dma_free_coherent(ndev->dev.parent,
+			  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
+			  lp->tx_bd_v,
+			  lp->tx_bd_p);
+
+	if (!lp->rx_bd_v)
+		return;
+
 	for (i = 0; i < lp->rx_bd_num; i++) {
-		dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
-				 lp->max_frm_size, DMA_FROM_DEVICE);
+		/* A NULL skb means this descriptor has not been initialised
+		 * at all.
+		 */
+		if (!lp->rx_bd_v[i].skb)
+			break;
+
 		dev_kfree_skb(lp->rx_bd_v[i].skb);
-	}
 
-	if (lp->rx_bd_v) {
-		dma_free_coherent(ndev->dev.parent,
-				  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
-				  lp->rx_bd_v,
-				  lp->rx_bd_p);
-	}
-	if (lp->tx_bd_v) {
-		dma_free_coherent(ndev->dev.parent,
-				  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
-				  lp->tx_bd_v,
-				  lp->tx_bd_p);
+		/* For each descriptor, we programmed cntrl with the (non-zero)
+		 * descriptor size, after it had been successfully allocated.
+		 * So a non-zero value in there means we need to unmap it.
+		 */
+		if (lp->rx_bd_v[i].cntrl)
+			dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
+					 lp->max_frm_size, DMA_FROM_DEVICE);
 	}
+
+	dma_free_coherent(ndev->dev.parent,
+			  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
+			  lp->rx_bd_v,
+			  lp->rx_bd_p);
 }
 
 /**
@@ -208,7 +221,7 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 					 sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
 					 &lp->tx_bd_p, GFP_KERNEL);
 	if (!lp->tx_bd_v)
-		goto out;
+		return -ENOMEM;
 
 	lp->rx_bd_v = dma_alloc_coherent(ndev->dev.parent,
 					 sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
-- 
2.43.0



