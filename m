Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07B442CAE3;
	Thu, 16 Jul 2026 14:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212294; cv=none; b=DPHngGldLv/ZkcLLrdRnKbVBBqrM/FQM52wiQsqmWJx8JAhuOiqrAofM02FdGMS5y+70m1N0MUV8O9CYRmmjXM0Zm/ZoVjF6nhPJdaH3pB+sPpp9+ig+9YeUnK5nyL1X73ofXW3mshm6eNOXQhhC6xPAQz5jq1xIt4lEv2Z6W54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212294; c=relaxed/simple;
	bh=9bKQjA7wV5H1QssRSP8rDc+SQegNG25tXIxDmkSKR5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wlj6c59ZI5Fw3RoX1cjwA04S3NWg6P/VODrfPUSTu7fLFxVTAu/RSK2NH2kM43fpnTZkoc/RWzVImLGhiaGshDiogRGMlS2QVYHjDY8gnR+/+YhrfP5LAkJVltKbPl1VYm3lq5XucnLJCSut0Y9IgqU2x1IXFgpoiBAHEE77pRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZF86VM9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZF86VM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3139B1F000E9;
	Thu, 16 Jul 2026 14:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212292;
	bh=Pxd/R86tcXzUWi+J1m4WV1Pu7KOhc+ZN2aP6znN8Jg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZF86VM9P19dKuSburthZ+XtcMjMB9df9xWSX73lXfLpZ4LxYd6l2gTmb0hhSU6nT
	 hA+FVi2gBzuWHB4kMnink6hrNQ3ZcZ3x//zwj0YDL5E8E9EAn0/F3Xbc2A709/2+T8
	 mEB5LQrBI43f5cUL5t1OWi4TQa+QTUPP2NuS1SJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 271/349] crypto: caam - use print_hex_dump_devel to guard key hex dumps
Date: Thu, 16 Jul 2026 15:33:25 +0200
Message-ID: <20260716133039.402329946@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 3f57657b6ea23f933371f2c2846322f441773cee upstream.

Use print_hex_dump_devel() for dumping sensitive key material in
*_setkey() and gen_split_key() to avoid leaking secrets at runtime when
CONFIG_DYNAMIC_DEBUG is enabled.

Fixes: 6e005503199b ("crypto: caam - print debug messages at debug level")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/caam/caamalg.c    |   12 ++++++------
 drivers/crypto/caam/caamalg_qi.c |   12 ++++++------
 drivers/crypto/caam/caamhash.c   |    4 ++--
 drivers/crypto/caam/key_gen.c    |    4 ++--
 4 files changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -597,7 +597,7 @@ static int aead_setkey(struct crypto_aea
 	dev_dbg(jrdev, "keylen %d enckeylen %d authkeylen %d\n",
 	       keys.authkeylen + keys.enckeylen, keys.enckeylen,
 	       keys.authkeylen);
-	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	/*
@@ -633,7 +633,7 @@ static int aead_setkey(struct crypto_aea
 	dma_sync_single_for_device(jrdev, ctx->key_dma, ctx->adata.keylen_pad +
 				   keys.enckeylen, ctx->dir);
 
-	print_hex_dump_debug("ctx.key@"__stringify(__LINE__)": ",
+	print_hex_dump_devel("ctx.key@"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, ctx->key,
 			     ctx->adata.keylen_pad + keys.enckeylen, 1);
 
@@ -674,7 +674,7 @@ static int gcm_setkey(struct crypto_aead
 	if (err)
 		return err;
 
-	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -695,7 +695,7 @@ static int rfc4106_setkey(struct crypto_
 	if (err)
 		return err;
 
-	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -721,7 +721,7 @@ static int rfc4543_setkey(struct crypto_
 	if (err)
 		return err;
 
-	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -748,7 +748,7 @@ static int skcipher_setkey(struct crypto
 	u32 *desc;
 	const bool is_rfc3686 = alg->caam.rfc3686;
 
-	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	ctx->cdata.keylen = keylen;
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -212,7 +212,7 @@ static int aead_setkey(struct crypto_aea
 	dev_dbg(jrdev, "keylen %d enckeylen %d authkeylen %d\n",
 		keys.authkeylen + keys.enckeylen, keys.enckeylen,
 		keys.authkeylen);
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	/*
@@ -248,7 +248,7 @@ static int aead_setkey(struct crypto_aea
 				   ctx->adata.keylen_pad + keys.enckeylen,
 				   ctx->dir);
 
-	print_hex_dump_debug("ctx.key@" __stringify(__LINE__)": ",
+	print_hex_dump_devel("ctx.key@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, ctx->key,
 			     ctx->adata.keylen_pad + keys.enckeylen, 1);
 
@@ -371,7 +371,7 @@ static int gcm_setkey(struct crypto_aead
 	if (ret)
 		return ret;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -475,7 +475,7 @@ static int rfc4106_setkey(struct crypto_
 	if (ret)
 		return ret;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -581,7 +581,7 @@ static int rfc4543_setkey(struct crypto_
 	if (ret)
 		return ret;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -631,7 +631,7 @@ static int skcipher_setkey(struct crypto
 	const bool is_rfc3686 = alg->caam.rfc3686;
 	int ret = 0;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	ctx->cdata.keylen = keylen;
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -505,7 +505,7 @@ static int axcbc_setkey(struct crypto_ah
 				   DMA_TO_DEVICE);
 	ctx->adata.keylen = keylen;
 
-	print_hex_dump_debug("axcbc ctx.key@" __stringify(__LINE__)" : ",
+	print_hex_dump_devel("axcbc ctx.key@" __stringify(__LINE__)" : ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, ctx->key, keylen, 1);
 
 	return axcbc_set_sh_desc(ahash);
@@ -525,7 +525,7 @@ static int acmac_setkey(struct crypto_ah
 	ctx->adata.key_virt = key;
 	ctx->adata.keylen = keylen;
 
-	print_hex_dump_debug("acmac ctx.key@" __stringify(__LINE__)" : ",
+	print_hex_dump_devel("acmac ctx.key@" __stringify(__LINE__)" : ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	return acmac_set_sh_desc(ahash);
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -58,7 +58,7 @@ int gen_split_key(struct device *jrdev,
 
 	dev_dbg(jrdev, "split keylen %d split keylen padded %d\n",
 		adata->keylen, adata->keylen_pad);
-	print_hex_dump_debug("ctx.key@" __stringify(__LINE__)": ",
+	print_hex_dump_devel("ctx.key@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key_in, keylen, 1);
 
 	if (local_max > max_keylen)
@@ -113,7 +113,7 @@ int gen_split_key(struct device *jrdev,
 		wait_for_completion(&result.completion);
 		ret = result.err;
 
-		print_hex_dump_debug("ctx.key@"__stringify(__LINE__)": ",
+		print_hex_dump_devel("ctx.key@"__stringify(__LINE__)": ",
 				     DUMP_PREFIX_ADDRESS, 16, 4, key_out,
 				     adata->keylen_pad, 1);
 	}


