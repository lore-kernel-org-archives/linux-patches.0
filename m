Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7EA3DE442;
	Mon,  4 May 2026 14:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903509; cv=none; b=Rf+Nu+OM/3xN8Fp4FWI5cDmWAb9BM0o7P3Dh7NomBswv6zsDcFFnZjQSnOmyYxlUQTQCT6buGDye3u3P3+aihrveLRvWNHs0TMNHmZ9rA1kKg4n+bCumBqbm4bGpcxgSPcmRIaep7+3hFn4u4NuZz9UE9xHpFjd7qLWrTZA9nhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903509; c=relaxed/simple;
	bh=3HFd60xB4+NLGSPdBj9SnLHKlcyMteAS+S75Va3FLbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAcsBooqbChEO1bb6xpgho6VMl2r7kSeI04yMcobAmCj6sPR74yZ4FwddcW9/1uPYJDcEGt8PLzMKi5xYxspUD+p7VM/OHYuRtGmRS3nx+7Bfg62hmNedWFLKA3f4tgaiv15LGeb8OezlUynrY2Hd6RCpLW9CyZTfO73fVmpm3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzPwJYqx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzPwJYqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E07C2BCC4;
	Mon,  4 May 2026 14:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903508;
	bh=3HFd60xB4+NLGSPdBj9SnLHKlcyMteAS+S75Va3FLbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gzPwJYqxnkTQF5ePtS46Yg68hkmh53P+aRO81NLIx+O+jdUGNNzGC57fsV/rIdHGx
	 2Wv0PHOTUCPEiLN9lWEM1LEPUZvEI+6HmwQ0A+inA5B0R8irg3yQPph7ncvT0HNo9v
	 1uq0TsJSOOkJ7Hcr3UNI4V0HYQoCzlmpz6D3v5tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.0 261/307] crypto: hisilicon - Fix dma_unmap_single() direction
Date: Mon,  4 May 2026 15:52:26 +0200
Message-ID: <20260504135152.634154604@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


