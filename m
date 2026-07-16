Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8E73D7D74;
	Thu, 16 Jul 2026 13:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209984; cv=none; b=Cc1nuy1HY1H9/h1vqoZClmznwNCEF+BERgS2f579Sagoc3KtmiFpWjrYo8RTX9GUNqX+rfdNyDcL+C4WZVsT9F8UHcsLacKW5AwlcmBCjDoUEiNL3LQkfNLUk5bvV7IV581BM0qNufzjC74vgdW3ojJ8RFkkLJLvf0CShQmzdSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209984; c=relaxed/simple;
	bh=iEXTXxj+nnuJ8HI4WprAOsbUhX81ndXPFks9cRGEZY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rW5OowxmiW65Mb65N1EklQg+6/QffXwkJ29LH7JikGlgFYjm28RsvuZA0nmmDd3SuNbkdr/WlP9sEpA4Obvoi1ehGWPVxftAZDHfiBIMwmz/DgO67ZfB4wjQfjIS5kiuoYfIMzyafUEl9GyRE5MsTyrPvexjyjyKq6UtmhfL88s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saJ6GEde; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saJ6GEde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2DF1F000E9;
	Thu, 16 Jul 2026 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209983;
	bh=GGdNPyop7PRz2wsVKIuLGbJy7I1WZW5QpHfkpj1n2YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=saJ6GEderohWuU9qvE6JNGNRkd7m64TWvUd4RZpbmzEJueU6XtdWgDyytQkl9PUj3
	 oVsybW0JfM326L2+6pV+2Vl4/USpoMaiEqzeIc0MvcTuS3h33GsHhKGy6S3J7CH9tP
	 GZscKynSNkU61pggSkFEAH/7G/qp6H5iXERvCtJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 391/518] crypto: talitos - move dma unmapping code in flush_channel() into a standalone dma_unmap_request() function
Date: Thu, 16 Jul 2026 15:30:59 +0200
Message-ID: <20260716133056.387362081@linuxfoundation.org>
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


