Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB8D415F14;
	Tue, 21 Jul 2026 19:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661766; cv=none; b=sz9KOnOZeHPNpFKMFzrrkijt644sKOThIRYiBa3ar7o5nb6SY7p7DuTZCt+aRy1pjKzdRpN04zUUtcZ2TtFjtDIoXzVHdXC38w572HAZuQT+kkL790hPoilXYf52LOlSkJBBNgliuiHWcNe3OBuTaJO4poFLkk+VHqplWMgyQYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661766; c=relaxed/simple;
	bh=3kTNJHspWOE7Q+IHwJniOVDclxGW320AriWIEEipxOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAYu3Yc/DQU7Z1nS1Q4NvHHMzuKIQfOwQfHKeYOzEKjuFZ5s4XECSI7X1UwQPZI9yxj0JUnotthDXc5Q8pt1ptv7FEv3aTU34wM/XUYlGFGSWSVPpciqf/dB15sC7MGj9pbD/lB3xyXQBM4y+Tj2GIAUuVA2XPshvZzFFJxyc8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cS625uEl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cS625uEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD5E1F000E9;
	Tue, 21 Jul 2026 19:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661765;
	bh=ArCYZrPqTbg9hDQVWzhYiK/10WDVi0rBNjvBzhwhMbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cS625uEl8S2eov4GnDBLt3+MJ4v9jTfo0Q55peWt/PCoFIfNhXhSFPOgf41A/yOuE
	 ZffcLR2cNmJWj028sIRs4QyEyTMnoK4XqtI/fzFAQgUfL4R9reCjChqElHVEn6NTl3
	 kqWuMFsXDdXEf6Feg3qQJalEb8aWh7RH26nHDUIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Vladislav Dronov <vdronov@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Patrick Talbert <ptalbert@redhat.com>
Subject: [PATCH 6.12 0191/1276] crypto: tegra - Fix dma_free_coherent size error
Date: Tue, 21 Jul 2026 17:10:34 +0200
Message-ID: <20260721152450.362625253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 03215b8457784540acc741e6331e355b62c6c8ab ]

When freeing a coherent DMA buffer, the size must match the value
that was used during the allocation.

Unfortunately the size field in the tegra driver gets overwritten
by this point so it no longer matches and creates a warning.

Fix this by saving a copy of the size on the stack.

Note that the ccm function actually mixes up the inbuf and outbuf
sizes, but it doesn't matter because the two sizes are actually
equal.

Fixes: 1cb328da4e8f ("crypto: tegra - Do not use fixed size buffers")
Reporeted-by: Patrick Talbert <ptalbert@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Vladislav Dronov <vdronov@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-aes.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 30c78afe3dea63..5086e7f140c303 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1201,6 +1201,7 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct tegra_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct tegra_se *se = ctx->se;
+	unsigned int bufsize;
 	int ret;
 
 	ret = tegra_ccm_crypt_init(req, se, rctx);
@@ -1210,14 +1211,15 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 	rctx->key_id = ctx->key_id;
 
 	/* Allocate buffers required */
-	rctx->inbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
-	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->inbuf.size,
+	bufsize = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
+	rctx->inbuf.size = bufsize;
+	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, bufsize,
 					     &rctx->inbuf.addr, GFP_KERNEL);
 	if (!rctx->inbuf.buf)
 		goto out_finalize;
 
-	rctx->outbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
-	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->outbuf.size,
+	rctx->outbuf.size = bufsize;
+	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, bufsize,
 					      &rctx->outbuf.addr, GFP_KERNEL);
 	if (!rctx->outbuf.buf) {
 		ret = -ENOMEM;
@@ -1254,11 +1256,11 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 	}
 
 out:
-	dma_free_coherent(ctx->se->dev, rctx->inbuf.size,
+	dma_free_coherent(ctx->se->dev, bufsize,
 			  rctx->outbuf.buf, rctx->outbuf.addr);
 
 out_free_inbuf:
-	dma_free_coherent(ctx->se->dev, rctx->outbuf.size,
+	dma_free_coherent(ctx->se->dev, bufsize,
 			  rctx->inbuf.buf, rctx->inbuf.addr);
 
 	if (tegra_key_is_reserved(rctx->key_id))
@@ -1278,6 +1280,7 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct tegra_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct tegra_aead_reqctx *rctx = aead_request_ctx(req);
+	unsigned int bufsize;
 	int ret;
 
 	rctx->src_sg = req->src;
@@ -1296,16 +1299,17 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	rctx->key_id = ctx->key_id;
 
 	/* Allocate buffers required */
-	rctx->inbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen;
-	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->inbuf.size,
+	bufsize = rctx->assoclen + rctx->authsize + rctx->cryptlen;
+	rctx->inbuf.size = bufsize;
+	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, bufsize,
 					     &rctx->inbuf.addr, GFP_KERNEL);
 	if (!rctx->inbuf.buf) {
 		ret = -ENOMEM;
 		goto out_finalize;
 	}
 
-	rctx->outbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen;
-	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->outbuf.size,
+	rctx->outbuf.size = bufsize;
+	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, bufsize,
 					      &rctx->outbuf.addr, GFP_KERNEL);
 	if (!rctx->outbuf.buf) {
 		ret = -ENOMEM;
@@ -1342,11 +1346,11 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 		ret = tegra_gcm_do_verify(ctx->se, rctx);
 
 out:
-	dma_free_coherent(ctx->se->dev, rctx->outbuf.size,
+	dma_free_coherent(ctx->se->dev, bufsize,
 			  rctx->outbuf.buf, rctx->outbuf.addr);
 
 out_free_inbuf:
-	dma_free_coherent(ctx->se->dev, rctx->inbuf.size,
+	dma_free_coherent(ctx->se->dev, bufsize,
 			  rctx->inbuf.buf, rctx->inbuf.addr);
 
 	if (tegra_key_is_reserved(rctx->key_id))
-- 
2.53.0



