Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54F515C8A
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BD1C433D6;
	Mon,  5 Dec 2022 19:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269381;
	bh=AsbUmn0BX8KmK2l7ztyROW2witm0pS7tfbhmJNoDJ+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vglLI9KCfKXgUyVF3zL5fro9cEcls/hjLXs04ZWc1Bpc+G4wynaITUmfLrABWst9e
	 gWXjgwgAV9DAkfPbh8BT4BLSlzVVv8aGDbrxPLXebHT9RIa9CQ5M06/2YmAVP/r1+t
	 4l8SUfSh3avr9TmuI2ljCgxCpEYnOPlm7fh6Ki2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Karpov <YKarpov@ispras.ru>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 106/153] net: ethernet: nixge: fix NULL dereference
Date: Mon,  5 Dec 2022 20:10:30 +0100
Message-Id: <20221205190811.784862637@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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
index ffd44edfffbf..acb25b8c9458 100644
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



