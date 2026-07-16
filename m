Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661D742F6E5;
	Thu, 16 Jul 2026 14:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212342; cv=none; b=GONCyDRwBzLEzz3/9Vax5Ie/G2VAxuWCcJE+TrE4Z1Q4VY/gQCKS6mN70TsKl3Ww1X8FsPHywMUNPgowD0zMw47BfaZni3Vxwo9I8ECyDCY+TX5yS2OenQqJqep8C6EVX8938W4SMtgoIBfBCRquOw6tzWYtO52iQ8z0CEa+Gvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212342; c=relaxed/simple;
	bh=8j75rJsNgEs27PULDh6kJvCKZi2xUvvZp/qDdGmGl3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJjAbCDzXceuGkUG8TKnz4XEz5CzUmBflJVcIE5mgcFKwII6cRD+FDmDGJSslyhXQN87XxEudKPkzBFBEzgLXyQT5FER8KZ8DnqymtQLzhwvYMCODW0SqGXnOfB+JZGararovmvbFM1a0BZVOLh3nSd9IrdcLW9zeHLuaIxbNko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prywvmVX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prywvmVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E371F00A3A;
	Thu, 16 Jul 2026 14:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212340;
	bh=i4PhY0iu0xK01Rfjh4AUABhLk68GrY11nVkTvzTnOJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=prywvmVXA2nMyqJPqWSM4kvAWyd2J102agNx+ryTg9DWRD8mDCnT1ZE8BsAeEFhtH
	 ITBe4nhSrYxV9FOMvTBzzmmYvTtHco9w1Q5l2Dpwy9jHVwCssBJUL/uQyQfoR7qS0f
	 gJbiV1GSst2ZWs6RxOTkk6/cacWOerVWhk+A3dLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 291/349] crypto: talitos/hash - prepare SEC1 descriptor chaining, remove additional descriptor
Date: Thu, 16 Jul 2026 15:33:45 +0200
Message-ID: <20260716133039.839031036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Louvel <paul.louvel@bootlin.com>

commit 59b5d899e33701665f18abe6bebf987427876e3e upstream.

Currently, when SEC1 has buffered data (nbuf != 0), the ahash code
creates an additional descriptor on the fly inside
common_nonsnoop_hash() to handle the remainder of the data. This
approach is incompatible with the arbitrary-length descriptor chaining
that follows.

Remove the "additional descriptor" logic from common_nonsnoop_hash()
and common_nonsnoop_hash_unmap().

Also remove the nbytes adjustment for SEC1 in ahash_edesc_alloc()
that subtracted nbuf.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/talitos.c |  101 ++---------------------------------------------
 1 file changed, 6 insertions(+), 95 deletions(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1788,15 +1788,9 @@ static void common_nonsnoop_hash_unmap(s
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 	struct talitos_desc *desc = &edesc->desc;
-	struct talitos_desc *desc2;
-
-	if (desc->next_desc)
-		desc2 = &edesc->next_desc->desc;
 
 	unmap_single_talitos_ptr(dev, &desc->ptr[5], DMA_FROM_DEVICE);
-	if (desc->next_desc &&
-	    desc->ptr[5].ptr != desc2->ptr[5].ptr)
-		unmap_single_talitos_ptr(dev, &desc2->ptr[5], DMA_FROM_DEVICE);
+
 	if (req_ctx->last_desc)
 		memcpy(areq->result, req_ctx->hw_context,
 		       crypto_ahash_digestsize(tfm));
@@ -1808,13 +1802,6 @@ static void common_nonsnoop_hash_unmap(s
 	if (from_talitos_ptr_len(&desc->ptr[1], is_sec1))
 		unmap_single_talitos_ptr(dev, &desc->ptr[1],
 					 DMA_TO_DEVICE);
-	else if (desc->next_desc)
-		unmap_single_talitos_ptr(dev, &desc2->ptr[1],
-					 DMA_TO_DEVICE);
-
-	if (is_sec1 && req_ctx->nbuf)
-		unmap_single_talitos_ptr(dev, &desc->ptr[3],
-					 DMA_TO_DEVICE);
 
 	if (edesc->dma_len)
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
@@ -1922,9 +1909,6 @@ static int common_nonsnoop_hash(struct t
 		to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen,
 			       is_sec1);
 
-	if (is_sec1 && req_ctx->nbuf)
-		length -= req_ctx->nbuf;
-
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1 && sg_count > 1)
 		sg_copy_to_buffer(req_ctx->psrc, sg_count, edesc->buf, length);
@@ -1934,16 +1918,10 @@ static int common_nonsnoop_hash(struct t
 	/*
 	 * data in
 	 */
-	if (is_sec1 && req_ctx->nbuf) {
-		map_single_talitos_ptr(dev, &desc->ptr[3], req_ctx->nbuf,
-				       req_ctx->buf[req_ctx->buf_idx],
-				       DMA_TO_DEVICE);
-	} else {
-		sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
-					  &desc->ptr[3], sg_count, 0, 0);
-		if (sg_count > 1)
-			sync_needed = true;
-	}
+	sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
+					&desc->ptr[3], sg_count, 0, 0);
+	if (sg_count > 1)
+		sync_needed = true;
 
 	/* fifth DWORD empty */
 
@@ -1963,49 +1941,6 @@ static int common_nonsnoop_hash(struct t
 	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) == 0)
 		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
 
-	if (is_sec1 && req_ctx->nbuf && length) {
-		struct talitos_edesc *edesc2;
-		struct talitos_desc *desc2;
-
-		edesc2 = kzalloc(sizeof(*edesc2),
-				 areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
-					 GFP_KERNEL :
-					 GFP_ATOMIC);
-		if (!edesc2) {
-			ret = -ENOMEM;
-			goto err;
-		}
-		edesc->next_desc = edesc2;
-
-		desc2 = &edesc2->desc;
-
-		desc2->hdr = desc->hdr;
-		desc2->hdr &= ~DESC_HDR_MODE0_MDEU_INIT;
-		desc->hdr &= ~DESC_HDR_MODE0_MDEU_PAD;
-		desc->hdr |= DESC_HDR_MODE0_MDEU_CONT;
-		desc->hdr &= ~DESC_HDR_DONE_NOTIFY;
-
-		if (desc->ptr[1].ptr)
-			copy_talitos_ptr(&desc2->ptr[1], &desc->ptr[1],
-					 is_sec1);
-		else
-			map_single_talitos_ptr_nosync(dev, &desc2->ptr[1],
-						      req_ctx->hw_context_size,
-						      req_ctx->hw_context,
-						      DMA_TO_DEVICE);
-		copy_talitos_ptr(&desc2->ptr[2], &desc->ptr[2], is_sec1);
-		sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
-					  &desc2->ptr[3], sg_count, 0, 0);
-		if (sg_count > 1)
-			sync_needed = true;
-		copy_talitos_ptr(&desc2->ptr[5], &desc->ptr[5], is_sec1);
-		if (req_ctx->last_desc)
-			map_single_talitos_ptr_nosync(dev, &desc->ptr[5],
-						      req_ctx->hw_context_size,
-						      req_ctx->hw_context,
-						      DMA_FROM_DEVICE);
-	}
-
 	if (sync_needed)
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
@@ -2028,11 +1963,6 @@ static struct talitos_edesc *ahash_edesc
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct talitos_private *priv = dev_get_drvdata(ctx->dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-
-	if (is_sec1)
-		nbytes -= req_ctx->nbuf;
 
 	return talitos_edesc_alloc(ctx->dev, req_ctx->psrc, NULL, NULL, 0,
 				   nbytes, 0, 0, 0, areq->base.flags, false);
@@ -2051,8 +1981,6 @@ static int ahash_process_req_one(struct
 	unsigned int nsg;
 	int nents;
 	struct device *dev = ctx->dev;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 	u8 *ctx_buf = req_ctx->buf[req_ctx->buf_idx];
 
 	if (!req_ctx->last_desc && (nbytes + req_ctx->nbuf <= blocksize)) {
@@ -2084,30 +2012,13 @@ static int ahash_process_req_one(struct
 	}
 
 	/* Chain in any previously buffered data */
-	if (!is_sec1 && req_ctx->nbuf) {
+	if (req_ctx->nbuf) {
 		nsg = (req_ctx->nbuf < nbytes_to_hash) ? 2 : 1;
 		sg_init_table(req_ctx->bufsl, nsg);
 		sg_set_buf(req_ctx->bufsl, ctx_buf, req_ctx->nbuf);
 		if (nsg > 1)
 			sg_chain(req_ctx->bufsl, 2, req_ctx->request_sl);
 		req_ctx->psrc = req_ctx->bufsl;
-	} else if (is_sec1 && req_ctx->nbuf && req_ctx->nbuf < blocksize) {
-		int offset;
-
-		if (nbytes_to_hash > blocksize)
-			offset = blocksize - req_ctx->nbuf;
-		else
-			offset = nbytes_to_hash - req_ctx->nbuf;
-		nents = sg_nents_for_len(req_ctx->request_sl, offset);
-		if (nents < 0) {
-			dev_err(dev, "Invalid number of src SG.\n");
-			return nents;
-		}
-		sg_copy_to_buffer(req_ctx->request_sl, nents,
-				  ctx_buf + req_ctx->nbuf, offset);
-		req_ctx->nbuf += offset;
-		req_ctx->psrc = scatterwalk_ffwd(req_ctx->bufsl, req_ctx->request_sl,
-						 offset);
 	} else
 		req_ctx->psrc = req_ctx->request_sl;
 


