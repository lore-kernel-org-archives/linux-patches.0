Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3497223DD6;
	Tue, 30 Sep 2025 15:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245288; cv=none; b=J9i+LLzAoIcgDt2mXhKFjThFqPCwPTiHHK8272r4YEpS0TB6PlH7HY3+EhiEHpEEBu3M8Ykp+aaRSONUoFVQKW0ZabrMf84PQGXz1EGPuiUG02d3zC288INWpMxE5iE41QhYzoEiblEBrl9+gr6cV5vswg26vrHt3pxaosfFjNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245288; c=relaxed/simple;
	bh=aP/QiS6fd9V7GWY0j83Dg+8EgxGjBZ1seLzdwykvxUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGcFSLksolq3y4KZfUegptTpiNNWxBp44n3MlqchM/ljQ7bewUDBg35se3+3p2vuEntAfPRt9+m0UtoZA+E3UwyWavykWp2gIsir/eVgt0FEl2q6n/HKM0afGBq/kKGR+7ffmbn9IQQUc5vmQcZlfv+o9QyVlKinAsF5nj1OWTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcE8OQqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcE8OQqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E4CC4CEF0;
	Tue, 30 Sep 2025 15:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245287;
	bh=aP/QiS6fd9V7GWY0j83Dg+8EgxGjBZ1seLzdwykvxUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcE8OQqegKludCxFWsi64VYRbrLOOyKUG4wMVzjKFBYJixVrvRzGbfohLUd4lWMBo
	 zfAlMwPS71QOqW9llZMXxt3EqT/ko+iuhLwVbifOpniuAW1ILZ5i96FWxbKzBiSNrI
	 MZSXoywX6eDXcpi+fskL3gd6I7Fo+YPWG59fslHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/151] xhci: dbc: decouple endpoint allocation from initialization
Date: Tue, 30 Sep 2025 16:47:01 +0200
Message-ID: <20250930143831.222628070@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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


