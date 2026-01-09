Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E08B31A069;
	Fri,  9 Jan 2026 12:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963091; cv=none; b=QUN66UddpFseHXUmvheXXvMFwRvumPHzLEvaEw1+Yp/hAVE5j7s6tH0Pmi0E3DqoK+GmKFUGvm0H2rMlUou7flgbKcJVjxiZNjioPqfrMGNyQ8E5SRpNZX7Bk324hoScSPtT4kv7zDUfpI0YyeSwKkIlGHAzCxzMDj+VHRnC+MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963091; c=relaxed/simple;
	bh=BxxVOEo27+1QN3iWT/KHOsNC0K7SKLQ7qeqjzjiBTgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDrgdO3Isl6+e3dDQ4FhEBCVywFbTJARPsYKv+DQzfweklBk/bC4Syhfhx2vejQ28CV+zfLrhyCTJelLQrUZY3kUbS5vamqPdZ/e3UFUZyvrdsNil/hxoP6kq7J0ZiLY5zRXpvlwg2MISZDcSOmdByyVCG/sCBZYHoEnWKGySLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdXtoJlF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdXtoJlF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CF7C4CEF1;
	Fri,  9 Jan 2026 12:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963091;
	bh=BxxVOEo27+1QN3iWT/KHOsNC0K7SKLQ7qeqjzjiBTgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdXtoJlFao61/cmpUOPqGLjoclT2RO6NCdwyxZuE1oc4p1wnppmQ6SI0/Dt7yFALo
	 /mVRPnYt7/v0CKMWxZIfIEIIpc3Fqr3Ejn4B9HTTDcY89kjJ85d6CmSH3J5glgA2P4
	 p3LAuUJp+6/JHF37AasABplThmBWmcEPrDHT2fQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivani Agarwal <shivani.agarwal@broadcom.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 562/634] crypto: af_alg - zero initialize memory allocated via sock_kmalloc
Date: Fri,  9 Jan 2026 12:44:00 +0100
Message-ID: <20260109112138.746783509@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivani Agarwal <shivani.agarwal@broadcom.com>

[ Upstream commit 6f6e309328d53a10c0fe1f77dec2db73373179b6 ]

Several crypto user API contexts and requests allocated with
sock_kmalloc() were left uninitialized, relying on callers to
set fields explicitly. This resulted in the use of uninitialized
data in certain error paths or when new fields are added in the
future.

The ACVP patches also contain two user-space interface files:
algif_kpp.c and algif_akcipher.c. These too rely on proper
initialization of their context structures.

A particular issue has been observed with the newly added
'inflight' variable introduced in af_alg_ctx by commit:

  67b164a871af ("crypto: af_alg - Disallow multiple in-flight AIO requests")

Because the context is not memset to zero after allocation,
the inflight variable has contained garbage values. As a result,
af_alg_alloc_areq() has incorrectly returned -EBUSY randomly when
the garbage value was interpreted as true:

  https://github.com/gregkh/linux/blame/master/crypto/af_alg.c#L1209

The check directly tests ctx->inflight without explicitly
comparing against true/false. Since inflight is only ever set to
true or false later, an uninitialized value has triggered
-EBUSY failures. Zero-initializing memory allocated with
sock_kmalloc() ensures inflight and other fields start in a known
state, removing random issues caused by uninitialized data.

Fixes: fe869cdb89c9 ("crypto: algif_hash - User-space interface for hash operations")
Fixes: 5afdfd22e6ba ("crypto: algif_rng - add random number generator support")
Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of duplicate code")
Fixes: 67b164a871af ("crypto: af_alg - Disallow multiple in-flight AIO requests")
Cc: stable@vger.kernel.org
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/af_alg.c     |    5 ++---
 crypto/algif_hash.c |    3 +--
 crypto/algif_rng.c  |    3 +--
 3 files changed, 4 insertions(+), 7 deletions(-)

--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1108,14 +1108,13 @@ struct af_alg_async_req *af_alg_alloc_ar
 	if (unlikely(!areq))
 		return ERR_PTR(-ENOMEM);
 
+	memset(areq, 0, areqlen);
+
 	ctx->inflight = true;
 
 	areq->areqlen = areqlen;
 	areq->sk = sk;
-	areq->last_rsgl = NULL;
 	INIT_LIST_HEAD(&areq->rsgl_list);
-	areq->tsgl = NULL;
-	areq->tsgl_entries = 0;
 
 	return areq;
 }
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -424,9 +424,8 @@ static int hash_accept_parent_nokey(void
 	if (!ctx)
 		return -ENOMEM;
 
-	ctx->result = NULL;
+	memset(ctx, 0, len);
 	ctx->len = len;
-	ctx->more = false;
 	crypto_init_wait(&ctx->wait);
 
 	ask->private = ctx;
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -250,9 +250,8 @@ static int rng_accept_parent(void *priva
 	if (!ctx)
 		return -ENOMEM;
 
+	memset(ctx, 0, len);
 	ctx->len = len;
-	ctx->addtl = NULL;
-	ctx->addtl_len = 0;
 
 	/*
 	 * No seeding done at that point -- if multiple accepts are


