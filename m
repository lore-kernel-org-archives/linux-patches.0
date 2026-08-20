Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177D736AB5A;
	Thu, 20 Aug 2026 15:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238498; cv=none; b=S5AQ3Sa9Wp4jjFhomtRQOIssKetcyB5/waVvlbM9zBco+XVRYL7/NxUn054Lgd64ayvGmfoTUy6rHLpG8fW4fPyCW1gsOvY8soImVAoIr0angTUoZmTKGhi/rkgz7rnqWGn+qwevVr2sXSiYMd/GL5OMq0IOPtvVNsv84H6gQj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238498; c=relaxed/simple;
	bh=hJ5ybFssbHRn8Ai957QCU+bgaK+zPGHURA159asI0WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Prg0dFT3aeSXzRCxI2G9+NyhroL8azo5rgxyfq3HPGGspAveZkYGMG5Ram9lqtQuiJCv7lT5nzQjbcS5kXj+e5yvb4bro856RQ9Njc4nUKk5FA96uf0c6fkM1rKv3Izg/PWHKLTIbuZdX9SNLCMTvkiCcLShBPDf+gb4zCYEJlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPpwcg4M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPpwcg4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC511F000E9;
	Thu, 20 Aug 2026 15:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238496;
	bh=PbXf5EtuDOutWHUPsHKJKdhLWf81xiOceJ4IMjbWI1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sPpwcg4MZ0imX74Mq/5fZz4TPNU1bRPiZUgLHLGFnqkkjR6RCT5sJjSx0OyDW5D/H
	 NvOMsQevUScrDfkQcBHbm2qQDJJ19UXUt67t1FgjxzTZSiUIIsQI4XpbVRG1ZdjckI
	 K0B8MFN7LiUR0QzaEsb6jUCrkj4D6e8bcP0SmMy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladislav Dronov <vdronov@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 168/228] crypto: tegra - fix rctx->cryptlen calculation in tegra_gcm_do_one_req()
Date: Thu, 20 Aug 2026 16:55:10 +0200
Message-ID: <20260820145249.792349397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladislav Dronov <vdronov@redhat.com>

[ Upstream commit 360f2974fcea49c61f6d6f81554741a9eeee7168 ]

Perform rctx->cryptlen calculation in tegra_gcm_do_one_req() the same way
it is done in tegra_ccm_crypt_init(). The current formulae may lead to a
crash if a caller does not call tegra_gcm_setauthsize() and so ctx->authsize
remains zero. Then a decrypt operation with incorrect rctx->cryptlen will
lead to a write beyound rctx->dst_sg buffer.

As a follow-up cleanup delete struct tegra_aead_ctx->authsize field since
it appears to be completely unused. Also simplify tegra_ccm_setauthsize()
and tegra_gcm_setauthsize() functions respectively.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Vladislav Dronov <vdronov@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-aes.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 9094c03e991f6..0fd1d70358996 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -45,7 +45,6 @@ struct tegra_aes_reqctx {
 
 struct tegra_aead_ctx {
 	struct tegra_se *se;
-	unsigned int authsize;
 	u32 alg;
 	u32 key_id;
 	u32 keylen;
@@ -1290,7 +1289,7 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	if (rctx->encrypt)
 		rctx->cryptlen = req->cryptlen;
 	else
-		rctx->cryptlen = req->cryptlen - ctx->authsize;
+		rctx->cryptlen = req->cryptlen - rctx->authsize;
 
 	memcpy(rctx->iv, req->iv, GCM_AES_IV_SIZE);
 	rctx->iv[3] = (1 << 24);
@@ -1394,8 +1393,6 @@ static int tegra_aead_cra_init(struct crypto_aead *tfm)
 
 static int tegra_ccm_setauthsize(struct crypto_aead *tfm,  unsigned int authsize)
 {
-	struct tegra_aead_ctx *ctx = crypto_aead_ctx(tfm);
-
 	switch (authsize) {
 	case 4:
 	case 6:
@@ -1404,28 +1401,15 @@ static int tegra_ccm_setauthsize(struct crypto_aead *tfm,  unsigned int authsize
 	case 12:
 	case 14:
 	case 16:
-		break;
+		return 0;
 	default:
 		return -EINVAL;
 	}
-
-	ctx->authsize = authsize;
-
-	return 0;
 }
 
 static int tegra_gcm_setauthsize(struct crypto_aead *tfm,  unsigned int authsize)
 {
-	struct tegra_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	int ret;
-
-	ret = crypto_gcm_check_authsize(authsize);
-	if (ret)
-		return ret;
-
-	ctx->authsize = authsize;
-
-	return 0;
+	return crypto_gcm_check_authsize(authsize);
 }
 
 static void tegra_aead_cra_exit(struct crypto_aead *tfm)
-- 
2.53.0



