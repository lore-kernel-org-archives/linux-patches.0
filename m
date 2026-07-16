Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B7A424671;
	Thu, 16 Jul 2026 14:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211364; cv=none; b=iUVv0NQ9blB1GXuO2/7C6+eyCeOg25LI//Rqjc2GT69iaZ8NSvFIVZml8q1S1+7O1GC+8IpI2tAaHXOLf9FA39hhSIbDH4XCX5oS07SvMsDd6vzZCCa7Hwrm+uqQSY5P1XIjTbQCAz+7qvGpmk/jGTHlKYqW65C9xP+t3UhhpUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211364; c=relaxed/simple;
	bh=RHnM7njRrTyoDGgEgx69p/+SlPii1TSxgJ6g2fdP0tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Srih0N/krvncSIfO/CUyuMuwQTO2wob81l9KBWG/r9KorDbT119VombZsBoB6x5k7bK/1RWC9ghDrN5dqFOQd2aPPBhjo6gSxQ5HHI/jRyg+GJfSceGsClFCCK3Fa94zYYxZcfM1NMTXz8P/gUiIeoaPb3tBFUjiw8yyf7wn3DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fs93WDGe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fs93WDGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99FB1F000E9;
	Thu, 16 Jul 2026 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211362;
	bh=MKeFTYqp4tjdU6qQ6+dMQlwMcl9BZ7mSxNutb2+7hL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fs93WDGe0Df6D+25CPyLugEASMhIhtCtWFWk1zaOQUyIaIDXrVvgXfnHCWHf/Nax5
	 5moIi4YSLPhhxUsnJApU3ghs6Lc4pCPaJ2jkuVF52xR9QtlWa2h6t+fvYmT8Sx5oP3
	 6hUYoDzhqjwZtjgldDQMxIlP8zT4UJH9f+ied+Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 372/480] crypto: talitos - add chaining of arbitrary number of descriptor for the SEC1
Date: Thu, 16 Jul 2026 15:31:59 +0200
Message-ID: <20260716133052.855348240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Louvel <paul.louvel@bootlin.com>

commit f126384ed55279c3b676f89d5ab547b8de8df782 upstream.

The SEC1 hardware can process a chain of descriptors without host
intervention. Only the hash implementation currently use this feature,
but with a chain of at most 2 descriptors added in commit 37b5e8897eb5
("crypto: talitos - chain in buffered data for ahash on SEC1").

Add supports for chaining an arbitrary number of descriptors in a chain.

Adapt the ahash implementation to make it compatible.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/talitos.c |  180 +++++++++++++++++++++++++++++++----------------
 drivers/crypto/talitos.h |    2 
 2 files changed, 124 insertions(+), 58 deletions(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -273,7 +273,10 @@ static int talitos_submit(struct device
 					   void *context, int error),
 			  void *context)
 {
+	struct talitos_edesc *edesc = container_of(desc, struct talitos_edesc, desc);
 	struct talitos_private *priv = dev_get_drvdata(dev);
+	dma_addr_t dma_desc, prev_dma_desc;
+	struct talitos_edesc *prev_edesc = NULL;
 	struct talitos_request *request;
 	unsigned long flags;
 	int head;
@@ -292,10 +295,31 @@ static int talitos_submit(struct device
 
 	/* map descriptor and save caller data */
 	if (is_sec1) {
-		desc->hdr1 = desc->hdr;
-		request->dma_desc = dma_map_single(dev, &desc->hdr1,
+		while (edesc) {
+			edesc->desc.hdr1 = edesc->desc.hdr;
+
+			dma_desc = dma_map_single(dev, &edesc->desc.hdr1,
+						  TALITOS_DESC_SIZE,
+						  DMA_BIDIRECTIONAL);
+
+			if (!prev_edesc) {
+				request->dma_desc = dma_desc;
+				goto next;
+			}
+
+			/* Chain in any previous descriptors. */
+
+			prev_edesc->desc.next_desc = cpu_to_be32(dma_desc);
+
+			dma_sync_single_for_device(dev, prev_dma_desc,
 						   TALITOS_DESC_SIZE,
-						   DMA_BIDIRECTIONAL);
+						   DMA_TO_DEVICE);
+
+next:
+			prev_edesc = edesc;
+			prev_dma_desc = dma_desc;
+			edesc = edesc->next_desc;
+		}
 	} else {
 		request->dma_desc = dma_map_single(dev, desc,
 						   TALITOS_DESC_SIZE,
@@ -326,6 +350,7 @@ static __be32 get_request_hdr(struct dev
 			      struct talitos_request *request, bool is_sec1)
 {
 	struct talitos_edesc *edesc;
+	dma_addr_t dma_desc;
 
 	if (!is_sec1) {
 		dma_sync_single_for_cpu(dev, request->dma_desc,
@@ -334,19 +359,17 @@ static __be32 get_request_hdr(struct dev
 		return request->desc->hdr;
 	}
 
-	if (!request->desc->next_desc) {
-		dma_sync_single_for_cpu(dev, request->dma_desc,
-					TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
-		return request->desc->hdr1;
-	} else {
-		dma_sync_single_for_cpu(dev,
-					be32_to_cpu(request->desc->next_desc),
-					TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
-		edesc = container_of(request->desc, struct talitos_edesc, desc);
-
-		return ((struct talitos_desc *)(edesc->buf + edesc->dma_len))
-			->hdr1;
+	edesc = container_of(request->desc, struct talitos_edesc, desc);
+	dma_desc = request->dma_desc;
+	while (edesc->next_desc) {
+		dma_desc = be32_to_cpu(edesc->desc.next_desc);
+		edesc = edesc->next_desc;
 	}
+
+	dma_sync_single_for_cpu(dev, dma_desc, TALITOS_DESC_SIZE,
+				DMA_BIDIRECTIONAL);
+
+	return edesc->desc.hdr1;
 }
 
 /*
@@ -356,6 +379,7 @@ static void flush_channel(struct device
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	struct talitos_request *request, saved_req;
+	struct talitos_edesc *edesc;
 	unsigned long flags;
 	int tail, status;
 	bool is_sec1 = has_ftr_sec1(priv);
@@ -380,9 +404,22 @@ static void flush_channel(struct device
 			else
 				status = error;
 
-		dma_unmap_single(dev, request->dma_desc,
-				 TALITOS_DESC_SIZE,
-				 DMA_BIDIRECTIONAL);
+		if (is_sec1) {
+			dma_unmap_single(dev, request->dma_desc,
+					 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+			edesc = container_of(request->desc,
+					     struct talitos_edesc, desc);
+			while (edesc->next_desc) {
+				dma_unmap_single(
+					dev, be32_to_cpu(edesc->desc.next_desc),
+					TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+				edesc = edesc->next_desc;
+			}
+		} else {
+			dma_unmap_single(dev, request->dma_desc,
+					TALITOS_DESC_SIZE,
+					DMA_BIDIRECTIONAL);
+		}
 
 		/* copy entries so we can call callback outside lock */
 		saved_req.desc = request->desc;
@@ -477,8 +514,12 @@ DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH
 static __be32 current_desc_hdr(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+	struct talitos_request *request;
+	struct talitos_edesc *edesc;
 	int tail, iter;
 	dma_addr_t cur_desc;
+	__be32 hdr = 0;
 
 	cur_desc = ((u64)in_be32(priv->chan[ch].reg + TALITOS_CDPR)) << 32;
 	cur_desc |= in_be32(priv->chan[ch].reg + TALITOS_CDPR_LO);
@@ -489,27 +530,35 @@ static __be32 current_desc_hdr(struct de
 	}
 
 	tail = priv->chan[ch].tail;
-
 	iter = tail;
-	while (priv->chan[ch].fifo[iter].dma_desc != cur_desc &&
-	       priv->chan[ch].fifo[iter].desc->next_desc != cpu_to_be32(cur_desc)) {
-		iter = (iter + 1) & (priv->fifo_len - 1);
-		if (iter == tail) {
-			dev_err(dev, "couldn't locate current descriptor\n");
-			return 0;
+	do {
+		request = &priv->chan[ch].fifo[iter];
+
+		if (request->dma_desc == cur_desc) {
+			hdr = request->desc->hdr;
+		} else if (is_sec1) {
+			edesc = container_of(request->desc,
+					     struct talitos_edesc, desc);
+			while (edesc->next_desc) {
+				if (edesc->desc.next_desc ==
+				    cpu_to_be32(cur_desc)) {
+					hdr = edesc->next_desc->desc.hdr1;
+					break;
+				}
+				edesc = edesc->next_desc;
+			}
 		}
-	}
 
-	if (priv->chan[ch].fifo[iter].desc->next_desc == cpu_to_be32(cur_desc)) {
-		struct talitos_edesc *edesc;
+		if (hdr)
+			break;
 
-		edesc = container_of(priv->chan[ch].fifo[iter].desc,
-				     struct talitos_edesc, desc);
-		return ((struct talitos_desc *)
-			(edesc->buf + edesc->dma_len))->hdr;
-	}
+		iter = (iter + 1) & (priv->fifo_len - 1);
+	} while (iter != tail);
+
+	if (!hdr)
+		dev_err(dev, "couldn't locate current descriptor\n");
 
-	return priv->chan[ch].fifo[iter].desc->hdr;
+	return hdr;
 }
 
 /*
@@ -1408,10 +1457,6 @@ static struct talitos_edesc *talitos_ede
 		dma_len = 0;
 	}
 	alloc_len += icv_stashing ? authsize : 0;
-
-	/* if its a ahash, add space for a second desc next to the first one */
-	if (is_sec1 && !dst)
-		alloc_len += sizeof(struct talitos_desc);
 	alloc_len += ivsize;
 
 	edesc = kmalloc(ALIGN(alloc_len, dma_get_cache_alignment()), flags);
@@ -1427,6 +1472,7 @@ static struct talitos_edesc *talitos_ede
 	edesc->dst_nents = dst_nents;
 	edesc->iv_dma = iv_dma;
 	edesc->dma_len = dma_len;
+	edesc->next_desc = NULL;
 	if (dma_len)
 		edesc->dma_link_tbl = dma_map_single(dev, &edesc->link_tbl[0],
 						     edesc->dma_len,
@@ -1727,8 +1773,10 @@ static void common_nonsnoop_hash_unmap(s
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 	struct talitos_desc *desc = &edesc->desc;
-	struct talitos_desc *desc2 = (struct talitos_desc *)
-				     (edesc->buf + edesc->dma_len);
+	struct talitos_desc *desc2;
+
+	if (desc->next_desc)
+		desc2 = &edesc->next_desc->desc;
 
 	unmap_single_talitos_ptr(dev, &desc->ptr[5], DMA_FROM_DEVICE);
 	if (desc->next_desc &&
@@ -1756,10 +1804,17 @@ static void common_nonsnoop_hash_unmap(s
 	if (edesc->dma_len)
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
 				 DMA_BIDIRECTIONAL);
+}
 
-	if (desc->next_desc)
-		dma_unmap_single(dev, be32_to_cpu(desc->next_desc),
-				 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+static void free_edesc_list_from(struct talitos_edesc *edesc)
+{
+	struct talitos_edesc *next;
+
+	while (edesc) {
+		next = edesc->next_desc;
+		kfree(edesc);
+		edesc = next;
+	}
 }
 
 static void ahash_done(struct device *dev,
@@ -1778,7 +1833,7 @@ static void ahash_done(struct device *de
 	}
 	common_nonsnoop_hash_unmap(dev, edesc, areq);
 
-	kfree(edesc);
+	free_edesc_list_from(edesc);
 
 	if (err) {
 		ahash_request_complete(areq, err);
@@ -1894,14 +1949,23 @@ static int common_nonsnoop_hash(struct t
 		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
 
 	if (is_sec1 && req_ctx->nbuf && length) {
-		struct talitos_desc *desc2 = (struct talitos_desc *)
-					     (edesc->buf + edesc->dma_len);
-		dma_addr_t next_desc;
+		struct talitos_edesc *edesc2;
+		struct talitos_desc *desc2;
+
+		edesc2 = kzalloc(sizeof(*edesc2),
+				 areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+					 GFP_KERNEL :
+					 GFP_ATOMIC);
+		if (!edesc2) {
+			ret = -ENOMEM;
+			goto err;
+		}
+		edesc->next_desc = edesc2;
+
+		desc2 = &edesc2->desc;
 
-		memset(desc2, 0, sizeof(*desc2));
 		desc2->hdr = desc->hdr;
 		desc2->hdr &= ~DESC_HDR_MODE0_MDEU_INIT;
-		desc2->hdr1 = desc2->hdr;
 		desc->hdr &= ~DESC_HDR_MODE0_MDEU_PAD;
 		desc->hdr |= DESC_HDR_MODE0_MDEU_CONT;
 		desc->hdr &= ~DESC_HDR_DONE_NOTIFY;
@@ -1925,21 +1989,21 @@ static int common_nonsnoop_hash(struct t
 						      req_ctx->hw_context_size,
 						      req_ctx->hw_context,
 						      DMA_FROM_DEVICE);
-
-		next_desc = dma_map_single(dev, &desc2->hdr1, TALITOS_DESC_SIZE,
-					   DMA_BIDIRECTIONAL);
-		desc->next_desc = cpu_to_be32(next_desc);
 	}
 
 	if (sync_needed)
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
 
-	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
-	if (ret != -EINPROGRESS) {
-		common_nonsnoop_hash_unmap(dev, edesc, areq);
-		kfree(edesc);
-	}
+	ret = talitos_submit(dev, ctx->ch, desc, callback,
+			     areq);
+	if (ret != -EINPROGRESS)
+		goto err;
+
+	return -EINPROGRESS;
+err:
+	common_nonsnoop_hash_unmap(dev, edesc, areq);
+	kfree(edesc);
 	return ret;
 }
 
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -49,6 +49,7 @@ struct talitos_desc {
  * @iv_dma: dma address of iv for checking continuity and link table
  * @dma_len: length of dma mapped link_tbl space
  * @dma_link_tbl: bus physical address of link_tbl/buf
+ * @next_desc: next descriptor
  * @desc: h/w descriptor
  * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1) (SEC2)
  * @buf: input and output buffeur (if {src,dst}_nents > 1) (SEC1)
@@ -63,6 +64,7 @@ struct talitos_edesc {
 	dma_addr_t iv_dma;
 	int dma_len;
 	dma_addr_t dma_link_tbl;
+	struct talitos_edesc *next_desc;
 	struct talitos_desc desc;
 	union {
 		DECLARE_FLEX_ARRAY(struct talitos_ptr, link_tbl);


