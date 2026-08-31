Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6039F4334A5;
	Mon, 31 Aug 2026 13:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184378; cv=none; b=X319pSh10H5axc8eLvtLO5Fzm36g+X6ZqWWwRTTPhpbbF6m5MAPEwAwijLBSwp2f6OMzFeVD0+G9oArol7M1NSPvvB9OSMGFdGzXgatfJhTogL3tI/ZmCbb2b+wjWOqclOeVfRJKELR+zMiQDG9hohMg5UTHeT55JuMXBHXXmys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184378; c=relaxed/simple;
	bh=0PVUF02z1VdH/2zPWz9XF8RYHkzdNIO/i+j5ah16vIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrP6sAOqQhjUTzpK4q4MY8zGJwN7ug5bj48L/u/WizhkjdStSQkCphqNisLQGUYawjpsivgKIDVfVXJJcQri2qKVfCoRTb7vqIlM9+QRXB9B7BStP3JKa66QSALoJ3mt16EXAWmqoJ22CqZV4Pc48SVa/Ej3UBSd4T903BRgtQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k2KRzc/5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k2KRzc/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEA51F00A3D;
	Mon, 31 Aug 2026 13:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184377;
	bh=w2UtIRMXkmzWKLrDpkmRzKZ51dUwMMvCPVxTOQhtSeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k2KRzc/5A2b0GlpKyuDehBf8hp9wekjP1ziKEFSgz5qXYSUpZrApjC5wpWYYMwG5A
	 JNJ0CCaS5Xs1/CTS8lHL8sgrN/kt1xtM4IO65jo5vKnCGw/Hf2FGfSe5lmQziwlAMk
	 hmfLiGZfehVakG99YeU1bZ0Z1hqPSeQwc//4dmmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 86/99] crypto: atmel-tdes - use scatterlist length before DMA mapping
Date: Mon, 31 Aug 2026 15:34:55 +0200
Message-ID: <20260831133404.099875871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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


