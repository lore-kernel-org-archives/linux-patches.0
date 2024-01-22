Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF4B5A7B8;
	Tue, 23 Jan 2024 01:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974352; cv=none; b=CJzCECAQ+du5jaGzL/06SBzjvx3IGogxs/TAEP4qgujfFOau9ecNGD0wkLENv5xqj7Sge2ZKRePsCXVlYgt/UZVGm/PyPIrgbjvS6snnuAvtehGlS/KnBjNxdp0KkLth3155QvCdWHzJboRNOaZmTARhsHSy9V1TtayvYXk7h70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974352; c=relaxed/simple;
	bh=2AXQc3CF+xuzovZsoXOFxhoayCo2/x2pae1JjveM++8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYNRZ0OfLNgWjlzRqzcNe8PUhftdJvnVoedSq2E5aAUaN3bTfdG2n9SG6WPkhQ1wHwWjhJiRlSAEITKQDYIUnMHhwqoBo6+RESjl/jDAMazn6XVsKWjU+NIxLaUuqY8nXFFlC29HKjTGWt2Mrv2RWIRGh6HZDG4K0SVdxKb57NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKyBoRnE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKyBoRnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E98C43399;
	Tue, 23 Jan 2024 01:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974352;
	bh=2AXQc3CF+xuzovZsoXOFxhoayCo2/x2pae1JjveM++8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKyBoRnEI/nJFyXmUZEd97oyZCjmido9P7I1TGyn1OFrYzim82q8E4HUKEGQD94t8
	 pTv5vu1DStEG8aqa8x3tUFuMCO9Y2Bre3Hdw9mvVsNtTKzjNc0KPiLuLRX/savivQW
	 OMNZjcBLDq4Rzj8fUKo7AfQ7ObkaZAURzxogy+HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/583] crypto: safexcel - Add error handling for dma_map_sg() calls
Date: Mon, 22 Jan 2024 15:51:39 -0800
Message-ID: <20240122235813.608624333@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 87e02063d07708cac5bfe9fd3a6a242898758ac8 ]

Macro dma_map_sg() may return 0 on error. This patch enables
checks in case of the macro failure and ensures unmapping of
previously mapped buffers with dma_unmap_sg().

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 49186a7d9e46 ("crypto: inside_secure - Avoid dma map if size is zero")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/inside-secure/safexcel_cipher.c    | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 272c28b5a088..b83818634ae4 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -742,9 +742,9 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 				max(totlen_src, totlen_dst));
 			return -EINVAL;
 		}
-		if (sreq->nr_src > 0)
-			dma_map_sg(priv->dev, src, sreq->nr_src,
-				   DMA_BIDIRECTIONAL);
+		if (sreq->nr_src > 0 &&
+		    !dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL))
+			return -EIO;
 	} else {
 		if (unlikely(totlen_src && (sreq->nr_src <= 0))) {
 			dev_err(priv->dev, "Source buffer not large enough (need %d bytes)!",
@@ -752,8 +752,9 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 			return -EINVAL;
 		}
 
-		if (sreq->nr_src > 0)
-			dma_map_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVICE);
+		if (sreq->nr_src > 0 &&
+		    !dma_map_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVICE))
+			return -EIO;
 
 		if (unlikely(totlen_dst && (sreq->nr_dst <= 0))) {
 			dev_err(priv->dev, "Dest buffer not large enough (need %d bytes)!",
@@ -762,9 +763,11 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 			goto unmap;
 		}
 
-		if (sreq->nr_dst > 0)
-			dma_map_sg(priv->dev, dst, sreq->nr_dst,
-				   DMA_FROM_DEVICE);
+		if (sreq->nr_dst > 0 &&
+		    !dma_map_sg(priv->dev, dst, sreq->nr_dst, DMA_FROM_DEVICE)) {
+			ret = -EIO;
+			goto unmap;
+		}
 	}
 
 	memcpy(ctx->base.ctxr->data, ctx->key, ctx->key_len);
-- 
2.43.0



