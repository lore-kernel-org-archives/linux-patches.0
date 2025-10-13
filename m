Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA4F307AE1;
	Mon, 13 Oct 2025 14:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367315; cv=none; b=JazyjUGlUWYXiwJOQeSPs9yeCAVboJ9TaVojWI6OCTcWcnEWR16G7+pnr9/8IQjyn6UmeX9x2QCIX9J0STyEruL+nlSV0Mam+hW24qhuiIJJxcC4/ss/SfjN6TyMP5qUwSXpOLB8SXOHjVVDFP0lJSzX6eUqvqpGwJhJ/g/YUiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367315; c=relaxed/simple;
	bh=LVUuu9mY8N3vRN0eXhqweO0C/WhPxOqMr22JzvR4BOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYo80VA6dBA/BvRs3lVSnr8/jqIHxy3hSfZ+Ucxr0biZmp3xkXqZ4bHRS0Vkjmr4llGJ39kCw9lDVpzaf+BN/vLeNGufDCIMsjYqwadzQ6deGZyBiv4qTcn7mjtWY0TlLO707C64zjuEuSauig23125U5jbSayQBTGF0rYypVuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJe63nc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJe63nc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF54C4CEE7;
	Mon, 13 Oct 2025 14:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367315;
	bh=LVUuu9mY8N3vRN0eXhqweO0C/WhPxOqMr22JzvR4BOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJe63nc4ObyGpgUhouCh72ubjyjalAocqKY8g0rtuvzGRsWvTUqqUN/uSjaSxGTY8
	 fk0LtFC6hRIi/ja01ENWB9XW6xnDfCX7RcwW9euEOXXe2hGe25AOD6TRoSpikwX+AJ
	 6fLXO/oZEnsapePOWHluodKil9vL0dJfGmNzRlPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Yeounsu Moon <yyyynoom@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/196] net: dlink: handle copy_thresh allocation failure
Date: Mon, 13 Oct 2025 16:45:40 +0200
Message-ID: <20251013144320.739072918@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yeounsu Moon <yyyynoom@gmail.com>

[ Upstream commit 8169a6011c5fecc6cb1c3654c541c567d3318de8 ]

The driver did not handle failure of `netdev_alloc_skb_ip_align()`.
If the allocation failed, dereferencing `skb->protocol` could lead to
a NULL pointer dereference.

This patch tries to allocate `skb`. If the allocation fails, it falls
back to the normal path.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Tested-on: D-Link DGE-550T Rev-A3
Signed-off-by: Yeounsu Moon <yyyynoom@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250928190124.1156-1-yyyynoom@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dlink/dl2k.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index 2acb63b547c35..bf58181589bf2 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -956,15 +956,18 @@ receive_packet (struct net_device *dev)
 		} else {
 			struct sk_buff *skb;
 
+			skb = NULL;
 			/* Small skbuffs for short packets */
-			if (pkt_len > copy_thresh) {
+			if (pkt_len <= copy_thresh)
+				skb = netdev_alloc_skb_ip_align(dev, pkt_len);
+			if (!skb) {
 				dma_unmap_single(&np->pdev->dev,
 						 desc_to_dma(desc),
 						 np->rx_buf_sz,
 						 DMA_FROM_DEVICE);
 				skb_put (skb = np->rx_skbuff[entry], pkt_len);
 				np->rx_skbuff[entry] = NULL;
-			} else if ((skb = netdev_alloc_skb_ip_align(dev, pkt_len))) {
+			} else {
 				dma_sync_single_for_cpu(&np->pdev->dev,
 							desc_to_dma(desc),
 							np->rx_buf_sz,
-- 
2.51.0



