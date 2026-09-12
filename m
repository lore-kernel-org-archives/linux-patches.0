Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35833ACEFB;
	Sat, 12 Sep 2026 18:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237420; cv=none; b=DB9h1uS9SpZwqTiL4dcQVlEp8Wt5/ffdW7CmYyartnsdiw3HEjQ40OtQVrgkPalqlSxDjXDwVBph+o/M48UN/zR70Q3O9wfcUjS3bbCxIhXICImgOsG5L17kIWIt3AjEKiq2OJcmJ0xsTZR9it5U+ZdQ3z8QA1rVR9upkKhGfeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237420; c=relaxed/simple;
	bh=AHOPZ2M9u6lIbhb3MJHaPbOGsBYu8YMr+FehiBXvT9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVa43hKpLPhYEt21udWxrzNFMqqxQY0nXqTjLRv085DHp6buEzhnPL/UGfuNpf0G5mVR5/eKMBhY3ku8hqj17N/KbqRfgKClxhrQS3BEZL1iGCuWdAIFKzCrLhG3vZ5Xug66PViuY7AiRmbh/6Wv7nFy6TN0+yYkuJB7Zu1rLfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPByvtMl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPByvtMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34A51F000FF;
	Sat, 12 Sep 2026 18:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237418;
	bh=ay7vJ2reDAI90zG05iMyzry1bpJP6fjlQIPbOMNgjeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPByvtMlcD7Maabq4RaqsYJTi1eAEupqW2t7WEk0L630c2U+liJTXimgxxq9RDEPt
	 2fDiomQG9BTR514tdv4RS++i/9srYvrTAZuMUp+k+VEPeGQoPcyOMfenSbq7NyW8Gt
	 BUjU2LKhtK9eIMAG/CLioDsrqIVdzK45Q0nb1AF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 253/935] dmaengine: dw-edma: Initialize IRQ data before requesting IRQs
Date: Sat, 12 Sep 2026 08:54:43 +0200
Message-ID: <20260912065532.628800252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
@@ -794,7 +794,6 @@ static int dw_edma_channel_setup(struct
 		else
 			irq->rd_mask |= BIT(j);
 
-		irq->dw = dw;
 		memcpy(&chan->msi, &irq->msi, sizeof(chan->msi));
 
 		dev_vdbg(dev, "MSI:\t\tChannel %s[%u] addr=0x%.8x%.8x, data=0x%.8x\n",
@@ -889,6 +888,7 @@ static int dw_edma_irq_request(struct dw
 	if (chip->nr_irqs == 1) {
 		/* Common IRQ shared among all channels */
 		irq = chip->ops->irq_vector(dev, 0);
+		dw->irq[0].dw = dw;
 		err = request_irq(irq, dw_edma_interrupt_common,
 				  IRQF_SHARED, dw->name, &dw->irq[0]);
 		if (err) {
@@ -914,6 +914,7 @@ static int dw_edma_irq_request(struct dw
 
 		for (i = 0; i < (*wr_alloc + *rd_alloc); i++) {
 			irq = chip->ops->irq_vector(dev, i);
+			dw->irq[i].dw = dw;
 			err = request_irq(irq,
 					  i < *wr_alloc ?
 						dw_edma_interrupt_write :


