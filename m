Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC3F23E358;
	Wed, 28 Jan 2026 15:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614266; cv=none; b=LtQo58w0jKwHOBJzImmukRUZAbppwuhDohwTqD963PeSeMynPynFqX7pffvi2+sep5txCWIRq8U0zVOp/YeW8t/5CKQedkEYkLbkc+qf4haxcTMyNqb6yuHC9kaPoJBIciUWBBlqKHhRNufI5DLw+Y1GGmqVVDRZwRsN6lYFpak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614266; c=relaxed/simple;
	bh=R8dh3Wn7Mp1gVBx528GV0eiwt/jrqaEp6r1o7rEJpT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAACkw/tSiNY5gzsk3qqLn84sbtM+XU8sONKqc+TVkTHU4+kAKHBG9l1MWgvjqsGfDGmiKxBBoQu/9DCcBOMv8UfgXRj7zW7HeCtAct9+nL0Eb4olAyZCNpugQzHpZpwN6wmudS4UaKK+YCzJ1tL4FCuQ7uZKY5D/MhJP9IQwcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atrb/xH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atrb/xH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A35C4CEF1;
	Wed, 28 Jan 2026 15:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614266;
	bh=R8dh3Wn7Mp1gVBx528GV0eiwt/jrqaEp6r1o7rEJpT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atrb/xH7lrxzDMUfnOPhLzV9u5arEpKwZghFS32GbOYK/cr599dzGdv4KZ9Yqnc1V
	 MZ8UURZT0JLsJOOf4lIS3lk7kDRkzQ4y5XqckZrUVfR+zCyImiUPb/qKA21ySe/q9C
	 pz/RDrWqihhpm5T6tMEcV1Z4nFFC7V3Z+4f612L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 085/254] dmaengine: sh: rz-dmac: Fix rz_dmac_terminate_all()
Date: Wed, 28 Jan 2026 16:21:01 +0100
Message-ID: <20260128145347.758272696@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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
@@ -533,11 +533,16 @@ rz_dmac_prep_slave_sg(struct dma_chan *c
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
 	spin_unlock_irqrestore(&channel->vc.lock, flags);


