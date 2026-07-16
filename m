Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34A03D7D74;
	Thu, 16 Jul 2026 13:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209987; cv=none; b=bBR2SmVpS3mPLwj08S8TAHzKqFVhhGS5C4uvRGkSEqNtX4uTKoq1p0y8B3ANntyOcjUb2n3J/jwfwKFFIvYuqrHR76M9DFW80NMz0r1gkNaFOwj6OvcYMYc23uuBZarsyssF+89HjA1E4c8Lg3N0O9+IP8NURPUehGZbrMNivTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209987; c=relaxed/simple;
	bh=DNZ3PEjszTI3m6xMMDXLs34siUi/wRjaKA5WRfk5LBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEpXudoZQ5609k4vgCwVR/fbQ0GM6yXd6xwT1vfhvU9VFt7plGcFnaTithuJFmW3HJRmC837EKorvGvgdKrEEoPW3JM7JalxCmSshWve6M0xGGqFhkniiyOg73Yld9KaqBhQ/iArjCO9dE/AK801S2S4U/qsdCGk+keZWfT91QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/urYkeL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/urYkeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BA11F000E9;
	Thu, 16 Jul 2026 13:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209985;
	bh=mcmjR5qRUhK5IZBmWx6yVkMjASbizLUf+k858qts/fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/urYkeL+1TYgbtYv8exeI73phL6K0hKQojfwInLeQDDp+47aqZwR+YmzFfcTq4xp
	 0TjZnE9V3auj6+m2Y4i2xpL6C3y9vtzuIKHdixPve1nIoAnZOy9ZAuL1U3yHI9g39X
	 /Ze52blYyaF4izmsbdE1wInWEjTOtt6PergNHNpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 392/518] crypto: talitos - move dma mapping code in talitos_submit() into a standalone dma_map_request() function
Date: Thu, 16 Jul 2026 15:31:00 +0200
Message-ID: <20260716133056.410620037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Paul Louvel <paul.louvel@bootlin.com>

commit 5c0aa8cad7745505297103f05dda3fa06e8ac670 upstream.

Previously added code to talitos_submit() in order to map an entire
descriptor chain.

Move that code into a standalone function to improve readability.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/talitos.c |   75 +++++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 34 deletions(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -255,6 +255,46 @@ static int init_device(struct device *de
 	return 0;
 }
 
+static void dma_map_request(struct device *dev, struct talitos_request *request,
+			    struct talitos_desc *desc, bool is_sec1)
+{
+	struct talitos_edesc *edesc =
+		container_of(desc, struct talitos_edesc, desc);
+	dma_addr_t dma_desc, prev_dma_desc;
+	struct talitos_edesc *prev_edesc = NULL;
+
+	if (is_sec1) {
+		while (edesc) {
+			edesc->desc.hdr1 = edesc->desc.hdr;
+
+			dma_desc = dma_map_single(dev, &edesc->desc.hdr1,
+						  TALITOS_DESC_SIZE,
+						  DMA_BIDIRECTIONAL);
+
+			if (!prev_edesc) {
+				request->dma_desc = dma_desc;
+				goto next;
+			}
+
+			/* Chain in any previous descriptors. */
+
+			prev_edesc->desc.next_desc = cpu_to_be32(dma_desc);
+
+			dma_sync_single_for_device(dev, prev_dma_desc,
+						   TALITOS_DESC_SIZE,
+						   DMA_TO_DEVICE);
+
+next:
+			prev_edesc = edesc;
+			prev_dma_desc = dma_desc;
+			edesc = edesc->next_desc;
+		}
+	} else {
+		request->dma_desc = dma_map_single(dev, desc, TALITOS_DESC_SIZE,
+						   DMA_BIDIRECTIONAL);
+	}
+}
+
 /**
  * talitos_submit - submits a descriptor to the device for processing
  * @dev:	the SEC device to be used
@@ -273,10 +313,7 @@ static int talitos_submit(struct device
 					   void *context, int error),
 			  void *context)
 {
-	struct talitos_edesc *edesc = container_of(desc, struct talitos_edesc, desc);
 	struct talitos_private *priv = dev_get_drvdata(dev);
-	dma_addr_t dma_desc, prev_dma_desc;
-	struct talitos_edesc *prev_edesc = NULL;
 	struct talitos_request *request;
 	unsigned long flags;
 	int head;
@@ -294,37 +331,7 @@ static int talitos_submit(struct device
 	request = &priv->chan[ch].fifo[head];
 
 	/* map descriptor and save caller data */
-	if (is_sec1) {
-		while (edesc) {
-			edesc->desc.hdr1 = edesc->desc.hdr;
-
-			dma_desc = dma_map_single(dev, &edesc->desc.hdr1,
-						  TALITOS_DESC_SIZE,
-						  DMA_BIDIRECTIONAL);
-
-			if (!prev_edesc) {
-				request->dma_desc = dma_desc;
-				goto next;
-			}
-
-			/* Chain in any previous descriptors. */
-
-			prev_edesc->desc.next_desc = cpu_to_be32(dma_desc);
-
-			dma_sync_single_for_device(dev, prev_dma_desc,
-						   TALITOS_DESC_SIZE,
-						   DMA_TO_DEVICE);
-
-next:
-			prev_edesc = edesc;
-			prev_dma_desc = dma_desc;
-			edesc = edesc->next_desc;
-		}
-	} else {
-		request->dma_desc = dma_map_single(dev, desc,
-						   TALITOS_DESC_SIZE,
-						   DMA_BIDIRECTIONAL);
-	}
+	dma_map_request(dev, request, desc, is_sec1);
 	request->callback = callback;
 	request->context = context;
 


