Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31015320CAD;
	Sat, 30 May 2026 17:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163423; cv=none; b=J74owcuTEY4ezBn5Pnp31hWBJRiVQpbKikSXAlCKus7PjiKRABJBomGIsXwilAklxZqNwjhGavS5a+mphJ2eHJ9Pq4xDVB1HKSPUJFAnLfdFbX9aYcFspwD0rv7zWJrPIOccV1xJfnejHKXv92Bibn/e+n1O/DhtVnTVYLAlmig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163423; c=relaxed/simple;
	bh=zfxaCAQCztBhNgaRJA2FxreP9xn3hTotN50jyTJeK20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pb6264zHcRtBNxLbP3PLvjP3peWZVv2PuRIPU7t3qEhMaEzkctOn5DtBXvE3HqdZ/WJKg6jI3h8pcntrO5QUi0sFR25MtlQqa3NrsrBZ+0oN5iYfndXSCSS8BHMKi3RdyQLI+4dawLvciT8pspQP6+nOzofCnVnywB9NHUlgNcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtAEw1dU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtAEw1dU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A5E1F00893;
	Sat, 30 May 2026 17:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163422;
	bh=DfOfz5wYvEOSKjzx4IXSc9F9CT4ehgnAq8ufLRRq9Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gtAEw1dU0iXpIvIiBV5VCXBbmgiMoErTqcy3ZwWHgFrwFFzhSzpFye+hJcRZv/7fv
	 mc/HPDYND0GZgMDE8p5TVWv/gCCuuNhcoxBwVnzvybNj8p6AEmv/iAR0fv5eUq9N60
	 I5NE6X6X+veaxYvMNnxdOW0LmWsgfR+V5PivLLco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 253/776] crypto: hisilicon - Fix dma_unmap_single() direction
Date: Sat, 30 May 2026 17:59:27 +0200
Message-ID: <20260530160247.071160049@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


