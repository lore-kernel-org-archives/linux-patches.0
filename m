Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEDE3C3BF3;
	Sat, 30 May 2026 18:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165827; cv=none; b=c4os+xM6BK/Ton35DblWmb0pcxqmKLIMrmjUfEwJlrQIlh+roLU20Cafeu2RihifCViCxTKmg9uIPZhUOCyYBbU9Pz5mcW+CV6zW5QxI2n6Eg6zX3QCh/efihlU9n0iC9wedSc1MHSwJCdRq7sHc4INQACP1wmUJ6V9JROajk0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165827; c=relaxed/simple;
	bh=bvz0PbgYyUiYRUKalitc4hoXioEgudK/aCLYwGfu6eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWINIGGH15Yndgvo4h3YZVOfGbn87Df8gjuPFD8Eu05XUZGoceoTR2PBOdwOXWJlL7OmKB6OLGVr6UA4o/FX30mtv2FinBCL8eT52Z36XOcwtX3jIoZUAJe9dPEUmxPX1NT/dpNSOhcMOZPAl3ttzrzyQd8ImF7eRT2uJkHX86k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lv5LESfT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lv5LESfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188991F00893;
	Sat, 30 May 2026 18:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165825;
	bh=kfhjwcKZA4ekQslUbQajEHUGJaCrTm1a950WbOTmysQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lv5LESfTObOTBpA02L6tBIHRIv07PKBmqIDk/l7H35nEf1LqWja3Xy5kJ4rzk/HOA
	 Kej9oIf0zPIjxenJQmb69++ZtQi9Wz6RMJltcspn1sdHX18YoMgNDwjlOBiPaqxJ/7
	 AjeDzRGc9mj3xNQ3iaipR4Dcrf1z3zfHoxHnFTKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 193/589] crypto: atmel-tdes - fix DMA sync direction
Date: Sat, 30 May 2026 18:01:14 +0200
Message-ID: <20260530160229.978958425@linuxfoundation.org>
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
@@ -312,8 +312,8 @@ static int atmel_tdes_crypt_pdc_stop(str
 		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 	} else {
-		dma_sync_single_for_device(dd->dev, dd->dma_addr_out,
-					   dd->dma_size, DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
+					dd->dma_size, DMA_FROM_DEVICE);
 
 		/* copy data */
 		count = atmel_tdes_sg_copy(&dd->out_sg, &dd->out_offset,
@@ -671,8 +671,8 @@ static int atmel_tdes_crypt_dma_stop(str
 			dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 			dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 		} else {
-			dma_sync_single_for_device(dd->dev, dd->dma_addr_out,
-				dd->dma_size, DMA_FROM_DEVICE);
+			dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
+						dd->dma_size, DMA_FROM_DEVICE);
 
 			/* copy data */
 			count = atmel_tdes_sg_copy(&dd->out_sg, &dd->out_offset,


