Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB7A18A6B9;
	Tue, 10 Sep 2024 10:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964691; cv=none; b=Y57V+hqzrl0gN7NGpbpYR8Amp66HcATuf4mCorzepS+dnQESgjURZaXuxspgm9iIrMH6VPtspMpSzxbGR9yuOVRIy46Dz6sc8fzKnM6JeSIh9qXmhSBVnspBp+JsOG9yfJzeXhNn+tIwbpopR21Hb6XPbphAuNlU4ZooKgo8o+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964691; c=relaxed/simple;
	bh=YTcUVjnjHf5PQul2GMNrR3MIPEe6X41fKoZ+4HpzJFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+gNXnCZqsc8tfqBvCCB15GUZ2fMQRDWHiv7cWQe+F9O+t3iNi1qxR3qexi+FMv+PtvgvFFk4vD9KR92vxIK+Tc45E93JKb9EtQLBjJP33l0K985PQ3+YIoopX8N7d8siw6Wn7nbgPyLykEc7gkmkCLh5Wh3xiFbSAjHDpQ2m0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3gSm3DR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3gSm3DR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350B5C4CEC3;
	Tue, 10 Sep 2024 10:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964691;
	bh=YTcUVjnjHf5PQul2GMNrR3MIPEe6X41fKoZ+4HpzJFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3gSm3DRM87CwvIjG9yQ0DNusTXANGfATtsCMvq/E7tX5ZcpJ3Krco2W7LaZGgl2n
	 yMDb/b/lHtGTXR0Aub94D6XjwncrOeTRZQvQM9EmWPRK8T10fHM5NC8WkoEcL6GZcj
	 gz86qywpi2h6U2LrFjbkzLShqcvW9A4oRJZb5Un8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 242/269] crypto: starfive - Fix nent assignment in rsa dec
Date: Tue, 10 Sep 2024 11:33:49 +0200
Message-ID: <20240910092616.487048555@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Jie Ho <jiajie.ho@starfivetech.com>

[ Upstream commit 8323c036789b8b4a61925fce439a89dba17b7f2f ]

Missing src scatterlist nent assignment in rsa decrypt function.
Removing all unneeded assignment and use nents value from req->src
instead.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/starfive/jh7110-cryp.h | 1 -
 drivers/crypto/starfive/jh7110-rsa.c  | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.h b/drivers/crypto/starfive/jh7110-cryp.h
index f386e9897896..607f70292b21 100644
--- a/drivers/crypto/starfive/jh7110-cryp.h
+++ b/drivers/crypto/starfive/jh7110-cryp.h
@@ -213,7 +213,6 @@ struct starfive_cryp_request_ctx {
 	struct scatterlist			*out_sg;
 	struct ahash_request			ahash_fbk_req;
 	size_t					total;
-	size_t					nents;
 	unsigned int				blksize;
 	unsigned int				digsize;
 	unsigned long				in_sg_len;
diff --git a/drivers/crypto/starfive/jh7110-rsa.c b/drivers/crypto/starfive/jh7110-rsa.c
index fbc06f8ee95f..1db9a3d02848 100644
--- a/drivers/crypto/starfive/jh7110-rsa.c
+++ b/drivers/crypto/starfive/jh7110-rsa.c
@@ -282,7 +282,7 @@ static int starfive_rsa_enc_core(struct starfive_cryp_ctx *ctx, int enc)
 		memset(rctx->rsa_data, 0, shift);
 	}
 
-	rctx->total = sg_copy_to_buffer(rctx->in_sg, rctx->nents,
+	rctx->total = sg_copy_to_buffer(rctx->in_sg, sg_nents(rctx->in_sg),
 					rctx->rsa_data + shift, rctx->total);
 
 	if (enc) {
@@ -333,7 +333,6 @@ static int starfive_rsa_enc(struct akcipher_request *req)
 	rctx->in_sg = req->src;
 	rctx->out_sg = req->dst;
 	rctx->total = req->src_len;
-	rctx->nents = sg_nents(rctx->in_sg);
 	ctx->rctx = rctx;
 
 	return starfive_rsa_enc_core(ctx, 1);
-- 
2.43.0



