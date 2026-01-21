Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4873428312F;
	Wed, 21 Jan 2026 18:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020591; cv=none; b=MOIHGu1roYBZ8TDycnyPNUxfnBkZ3pE9UuR0BlqZC7OWedKv9bSPDTd98yUk/FqNEe3zAVe7j+C5rM1doIiitJKx86fZqaB/3SvBbMN/LnX4QvkxlNLRA5/dWt+CG/l/zM6MY9oM5SUWfdmKQYuw5pO5/Sa7Kbi971FXgraMwRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020591; c=relaxed/simple;
	bh=+pOEgPih1VsNR0wR8Wr1y7bgnfkSkIOaAc6sXfxR+qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8Sd2SihPzgWnuz/bKet7qMJ+ONdJbxcqpBCA7ORr5R4tYoxJIkYfhXv04+FaSiKn9IuESLtWNYTIviGS4/bLOH63KVyGVtlXomNTc7spbmFbQPVgRjNjKbqcvG2iWiq8m5wmkDm8l2sNpf/E5Ht5Ei7kNgJ/y40nE2z+saYbvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxLYe+iK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxLYe+iK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7420AC2BC9E;
	Wed, 21 Jan 2026 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020590;
	bh=+pOEgPih1VsNR0wR8Wr1y7bgnfkSkIOaAc6sXfxR+qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxLYe+iKZMRLrpu4lQijlxk8T/UXB4Qp442kwg/dt7pUWNKac1h9clAsEg/H8qbr+
	 dRI4GmfCHiM8e63RgyA96RxabXg3E2DGl7GjeO1y2KXud1oulvjTBnxHr8fSQ3ztV/
	 VQapFvTfJ84zEi7X40DGqRwqR5undE6YZdWl4JkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 178/198] dmaengine: sh: rz-dmac: Fix rz_dmac_terminate_all()
Date: Wed, 21 Jan 2026 19:16:46 +0100
Message-ID: <20260121181424.957492624@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 747213b08a1ab6a76e3e3b3e7a209cc1d402b5d0 upstream.

After audio full duplex testing, playing the recorded file contains a few
playback frames from the previous time. The rz_dmac_terminate_all() does
not reset all the hardware descriptors queued previously, leading to the
wrong descriptor being picked up during the next DMA transfer. Fix the
above issue by resetting all the descriptor headers for a channel in
rz_dmac_terminate_all() as rz_dmac_lmdesc_recycle() points to the proper
descriptor header filled by the rz_dmac_prepare_descs_for_slave_sg().

Cc: stable@kernel.org
Fixes: 5000d37042a6 ("dmaengine: sh: Add DMAC driver for RZ/G2L SoC")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Tested-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20251113195052.564338-1-biju.das.jz@bp.renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/sh/rz-dmac.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/dma/sh/rz-dmac.c
+++ b/drivers/dma/sh/rz-dmac.c
@@ -557,11 +557,16 @@ rz_dmac_prep_slave_sg(struct dma_chan *c
 static int rz_dmac_terminate_all(struct dma_chan *chan)
 {
 	struct rz_dmac_chan *channel = to_rz_dmac_chan(chan);
+	struct rz_lmdesc *lmdesc = channel->lmdesc.base;
 	unsigned long flags;
+	unsigned int i;
 	LIST_HEAD(head);
 
 	rz_dmac_disable_hw(channel);
 	spin_lock_irqsave(&channel->vc.lock, flags);
+	for (i = 0; i < DMAC_NR_LMDESC; i++)
+		lmdesc[i].header = 0;
+
 	list_splice_tail_init(&channel->ld_active, &channel->ld_free);
 	list_splice_tail_init(&channel->ld_queue, &channel->ld_free);
 	vchan_get_all_descriptors(&channel->vc, &head);


