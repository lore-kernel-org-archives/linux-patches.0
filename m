Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0632F5A1B;
	Mon, 27 Oct 2025 19:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592166; cv=none; b=Xxm0wrQ8Q4+Sk6+JD5DhF/lm9b37n6iEm7I7OCQ9dHUcSlrhxIdkBaMLemmoVxYp/2lAh/dHuKFni7jQRaCCimmNyRzeENa+VfoCsfbWvABQNEK13eeXJP57OSNcW8PZ5wBtUKI2vQQf4I4Wv77tJEn3fjDQR3gli82EpfZbkw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592166; c=relaxed/simple;
	bh=ZIYuMxuoC+OsNsqv9IczYzwM3g8Xk1kxxxyZKshQ9Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gB+3adG9SooOumRnLHcGCr3Sp6X2Y6qaP4DYL4iw8u9XVgn7uaGSTiJTTHPRwQpZRtTTLPRqYx1aJ/pxMDDS3QcpqvjS8jx2g05l0ldffinqgbRqj2Cp3vVYR05tWG4ZjsC5QtAXH3ZCJZ0zvWYWuUt7Uxx6608oysadCKLyHLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7vmE7pv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7vmE7pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201EBC4CEF1;
	Mon, 27 Oct 2025 19:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592166;
	bh=ZIYuMxuoC+OsNsqv9IczYzwM3g8Xk1kxxxyZKshQ9Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7vmE7pv3jw5QEZEDW4z8YNTIW++XtQU2m0fqhZLDXqQlTZp613ExyuAoKe5kwLzu
	 8PMSxHDI3aImAp0ZLJUxq9sF24VYREOaXHF5/z9me5mwa6sQaMLAXz3C+yNJ01JCct
	 yPdNZWfHxfwDYz1vBdtig3reiixKYINetxYTjMUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/157] crypto: rockchip - Fix dma_unmap_sg() nents value
Date: Mon, 27 Oct 2025 19:34:32 +0100
Message-ID: <20251027183501.555855921@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 21140e5caf019e4a24e1ceabcaaa16bd693b393f ]

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 57d67c6e8219 ("crypto: rockchip - rework by using crypto_engine")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ removed unused rctx variable declaration since device pointer already came from tctx->dev->dev instead of rctx->dev ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/rockchip/rk3288_crypto_ahash.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -236,10 +236,9 @@ static int rk_hash_unprepare(struct cryp
 {
 	struct ahash_request *areq = container_of(breq, struct ahash_request, base);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct rk_ahash_rctx *rctx = ahash_request_ctx(areq);
 	struct rk_ahash_ctx *tctx = crypto_ahash_ctx(tfm);
 
-	dma_unmap_sg(tctx->dev->dev, areq->src, rctx->nrsg, DMA_TO_DEVICE);
+	dma_unmap_sg(tctx->dev->dev, areq->src, sg_nents(areq->src), DMA_TO_DEVICE);
 	return 0;
 }
 


