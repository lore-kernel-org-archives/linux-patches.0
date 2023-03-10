Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34BC848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E20C433D2;
	Fri, 10 Mar 2023 14:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458480;
	bh=bzbpRyIQO3KFKhVV59KlCKn7fyuNQ6N8oLBPkqV6O3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CkfQt+rO08nNk8iU4+DneQAx8HilMPTMtybesovn7sHHwlvB1rim0l00WFfMoqe4z
	 CyInHQYndaa1Cz7bkzLZckvO9FU3Nj6TzI21D1+uQZaXTPEoVNwQXqX5lfCtDhesot
	 Mz95HnuvPxQ5aqGh34mLs1zDNmKdBDDAbN0ebWiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/357] wifi: ipw2x00: dont call dev_kfree_skb() under spin_lock_irqsave()
Date: Fri, 10 Mar 2023 14:35:29 +0100
Message-Id: <20230310133735.779224196@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

[ Upstream commit 45fc6d7461f18df2f238caf0cbc5acc4163203d1 ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
The difference between them is free reason, dev_kfree_skb_irq() means
the SKB is dropped in error and dev_consume_skb_irq() means the SKB
is consumed in normal.

In this case, dev_kfree_skb() is called to free and drop the SKB when
it's reset, so replace it with dev_kfree_skb_irq(). Compile tested
only.

Fixes: 43f66a6ce8da ("Add ipw2200 wireless driver.")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221208143826.2385218-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index fc9c2930f08cf..b2f7736a79f85 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -3445,7 +3445,7 @@ static void ipw_rx_queue_reset(struct ipw_priv *priv,
 			dma_unmap_single(&priv->pci_dev->dev,
 					 rxq->pool[i].dma_addr,
 					 IPW_RX_BUF_SIZE, DMA_FROM_DEVICE);
-			dev_kfree_skb(rxq->pool[i].skb);
+			dev_kfree_skb_irq(rxq->pool[i].skb);
 			rxq->pool[i].skb = NULL;
 		}
 		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
-- 
2.39.2



