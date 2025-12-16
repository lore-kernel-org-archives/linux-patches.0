Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB93315786;
	Tue, 16 Dec 2025 11:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885131; cv=none; b=pWSJ5gKFwS1ngYHFQKRXaQeRl5ABtOITJ3o2DsYpFUdwLlm5uKJuhlh+r/hwSu4/9sZZGySklr2YOlhBDlOwMHEclIXbdYUWowwTNp/DbcWRTQgmabDFbotIrxKDiPGXnBRVLaQ4ybHvusSNyiGJgvBnjWkYp60wElg0PJdtjf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885131; c=relaxed/simple;
	bh=nDbdmRIdt2Qa7VOoIkHWP64k/XKOMAjwLfHhR2X7Hbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HF/2kKzITScQ+E2U6fGE7QM7uOYDhIc5cHdc9ShVNY/sF2xOBNrv95Uq86L7PDhpgXH0xxuFxbC6vz7Ko9wxJvgag5sONrRdx2fWBn+zEp31JipcvAxE9/i7G1/37iPUJHcagjSnpp1fJeZZO5QmLmNFTw79G+NTofgiGr2VY8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFmN0hfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFmN0hfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D02C4CEF1;
	Tue, 16 Dec 2025 11:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885131;
	bh=nDbdmRIdt2Qa7VOoIkHWP64k/XKOMAjwLfHhR2X7Hbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFmN0hfP9wVCYGHS6IA5CrcFld4H9L1YXHhgd02DnUuzvKBqUg8yk9qPJLdt016nh
	 Ct2gu49JJg1rNb6pTYFNRtw4wvEVmq1u/dWoRlhZdOJJDxBE53PdoTggLTp4Lwqqh5
	 P2mUkZrvsxaUr3awrrdyy1De8EKGZLHuFBYvkCQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 047/507] crypto: authenc - Correctly pass EINPROGRESS back up to the caller
Date: Tue, 16 Dec 2025 12:08:08 +0100
Message-ID: <20251216111347.248210174@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 96feb73def02d175850daa0e7c2c90c876681b5c ]

When authenc is invoked with MAY_BACKLOG, it needs to pass EINPROGRESS
notifications back up to the caller when the underlying algorithm
returns EBUSY synchronously.

However, if the EBUSY comes from the second part of an authenc call,
i.e., it is asynchronous, both the EBUSY and the subsequent EINPROGRESS
notification must not be passed to the caller.

Implement this by passing a mask to the function that starts the
second half of authenc and using it to determine whether EBUSY
and EINPROGRESS should be passed to the caller.

This was a deficiency in the original implementation of authenc
because it was not expected to be used with MAY_BACKLOG.

Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 180ce7e81030 ("crypto: authenc - Add EINPROGRESS check")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/authenc.c | 75 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 25 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index a723769c87779..ac679ce2cb953 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -37,7 +37,7 @@ struct authenc_request_ctx {
 
 static void authenc_request_complete(struct aead_request *req, int err)
 {
-	if (err != -EINPROGRESS)
+	if (err != -EINPROGRESS && err != -EBUSY)
 		aead_request_complete(req, err);
 }
 
@@ -107,27 +107,42 @@ static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 	return err;
 }
 
-static void authenc_geniv_ahash_done(void *data, int err)
+static void authenc_geniv_ahash_finish(struct aead_request *req)
 {
-	struct aead_request *req = data;
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct aead_instance *inst = aead_alg_instance(authenc);
 	struct authenc_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
 
-	if (err)
-		goto out;
-
 	scatterwalk_map_and_copy(ahreq->result, req->dst,
 				 req->assoclen + req->cryptlen,
 				 crypto_aead_authsize(authenc), 1);
+}
 
-out:
+static void authenc_geniv_ahash_done(void *data, int err)
+{
+	struct aead_request *req = data;
+
+	if (!err)
+		authenc_geniv_ahash_finish(req);
 	aead_request_complete(req, err);
 }
 
-static int crypto_authenc_genicv(struct aead_request *req, unsigned int flags)
+/*
+ * Used when the ahash request was invoked in the async callback context
+ * of the previous skcipher request.  Eat any EINPROGRESS notifications.
+ */
+static void authenc_geniv_ahash_done2(void *data, int err)
+{
+	struct aead_request *req = data;
+
+	if (!err)
+		authenc_geniv_ahash_finish(req);
+	authenc_request_complete(req, err);
+}
+
+static int crypto_authenc_genicv(struct aead_request *req, unsigned int mask)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct aead_instance *inst = aead_alg_instance(authenc);
@@ -136,6 +151,7 @@ static int crypto_authenc_genicv(struct aead_request *req, unsigned int flags)
 	struct crypto_ahash *auth = ctx->auth;
 	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
+	unsigned int flags = aead_request_flags(req) & ~mask;
 	u8 *hash = areq_ctx->tail;
 	int err;
 
@@ -143,7 +159,8 @@ static int crypto_authenc_genicv(struct aead_request *req, unsigned int flags)
 	ahash_request_set_crypt(ahreq, req->dst, hash,
 				req->assoclen + req->cryptlen);
 	ahash_request_set_callback(ahreq, flags,
-				   authenc_geniv_ahash_done, req);
+				   mask ? authenc_geniv_ahash_done2 :
+					  authenc_geniv_ahash_done, req);
 
 	err = crypto_ahash_digest(ahreq);
 	if (err)
@@ -159,12 +176,11 @@ static void crypto_authenc_encrypt_done(void *data, int err)
 {
 	struct aead_request *areq = data;
 
-	if (err)
-		goto out;
-
-	err = crypto_authenc_genicv(areq, 0);
-
-out:
+	if (err) {
+		aead_request_complete(areq, err);
+		return;
+	}
+	err = crypto_authenc_genicv(areq, CRYPTO_TFM_REQ_MAY_SLEEP);
 	authenc_request_complete(areq, err);
 }
 
@@ -199,11 +215,18 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 	if (err)
 		return err;
 
-	return crypto_authenc_genicv(req, aead_request_flags(req));
+	return crypto_authenc_genicv(req, 0);
+}
+
+static void authenc_decrypt_tail_done(void *data, int err)
+{
+	struct aead_request *req = data;
+
+	authenc_request_complete(req, err);
 }
 
 static int crypto_authenc_decrypt_tail(struct aead_request *req,
-				       unsigned int flags)
+				       unsigned int mask)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct aead_instance *inst = aead_alg_instance(authenc);
@@ -214,6 +237,7 @@ static int crypto_authenc_decrypt_tail(struct aead_request *req,
 	struct skcipher_request *skreq = (void *)(areq_ctx->tail +
 						  ictx->reqoff);
 	unsigned int authsize = crypto_aead_authsize(authenc);
+	unsigned int flags = aead_request_flags(req) & ~mask;
 	u8 *ihash = ahreq->result + authsize;
 	struct scatterlist *src, *dst;
 
@@ -230,7 +254,9 @@ static int crypto_authenc_decrypt_tail(struct aead_request *req,
 
 	skcipher_request_set_tfm(skreq, ctx->enc);
 	skcipher_request_set_callback(skreq, flags,
-				      req->base.complete, req->base.data);
+				      mask ? authenc_decrypt_tail_done :
+					     req->base.complete,
+				      mask ? req : req->base.data);
 	skcipher_request_set_crypt(skreq, src, dst,
 				   req->cryptlen - authsize, req->iv);
 
@@ -241,12 +267,11 @@ static void authenc_verify_ahash_done(void *data, int err)
 {
 	struct aead_request *req = data;
 
-	if (err)
-		goto out;
-
-	err = crypto_authenc_decrypt_tail(req, 0);
-
-out:
+	if (err) {
+		aead_request_complete(req, err);
+		return;
+	}
+	err = crypto_authenc_decrypt_tail(req, CRYPTO_TFM_REQ_MAY_SLEEP);
 	authenc_request_complete(req, err);
 }
 
@@ -273,7 +298,7 @@ static int crypto_authenc_decrypt(struct aead_request *req)
 	if (err)
 		return err;
 
-	return crypto_authenc_decrypt_tail(req, aead_request_flags(req));
+	return crypto_authenc_decrypt_tail(req, 0);
 }
 
 static int crypto_authenc_init_tfm(struct crypto_aead *tfm)
-- 
2.51.0



