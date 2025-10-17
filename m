Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEEF330B06;
	Fri, 17 Oct 2025 15:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715416; cv=none; b=mah+YKN2QRNG+J680gSPjic/WRyldHAjtWk+Nl4M7nGEih0pVufLb4lg8D7KJrR1m9sphwzrLP1qwbKwUNoJKAFOqXqBYjzyRuX0EMymKnvaS9wZRiegmzoRyvcZ1j5Acp7MXBmoYCdy0/YQ10qMvcmyhfyxWFlMcnftKir1Ihw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715416; c=relaxed/simple;
	bh=oyJO/s+0OiJp3gfCSz2jYeYUupw0/KC2zwcwNwgGL40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEWoOm2ySELJl0ifRBMLyAXOraCTjyl6NyN4Ipk4rttKH9jACJYCq2R2qbUwxzOOWzBLJ+GmoM+ryD5SZoLMQeoLB2wTppQuRrwnnlK1IJJwXpvqNxwSqdDbh8wzULcgBGsvNMekp0aP0EfYoPIk90OgIwcFsemVWZH2LJij2/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUhCtyxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUhCtyxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297A2C4CEE7;
	Fri, 17 Oct 2025 15:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715415;
	bh=oyJO/s+0OiJp3gfCSz2jYeYUupw0/KC2zwcwNwgGL40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUhCtyxMGhcYvU1aSaY4l2xfNDp7CVS+8t9QR3r1ZlLufLJKNAAUSXIYRwF+TVadX
	 Ay1PuWo9c3nih3Yw4TGa60hYaKZf1u+gVQ16QpQ1vzVT5PJwTwB7e1fiFchgA13kpI
	 7gYV9hn4hVkVsR2tW9/hYJuIMIAk5E6ZdoaaErPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.17 209/371] crypto: rockchip - Fix dma_unmap_sg() nents value
Date: Fri, 17 Oct 2025 16:53:04 +0200
Message-ID: <20251017145209.651171108@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 21140e5caf019e4a24e1ceabcaaa16bd693b393f upstream.

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 57d67c6e8219 ("crypto: rockchip - rework by using crypto_engine")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/rockchip/rk3288_crypto_ahash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -254,7 +254,7 @@ static void rk_hash_unprepare(struct cry
 	struct rk_ahash_rctx *rctx = ahash_request_ctx(areq);
 	struct rk_crypto_info *rkc = rctx->dev;
 
-	dma_unmap_sg(rkc->dev, areq->src, rctx->nrsg, DMA_TO_DEVICE);
+	dma_unmap_sg(rkc->dev, areq->src, sg_nents(areq->src), DMA_TO_DEVICE);
 }
 
 static int rk_hash_run(struct crypto_engine *engine, void *breq)


