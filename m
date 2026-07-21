Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C52C2F25E4;
	Tue, 21 Jul 2026 20:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664248; cv=none; b=pFaCeLz2mm9wxasd055PaPry7zOZlc57XEHNzvXXLf0aaU1YOe1RlRaJ+p/CHmhDrMfyGGI9D+bhYu/LCnoF4lsyL5X2jf9llPq7ZDAtJQeDKhsh+X8g/hcjf/tUX5giTD1YVwlnxo0go9uc9GA1sl/ffSpSGgM/LuT7ZnEYCzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664248; c=relaxed/simple;
	bh=50WCPq++s6QR9e0rfU90d+0SU55WuswWnbuUamMqhmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDM6r2Dr+GHeWCcD8GoPrM39OcZwCX2V/59/fc8DfteR7oR6E9VOOFAOUAJn0e/Ck0ak3QBlHxJt3Ommk39TCUW3YPKGfXtlyfjKrc+pmv2vz7DzUueaxmrVJRGsXN9nhrcou3Qs0Kn+t6Acx7IxWEhW0Hc2/fzIMyocpuLh4+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xovL+tCb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xovL+tCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EF91F000E9;
	Tue, 21 Jul 2026 20:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664247;
	bh=+bap2iYuy/9PDjt0fCMgvB8s0dAfnhA7FX6iSvXGpxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xovL+tCbd6BTLxYkNbfGcmbVXGpxDGqfUR5D4jRa24wzaTyJXWcQ6AVGOaGN037Zi
	 VzjIQPc+xqxT927efn7PPvZHNTgKZ4XqwkTrad5Dty4q2fyQREoMNmI2nhOLbeeUjW
	 ZYRq3RSuEe1LYoN12wu4m1ZYTgvhO4F2VhpcxKp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 1128/1276] mtd: rawnand: lpc32xx_slc: fail DMA transfer on completion timeout
Date: Tue, 21 Jul 2026 17:26:11 +0200
Message-ID: <20260721152511.235368345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


