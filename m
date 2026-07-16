Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB93435520;
	Thu, 16 Jul 2026 14:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212454; cv=none; b=isjjODt4uo3JczAPYdn+hQOOJXVy92umF+iYM7Y0K3ShJE+j0Cf3l2ewIfc4RQADa1RBeejN7+5feqY2JbpWnz+sdQGN5EY3egVxZDwjHt80mM3OMYAZ1JpdvkLKOeI2dzs1WHFSrr/KvtjnWl8sJWRYwuaRX28JqKq4/iH5mXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212454; c=relaxed/simple;
	bh=mQWfdM3yAFNkO30DRvk1hhH8I397qAds9j/TgbF0hv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0w4z+V1alUH8QbeJ8Mn5VItyjt9dyLjJ7awFR9N5StCSCzCtD/531o9ddFdfHj5513dzajFX7EuKjWqO+xX3okHKdpn5DywMIYo2JswdrXNL0dw2kucK4K5hEgtkGeEM9JE5fzXfEs62F7sFtbjND/gnrCNQ4I1RuX+PJ3qY3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=asW+hrlK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="asW+hrlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BA91F000E9;
	Thu, 16 Jul 2026 14:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212452;
	bh=t+M3UAAA9f8/pYrOr7hn6UKaCNoVsQAr5zYT+nJyb9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=asW+hrlKk9Iz20w2sf40dnLUF8/UaAbeXaRJ8NzUTUK/xNsfK5m0NqCd2Hmpp+ER+
	 B87R6CVYEJujJgTGvYe27m6z5Vbp7GqN+UrwEUijmyhn8Wqji1jLDCl5k2r6Gf3WaB
	 HOnW6eGWCbyMpLEt+F8ih11lrLnkmwauWniNbwik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 289/349] crypto: talitos - move dma mapping code in talitos_submit() into a standalone dma_map_request() function
Date: Thu, 16 Jul 2026 15:33:43 +0200
Message-ID: <20260716133039.797083246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
 


