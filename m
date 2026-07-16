Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C64432BEE;
	Thu, 16 Jul 2026 14:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212297; cv=none; b=D8bYFcK5uGWsfZi8K4bDPrbT6O/hfK3Q6O1XkBCgIVLj+6FTzg1Wk992OFFj8kY9gjoV32B5hAAIDbrj/wCZkwt2dqkRaT+eUXZP6xdebgYeoS5qRcw68aiYJ19KfxJLiwPqqbMgqx1FtuEZtyrdNJbhty0wD6V2d5roM0rfFmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212297; c=relaxed/simple;
	bh=62QwFdJ+/BmVeYK5EGtlIg3xnYRPmwy6KmdQKp1hi6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNY49MDAr9VO9+NImjC5Dr7SA4xWHJZZ24j+watGC2LHvdXJBmVo4PX2mhpM1Ey8snULdky4Q00sDUz3u5/7mVP57srM3eZ4MKkwzLWkXMdyPlW3LBCr6F2Y4/l5I9NQqEnvhXUwXbf+UvxZzmzJVwyJ4Dsmg2sw2dr6UkKehSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqEECALL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqEECALL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D6A1F000E9;
	Thu, 16 Jul 2026 14:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212295;
	bh=+HdXJExjSmc942s0C24E0ntE+WDRmfmUU+KoL2Z9YEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uqEECALLqRu7RK8/oSiQnAtpHloSMS4o7FLluexyuN5D+eHU2moJM61IbFEsQ9cYl
	 C22+liFoykbju6O1Ml3RS9+pKRz00vBCeU9Z+YJQKy5Fo7egZJwbRRlweNcVDjfpet
	 GjD8aQwh/b/OgR1sh4dgnldBrDKg+mVWxGae5HvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 272/349] crypto: caam - use print_hex_dump_devel to guard key hex dumps again
Date: Thu, 16 Jul 2026 15:33:26 +0200
Message-ID: <20260716133039.423209755@linuxfoundation.org>
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
@@ -299,7 +299,7 @@ static int aead_setkey(struct crypto_aea
 	dev_dbg(dev, "keylen %d enckeylen %d authkeylen %d\n",
 		keys.authkeylen + keys.enckeylen, keys.enckeylen,
 		keys.authkeylen);
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	ctx->adata.keylen = keys.authkeylen;
@@ -313,7 +313,7 @@ static int aead_setkey(struct crypto_aea
 	memcpy(ctx->key + ctx->adata.keylen_pad, keys.enckey, keys.enckeylen);
 	dma_sync_single_for_device(dev, ctx->key_dma, ctx->adata.keylen_pad +
 				   keys.enckeylen, ctx->dir);
-	print_hex_dump_debug("ctx.key@" __stringify(__LINE__)": ",
+	print_hex_dump_devel("ctx.key@" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, ctx->key,
 			     ctx->adata.keylen_pad + keys.enckeylen, 1);
 
@@ -730,7 +730,7 @@ static int gcm_setkey(struct crypto_aead
 	ret = aes_check_keylen(keylen);
 	if (ret)
 		return ret;
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -826,7 +826,7 @@ static int rfc4106_setkey(struct crypto_
 	if (ret)
 		return ret;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -925,7 +925,7 @@ static int rfc4543_setkey(struct crypto_
 	if (ret)
 		return ret;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	memcpy(ctx->key, key, keylen);
@@ -953,7 +953,7 @@ static int skcipher_setkey(struct crypto
 	u32 *desc;
 	const bool is_rfc3686 = alg->caam.rfc3686;
 
-	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
+	print_hex_dump_devel("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 
 	ctx->cdata.keylen = keylen;


