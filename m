Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12354325701;
	Thu, 16 Jul 2026 14:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211421; cv=none; b=kfjXhHj8U8Le73IRtYIII2zbW/NEGa+3ZHCjaUYCpJF9VyzR7U9SzHaXT1o1qL05i/7LyRdJgehT5mkq0OLFBkTzrTxN8jgy/lYdDetnxRCmJuhzpFO/sxRYkkR4WMFsBcQc/rrVjwLcS90EPoBKzyxMch/Ev6CaRHNeg4a8IO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211421; c=relaxed/simple;
	bh=efX7dqeiji3QNXBvXdq/0/3g4T6RqV8wxwOJ9ZkQwcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1GTmWoI2EsO0t5qE0ius/Lvp+SgjSNtA5V9imabxADrAjHi9996k8agIN92LABO73suy/gSfKCm/zVe5sN7spxFWx5/rOZFvA0Wy4WBKvE+tZ76vj+t3mGDedeLidVrKOQ8MSRBEj8vj2UuOGm853QXyWIoJteU6KRefH3NpcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lcgoiq4y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lcgoiq4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DCA1F000E9;
	Thu, 16 Jul 2026 14:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211419;
	bh=U9Pg+WpzUVrVQ9knfq9QTc7lnhIdm20Ik98xd3Y98Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lcgoiq4yP8bMLH3EaARB2ggLz8vLZGQmTbUYy4jx1+eoXrqLG37MO528o9r6XTUoh
	 XlbmTMhndcYksKNY0YX5dWe/dHEWLrDNohEYrkvz8dkKltkRbKF7V15z8Xe0K90YNh
	 Y2KrimlFna/Xp4K4LuSCRswVIIsg+QT6Belt2maI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 378/480] crypto: talitos/hash - drop workqueue mechanism for SEC1
Date: Thu, 16 Jul 2026 15:32:05 +0200
Message-ID: <20260716133052.983079243@linuxfoundation.org>
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

commit be4802afb1700534e48cb776d0d1e772c27de130 upstream.

Now that SEC1 hash uses hardware descriptor chaining instead of a
workqueue to process requests exceeding TALITOS1_MAX_DATA_LEN, the
workqueue code is no longer needed.

Remove sec1_ahash_process_remaining(), the related fields from
talitos_ahash_req_ctx (request_bufsl, areq, request_sl,
remaining_ahash_request_bytes, current_ahash_request_bytes,
sec1_ahash_process_remaining), the dead code in ahash_done(), and
simplify ahash_process_req() to call ahash_process_req_one() directly
with the original areq->src and areq->nbytes.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/talitos.c |   80 ++++-------------------------------------------
 1 file changed, 7 insertions(+), 73 deletions(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -12,7 +12,6 @@
  * All rights reserved.
  */
 
-#include <linux/workqueue.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
@@ -952,13 +951,6 @@ struct talitos_ahash_req_ctx {
 	unsigned int nbuf;
 	struct scatterlist bufsl[2];
 	struct scatterlist *psrc;
-
-	struct scatterlist request_bufsl[2];
-	struct ahash_request *areq;
-	struct scatterlist *request_sl;
-	unsigned int remaining_ahash_request_bytes;
-	unsigned int current_ahash_request_bytes;
-	struct work_struct sec1_ahash_process_remaining;
 };
 
 struct talitos_export_state {
@@ -1840,18 +1832,6 @@ static void ahash_done(struct device *de
 	free_edesc_list_from(areq, edesc);
 
 	ahash_request_complete(areq, err);
-
-	return;
-
-	req_ctx->remaining_ahash_request_bytes -=
-		req_ctx->current_ahash_request_bytes;
-
-	if (!req_ctx->remaining_ahash_request_bytes) {
-		ahash_request_complete(areq, 0);
-		return;
-	}
-
-	schedule_work(&req_ctx->sec1_ahash_process_remaining);
 }
 
 /*
@@ -2044,12 +2024,12 @@ static int ahash_process_req_one(struct
 
 	if (!req_ctx->last_request && (nbytes + req_ctx->nbuf <= blocksize)) {
 		/* Buffer up to one whole block */
-		nents = sg_nents_for_len(req_ctx->request_sl, nbytes);
+		nents = sg_nents_for_len(areq->src, nbytes);
 		if (nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
-		sg_copy_to_buffer(req_ctx->request_sl, nents,
+		sg_copy_to_buffer(areq->src, nents,
 				  ctx_buf + req_ctx->nbuf, nbytes);
 		req_ctx->nbuf += nbytes;
 		return 0;
@@ -2076,18 +2056,18 @@ static int ahash_process_req_one(struct
 		sg_init_table(req_ctx->bufsl, nsg);
 		sg_set_buf(req_ctx->bufsl, ctx_buf, req_ctx->nbuf);
 		if (nsg > 1)
-			sg_chain(req_ctx->bufsl, 2, req_ctx->request_sl);
+			sg_chain(req_ctx->bufsl, 2, areq->src);
 		req_ctx->psrc = req_ctx->bufsl;
 	} else
-		req_ctx->psrc = req_ctx->request_sl;
+		req_ctx->psrc = areq->src;
 
 	if (to_hash_later) {
-		nents = sg_nents_for_len(req_ctx->request_sl, nbytes);
+		nents = sg_nents_for_len(areq->src, nbytes);
 		if (nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
-		sg_pcopy_to_buffer(req_ctx->request_sl, nents,
+		sg_pcopy_to_buffer(areq->src, nents,
 				   req_ctx->buf[(req_ctx->buf_idx + 1) & 1],
 				      to_hash_later,
 				      nbytes - to_hash_later);
@@ -2106,54 +2086,9 @@ static int ahash_process_req_one(struct
 	return ret;
 }
 
-static void sec1_ahash_process_remaining(struct work_struct *work)
-{
-	struct talitos_ahash_req_ctx *req_ctx =
-		container_of(work, struct talitos_ahash_req_ctx,
-			     sec1_ahash_process_remaining);
-	int err = 0;
-
-	req_ctx->request_sl = scatterwalk_ffwd(req_ctx->request_bufsl,
-					       req_ctx->request_sl, TALITOS1_MAX_DATA_LEN);
-
-	if (req_ctx->remaining_ahash_request_bytes > TALITOS1_MAX_DATA_LEN)
-		req_ctx->current_ahash_request_bytes = TALITOS1_MAX_DATA_LEN;
-	else {
-		req_ctx->current_ahash_request_bytes =
-			req_ctx->remaining_ahash_request_bytes;
-
-		if (req_ctx->last_request)
-			req_ctx->last_desc = 1;
-	}
-
-	err = ahash_process_req_one(req_ctx->areq,
-				    req_ctx->current_ahash_request_bytes);
-
-	if (err != -EINPROGRESS)
-		ahash_request_complete(req_ctx->areq, err);
-}
-
 static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = ctx->dev;
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-
-	req_ctx->areq = areq;
-	req_ctx->request_sl = areq->src;
-	req_ctx->remaining_ahash_request_bytes = nbytes;
-
-	if (is_sec1) {
-		if (req_ctx->last_request)
-			req_ctx->last_desc = 1;
-	}
-
-	req_ctx->current_ahash_request_bytes = nbytes;
-
-	return ahash_process_req_one(req_ctx->areq, nbytes);
+	return ahash_process_req_one(areq, nbytes);
 }
 
 static int ahash_init(struct ahash_request *areq)
@@ -2176,7 +2111,6 @@ static int ahash_init(struct ahash_reque
 	req_ctx->hw_context_size = size;
 	req_ctx->last_request = 0;
 	req_ctx->last_desc = 0;
-	INIT_WORK(&req_ctx->sec1_ahash_process_remaining, sec1_ahash_process_remaining);
 
 	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
 			     DMA_TO_DEVICE);


