Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABEA267B05;
	Sat, 30 May 2026 17:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163007; cv=none; b=gwEU8W+gV/U78BzHGjuNXY7nuPBkzFdjA0VnHq8zED0mgdTyvmjIA7ZUpuwRj/nZ5G+Gsl0uIhAPQIJ4v+82MT3PDMITLWa4sqpcu20ISgZryx9BZyYWlnWVP8dP7YQm/KGMNdK2dgYeko5GVZmDjCgZYzVzwR0dcctBvV/1RHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163007; c=relaxed/simple;
	bh=L6dkOPWtaFMJL4YMQuhTxMiDaWPt3mYOG/qE8nlKgOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FK+sHmRWvta4iHHUAFBJ/cY4kmoq14alJ9bA2nMpsIhzH9YpHXdpQypy7Fjxs9L5PKQNy/BNH59LGpFnX/2RtFSJ5JBkNIeXoRXClhAJbFz9sM9hozexlInXFsLFH50nBAYRdI7RQXEo4YiJQszzvJUrdPwkbRp/oIadUCHkckM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxA2FJd6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxA2FJd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDDA1F00893;
	Sat, 30 May 2026 17:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163006;
	bh=jA59KurEzNRroU0bqcgFkUJ4oy5+/AT672LBL3fPEcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dxA2FJd6wDhq+LBVBzHlU8DqkwSjngpJwx/tOrqKX7roTeK3Np1qgz+FLz0qM/gD5
	 I1Cc1rhvGAJgLbbgq0lprSNujE6onmFcBLUq58H1v1kCSYx/pASvjNiM+vimAylYL0
	 Sv21s/QskG+ORIN94mw2/FsJvSilImKSYMs9MEvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juan Li <lijuan@linux.spacemit.com>,
	Guodong Xu <guodong@riscstar.com>,
	Vinod Koul <vkoul@kernel.org>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 5.15 128/776] dmaengine: mmp_pdma: Fix race condition in mmp_pdma_residue()
Date: Sat, 30 May 2026 17:57:22 +0200
Message-ID: <20260530160243.692091841@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
@@ -764,6 +764,7 @@ static unsigned int mmp_pdma_residue(str
 {
 	struct mmp_pdma_desc_sw *sw;
 	u32 curr, residue = 0;
+	unsigned long flags;
 	bool passed = false;
 	bool cyclic = chan->cyclic_first != NULL;
 
@@ -779,6 +780,8 @@ static unsigned int mmp_pdma_residue(str
 	else
 		curr = readl(chan->phy->base + DSADR(chan->phy->idx));
 
+	spin_lock_irqsave(&chan->desc_lock, flags);
+
 	list_for_each_entry(sw, &chan->chain_running, node) {
 		u32 start, end, len;
 
@@ -822,6 +825,7 @@ static unsigned int mmp_pdma_residue(str
 			continue;
 
 		if (sw->async_tx.cookie == cookie) {
+			spin_unlock_irqrestore(&chan->desc_lock, flags);
 			return residue;
 		} else {
 			residue = 0;
@@ -829,6 +833,8 @@ static unsigned int mmp_pdma_residue(str
 		}
 	}
 
+	spin_unlock_irqrestore(&chan->desc_lock, flags);
+
 	/* We should only get here in case of cyclic transactions */
 	return residue;
 }


