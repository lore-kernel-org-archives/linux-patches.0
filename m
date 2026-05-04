Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9653DE44F;
	Mon,  4 May 2026 14:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904213; cv=none; b=R/pj7LpyEktZwJVOILIooGUE5HnxBHbYZzmPU71EhDZuLoJrexvb3/PDl7nvEuAUOilPNaQ0G6pAr8jV+/N4DCMJxSR+d69rbuRM+pUw4luCHrfyoF57OrwAdDp2jWmbQjgV3pGfFLEXPswnGXPQ55DwYJV++FYR/QDlQiNj01E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904213; c=relaxed/simple;
	bh=K2fxWY0C2Gc3VDfDhUWYReZO6lOSqwVwVHmqIh+QxrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pfu3D+z9qIUPl5nMZwtyW7sLnt1BWG6z3EQIgZEqtIXjCstYVV6xHVUwXevXX/MPWUCNjV7VwcehfyswfzNe+KxJKKNfVdnrceJjPoHECRmU0pFMvxbHoeQZU4PfIY462lsHIgEHnDMF0ndIHVE5zBxh9E/b8Q6VKLqAA+Mcq6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8DM/d06; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8DM/d06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23916C2BCF4;
	Mon,  4 May 2026 14:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904213;
	bh=K2fxWY0C2Gc3VDfDhUWYReZO6lOSqwVwVHmqIh+QxrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S8DM/d06nV9Pd5j/a1UWhkN2ZnyaVcpxPc7bTIJKJoDAADJBdkSFRqQz9jhM/pLZm
	 J33YntwixoNsIg1RmbxieUl/1M2X0/kDhrFdnmPnkSNXQyUk1ES0a/HpHTEldCG7cV
	 s9fYX+fFmWvWSXIshepW6XxvpNqxw+GqCoJWLcJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 226/275] crypto: atmel-tdes - fix DMA sync direction
Date: Mon,  4 May 2026 15:52:46 +0200
Message-ID: <20260504135151.459688019@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit c8a9a647532f5c2a04180352693215e24e9dba03 upstream.

Before DMA output is consumed by the CPU, ->dma_addr_out must be synced
with dma_sync_single_for_cpu() instead of dma_sync_single_for_device().
Using the wrong direction can return stale cache data on non-coherent
platforms.

Fixes: 13802005d8f2 ("crypto: atmel - add Atmel DES/TDES driver")
Fixes: 1f858040c2f7 ("crypto: atmel-tdes - add support for latest release of the IP (0x700)")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-tdes.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -294,8 +294,8 @@ static int atmel_tdes_crypt_pdc_stop(str
 		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 	} else {
-		dma_sync_single_for_device(dd->dev, dd->dma_addr_out,
-					   dd->dma_size, DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
+					dd->dma_size, DMA_FROM_DEVICE);
 
 		/* copy data */
 		count = atmel_tdes_sg_copy(&dd->out_sg, &dd->out_offset,
@@ -619,8 +619,8 @@ static int atmel_tdes_crypt_dma_stop(str
 			dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 			dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 		} else {
-			dma_sync_single_for_device(dd->dev, dd->dma_addr_out,
-				dd->dma_size, DMA_FROM_DEVICE);
+			dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
+						dd->dma_size, DMA_FROM_DEVICE);
 
 			/* copy data */
 			count = atmel_tdes_sg_copy(&dd->out_sg, &dd->out_offset,


