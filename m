Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8A23B8BCB;
	Mon, 23 Mar 2026 15:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278930; cv=none; b=nXZMLfF3Z5T2RxVEUGG0F9OLX6HNpNFgU32nnzeZ+WdiQHxXePYylM5ASUmejbephAJSIp8D4N/m89w3o9SuacqhoDjBw6AwpcDOKIL0fapR0nE2r1i+1mUcJBi1gudjBdYkYMTI883dxgZOdbdmTIlK8SEWZebk172rj4ZtLFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278930; c=relaxed/simple;
	bh=SrE+u5v0X6IEMWAWZVIPvdmZzzqDLRuB4HeOgGKEhKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9t9WLvocgwK8hp3OQ5gCJ31pGal3bNxJt/Rc/rYwJHX/l6RG4z+wQrWEZ1mrsBHXmV/pNL/ijc2XvxriUDr/UNbjVwcgq0qWC1AzqVVTPly9EaefECgvp0Vc9GPPwxhkEhIoy8Q1QJTjnJD+DiDeEAiQZVuOeZJVZT24gcKoBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvgOOQ4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvgOOQ4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AFEC2BCB1;
	Mon, 23 Mar 2026 15:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278930;
	bh=SrE+u5v0X6IEMWAWZVIPvdmZzzqDLRuB4HeOgGKEhKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvgOOQ4NvyWmOmht5n9cjMVe4F99ww8ZOPGlbhF2HkF9WeH5Pj32X+bel2EltJCBt
	 UdL48oWxy1ogy4V6+bswchxnFS5fz4J5A5BAYStSWNh2aty2bvt8Q2iHOO2EhB4rp4
	 FDE5dNFnX9EPRP0F7hcptCTMJ3O4SjNVqjMV8EEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juan Li <lijuan@linux.spacemit.com>,
	Guodong Xu <guodong@riscstar.com>,
	Vinod Koul <vkoul@kernel.org>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 6.6 422/567] dmaengine: mmp_pdma: Fix race condition in mmp_pdma_residue()
Date: Mon, 23 Mar 2026 14:45:42 +0100
Message-ID: <20260323134544.329562609@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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


