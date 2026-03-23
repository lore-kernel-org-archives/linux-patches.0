Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7310C23A561;
	Mon, 23 Mar 2026 14:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277141; cv=none; b=TRQrXSuu8JOOzPmzhWZ8VLDj0zYKoA4GeeuCuqztbzAi2CCCs8Waz10Y5Nko0NktzlfQ8Z/2+y4G/8mYMYXjxxedDrYcs2AdtTjBE02mcc5tzzQEdpkqrh8vRXTuQ4EoqMfrbkc9Z34NW+jUcAIRfzq5cmKxSZCntQTcMyIXU10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277141; c=relaxed/simple;
	bh=H9TZuWIm6Tew4pZZ/poOtnVi71foDmVrkbXhd9SHHhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0lQnEuIs+fcTrWkXJjatJsSrShvIuuaDHYwYR0H7p1r0QoimeO4/TJD56OVDQ45KHW/nsj8odPwEseDyN/tVk1yWkc7ydE1dSWD4adRG57/5DSEbe+bFQNNkR/XFqnLjCqCgcXBh9NZkDDxdE0uxj55s8P2vc8EbboZfcTk3C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPCQhf0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPCQhf0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD06C2BCB1;
	Mon, 23 Mar 2026 14:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277141;
	bh=H9TZuWIm6Tew4pZZ/poOtnVi71foDmVrkbXhd9SHHhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPCQhf0PIU1gzzXSKGenocrf10t3x1BDardWvP9299bO5r4IjCg/AjOozMbBOoTa7
	 Q781LO8TUMmXLhBH/fMscAgvjfgJKcMqkhJzHy2J2tG0rP822y4hkxAmti+PKb4WiG
	 MSX/+Y7w0XoCxRAfcZHeuhrV0MViFydnMfQaZwUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juan Li <lijuan@linux.spacemit.com>,
	Guodong Xu <guodong@riscstar.com>,
	Vinod Koul <vkoul@kernel.org>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 6.12 290/460] dmaengine: mmp_pdma: Fix race condition in mmp_pdma_residue()
Date: Mon, 23 Mar 2026 14:44:46 +0100
Message-ID: <20260323134533.606695224@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Guodong Xu <guodong@riscstar.com>

[ Upstream commit a143545855bc2c6e1330f6f57ae375ac44af00a7 ]

Add proper locking in mmp_pdma_residue() to prevent use-after-free when
accessing descriptor list and descriptor contents.

The race occurs when multiple threads call tx_status() while the tasklet
on another CPU is freeing completed descriptors:

CPU 0                              CPU 1
-----                              -----
mmp_pdma_tx_status()
mmp_pdma_residue()
  -> NO LOCK held
     list_for_each_entry(sw, ..)
                                   DMA interrupt
                                   dma_do_tasklet()
                                     -> spin_lock(&desc_lock)
                                        list_move(sw->node, ...)
                                        spin_unlock(&desc_lock)
  |                                     dma_pool_free(sw) <- FREED!
  -> access sw->desc <- UAF!

This issue can be reproduced when running dmatest on the same channel with
multiple threads (threads_per_chan > 1).

Fix by protecting the chain_running list iteration and descriptor access
with the chan->desc_lock spinlock.

Signed-off-by: Juan Li <lijuan@linux.spacemit.com>
Signed-off-by: Guodong Xu <guodong@riscstar.com>
Link: https://patch.msgid.link/20251216-mmp-pdma-race-v1-1-976a224bb622@riscstar.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[ Minor context conflict resolved. ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/mmp_pdma.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -763,6 +763,7 @@ static unsigned int mmp_pdma_residue(str
 {
 	struct mmp_pdma_desc_sw *sw;
 	u32 curr, residue = 0;
+	unsigned long flags;
 	bool passed = false;
 	bool cyclic = chan->cyclic_first != NULL;
 
@@ -778,6 +779,8 @@ static unsigned int mmp_pdma_residue(str
 	else
 		curr = readl(chan->phy->base + DSADR(chan->phy->idx));
 
+	spin_lock_irqsave(&chan->desc_lock, flags);
+
 	list_for_each_entry(sw, &chan->chain_running, node) {
 		u32 start, end, len;
 
@@ -821,6 +824,7 @@ static unsigned int mmp_pdma_residue(str
 			continue;
 
 		if (sw->async_tx.cookie == cookie) {
+			spin_unlock_irqrestore(&chan->desc_lock, flags);
 			return residue;
 		} else {
 			residue = 0;
@@ -828,6 +832,8 @@ static unsigned int mmp_pdma_residue(str
 		}
 	}
 
+	spin_unlock_irqrestore(&chan->desc_lock, flags);
+
 	/* We should only get here in case of cyclic transactions */
 	return residue;
 }


