Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1ACC3AA4F9;
	Tue, 21 Jul 2026 22:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673480; cv=none; b=Yb3MDPbBG/1VHg6XtwKZ4yxWMQvOhKQeBlwkg6w+yBl2WAglftJzrJ7woWilq1kOcgUqWGwJdDbyJfcKnVRpSt/eeRRKKTJ7ytji+9FjF4R6COWuhnrpxykcgXCWQTXMDC6zRhkxZ+uKSeauP4nKIwSf6lrVWjkBv4Be71n8348=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673480; c=relaxed/simple;
	bh=hQAeHjsfMQRY1yJs83qsC0zSEXX4uZBZxF5b+hlWocA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/lQcYOzYtN6t8kzARE7623bpoe3xhdfotanlBfnALeq/PkraqdtzKF2biyA/MmdIU2dV7bgP3xxurLrfkkMAu8grNvQPOie4ultXfgaSXDawQOC8UT1ABkkRtYKYBCeIM0YpGDXnJ3+Bm9cMhOBEUmWfpjS46SLAqHrpQDKXZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0whKu4H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0whKu4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B510D1F00A3A;
	Tue, 21 Jul 2026 22:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673476;
	bh=GlCVr5+WI4JFbW7AZePXSnP18g+9JcJ0HmozHnTsIfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I0whKu4HdvtYP0DSF1NcUQpyainxie+gMQFIx+sMJ+o1GIwEgiTq9oVGScNfdndwe
	 6UAvlpQwbe+yKzHv1jExsOaVUEJe2DcCxoTO/49Y3wvwvecARKO66FXmSAW47q12Un
	 tI8qTi/OTNZ9QXDXy2W0jhLdxLDfcGh7hvIueiDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 134/699] crypto: talitos - use dma_sync_single_for_cpu() before reading descriptor header
Date: Tue, 21 Jul 2026 17:18:13 +0200
Message-ID: <20260721152358.733461706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
@@ -320,19 +320,31 @@ static int talitos_submit(struct device
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
@@ -356,7 +368,7 @@ static void flush_channel(struct device
 
 		/* descriptors with their done bits set don't get the error */
 		rmb();
-		hdr = get_request_hdr(request, is_sec1);
+		hdr = get_request_hdr(dev, request, is_sec1);
 
 		if ((hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
 			status = 0;


