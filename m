Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10943B995D;
	Tue, 21 Jul 2026 21:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670141; cv=none; b=anwFkP3EEd5X8dnH6gMjHaIVue2Q6oE5azry84G7Zj9UN3mbgxMG/mSk/pkbvd07m4pe3dWhCUBRVkGEGdPcZGhpv3zIznlLATfNfJ4etVD4pXbvFnyBu/K2wNgH33THKj/NvoStGdMNrYq7PDnljW3Rzt6DLy5D64K6SSQQMDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670141; c=relaxed/simple;
	bh=kuWizVtcnPyWzCmYEPPbOn7v38+pIJmDL/NJ0Vz9fpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNF/vuIvv4ZBW+bRgspfHE5DGAJM04AE0cbTyDQUJ1c5h+GVvidUMGYqgWvZfaFCw9YwoFdBIUE1sQE7YnPRwXRIzZitBSiutWMI+3McPOrOWQUI4sVFFuOBnJaViYrxwMDqFNUdYqEEhlKtzJbrn4ZiHrvQzjPJcKbm7uySlD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBuJIrjf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBuJIrjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD4C1F000E9;
	Tue, 21 Jul 2026 21:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670139;
	bh=syOORFP3gfElnC4jc0p5eMZe5zxM9YKt/o5idgQLfJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yBuJIrjfdxltreJ18fGZWRyhWdzl+tzQfh0YQ2tkzWLbjfelr1xGVhGqmmLvCcCCT
	 f/QPTYhzz90nz8loztvpWWF6ChHtDj/erGCsNF5Ff3tkInSyqTbo32H2yQTe8rvqte
	 DTOrY6032LzDOVDOvNT6/nosyX1+YMwb5FQ+xJkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 0820/1067] dmaengine: dw-edma: Add spinlock to protect DONE_INT_MASK and ABORT_INT_MASK
Date: Tue, 21 Jul 2026 17:23:41 +0200
Message-ID: <20260721152442.898366716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit 8ffba0171c6bbce5f093c6dba5a02c0805b31203 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-edma/dw-edma-core.h    |    2 +-
 drivers/dma/dw-edma/dw-edma-v0-core.c |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/dma/dw-edma/dw-edma-core.h
+++ b/drivers/dma/dw-edma/dw-edma-core.h
@@ -109,7 +109,7 @@ struct dw_edma {
 
 	struct dw_edma_chan		*chan;
 
-	raw_spinlock_t			lock;		/* Only for legacy */
+	raw_spinlock_t			lock;		/* Protect v0 shared registers */
 
 	struct dw_edma_chip             *chip;
 #ifdef CONFIG_DEBUG_FS
--- a/drivers/dma/dw-edma/dw-edma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-edma-v0-core.c
@@ -361,6 +361,7 @@ void dw_edma_v0_core_start(struct dw_edm
 {
 	struct dw_edma_chan *chan = chunk->chan;
 	struct dw_edma *dw = chan->dw;
+	unsigned long flags;
 	u32 tmp;
 
 	dw_edma_v0_core_write_chunk(chunk);
@@ -405,6 +406,8 @@ void dw_edma_v0_core_start(struct dw_edm
 			}
 		}
 		/* Interrupt unmask - done, abort */
+		raw_spin_lock_irqsave(&dw->lock, flags);
+
 		tmp = GET_RW_32(dw, chan->dir, int_mask);
 		tmp &= ~FIELD_PREP(EDMA_V0_DONE_INT_MASK, BIT(chan->id));
 		tmp &= ~FIELD_PREP(EDMA_V0_ABORT_INT_MASK, BIT(chan->id));
@@ -413,6 +416,9 @@ void dw_edma_v0_core_start(struct dw_edm
 		tmp = GET_RW_32(dw, chan->dir, linked_list_err_en);
 		tmp |= FIELD_PREP(EDMA_V0_LINKED_LIST_ERR_MASK, BIT(chan->id));
 		SET_RW_32(dw, chan->dir, linked_list_err_en, tmp);
+
+		raw_spin_unlock_irqrestore(&dw->lock, flags);
+
 		/* Channel control */
 		SET_CH_32(dw, chan->dir, chan->id, ch_control1,
 			  (DW_EDMA_V0_CCS | DW_EDMA_V0_LLE));


