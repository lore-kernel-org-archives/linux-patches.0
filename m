Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353D1326D76;
	Mon, 27 Oct 2025 18:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590748; cv=none; b=jH9g8Anpt9XHuGYTFOspUJ+vXSwZjWf3QOcCHTsMlWBZgNs+YgPbbFnqVFl8iZQu1Gaf+qhghgNjE1s9LP5PYlTf7qOflzjbCljKPdglWxvd/Z/Jsu71AHfP84O9jnC4idUByrubJH9tYQTW2WmvlYipjg/6EJltjmNINno2Sb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590748; c=relaxed/simple;
	bh=TrvHRGhn97bKPk6furPIR+1tj/obIuJBqY7rGcfu46c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEs4A/Of8JTrBVcqegi0dna4TMHu6yrlflu+mo7qVw3TtHe26rD+LfBwM8KdjmEh+Kw+gppBuQO2w2O8TxPi+aAPWaEkCpIAlwg1+anYNX7v3FxDYHj0sRIjmhdHYLKrT5iYF796h4myYJrFfrp9ZVYUrYOcW+/mCzJm+8ddMHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mfycu4PL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mfycu4PL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B799C113D0;
	Mon, 27 Oct 2025 18:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590745;
	bh=TrvHRGhn97bKPk6furPIR+1tj/obIuJBqY7rGcfu46c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mfycu4PLqfDc0jTlcQHaI62MIjzIb/si9I7/IBaj7tb0DJGnhfS8HM5KSNwe+TsrI
	 yQ7HG1wv1CeEdufQmrX4Yen3nhPOJPASLfAaDaFyB9omEWX6oZiCnBrj1XUEwojldQ
	 h4l6r3THYZU2eZlOxoBYRMRPHEt/lfwR7E1mLTUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeounsu Moon <yyyynoom@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 159/224] net: dlink: handle dma_map_single() failure properly
Date: Mon, 27 Oct 2025 19:35:05 +0100
Message-ID: <20251027183513.193340318@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yeounsu Moon <yyyynoom@gmail.com>

[ Upstream commit 65946eac6d888d50ae527c4e5c237dbe5cc3a2f2 ]

There is no error handling for `dma_map_single()` failures.

Add error handling by checking `dma_mapping_error()` and freeing
the `skb` using `dev_kfree_skb()` (process context) when it fails.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yeounsu Moon <yyyynoom@gmail.com>
Tested-on: D-Link DGE-550T Rev-A3
Suggested-by: Simon Horman <horms@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dlink/dl2k.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index 8597648156635..855328ae6ea57 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -508,25 +508,34 @@ static int alloc_list(struct net_device *dev)
 	for (i = 0; i < RX_RING_SIZE; i++) {
 		/* Allocated fixed size of skbuff */
 		struct sk_buff *skb;
+		dma_addr_t addr;
 
 		skb = netdev_alloc_skb_ip_align(dev, np->rx_buf_sz);
 		np->rx_skbuff[i] = skb;
-		if (!skb) {
-			free_list(dev);
-			return -ENOMEM;
-		}
+		if (!skb)
+			goto err_free_list;
+
+		addr = dma_map_single(&np->pdev->dev, skb->data,
+				      np->rx_buf_sz, DMA_FROM_DEVICE);
+		if (dma_mapping_error(&np->pdev->dev, addr))
+			goto err_kfree_skb;
 
 		np->rx_ring[i].next_desc = cpu_to_le64(np->rx_ring_dma +
 						((i + 1) % RX_RING_SIZE) *
 						sizeof(struct netdev_desc));
 		/* Rubicon now supports 40 bits of addressing space. */
-		np->rx_ring[i].fraginfo =
-		    cpu_to_le64(dma_map_single(&np->pdev->dev, skb->data,
-					       np->rx_buf_sz, DMA_FROM_DEVICE));
+		np->rx_ring[i].fraginfo = cpu_to_le64(addr);
 		np->rx_ring[i].fraginfo |= cpu_to_le64((u64)np->rx_buf_sz << 48);
 	}
 
 	return 0;
+
+err_kfree_skb:
+	dev_kfree_skb(np->rx_skbuff[i]);
+	np->rx_skbuff[i] = NULL;
+err_free_list:
+	free_list(dev);
+	return -ENOMEM;
 }
 
 static void rio_hw_init(struct net_device *dev)
-- 
2.51.0



