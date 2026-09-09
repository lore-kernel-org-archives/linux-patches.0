Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F5E25783C;
	Wed,  9 Sep 2026 14:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963427; cv=none; b=nMZ5O3Kryy0zvGE3yfn+rdvk9OyNCYnpyB1/DVfBthRw43vbmpzSnarMN2GJJDXhmvIEKAE8zyyPaLgen28ZXud+SgnJHBlHuEIqdDs9aCoOuacV3Be+gphB3mTx932nOsjQPziVMZRabE9CwnO6rgLtqlWamMd6umjBL31KWzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963427; c=relaxed/simple;
	bh=Roda3kY4Dr4j+Nh2/NonEeMWB3RB8SOYG+VNqFarG08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOtFlIyY2Jf6K0i6Yw8FD1B525zAYsD9gZZn2J4XyFORUGJd/63PuiZFk78JOxdHpWJ0LkHBS4kbqwHin8oqT92hHCqvQA6tMXmNexK3FwR2YSv4OSrTO+yP+1gwy5vuH4/bvtUec480+Gtkk5jSwrTojauAKsaAqAqpO+4Uuew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OhHECSgM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OhHECSgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12221F00A3A;
	Wed,  9 Sep 2026 14:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963426;
	bh=u50JEDJFRslzAWlgpRAVZ8nA0k58r11VTvhWjqlLb1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OhHECSgMg2G2HsY/UefWMbuLPrNFJf+uiM5CbPSCLm5NRM+8NjZgPZ9iRYGSmASCe
	 cLvmQFyRSa8E5iGed6u5FInvkHa+mp8ZJ8atVi/fX/tPHgVm4Pa0obDNq2JT+bI/uH
	 sNWX2Y08ICy3Twzf/HBSum9HomcANvANXawEDvnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 073/583] dmaengine: dw-edma: Initialize IRQ data before requesting IRQs
Date: Wed,  9 Sep 2026 15:35:58 +0200
Message-ID: <20260909134240.612770698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -782,7 +782,6 @@ static int dw_edma_channel_setup(struct
 		else
 			irq->rd_mask |= BIT(chan->id);
 
-		irq->dw = dw;
 		memcpy(&chan->msi, &irq->msi, sizeof(chan->msi));
 
 		dev_vdbg(dev, "MSI:\t\tChannel %s[%u] addr=0x%.8x%.8x, data=0x%.8x\n",
@@ -870,6 +869,7 @@ static int dw_edma_irq_request(struct dw
 	if (chip->nr_irqs == 1) {
 		/* Common IRQ shared among all channels */
 		irq = chip->ops->irq_vector(dev, 0);
+		dw->irq[0].dw = dw;
 		err = request_irq(irq, dw_edma_interrupt_common,
 				  IRQF_SHARED, dw->name, &dw->irq[0]);
 		if (err) {
@@ -895,6 +895,7 @@ static int dw_edma_irq_request(struct dw
 
 		for (i = 0; i < (*wr_alloc + *rd_alloc); i++) {
 			irq = chip->ops->irq_vector(dev, i);
+			dw->irq[i].dw = dw;
 			err = request_irq(irq,
 					  i < *wr_alloc ?
 						dw_edma_interrupt_write :


