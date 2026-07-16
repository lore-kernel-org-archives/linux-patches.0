Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190F0424D79;
	Thu, 16 Jul 2026 14:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212349; cv=none; b=ZpYj6xSRriU6VQDx7fyJ8c1hJP/EXu97dgKznPMZXW2YI/visY/dtolDm5yo2ReI1lXzTzDxk4KMPGQH4G07QANUCjbjn4i97XnfC39RvqZr7OwuRPZsghXYSF+JvQx1UDCuSQoglMO6v9SqeHcqDv3rgs1e/66V0m4rHDcW4Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212349; c=relaxed/simple;
	bh=HkpJq9g6ZClXC/1O11oC/EBfwFi/e1Ay6VzJlcKAGvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xz/Yv+u1gGwkvX9FatwTPxNOW5ogEG0cTWVWlBDIscO5de/6tVqR8luWA4HR1H7oXQTa9C0UmqIffTdmLNxc/UHSh/OZG1NVV4Wk87XsmQLK2fvBBHARW5F0Jpu8HQWjGqgN2++GW3cKwKxOC4eMS9RDqyVkeV9TH7+K3k+/J0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnRdL2g2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnRdL2g2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFCC1F000E9;
	Thu, 16 Jul 2026 14:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212348;
	bh=+HqxYIhselhApwwRFR6pI9rZ/ZLQ18fJXYV6R0CNqxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SnRdL2g288TuyRVYjphoFu9BIcGywLu+Pa90rw+osVIPZ0Gzv14zvaOMbK9kX8Tcb
	 SbjowtSWiuegUAbuaJvmKCuDO3nz1IfZGzm71GFPHuUt1WdZu1OC5sHPsNJLxy1QuR
	 BugwR6KJMh3nYGN6ibCnYRlBAbowYl+OWBOarubo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 294/349] crypto: talitos/hash - rename first_desc/last_desc to first_request/last_request
Date: Thu, 16 Jul 2026 15:33:48 +0200
Message-ID: <20260716133039.902022662@linuxfoundation.org>
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

commit 8bcf00671400ac3b3a4cc3011e6c1496dbd880fd upstream.

In talitos_ahash_req_ctx and talitos_export_state, the fields
first_desc and last_desc describe request-level (not descriptor-level)
state.  Rename them to first_request and last_request for clarity.
last_desc is also removed from talitos_ahash_req_ctx as it is no
longer used.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/talitos.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -944,8 +944,7 @@ struct talitos_ahash_req_ctx {
 	u8 buf[2][HASH_MAX_BLOCK_SIZE];
 	int buf_idx;
 	unsigned int swinit;
-	unsigned int first_desc;
-	unsigned int last_desc;
+	unsigned int first_request;
 	unsigned int last_request;
 	unsigned int to_hash_later;
 	unsigned int nbuf;
@@ -957,8 +956,8 @@ struct talitos_export_state {
 	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
 	u8 buf[HASH_MAX_BLOCK_SIZE];
 	unsigned int swinit;
-	unsigned int first_desc;
-	unsigned int last_desc;
+	unsigned int first_request;
+	unsigned int last_request;
 	unsigned int to_hash_later;
 	unsigned int nbuf;
 };
@@ -1822,8 +1821,7 @@ static void ahash_done(struct device *de
 		 container_of(desc, struct talitos_edesc, desc);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
-
-	if (!req_ctx->last_desc && req_ctx->to_hash_later) {
+	if (!req_ctx->last_request && req_ctx->to_hash_later) {
 		/* Position any partial block for next update/final/finup */
 		req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
 		req_ctx->nbuf = req_ctx->to_hash_later;
@@ -1872,7 +1870,7 @@ static void common_nonsnoop_hash(struct
 	/* first DWORD empty */
 
 	/* hash context in */
-	if (!edesc->first || !req_ctx->first_desc || req_ctx->swinit) {
+	if (!edesc->first || !req_ctx->first_request || req_ctx->swinit) {
 		map_single_talitos_ptr_nosync(dev, &desc->ptr[1],
 					      req_ctx->hw_context_size,
 					      req_ctx->hw_context,
@@ -1880,7 +1878,7 @@ static void common_nonsnoop_hash(struct
 		req_ctx->swinit = 0;
 	}
 	/* Indicate next op is not the first. */
-	req_ctx->first_desc = 0;
+	req_ctx->first_request = 0;
 
 	/* HMAC key */
 	if (ctx->keylen)
@@ -1975,14 +1973,14 @@ ahash_process_req_prepare(struct ahash_r
 			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
 
 		/* request SEC to INIT hash. */
-		if (req_ctx->first_desc && edesc->first && !req_ctx->swinit)
+		if (req_ctx->first_request && edesc->first && !req_ctx->swinit)
 			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
 
 		/*
 		 * When the tfm context has a keylen, it's an HMAC.
 		 * A first or last (ie. not middle) descriptor must request HMAC.
 		 */
-		if (ctx->keylen && ((req_ctx->first_desc && edesc->first) ||
+		if (ctx->keylen && ((req_ctx->first_request && edesc->first) ||
 				    (req_ctx->last_request && edesc->last)))
 			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
 
@@ -2103,14 +2101,13 @@ static int ahash_init(struct ahash_reque
 	/* Initialize the context */
 	req_ctx->buf_idx = 0;
 	req_ctx->nbuf = 0;
-	req_ctx->first_desc = 1; /* first_desc indicates h/w must init its context */
+	req_ctx->first_request = 1;
 	req_ctx->swinit = 0; /* assume h/w init of context */
 	size =	(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
 			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
 			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
 	req_ctx->hw_context_size = size;
 	req_ctx->last_request = 0;
-	req_ctx->last_desc = 0;
 
 	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
 			     DMA_TO_DEVICE);
@@ -2202,8 +2199,8 @@ static int ahash_export(struct ahash_req
 	       req_ctx->hw_context_size);
 	memcpy(export->buf, req_ctx->buf[req_ctx->buf_idx], req_ctx->nbuf);
 	export->swinit = req_ctx->swinit;
-	export->first_desc = req_ctx->first_desc;
-	export->last_desc = req_ctx->last_desc;
+	export->first_request = req_ctx->first_request;
+	export->last_request = req_ctx->last_request;
 	export->to_hash_later = req_ctx->to_hash_later;
 	export->nbuf = req_ctx->nbuf;
 
@@ -2228,8 +2225,8 @@ static int ahash_import(struct ahash_req
 	memcpy(req_ctx->hw_context, export->hw_context, size);
 	memcpy(req_ctx->buf[0], export->buf, export->nbuf);
 	req_ctx->swinit = export->swinit;
-	req_ctx->first_desc = export->first_desc;
-	req_ctx->last_desc = export->last_desc;
+	req_ctx->first_request = export->first_request;
+	req_ctx->last_request = export->last_request;
 	req_ctx->to_hash_later = export->to_hash_later;
 	req_ctx->nbuf = export->nbuf;
 


