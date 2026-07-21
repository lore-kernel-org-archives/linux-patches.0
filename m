Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC1B35C68A;
	Tue, 21 Jul 2026 21:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668542; cv=none; b=gyV7hD2GlCU6vap7ttRol9/Pqy4k5U9yEHiJrZGaExMD1RSrcwCzoZsidm5Jf3ZdkkG7d9E3/slkNl9uLz13UaJ17PnvBXJQPV2aOBD8KuNnKrAWaI5jxkZzTDaGcJY+X8sfpFwaCscaJ5CERQ6CXChG8cVXqg+m5oVNeGrZFuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668542; c=relaxed/simple;
	bh=Km+uS/4Yqz9Lw8ecO+CE4Ion7gHF7Gh1WZ9VTrtmjhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/i3/NWdySeYH2t5oDy7ElfYx+aMV+YQmQph04AFFRGn9qrW73/yvwS1qir/lNseb5CT9u5az740H/+1D5nEjQfYm7zpZbThNiewhoHsudXpa5bJlF0W2udiOr9ULsCYHpvbnZz0Ji6GC2pmBAr+6qletqqQJBYJpg1LjDGh3eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OK2r65BC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OK2r65BC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1030B1F000E9;
	Tue, 21 Jul 2026 21:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668541;
	bh=uozlFWU40Hyh2PoPsVfDFmpIfzv9OQD70EAerk8XEpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OK2r65BCsA0RmN5yMPJxGeO57me1BIu51qyRYi878q88lgCt/7tGzBhQbDaFyMgCg
	 NSXOYeU4DiZ+9Xe2kxabn7NdWQPK+CJ2PHGxWhpA/3iVo1vlwCCTrItidCnEH+7qwa
	 uB9dooZsXvNNVV/l+K80X1SwdL5ZPY+nElCm9ScI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 0215/1067] crypto: talitos - use dma_sync_single_for_cpu() before reading descriptor header
Date: Tue, 21 Jul 2026 17:13:36 +0200
Message-ID: <20260721152429.408101492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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


