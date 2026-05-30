Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF1B3A3E74;
	Sat, 30 May 2026 16:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160159; cv=none; b=L8v4Qn99AEQ1Md3cLRx0DD2/saC9LDKiVkbZGJaQh4zUcYK/lh6Z94mB3/3JojELOs1FgyQUW17R+t9It55x5EApgy9TCyxLfDI2eda85JFTfV74Qdqmx3b12D2oEPoY0eXpwI6Za6NFEWNALQDNmZS9JzHpFSNxgPZVgXuTFU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160159; c=relaxed/simple;
	bh=vJvBM/tylpqCZ39W6pxoupXeRhQ0h/x41PlhNKsaglg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4UVp4dE6XudS+BG18QfL5lByFsva27cCPvihhnsRIsCWCCYG7WXwzGEclvZdIuTzLxTDEwLhIZrBDvNvhL2pOftZbAMAlnun+kWYMVEwCim0NRzambA8qqZmCVKne7JYHTUPSg/1IZDDuxWw1sl2VuZFmQaGWCpqsa9lf2dYFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zeKRixlh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zeKRixlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25251F00893;
	Sat, 30 May 2026 16:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160158;
	bh=Uz6FjJsna7pDxky92hwxi48V/T2EoeJoi0qPH1faY1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zeKRixlh4/T4FwvLVtBA2SADQw76IrXvqbO73h0DQi3NHUoYjUBnAQPbQ/xOxTJ7R
	 8fqmOjYgiBk9yiAL4oh8Gp50MYfTD8bvStD1a5IWc749OdmLfJJmV09mo9ylGyDvse
	 00MfycKfXU+YzbdADD+yMk35kNS2tngfza+4gfK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 260/969] crypto: atmel-tdes - fix DMA sync direction
Date: Sat, 30 May 2026 17:56:24 +0200
Message-ID: <20260530160307.660078434@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -660,8 +660,8 @@ static int atmel_tdes_crypt_dma_stop(str
 			dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 			dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 		} else {
-			dma_sync_single_for_device(dd->dev, dd->dma_addr_out,
-				dd->dma_size, DMA_FROM_DEVICE);
+			dma_sync_single_for_cpu(dd->dev, dd->dma_addr_out,
+						dd->dma_size, DMA_FROM_DEVICE);
 
 			/* copy data */
 			count = atmel_tdes_sg_copy(&dd->out_sg, &dd->out_offset,


