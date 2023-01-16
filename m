Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6514A46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD5EC433D2;
	Mon, 16 Jan 2023 16:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885977;
	bh=FJNqcM+wi76TPP97htFcSlzVykQK+sTACSdOP6qbBxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7boPGMToR6zyeKmQy97q4+09LmcYxno+dzY0/Wkb9dL2Iko6d11Idyx17uuXKHvo
	 51837Q4s9TkTSc0FTrv2e6PU4DUNuApU4lO4E5r7y0vWyZGSs1Mq9F03iiQUWHwPbi
	 kH/wWm6wFrxVOmilGHkLomDvsclpyIrTGZaLyjQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 225/658] hamradio: dont call dev_kfree_skb() under spin_lock_irqsave()
Date: Mon, 16 Jan 2023 16:45:13 +0100
Message-Id: <20230116154919.800675098@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 3727f742915f04f6fc550b80cf406999bd4e90d0 ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
The difference between them is free reason, dev_kfree_skb_irq() means
the SKB is dropped in error and dev_consume_skb_irq() means the SKB
is consumed in normal.

In scc_discard_buffers(), dev_kfree_skb() is called to discard the SKBs,
so replace it with dev_kfree_skb_irq().

In scc_net_tx(), dev_kfree_skb() is called to drop the SKB that exceed
queue length, so replace it with dev_kfree_skb_irq().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/scc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index 6c03932d8a6b..3dc4eb841aa1 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -300,12 +300,12 @@ static inline void scc_discard_buffers(struct scc_channel *scc)
 	spin_lock_irqsave(&scc->lock, flags);	
 	if (scc->tx_buff != NULL)
 	{
-		dev_kfree_skb(scc->tx_buff);
+		dev_kfree_skb_irq(scc->tx_buff);
 		scc->tx_buff = NULL;
 	}
 	
 	while (!skb_queue_empty(&scc->tx_queue))
-		dev_kfree_skb(skb_dequeue(&scc->tx_queue));
+		dev_kfree_skb_irq(skb_dequeue(&scc->tx_queue));
 
 	spin_unlock_irqrestore(&scc->lock, flags);
 }
@@ -1667,7 +1667,7 @@ static netdev_tx_t scc_net_tx(struct sk_buff *skb, struct net_device *dev)
 	if (skb_queue_len(&scc->tx_queue) > scc->dev->tx_queue_len) {
 		struct sk_buff *skb_del;
 		skb_del = skb_dequeue(&scc->tx_queue);
-		dev_kfree_skb(skb_del);
+		dev_kfree_skb_irq(skb_del);
 	}
 	skb_queue_tail(&scc->tx_queue, skb);
 	netif_trans_update(dev);
-- 
2.35.1



