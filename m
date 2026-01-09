Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C0032BF21;
	Fri,  9 Jan 2026 11:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959848; cv=none; b=iLSjAXoVS0/FPMabk9CDbId2CgHlJrMDrqcsw3PoTo/G4hA/nqI5babFqJWTlSs7MFFTbO/Cq+DJdo64Ua0suJaF07Smfwj/EIfdURPyClfNESsAintjSiAjc1yIhsIEDugpdRNhbSa4wAPsP1ExDSideLtHR2xKq5SyvRETHL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959848; c=relaxed/simple;
	bh=jpiuCV6q58LshJ0tBhHSPQK4YT9ahIOC8EaoLJay6oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BG3hQVYd2ABYKAjYtwLkMcmhohawgXmM5YQZH5qthfxirZmyqb0v1faRnrgprjomkHOjtxrpyA+dJY7FLc3Ieq0vyj6BgYKWKCLIpcSRmhXxFGYCXeslSGaFasdYNkaNQVrwO8tZu+Ne+qm6as52h7ugIxsqWzh/AFejmjk1FAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2jXhECP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2jXhECP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B02C4CEF1;
	Fri,  9 Jan 2026 11:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959848;
	bh=jpiuCV6q58LshJ0tBhHSPQK4YT9ahIOC8EaoLJay6oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2jXhECPCFa2Wx6MruIWA3xMKRwFZy5mGik4SifNA3sufrYL+wCUQ2ClYUKB7uk3H
	 e1j778zwj9oP0kxLWFHqqXUewfnrBnDK5f7Gw6MSECzO3/Zib0JMnoNXKVsuDcBynO
	 8XqtSGl9kK3Respt7VGsm4/vbC20D6ElZ9VFDahk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/737] crypto: starfive - Correctly handle return of sg_nents_for_len
Date: Fri,  9 Jan 2026 12:35:35 +0100
Message-ID: <20260109112141.376171708@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cc7650198d703..e973e73f866ba 100644
--- a/drivers/crypto/starfive/jh7110-hash.c
+++ b/drivers/crypto/starfive/jh7110-hash.c
@@ -358,6 +358,7 @@ static int starfive_hash_digest(struct ahash_request *req)
 	struct starfive_cryp_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct starfive_cryp_request_ctx *rctx = ahash_request_ctx(req);
 	struct starfive_cryp_dev *cryp = ctx->cryp;
+	int sg_len;
 
 	memset(rctx, 0, sizeof(struct starfive_cryp_request_ctx));
 
@@ -366,7 +367,10 @@ static int starfive_hash_digest(struct ahash_request *req)
 	rctx->in_sg = req->src;
 	rctx->blksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 	rctx->digsize = crypto_ahash_digestsize(tfm);
-	rctx->in_sg_len = sg_nents_for_len(rctx->in_sg, rctx->total);
+	sg_len = sg_nents_for_len(rctx->in_sg, rctx->total);
+	if (sg_len < 0)
+		return sg_len;
+	rctx->in_sg_len = sg_len;
 	ctx->rctx = rctx;
 
 	if (starfive_hash_check_aligned(rctx->in_sg, rctx->total, rctx->blksize))
-- 
2.51.0



