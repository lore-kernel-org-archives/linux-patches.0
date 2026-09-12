Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB24202F71;
	Sat, 12 Sep 2026 15:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227975; cv=none; b=MKGMu5Rgqh1WJBbDk9xGkXjoJ8r0srHI1BaI5iqTENj8zwJjWix++HLP3H1eNs+A5O3x8RsOGDjpiPe/GACQ0477XRe3Nubr6V9XGT4oQKXkSX2jje7iAx9BJeY0Zxtoxy68c0y0Kg6bryb2l0WA1I3N5eAV5kuwV/iuvtDQAts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227975; c=relaxed/simple;
	bh=iD7F0FH/ikjFKGuSXs0gYQINkSwxTcl4lVWH6Z+lt9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHkOIU6n169FS5SIoW7+hzpzVqRdAUBYMBGz+aIoMlFMGOSC89AQ+PWONckM0FXWynyLbIFOI5CdvFjC0qikfqNhfenlMyrmCcXEKI2NEXzi+fzimg8a4qcFbnxEYYoFI3xb1NfRX3tap6e8t/knjT6B4b/jiIqoYm/4mLHnbUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnMUfj0u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnMUfj0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411BF1F000FF;
	Sat, 12 Sep 2026 15:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227974;
	bh=oG7seT7vIZ8rTV6u9+uE9HoKvu5b8rC2KUTvht0sNpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SnMUfj0uvuDnYvvXVQQPNmbqw8TQwsAbHxTXWMTK/k+aloBnmtboCbqmXh1VbNdZ5
	 LWkgR9qG3jqMX7Qbea7iRNvyNr91q4YsaHrOBq7GgaVW3UXnF8r9lKCj8z0+lnq5SP
	 MQjL5l4chb4Qlkb73LKvb/47l3lw/8WCTBVl5/jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 0292/1191] dmaengine: dw-edma: Initialize IRQ data before requesting IRQs
Date: Sat, 12 Sep 2026 08:50:20 +0200
Message-ID: <20260912065554.790280059@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
@@ -806,7 +806,6 @@ static int dw_edma_channel_setup(struct
 		else
 			irq->rd_mask |= BIT(j);
 
-		irq->dw = dw;
 		memcpy(&chan->msi, &irq->msi, sizeof(chan->msi));
 
 		dev_vdbg(dev, "MSI:\t\tChannel %s[%u] addr=0x%.8x%.8x, data=0x%.8x\n",
@@ -901,6 +900,7 @@ static int dw_edma_irq_request(struct dw
 	if (chip->nr_irqs == 1) {
 		/* Common IRQ shared among all channels */
 		irq = chip->ops->irq_vector(dev, 0);
+		dw->irq[0].dw = dw;
 		err = request_irq(irq, dw_edma_interrupt_common,
 				  IRQF_SHARED, dw->name, &dw->irq[0]);
 		if (err) {
@@ -926,6 +926,7 @@ static int dw_edma_irq_request(struct dw
 
 		for (i = 0; i < (*wr_alloc + *rd_alloc); i++) {
 			irq = chip->ops->irq_vector(dev, i);
+			dw->irq[i].dw = dw;
 			err = request_irq(irq,
 					  i < *wr_alloc ?
 						dw_edma_interrupt_write :


