Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC63271473;
	Mon, 13 Oct 2025 15:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367870; cv=none; b=GCzjopc8H3+63Csz+eg5pJBByOIicgHJda2DlhMgXqdAQROqihbs+BhHCC4EV2r51c7X3nKoWSkqasSdypnreuNPMi9e2E8aRjHtW5M3cZ+3G2ph5gpgyCFMU1u2eGbc18OZ6ZAEjNfeO5N9lZTXfJcB/p1gkAQb4LpVaDPn6JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367870; c=relaxed/simple;
	bh=cPYkXvX1gquYL+3EqPshm2NsEkr91ormqI4KRjh/UPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjTR4bLSkrpMmu4yUyUM+kf0kLt2BVIrxB+EyxuvsUijf3KOFnI9PQzQ3dS78k4ofAl/3TBlOIq4WSRO9ECH+IxJcQeAzp/Rm3lCaoIBl8n1mrxYSECuaDWPJNFhkjW4O2SiMUTIrkoFmvN9B+kvnu7VPWaOP/tapjDae2u2d6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDCJU8d1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDCJU8d1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11617C4CEE7;
	Mon, 13 Oct 2025 15:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367870;
	bh=cPYkXvX1gquYL+3EqPshm2NsEkr91ormqI4KRjh/UPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDCJU8d1oO8crFB/Okcy5D0sGfXeCSK8yHlR7S5wk1IbenVOQZHDRDYBdP0GirriN
	 zIWTyzfNRb0NsLfFdhb5KIeheNJFwnrtYud3LwuowQ6fYnNPBz38P96ufkKNdVfVhU
	 /eUqJ3CVQ1LV0CYgsDaw85OndP5EMw8aEVNpeEDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Yeounsu Moon <yyyynoom@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/196] net: dlink: handle copy_thresh allocation failure
Date: Mon, 13 Oct 2025 16:45:52 +0200
Message-ID: <20251013144321.135795668@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
index f1208591ed67e..1c3a5cf379cd0 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -954,15 +954,18 @@ receive_packet (struct net_device *dev)
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



