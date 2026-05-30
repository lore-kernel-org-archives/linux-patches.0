Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8242D3A7848;
	Sat, 30 May 2026 18:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165819; cv=none; b=hwtckDSq8EsPxFo/xFk9+H2eTununCinr10O+PKcjJam7j1xZCVWC2NRgc/0xWZrnmTnr2YRCESKjV5koOTpyaSsb8LUZO8SfQ894pfxles9qHwF16Z53k9xS2mqfKJpJFcMLl2KI/J0EYOwjxf74czwgJm6jr/hy52HQ6YR3dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165819; c=relaxed/simple;
	bh=sP8JCz4dUJCqte8hnU8VCeOLGdn0sK5npwb3fq2CkSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNu1A5JTNDDxT+2geZPkZY5jH+ybLS/LrI27nUQkXxXUXcM6TUKpkvRaztJgJnXCU6+qk/XCoTRqcuM1PBPWHbGIe4lJwRlO1azImegnAV1qNJvGwDx9nDHOyO8K7liJjZJkO/6EIeWKb8I1i9r7NouOcAlzEmeNlLOhbNmArqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Sdm1AAj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Sdm1AAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371541F00893;
	Sat, 30 May 2026 18:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165815;
	bh=FtMRvU74lpib0VrHOAwKFLnA7Nbibfg6WvJaQJF8aes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Sdm1AAjPW7GLx2UyR3Wth3lBAZRmojIMYG3N9e3OOm6phexA0z/bmOpXas9La6+C
	 XP14H+clY4Uk0eJ3Z02QcLdx5pdd+bo28RvO5cH11u7fvCginCidLiYYmuXHjbr/2M
	 IMflUk1chtp905xkk2B0Ole9qzXTiQW6K3n8PesA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 191/589] crypto: hisilicon - Fix dma_unmap_single() direction
Date: Sat, 30 May 2026 18:01:12 +0200
Message-ID: <20260530160229.927015156@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


