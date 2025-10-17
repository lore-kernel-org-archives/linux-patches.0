Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5212330B22;
	Fri, 17 Oct 2025 15:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716195; cv=none; b=uIWTejQyOJ9GVCQQy0fhdJC0mXIRseg+hNv8IclCNoYhbfGcfEbfWZ8ngJkhBgeA3MQEYzgHSzySkxnThl+ETw2SGalSbsgIs8yRADVqKDKxuampd7U3ULq9yUHc72PinSgOm++R7I7Q5JU6FKphb2clbyTMPp8pgclKC3NtjNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716195; c=relaxed/simple;
	bh=9a9GV751AGjnaatwkJXKnTP9iPAvF4NOQr7ls3lRh6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUM7lKa05n7/gCRrdbJgXIoWW+wajmYuBfGsGxhFHwpqSrDK2FizIiGjESu68tEINbXm+qihJS6AkGHficS3MrBxSw69FeiNK4HSxKOjKnJvsLQGaPkeXFjnj36/im+TlQlIr6gyuGtxBZQJajrCbw20M//3ZzW4eFIuj9ceLKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAzLZ8F7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAzLZ8F7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA92C4CEE7;
	Fri, 17 Oct 2025 15:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716195;
	bh=9a9GV751AGjnaatwkJXKnTP9iPAvF4NOQr7ls3lRh6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAzLZ8F71XmPGHSktv7rwBWJOEyBkqfYwcYfqEFUOIuXI+AMfPdjnQOCAcboyZC+I
	 41U1uQC0O+wTJF9R8XmF3f2Xg3m+mxEJurjP/7Avlaiac45JnTJbGmCdaEr3cuInrO
	 7FY0apcQgvWy1G+1L121URT8kD8oG2w/3utm3NUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Yeounsu Moon <yyyynoom@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/276] net: dlink: handle copy_thresh allocation failure
Date: Fri, 17 Oct 2025 16:53:18 +0200
Message-ID: <20251017145146.315605190@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 81395852b4d43..ca8bfd1b8278e 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -957,15 +957,18 @@ receive_packet (struct net_device *dev)
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



