Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7825230C359;
	Mon, 13 Apr 2026 16:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098512; cv=none; b=iyZg5adZjP+Dq+v4jQ+YRqgDmc/prbEis+qGe8uFGAOFDp+JmzS2QWOKuHwBnwRtFONLdTJwmnlwmXXWdksrsYuoKJ18oJ8L/d9NzPwAkuwbPaNNKZ8GoifjxQdMQjSt1x0o6fhpsFLZlTlXCJne2/hNe8Qn0UXmFlSOF51fEc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098512; c=relaxed/simple;
	bh=SBH3+qTDJ29bVqGzyWQxp2AzGzd0udnyduJ9ZkEC4xA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKqTJiznTkrg6/QR3HoAHKn204N6GGzRYG0B1BWYvy0uPYWWVHCKCN7yO6vWTJjpp5ibttPJGknHZIe+aHRkVkeGyhNFPAkrWWOKKwDzndMf5poSibuH5uYBT0P05gyBTQzPrAgV4qi/eXfmWZMEX5Ta6pemBRwrwsVPCQtTN78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0py9Sy1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0py9Sy1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBA1C2BCAF;
	Mon, 13 Apr 2026 16:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098512;
	bh=SBH3+qTDJ29bVqGzyWQxp2AzGzd0udnyduJ9ZkEC4xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0py9Sy1Wu8fZ9j8B6JO5gLseSv4Qmllsi7enefzYppx/epSGoIKh4U/BsCeiQJlmp
	 /tAbu8Iwnc9mINlfXmBklJIW2IRIp0HCjDil3EDDBxkDPwjiEXrwlq5dW/nwNPbmcY
	 MIfWmK+T5AbgyLh+EGMwJmyWRPttKgCZJ//CCOmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 554/570] dmaengine: sh: rz-dmac: Protect the driver specific lists
Date: Mon, 13 Apr 2026 18:01:25 +0200
Message-ID: <20260413155851.215217511@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea@tuxon.dev>

[ Upstream commit abb863e6213dc41a58ef8bb3289b7e77460dabf3 ]

The driver lists (ld_free, ld_queue) are used in
rz_dmac_free_chan_resources(), rz_dmac_terminate_all(),
rz_dmac_issue_pending(), and rz_dmac_irq_handler_thread(), all under
the virtual channel lock. Take the same lock in rz_dmac_prep_slave_sg()
and rz_dmac_prep_dma_memcpy() as well to avoid concurrency issues, since
these functions also check whether the lists are empty and update or
remove list entries.

Fixes: 5000d37042a6 ("dmaengine: sh: Add DMAC driver for RZ/G2L SoC")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20260316133252.240348-2-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[ replaced scoped_guard(spinlock_irqsave) with explicit spin_lock_irqsave/spin_unlock_irqrestore calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/sh/rz-dmac.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/drivers/dma/sh/rz-dmac.c
+++ b/drivers/dma/sh/rz-dmac.c
@@ -419,6 +419,7 @@ static int rz_dmac_alloc_chan_resources(
 		if (!desc)
 			break;
 
+		/* No need to lock. This is called only for the 1st client. */
 		list_add_tail(&desc->node, &channel->ld_free);
 		channel->descs_allocated++;
 	}
@@ -470,12 +471,17 @@ rz_dmac_prep_dma_memcpy(struct dma_chan
 	struct rz_dmac_chan *channel = to_rz_dmac_chan(chan);
 	struct rz_dmac *dmac = to_rz_dmac(chan->device);
 	struct rz_dmac_desc *desc;
+	unsigned long irqflags;
 
 	dev_dbg(dmac->dev, "%s channel: %d src=0x%pad dst=0x%pad len=%zu\n",
 		__func__, channel->index, &src, &dest, len);
 
-	if (list_empty(&channel->ld_free))
+	spin_lock_irqsave(&channel->vc.lock, irqflags);
+
+	if (list_empty(&channel->ld_free)) {
+		spin_unlock_irqrestore(&channel->vc.lock, irqflags);
 		return NULL;
+	}
 
 	desc = list_first_entry(&channel->ld_free, struct rz_dmac_desc, node);
 
@@ -486,6 +492,9 @@ rz_dmac_prep_dma_memcpy(struct dma_chan
 	desc->direction = DMA_MEM_TO_MEM;
 
 	list_move_tail(channel->ld_free.next, &channel->ld_queue);
+
+	spin_unlock_irqrestore(&channel->vc.lock, irqflags);
+
 	return vchan_tx_prep(&channel->vc, &desc->vd, flags);
 }
 
@@ -498,17 +507,21 @@ rz_dmac_prep_slave_sg(struct dma_chan *c
 	struct rz_dmac_chan *channel = to_rz_dmac_chan(chan);
 	struct rz_dmac_desc *desc;
 	struct scatterlist *sg;
+	unsigned long irqflags;
 	int dma_length = 0;
 	int i = 0;
 
-	if (list_empty(&channel->ld_free))
+	spin_lock_irqsave(&channel->vc.lock, irqflags);
+
+	if (list_empty(&channel->ld_free)) {
+		spin_unlock_irqrestore(&channel->vc.lock, irqflags);
 		return NULL;
+	}
 
 	desc = list_first_entry(&channel->ld_free, struct rz_dmac_desc, node);
 
-	for_each_sg(sgl, sg, sg_len, i) {
+	for_each_sg(sgl, sg, sg_len, i)
 		dma_length += sg_dma_len(sg);
-	}
 
 	desc->type = RZ_DMAC_DESC_SLAVE_SG;
 	desc->sg = sgl;
@@ -522,6 +535,9 @@ rz_dmac_prep_slave_sg(struct dma_chan *c
 		desc->dest = channel->dst_per_address;
 
 	list_move_tail(channel->ld_free.next, &channel->ld_queue);
+
+	spin_unlock_irqrestore(&channel->vc.lock, irqflags);
+
 	return vchan_tx_prep(&channel->vc, &desc->vd, flags);
 }
 


