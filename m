Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CF72E54AA;
	Tue, 16 Dec 2025 11:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884545; cv=none; b=PYDESC13thhG6YDZxaMyj+2azxKjP82jLp7nF0EpZ3kBugFZ5rMMusy5SQ4mqpJiuVYCxY8DE2a7i4p2YRIfWV7ElqNVbK2spBgDmkqE05HFCnlT7ur+ifh0vuITphnzYmzod+lnMtDTo1Dq8PbfFOj8m2BK6gSXQQeW11Vav2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884545; c=relaxed/simple;
	bh=JTBnZmwqCGMqdHTy5IJjV3iu9DYyTWN8FKJcHJ9SQ/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eakQ/o3WSjhxXP0nh4Dn/Cue+dCu7db4hKKUJCFCRSmQf3ZVGJdL3yAXKDsUFqzyckFAoolkK8rd08ewwiEg6clXEHR6ZOlDWf9LMgAUNVbfw6bvNelVD8jVtO9t+i3bHc/xKJ86L8l2VwzZznn1VowddmdtCY9zTAdnnT3rsgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZBvtdNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZBvtdNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9AAC4CEF1;
	Tue, 16 Dec 2025 11:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884544;
	bh=JTBnZmwqCGMqdHTy5IJjV3iu9DYyTWN8FKJcHJ9SQ/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZBvtdNnXtOs3IJwhD96nAlEre8G43PUUzqTJqv2bYN2hp7M8Wt46Q04cYnQ4vTMr
	 CbwVlU4Xbx37FHzPbzbnAY4BzYmXWiA05iAaw1rShETLDem76ciN9P/hIssxA/MKlc
	 TWUJX4TnHEsjJhOC9VkxRRXpcR/c7Ad4xh96M7CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/354] crypto: starfive - Correctly handle return of sg_nents_for_len
Date: Tue, 16 Dec 2025 12:12:56 +0100
Message-ID: <20251216111328.493308068@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit e9eb52037a529fbb307c290e9951a62dd728b03d ]

The return value of sg_nents_for_len was assigned to an unsigned long
in starfive_hash_digest, causing negative error codes to be converted
to large positive integers.

Add error checking for sg_nents_for_len and return immediately on
failure to prevent potential buffer overflows.

Fixes: 7883d1b28a2b ("crypto: starfive - Add hash and HMAC support")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/starfive/jh7110-hash.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/starfive/jh7110-hash.c b/drivers/crypto/starfive/jh7110-hash.c
index 2c60a1047bc39..c0b09ca1cc2ed 100644
--- a/drivers/crypto/starfive/jh7110-hash.c
+++ b/drivers/crypto/starfive/jh7110-hash.c
@@ -326,6 +326,7 @@ static int starfive_hash_digest(struct ahash_request *req)
 	struct starfive_cryp_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct starfive_cryp_request_ctx *rctx = ahash_request_ctx(req);
 	struct starfive_cryp_dev *cryp = ctx->cryp;
+	int sg_len;
 
 	memset(rctx, 0, sizeof(struct starfive_cryp_request_ctx));
 
@@ -334,7 +335,10 @@ static int starfive_hash_digest(struct ahash_request *req)
 	rctx->in_sg = req->src;
 	rctx->blksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 	rctx->digsize = crypto_ahash_digestsize(tfm);
-	rctx->in_sg_len = sg_nents_for_len(rctx->in_sg, rctx->total);
+	sg_len = sg_nents_for_len(rctx->in_sg, rctx->total);
+	if (sg_len < 0)
+		return sg_len;
+	rctx->in_sg_len = sg_len;
 	ctx->rctx = rctx;
 
 	return crypto_transfer_hash_request_to_engine(cryp->engine, req);
-- 
2.51.0



