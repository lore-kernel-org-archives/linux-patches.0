Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD1D2F8BE7;
	Tue, 12 Aug 2025 17:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021454; cv=none; b=bwjwVbFQ//LrSnpbwJiE2qn0hIdyTbsHuVlsDxctVw+BW1JpcNbfqnOLFeTSxU1cLROFeKKM3nwvDO1XgAq7/g6RatHOphNWy6mQqiWpoawsnnTf9Q2dlW7rgcqXNSZBSaZYy9EGNqTFVlD37IYsIUcCmnCBufVyly+uAFDNvDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021454; c=relaxed/simple;
	bh=5LF3OgsPQtTTbibxMqtQ1G5iuGu8UNlsDOUfUE5pS04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faLYdspPEGswQASpIHE3KpGTwA1UoSPO1qpJShOVpFz8ldMXpZ8TzRsfqz4MroabXWyFV7E+fhpkkKZUQURwYlE8PQ9eKPcljCR2+SeDopS2oRW7hTohoNwdo3AJu3Tx7WrmViksXaOpy6uqwIqLRH2PXNcwfGU3VSOwOPLw+4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iA51HPvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iA51HPvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7972CC4CEF0;
	Tue, 12 Aug 2025 17:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021453;
	bh=5LF3OgsPQtTTbibxMqtQ1G5iuGu8UNlsDOUfUE5pS04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iA51HPvNhPrOCd8H7MbCNw4JdWZIyyT9Pxz8SxIWWYPjUGHfDXzd2JChOZfq3zXgL
	 NLd3Wcxb4sQp7EKGaxBMWrnZ98NeLMORHn7+CUKTXzgadRK87YKytX+ailvfDLd7O5
	 /04ssvj8jmC2Ufz3tApFq4O4ShBy1U/XTeBEODNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/262] crypto: inside-secure - Fix `dma_unmap_sg()` nents value
Date: Tue, 12 Aug 2025 19:28:36 +0200
Message-ID: <20250812172958.556708178@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit cb7fa6b6fc71e0c801e271aa498e2f19e6df2931 ]

The `dma_unmap_sg()` functions should be called with the same nents as the
`dma_map_sg()`, not the value the map function returned.

Fixes: c957f8b3e2e5 ("crypto: inside-secure - avoid unmapping DMA memory that was not mapped")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index f44c08f5f5ec..af4b978189e5 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -249,7 +249,9 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv,
 	safexcel_complete(priv, ring);
 
 	if (sreq->nents) {
-		dma_unmap_sg(priv->dev, areq->src, sreq->nents, DMA_TO_DEVICE);
+		dma_unmap_sg(priv->dev, areq->src,
+			     sg_nents_for_len(areq->src, areq->nbytes),
+			     DMA_TO_DEVICE);
 		sreq->nents = 0;
 	}
 
@@ -497,7 +499,9 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 			 DMA_FROM_DEVICE);
 unmap_sg:
 	if (req->nents) {
-		dma_unmap_sg(priv->dev, areq->src, req->nents, DMA_TO_DEVICE);
+		dma_unmap_sg(priv->dev, areq->src,
+			     sg_nents_for_len(areq->src, areq->nbytes),
+			     DMA_TO_DEVICE);
 		req->nents = 0;
 	}
 cdesc_rollback:
-- 
2.39.5



