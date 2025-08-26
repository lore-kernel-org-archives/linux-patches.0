Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF5C350D46;
	Tue, 26 Aug 2025 14:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218832; cv=none; b=bdxq44IZN9A+99mB3ksBsRx9g/Yd2/2qXMxy72dXFZVvUfHSKZBT/JWJQ8ZcpL4ZG65Zn+Bu0WFUXzgZv8x33qehRicCDcPf6DXNgqJqwkFd0OCSdDERPXat7ycevlcTq+Sz2eHWKEN2ZXPgzhEVYn5mr0cSRxjNARA5iT/nwR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218832; c=relaxed/simple;
	bh=tLaCkFAwmEruqqkprHyQqcI6rmm53XbP/DeDDmPdDAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=da79HVFP1V2TOFxdWfSJMlzGJjvW3BRCfNKIC3V86e+v+HdMdGj4eZAkhXUdYZWgt9CGGsMOrO6ybFSYVcOwCEJvBNnLBVb0pu3zQ5N5SZPHDLbLTnlWakiwyayZrfJtXek5gKHKXc55Pkc2+jt77AJQ7xyhVIcmwSJCnCrYxd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2eecDgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2eecDgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50288C113CF;
	Tue, 26 Aug 2025 14:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218832;
	bh=tLaCkFAwmEruqqkprHyQqcI6rmm53XbP/DeDDmPdDAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2eecDguI7xJmJA+FYcBhr1qm/0qHP015PmCHLAn+jxgV73XiPeiW2HTlTV6EPQFI
	 WjEevOsIglLNW8t8XZu+fMz52VH4HC/7VGGDlzEweRAQE6N8ksc1Tr6kR8KtcnYHGu
	 FW4Lemld9SQS+gmijlklPMD/g8l/61NnHkC2ec3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 119/403] crypto: img-hash - Fix dma_unmap_sg() nents value
Date: Tue, 26 Aug 2025 13:07:25 +0200
Message-ID: <20250826110910.024325687@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 17cc44f14e5c..b5fd15e0c050 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -434,7 +434,7 @@ static int img_hash_write_via_dma_stop(struct img_hash_dev *hdev)
 	struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
 
 	if (ctx->flags & DRIVER_FLAGS_SG)
-		dma_unmap_sg(hdev->dev, ctx->sg, ctx->dma_ct, DMA_TO_DEVICE);
+		dma_unmap_sg(hdev->dev, ctx->sg, 1, DMA_TO_DEVICE);
 
 	return 0;
 }
-- 
2.39.5



