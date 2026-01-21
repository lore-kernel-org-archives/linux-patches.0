Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B4A3A89B8;
	Wed, 21 Jan 2026 18:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019817; cv=none; b=TlN0z6rD+CIeBFFRf3DcYHBfrEv/Mcwhd3hm4/k9i0fyovVYlLN6iGyCf1vfw7LqDvO5Ax6aojbIfSORuTRYuiXzzftnCsKE4P6zr1UNmF3xwCz9ZmkTuo72e8/oFcwetuP9b04s9Q6sUphvaBkykiBkwsGFCKKiKFtuf0DaMQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019817; c=relaxed/simple;
	bh=/3U7i/Bg4wSaMKiqvbVpMgefKBozg8L6Cdffn17Qqow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFjSX4i8uLeoACNMfOR6za+RJqXb/7DKrBZ9ebL0Q5X7+6wvBphhrijrWXQL+yfi2KRVdkV8PY1amH8am8V55mGjkJNLki6tEWBzaHdcro2DzdcM32JlQB8er4evZeh1lp9WRgDBqIFenqMCElAwuUa4uyH6b95FI+aY3IG+Eng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r71tWxjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r71tWxjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2041CC19424;
	Wed, 21 Jan 2026 18:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019817;
	bh=/3U7i/Bg4wSaMKiqvbVpMgefKBozg8L6Cdffn17Qqow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r71tWxjt2S/1Kznr1Cxmt9cMhTLBfJCRNtGBpMtyjxi3JKczpiH9NAZ59JFzxSmC2
	 adQZVkqL1qi7RmcDbNxiO6aWrUly8FRZg4+Ww6D0AIrsl8jYFQF4AOeTvlrs0Jz2pg
	 woSm6S9AAx5rMqZEETUOgUf6mrv4kdsFExXG9AWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 116/139] dmaengine: sh: rz-dmac: Fix rz_dmac_terminate_all()
Date: Wed, 21 Jan 2026 19:16:04 +0100
Message-ID: <20260121181415.625849719@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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
 	vchan_get_all_descriptors(&channel->vc, &head);


