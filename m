Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A428820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D71C4339B;
	Fri, 10 Mar 2023 14:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459601;
	bh=gMPbaTDfJ1dvSoVqfAG5jDul9zjlycyet/arz3jMpKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0njazf1m1dXucGsLHjkrF7tY++J3AdGPOWQ0SyNxdX7XnOaJKRBfplu1UkR01yofq
	 8rbi63BktWq5jfAOv9lWJDXoRluDY4GSJ4dP78NF1rdz0DSXB6cveEFwpSrQcORUwV
	 QMoW6rEMbLnIMjdBACcqJKDZWFjFV9JJ9J5nl6DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/529] wifi: ipw2x00: dont call dev_kfree_skb() under spin_lock_irqsave()
Date: Fri, 10 Mar 2023 14:33:22 +0100
Message-Id: <20230310133807.728939374@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index ada6ce32c1f19..df28e4a05e140 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -3444,7 +3444,7 @@ static void ipw_rx_queue_reset(struct ipw_priv *priv,
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



