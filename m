Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B614424D75;
	Thu, 16 Jul 2026 14:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211392; cv=none; b=ibF37Z3Y13k+3ge5FgJBXYvWOMxREnoKGuZyNHfmP0IFLSRvE6rD0QnzU/RvxSQOgJsbdKM63NAHKrFKcFmWZBnTsfnsAXl8hRr5w7d2yaDm+iWTfj5I61PwppCtp9PwhAU6uZ8IBnzhZ5XUMLylcL9iASIRaZP7f7P1l5Re1CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211392; c=relaxed/simple;
	bh=P7cUw6hSMf+px9VvtFxl8+k5KwCs7ormMUE91vamB1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2CREB7XNuCyLmgeXXeuNOfpi9Fok8SBEHKp3oeeea8pqdM6yuK/qxln9V/e0xXCPO5HvypHWYpZsn4AuOI8qnTsUw23omUvGzlSEQ9D/1ZQSOufsOuVw+rarskOCK2nys+mb+SFPTkFBODFE+uokT8dR0T2dnxiLsfBjAuFNBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XheIynSK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XheIynSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854401F000E9;
	Thu, 16 Jul 2026 14:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211390;
	bh=rkcu0ItZFAXPSYdC62UD/My2MyixkJ2C4g0Sk4EDe0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XheIynSKyXnL/9HIDuLsl0rK1XDTKHE/gPKHISYNHa0O2C8bMNpkGRyn5qvW1ps07
	 fJsL5F+7NDpNwFLxYiKvWc7wKQjDX4SOmnvBCU87yu1sOxdwh006ZX8NRyuNOsVVQ6
	 W0zKN48DyH6SXyoIvJPPco4SawRjztHlsQ9ISZiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 373/480] crypto: talitos - move dma unmapping code in flush_channel() into a standalone dma_unmap_request() function
Date: Thu, 16 Jul 2026 15:32:00 +0200
Message-ID: <20260716133052.876979136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Paul Louvel <paul.louvel@bootlin.com>

commit 4d9b0b7415b9e79a3d54d18b5ff230974ea78740 upstream.

Previously added code to flush_channel() in order to unmap an entire
descriptor.

Move that code into a standalone function to improve readability.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/talitos.c |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -372,6 +372,27 @@ static __be32 get_request_hdr(struct dev
 	return edesc->desc.hdr1;
 }
 
+static void dma_unmap_request(struct device *dev,
+			      struct talitos_request *request, bool is_sec1)
+{
+	struct talitos_edesc *edesc;
+
+	if (is_sec1) {
+		dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
+				 DMA_BIDIRECTIONAL);
+		edesc = container_of(request->desc, struct talitos_edesc, desc);
+		while (edesc->next_desc) {
+			dma_unmap_single(dev,
+					 be32_to_cpu(edesc->desc.next_desc),
+					 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+			edesc = edesc->next_desc;
+		}
+	} else {
+		dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
+				 DMA_BIDIRECTIONAL);
+	}
+}
+
 /*
  * process what was done, notify callback of error if not
  */
@@ -379,7 +400,6 @@ static void flush_channel(struct device
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	struct talitos_request *request, saved_req;
-	struct talitos_edesc *edesc;
 	unsigned long flags;
 	int tail, status;
 	bool is_sec1 = has_ftr_sec1(priv);
@@ -404,22 +424,7 @@ static void flush_channel(struct device
 			else
 				status = error;
 
-		if (is_sec1) {
-			dma_unmap_single(dev, request->dma_desc,
-					 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
-			edesc = container_of(request->desc,
-					     struct talitos_edesc, desc);
-			while (edesc->next_desc) {
-				dma_unmap_single(
-					dev, be32_to_cpu(edesc->desc.next_desc),
-					TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
-				edesc = edesc->next_desc;
-			}
-		} else {
-			dma_unmap_single(dev, request->dma_desc,
-					TALITOS_DESC_SIZE,
-					DMA_BIDIRECTIONAL);
-		}
+		dma_unmap_request(dev, request, is_sec1);
 
 		/* copy entries so we can call callback outside lock */
 		saved_req.desc = request->desc;


