Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E38189BB0;
	Sun,  7 Sep 2025 20:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276528; cv=none; b=CjLI+aLvTaEJPJziUCyZXT71h9rL2aEtGdgSqN37RpiJSiuIMi0ziPhdtqxBCgsqeGDvltyeuxhS1oMFIPhbp4TGg+2z+hR+Selt1HbXHRY9MfH8fZLRjrZvpRUOlcS0T3Fj6zkH+qyDisnmAsj1+VPOy2H97L5SIYbygkpEYJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276528; c=relaxed/simple;
	bh=OCm5px5OwBL0GI8P46ctVhf7XDwfG4IQ9Orbgq19Bn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7DMRrjkKoDI78ApmfsQ/ONRkYuak0iAnabkgxXc1cHO4+qdBPToy/5PvuCL11KROLmP1EFMAsSM5CiQOztwMn85P0aDVt3xkIAnDkrwA8dJx78ZJUG1Df5VsJ9h4ofQ8ufMZ+wDVyncF2OOisNfHD5CLboqK45DGYny2vm6Dqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LjD62dpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LjD62dpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1525BC4CEF0;
	Sun,  7 Sep 2025 20:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276528;
	bh=OCm5px5OwBL0GI8P46ctVhf7XDwfG4IQ9Orbgq19Bn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjD62dpH1Lqq2hr42PTXny9d5BsBAh966AKO/+9XY5CmJM4Yp1c1yMOFkl0xNNYTY
	 vCyxIf5S2P027BqT/7qteEn+7WX5wA28bJPK1J42y+1Xt6bxsPUW14Vq2KjULu4X8x
	 hHVgKRnf4csA/TGWJEB3dUoxMPVJFFnrheIoSOg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Galbraith <efault@gmx.de>,
	Sean Anderson <sean.anderson@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/121] net: macb: Fix tx_ptr_lock locking
Date: Sun,  7 Sep 2025 21:57:44 +0200
Message-ID: <20250907195610.548209582@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 6bc8a5098bf4a365c4086a4a4130bfab10a58260 ]

macb_start_xmit and macb_tx_poll can be called with bottom-halves
disabled (e.g. from softirq) as well as with interrupts disabled (with
netpoll). Because of this, all other functions taking tx_ptr_lock must
use spin_lock_irqsave.

Fixes: 138badbc21a0 ("net: macb: use NAPI for TX completion path")
Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Link: https://patch.msgid.link/20250829143521.1686062-1-sean.anderson@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 28 ++++++++++++++----------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 534e7f7bca4c2..b836ab2a649a2 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1234,11 +1234,12 @@ static int macb_tx_complete(struct macb_queue *queue, int budget)
 {
 	struct macb *bp = queue->bp;
 	u16 queue_index = queue - bp->queues;
+	unsigned long flags;
 	unsigned int tail;
 	unsigned int head;
 	int packets = 0;
 
-	spin_lock(&queue->tx_ptr_lock);
+	spin_lock_irqsave(&queue->tx_ptr_lock, flags);
 	head = queue->tx_head;
 	for (tail = queue->tx_tail; tail != head && packets < budget; tail++) {
 		struct macb_tx_skb	*tx_skb;
@@ -1297,7 +1298,7 @@ static int macb_tx_complete(struct macb_queue *queue, int budget)
 	    CIRC_CNT(queue->tx_head, queue->tx_tail,
 		     bp->tx_ring_size) <= MACB_TX_WAKEUP_THRESH(bp))
 		netif_wake_subqueue(bp->dev, queue_index);
-	spin_unlock(&queue->tx_ptr_lock);
+	spin_unlock_irqrestore(&queue->tx_ptr_lock, flags);
 
 	return packets;
 }
@@ -1713,8 +1714,9 @@ static void macb_tx_restart(struct macb_queue *queue)
 {
 	struct macb *bp = queue->bp;
 	unsigned int head_idx, tbqp;
+	unsigned long flags;
 
-	spin_lock(&queue->tx_ptr_lock);
+	spin_lock_irqsave(&queue->tx_ptr_lock, flags);
 
 	if (queue->tx_head == queue->tx_tail)
 		goto out_tx_ptr_unlock;
@@ -1726,19 +1728,20 @@ static void macb_tx_restart(struct macb_queue *queue)
 	if (tbqp == head_idx)
 		goto out_tx_ptr_unlock;
 
-	spin_lock_irq(&bp->lock);
+	spin_lock(&bp->lock);
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
-	spin_unlock_irq(&bp->lock);
+	spin_unlock(&bp->lock);
 
 out_tx_ptr_unlock:
-	spin_unlock(&queue->tx_ptr_lock);
+	spin_unlock_irqrestore(&queue->tx_ptr_lock, flags);
 }
 
 static bool macb_tx_complete_pending(struct macb_queue *queue)
 {
 	bool retval = false;
+	unsigned long flags;
 
-	spin_lock(&queue->tx_ptr_lock);
+	spin_lock_irqsave(&queue->tx_ptr_lock, flags);
 	if (queue->tx_head != queue->tx_tail) {
 		/* Make hw descriptor updates visible to CPU */
 		rmb();
@@ -1746,7 +1749,7 @@ static bool macb_tx_complete_pending(struct macb_queue *queue)
 		if (macb_tx_desc(queue, queue->tx_tail)->ctrl & MACB_BIT(TX_USED))
 			retval = true;
 	}
-	spin_unlock(&queue->tx_ptr_lock);
+	spin_unlock_irqrestore(&queue->tx_ptr_lock, flags);
 	return retval;
 }
 
@@ -2314,6 +2317,7 @@ static netdev_tx_t macb_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct macb_queue *queue = &bp->queues[queue_index];
 	unsigned int desc_cnt, nr_frags, frag_size, f;
 	unsigned int hdrlen;
+	unsigned long flags;
 	bool is_lso;
 	netdev_tx_t ret = NETDEV_TX_OK;
 
@@ -2374,7 +2378,7 @@ static netdev_tx_t macb_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		desc_cnt += DIV_ROUND_UP(frag_size, bp->max_tx_length);
 	}
 
-	spin_lock_bh(&queue->tx_ptr_lock);
+	spin_lock_irqsave(&queue->tx_ptr_lock, flags);
 
 	/* This is a hard error, log it. */
 	if (CIRC_SPACE(queue->tx_head, queue->tx_tail,
@@ -2396,15 +2400,15 @@ static netdev_tx_t macb_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	wmb();
 	skb_tx_timestamp(skb);
 
-	spin_lock_irq(&bp->lock);
+	spin_lock(&bp->lock);
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
-	spin_unlock_irq(&bp->lock);
+	spin_unlock(&bp->lock);
 
 	if (CIRC_SPACE(queue->tx_head, queue->tx_tail, bp->tx_ring_size) < 1)
 		netif_stop_subqueue(dev, queue_index);
 
 unlock:
-	spin_unlock_bh(&queue->tx_ptr_lock);
+	spin_unlock_irqrestore(&queue->tx_ptr_lock, flags);
 
 	return ret;
 }
-- 
2.50.1



