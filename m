Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7189D318BB3;
	Sat, 12 Sep 2026 13:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221304; cv=none; b=EHL9W3wSX65SprGtMDjIpqjLZ0VM5cULDoXEN3CL0LUdOy4E7mwU1uu7PU6QtAzfbhYER6iT3giq5avGe2odYwh4HbN6YKbm5R3yptmtT1oayiRIZH8M39F2RyNRrxksHNLKmGnTsEL6Kj2FjX2wpv5maMi3M4ycgMkQW0L1/AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221304; c=relaxed/simple;
	bh=Hfqh8IwaPZ4P938Rv5uJYR5d0n8EHi3SbENADHOFQm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfusdHI/H6buG0LiQDO60T43rAYO6Q7mboQdNZ+YgucMDFQO2zWwVUhLn+B7GCNC/CfpxzBZQW4EY/OBtehOO84+RodJxTsgNlTx1uI8HN64FzxioIYxTWwFh/wdI0ieNH4kMRXbIMQiW59ZcVzp+VDSOdv4afY2tJsVw1OtoVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDpgCjcB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDpgCjcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AAD1F00893;
	Sat, 12 Sep 2026 13:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221303;
	bh=C6TQBo+iR6a4y1+/aibKjbHChB94NzpI+k2UC/uqv9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDpgCjcBg8t+23tsDng49kdBQ5SCQYQxg3B+nLMfQyGw+vEGhj92KVO3yhTbXDOcr
	 0xXZchZ3pxGOsEn1OCugJ8J87kQY5TVqCx/f7IxIkB7qZ+1CJaAhsuZbgHhGtNaDaA
	 5/0OsKvZi5zBzLRK1aEiyHBF2KJ0NcCh0BDu3oQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 0356/1424] dmaengine: dw-edma: Initialize IRQ data before requesting IRQs
Date: Sat, 12 Sep 2026 08:46:28 +0200
Message-ID: <20260912065615.260236729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

commit 647217abea849d3d45f8cb0b8ee5b78d50f26985 upstream.

dw_edma_irq_request() passes struct dw_edma_irq to request_irq() before
dw_edma_channel_setup() fills the back pointer. A shared interrupt can
therefore enter the handler with dw_irq->dw still NULL, leading to a
NULL pointer dereference.

Set the back pointer before installing each handler.

Fixes: e63d79d1ffcd ("dmaengine: Add Synopsys eDMA IP core driver")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260721062815.4117887-5-den@valinux.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-edma-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -793,7 +793,6 @@ static int dw_edma_channel_setup(struct
 		else
 			irq->rd_mask |= BIT(chan->id);
 
-		irq->dw = dw;
 		memcpy(&chan->msi, &irq->msi, sizeof(chan->msi));
 
 		dev_vdbg(dev, "MSI:\t\tChannel %s[%u] addr=0x%.8x%.8x, data=0x%.8x\n",
@@ -880,6 +879,7 @@ static int dw_edma_irq_request(struct dw
 	if (chip->nr_irqs == 1) {
 		/* Common IRQ shared among all channels */
 		irq = chip->ops->irq_vector(dev, 0);
+		dw->irq[0].dw = dw;
 		err = request_irq(irq, dw_edma_interrupt_common,
 				  IRQF_SHARED, dw->name, &dw->irq[0]);
 		if (err) {
@@ -905,6 +905,7 @@ static int dw_edma_irq_request(struct dw
 
 		for (i = 0; i < (*wr_alloc + *rd_alloc); i++) {
 			irq = chip->ops->irq_vector(dev, i);
+			dw->irq[i].dw = dw;
 			err = request_irq(irq,
 					  i < *wr_alloc ?
 						dw_edma_interrupt_write :


