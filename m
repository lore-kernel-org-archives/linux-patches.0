Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465C24E66A5;
	Mon, 31 Aug 2026 13:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183608; cv=none; b=UupxjZW1J9cCr5B33ura6x5TQh2ObPTFYyiS/0dflDr9txfj+/neJ1uliE55jIApI9fOAsLBhaROsWpHril9nL6eSxUH24PLPjHz3qfr7wQZUHBpza3dV+qmnL7QrEXJj5/xxNRSie1g2TnSaubrmXn6iBOPOSoe351pRxZnCzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183608; c=relaxed/simple;
	bh=FqDWrUQyaQEOsOypeiOXUac63Hy3SJWmlgwPCQBPOlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cax2gI8+3NyoVgySxjwobyXx2RkjTSyI+wJMsa+HQqA3sWMxfnWGQ5bPxUOYf9yLd013WdAFu/K3g7rhHkHCS/TBFQH2hPPQYIffrb3LrNIfHzd3fU65OROvU/jxTe6l3dW9+Tkkq24mweI3EhE7uw0zrWjWIOVXbZjuuN5Z3oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFvgvFfL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFvgvFfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD6C1F00A3F;
	Mon, 31 Aug 2026 13:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183606;
	bh=ex4NCBD3QmiAXPmSaoAOR8Iz6X6omIKmtm+G379kSPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFvgvFfLFbbQ/5hVr+g/QkMRp0/A+AcZME8WNv5sTsvwMcgSDusR3FEhAgUvglZCd
	 TzjW5+7P+K11Du3/AnO6tOVJARdsVE4diYMY0MeOjMwYCVeZ0+05saEQbDGeG582r5
	 tg/at6V/WkJXomwByf/fRXAjIgWgYTLioxqcFIRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.2 55/71] crypto: atmel-tdes - use scatterlist length before DMA mapping
Date: Mon, 31 Aug 2026 15:34:20 +0200
Message-ID: <20260831133402.090054031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -462,14 +462,13 @@ static int atmel_tdes_crypt_start(struct
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


