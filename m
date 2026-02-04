Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75D127F749;
	Wed,  4 Feb 2026 14:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216855; cv=none; b=ZKVJhKmfLVMv53gUDK7lXKeRXFp3qNSSsQxG6tGgwioRzoKxM4qmXL5J+cfl4Z9d7rQawl6xpPQSd0VrRQIs7/YSUJs9Ku74fpXDs06AVsXO+uBBv+jBP2poeXEQ1F0P0rMOEQz4gkEG1WFHQQVung2tvAS9mQ/wm7VZHHzcPFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216855; c=relaxed/simple;
	bh=Qio0zSDLXca8gS4S6u8DaTN0Pndtu5IXgJhWstgidzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ym5go2IESI7KIOCLujNT9hU5Z5GV9lhCEwNZM1ZRSm89lsxSL9RdmYQWSy+6iMWjZv8YqPDS8hKsVpqybKlI4GNETpitcqLXD5pcN3vzJ/ksIX9bi7av1AwfsgBmm/cVwrtb14af+fkLDmXx4INngghIVJxcnlvOkgFlzXemS3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/uOEopJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/uOEopJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E83C4CEF7;
	Wed,  4 Feb 2026 14:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216855;
	bh=Qio0zSDLXca8gS4S6u8DaTN0Pndtu5IXgJhWstgidzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/uOEopJjBhpjgr0jVdxIBDA9FcSSxFwLt5OFXe/mmBR39PzoVGRThi29glZWEtzE
	 yUdMbbLBH30KYOytNI1FzDmgdKlR3SQJ8ZQ5yaFJgEE1cbCScqAQngyreRzSA3FdJl
	 VWGTznIYF6GPj1Zj+plmetzdO27LNTBrMwSHiCcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 050/206] dmaengine: sh: rz-dmac: Fix rz_dmac_terminate_all()
Date: Wed,  4 Feb 2026 15:38:01 +0100
Message-ID: <20260204143900.018895766@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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
@@ -531,11 +531,16 @@ rz_dmac_prep_slave_sg(struct dma_chan *c
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


