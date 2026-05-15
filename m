Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F603E009E;
	Fri, 15 May 2026 16:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860906; cv=none; b=YQNYqWsXEIBNyo/ZxLU4FoU+siajqrXFYJsoEkXS2r9Bz9U93yH4mMUesdVOMz5KiJku1oiFz6GC5DQaANpt0lAoBZOeZL0B5m/yzFhQd/W9EqQCuzQAMEEopGwMtV7wZdcKPCmZE2JPXDstnSjX7YEdMqyb19mkRPhTgZG02kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860906; c=relaxed/simple;
	bh=kQgm33mcrXujH6VpPEQ9GnyVspYoEyOOh2LzaN77c68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suMsZ067K5R+eylkuf9XW6JloG12iZ9xOhX9Tuzl3iPIpc/isS4VQGpZP3imf8/skOj7jbEFsU+2Ck9HwRQTqgYObTEv7GA6yWI/pVQTb8rbgf3D3sWHYPEnQLVEODFk1mUuFivHgK00phJ4VPGZSgfz6J3ReZhVMMtYKwOloYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vaUYTOdZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vaUYTOdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BBEC2BCB3;
	Fri, 15 May 2026 16:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860905;
	bh=kQgm33mcrXujH6VpPEQ9GnyVspYoEyOOh2LzaN77c68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vaUYTOdZLuuOowISpzDqUTONGWCGduILWhungjgl1PnS2IXncOflJ+kbj4VrEBf0o
	 xH0U6n1oJXxoywzxUn3Rgmi/sT27J7l82cRpa2Tq/N016zzaIZBmFREsDE7C5nepjL
	 tP/0esX7wqqts9LHYgprSiNt8xSUgAtf9Dh2vizI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 125/474] crypto: atmel-tdes - fix DMA sync direction
Date: Fri, 15 May 2026 17:43:54 +0200
Message-ID: <20260515154717.737766275@linuxfoundation.org>
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
@@ -304,8 +304,8 @@ static int atmel_tdes_crypt_pdc_stop(str
 		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 	} else {
-		dma_sync_single_for_device(dd->dev, dd->dma_addr_out,
-					   dd->dma_size, DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
+					dd->dma_size, DMA_FROM_DEVICE);
 
 		/* copy data */
 		count = atmel_tdes_sg_copy(&dd->out_sg, &dd->out_offset,
@@ -655,8 +655,8 @@ static int atmel_tdes_crypt_dma_stop(str
 			dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 			dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 		} else {
-			dma_sync_single_for_device(dd->dev, dd->dma_addr_out,
-				dd->dma_size, DMA_FROM_DEVICE);
+			dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
+						dd->dma_size, DMA_FROM_DEVICE);
 
 			/* copy data */
 			count = atmel_tdes_sg_copy(&dd->out_sg, &dd->out_offset,


