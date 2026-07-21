Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A78E43DA38;
	Tue, 21 Jul 2026 22:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672829; cv=none; b=pMtLW3CgOogcILlPZNBuDdCqLO03xjquwVaimsmUU2Rg7TV6lWXv5/sCI9C+p4ftoAO5y4/FOmSrmMaZGK1dLguUtKhtiz6+KoFGTH0qWR16KzJyodsKRMAi6SSQGf5xsEvVP54je97RtcjpNmrdRsOTVoJQv0ZKdguC7rI1Fls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672829; c=relaxed/simple;
	bh=fcPU/iBdchFs9JkYyu/ziS7G6WEL5oCOMIRReawDcss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHSnLvSGdFglCrMynjpfQuCR+d+HqXjxJqOS1cNWoLlvI1tX0v0SGYrru//6/4Nrv59wSjEZDYjKLSjCWtJRAmPDZpJkwXoHFMFZBHSIiCYQP5p2Do/TjB71T5wjeopR2G0Xv0doJTCyFncxd3cYa+ndO7AkphYY+ZhlY/EeQkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6LUAIiJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6LUAIiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5321F000E9;
	Tue, 21 Jul 2026 22:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672828;
	bh=0m1cMsqtTe1b7ENaL5RuV2hhGlvOtp5EING7QRT0kAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6LUAIiJwH6Cqx+T75dbBzZ0qa8c9yXrYkTR4qhfdYRvKBVo8+OE+sjnmzeObddIG
	 Zt7fquEA94JJSzovYs9205lWkpBKV3+McmgsRasiiNqP1A+dGOlp0gN5dWFf4BJA+J
	 bAsnWc+XqQu6v1FbxcG4Did4XEsFuQPys3aNYpJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 729/843] mtd: rawnand: lpc32xx_slc: fail DMA transfer on completion timeout
Date: Tue, 21 Jul 2026 17:26:04 +0200
Message-ID: <20260721152422.441977384@linuxfoundation.org>
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
@@ -444,6 +444,7 @@ static int lpc32xx_xmit_dma(struct mtd_i
 	struct dma_async_tx_descriptor *desc;
 	int flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 	int res;
+	unsigned long time_left;
 
 	host->dma_slave_config.direction = dir;
 	host->dma_slave_config.src_addr = dma;
@@ -481,12 +482,19 @@ static int lpc32xx_xmit_dma(struct mtd_i
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


