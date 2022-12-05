Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A7B15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97163C433D6;
	Mon,  5 Dec 2022 19:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268691;
	bh=w0bVtD2QRxMXHLg0CoVMqh5QJ13U365e76EPDfxJB2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbql7uZK2SeH/aMi8P6t7BS5ZDDYf6Du+AJc8nwuBDICpGddIkh7he3KW1Rhdze7Z
	 KRrfgOfT01zNgpYXpqzCOT7xbnSuuqlzZKgN2EF9KQ9smIcheOkeXUDJ8zoIxi4sGD
	 MxVigt8PVh59wdvx22O2xp9pc4yT/frtf6elB0yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Karpov <YKarpov@ispras.ru>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 42/92] net: ethernet: nixge: fix NULL dereference
Date: Mon,  5 Dec 2022 20:09:55 +0100
Message-Id: <20221205190804.871080528@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuri Karpov <YKarpov@ispras.ru>

[ Upstream commit 9256db4e45e8b497b0e993cc3ed4ad08eb2389b6 ]

In function nixge_hw_dma_bd_release() dereference of NULL pointer
priv->rx_bd_v is possible for the case of its allocation failure in
nixge_hw_dma_bd_init().

Move for() loop with priv->rx_bd_v dereference under the check for
its validity.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
Signed-off-by: Yuri Karpov <YKarpov@ispras.ru>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ni/nixge.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 9c48fd85c418..07fbd329fe93 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -249,25 +249,26 @@ static void nixge_hw_dma_bd_release(struct net_device *ndev)
 	struct sk_buff *skb;
 	int i;
 
-	for (i = 0; i < RX_BD_NUM; i++) {
-		phys_addr = nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
-						     phys);
-
-		dma_unmap_single(ndev->dev.parent, phys_addr,
-				 NIXGE_MAX_JUMBO_FRAME_SIZE,
-				 DMA_FROM_DEVICE);
-
-		skb = (struct sk_buff *)(uintptr_t)
-			nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
-						 sw_id_offset);
-		dev_kfree_skb(skb);
-	}
+	if (priv->rx_bd_v) {
+		for (i = 0; i < RX_BD_NUM; i++) {
+			phys_addr = nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
+							     phys);
+
+			dma_unmap_single(ndev->dev.parent, phys_addr,
+					 NIXGE_MAX_JUMBO_FRAME_SIZE,
+					 DMA_FROM_DEVICE);
+
+			skb = (struct sk_buff *)(uintptr_t)
+				nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
+							 sw_id_offset);
+			dev_kfree_skb(skb);
+		}
 
-	if (priv->rx_bd_v)
 		dma_free_coherent(ndev->dev.parent,
 				  sizeof(*priv->rx_bd_v) * RX_BD_NUM,
 				  priv->rx_bd_v,
 				  priv->rx_bd_p);
+	}
 
 	if (priv->tx_skb)
 		devm_kfree(ndev->dev.parent, priv->tx_skb);
-- 
2.35.1



