Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E03A3C00BA;
	Thu, 15 Jan 2026 17:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499860; cv=none; b=i3E9o3wYzS7DZtkXMocWVSboAlRpCHJu8d2z5uwb+qD5KsaHGwGILhTCvXK/wt2dwDAanmVPkEJGhkqmJyqUtostlOPEIisNTW8A5f6xI//y5X28HCI6SeOOsbvsrJi7X94EOIUHbSG5ccs9WwyOuvZp2zLfITTsID0hwTw3/xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499860; c=relaxed/simple;
	bh=StqxXvczhjCmXlNKLLjdwwRsfEh6dEhLDjkrKoTrrRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gx/n9U+FSPjCyQITYGloQ9T/uk9z3xGYmvJmMEx9GML9GDoLvHk+Y2RSIVYaUgR1Knn6RhV7A31FxRvapTro1kQZlriv1al5GBYNogn3enarkDHUoldqj5hCqczy7oKy+DYhPJQy/aMxXUvvmwoKHfp9dgGTVlvzD8Ky8AiksJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cvg5xZqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cvg5xZqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A252C116D0;
	Thu, 15 Jan 2026 17:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499859;
	bh=StqxXvczhjCmXlNKLLjdwwRsfEh6dEhLDjkrKoTrrRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cvg5xZqSy3XMQbd3S0O+xUprJIKvJIlxVlOhIOSeBwMiEKYsf/Y4RFPzT6ZHFqaTw
	 hCVtXoq5P6cGHrECljNF9h+Vcq2KvwZYZ/2OGY/eaa0Jg6C3qGJ3Svm/PwBnIjtVqA
	 4pPepeIIDhrbPqJjir8sq0CNcA7DO/Z3Vq4tVnn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivani Agarwal <shivani.agarwal@broadcom.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 373/451] crypto: af_alg - zero initialize memory allocated via sock_kmalloc
Date: Thu, 15 Jan 2026 17:49:34 +0100
Message-ID: <20260115164244.408249302@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
@@ -1127,14 +1127,13 @@ struct af_alg_async_req *af_alg_alloc_ar
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
@@ -423,9 +423,8 @@ static int hash_accept_parent_nokey(void
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


