Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1C32F12B9;
	Fri, 17 Oct 2025 14:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713177; cv=none; b=S2HzXPmUwIVRLvUndIwjhwgFHXPd2V4tsy6vMK94WKxiLYlDhmDzbBY9jPqG+mkuy6gjZgViNbTdyf+Yx2NR8P7if2u47ytuZP6sNtlMCjGQzhCwozAIDcn3vxgO6fRvyxi1QcCc6NMpU6Ad88+o1FX+HdqEye8oh2IpvYLgW3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713177; c=relaxed/simple;
	bh=ilp1mUPNqHCCRBjx5FgMYUH34hI3cdsF8h3WXFRuapM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fooxAl1K7mRCajTdgk9O5hxzEJwwavcW9Jkfx3Dgy9TWE3pqDzvL9m+ZGEd1X8fGbaieS/M0wEl/5ZmelKqKqq9yb2ZeFxPkI8QOYpnBszbS4FSOfk+nfrn3upGtCAjLpCx4Vibv8PMKUbzF5oZt7oMv5oFTtmQG1BqOcOXyy5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/RNOWxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/RNOWxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7BCC4CEF9;
	Fri, 17 Oct 2025 14:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713176;
	bh=ilp1mUPNqHCCRBjx5FgMYUH34hI3cdsF8h3WXFRuapM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/RNOWxZTWUZYpvSw6Z6DqOMSH5G6eqsBxegm+GFRwY2W/TZO90JIk0UHJN7HDMtU
	 n8eX6cwfgZ5kjlZXo/1FnLwemR7cuaBqbAawJT+cCod306lNK1Ws7WGqodU+Hf2oGd
	 PjSG1b9ZOOej/YWaI+raq6R+ag2RE11iAHuZIkec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 074/168] crypto: aspeed - Fix dma_unmap_sg() direction
Date: Fri, 17 Oct 2025 16:52:33 +0200
Message-ID: <20251017145131.754703464@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 838d2d51513e6d2504a678e906823cfd2ecaaa22 upstream.

It seems like everywhere in this file, when the request is not
bidirectionala, req->src is mapped with DMA_TO_DEVICE and req->dst is
mapped with DMA_FROM_DEVICE.

Fixes: 62f58b1637b7 ("crypto: aspeed - add HACE crypto driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/aspeed/aspeed-hace-crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/aspeed/aspeed-hace-crypto.c
+++ b/drivers/crypto/aspeed/aspeed-hace-crypto.c
@@ -335,7 +335,7 @@ free_req:
 
 	} else {
 		dma_unmap_sg(hace_dev->dev, req->dst, rctx->dst_nents,
-			     DMA_TO_DEVICE);
+			     DMA_FROM_DEVICE);
 		dma_unmap_sg(hace_dev->dev, req->src, rctx->src_nents,
 			     DMA_TO_DEVICE);
 	}


