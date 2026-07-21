Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA7644AB9F;
	Tue, 21 Jul 2026 22:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673363; cv=none; b=KV9do9guIXKNw4j0RKXqSJ6BMh1dZ4X8xzDT2jJgz7bJlvTmpRb2RWIaIzZehF0VmWXRYXlg06MEO46kAJm891f3vwBR8IH4V7qD02G4KEK4lckUoYoD44PjXOGB8GeBd5W/GIjeQ7lMZ+cIGe5g/1e/KUaUOktYAR8fJRF7OhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673363; c=relaxed/simple;
	bh=ysi7Jm95/SPQp4zYb1yhopKX6y4YulMZOXCntf58+Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gs6pdksaWHL0/XxyOc4RPfkH4KvVNP0DyuXmTMfYx3Y3NZnU6hFS8kwoBcD58J6DzgOf/5P1FZxGNKUn/pwTSdcN0BriBWthvKl1//gbHij60GZKZfrOi3AqCqu+H54jvI7nd7Fg54G2N8UOBmlOmCVnPCR14Sxx2p3Kl7w1Kp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1LtBGzz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1LtBGzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4C41F000E9;
	Tue, 21 Jul 2026 22:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673362;
	bh=1R5mpK4CRNxNSAqEAszz8aZhKQgvyu99zOX7qajy3FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y1LtBGzzTKfysbSmbywlPL5AfwaaASAuRmiAbyrt0aLD/0PJYfcuRMbnDapQ1sQgk
	 3yXOIogvABdf8CiwmMEApDI1zDPXElb1cUkM5Dp/XjcD73uFL+pqkkzpRR8zUKcl2D
	 cQoJEMZZBHbM8PKtJWJiZDeKWm92MgVVaBKETie4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 127/699] crypto: caam - use print_hex_dump_devel to guard key hex dumps
Date: Tue, 21 Jul 2026 17:18:06 +0200
Message-ID: <20260721152358.571398074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -588,7 +588,7 @@ static int aead_setkey(struct crypto_aea
 	dev_dbg(jrdev, "keylen %d enckeylen %d authkeylen %d\n",
 	       keys.authkeylen + keys.enckeylen, keys.enckeylen,
 	       keys.authkeylen);
-	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	/*
@@ -624,7 +624,7 @@ static int aead_setkey(struct crypto_aea
 	dma_sync_single_for_device(jrdev, ctx->key_dma, ctx->adata.keylen_pad +
 				   keys.enckeylen, ctx->dir);
 
-	print_hex_dump_debug("ctx.key@"__stringify(__LINE__)": ",
+	print_hex_dump_devel("ctx.key@"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, ctx->key,
 			     ctx->adata.keylen_pad + keys.enckeylen, 1);
 
@@ -665,7 +665,7 @@ static int gcm_setkey(struct crypto_aead
 	if (err)
 		return err;
 
-	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -686,7 +686,7 @@ static int rfc4106_setkey(struct crypto_
 	if (err)
 		return err;
 
-	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -712,7 +712,7 @@ static int rfc4543_setkey(struct crypto_
 	if (err)
 		return err;
 
-	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -739,7 +739,7 @@ static int skcipher_setkey(struct crypto
 	u32 *desc;
 	const bool is_rfc3686 = alg->caam.rfc3686;
 
-	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	ctx->cdata.keylen = keylen;
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -207,7 +207,7 @@ static int aead_setkey(struct crypto_aea
 	dev_dbg(jrdev, "keylen %d enckeylen %d authkeylen %d\n",
 		keys.authkeylen + keys.enckeylen, keys.enckeylen,
 		keys.authkeylen);
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	/*
@@ -243,7 +243,7 @@ static int aead_setkey(struct crypto_aea
 				   ctx->adata.keylen_pad + keys.enckeylen,
 				   ctx->dir);
 
-	print_hex_dump_debug("ctx.key@" __stringify(__LINE__)": ",
+	print_hex_dump_devel("ctx.key@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, ctx->key,
 			     ctx->adata.keylen_pad + keys.enckeylen, 1);
 
@@ -366,7 +366,7 @@ static int gcm_setkey(struct crypto_aead
 	if (ret)
 		return ret;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -470,7 +470,7 @@ static int rfc4106_setkey(struct crypto_
 	if (ret)
 		return ret;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -576,7 +576,7 @@ static int rfc4543_setkey(struct crypto_
 	if (ret)
 		return ret;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -626,7 +626,7 @@ static int skcipher_setkey(struct crypto
 	const bool is_rfc3686 = alg->caam.rfc3686;
 	int ret = 0;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	ctx->cdata.keylen = keylen;
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -495,7 +495,7 @@ static int axcbc_setkey(struct crypto_ah
 				   DMA_TO_DEVICE);
 	ctx->adata.keylen = keylen;
 
-	print_hex_dump_debug("axcbc ctx.key@" __stringify(__LINE__)" : ",
+	print_hex_dump_devel("axcbc ctx.key@" __stringify(__LINE__)" : ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, ctx->key, keylen, 1);
 
 	return axcbc_set_sh_desc(ahash);
@@ -515,7 +515,7 @@ static int acmac_setkey(struct crypto_ah
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


