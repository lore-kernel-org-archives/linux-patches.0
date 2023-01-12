Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C56749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82D3C433D2;
	Thu, 12 Jan 2023 14:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532745;
	bh=ivhCwP23VuCncQEjx2WXXaW4DrmPXPW9aUJ2aokptpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGpP9yYIvxmpUgm8dOn0kNQkrAK/kGc1w5m8P5DNvk10FgmYrP5AuDzBfI4g5GsLR
	 qq1eSIKTeUI2cbCZHNkMUgwxjt5vKCTh++Twkb+JzEZ7wSww9zY47EL8jFa8xhrrfI
	 rJj7TqHQy82lA77oj0cLK9j92+pEECJch+clmcmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 262/783] net: amd: lance: dont call dev_kfree_skb() under spin_lock_irqsave()
Date: Thu, 12 Jan 2023 14:49:38 +0100
Message-Id: <20230112135536.570083567@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit 6151d105dfce8c23edf30eed35e97f3d9b96a35c ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
The difference between them is free reason, dev_kfree_skb_irq() means
the SKB is dropped in error and dev_consume_skb_irq() means the SKB
is consumed in normal.

In these two cases, dev_kfree_skb() is called consume the xmited SKB,
so replace it with dev_consume_skb_irq().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/atarilance.c | 2 +-
 drivers/net/ethernet/amd/lance.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index 961796abab35..5e8b72db8873 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -825,7 +825,7 @@ lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	lp->memcpy_f( PKTBUF_ADDR(head), (void *)skb->data, skb->len );
 	head->flag = TMD1_OWN_CHIP | TMD1_ENP | TMD1_STP;
 	dev->stats.tx_bytes += skb->len;
-	dev_kfree_skb( skb );
+	dev_consume_skb_irq(skb);
 	lp->cur_tx++;
 	while( lp->cur_tx >= TX_RING_SIZE && lp->dirty_tx >= TX_RING_SIZE ) {
 		lp->cur_tx -= TX_RING_SIZE;
diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
index aff44241988c..9dae225b7fd5 100644
--- a/drivers/net/ethernet/amd/lance.c
+++ b/drivers/net/ethernet/amd/lance.c
@@ -997,7 +997,7 @@ static netdev_tx_t lance_start_xmit(struct sk_buff *skb,
 		skb_copy_from_linear_data(skb, &lp->tx_bounce_buffs[entry], skb->len);
 		lp->tx_ring[entry].base =
 			((u32)isa_virt_to_bus((lp->tx_bounce_buffs + entry)) & 0xffffff) | 0x83000000;
-		dev_kfree_skb(skb);
+		dev_consume_skb_irq(skb);
 	} else {
 		lp->tx_skbuff[entry] = skb;
 		lp->tx_ring[entry].base = ((u32)isa_virt_to_bus(skb->data) & 0xffffff) | 0x83000000;
-- 
2.35.1



