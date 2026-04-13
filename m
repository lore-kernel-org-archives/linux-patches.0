Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9CD30BF68;
	Mon, 13 Apr 2026 16:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098510; cv=none; b=tRigx10m+9Q9WBKgUIa160slo+3NwkDjGuUEhxXwqY/xIp00jg+4bKo8Rz8tLtybot6cHpjzVGFnQFVQG5fPZgbjThowSZHVOmVNUdCu1Qf5oGVKQMz2S3oCVhGw0NESaTP+++MWndg+8Yg5ptlyUo1KVntZ1eRqbTM85y9D2tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098510; c=relaxed/simple;
	bh=/1af8cy+fkvmv44hnUn5SOAOOYgflDZssBfznSvgAsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5Ws+CzgX/TWrwEDhzaTw7FS8h44SF65xQGNC+A+Fy4PNIjBPxDhhynlXFlT24VuZYqp0+zUSpVeObBMPwvl3myim2hMdFcspis4/3fbzhOP7voR2NL4THXjEFQxOSWtDdOUJUmoTM5vbYSW+hdA9vkYtq1ngv8SFVMM8DqYA5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eI8Tp9zO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eI8Tp9zO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3DDC2BCAF;
	Mon, 13 Apr 2026 16:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098509;
	bh=/1af8cy+fkvmv44hnUn5SOAOOYgflDZssBfznSvgAsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eI8Tp9zOyT+6vuwy7hXTATsUpP3MkAIQDA1SZVgtgt5DSDEigjJfcxN2UB0/n4z3x
	 LOnzAHmOUQOwoP/lv1FXFuJPocy66Wbd/snaOCKm0+J6W+tQ1UZ3VX6P65YTaz84z5
	 KxqzypE2ZAlY7n1DcpljoF5K91loHmAO5qoYHCyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Frank Li <Frank.Li@nxp.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 553/570] dmaengine: sh: rz-dmac: Move CHCTRL updates under spinlock
Date: Mon, 13 Apr 2026 18:01:24 +0200
Message-ID: <20260413155851.176648116@linuxfoundation.org>
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

[ Upstream commit 89a8567d84bde88cb7cdbbac2ab2299c4f991490 ]

Both rz_dmac_disable_hw() and rz_dmac_irq_handle_channel() update the
CHCTRL register. To avoid concurrency issues when configuring
functionalities exposed by this registers, take the virtual channel lock.
All other CHCTRL updates were already protected by the same lock.

Previously, rz_dmac_disable_hw() disabled and re-enabled local IRQs, before
accessing CHCTRL registers but this does not ensure race-free access.
Remove the local IRQ disable/enable code as well.

Fixes: 5000d37042a6 ("dmaengine: sh: Add DMAC driver for RZ/G2L SoC")
Cc: stable@vger.kernel.org
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20260316133252.240348-3-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[ replaced scoped_guard(spinlock_irqsave, ...) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/sh/rz-dmac.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/dma/sh/rz-dmac.c
+++ b/drivers/dma/sh/rz-dmac.c
@@ -283,13 +283,10 @@ static void rz_dmac_disable_hw(struct rz
 {
 	struct dma_chan *chan = &channel->vc.chan;
 	struct rz_dmac *dmac = to_rz_dmac(chan->device);
-	unsigned long flags;
 
 	dev_dbg(dmac->dev, "%s channel %d\n", __func__, channel->index);
 
-	local_irq_save(flags);
 	rz_dmac_ch_writel(channel, CHCTRL_DEFAULT, CHCTRL, 1);
-	local_irq_restore(flags);
 }
 
 static void rz_dmac_set_dmars_register(struct rz_dmac *dmac, int nr, u32 dmars)
@@ -536,8 +533,8 @@ static int rz_dmac_terminate_all(struct
 	unsigned int i;
 	LIST_HEAD(head);
 
-	rz_dmac_disable_hw(channel);
 	spin_lock_irqsave(&channel->vc.lock, flags);
+	rz_dmac_disable_hw(channel);
 	for (i = 0; i < DMAC_NR_LMDESC; i++)
 		lmdesc[i].header = 0;
 
@@ -646,13 +643,17 @@ static void rz_dmac_irq_handle_channel(s
 {
 	struct dma_chan *chan = &channel->vc.chan;
 	struct rz_dmac *dmac = to_rz_dmac(chan->device);
+	unsigned long flags;
 	u32 chstat, chctrl;
 
 	chstat = rz_dmac_ch_readl(channel, CHSTAT, 1);
 	if (chstat & CHSTAT_ER) {
 		dev_err(dmac->dev, "DMAC err CHSTAT_%d = %08X\n",
 			channel->index, chstat);
+
+		spin_lock_irqsave(&channel->vc.lock, flags);
 		rz_dmac_ch_writel(channel, CHCTRL_DEFAULT, CHCTRL, 1);
+		spin_unlock_irqrestore(&channel->vc.lock, flags);
 		goto done;
 	}
 


