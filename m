Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B376472F8D;
	Tue, 21 Jul 2026 21:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667675; cv=none; b=sHbvt1cxRaefqjAvnzF88kNa10Bkj2V+gTt4hbHe4t7TPkfE7UnSeCq/qtnDbSnkCAM4ymk7m1t6zG/Dn83b/rUbRW/dhJCBN1Pp+cQBXQm05RKVBpsh1kPBqDExqIZcKmq7/fsSyc1SyXBtQpY1Dmg3fehbsmMegW6I4yaMrfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667675; c=relaxed/simple;
	bh=NL3j4elEYO5mM9Fra5q837QQXgqLIBUxgMGj2WqetpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfx2SreEbaXJ7+5TuddCdAHD9RDgeyY9ikhlK/5o7eShDNPzVO8Gn/TK4SgL2q7LEDcMl/fm390LQuAw8wowecJSZQgd60b6buCIQif6+5wF23tm1VXqsgsXQ6PEg5J2NtQChlkKsBKAr5kgNX3UvYYn1X8I5qMVblQAc+h1fys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q39g3m+o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q39g3m+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161151F000E9;
	Tue, 21 Jul 2026 21:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667673;
	bh=tFVNsH/tN64kyqhIDMcCdtB1vQSMoaTfUIrmoNcZXX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q39g3m+ojnES04U6dYBbGX+qGszsgGCPBYy42gJ7/dUmN3l9Ik/kYbWRBN8Nq44he
	 sjolkgo4IGvwBTPFGDUu3r3JbuFAVm0PUxfkIoBLgrbZuWDeBWesw0sQGp8mXJhLvb
	 kN6J1ZPtWeRLpp0tcFunkU4Pf2meq4GHRmJJ4FsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 1148/1266] mtd: rawnand: lpc32xx_slc: fail DMA transfer on completion timeout
Date: Tue, 21 Jul 2026 17:26:25 +0200
Message-ID: <20260721152507.472845247@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 17a8ce84964f243c8f89dc7353ac7e8d3137bc74 upstream.

lpc32xx_xmit_dma() waits for the DMA completion callback but ignores
wait_for_completion_timeout(). A timed out DMA transfer is therefore
unmapped and reported as successful to the NAND read/write path.

Return -ETIMEDOUT when the completion wait expires. Terminate the DMA
channel before unmapping the scatterlist so the timed out transfer cannot
continue to access the buffer after the error is returned.

Fixes: 2944a44da09e ("mtd: add LPC32xx SLC NAND driver")
Cc: stable@vger.kernel.org
Reviewed-by: Vladimir Zapolskiy <vz@kernel.org>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/lpc32xx_slc.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/lpc32xx_slc.c
+++ b/drivers/mtd/nand/raw/lpc32xx_slc.c
@@ -430,6 +430,7 @@ static int lpc32xx_xmit_dma(struct mtd_i
 	struct dma_async_tx_descriptor *desc;
 	int flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 	int res;
+	unsigned long time_left;
 
 	host->dma_slave_config.direction = dir;
 	host->dma_slave_config.src_addr = dma;
@@ -467,12 +468,19 @@ static int lpc32xx_xmit_dma(struct mtd_i
 	dmaengine_submit(desc);
 	dma_async_issue_pending(host->dma_chan);
 
-	wait_for_completion_timeout(&host->comp, msecs_to_jiffies(1000));
+	time_left = wait_for_completion_timeout(&host->comp,
+						msecs_to_jiffies(1000));
+	if (!time_left) {
+		dmaengine_terminate_sync(host->dma_chan);
+		res = -ETIMEDOUT;
+	} else {
+		res = 0;
+	}
 
 	dma_unmap_sg(host->dma_chan->device->dev, &host->sgl, 1,
 		     DMA_BIDIRECTIONAL);
 
-	return 0;
+	return res;
 out1:
 	dma_unmap_sg(host->dma_chan->device->dev, &host->sgl, 1,
 		     DMA_BIDIRECTIONAL);


