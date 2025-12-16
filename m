Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058A1358D2E;
	Tue, 16 Dec 2025 12:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887899; cv=none; b=qyFLHHQtAE0DK9Mndn9f0Mr1udTPcT7S0IQ4mnxIODw26bwTqLwTMZc/7eQ8UqluFVRzq/9m8L4UWMoXG4Aou/DhColT3i0gw4QtT1s0g0IO7/3YD2/ZjuanuJVJnVxi2wurko8tYYvwPK/HnrenFzuKwo/J8D8qSG01+SOhbPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887899; c=relaxed/simple;
	bh=zDjAOryLjJGEpMvpBjOatdvCOEzzwm81QuJX7gCPGtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7ekZiHgMvDpuVxvB9YInd/nIYpQDAjM/uEpFQGtjpFtFmDP34/po1JbefLzUGg7JfmrA5/qzGoV95akr7CEh/vN4ha6IP2N2/DGNAuEJ5T2cbzD+lHDQAfzHz97HJztFuXO2YJPlxuRbkXpWIFyyo+KEg9LA46i1Em0wK7RbgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6lezpMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6lezpMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6847EC4CEF1;
	Tue, 16 Dec 2025 12:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887898;
	bh=zDjAOryLjJGEpMvpBjOatdvCOEzzwm81QuJX7gCPGtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6lezpMJuIIaNlHEcc6hctq1rCbEobwZNwQgnUi+u+N1YmnsFIRNsnr3W+NEPCMGb
	 arRUtx3Tim8xwctcdpy2zWCjldfOwVZRuRXeCCeLn9G0zbFkUmXhKY2OAnufKwIxlv
	 qKvgqqUcduJgKWkB/vtl7u6LGX6ordwzMrzcECeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 371/614] crypto: starfive - Correctly handle return of sg_nents_for_len
Date: Tue, 16 Dec 2025 12:12:18 +0100
Message-ID: <20251216111414.803296000@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index e6839c7bfb73a..54b7af4a7aee8 100644
--- a/drivers/crypto/starfive/jh7110-hash.c
+++ b/drivers/crypto/starfive/jh7110-hash.c
@@ -325,6 +325,7 @@ static int starfive_hash_digest(struct ahash_request *req)
 	struct starfive_cryp_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct starfive_cryp_request_ctx *rctx = ahash_request_ctx(req);
 	struct starfive_cryp_dev *cryp = ctx->cryp;
+	int sg_len;
 
 	memset(rctx, 0, sizeof(struct starfive_cryp_request_ctx));
 
@@ -333,7 +334,10 @@ static int starfive_hash_digest(struct ahash_request *req)
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



