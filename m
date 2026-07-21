Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0257F43E068;
	Tue, 21 Jul 2026 22:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671243; cv=none; b=QerMnzS+Np7VKib12lgKfLfxefVV4eu/hK3KWyYpRFvUuxe6HiwDYEb5CaECeXu+9NGZLZMF3Gn3T01ChgFp1DcBB+4LGpbXZwGrEc1cJHS/TyAzFCMEkqJeLMXwA6ayWAMGEYEAQzNqjHZfsndetVA1tbwmCIKojsGs+oK5eRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671243; c=relaxed/simple;
	bh=xmRzVXOf9T8jaHtDvnI99ETxXS3BZKQap6zbYVzXquU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ez859GRnq4PAJfA/4vh5AVmqXGLkwH2fplqPMj4Ykun5viGsEzG0fPEKuEmn81RGUobNHaNXQ20KnvvkVI0wTrmdgC7IiJc7AdlvBIrnzEYOFbeNbVW10ncwWMw3WIyXz/QW2WBu/Cq53EHwbqm5nDSyNN4s8WwTk3s63nPFWrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajIlPaAt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajIlPaAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A821F00A3A;
	Tue, 21 Jul 2026 22:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671241;
	bh=3699+mqANk6KfaX5itNetX4XNxi/LMQgYc1qaYMlkXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajIlPaAtUq6PMgoHVfGjxkvd55iXvvfTUQc1mE7gQO6ZnX1CQ+LP5R7EasBN624w0
	 CFgV/aSFJY4Nta6NvdN82iPpDRZeIUa2/E/e3RuKW42porc7vj3C02+ynI/0QDjTOx
	 IEWfjqqlnYaz1l9OSEnPoU6n5VKmO3fWquCnN9sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 170/843] crypto: talitos - use dma_sync_single_for_cpu() before reading descriptor header
Date: Tue, 21 Jul 2026 17:16:45 +0200
Message-ID: <20260721152409.842248893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -321,19 +321,31 @@ static int talitos_submit(struct device
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
@@ -357,7 +369,7 @@ static void flush_channel(struct device
 
 		/* descriptors with their done bits set don't get the error */
 		rmb();
-		hdr = get_request_hdr(request, is_sec1);
+		hdr = get_request_hdr(dev, request, is_sec1);
 
 		if ((hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
 			status = 0;


