Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF683EBF20;
	Tue, 17 Mar 2026 16:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765620; cv=none; b=IDKllCBdxNyJ/m4XPrsfFEwJ6QLOCg4NiypqSgIm7EFr0Nu1cBH9fdf4YyCyAxvxPLiXo3kCyn/sfFLqqCVoApKwSYcH5jOueimmFfEheGDTFN8ayHIISnjkz0Vi165uborIUVpyNAFx0CfM9/VEnhYVT40V9Hik6U4L6yi40Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765620; c=relaxed/simple;
	bh=BvdolAU9K1eVpBs/MST1HgPL3kFV82AscouMtrrtHgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEVBWfZrIuo3xr2rv3nr/FbrslXgKooeULhVj8oMY337RIhRJy43AzO5ML7Ht/jdtIZCXXSbZ1/LnwcYJacoUTBC26zmkjNnf9xat5GLiSz8EHaDw2eIWP1oGs1ULcObd7PddE3ZW4S7eVRklHJy9TmnUjKkC9iewFJdMv/jUME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bso1Ek8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bso1Ek8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25152C4CEF7;
	Tue, 17 Mar 2026 16:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765620;
	bh=BvdolAU9K1eVpBs/MST1HgPL3kFV82AscouMtrrtHgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bso1Ek8icL6qky49uY/rIPLKA3X6F1DyV+Z2dWSpXgoRZyiP7a4Jdz6TbAYgWx58f
	 N9kZ4NWbUwEs6ZD20oBiHNAQfeSwPz8gV5hy47avZdbMM1BG3W6p14ku2mQYE1oi9K
	 UTtx/dste2DWONYDv+wL+kEB7aolb0MMKSiT5c4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 051/378] net: spacemit: Fix error handling in emac_alloc_rx_desc_buffers()
Date: Tue, 17 Mar 2026 17:30:08 +0100
Message-ID: <20260317163008.868651929@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivian Wang <wangruikang@iscas.ac.cn>

[ Upstream commit 3aa1417803c1833cbd5bacb7e6a6489a196f2519 ]

Even if we get a dma_mapping_error() while mapping an RX buffer, we
should still update rx_ring->head to ensure that the buffers we were
able to allocate and map are used. Fix this by breaking out to the
existing code after the loop, analogous to the existing handling for skb
allocation failure.

Fixes: bfec6d7f2001 ("net: spacemit: Add K1 Ethernet MAC")
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Link: https://patch.msgid.link/20260305-k1-ethernet-more-fixes-v2-1-e4e434d65055@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/spacemit/k1_emac.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/spacemit/k1_emac.c b/drivers/net/ethernet/spacemit/k1_emac.c
index b49c4708bf9eb..5de69a105168a 100644
--- a/drivers/net/ethernet/spacemit/k1_emac.c
+++ b/drivers/net/ethernet/spacemit/k1_emac.c
@@ -582,7 +582,9 @@ static void emac_alloc_rx_desc_buffers(struct emac_priv *priv)
 						  DMA_FROM_DEVICE);
 		if (dma_mapping_error(&priv->pdev->dev, rx_buf->dma_addr)) {
 			dev_err_ratelimited(&ndev->dev, "Mapping skb failed\n");
-			goto err_free_skb;
+			dev_kfree_skb_any(skb);
+			rx_buf->skb = NULL;
+			break;
 		}
 
 		rx_desc_addr = &((struct emac_desc *)rx_ring->desc_addr)[i];
@@ -607,10 +609,6 @@ static void emac_alloc_rx_desc_buffers(struct emac_priv *priv)
 
 	rx_ring->head = i;
 	return;
-
-err_free_skb:
-	dev_kfree_skb_any(skb);
-	rx_buf->skb = NULL;
 }
 
 /* Returns number of packets received */
-- 
2.51.0



