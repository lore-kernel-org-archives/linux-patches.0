Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B2373451;
	Tue, 11 Nov 2025 00:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822179; cv=none; b=JXkU3aNMJqfCepNZwmcbsQRQ1KjRR0ToxRMGF7YOczdcQFNwfpGX9HOoLdnsudR65CeBvaswmuyhOnLE6gRKoHf1xmLohrXqz8nxeQIeo7H0SlKyYHvKf87671BOQjBcGz8EmchEOS2X3H/eID3MLnaeH1ohanO1UWamvYwdP6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822179; c=relaxed/simple;
	bh=GCqqWKKniQq3Evh1X7Odd8nyOJ2hXxvn6Hur8wj3e50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnfj7KuXPmBUsjbS90yRAoV0TG3pGGwM5Sd0wO6mM4bjO6KIbuEhKzmJDtosW6uVhb3+n4JtCd3tdl1tyZ4Mey28plqUD7kd9bbQLhdvNM9EFnqUehl1fB54ccGdnFYJAwD0MJZDhXDovUPAvGcLKnI1xszp3KsALsngr4dfoIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AeEdYBZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AeEdYBZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB198C16AAE;
	Tue, 11 Nov 2025 00:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822179;
	bh=GCqqWKKniQq3Evh1X7Odd8nyOJ2hXxvn6Hur8wj3e50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AeEdYBZ6tbakrqUrw2oOyq8G1PT3rQ/ozBMAhg9voMU+MQj27rYJ1KhptK6373+Ib
	 /qAEPXvejFnAXsqM7FEC+eT14VXB4i1rG7ZePPoYJbRCtz/zfELlTUlvxgC649/0Mw
	 0tHBDcrU/pUv6KOZrxu7nO2DOpcOjMOY0dunMy+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 048/849] crypto: s390/phmac - Do not modify the req->nbytes value
Date: Tue, 11 Nov 2025 09:33:38 +0900
Message-ID: <20251111004537.598680936@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 3ac2939bc4341ac28700a2ed0c345ba7e7bdb6fd ]

The phmac implementation used the req->nbytes field on combined
operations (finup, digest) to track the state:
with req->nbytes > 0 the update needs to be processed,
while req->nbytes == 0 means to do the final operation. For
this purpose the req->nbytes field was set to 0 after successful
update operation. However, aead uses the req->nbytes field after a
successful hash operation to determine the amount of data to
en/decrypt. So an implementation must not modify the nbytes field.

Fixed by a slight rework on the phmac implementation. There is
now a new field async_op in the request context which tracks
the (asynch) operation to process. So the 'state' via req->nbytes
is not needed any more and now this field is untouched and may
be evaluated even after a request is processed by the phmac
implementation.

Fixes: cbbc675506cc ("crypto: s390 - New s390 specific protected key hash phmac")
Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Tested-by: Ingo Franzki <ifranzki@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/phmac_s390.c | 52 +++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index 7ecfdc4fba2d0..89f3e6d8fd897 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -169,11 +169,18 @@ struct kmac_sha2_ctx {
 	u64 buflen[2];
 };
 
+enum async_op {
+	OP_NOP = 0,
+	OP_UPDATE,
+	OP_FINAL,
+	OP_FINUP,
+};
+
 /* phmac request context */
 struct phmac_req_ctx {
 	struct hash_walk_helper hwh;
 	struct kmac_sha2_ctx kmac_ctx;
-	bool final;
+	enum async_op async_op;
 };
 
 /*
@@ -610,6 +617,7 @@ static int phmac_update(struct ahash_request *req)
 	 * using engine to serialize requests.
 	 */
 	if (rc == 0 || rc == -EKEYEXPIRED) {
+		req_ctx->async_op = OP_UPDATE;
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
 		if (rc != -EINPROGRESS)
@@ -647,8 +655,7 @@ static int phmac_final(struct ahash_request *req)
 	 * using engine to serialize requests.
 	 */
 	if (rc == 0 || rc == -EKEYEXPIRED) {
-		req->nbytes = 0;
-		req_ctx->final = true;
+		req_ctx->async_op = OP_FINAL;
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
 		if (rc != -EINPROGRESS)
@@ -676,13 +683,16 @@ static int phmac_finup(struct ahash_request *req)
 	if (rc)
 		goto out;
 
+	req_ctx->async_op = OP_FINUP;
+
 	/* Try synchronous operations if no active engine usage */
 	if (!atomic_read(&tfm_ctx->via_engine_ctr)) {
 		rc = phmac_kmac_update(req, false);
 		if (rc == 0)
-			req->nbytes = 0;
+			req_ctx->async_op = OP_FINAL;
 	}
-	if (!rc && !req->nbytes && !atomic_read(&tfm_ctx->via_engine_ctr)) {
+	if (!rc && req_ctx->async_op == OP_FINAL &&
+	    !atomic_read(&tfm_ctx->via_engine_ctr)) {
 		rc = phmac_kmac_final(req, false);
 		if (rc == 0)
 			goto out;
@@ -694,7 +704,7 @@ static int phmac_finup(struct ahash_request *req)
 	 * using engine to serialize requests.
 	 */
 	if (rc == 0 || rc == -EKEYEXPIRED) {
-		req_ctx->final = true;
+		/* req->async_op has been set to either OP_FINUP or OP_FINAL */
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
 		if (rc != -EINPROGRESS)
@@ -855,15 +865,16 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 
 	/*
 	 * Three kinds of requests come in here:
-	 * update when req->nbytes > 0 and req_ctx->final is false
-	 * final when req->nbytes = 0 and req_ctx->final is true
-	 * finup when req->nbytes > 0 and req_ctx->final is true
-	 * For update and finup the hwh walk needs to be prepared and
-	 * up to date but the actual nr of bytes in req->nbytes may be
-	 * any non zero number. For final there is no hwh walk needed.
+	 * 1. req->async_op == OP_UPDATE with req->nbytes > 0
+	 * 2. req->async_op == OP_FINUP with req->nbytes > 0
+	 * 3. req->async_op == OP_FINAL
+	 * For update and finup the hwh walk has already been prepared
+	 * by the caller. For final there is no hwh walk needed.
 	 */
 
-	if (req->nbytes) {
+	switch (req_ctx->async_op) {
+	case OP_UPDATE:
+	case OP_FINUP:
 		rc = phmac_kmac_update(req, true);
 		if (rc == -EKEYEXPIRED) {
 			/*
@@ -880,10 +891,11 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 			hwh_advance(hwh, rc);
 			goto out;
 		}
-		req->nbytes = 0;
-	}
-
-	if (req_ctx->final) {
+		if (req_ctx->async_op == OP_UPDATE)
+			break;
+		req_ctx->async_op = OP_FINAL;
+		fallthrough;
+	case OP_FINAL:
 		rc = phmac_kmac_final(req, true);
 		if (rc == -EKEYEXPIRED) {
 			/*
@@ -897,10 +909,14 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 			cond_resched();
 			return -ENOSPC;
 		}
+		break;
+	default:
+		/* unknown/unsupported/unimplemented asynch op */
+		return -EOPNOTSUPP;
 	}
 
 out:
-	if (rc || req_ctx->final)
+	if (rc || req_ctx->async_op == OP_FINAL)
 		memzero_explicit(kmac_ctx, sizeof(*kmac_ctx));
 	pr_debug("request complete with rc=%d\n", rc);
 	local_bh_disable();
-- 
2.51.0



