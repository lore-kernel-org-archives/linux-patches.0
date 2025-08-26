Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A62D35A28E;
	Tue, 26 Aug 2025 14:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217393; cv=none; b=KC7LzPn655DSjqKmnfVOhGhOM9s+O8QO8J7k8uzlRhXGac2qYrd3fUe5z5hXxUFZpU+JKPW/oYjN/06pHyEm+w/DTolFzQyGSi9bDRZqehjTHOTN/kNYDOv27kgdDXGaft2IoceCWZLkDvMErtQ//EfhNHqy7zhzFU9/eqfZn00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217393; c=relaxed/simple;
	bh=1gXufgFymjURqjVoQgkXnDPGvlqnRcApTEBnkUYKAxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVslNshYlREMJeIate0heGYD/54JM43xQCSUTfaGiKCDAibfgruyXTbnwgV1g8U1PBqQDkzZSCCAxk8pDRY+xVkXCRsD1awyp08n7wFw5/kl3/3/5uY9MzjkYR8pSov4a9chBoSZoIZFJts/Xl5cEDqdLflJO8TPuOQMfEhzc6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXc4QzKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXc4QzKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4C1C4CEF1;
	Tue, 26 Aug 2025 14:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217393;
	bh=1gXufgFymjURqjVoQgkXnDPGvlqnRcApTEBnkUYKAxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXc4QzKFkTotYGP2ZWDMJZ/6Ej2aWAgx3ySMyb/WE6DxPGNAnlifjHid7o+Wg7vkE
	 D09n3bcYYT3xTKHJKXdM+HHakaTdrMm0HU7dnpwot1k8iY6QuZvRctfhKFvto5taY8
	 zpXzrgaIkZzzgpjBzbPvXy1xEaT0K4khnbOYL5QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/523] crypto: inside-secure - Fix `dma_unmap_sg()` nents value
Date: Tue, 26 Aug 2025 13:05:36 +0200
Message-ID: <20250826110927.618375409@linuxfoundation.org>
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
index 1c9af02eb63b..bdb60810ec72 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -247,7 +247,9 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv,
 	safexcel_complete(priv, ring);
 
 	if (sreq->nents) {
-		dma_unmap_sg(priv->dev, areq->src, sreq->nents, DMA_TO_DEVICE);
+		dma_unmap_sg(priv->dev, areq->src,
+			     sg_nents_for_len(areq->src, areq->nbytes),
+			     DMA_TO_DEVICE);
 		sreq->nents = 0;
 	}
 
@@ -495,7 +497,9 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
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



