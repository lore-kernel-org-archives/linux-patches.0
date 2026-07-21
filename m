Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D9D435A96;
	Tue, 21 Jul 2026 20:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665489; cv=none; b=VPwECeRE+iEuiXKmHjNme8spA4fLcFTwN7yqyGDa1CAddewiROIthDTPhdAI3LmkXRfBTpZV3NX/4vXrvIWiU0sSLeBY5kbFH3TFb3Bfta1/dO7wlbiJATxcfKKcvuNeD8fI+B7hRHYeuBehcse5U+3UlaZUQf9B79JpfHbVeE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665489; c=relaxed/simple;
	bh=jXZjLf9gYMXoBUXtohFvw9lH4SITtm0v4urr2BaYmJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jl5EnYukNvcTCZSFLL2avuuBnLhwdmrDQT27MF6CsZYkTWN+sZld6lCbYrip4YzClK1tqVjdwLIt7f1JdUSOKDAzpRgTrcZx0xSHCy6Dr7QlDs9LIXMMZ+sxP150GkBYjsgG6mUYBInsQtKOk/iMNT/1p0T68GG7qYTkbrKJJRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlEO7SxY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlEO7SxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081301F000E9;
	Tue, 21 Jul 2026 20:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665488;
	bh=XoaHPmVkY5R6HmqpH19zt9JCs3FBiH56J4kXHYs7YO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NlEO7SxYueYWnJfcFKMvMUi4pCrebWIJbr/y1X+7ioklR4LqyKPfQ9lRmak0W4i5d
	 Vypg0GXqoHG0UnDdWOio2WpuYuryjjyK5cedGc67DM2LBrNSZz2JuybQ+O/cJzXmVI
	 WYgI698gGiwFbkoTmvZaU/khRUJ7OGNEprx7nImI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 0280/1266] crypto: talitos - move dma unmapping code in flush_channel() into a standalone dma_unmap_request() function
Date: Tue, 21 Jul 2026 17:11:57 +0200
Message-ID: <20260721152448.088325662@linuxfoundation.org>
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


