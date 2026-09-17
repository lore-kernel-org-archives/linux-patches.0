Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877473BD64B;
	Thu, 17 Sep 2026 17:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666467; cv=none; b=Nbj/HIzE+bJ8FEWaiA3Crce9/fhevO1Kwru/qYSzF63jw2UPz2NGGB8Vvt8LMyZGNgibTIgIr3S6HBh+K2Rsla24SwBpFMk3Vjit63KrPptOpfw2aO0XuoMf4GOlr3HJu7VU7uTJ/sEiv74VOrXRuJdGxPNy3DOxQcmmgROes8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666467; c=relaxed/simple;
	bh=0+2uyyRMI3JZS466Lf61Y44/erg0XQHAfbwUM3VJCQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdgAMw+L9dzkoUHX7djvL/YOE5fwd1h6BdFv7nx+UtlV+e+4VXCpaOSTK7+UfYLrtiU+k9Jmaxtaw9Zj1zTV0SQxDuNaASOIK0dNbtA8H7HI5hV3gD43Xwm9EQlaq4iX9aT2aUNkTZL80mcREkKzauopIS5qiiwLvoNZ9+dLJj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGcXxg7q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGcXxg7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F93E1F00893;
	Thu, 17 Sep 2026 17:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666464;
	bh=NZzbl5hilKDAU68Mv6FjVD98m9nzflScefRNGVaJ094=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGcXxg7qHUEFBzAyiy2ByXN9/NljlIWAOU3KGkS5MfJLI1HJhZaWP8PyoMVW9rzr+
	 4iGJAW7T9Iu0cIk6H+3Rqa/isussqEAYx1X0ntBbKlUGAuSEhQKZcY2WwzK1MrewxV
	 jP6u/SlhjLsxtjqwvvLdIN4N3ZZpSL5mUTdj0l1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 1046/1250] s390/crypto: Fix handling of EBUSY in PHMAC when req is pushed to crypto engine
Date: Thu, 17 Sep 2026 16:14:01 +0100
Message-ID: <20260917151620.437092570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

commit 330148371401de474b656eaf521861f12ec1a1ce upstream.

When a request is transferred to the engine via
crypto_transfer_hash_request_to_engine() there are two return codes
signaling a successful transfer: EINPROGRESS and EBUSY. However the
correct handling of EBUSY was missing and has been added as a return
code indicating a successful transfer to the crypto engine.

Fixes: cbbc675506cc ("crypto: s390 - New s390 specific protected key hash phmac")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.17+
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/crypto/phmac_s390.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -59,8 +59,10 @@ static inline int hwh_prepare(struct aha
  */
 static inline int hwh_advance(struct hash_walk_helper *hwh, int n)
 {
-	if (n < 0)
+	if (n < 0) {
+		hwh->walkbytes = n;
 		return crypto_hash_walk_done(&hwh->walk, n);
+	}
 
 	hwh->walkbytes -= n;
 	hwh->walkaddr += n;
@@ -597,6 +599,7 @@ static int phmac_update(struct ahash_req
 	struct phmac_tfm_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
 	struct kmac_sha2_ctx *kmac_ctx = &req_ctx->kmac_ctx;
 	struct hash_walk_helper *hwh = &req_ctx->hwh;
+	bool cleanup = true;
 	int rc;
 
 	/* prep the walk in the request context */
@@ -620,12 +623,15 @@ static int phmac_update(struct ahash_req
 		req_ctx->async_op = OP_UPDATE;
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc == -EINPROGRESS || rc == -EBUSY)
+			cleanup = false;
+		else
 			atomic_dec(&tfm_ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS) {
-		hwh_advance(hwh, rc);
+	if (cleanup) {
+		if (hwh->walkbytes > 0)
+			hwh_advance(hwh, rc);
 		memzero_explicit(kmac_ctx, sizeof(*kmac_ctx));
 	}
 
@@ -640,6 +646,7 @@ static int phmac_final(struct ahash_requ
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct phmac_tfm_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
 	struct kmac_sha2_ctx *kmac_ctx = &req_ctx->kmac_ctx;
+	bool cleanup = true;
 	int rc = 0;
 
 	/* Try synchronous operation if no active engine usage */
@@ -658,12 +665,14 @@ static int phmac_final(struct ahash_requ
 		req_ctx->async_op = OP_FINAL;
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc == -EINPROGRESS || rc == -EBUSY)
+			cleanup = false;
+		else
 			atomic_dec(&tfm_ctx->via_engine_ctr);
 	}
 
 out:
-	if (rc != -EINPROGRESS)
+	if (cleanup)
 		memzero_explicit(kmac_ctx, sizeof(*kmac_ctx));
 	pr_debug("rc=%d\n", rc);
 	return rc;
@@ -676,6 +685,7 @@ static int phmac_finup(struct ahash_requ
 	struct phmac_tfm_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
 	struct kmac_sha2_ctx *kmac_ctx = &req_ctx->kmac_ctx;
 	struct hash_walk_helper *hwh = &req_ctx->hwh;
+	bool cleanup = true;
 	int rc;
 
 	/* prep the walk in the request context */
@@ -707,15 +717,17 @@ static int phmac_finup(struct ahash_requ
 		/* req->async_op has been set to either OP_FINUP or OP_FINAL */
 		atomic_inc(&tfm_ctx->via_engine_ctr);
 		rc = crypto_transfer_hash_request_to_engine(phmac_crypto_engine, req);
-		if (rc != -EINPROGRESS)
+		if (rc == -EINPROGRESS || rc == -EBUSY)
+			cleanup = false;
+		else
 			atomic_dec(&tfm_ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS)
+	if (cleanup && hwh->walkbytes > 0)
 		hwh_advance(hwh, rc);
 
 out:
-	if (rc != -EINPROGRESS)
+	if (cleanup)
 		memzero_explicit(kmac_ctx, sizeof(*kmac_ctx));
 	pr_debug("rc=%d\n", rc);
 	return rc;


