Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC05F40EB9B;
	Thu, 16 Jul 2026 14:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211228; cv=none; b=UMaQG8ieHrFCbkYyPEm4hVDoeFFtDnGOEze55CAERK8BQ1jzfEZc2rXIkajVEgVnUoC/LgRNoeG/5x0pxEYXpqY83cx/BdRhrfrZgVu0Y4lEp8Ql1tT/DcCmhxuwSNynrgbcPgfulKAvcL41pbqAbD8MhnoqWt7XWcX7R6VR48I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211228; c=relaxed/simple;
	bh=VEZXHnj4eYHGvxYtEYrLbJL9AWVXAAgDYaZrBl0M3AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZsC4dExuYb/PnmSTzQcs0Tb6AiWjAU5W2xJkJGlV5HNwCrxwO38EpoJH36H5re8zxcTAH3D+ItDgfE5Kxo3TvCFue4+NBVwUGPC9QMxSXKLtIZpbFU2OE+eKtbXsPvN4jSXcZ2Rb7V2vFyRllqnS0lkii84kkaiZttvCIgFrE1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joKv/Vnk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joKv/Vnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C60F1F000E9;
	Thu, 16 Jul 2026 14:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211227;
	bh=s7lmLBftppjFOx150rRAo1eGVBRLl+NyCLz9C9y64v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=joKv/Vnkr4gpRwAhGg13jw28PK6Lc7j3XkgW1n/GFfPW5sR2CKlThzohz7xMZu91b
	 vppkD0bhjdeFQwGBpSGDkgwXhFV7rO791Elam0teGYVvhffb4L+Ev3EXyhGLAttk+k
	 M5wRn/LLmsUu9lxq3dBlnADzAiuTaHjNNHVm8KyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 348/480] crypto: caam - use print_hex_dump_devel to guard key hex dumps again
Date: Thu, 16 Jul 2026 15:31:35 +0200
Message-ID: <20260716133052.335857057@linuxfoundation.org>
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
@@ -300,7 +300,7 @@ static int aead_setkey(struct crypto_aea
 	dev_dbg(dev, "keylen %d enckeylen %d authkeylen %d\n",
 		keys.authkeylen + keys.enckeylen, keys.enckeylen,
 		keys.authkeylen);
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	ctx->adata.keylen = keys.authkeylen;
@@ -314,7 +314,7 @@ static int aead_setkey(struct crypto_aea
 	memcpy(ctx->key + ctx->adata.keylen_pad, keys.enckey, keys.enckeylen);
 	dma_sync_single_for_device(dev, ctx->key_dma, ctx->adata.keylen_pad +
 				   keys.enckeylen, ctx->dir);
-	print_hex_dump_debug("ctx.key@" __stringify(__LINE__)": ",
+	print_hex_dump_devel("ctx.key@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, ctx->key,
 			     ctx->adata.keylen_pad + keys.enckeylen, 1);
 
@@ -731,7 +731,7 @@ static int gcm_setkey(struct crypto_aead
 	ret = aes_check_keylen(keylen);
 	if (ret)
 		return ret;
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -827,7 +827,7 @@ static int rfc4106_setkey(struct crypto_
 	if (ret)
 		return ret;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -926,7 +926,7 @@ static int rfc4543_setkey(struct crypto_
 	if (ret)
 		return ret;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -954,7 +954,7 @@ static int skcipher_setkey(struct crypto
 	u32 *desc;
 	const bool is_rfc3686 = alg->caam.rfc3686;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	ctx->cdata.keylen = keylen;


