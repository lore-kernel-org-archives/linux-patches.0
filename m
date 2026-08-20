Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C7B410D30;
	Thu, 20 Aug 2026 17:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247228; cv=none; b=Ic+VF4KO0TSPEkAwF41EWEjqrD599OC6kGBC0SfnZd0VWRcn97ESBOQAsCz+SzICagHqCgStGupuq6A32Xf0kr80dPMFe9bJNwAYLroztBy6bcXjsOvoFlVf/kBI09ktDN8PJZpzGQU7glRHrn2d5Nul+iaIBZAiOutAhOrJCQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247228; c=relaxed/simple;
	bh=1YeUoGmqXfp8Bs17ObiEPZdR+24Mqng9LFyoG7M7Ayk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLoZ+NAdMrT4XnanSp1JaMuIekmmFB0JGY+pwXKsadNcDqTUuqIoowSFqwNrKoONe9J1iNcC6aKdkHtDDF01c2iJUlfgVBHbuCwqp1D0UuF+E109a45y9WFiPjgLSQkdolzGfCdZw7TvjY6OG1d6JdC1NPnivIe9abk1rodBH7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CT3pqjgG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CT3pqjgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828E91F000E9;
	Thu, 20 Aug 2026 17:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247227;
	bh=8k56CfobtU/r4+mgigpIN+Rd6EYstaGlkMZv6HVwixs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CT3pqjgGKKZywfV3PjoWd3GXsQ4RI+bLMxqLc45dlsr3tXIiIS7/9fz8uUes+sTCh
	 Lk/as1Wq9nYH1YKju2WKbP71jWSrJEtmf9QveNkCQGKLsb4I6+9OgUqKIHowt8x+eN
	 SbE8GNwJJIxNk5KZuCFVKQ5LmJALxbBQfbdAMQnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladislav Dronov <vdronov@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/220] crypto: tegra - fix rctx->cryptlen calculation in tegra_gcm_do_one_req()
Date: Thu, 20 Aug 2026 16:56:24 +0200
Message-ID: <20260820145229.348909884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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



