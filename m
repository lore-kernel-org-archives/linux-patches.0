Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872E05519A2;
	Wed,  9 Sep 2026 13:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961927; cv=none; b=UKTxYnbOpklFo0+hbIHYMfXA0z0dkaduXyVeFOyHEcn8gTnguBavdiwLcC1mpO+Rr5wuwKPQIRS+twv0PJ8/6gGQR9WemaV8LGcJ2gs3/6pwZeNcvWH4LE7LpPgKt+XU4+feDN+s5d7zGQhLapp84bDP7FeQSuMiu3Z9NqSmuQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961927; c=relaxed/simple;
	bh=DBxo/sY9nEU+EuIxFjtzrQKtHF0yJqZrfPyOHdktcoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8S7/ukRaQQaV86ISJwIMU2FYJfrhJQFKdRER9RUk506aiXeW3yMktZoPE3bu9/r8s0xkVbI9Wv886E3rGGWAyuEPpxeFMkjBM4Yg3vz0srRRtXeIzsYkEqfhoTO2Oj7y+hfq8KdCGYx8mUS+bvXADr3WhAousWPHV8bEoCtfZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enL4CYBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enL4CYBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CB51F00A3F;
	Wed,  9 Sep 2026 13:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961926;
	bh=vlpul5qz/2HCSGfs2NAnFZqJ9i+COX01ohuV+jtOtnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=enL4CYBK6AH/oYsD33JJq88ftcHsgXpbZPpwwFB4FcJh6oyL+03/wYLSGEoz3umX+
	 375drWqNlK63KDQb2LrirE036JJ21NsfG9pdrEgCXGbeQzDuIb2Iy+1gYPg+I2gKJd
	 ZdhILy2FyeefVSH1tSjOWaIXqOHbS0dyahCU3Iho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 7.2 112/556] dmaengine: dw-edma: Initialize IRQ data before requesting IRQs
Date: Wed,  9 Sep 2026 15:36:32 +0200
Message-ID: <20260909134234.416942816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -937,7 +937,6 @@ static int dw_edma_channel_setup(struct
 		else
 			irq->rd_mask |= BIT(chan->id);
 
-		irq->dw = dw;
 		memcpy(&chan->msi, &irq->msi, sizeof(chan->msi));
 
 		dev_vdbg(dev, "MSI:\t\tChannel %s[%u] addr=0x%.8x%.8x, data=0x%.8x\n",
@@ -1018,6 +1017,7 @@ static int dw_edma_irq_request(struct dw
 	if (chip->nr_irqs == 1) {
 		/* Common IRQ shared among all channels */
 		irq = chip->ops->irq_vector(dev, 0);
+		dw->irq[0].dw = dw;
 		err = request_irq(irq, dw_edma_interrupt_common,
 				  IRQF_SHARED, dw->name, &dw->irq[0]);
 		if (err) {
@@ -1040,6 +1040,7 @@ static int dw_edma_irq_request(struct dw
 
 		for (i = 0; i < (*wr_alloc + *rd_alloc); i++) {
 			irq = chip->ops->irq_vector(dev, i);
+			dw->irq[i].dw = dw;
 			err = request_irq(irq,
 					  i < *wr_alloc ?
 						dw_edma_interrupt_write :


