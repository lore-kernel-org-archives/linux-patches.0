Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741A328ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505C6C433EF;
	Mon, 12 Dec 2022 13:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853112;
	bh=WJYqIz9zOhTIglzQzmd6mrRv4JGk3iOnZIc2NxQ3yPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXHXPfA4wdsCycor1De478gpMM4EzEo2J72rGUXwVtI8qLBQ/a4qJxYS8gYbkdpo8
	 R1p2X2a6pp2/lMHtRgphOjhDT8vF29H6d29opbljgVQyxcZPzS86f6e35THthtoA/n
	 TSt6W9wjGT3j796coTnrjUQteV/x7AUcoAzUhZ+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/38] xen/netback: dont call kfree_skb() with interrupts disabled
Date: Mon, 12 Dec 2022 14:19:13 +0100
Message-Id: <20221212130912.732254174@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130912.069170932@linuxfoundation.org>
References: <20221212130912.069170932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 74e7e1efdad45580cc3839f2a155174cf158f9b5 ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So remove kfree_skb()
from the spin_lock_irqsave() section and use the already existing
"drop" label in xenvif_start_xmit() for dropping the SKB. At the
same time replace the dev_kfree_skb() call there with a call of
dev_kfree_skb_any(), as xenvif_start_xmit() can be called with
disabled interrupts.

This is XSA-424 / CVE-2022-42328 / CVE-2022-42329.

Fixes: be81992f9086 ("xen/netback: don't queue unlimited number of packages")
Reported-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/common.h    | 2 +-
 drivers/net/xen-netback/interface.c | 6 ++++--
 drivers/net/xen-netback/rx.c        | 8 +++++---
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 4ef648f79993..e5f254500c1c 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -364,7 +364,7 @@ int xenvif_dealloc_kthread(void *data);
 irqreturn_t xenvif_ctrl_irq_fn(int irq, void *data);
 
 bool xenvif_have_rx_work(struct xenvif_queue *queue, bool test_kthread);
-void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
+bool xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb);
 
 void xenvif_carrier_on(struct xenvif *vif);
 
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index c3f64ca0bb63..c8e551932666 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -254,14 +254,16 @@ xenvif_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (vif->hash.alg == XEN_NETIF_CTRL_HASH_ALGORITHM_NONE)
 		skb_clear_hash(skb);
 
-	xenvif_rx_queue_tail(queue, skb);
+	if (!xenvif_rx_queue_tail(queue, skb))
+		goto drop;
+
 	xenvif_kick_thread(queue);
 
 	return NETDEV_TX_OK;
 
  drop:
 	vif->dev->stats.tx_dropped++;
-	dev_kfree_skb(skb);
+	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
 
diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
index 6964f8b1a36b..5067fa0c751f 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -82,9 +82,10 @@ static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
 	return false;
 }
 
-void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
+bool xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 {
 	unsigned long flags;
+	bool ret = true;
 
 	spin_lock_irqsave(&queue->rx_queue.lock, flags);
 
@@ -92,8 +93,7 @@ void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 		struct net_device *dev = queue->vif->dev;
 
 		netif_tx_stop_queue(netdev_get_tx_queue(dev, queue->id));
-		kfree_skb(skb);
-		queue->vif->dev->stats.rx_dropped++;
+		ret = false;
 	} else {
 		if (skb_queue_empty(&queue->rx_queue))
 			xenvif_update_needed_slots(queue, skb);
@@ -104,6 +104,8 @@ void xenvif_rx_queue_tail(struct xenvif_queue *queue, struct sk_buff *skb)
 	}
 
 	spin_unlock_irqrestore(&queue->rx_queue.lock, flags);
+
+	return ret;
 }
 
 static struct sk_buff *xenvif_rx_dequeue(struct xenvif_queue *queue)
-- 
2.35.1



