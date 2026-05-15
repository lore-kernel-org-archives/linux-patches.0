Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBFF3B6354;
	Fri, 15 May 2026 16:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860900; cv=none; b=SV2czrZmiWRFp7otDsvHGV2prAE1pGvDsAyV5bral4Op7e1gzBHJQANeDxF0xCMjCxQ/pJIjYtRRyGL+OdtkIQfHRTvoKmyoTWHF/fjna9r9ewd8cmygIykQD1lVT3S9pjcghPwXfgGjWk/ajLU0RLeR37r5D0u+O98kvJBVhDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860900; c=relaxed/simple;
	bh=oehfPnm+lki+DoDRA5x7v3i6PAW8yCCSK3Xz2Ci61Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGytRPKAIVz+NK8cTEBXWmTzQSWkGcC587IQq2eozUiLI4cid0z80UElShF8XqIOhWtS9zGSwtXo3K5HeWwDn9jzzVyp5UWv4c+8QXntjYFe0QNSx71tEDS17ioiYBx+kRyd7nOMzvUcgOPo1anSZ3cvQrHxW1giFK1884mwbXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RySaGxoa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RySaGxoa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD76C2BCB3;
	Fri, 15 May 2026 16:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860900;
	bh=oehfPnm+lki+DoDRA5x7v3i6PAW8yCCSK3Xz2Ci61Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RySaGxoaxgZSHonSuY/F95MsgiRCws2ieq6OMyEnLj0n94/oPguirKvMFUSUaEKAv
	 LYllWUtyqXKb4rYQ6qHl8sPq0yPI0MJwEnU8QZxK3OlfXv0Qin3RAO88QiWWvAAsr2
	 t2FKUYPUIT+AXFgQJmZOmPtowx0LlBuow1hwe6CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 123/474] crypto: hisilicon - Fix dma_unmap_single() direction
Date: Fri, 15 May 2026 17:43:52 +0200
Message-ID: <20260515154717.696805987@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 1ee57ab93b75eb59f426aef37b5498a7ffc28278 upstream.

The direction used to map the buffer skreq->iv is DMA_TO_DEVICE but it is
unmapped with direction DMA_BIDIRECTIONAL in the error path.

Change the unmap to match the mapping.

Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/hisilicon/sec/sec_algs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -844,7 +844,7 @@ err_free_elements:
 	if (crypto_skcipher_ivsize(atfm))
 		dma_unmap_single(info->dev, sec_req->dma_iv,
 				 crypto_skcipher_ivsize(atfm),
-				 DMA_BIDIRECTIONAL);
+				 DMA_TO_DEVICE);
 err_unmap_out_sg:
 	if (split)
 		sec_unmap_sg_on_err(skreq->dst, steps, splits_out,


