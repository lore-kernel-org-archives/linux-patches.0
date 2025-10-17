Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777AC2F12D0;
	Fri, 17 Oct 2025 15:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714388; cv=none; b=kAk0aQdkRZN3aE5vvMUL5nivKyBUxaCD2+pirfiMyk2tugOhg7aDzpBbQQQFjGyv/VKy7ZvevT92AaX6H1pDXIlTX9GaOD2lNjMhlmAgojtZCr5+WKxtDpZaaVOpVlgxvA9hrD4ift8zC9Y6rVCSDLNcYCHVg8iWdymCccKupHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714388; c=relaxed/simple;
	bh=S/MXThZFr5NvVqMRt9V1ubHqakFOoL3t7qLKEKEAoDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKpW2HKDOqIVX9yp5es5jphCWnB1IkCJl2Q/RNf0F0SJZHXuUcmw3LsBMd5WnTd7KBSxH2DLnPnrUlmcBpdoKcI3g7dHD4QgqdjJUa6A86G76XG+oMC3MzG3ngpab6sHj0JYVF1CIdcJFe7iDqkcU1Csf1dZNZXTQFBs0NMn3B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8i42/Zr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8i42/Zr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC888C4CEE7;
	Fri, 17 Oct 2025 15:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714387;
	bh=S/MXThZFr5NvVqMRt9V1ubHqakFOoL3t7qLKEKEAoDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8i42/ZrgY2MlzsGVqxAZpUUmxyJV3hiK36HBfJBgmgVcBAVE/L3SiusciudVEA//
	 X7e564i8f7fLPhTz31sMJ6Hx/VlJ5In9qF1ES2dkOS+l/BfiL+8xGqEv0A19Gx5uai
	 hx8jwZN5tYFgMrNug2AUzjn0+Lm+D8c9ljXhu4W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 127/277] crypto: aspeed - Fix dma_unmap_sg() direction
Date: Fri, 17 Oct 2025 16:52:14 +0200
Message-ID: <20251017145151.765147109@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -346,7 +346,7 @@ free_req:
 
 	} else {
 		dma_unmap_sg(hace_dev->dev, req->dst, rctx->dst_nents,
-			     DMA_TO_DEVICE);
+			     DMA_FROM_DEVICE);
 		dma_unmap_sg(hace_dev->dev, req->src, rctx->src_nents,
 			     DMA_TO_DEVICE);
 	}


