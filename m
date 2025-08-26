Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1566E2BE058;
	Tue, 26 Aug 2025 14:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217490; cv=none; b=cjEKoUhHm/bMycY2FU6VRe7ovFDlCQVjSHWitEh8MUu5T86xIyRwIG+92e56xUtRh7CErRTLiyVtEujoL1M1EXYOll4YoDkIR3h59JlYTW3PvnCZ2as7m6TCucAqBm/rcczKmThNxYXrLJyUViS5YedK9kVFVwfCWHbFRkh7Nnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217490; c=relaxed/simple;
	bh=hrhg+dvWvotqwO4/N49iWxPDQpBK2jBxnDSCZxjBTBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyHsz4Lj2Vo5qh2tNFGVdcsHKn62ZsuNCJ06fyySpt0QRJJcEFF/13QxlAOM/lsZQoyEq4czw9q5B5FHot1VjEoYRAxGBjdpgUTYjvvYh853fxXYeVF8cYbs7mAI6gPAdYAtigEEBGAGsAniL4YCNLgLRVzb03zE1/TFATw/f5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0PXbyon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0PXbyon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D2DC4CEF1;
	Tue, 26 Aug 2025 14:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217490;
	bh=hrhg+dvWvotqwO4/N49iWxPDQpBK2jBxnDSCZxjBTBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0PXbyon7F2FOlr4jaLZQzBApzskIUd9nsd6wZb/XmICGZbgvIFZ+N1mNXYgjoyIo
	 YprlFqLsDAuDeI/LbRCB2Ti7/ptpr6EhE++twFUQ4g3qC6kjSyhFogAGZdkwNUvSJb
	 SqqFz3ngaxRPxrYpC/XkB3I5UEXJyaJTep5lAhco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/523] crypto: img-hash - Fix dma_unmap_sg() nents value
Date: Tue, 26 Aug 2025 13:05:45 +0200
Message-ID: <20250826110927.833881043@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cecae50d0f58..87eed86ef3fe 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -435,7 +435,7 @@ static int img_hash_write_via_dma_stop(struct img_hash_dev *hdev)
 	struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
 
 	if (ctx->flags & DRIVER_FLAGS_SG)
-		dma_unmap_sg(hdev->dev, ctx->sg, ctx->dma_ct, DMA_TO_DEVICE);
+		dma_unmap_sg(hdev->dev, ctx->sg, 1, DMA_TO_DEVICE);
 
 	return 0;
 }
-- 
2.39.5



