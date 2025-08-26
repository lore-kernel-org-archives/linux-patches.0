Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAB426B747;
	Tue, 26 Aug 2025 13:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215852; cv=none; b=H792+GEjt5kzx/vnICg5zB8gUmELCYbixTnoqwiSRicPH0YY/qWAlnWeK87Y3z4FFNE6WHI3f4NQz4FUL2ev7dktvQeCeD9cstuM1VPDc2gU3UpzDtaeAnWNVWTLDK0wK4W1otMn8rUqfKQMJaQSknuxDHE++mzS/ytS1CyuWDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215852; c=relaxed/simple;
	bh=1RCSKR4Zd33H7VU5reTCuJwc62bnbvbNnQrneh8ucd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBIXmm7osbms4PRwscJc6seiHhnbhiR/JLjdQzWxcdf631hMC+Xv2ZOCnVemvaDnXSr1lq9/j6/iIGJCmxs9KTFLovvbDbzbXAtXffvnFtwX3bWhapzuZZbd8QOjMr4x1g5SqYyoqAIegF83GLe/ixCQEjUkdeggl324aB0VGgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+6XQemY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+6XQemY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4E6C4CEF1;
	Tue, 26 Aug 2025 13:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215852;
	bh=1RCSKR4Zd33H7VU5reTCuJwc62bnbvbNnQrneh8ucd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+6XQemYvk/CPhQg63TkxYtc7WwSZwS10qJkRJhvlwLxfobabDTbDf55NUa35Mt0A
	 EY03ioWdKquOOcldF8YlbJ82eUdcy75j/x/UJBCKTzGJi8kgmxcKVqxjw7WyaXOgr+
	 SxcGcn77DS8iOQ6/1IbbBplhB1XUJQG2b9pcBGuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/644] crypto: img-hash - Fix dma_unmap_sg() nents value
Date: Tue, 26 Aug 2025 13:04:40 +0200
Message-ID: <20250826110951.141404213@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 34b41cbcfa8d..28b75632d1d1 100644
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



