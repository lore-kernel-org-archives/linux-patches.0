Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C531026738B;
	Tue, 21 Oct 2025 19:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076449; cv=none; b=iHLNf8nIffPZcQJ0GOnOuaJ2D41Qs9uEy49rrlH3zob5U91ry3ZL5K8ZfRoPJR3kReTwpsHpx0N8FlgHqRTWHMxQ5s7O0j5WAJok/h7RCF2kzeF7c9ESCVvdWK2KjY6gbhwFrl6eVwPRQRC8eOKtTdeyjw9wGdnp2JFt1wAYQBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076449; c=relaxed/simple;
	bh=LZHrH7/XCBsbrCStNMghNcar9g4/QoflSmOWUnFmFTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnDA1150o5ql47mA7lsO0i4qsrpgG6EkEbiLIidmVhp2bRdWXBKwNuDNGNyg1rnE78G9AffIM3oJ3VZb502NvZRe5cnAL36N1XTxDkIVcu7IRTeTi1Nv51bp6xQOrQBgvoX6wYGweWmt6CNSNocpIbm0k5Ev9xx6g8Qa4yaoPw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLhSIryG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLhSIryG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54570C4CEF5;
	Tue, 21 Oct 2025 19:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076449;
	bh=LZHrH7/XCBsbrCStNMghNcar9g4/QoflSmOWUnFmFTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLhSIryGRd7UaV7TUCncYFLCQcKYJwLVe0P0Z68Ocl76npghZaEt0zI/Zxaj38O9t
	 CSTopY/PP4uiMl5g8uaFTKl0stxsk56rnrgQZ8TvKjoej4rYtgii7hifL8ojq4Neh5
	 0XP6W+HWmwpLr0tlvjExxXNFp3R4WHalgB6xiTC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeounsu Moon <yyyynoom@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/105] net: dlink: handle dma_map_single() failure properly
Date: Tue, 21 Oct 2025 21:50:46 +0200
Message-ID: <20251021195022.572694947@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1c3a5cf379cd0..72c97dcd0fee0 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -498,25 +498,34 @@ static int alloc_list(struct net_device *dev)
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



