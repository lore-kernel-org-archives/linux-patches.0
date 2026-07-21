Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B7E415F14;
	Tue, 21 Jul 2026 19:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661769; cv=none; b=dS0IkbLsQOYEGJoE8nUdDmyqhR2+06H5rnOshf8OWTbJgNom5tlfx2422xlo574KSIosS4m45s74d6WRlkfEVViXGNDSZKZChH7/l5ZaKsNUJxnW3Xw/uM8yNjGUVVkU3KBXJtvMHCE8wzLhAgtLZDzii6R6/ikeb25mASD3iow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661769; c=relaxed/simple;
	bh=fJ8I0yDiFi+BWQVr+jN8PwJYUAOnmg+XkxXPlqBiE74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzRZjl91ULFVZBJbJ6fV0kkUYX6HcxbVTye9qpUlTc3J2sDBkdM6UcWfX0nmT72yIfs2tIOIrFBWrxFNarURmGN/FTaV4lyu6VpkSyM1L00OeUOYCyu3GP/zbMIP2473Vw9snhWrlkinm6hgFt54F5ttViSxRerQwRjuQzp+S1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SIFD3zF7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SIFD3zF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB361F000E9;
	Tue, 21 Jul 2026 19:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661768;
	bh=zTgDP5m88NscBCRP4HmDsX9SCUboDMizvMHLbm1n54c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SIFD3zF7GAn4EzgVrdn6+i/D0JyrKiXHusjtmjGSDh3WAunlWn2MsJlMO5mZ4DWZV
	 T3d+6UsFSb0izJQCM+KlqS/b0YY3/dx6CZdSw2uVCcVAHvPkf7fTFs2cpk4sSK7aTz
	 C3sDSwD5UbvEyJWA3CwhYQ4BQRenSw81/QgIoZFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladislav Dronov <vdronov@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0192/1276] crypto: tegra - Return ENOMEM when input buffer allocation fails for ccm
Date: Tue, 21 Jul 2026 17:10:35 +0200
Message-ID: <20260721152450.383277531@linuxfoundation.org>
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



