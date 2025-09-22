Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606352E2847;
	Mon, 22 Sep 2025 19:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569802; cv=none; b=g5WbU+AVIy8rzXSVUszThn83NrTxPYCGBIo+so+CYBSo6eN9Tcihq4tcoHWfRShOthrF6pCaPiknrpyVaFd99Z243RowQvbVolSH69I5Jf5pS4ugK5JheBrzw8pNzIloM4k4dFlHXegy/0lm+C+INPTq/PwPvdlVC1/hikCRu6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569802; c=relaxed/simple;
	bh=gur7xamk+jfLt6FKsGcMRxHW9K3xQ6WK6pzRW8GHzlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j819lgAZqIRqsAVwNB7394VPAd60yKXUbwyuwRvdhqb+N3bRTSPgZk7ietZgn3dePqRk3dvT1IDsfgfXytqQNC2KhEVOEakeUgVrIwHiy8vYjI88odfkSb6X11/ipUyqgxLmzlAvLoOxCDw+JNOWeR0o21tfsZzF/W4p4Sf8ZP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7VbOk+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7VbOk+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA4CC4CEF0;
	Mon, 22 Sep 2025 19:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569802;
	bh=gur7xamk+jfLt6FKsGcMRxHW9K3xQ6WK6pzRW8GHzlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7VbOk+umnOM6u5mxLBEOh2/0dC0hiiuvH+MQAB2uh3L0NgJGg1kkmQ80kYFhFNv/
	 fvRLVKac9dyyqUBk/xE0ezebI8rZVTNGNKI5tc9jBntKxMKrXK/1/7tKcY9nYwRqL3
	 18o9k7kLJsHN9kYSD7W38GIgIBkp0/i9M7RiRQ+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 62/70] xhci: dbc: decouple endpoint allocation from initialization
Date: Mon, 22 Sep 2025 21:30:02 +0200
Message-ID: <20250922192406.265582264@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 220a0ffde02f962c13bc752b01aa570b8c65a37b ]

Decouple allocation of endpoint ring buffer from initialization
of the buffer, and initialization of endpoint context parts from
from the rest of the contexts.

It allows driver to clear up and reinitialize endpoint rings
after disconnect without reallocating everything.

This is a prerequisite for the next patch that prevents the transfer
ring from filling up with cancelled (no-op) TRBs if a debug cable is
reconnected several times without transferring anything.

Cc: stable@vger.kernel.org
Fixes: dfba2174dc42 ("usb: xhci: Add DbC support in xHCI driver")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250902105306.877476-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgcap.c |   71 ++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 25 deletions(-)

--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -86,13 +86,34 @@ static u32 xhci_dbc_populate_strings(str
 	return string_length;
 }
 
+static void xhci_dbc_init_ep_contexts(struct xhci_dbc *dbc)
+{
+	struct xhci_ep_ctx      *ep_ctx;
+	unsigned int		max_burst;
+	dma_addr_t		deq;
+
+	max_burst               = DBC_CTRL_MAXBURST(readl(&dbc->regs->control));
+
+	/* Populate bulk out endpoint context: */
+	ep_ctx                  = dbc_bulkout_ctx(dbc);
+	deq                     = dbc_bulkout_enq(dbc);
+	ep_ctx->ep_info         = 0;
+	ep_ctx->ep_info2        = dbc_epctx_info2(BULK_OUT_EP, 1024, max_burst);
+	ep_ctx->deq             = cpu_to_le64(deq | dbc->ring_out->cycle_state);
+
+	/* Populate bulk in endpoint context: */
+	ep_ctx                  = dbc_bulkin_ctx(dbc);
+	deq                     = dbc_bulkin_enq(dbc);
+	ep_ctx->ep_info         = 0;
+	ep_ctx->ep_info2        = dbc_epctx_info2(BULK_IN_EP, 1024, max_burst);
+	ep_ctx->deq             = cpu_to_le64(deq | dbc->ring_in->cycle_state);
+}
+
 static void xhci_dbc_init_contexts(struct xhci_dbc *dbc, u32 string_length)
 {
 	struct dbc_info_context	*info;
-	struct xhci_ep_ctx	*ep_ctx;
 	u32			dev_info;
-	dma_addr_t		deq, dma;
-	unsigned int		max_burst;
+	dma_addr_t		dma;
 
 	if (!dbc)
 		return;
@@ -106,20 +127,8 @@ static void xhci_dbc_init_contexts(struc
 	info->serial		= cpu_to_le64(dma + DBC_MAX_STRING_LENGTH * 3);
 	info->length		= cpu_to_le32(string_length);
 
-	/* Populate bulk out endpoint context: */
-	ep_ctx			= dbc_bulkout_ctx(dbc);
-	max_burst		= DBC_CTRL_MAXBURST(readl(&dbc->regs->control));
-	deq			= dbc_bulkout_enq(dbc);
-	ep_ctx->ep_info		= 0;
-	ep_ctx->ep_info2	= dbc_epctx_info2(BULK_OUT_EP, 1024, max_burst);
-	ep_ctx->deq		= cpu_to_le64(deq | dbc->ring_out->cycle_state);
-
-	/* Populate bulk in endpoint context: */
-	ep_ctx			= dbc_bulkin_ctx(dbc);
-	deq			= dbc_bulkin_enq(dbc);
-	ep_ctx->ep_info		= 0;
-	ep_ctx->ep_info2	= dbc_epctx_info2(BULK_IN_EP, 1024, max_burst);
-	ep_ctx->deq		= cpu_to_le64(deq | dbc->ring_in->cycle_state);
+	/* Populate bulk in and out endpoint contexts: */
+	xhci_dbc_init_ep_contexts(dbc);
 
 	/* Set DbC context and info registers: */
 	lo_hi_writeq(dbc->ctx->dma, &dbc->regs->dccp);
@@ -421,6 +430,23 @@ dbc_alloc_ctx(struct device *dev, gfp_t
 	return ctx;
 }
 
+static void xhci_dbc_ring_init(struct xhci_ring *ring)
+{
+	struct xhci_segment *seg = ring->first_seg;
+
+	/* clear all trbs on ring in case of old ring */
+	memset(seg->trbs, 0, TRB_SEGMENT_SIZE);
+
+	/* Only event ring does not use link TRB */
+	if (ring->type != TYPE_EVENT) {
+		union xhci_trb *trb = &seg->trbs[TRBS_PER_SEGMENT - 1];
+
+		trb->link.segment_ptr = cpu_to_le64(ring->first_seg->dma);
+		trb->link.control = cpu_to_le32(LINK_TOGGLE | TRB_TYPE(TRB_LINK));
+	}
+	xhci_initialize_ring_info(ring, 1);
+}
+
 static struct xhci_ring *
 xhci_dbc_ring_alloc(struct device *dev, enum xhci_ring_type type, gfp_t flags)
 {
@@ -449,15 +475,10 @@ xhci_dbc_ring_alloc(struct device *dev,
 
 	seg->dma = dma;
 
-	/* Only event ring does not use link TRB */
-	if (type != TYPE_EVENT) {
-		union xhci_trb *trb = &seg->trbs[TRBS_PER_SEGMENT - 1];
-
-		trb->link.segment_ptr = cpu_to_le64(dma);
-		trb->link.control = cpu_to_le32(LINK_TOGGLE | TRB_TYPE(TRB_LINK));
-	}
 	INIT_LIST_HEAD(&ring->td_list);
-	xhci_initialize_ring_info(ring, 1);
+
+	xhci_dbc_ring_init(ring);
+
 	return ring;
 dma_fail:
 	kfree(seg);


