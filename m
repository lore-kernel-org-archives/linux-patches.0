Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C52A2B9C7;
	Sun,  1 Sep 2024 16:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208819; cv=none; b=b08S+dyACAlFaQcEApeISH3yb8RKGZpaAaP5q1mdl2ig48Mfr+HlXZ/wbjTbqPLuldQ4+wh9GPbrAFPiNAFY7FVDHSeZNLV30yN8cUrEZOwsdqxrJjOXiZHNXvc5vpyieOxd/Zmw3V+ynQc/+tKQp7nv7gR6msZFiwpnFoFlx48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208819; c=relaxed/simple;
	bh=8fRsJU6BszFBYCEgvLwdJDU3M+0nJhWEBPhsnEYkfc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNn339Nemy8Cza+SeC5dsIGZMRy3q2/JKoV35AlSiy0gL7ehLYyGdsuhr8ZllQgWnRDG3Cwig4mZMmXNKY8RdwhwNzTpINEr30/YjL59lGCm8V/kVvcgOOlQ0oSTbh4DebkFNlE+BYB8Wwc9GxGDC1+4mCW6CLXvq/SorFt83w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LceOHQWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LceOHQWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51519C4CEC3;
	Sun,  1 Sep 2024 16:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208818;
	bh=8fRsJU6BszFBYCEgvLwdJDU3M+0nJhWEBPhsnEYkfc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LceOHQWYxcLLvQX5+ePeRQw0ZNqkd14mVQQdkebEBYUWTeU/7sC6tHjCxVU/I8RbM
	 yRO745+4adTzbTF6eWHtV2mwSzCEbs9W0cp5K39ASGc55bHhQasD0AM1nigGToahEx
	 gTeBU8tL/PL8MSmCbmd8D6amSj5cwIiu8xJ0LdYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/134] net: axienet: Factor out TX descriptor chain cleanup
Date: Sun,  1 Sep 2024 18:16:07 +0200
Message-ID: <20240901160810.907153559@linuxfoundation.org>
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

[ Upstream commit ab365c3393664f32116aa22fe322cb04a93fab31 ]

Factor out the code that cleans up a number of connected TX descriptors,
as we will need it to properly roll back a failed _xmit() call.
There are subtle differences between cleaning up a successfully sent
chain (unknown number of involved descriptors, total data size needed)
and a chain that was about to set up (number of descriptors known), so
cater for those variations with some extra parameters.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9ff2f816e2aa ("net: axienet: Fix register defines comment description")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 79 +++++++++++++------
 1 file changed, 57 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 22222d79e4902..4467719095432 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -546,32 +546,46 @@ static int axienet_device_reset(struct net_device *ndev)
 }
 
 /**
- * axienet_start_xmit_done - Invoked once a transmit is completed by the
- * Axi DMA Tx channel.
+ * axienet_free_tx_chain - Clean up a series of linked TX descriptors.
  * @ndev:	Pointer to the net_device structure
+ * @first_bd:	Index of first descriptor to clean up
+ * @nr_bds:	Number of descriptors to clean up, can be -1 if unknown.
+ * @sizep:	Pointer to a u32 filled with the total sum of all bytes
+ * 		in all cleaned-up descriptors. Ignored if NULL.
  *
- * This function is invoked from the Axi DMA Tx isr to notify the completion
- * of transmit operation. It clears fields in the corresponding Tx BDs and
- * unmaps the corresponding buffer so that CPU can regain ownership of the
- * buffer. It finally invokes "netif_wake_queue" to restart transmission if
- * required.
+ * Would either be called after a successful transmit operation, or after
+ * there was an error when setting up the chain.
+ * Returns the number of descriptors handled.
  */
-static void axienet_start_xmit_done(struct net_device *ndev)
+static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
+				 int nr_bds, u32 *sizep)
 {
-	u32 size = 0;
-	u32 packets = 0;
 	struct axienet_local *lp = netdev_priv(ndev);
 	struct axidma_bd *cur_p;
-	unsigned int status = 0;
+	int max_bds = nr_bds;
+	unsigned int status;
+	int i;
+
+	if (max_bds == -1)
+		max_bds = lp->tx_bd_num;
+
+	for (i = 0; i < max_bds; i++) {
+		cur_p = &lp->tx_bd_v[(first_bd + i) % lp->tx_bd_num];
+		status = cur_p->status;
+
+		/* If no number is given, clean up *all* descriptors that have
+		 * been completed by the MAC.
+		 */
+		if (nr_bds == -1 && !(status & XAXIDMA_BD_STS_COMPLETE_MASK))
+			break;
 
-	cur_p = &lp->tx_bd_v[lp->tx_bd_ci];
-	status = cur_p->status;
-	while (status & XAXIDMA_BD_STS_COMPLETE_MASK) {
 		dma_unmap_single(ndev->dev.parent, cur_p->phys,
 				(cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
 				DMA_TO_DEVICE);
-		if (cur_p->skb)
+
+		if (cur_p->skb && (status & XAXIDMA_BD_STS_COMPLETE_MASK))
 			dev_consume_skb_irq(cur_p->skb);
+
 		cur_p->cntrl = 0;
 		cur_p->app0 = 0;
 		cur_p->app1 = 0;
@@ -580,15 +594,36 @@ static void axienet_start_xmit_done(struct net_device *ndev)
 		cur_p->status = 0;
 		cur_p->skb = NULL;
 
-		size += status & XAXIDMA_BD_STS_ACTUAL_LEN_MASK;
-		packets++;
-
-		if (++lp->tx_bd_ci >= lp->tx_bd_num)
-			lp->tx_bd_ci = 0;
-		cur_p = &lp->tx_bd_v[lp->tx_bd_ci];
-		status = cur_p->status;
+		if (sizep)
+			*sizep += status & XAXIDMA_BD_STS_ACTUAL_LEN_MASK;
 	}
 
+	return i;
+}
+
+/**
+ * axienet_start_xmit_done - Invoked once a transmit is completed by the
+ * Axi DMA Tx channel.
+ * @ndev:	Pointer to the net_device structure
+ *
+ * This function is invoked from the Axi DMA Tx isr to notify the completion
+ * of transmit operation. It clears fields in the corresponding Tx BDs and
+ * unmaps the corresponding buffer so that CPU can regain ownership of the
+ * buffer. It finally invokes "netif_wake_queue" to restart transmission if
+ * required.
+ */
+static void axienet_start_xmit_done(struct net_device *ndev)
+{
+	struct axienet_local *lp = netdev_priv(ndev);
+	u32 packets = 0;
+	u32 size = 0;
+
+	packets = axienet_free_tx_chain(ndev, lp->tx_bd_ci, -1, &size);
+
+	lp->tx_bd_ci += packets;
+	if (lp->tx_bd_ci >= lp->tx_bd_num)
+		lp->tx_bd_ci -= lp->tx_bd_num;
+
 	ndev->stats.tx_packets += packets;
 	ndev->stats.tx_bytes += size;
 
-- 
2.43.0



