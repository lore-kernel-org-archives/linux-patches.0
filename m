Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1FF424D4E;
	Thu, 16 Jul 2026 14:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211226; cv=none; b=Pc5SCDSuxYnvGczfoooy9gGe0K4LtLxqyQVrxbzfn/sAYi0wp4EUTXc5/kkb5XylRwIPt9eJ6VgBoIncHEzQiTjkW/n3BiKPOAovlePr1HMrtXxO1xwJ7JWzkTelIBM37HzksB5M0N1U2vYH7kfsVNELV8EDyJTZbW9TIlIvNtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211226; c=relaxed/simple;
	bh=6JicGn3087OVp/xpmj9sLIwqnh7SJK2FlvSfccRZeUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI88adwI5YjoM2gjEiiWA2ublhSqjEP/lSViNQwT9dqHiHhx5jF8oYYSSAv7mcYYetjpy/GzkzhBSHViRrkKp4GNHPWcu1wAfCi+oRR1kfneZ0AGJLfxKP4UHNvR50hmr5dzlZIQvHCoZAPFy+6CKpIMrhfqPf1JeqrRuJvXS+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peGoTTLX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peGoTTLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924E31F000E9;
	Thu, 16 Jul 2026 14:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211225;
	bh=cblWTdd1R/9zTHnLVnR4F4ISQn4aH1qfd65BcJKGWDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=peGoTTLXF83l+FLfr7A5COrCRdIv7xh2Z7WuB+FNe5Uc440rfvSTBj10yibVHbCFA
	 XUYRls0hGGXK6vrUAXx/RYqEDrqDUiwo2RSbzmZ4OF+IE/1NY5+jkDR7t/vWW2dqhO
	 HYFKTEZD2616xKSWE0S53nSr0yWNJYNXt49V8A8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 347/480] crypto: caam - use print_hex_dump_devel to guard key hex dumps
Date: Thu, 16 Jul 2026 15:31:34 +0200
Message-ID: <20260716133052.314974003@linuxfoundation.org>
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


