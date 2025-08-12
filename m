Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EDA21ABD0;
	Tue, 12 Aug 2025 19:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026351; cv=none; b=TNrKpHetGAXOtDfPQec3xwsxob/mSEkEJmKOOyS6PyhNa3H1+efYEAz1EcWzP9b8qhm83f7nt7CiRvFgltooP/mwfqx81hi7FWfrTV1pGWtRqSZeuQCskDUaqpXP3ZguhGeJCsBdFBVnTG8Gl3vPDvGR+rk30iwVvxPVyIrFIMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026351; c=relaxed/simple;
	bh=AxYfYi+L1+emPXuDsc2W7HSawHT6imKEfI5H4L2ZAdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUVJ+NuK3d3m11SCPac47LcQDXYipmaG+JpZxczkYZ3NH7wLl/Q4VAXK9GQGfF6I1u4NbksDRuzQJsWVgfo4J3ZZ/4DFK2YOwxaNFGIkHhesr3cA6uLO2vJ/yKEk5yKWEYd1argxx++asJlWxiBXGq2FXE5TrvFacnbm1SioM/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rnc/QreS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rnc/QreS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B81DC4CEF0;
	Tue, 12 Aug 2025 19:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026351;
	bh=AxYfYi+L1+emPXuDsc2W7HSawHT6imKEfI5H4L2ZAdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rnc/QreS/C5GEg3yMDUehlBSoDjeSpEQvPYwsdxKYnhHyCzgaBI8KC5WOwVAtIZE0
	 h4cQS53UwLwIR4jrze9d8XQGwWphjaTN4rzJbelXiVSxaYi7NUtqjGk37OROWV3mA3
	 M32dUBqur2B9otv3mXYQ0DBK1/sS76upSQPBZqfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 294/480] crypto: img-hash - Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:48:22 +0200
Message-ID: <20250812174409.557573928@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 34b283636181ce02c52633551f594fec9876bec7 ]

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: d358f1abbf71 ("crypto: img-hash - Add Imagination Technologies hw hash accelerator")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/img-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 1dc2378aa88b..503bc1c9e3f3 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -436,7 +436,7 @@ static int img_hash_write_via_dma_stop(struct img_hash_dev *hdev)
 	struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
 
 	if (ctx->flags & DRIVER_FLAGS_SG)
-		dma_unmap_sg(hdev->dev, ctx->sg, ctx->dma_ct, DMA_TO_DEVICE);
+		dma_unmap_sg(hdev->dev, ctx->sg, 1, DMA_TO_DEVICE);
 
 	return 0;
 }
-- 
2.39.5



