Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF23433BCA;
	Tue, 21 Jul 2026 22:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671225; cv=none; b=Dj5GWaUNxV4PoMfC4brYMOL8SzQ0ou0MwjE4QM4A2gGPyd5dV4DR1/KEL23QEOU/6BViF2L1/SXoz5vUc0xL3Kx5Slct3dpQxdGKyzdNlREB9c5hZfryI+Pq3qlFe/Bgq7BShydL4fQ9nHRAL5no93y0cPZBTv+tbpocFv4Mvj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671225; c=relaxed/simple;
	bh=AuzLgSWe+yvkAqrZRZX8/Fd66hxgvOyQD0OjIB/z8fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTiQdCCbMFMcyd0NDO4vOzfcvnNaxlH2YGzr8IJcGt09rzsyomtbaiEPYEBxXOzkd5ePRXpqr82RsulU3Hz7ujrZEC04Sjoqzrzlh9lw+p2fVSkCgKwHdhj7+gRbiJ406mbRMGtQCnM4awtd/S0agoWkG1LOied2vYFwH7bylv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGnhqkSS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGnhqkSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060A51F000E9;
	Tue, 21 Jul 2026 22:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671223;
	bh=OlVuA6FnzmZxEtvokEBV4wAsajyr1Xl0AnJAtxzgXpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zGnhqkSSWbDGqXflScddzsYDYgDb0h5hrMiLFn08ARvKyTCmWAx+2U0Lv70RRYvQE
	 /Pp9rSHZD7Sf+JPHa900sFNmjl38kmpIu+Fp8LfE+2DHYMxUiZKiTnYF+DpFOwgUqx
	 8iN4wAA8RefH0bteA9LW0mhSOzkfBWibLCwC2DgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 164/843] crypto: caam - use print_hex_dump_devel to guard key hex dumps again
Date: Tue, 21 Jul 2026 17:16:39 +0200
Message-ID: <20260721152409.705567164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 8005dc808bcce7d6cc2ae015a3cde1683bee602d upstream.

Use print_hex_dump_devel() for dumping sensitive key material in
*_setkey() to avoid leaking secrets at runtime when CONFIG_DYNAMIC_DEBUG
is enabled.

Fixes: 8d818c105501 ("crypto: caam/qi2 - add DPAA2-CAAM driver")
Fixes: 226853ac3ebe ("crypto: caam/qi2 - add skcipher algorithms")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/caam/caamalg_qi2.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -297,7 +297,7 @@ static int aead_setkey(struct crypto_aea
 	dev_dbg(dev, "keylen %d enckeylen %d authkeylen %d\n",
 		keys.authkeylen + keys.enckeylen, keys.enckeylen,
 		keys.authkeylen);
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	ctx->adata.keylen = keys.authkeylen;
@@ -311,7 +311,7 @@ static int aead_setkey(struct crypto_aea
 	memcpy(ctx->key + ctx->adata.keylen_pad, keys.enckey, keys.enckeylen);
 	dma_sync_single_for_device(dev, ctx->key_dma, ctx->adata.keylen_pad +
 				   keys.enckeylen, ctx->dir);
-	print_hex_dump_debug("ctx.key@" __stringify(__LINE__)": ",
+	print_hex_dump_devel("ctx.key@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, ctx->key,
 			     ctx->adata.keylen_pad + keys.enckeylen, 1);
 
@@ -728,7 +728,7 @@ static int gcm_setkey(struct crypto_aead
 	ret = aes_check_keylen(keylen);
 	if (ret)
 		return ret;
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -824,7 +824,7 @@ static int rfc4106_setkey(struct crypto_
 	if (ret)
 		return ret;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -923,7 +923,7 @@ static int rfc4543_setkey(struct crypto_
 	if (ret)
 		return ret;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -951,7 +951,7 @@ static int skcipher_setkey(struct crypto
 	u32 *desc;
 	const bool is_rfc3686 = alg->caam.rfc3686;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	ctx->cdata.keylen = keylen;


