Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EA7FBF6;
	Tue, 30 Sep 2025 15:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246242; cv=none; b=D8hjGXvNzh+mC/lmYmkceE5kMUHDaN9xDO4qwXo4zG5Q142WA7/hZ/JxCHZTIwrUV/soosMCJl6kaT74L4neaQdYtbmvAV08iverbHIGy9ouzs9V3e7rGPy7PvAwqU658HPZ/dWGhLN7WzMReqWmZhXejZ2W7RbpNw+P/KScEVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246242; c=relaxed/simple;
	bh=YELj6FiV9fJV+jD6GiMHnJ+VNyN2RGFb3vhUuqf48nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWuBtDt5wkg7DFQrleLGhKetTmPvE622lNVP5cGxMIlQsAMaN/Eybmn7P68WJvI6yUcRET5v7IDdKZW11pwweyS/J5EDkNAyE3hTbP1U7ylxKNW/gx1jiEFopUxNQrDr10FKXoYBG6DzxMksJhhl+4fcVCzqsJyc9LRNNs8sTww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EcYm1kjz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EcYm1kjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A26C4CEF0;
	Tue, 30 Sep 2025 15:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246242;
	bh=YELj6FiV9fJV+jD6GiMHnJ+VNyN2RGFb3vhUuqf48nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EcYm1kjz5dZGA0puLw5rueQmZ1zMSu0CBJWIk9VefMccdFr1xI4aFxVKjFn8SN1Rb
	 161YkEMPY/JM4BE+EAX0AHG0eY4gw9xB717TOSwX32EkbFI+mx4yjzyQlGTl65wy86
	 t3jF6le+uoY3/9Fe6E5IuPLYYKapjkZ7zCjNa8CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfgang Walter <linux@stwm.de>,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 89/89] Revert "usb: xhci: remove option to change a default rings TRB cycle bit"
Date: Tue, 30 Sep 2025 16:48:43 +0200
Message-ID: <20250930143825.577020516@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

From: Niklas Neronin <niklas.neronin@linux.intel.com>

Revert commit 9b28ef1e4cc07cdb35da257aa4358d0127168b68 which is upstream
commit e1b0fa863907a61e86acc19ce2d0633941907c8e

It causes regression in 6.12.49 stable, no issues in upstream.

Commit 9b28ef1e4cc0 ("usb: xhci: remove option to change a default
ring's TRB cycle bit") introduced a regression in 6.12.49 stable kernel.
The original commit was never intended for stable kernels, but was added
as a dependency for commit a5c98e8b1398 ("xhci: dbc: Fix full DbC
transfer ring after several reconnects").

Since this commit is more of an optimization, revert it and solve the
dependecy by modifying one line in xhci_dbc_ring_init(). Specifically,
commit a5c98e8b1398 ("xhci: dbc: Fix full DbC transfer ring after
several reconnects") moved function call xhci_initialize_ring_info()
into a separate function. To resolve the dependency, the arguments for
this function call are also reverted.

Closes: https://lore.kernel.org/stable/01b8c8de46251cfaad1329a46b7e3738@stwm.de/
Tested-by: Wolfgang Walter <linux@stwm.de>
Cc: stable@vger.kernel.org # v6.12.49
Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgcap.c |    2 -
 drivers/usb/host/xhci-mem.c    |   50 ++++++++++++++++++++++-------------------
 drivers/usb/host/xhci.c        |    2 -
 drivers/usb/host/xhci.h        |    6 +++-
 4 files changed, 33 insertions(+), 27 deletions(-)

--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -458,7 +458,7 @@ static void xhci_dbc_ring_init(struct xh
 		trb->link.segment_ptr = cpu_to_le64(ring->first_seg->dma);
 		trb->link.control = cpu_to_le32(LINK_TOGGLE | TRB_TYPE(TRB_LINK));
 	}
-	xhci_initialize_ring_info(ring);
+	xhci_initialize_ring_info(ring, 1);
 }
 
 static int xhci_dbc_reinit_ep_rings(struct xhci_dbc *dbc)
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -27,12 +27,14 @@
  * "All components of all Command and Transfer TRBs shall be initialized to '0'"
  */
 static struct xhci_segment *xhci_segment_alloc(struct xhci_hcd *xhci,
+					       unsigned int cycle_state,
 					       unsigned int max_packet,
 					       unsigned int num,
 					       gfp_t flags)
 {
 	struct xhci_segment *seg;
 	dma_addr_t	dma;
+	int		i;
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
 
 	seg = kzalloc_node(sizeof(*seg), flags, dev_to_node(dev));
@@ -54,6 +56,11 @@ static struct xhci_segment *xhci_segment
 			return NULL;
 		}
 	}
+	/* If the cycle state is 0, set the cycle bit to 1 for all the TRBs */
+	if (cycle_state == 0) {
+		for (i = 0; i < TRBS_PER_SEGMENT; i++)
+			seg->trbs[i].link.control = cpu_to_le32(TRB_CYCLE);
+	}
 	seg->num = num;
 	seg->dma = dma;
 	seg->next = NULL;
@@ -131,14 +138,6 @@ static void xhci_link_rings(struct xhci_
 
 	chain_links = xhci_link_chain_quirk(xhci, ring->type);
 
-	/* If the cycle state is 0, set the cycle bit to 1 for all the TRBs */
-	if (ring->cycle_state == 0) {
-		xhci_for_each_ring_seg(ring->first_seg, seg) {
-			for (int i = 0; i < TRBS_PER_SEGMENT; i++)
-				seg->trbs[i].link.control |= cpu_to_le32(TRB_CYCLE);
-		}
-	}
-
 	next = ring->enq_seg->next;
 	xhci_link_segments(ring->enq_seg, first, ring->type, chain_links);
 	xhci_link_segments(last, next, ring->type, chain_links);
@@ -288,7 +287,8 @@ void xhci_ring_free(struct xhci_hcd *xhc
 	kfree(ring);
 }
 
-void xhci_initialize_ring_info(struct xhci_ring *ring)
+void xhci_initialize_ring_info(struct xhci_ring *ring,
+			       unsigned int cycle_state)
 {
 	/* The ring is empty, so the enqueue pointer == dequeue pointer */
 	ring->enqueue = ring->first_seg->trbs;
@@ -302,7 +302,7 @@ void xhci_initialize_ring_info(struct xh
 	 * New rings are initialized with cycle state equal to 1; if we are
 	 * handling ring expansion, set the cycle state equal to the old ring.
 	 */
-	ring->cycle_state = 1;
+	ring->cycle_state = cycle_state;
 
 	/*
 	 * Each segment has a link TRB, and leave an extra TRB for SW
@@ -317,6 +317,7 @@ static int xhci_alloc_segments_for_ring(
 					struct xhci_segment **first,
 					struct xhci_segment **last,
 					unsigned int num_segs,
+					unsigned int cycle_state,
 					enum xhci_ring_type type,
 					unsigned int max_packet,
 					gfp_t flags)
@@ -327,7 +328,7 @@ static int xhci_alloc_segments_for_ring(
 
 	chain_links = xhci_link_chain_quirk(xhci, type);
 
-	prev = xhci_segment_alloc(xhci, max_packet, num, flags);
+	prev = xhci_segment_alloc(xhci, cycle_state, max_packet, num, flags);
 	if (!prev)
 		return -ENOMEM;
 	num++;
@@ -336,7 +337,8 @@ static int xhci_alloc_segments_for_ring(
 	while (num < num_segs) {
 		struct xhci_segment	*next;
 
-		next = xhci_segment_alloc(xhci, max_packet, num, flags);
+		next = xhci_segment_alloc(xhci, cycle_state, max_packet, num,
+					  flags);
 		if (!next)
 			goto free_segments;
 
@@ -361,8 +363,9 @@ free_segments:
  * Set the end flag and the cycle toggle bit on the last segment.
  * See section 4.9.1 and figures 15 and 16.
  */
-struct xhci_ring *xhci_ring_alloc(struct xhci_hcd *xhci, unsigned int num_segs,
-				  enum xhci_ring_type type, unsigned int max_packet, gfp_t flags)
+struct xhci_ring *xhci_ring_alloc(struct xhci_hcd *xhci,
+		unsigned int num_segs, unsigned int cycle_state,
+		enum xhci_ring_type type, unsigned int max_packet, gfp_t flags)
 {
 	struct xhci_ring	*ring;
 	int ret;
@@ -380,7 +383,7 @@ struct xhci_ring *xhci_ring_alloc(struct
 		return ring;
 
 	ret = xhci_alloc_segments_for_ring(xhci, &ring->first_seg, &ring->last_seg, num_segs,
-					   type, max_packet, flags);
+					   cycle_state, type, max_packet, flags);
 	if (ret)
 		goto fail;
 
@@ -390,7 +393,7 @@ struct xhci_ring *xhci_ring_alloc(struct
 		ring->last_seg->trbs[TRBS_PER_SEGMENT - 1].link.control |=
 			cpu_to_le32(LINK_TOGGLE);
 	}
-	xhci_initialize_ring_info(ring);
+	xhci_initialize_ring_info(ring, cycle_state);
 	trace_xhci_ring_alloc(ring);
 	return ring;
 
@@ -418,8 +421,8 @@ int xhci_ring_expansion(struct xhci_hcd
 	struct xhci_segment	*last;
 	int			ret;
 
-	ret = xhci_alloc_segments_for_ring(xhci, &first, &last, num_new_segs, ring->type,
-					   ring->bounce_buf_len, flags);
+	ret = xhci_alloc_segments_for_ring(xhci, &first, &last, num_new_segs, ring->cycle_state,
+					   ring->type, ring->bounce_buf_len, flags);
 	if (ret)
 		return -ENOMEM;
 
@@ -629,7 +632,8 @@ struct xhci_stream_info *xhci_alloc_stre
 
 	for (cur_stream = 1; cur_stream < num_streams; cur_stream++) {
 		stream_info->stream_rings[cur_stream] =
-			xhci_ring_alloc(xhci, 2, TYPE_STREAM, max_packet, mem_flags);
+			xhci_ring_alloc(xhci, 2, 1, TYPE_STREAM, max_packet,
+					mem_flags);
 		cur_ring = stream_info->stream_rings[cur_stream];
 		if (!cur_ring)
 			goto cleanup_rings;
@@ -970,7 +974,7 @@ int xhci_alloc_virt_device(struct xhci_h
 	}
 
 	/* Allocate endpoint 0 ring */
-	dev->eps[0].ring = xhci_ring_alloc(xhci, 2, TYPE_CTRL, 0, flags);
+	dev->eps[0].ring = xhci_ring_alloc(xhci, 2, 1, TYPE_CTRL, 0, flags);
 	if (!dev->eps[0].ring)
 		goto fail;
 
@@ -1453,7 +1457,7 @@ int xhci_endpoint_init(struct xhci_hcd *
 
 	/* Set up the endpoint ring */
 	virt_dev->eps[ep_index].new_ring =
-		xhci_ring_alloc(xhci, 2, ring_type, max_packet, mem_flags);
+		xhci_ring_alloc(xhci, 2, 1, ring_type, max_packet, mem_flags);
 	if (!virt_dev->eps[ep_index].new_ring)
 		return -ENOMEM;
 
@@ -2262,7 +2266,7 @@ xhci_alloc_interrupter(struct xhci_hcd *
 	if (!ir)
 		return NULL;
 
-	ir->event_ring = xhci_ring_alloc(xhci, segs, TYPE_EVENT, 0, flags);
+	ir->event_ring = xhci_ring_alloc(xhci, segs, 1, TYPE_EVENT, 0, flags);
 	if (!ir->event_ring) {
 		xhci_warn(xhci, "Failed to allocate interrupter event ring\n");
 		kfree(ir);
@@ -2468,7 +2472,7 @@ int xhci_mem_init(struct xhci_hcd *xhci,
 		goto fail;
 
 	/* Set up the command ring to have one segments for now. */
-	xhci->cmd_ring = xhci_ring_alloc(xhci, 1, TYPE_COMMAND, 0, flags);
+	xhci->cmd_ring = xhci_ring_alloc(xhci, 1, 1, TYPE_COMMAND, 0, flags);
 	if (!xhci->cmd_ring)
 		goto fail;
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -769,7 +769,7 @@ static void xhci_clear_command_ring(stru
 		seg->trbs[TRBS_PER_SEGMENT - 1].link.control &= cpu_to_le32(~TRB_CYCLE);
 	}
 
-	xhci_initialize_ring_info(ring);
+	xhci_initialize_ring_info(ring, 1);
 	/*
 	 * Reset the hardware dequeue pointer.
 	 * Yes, this will need to be re-written after resume, but we're paranoid
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1803,12 +1803,14 @@ void xhci_slot_copy(struct xhci_hcd *xhc
 int xhci_endpoint_init(struct xhci_hcd *xhci, struct xhci_virt_device *virt_dev,
 		struct usb_device *udev, struct usb_host_endpoint *ep,
 		gfp_t mem_flags);
-struct xhci_ring *xhci_ring_alloc(struct xhci_hcd *xhci, unsigned int num_segs,
+struct xhci_ring *xhci_ring_alloc(struct xhci_hcd *xhci,
+		unsigned int num_segs, unsigned int cycle_state,
 		enum xhci_ring_type type, unsigned int max_packet, gfp_t flags);
 void xhci_ring_free(struct xhci_hcd *xhci, struct xhci_ring *ring);
 int xhci_ring_expansion(struct xhci_hcd *xhci, struct xhci_ring *ring,
 		unsigned int num_trbs, gfp_t flags);
-void xhci_initialize_ring_info(struct xhci_ring *ring);
+void xhci_initialize_ring_info(struct xhci_ring *ring,
+			unsigned int cycle_state);
 void xhci_free_endpoint_ring(struct xhci_hcd *xhci,
 		struct xhci_virt_device *virt_dev,
 		unsigned int ep_index);


