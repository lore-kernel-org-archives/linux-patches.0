Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA65381AE2;
	Thu, 20 Aug 2026 15:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239160; cv=none; b=ILyvS8a2srxmz8VGGtyYDlnAf/pJfKBu6ZKbQXSMqgE53FPuW+4wwsl88mRyMXolQP0Mfz/CmYgrKRkVH4Z+lTU1ea3LnPCk/XuK6wSoLhU047E7TEPaT7HwHzze6kt6huwyIZv7YOFQLQN7yM1VgNw+NlkZOLB/FwR3JborHT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239160; c=relaxed/simple;
	bh=lrw1wmGVFehaCJeW7F4/HS+wIhC7Z+K3Vf2Yiszrrms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSoa6FhiOtaC1OObTTXbGFXHqKmBdj7qgSjwXOB/T3ipgX1aJp/vwP0ZAtLQosvwk+TI1T5IKG3Vt9OihwrrNe4nlT1LwP5OPFf3idQvmR1ov7VBlQcxEBybo2EEvZmhKcsWZZ1bkxj2sBd1Gp/iiKWRoAqn7aZatZJYxt2tx9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGNhNaGL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGNhNaGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4A31F000E9;
	Thu, 20 Aug 2026 15:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239158;
	bh=B2KQazEbjx5Ly/ZCJVqmWziM71BIBE3E+Dr8E8o9xUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OGNhNaGLJhGgJMV4eEtYCMRfx8jF+c4Fm34YuElUBjaByE0F43k5n6NJuLgGCcCvl
	 VtV+VDlfwgBPekIa5Q2L2eDRAF00CQg676IybyTcoBOnearvGZALaAxdXnGKHudr53
	 dADwyIJiOUJMapzW+j2aq27d9hqcK7hNdC3bdwIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladislav Dronov <vdronov@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 171/217] crypto: tegra - fix rctx->cryptlen calculation in tegra_gcm_do_one_req()
Date: Thu, 20 Aug 2026 16:55:39 +0200
Message-ID: <20260820145242.887207172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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



