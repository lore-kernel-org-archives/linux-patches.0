Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2081D521206;
	Mon, 31 Aug 2026 13:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183847; cv=none; b=GbuXSyoEXx/LEiBoHsfxGvlcPmXG6+R8ujTBqJ1V0FGHiHhEuvWMf6g0ZlBDZdblqE1ZxR46qS1PW4+jE3N+sNwMNoO+vuSyFcbTkJlGvCUl7rzZfoMIxQOCoHBCZEzr1ayNy+UhHv+rXc8L4xmc6E/AfLn0oUwUvu808LIlzQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183847; c=relaxed/simple;
	bh=BYDsKYbeCaX7stkiaoiB20MRXwntYSUQkO4lKm9FPhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmH+MM9PJFpfaSwdGqtQFffPtQsV1WGqeYZuOGppp/QLzka2ipTRiJdXW3inoXb8fFHIrGcOnBKdAzENIRZLNE2lUMUV18NNT1KRvCAw/cN7lnO0EKWVqkEEi+vKGxXFV/yfZk7tazAXYP1Wo9Z9DMPwkDgG7zs38W8htSSHCMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ez5lEju; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ez5lEju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A06F1F00A3F;
	Mon, 31 Aug 2026 13:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183845;
	bh=uFJhNddEplX6kqne71oSe5dC7RTjrvV9sav8LWmzv78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ez5lEju4TUq2KoUB7PKC2IumnebbnNOdxqcZgym/GkPF2FTKcok0l+e0l3/jftcP
	 Ac+qpdz48blSN2TG4NGcAzA+T2pkPZzDBQZD/i656YjjW2+lbmD7yojva3UtH57H8F
	 a34LtFLNWAU6wEwxrSa9Wnhfh4QOlQdNdtxc0Sxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 60/76] crypto: atmel-tdes - use scatterlist length before DMA mapping
Date: Mon, 31 Aug 2026 15:34:32 +0200
Message-ID: <20260831133402.560184010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit ba199bdaa80b09a7dd92f28751de7f3dbb06c510 upstream.

Using sg_dma_len() is only valid after mapping the scatterlist with
dma_map_sg(). However, atmel_tdes_crypt_start() uses it before mapping
to compare input/output lengths and to compute the transfer count.

Use the original scatterlist lengths before DMA mapping to avoid reading
stale or uninitialized DMA lengths when CONFIG_NEED_SG_DMA_LENGTH=y.

Drop the output scatterlist length in the fast path since it is equal to
->in_sg->length and does not change the transfer count.

Fixes: 13802005d8f2 ("crypto: atmel - add Atmel DES/TDES driver")
Fixes: 1f858040c2f7 ("crypto: atmel-tdes - add support for latest release of the IP (0x700)")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-tdes.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -463,14 +463,13 @@ static int atmel_tdes_crypt_start(struct
 			IS_ALIGNED(dd->out_sg->length, dd->ctx->block_size);
 		fast = in && out;
 
-		if (sg_dma_len(dd->in_sg) != sg_dma_len(dd->out_sg))
+		if (dd->in_sg->length != dd->out_sg->length)
 			fast = 0;
 	}
 
 
 	if (fast)  {
-		count = min_t(size_t, dd->total, sg_dma_len(dd->in_sg));
-		count = min_t(size_t, count, sg_dma_len(dd->out_sg));
+		count = min_t(size_t, dd->total, dd->in_sg->length);
 
 		err = dma_map_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 		if (!err) {


