Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2908E31B118;
	Tue, 16 Dec 2025 11:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886016; cv=none; b=VJIyUhhKJ+PQhyjp3V0HEbUpwe9+1ufTFX4cqeIrFmP+dQHOnD6cMkkqrLDfnaNPC4Zt46Tgg3B6zSr369XGHEsCCnwaphFF9QAVDg/cyxeRSx6+5xquG8r9q3pT28r0lxbRWN74K0zCOVLVvEy1sTQoR0/ySt9p30uQ+HAaqSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886016; c=relaxed/simple;
	bh=Cti7EVLBVE3MqQWMEOIPOG008tHFBXXuJC7KVQgBkO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfKykXUJNt0u0swPIMt9C14a64HRAOxBTbd7fUU4lODW/hTr/2rSjJCf0aIel6N7Wlksz/CwVC/IDdiuf+AAHgdVOyeVkd5tY996AsHL3L+aTbmxnP7X8jzsDqKshkibZZdJht0LYecsUl5C3CRBy0oqYSl2Oe8L4i/tLE+COqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PaNMLx3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PaNMLx3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732BEC4CEF1;
	Tue, 16 Dec 2025 11:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886015;
	bh=Cti7EVLBVE3MqQWMEOIPOG008tHFBXXuJC7KVQgBkO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaNMLx3e9BT+tHqZz9k6c6b5Lcvd1QFodKU0U72RbUJC/e6jhjmrZAuqWHSJAxPAe
	 xeFLNCBEtPUWhzH60se6WAGigQxv9A2kcXbC+Dpj8BKqWrYnF/jnppJdlzop7ZY/bG
	 5t7xX4/UiOpygH22UZGi4DLw7GB4VrqG8nzQZfeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 311/507] crypto: starfive - Correctly handle return of sg_nents_for_len
Date: Tue, 16 Dec 2025 12:12:32 +0100
Message-ID: <20251216111356.736828381@linuxfoundation.org>
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
index 6cfe0238f615f..66a8b04c0a55b 100644
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



