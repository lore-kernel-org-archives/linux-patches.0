Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A06A634F8;
	Tue, 23 Jan 2024 00:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971282; cv=none; b=GQmOWR3BVXpgHN8GcgCCpQlfyrlY40jsWN2PN2eldW6pyqErqwnfwEGqi9JnPZ+Sx5AHK0fwFt5Y/6/+RZfIbrxGeMuWeZORWxk7tdEfWFusPEn+k39h0IrPJq/4oxIoY5jFna1SvvHhlWjsrPklKawrINiwshXK9yi2oDlk+ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971282; c=relaxed/simple;
	bh=zZbNnhP3FYDEEgNy5NzVibh8DtPiFmUTf20fmCFo7GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bk475mliomav8Fxm8dbnoxSUgVFVy2deNq5ox/GQi1wCscxdxjz6YIp/6cXjRx+CAUkR+a6QGgXM10QGOloNCheyKSTF7mVUG9B7/gfqp73uVYsjX3JufMpfSAQKUsqXNHjx0QZ/+ayBplPUaXFUqBtBDvl5MqtWQBETY2mIElM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+6eHK/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+6eHK/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9876AC433C7;
	Tue, 23 Jan 2024 00:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971282;
	bh=zZbNnhP3FYDEEgNy5NzVibh8DtPiFmUTf20fmCFo7GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+6eHK/wlCm+E1M/rfd9PT3SpFz9d4kFUWf+qtemxOT4E+y3nWABjMBPkClgKXdL1
	 cWGy351hzNk/bwGyR4JbSgXFv6vqoBozQXeboiks3Ex8+tx5vhGgbn+hggMi/l/Q+e
	 8t53IgNY8uxfeOV0mlrJchHL7atbF9+Nvicy2Tg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/286] crypto: sahara - avoid skcipher fallback code duplication
Date: Mon, 22 Jan 2024 15:56:44 -0800
Message-ID: <20240122235735.846139559@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3cd872d282b4..b584dd086989 100644
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



