Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E99E4CA297;
	Tue, 21 Jul 2026 17:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656118; cv=none; b=qBaZvMBSkogn6wqEI/IU6lTJiN0hJwW481iJJ05nJbhTNFry7HCGxRLDn2pBD5alAQWunM2fQkNBuqFwMZtG4WhzGY88zFYfj5JDSSJuKWWuzPJdtfGG7NWov9XUCi9i43IJ9SgksIPgkGRh5Pb7hcREvy/tayPrASs6lA3E6rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656118; c=relaxed/simple;
	bh=/SoSH/kbYM9gdRVlLpsPNwp0VA0uQAh6kEZGQHU+KLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8oHNVGSmG3Fym4N2GFyX74ikb/IKPWfJwbTzxrIecky+4qWoAMn0Ugio7CXkhicGzmH69aMbfyC7kdsqExs06QZCvNqWvTCjJmkR223W7q6uNyYcancS2UWGe4N6f9x3XtlUiXJXLZz5z2Tgjc0+TEPnlSOSDFR8OG8saslsIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5iLCZXg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5iLCZXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FAF1F000E9;
	Tue, 21 Jul 2026 17:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656117;
	bh=00xujKAiI8XqUbsZ/aKpzCxoMu7E6XorOqkCrLJS0wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5iLCZXgujElX67d/iKdXBEBdqOcvzN1GB5Cr7Lv1+ReVsJfViP5JLrJciGiUcHgn
	 zCjJdIuI8E170LUYRXaSahavI5nw1n+QkQVdViVVcNoldp4B8rKfxAZyCOX3qJakTH
	 uqQS66grISsyZmzo3Xt1awaPpVlJ3FctpuBHoF8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladislav Dronov <vdronov@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0265/1611] crypto: tegra - Return ENOMEM when input buffer allocation fails for ccm
Date: Tue, 21 Jul 2026 17:06:21 +0200
Message-ID: <20260721152521.007976148@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 690a5f9e5c972a580565ce544ed1627ccf1e84de ]

Ensure the ENOMEM error value is set when the input buffer allocation
fails in tegra_ccm_do_one_req.

Fixes: 1e245948ca0c ("crypto: tegra - finalize crypto req on error")
Reported-by: Vladislav Dronov <vdronov@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Vladislav Dronov <vdronov@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-aes.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 5086e7f140c303..9094c03e991f65 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1215,16 +1215,15 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 	rctx->inbuf.size = bufsize;
 	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, bufsize,
 					     &rctx->inbuf.addr, GFP_KERNEL);
+	ret = -ENOMEM;
 	if (!rctx->inbuf.buf)
 		goto out_finalize;
 
 	rctx->outbuf.size = bufsize;
 	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, bufsize,
 					      &rctx->outbuf.addr, GFP_KERNEL);
-	if (!rctx->outbuf.buf) {
-		ret = -ENOMEM;
+	if (!rctx->outbuf.buf)
 		goto out_free_inbuf;
-	}
 
 	if (!ctx->key_id) {
 		ret = tegra_key_submit_reserved_aes(ctx->se, ctx->key,
-- 
2.53.0



