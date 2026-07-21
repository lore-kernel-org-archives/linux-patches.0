Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23A746A605;
	Tue, 21 Jul 2026 15:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648998; cv=none; b=QDeKYze4Azpr+uekFa3Jxrw9A6wejdoh9De6r4tpV3/mDiKy/sDE0+ZCeMP4yG6cd24H1G4b9X0zmshBivR33kviKTxByO/MoA4yPJpnh96HvlfbCJuuBcPDRGpNn4RIn3IISv0igi7Min1NmfwgPqJSqknEMw5aj5vfBcKlH/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648998; c=relaxed/simple;
	bh=T7ch0VNnufT1ZBCIHmuFTqQrZlh9lk/6vpzGMB+jv3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDD2+y7iWwrTuy3O6QotYQymAzlR53K4nIKdIckS8GSJBXNrD4keUJY5pzi1ra3dzuSNkLdUxsiS5rA0o7v7VhZQ5FI4RjhcpPxjdBqyLNIbNhiykg9FeIbj4XtyRHsmWYch2cXgKDFKo4sB+DNKIyYvsqGB22uAi/jJyynHf0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJY4hbYm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJY4hbYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A291F000E9;
	Tue, 21 Jul 2026 15:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648996;
	bh=KhHGUnuupHfjOIrHRxwJe9mcB99+3Blgnjuv7AWrGNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJY4hbYm40dQ5+bZPa6EQ3VlJCLNa5RQRydzjS2F7fjDo0crxhMYmCaSXxEw81JPZ
	 SqSUmsegesvVsHUuLIGkyfl3FX4BItMtZoEMgVBE0vQxL7gMezhWXQ3NZjtRiVZ0uy
	 ZipooIVffHsnsvb8sldJWNmBV0pvI+4pAwPtF+Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladislav Dronov <vdronov@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0368/2077] crypto: tegra - Return ENOMEM when input buffer allocation fails for ccm
Date: Tue, 21 Jul 2026 17:00:41 +0200
Message-ID: <20260721152601.369726273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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



