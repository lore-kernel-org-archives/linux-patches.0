Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931226FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1754CC433EF;
	Mon, 16 Jan 2023 17:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888752;
	bh=h//9EotYv3dtzkJSDz/tI+erI32wjaz/uYI5ud5aVgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJ3HJKkx3u9CsdnzJ6C4lvEweaWHlg3b34lWLyTDaQdaoeCkS/IltyUplkAS161Ym
	 FgcA+w+8bcSmsgwxQSZCL7Bfs33CBRz54yAqTJXD9zEIUM48maEwL8VZhziOQyiJ9g
	 E1/ZpAtmkbXEdsOInGVoPXt+u9zp6KLcrNZdYu+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 126/338] net: apple: bmac: dont call dev_kfree_skb() under spin_lock_irqsave()
Date: Mon, 16 Jan 2023 16:49:59 +0100
Message-Id: <20230116154826.331566022@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

[ Upstream commit 5fe02e046e6422c4adfdbc50206ec7186077da24 ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
The difference between them is free reason, dev_kfree_skb_irq() means
the SKB is dropped in error and dev_consume_skb_irq() means the SKB
is consumed in normal.

In this case, dev_kfree_skb() is called in bmac_tx_timeout() to drop
the SKB, when tx timeout, so replace it with dev_kfree_skb_irq().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/apple/bmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index a8b462e1beba..7e4567c7bcae 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -1516,7 +1516,7 @@ static void bmac_tx_timeout(unsigned long data)
 	i = bp->tx_empty;
 	++dev->stats.tx_errors;
 	if (i != bp->tx_fill) {
-		dev_kfree_skb(bp->tx_bufs[i]);
+		dev_kfree_skb_irq(bp->tx_bufs[i]);
 		bp->tx_bufs[i] = NULL;
 		if (++i >= N_TX_RING) i = 0;
 		bp->tx_empty = i;
-- 
2.35.1



