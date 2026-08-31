Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6839568FC3;
	Mon, 31 Aug 2026 13:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184092; cv=none; b=DqSSp76i0nwn3jiRYNm+M8O3vnNWuz8P7zxd8hFoc5bdyc27WZCsowNUl4mj1jFg8EO/DH+W4lSfpkEoMywB3T5hERudjkZaDtRowBzYtxZZEIrOE4JtlRlI8BJ+W+6QI3QVWyHaLDejqL9SUixkPZE7EirI2nwHADYEckDZytk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184092; c=relaxed/simple;
	bh=M3Nkf85gxkoWPTvhe23mPCNu+ZUk01d2Ti+d1gBfQMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXPNVv1U/HYaDVl4JcFo6q1SkhRO6BuQhbfoggFZ9gH+wtK9JGMT9So21z7h3A8yBmddSfnP2KVZnEzUZSCyyFF0i33PFf/a4ZrK0peikQPv7FllMIIGgOLg87VLq+Wiwt5FR+yWp7LmrZEXUbobCOnqOiINgxZFSIcvLZ1F8WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKcq7LuF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKcq7LuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8EB1F00A3D;
	Mon, 31 Aug 2026 13:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184090;
	bh=mFe0r0riNApK4iarPwVkl1ZbZThJ2x4Bmd1diZAFqf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oKcq7LuF+tq6OyJ3CKeomULUoBin7mCgMeE4hSqgudMSe2b59XNen7tnw+m9qjpAV
	 LvoJuKFzMmzJUi9YBGDg+LLY4psxejfsudMbo8b3cSOhPJVuI1CU0nDTMtdNRMNAPi
	 x8Zawp6qYZQ79RKhNS6jBj4ibpHHyc0cK4OUtZQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 69/83] crypto: atmel-tdes - use scatterlist length before DMA mapping
Date: Mon, 31 Aug 2026 15:34:45 +0200
Message-ID: <20260831133402.995140173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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


