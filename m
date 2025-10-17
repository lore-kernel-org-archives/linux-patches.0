Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF16F337118;
	Fri, 17 Oct 2025 15:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713695; cv=none; b=PuIhb9yNoPlXrIvUp9Tb0/mY5jdLrjuPGxa97bpPPh6Sb3OsiIPysccdY9tEAFkeCibADQ3gwl6SYFQMDFH70gmP7ZVFA4F4yppUX1RnuHcfn0We7UOWaNWEmlTngA73YPAXklXDnk+ZJeO5uuwkNcXAJpY/dOYSyTqIIN2VKKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713695; c=relaxed/simple;
	bh=8/vFm+4geDf4sEQmidFeqZq71TW6BTkUZbrjrJryh78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLEKZ1zxV/poGVRXOgR9nw2TYoYswIE9tAjwh/rFg6tpAkfTokkkh4eIM4c+qDAn1lp1DFXAsoNyC79WkA5J2XJsGHdXhLNnA8Fol3RNMervxWnrbiM0BB7w1yvddKCa31Tc5t8iejLihUqhoeZIkojazB34krOwR6N8WaFYkBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/txWX3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/txWX3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B43C4CEF9;
	Fri, 17 Oct 2025 15:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713695;
	bh=8/vFm+4geDf4sEQmidFeqZq71TW6BTkUZbrjrJryh78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/txWX3o2lyW+aMsD7AmyhZW558LftjXgIV1OT0YWjhc5L9bmIsUhK/7Mf3pdzoFK
	 Vjl36FldxSPbGZZJz8nldyRNQeYAvOUd6OUHGOcnhuhLIVCl+9n8shErxAEFafeTsS
	 PFdnK0VcTXlfNjeCSd2p3/XeVM8sfB36i+DLU/pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 088/201] crypto: rockchip - Fix dma_unmap_sg() nents value
Date: Fri, 17 Oct 2025 16:52:29 +0200
Message-ID: <20251017145137.987975519@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -252,7 +252,7 @@ static void rk_hash_unprepare(struct cry
 	struct rk_ahash_rctx *rctx = ahash_request_ctx(areq);
 	struct rk_crypto_info *rkc = rctx->dev;
 
-	dma_unmap_sg(rkc->dev, areq->src, rctx->nrsg, DMA_TO_DEVICE);
+	dma_unmap_sg(rkc->dev, areq->src, sg_nents(areq->src), DMA_TO_DEVICE);
 }
 
 static int rk_hash_run(struct crypto_engine *engine, void *breq)


