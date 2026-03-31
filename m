Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5771C861A;
	Tue, 31 Mar 2026 16:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975349; cv=none; b=hCNhpOAp5SXoSpsHtEbljUlpR4JdP+UQ/1xAtVy34yd6ciOIfNgp6UeMzg4zCS4hFfBTxYRsbOlGXFKOX92JyqD1xH9THE8mOkstld9zm3LQvamBsQbdgcGVv2cKZnWxt4tvOQvqSCjV5fd/9Hii82FFL2i5GwPanKZ2fqx4cis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975349; c=relaxed/simple;
	bh=YnfRW8WXJQLv9AfSUTpso4o+H4VEUH5oiFQKw5PLPxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mG1MufKJvWgyXoJhVC7qsPDPfoCdj9M8SDf+BRn+EvFs8VXLumoIf1h5Xf+XNXg2PLxSNjwkfFsvOW+Hh6ERzrMzRsj9kydj4KajRRrrlBEnIiVi616DLWWybL9m0SlACRKguDNkMqfvK6h13WvE2hcYirArLYusQJiugT9LlJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owxY/b+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owxY/b+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3506EC19423;
	Tue, 31 Mar 2026 16:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975349;
	bh=YnfRW8WXJQLv9AfSUTpso4o+H4VEUH5oiFQKw5PLPxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owxY/b+eYiPXAHLN7zqoDDuzSN/i7ar6e7Cbjzs6xnRNqMI8R38TedXklJl7REEh5
	 p95hynRsufuSn8xIPyGvz1BXEOlED4JvwM45aT6vH6toxc6uy6bkC6b2P46krA5AT0
	 cpW2KIAkS5wgpTPblm0ysnUBUjkb17GkBjd7cVEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.19 260/342] dmaengine: sh: rz-dmac: Protect the driver specific lists
Date: Tue, 31 Mar 2026 18:21:33 +0200
Message-ID: <20260331161808.521576798@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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
@@ -448,6 +449,7 @@ static int rz_dmac_alloc_chan_resources(
 		if (!desc)
 			break;
 
+		/* No need to lock. This is called only for the 1st client. */
 		list_add_tail(&desc->node, &channel->ld_free);
 		channel->descs_allocated++;
 	}
@@ -503,18 +505,21 @@ rz_dmac_prep_dma_memcpy(struct dma_chan
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
 
@@ -530,27 +535,29 @@ rz_dmac_prep_slave_sg(struct dma_chan *c
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
 


