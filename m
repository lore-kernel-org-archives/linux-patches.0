Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A95423A89;
	Tue, 31 Mar 2026 16:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974537; cv=none; b=a/kqe9hIORQz33FDiFqzdAgLjVHSXTp23lgop/kyub9MkxzpNQRrKYAg+SFGkL5rWBKsQZlnDC64edAfurLSMnkpQ4CBpsgkJIHwzew5oFwCYrgPXTmD+zv1L975m7egh12hmAr/Y3Lm9sWaF2ifnc06R7IFRMe5iZ8wUY4tQl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974537; c=relaxed/simple;
	bh=rFxcuNiZQkHDIYf56I/OOe/DZKx11M/76ppyCoulcas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5XTXpm4KzxCNN6VZW3bzznb11foVQIM8hgw8qjRm/qfAqrczB0N7jN0jizwj76UQi7H1ZcI9LYx2xXIQmjxh1hLn/S2k8BcXjat6xHwnClck8ml29hlLY9WGJBEBY2XkLZnZXT0CJIBoQeon5xyzSAxClSDObnCcrXb8vDuRNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQuw2Iep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQuw2Iep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3413C19423;
	Tue, 31 Mar 2026 16:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974537;
	bh=rFxcuNiZQkHDIYf56I/OOe/DZKx11M/76ppyCoulcas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQuw2IepyM1rRfwRsMlALo1brMFFg5F+Otu7xWrG4g8C8jsvKxSYkIpd7JZyG2We2
	 vL/eLDdR+2VP48SnolisJ+C869G05WWQ3ipOs1dhsIwPZqNx5K9AB1XrwwhWqf5bJi
	 P5M8HPpukP9zDdlAZCOi9Cnx/WzU2qbjW0TN/FR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 124/175] dmaengine: sh: rz-dmac: Protect the driver specific lists
Date: Tue, 31 Mar 2026 18:21:48 +0200
Message-ID: <20260331161734.336263127@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea@tuxon.dev>

commit abb863e6213dc41a58ef8bb3289b7e77460dabf3 upstream.

The driver lists (ld_free, ld_queue) are used in
rz_dmac_free_chan_resources(), rz_dmac_terminate_all(),
rz_dmac_issue_pending(), and rz_dmac_irq_handler_thread(), all under
the virtual channel lock. Take the same lock in rz_dmac_prep_slave_sg()
and rz_dmac_prep_dma_memcpy() as well to avoid concurrency issues, since
these functions also check whether the lists are empty and update or
remove list entries.

Fixes: 5000d37042a6 ("dmaengine: sh: Add DMAC driver for RZ/G2L SoC")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20260316133252.240348-2-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/sh/rz-dmac.c |   63 ++++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 28 deletions(-)

--- a/drivers/dma/sh/rz-dmac.c
+++ b/drivers/dma/sh/rz-dmac.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/cleanup.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/interrupt.h>
@@ -424,6 +425,7 @@ static int rz_dmac_alloc_chan_resources(
 		if (!desc)
 			break;
 
+		/* No need to lock. This is called only for the 1st client. */
 		list_add_tail(&desc->node, &channel->ld_free);
 		channel->descs_allocated++;
 	}
@@ -479,18 +481,21 @@ rz_dmac_prep_dma_memcpy(struct dma_chan
 	dev_dbg(dmac->dev, "%s channel: %d src=0x%pad dst=0x%pad len=%zu\n",
 		__func__, channel->index, &src, &dest, len);
 
-	if (list_empty(&channel->ld_free))
-		return NULL;
+	scoped_guard(spinlock_irqsave, &channel->vc.lock) {
+		if (list_empty(&channel->ld_free))
+			return NULL;
+
+		desc = list_first_entry(&channel->ld_free, struct rz_dmac_desc, node);
+
+		desc->type = RZ_DMAC_DESC_MEMCPY;
+		desc->src = src;
+		desc->dest = dest;
+		desc->len = len;
+		desc->direction = DMA_MEM_TO_MEM;
 
-	desc = list_first_entry(&channel->ld_free, struct rz_dmac_desc, node);
-
-	desc->type = RZ_DMAC_DESC_MEMCPY;
-	desc->src = src;
-	desc->dest = dest;
-	desc->len = len;
-	desc->direction = DMA_MEM_TO_MEM;
+		list_move_tail(channel->ld_free.next, &channel->ld_queue);
+	}
 
-	list_move_tail(channel->ld_free.next, &channel->ld_queue);
 	return vchan_tx_prep(&channel->vc, &desc->vd, flags);
 }
 
@@ -506,27 +511,29 @@ rz_dmac_prep_slave_sg(struct dma_chan *c
 	int dma_length = 0;
 	int i = 0;
 
-	if (list_empty(&channel->ld_free))
-		return NULL;
-
-	desc = list_first_entry(&channel->ld_free, struct rz_dmac_desc, node);
+	scoped_guard(spinlock_irqsave, &channel->vc.lock) {
+		if (list_empty(&channel->ld_free))
+			return NULL;
+
+		desc = list_first_entry(&channel->ld_free, struct rz_dmac_desc, node);
+
+		for_each_sg(sgl, sg, sg_len, i)
+			dma_length += sg_dma_len(sg);
+
+		desc->type = RZ_DMAC_DESC_SLAVE_SG;
+		desc->sg = sgl;
+		desc->sgcount = sg_len;
+		desc->len = dma_length;
+		desc->direction = direction;
+
+		if (direction == DMA_DEV_TO_MEM)
+			desc->src = channel->src_per_address;
+		else
+			desc->dest = channel->dst_per_address;
 
-	for_each_sg(sgl, sg, sg_len, i) {
-		dma_length += sg_dma_len(sg);
+		list_move_tail(channel->ld_free.next, &channel->ld_queue);
 	}
 
-	desc->type = RZ_DMAC_DESC_SLAVE_SG;
-	desc->sg = sgl;
-	desc->sgcount = sg_len;
-	desc->len = dma_length;
-	desc->direction = direction;
-
-	if (direction == DMA_DEV_TO_MEM)
-		desc->src = channel->src_per_address;
-	else
-		desc->dest = channel->dst_per_address;
-
-	list_move_tail(channel->ld_free.next, &channel->ld_queue);
 	return vchan_tx_prep(&channel->vc, &desc->vd, flags);
 }
 


