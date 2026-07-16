Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7767742376D;
	Thu, 16 Jul 2026 14:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211334; cv=none; b=PYEw07JNA/PlFaDlAwE+FDTEYOFSJQqUn1CLBVLtr1X6aJkgqwe+8DnOr4HsSSmrqePaJXXOYMlH+v4DN4GV5iZp3kdASo6rgUS1qCjKBdm+23JHIO6GGriP0jgycXOI/YRPfnR/XqYwBGNcIXfhGpp18EzZKdfMW8Dt+H5EaTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211334; c=relaxed/simple;
	bh=SCKC6CEPxTU6vvWKfwW0lgiXLlteVVplC9wYbcqEpQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GurycOzIUBwaZc+krrEqqYx6BwxSgEt+bgC9AEDX/H6BRagYDVO4xRjQMZvMu60O2+GYdxv27Cifbvu9K9nM2MMK7EqZfFD3C/1/AWsy2b4Y7PmR1LxZgfQeVidXmmk1w2U8k2AqHkWLzwv4HiOOQUcvW9D5UJQa3gbqrSKUd+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSU0dV6D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSU0dV6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42261F000E9;
	Thu, 16 Jul 2026 14:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211333;
	bh=C8KwDOiqsgHsg3UUGaQiuKg6Rx81tSDc2zlz6vL7/Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OSU0dV6D3K3z7ABn1me2VtgHoUmrnCCqjQ76KlvTSy7Y0BSihRAHizAtem8mkL+h6
	 BPLCelo36CwNccWeJcJ+86Ist+7ByKt0EvU/GQVwbNJWAxoI8En3W5z9BOe5bDv5UT
	 1ZqAlxpPu7SYS+5kKasgmdl94vo+mklWkWJIWsss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Louvel <paul.louvel@bootlin.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 371/480] crypto: talitos - use dma_sync_single_for_cpu() before reading descriptor header
Date: Thu, 16 Jul 2026 15:31:58 +0200
Message-ID: <20260716133052.833424876@linuxfoundation.org>
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


