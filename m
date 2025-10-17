Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AE9339717;
	Fri, 17 Oct 2025 15:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715410; cv=none; b=rz6hfvJsAfszSItF+q4twEjHlDIhRv6ohEzR7fE1/Jn65OaBVFNZnRIZir4gikHeT0TiEtTrfBLVn2wurhUUeKnrxIgwWsBhRUwCUaQiEN3fEQDKeUQamXqcDTZBbtq3Z9XbgDRCGE++Qlrc0IlPBwSnB739TW1u3YRnH6Kqyo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715410; c=relaxed/simple;
	bh=cildoYq5y6sdk+tpyoDrgMBRhpmZWb9+HiRaduBjxas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdEFtVWt6PlV1gkvN6bYcHZOFIs/s6weFwWx57BWHzOeS9RBQNqEb60bTYH7FC/ivSogNk40vy7Yarfs/BOzC81v/bnRWBr+x+0i8APO/O/3oJkJ56i9FxuEnlt2Q77Wp7gumz3Yn5ZVXXcGg7yGRskVr9GdtI5O3JW4crks2CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnkPW63W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnkPW63W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737D8C4CEE7;
	Fri, 17 Oct 2025 15:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715409;
	bh=cildoYq5y6sdk+tpyoDrgMBRhpmZWb9+HiRaduBjxas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnkPW63WATopuwjbjsY0mQEIwmuiBBSgzgfhn54UW1/l/j+T8c+grOneOojBUxxNn
	 ehQX9dPrBmFxeBvjwLxOEaU7UAzNnyT/j1BkPRvHkj7ghPxWV4fQCMC/qZO1WXfnje
	 cwYnRH+fL0CR4Gi2WUWr72vzL9igaM/Sh3Lk2d9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.17 207/371] crypto: aspeed - Fix dma_unmap_sg() direction
Date: Fri, 17 Oct 2025 16:53:02 +0200
Message-ID: <20251017145209.580300378@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


