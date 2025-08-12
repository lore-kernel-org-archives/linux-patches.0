Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7424A2EAB97;
	Tue, 12 Aug 2025 18:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022545; cv=none; b=qaioxp/n7Fx3DnieIg9Hcp4k2ukFbQaE4AtlO30esm4vM0o1pp/pKjg773VIODkCehim3TGN2PVmGDO6aVuGGDTep9ds8OQ6JfXUYovufN/8WNEd3lFPDGW3h2oxsV8tKT2ETQGwtRVHvuMWAITeGPkCwiZq5Iu76pMb1NrXM/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022545; c=relaxed/simple;
	bh=nNvEh+bHTrZ+Hqm3LzK7mwbB/lhQaCUTuiOrm6Le2gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDo/wp820JqJh88ONisna3I5VypWYl39zK0X+KyxyPULkFyTCvkjBDUy4Iy3Y7az8hwYrI3ClkpE3hgBNM+s/ussMYezkvsw+yWAM+PNkBsxcCqhxFrwLlbcwx0gasHYejwiQu+g9hU/c9ggtUpTHGStWgj4ATg3yz+Wxxyzsd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7RcCLZ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7RcCLZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22E6C4CEF0;
	Tue, 12 Aug 2025 18:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022545;
	bh=nNvEh+bHTrZ+Hqm3LzK7mwbB/lhQaCUTuiOrm6Le2gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7RcCLZ2xP0qnG2/iiIIDMy+CZIZvPB9Uaa3v8iv19qTDvDoXqaBNtEtgRsjUroUx
	 9ArIK5UzD5brhq4PHyetzn1HoH9WMyxrVI+NmDPXm2UT7BrGiS+VosFG5uCrzCd8m0
	 5sahK11BUA5CRMjtrB8BRya43GyhVvSW6cR7d6TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/369] crypto: inside-secure - Fix `dma_unmap_sg()` nents value
Date: Tue, 12 Aug 2025 19:28:04 +0200
Message-ID: <20250812173021.806715616@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



