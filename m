Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1511487F4;
	Tue, 23 Jan 2024 00:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969176; cv=none; b=ESOxErEdazTSaQeUbLJYiSWqLYjXC6UGIP5Z+6uxGTXdL0Ys2U9sR0NVaq0COfvM8uMX7sdJ10w2wKjaPQqvLCUBmSYpwf60g73RIv649Z5sC5hQ+MkbC0I73FFl/Bs+sJBIsxprwSpHlwipMGS9/A662KEG6XEGYrQqBg+NZaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969176; c=relaxed/simple;
	bh=fw+hP5UybeKaB64kc+M0uDVRBzJd18bBJqK9gGhHJy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqYVC2Z0I0suX03jDM+J9PkxNKQXVLqcaMKKlNPXvDpLYbk1IdN/cAVreAao3S+ukoz0j8mZsN8PYsxlirOb/Eyt4KlbdIcpH2B+tdCpyoooLsDTqU7xM0V+TAY1dar6IShFp15ineJilA3uABMLMxZRL1m+vPCWKsYiPOVae8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4EIqdmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4EIqdmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DF6C433C7;
	Tue, 23 Jan 2024 00:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969176;
	bh=fw+hP5UybeKaB64kc+M0uDVRBzJd18bBJqK9gGhHJy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4EIqdmPiqpsrcUSGQoyWas0yKPjJqOdcdoZEWYVia+u1dbonxVCJkCbMJd2SJS5q
	 2fNX+2LfQm8rqlcmgXzaVpuQ5z5ZqHlw17QmWZXu+SFLzzmI2GqAm7Egex065VN+wt
	 IfnI2gFpPhGQEB81F919cHCUV192EXt5omHSWWjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 075/641] crypto: sahara - avoid skcipher fallback code duplication
Date: Mon, 22 Jan 2024 15:49:39 -0800
Message-ID: <20240122235820.380820864@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit 01d70a4bbff20ea05cadb4c208841985a7cc6596 ]

Factor out duplicated skcipher fallback handling code to a helper function
sahara_aes_fallback(). Also, keep a single check if fallback is required in
sahara_aes_crypt().

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: d1d6351e37aa ("crypto: sahara - handle zero-length aes requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 85 ++++++++++++-----------------------------
 1 file changed, 25 insertions(+), 60 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index c4eb66d2e08d..0771c7160c47 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -648,12 +648,37 @@ static int sahara_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	return crypto_skcipher_setkey(ctx->fallback, key, keylen);
 }
 
+static int sahara_aes_fallback(struct skcipher_request *req, unsigned long mode)
+{
+	struct sahara_aes_reqctx *rctx = skcipher_request_ctx(req);
+	struct sahara_ctx *ctx = crypto_skcipher_ctx(
+		crypto_skcipher_reqtfm(req));
+
+	skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
+	skcipher_request_set_callback(&rctx->fallback_req,
+				      req->base.flags,
+				      req->base.complete,
+				      req->base.data);
+	skcipher_request_set_crypt(&rctx->fallback_req, req->src,
+				   req->dst, req->cryptlen, req->iv);
+
+	if (mode & FLAGS_ENCRYPT)
+		return crypto_skcipher_encrypt(&rctx->fallback_req);
+
+	return crypto_skcipher_decrypt(&rctx->fallback_req);
+}
+
 static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 {
 	struct sahara_aes_reqctx *rctx = skcipher_request_ctx(req);
+	struct sahara_ctx *ctx = crypto_skcipher_ctx(
+		crypto_skcipher_reqtfm(req));
 	struct sahara_dev *dev = dev_ptr;
 	int err = 0;
 
+	if (unlikely(ctx->keylen != AES_KEYSIZE_128))
+		return sahara_aes_fallback(req, mode);
+
 	dev_dbg(dev->device, "nbytes: %d, enc: %d, cbc: %d\n",
 		req->cryptlen, !!(mode & FLAGS_ENCRYPT), !!(mode & FLAGS_CBC));
 
@@ -676,81 +701,21 @@ static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 
 static int sahara_aes_ecb_encrypt(struct skcipher_request *req)
 {
-	struct sahara_aes_reqctx *rctx = skcipher_request_ctx(req);
-	struct sahara_ctx *ctx = crypto_skcipher_ctx(
-		crypto_skcipher_reqtfm(req));
-
-	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-		skcipher_request_set_callback(&rctx->fallback_req,
-					      req->base.flags,
-					      req->base.complete,
-					      req->base.data);
-		skcipher_request_set_crypt(&rctx->fallback_req, req->src,
-					   req->dst, req->cryptlen, req->iv);
-		return crypto_skcipher_encrypt(&rctx->fallback_req);
-	}
-
 	return sahara_aes_crypt(req, FLAGS_ENCRYPT);
 }
 
 static int sahara_aes_ecb_decrypt(struct skcipher_request *req)
 {
-	struct sahara_aes_reqctx *rctx = skcipher_request_ctx(req);
-	struct sahara_ctx *ctx = crypto_skcipher_ctx(
-		crypto_skcipher_reqtfm(req));
-
-	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-		skcipher_request_set_callback(&rctx->fallback_req,
-					      req->base.flags,
-					      req->base.complete,
-					      req->base.data);
-		skcipher_request_set_crypt(&rctx->fallback_req, req->src,
-					   req->dst, req->cryptlen, req->iv);
-		return crypto_skcipher_decrypt(&rctx->fallback_req);
-	}
-
 	return sahara_aes_crypt(req, 0);
 }
 
 static int sahara_aes_cbc_encrypt(struct skcipher_request *req)
 {
-	struct sahara_aes_reqctx *rctx = skcipher_request_ctx(req);
-	struct sahara_ctx *ctx = crypto_skcipher_ctx(
-		crypto_skcipher_reqtfm(req));
-
-	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-		skcipher_request_set_callback(&rctx->fallback_req,
-					      req->base.flags,
-					      req->base.complete,
-					      req->base.data);
-		skcipher_request_set_crypt(&rctx->fallback_req, req->src,
-					   req->dst, req->cryptlen, req->iv);
-		return crypto_skcipher_encrypt(&rctx->fallback_req);
-	}
-
 	return sahara_aes_crypt(req, FLAGS_ENCRYPT | FLAGS_CBC);
 }
 
 static int sahara_aes_cbc_decrypt(struct skcipher_request *req)
 {
-	struct sahara_aes_reqctx *rctx = skcipher_request_ctx(req);
-	struct sahara_ctx *ctx = crypto_skcipher_ctx(
-		crypto_skcipher_reqtfm(req));
-
-	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-		skcipher_request_set_callback(&rctx->fallback_req,
-					      req->base.flags,
-					      req->base.complete,
-					      req->base.data);
-		skcipher_request_set_crypt(&rctx->fallback_req, req->src,
-					   req->dst, req->cryptlen, req->iv);
-		return crypto_skcipher_decrypt(&rctx->fallback_req);
-	}
-
 	return sahara_aes_crypt(req, FLAGS_CBC);
 }
 
-- 
2.43.0



