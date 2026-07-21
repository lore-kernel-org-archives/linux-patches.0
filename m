Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5035B435A96;
	Tue, 21 Jul 2026 20:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665484; cv=none; b=WdhktUw1XQj2XVOnx2sFEZXtUko/U2eR7U5LzdfGr0W644XcGJIt9tDZTxd6XBV8JfbsKYS4CtkFZc2dz+M9BymDMC7Tr293UO6FFZIo+8QFgOEUTvcRpUl4Q8ODXE4iiIxUCKF/X2UKtEAVX/VZxftY0Snyqf5G6S/T67e7gao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665484; c=relaxed/simple;
	bh=WOcsXsQkvAKBIPpKRxF7byxRJuMq3TSqFRKvfyz9d3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZuccGIoiYpMRmDSXEXAm27z7TnToQS7AbmiIHcfDppOPdY4L78lpjcodw3ME5zgdp+7ENTFKAexw0Gfk3zRrtQSKpdU+s/VCR3iKsM3FlrwzlMcqCmpUWE/+9kbJQM4ltjPoNW8a0CSgyhRi+OfG11sZOp1ffy8gQHN+Vg/gXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QD552Ise; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QD552Ise"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5661F000E9;
	Tue, 21 Jul 2026 20:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665483;
	bh=zMNTYekhWlGcTQE1cBzlwBhgBs0bXFz8XLrODaUdsOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QD552Ise5TRBw8BG5g4D/E8ak6/ibK7ieBnh0pN4YJqxEEzSNsSovJXHjU58Pj+GE
	 BtSdK1yA5jBjRrLfwRxjilWv7+jHfYjbqS2YQgepxrVPZWePvDGBZjO8Samiy02AWA
	 StdYnkmWqGG1xK7Xr6MfXED9cpagdm/MOdCAO7Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 0278/1266] crypto: talitos - use dma_sync_single_for_cpu() before reading descriptor header
Date: Tue, 21 Jul 2026 17:11:55 +0200
Message-ID: <20260721152448.043300065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Paul Louvel <paul.louvel@bootlin.com>

commit e17ff3d6ff907dc8406261e8fd3e1fc8a908f0f6 upstream.

In order to know if a descriptor has been processed by the device,
the driver polls the FIFO to see if DESC_HDR_DONE is set on a descriptor
header to confirm completion.
The current code does not make sure that the CPU gets up to date data
before reading the descriptor.

Fix this by calling dma_sync_single_for_cpu() before reading memory
written by the device.

Cc: stable@vger.kernel.org
Fixes: 58cdbc6d2263 ("crypto: talitos - fix hash on SEC1.")
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/talitos.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -322,19 +322,31 @@ static int talitos_submit(struct device
 	return -EINPROGRESS;
 }
 
-static __be32 get_request_hdr(struct talitos_request *request, bool is_sec1)
+static __be32 get_request_hdr(struct device *dev,
+			      struct talitos_request *request, bool is_sec1)
 {
 	struct talitos_edesc *edesc;
 
-	if (!is_sec1)
+	if (!is_sec1) {
+		dma_sync_single_for_cpu(dev, request->dma_desc,
+					TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+
 		return request->desc->hdr;
+	}
 
-	if (!request->desc->next_desc)
+	if (!request->desc->next_desc) {
+		dma_sync_single_for_cpu(dev, request->dma_desc,
+					TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
 		return request->desc->hdr1;
-
-	edesc = container_of(request->desc, struct talitos_edesc, desc);
-
-	return ((struct talitos_desc *)(edesc->buf + edesc->dma_len))->hdr1;
+	} else {
+		dma_sync_single_for_cpu(dev,
+					be32_to_cpu(request->desc->next_desc),
+					TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+		edesc = container_of(request->desc, struct talitos_edesc, desc);
+
+		return ((struct talitos_desc *)(edesc->buf + edesc->dma_len))
+			->hdr1;
+	}
 }
 
 /*
@@ -358,7 +370,7 @@ static void flush_channel(struct device
 
 		/* descriptors with their done bits set don't get the error */
 		rmb();
-		hdr = get_request_hdr(request, is_sec1);
+		hdr = get_request_hdr(dev, request, is_sec1);
 
 		if ((hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
 			status = 0;


