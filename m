Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB5947F77E;
	Thu, 20 Aug 2026 16:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244355; cv=none; b=SnINVUayOGo9hBifsLqcyCYcQ5mfmj7TfQthssLg4OEKHXOFflXU9vvlNBRm0e6PH6Q/fLK+guKUgEPTfxtAd9iIxgksSbq7c6g/hp9R7FneFJkgTEErApIRGChEyOVO54l7ZYghqgbjntrg311J14MecXUNNShMVU59BbAO7YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244355; c=relaxed/simple;
	bh=dl3DPfEJVc7dpygCXS5KGnSCnhy9olG/TjzHZlBIY6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIzeNGAoP/Ob5vQGvfwW7xE4cfcrftMIMg3gFz6kL6tRbkF5k/5yZGDro58siIE7+7CXaw6q7HZ+RVvIZH464aDvy8a9Qg9rAr7Y1OUeHHans8U0CuoKncW8GJHKkQ58YaTr9a8fmVJatv2HQadCQRF6sGDk25RDAwRx6RbJ90w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTm0Y5vq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTm0Y5vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55A31F000E9;
	Thu, 20 Aug 2026 16:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244354;
	bh=fJQdmsgA7W8bX4QG72hQZmGQ2VbM1tu2PDM90c40s9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTm0Y5vqC2nktOCX7h5r47VHI/eo/STT8Cmu5ilMTwsQWg6D4dWPNpfzVoVyJQRnI
	 EfjlyEBIDiu2a46QY/cqwdm07hiWpm4kcMzaZDObShrxIjZgzW6Rhphlh0bShQPySs
	 KJZmX/GSlJENlfd/3fMZxdn90rLce6NN2/pXS1uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/235] dmaengine: dw-edma: Add spinlock to protect DONE_INT_MASK and ABORT_INT_MASK
Date: Thu, 20 Aug 2026 16:55:37 +0200
Message-ID: <20260820145219.517194018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 8ffba0171c6bbce5f093c6dba5a02c0805b31203 ]

The DONE_INT_MASK and ABORT_INT_MASK registers are shared by all DMA
channels, and modifying them requires a read-modify-write sequence.
Because this operation is not atomic, concurrent calls to
dw_edma_v0_core_start() can introduce race conditions if two channels
update these registers simultaneously.

Add a spinlock to serialize access to these registers and prevent race
conditions.

Fixes: 7e4b8a4fbe2c ("dmaengine: Add Synopsys eDMA IP version 0 support")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Li <Frank.Li@nxp.com>
[den: update dw_edma.lock comment]
Link: https://lore.kernel.org/dmaengine/20260109-edma_ll-v2-1-5c0b27b2c664@nxp.com/
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260521142153.2957432-5-den@valinux.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-edma-core.h    |    2 +-
 drivers/dma/dw-edma/dw-edma-v0-core.c |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/dma/dw-edma/dw-edma-core.h
+++ b/drivers/dma/dw-edma/dw-edma-core.h
@@ -131,7 +131,7 @@ struct dw_edma {
 
 	struct dw_edma_chan		*chan;
 
-	raw_spinlock_t			lock;		/* Only for legacy */
+	raw_spinlock_t			lock;		/* Protect v0 shared registers */
 
 	struct dw_edma_chip             *chip;
 
--- a/drivers/dma/dw-edma/dw-edma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-edma-v0-core.c
@@ -237,6 +237,7 @@ void dw_edma_v0_core_start(struct dw_edm
 {
 	struct dw_edma_chan *chan = chunk->chan;
 	struct dw_edma *dw = chan->dw;
+	unsigned long flags;
 	u32 tmp;
 
 	dw_edma_v0_core_write_chunk(chunk);
@@ -245,6 +246,8 @@ void dw_edma_v0_core_start(struct dw_edm
 		/* Enable engine */
 		SET_RW_32(dw, chan->dir, engine_en, BIT(0));
 		/* Interrupt unmask - done, abort */
+		raw_spin_lock_irqsave(&dw->lock, flags);
+
 		tmp = GET_RW_32(dw, chan->dir, int_mask);
 		tmp &= ~FIELD_PREP(EDMA_V0_DONE_INT_MASK, BIT(chan->id));
 		tmp &= ~FIELD_PREP(EDMA_V0_ABORT_INT_MASK, BIT(chan->id));
@@ -253,6 +256,9 @@ void dw_edma_v0_core_start(struct dw_edm
 		tmp = GET_RW_32(dw, chan->dir, linked_list_err_en);
 		tmp |= FIELD_PREP(EDMA_V0_LINKED_LIST_ERR_MASK, BIT(chan->id));
 		SET_RW_32(dw, chan->dir, linked_list_err_en, tmp);
+
+		raw_spin_unlock_irqrestore(&dw->lock, flags);
+
 		/* Channel control */
 		SET_CH_32(dw, chan->dir, chan->id, ch_control1,
 			  (DW_EDMA_V0_CCS | DW_EDMA_V0_LLE));


