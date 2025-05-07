Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE71214813;
	Wed,  7 May 2025 19:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645153; cv=none; b=lME9Qa5q5EPIOQimvvtQbDYWnuXy7DlLYIxD99yUPtxoy/9nVP2XfuuFTvgiDsZoAAUsJ8Ds672t4sGDP8abHeGNUPOoUOQtWxalWaOLVPI00w3ZEOCsoy3bq5vxcjptdQLOnR6FXejtioFgHFNV/uGpQIlDAxqMTqstuykcGsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645153; c=relaxed/simple;
	bh=WzzEUXnxg1uaa0RdEeEf/MpCJ2R3O6SvhMl5uRJz5TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoPNbANKeJcZmT6268PxkycOXY+3oltAIoVJQXjzYXWls7+7a3BpQG58oJc5hhAdqrfbFZ7rfjG4etwna/Cv+O/GU4DJA4lMMeX9pV/NGFB9mlZwaJTjknZfO887U1jAxq5hfBfAq4vsZf+WbipQQrImdDaXT/LB6dBvjjG6nYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuvTZxqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuvTZxqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9B2C4CEE2;
	Wed,  7 May 2025 19:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645152;
	bh=WzzEUXnxg1uaa0RdEeEf/MpCJ2R3O6SvhMl5uRJz5TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuvTZxqp3B8J2kchSaplz4b8zPRdCH/zlhw0gL5DgOM9gs12rW5xiSa9A6gSOzUc+
	 mTwfKcrnAw53iSoe63j4mdQNdRb97QFSfQIxI3LFFSrOPAA8LqBu6OSBY9C0O+fVIg
	 a2po/U6d9i3eGnnWUEZxpKs0ENWtTmDE1+0Gth+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/129] xhci: Set DESI bits in ERDP register correctly
Date: Wed,  7 May 2025 20:40:46 +0200
Message-ID: <20250507183817.950661455@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 044818a6cd808b38a5d179a5fb9940417de4ba24 ]

When using more than one Event Ring segment (ERSTSZ > 1), software shall
set the DESI bits in the ERDP register to the number of the segment to
which the upper ERDP bits are pointing.  The xHC may use the DESI bits
as a shortcut to determine whether it needs to check for an Event Ring
Full condition:  If it's enqueueing events in a different segment, it
need not compare its internal Enqueue Pointer with the Dequeue Pointer
in the upper bits of the ERDP register (sec 5.5.2.3.3).

Not setting the DESI bits correctly can result in the xHC enqueueing
events past the Dequeue Pointer.  On Renesas uPD720201 host controllers,
incorrect DESI bits cause an interrupt storm.  For comparison, VIA VL805
host controllers do not exhibit such problems.  Perhaps they do not take
advantage of the optimization afforded by the DESI bits.

To fix the issue, assign the segment number to each struct xhci_segment
in xhci_segment_alloc().  When advancing the Dequeue Pointer in
xhci_update_erst_dequeue(), write the segment number to the DESI bits.

On driver probe, set the DESI bits to zero in xhci_set_hc_event_deq() as
processing starts in segment 0.  Likewise on driver teardown, clear the
DESI bits to zero in xhci_free_interrupter() when clearing the upper
bits of the ERDP register.  Previously those functions (incorrectly)
treated the DESI bits as if they're declared RsvdP.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20231019102924.2797346-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: bea5892d0ed2 ("xhci: Limit time spent with xHC interrupts disabled during bus resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c  | 25 +++++++++++--------------
 drivers/usb/host/xhci-ring.c |  2 +-
 drivers/usb/host/xhci.h      |  1 +
 3 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index fbc486546b853..f236fba5cd248 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -29,6 +29,7 @@
 static struct xhci_segment *xhci_segment_alloc(struct xhci_hcd *xhci,
 					       unsigned int cycle_state,
 					       unsigned int max_packet,
+					       unsigned int num,
 					       gfp_t flags)
 {
 	struct xhci_segment *seg;
@@ -60,6 +61,7 @@ static struct xhci_segment *xhci_segment_alloc(struct xhci_hcd *xhci,
 		for (i = 0; i < TRBS_PER_SEGMENT; i++)
 			seg->trbs[i].link.control = cpu_to_le32(TRB_CYCLE);
 	}
+	seg->num = num;
 	seg->dma = dma;
 	seg->next = NULL;
 
@@ -324,6 +326,7 @@ static int xhci_alloc_segments_for_ring(struct xhci_hcd *xhci,
 		enum xhci_ring_type type, unsigned int max_packet, gfp_t flags)
 {
 	struct xhci_segment *prev;
+	unsigned int num = 0;
 	bool chain_links;
 
 	/* Set chain bit for 0.95 hosts, and for isoc rings on AMD 0.96 host */
@@ -331,16 +334,17 @@ static int xhci_alloc_segments_for_ring(struct xhci_hcd *xhci,
 			 (type == TYPE_ISOC &&
 			  (xhci->quirks & XHCI_AMD_0x96_HOST)));
 
-	prev = xhci_segment_alloc(xhci, cycle_state, max_packet, flags);
+	prev = xhci_segment_alloc(xhci, cycle_state, max_packet, num, flags);
 	if (!prev)
 		return -ENOMEM;
-	num_segs--;
+	num++;
 
 	*first = prev;
-	while (num_segs > 0) {
+	while (num < num_segs) {
 		struct xhci_segment	*next;
 
-		next = xhci_segment_alloc(xhci, cycle_state, max_packet, flags);
+		next = xhci_segment_alloc(xhci, cycle_state, max_packet, num,
+					  flags);
 		if (!next) {
 			prev = *first;
 			while (prev) {
@@ -353,7 +357,7 @@ static int xhci_alloc_segments_for_ring(struct xhci_hcd *xhci,
 		xhci_link_segments(prev, next, type, chain_links);
 
 		prev = next;
-		num_segs--;
+		num++;
 	}
 	xhci_link_segments(prev, *first, type, chain_links);
 	*last = prev;
@@ -1803,7 +1807,6 @@ xhci_free_interrupter(struct xhci_hcd *xhci, struct xhci_interrupter *ir)
 {
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
 	size_t erst_size;
-	u64 tmp64;
 	u32 tmp;
 
 	if (!ir)
@@ -1826,9 +1829,7 @@ xhci_free_interrupter(struct xhci_hcd *xhci, struct xhci_interrupter *ir)
 		tmp &= ERST_SIZE_MASK;
 		writel(tmp, &ir->ir_set->erst_size);
 
-		tmp64 = xhci_read_64(xhci, &ir->ir_set->erst_dequeue);
-		tmp64 &= (u64) ERST_PTR_MASK;
-		xhci_write_64(xhci, tmp64, &ir->ir_set->erst_dequeue);
+		xhci_write_64(xhci, ERST_EHB, &ir->ir_set->erst_dequeue);
 	}
 
 	/* free interrrupter event ring */
@@ -1935,7 +1936,6 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 
 static void xhci_set_hc_event_deq(struct xhci_hcd *xhci, struct xhci_interrupter *ir)
 {
-	u64 temp;
 	dma_addr_t deq;
 
 	deq = xhci_trb_virt_to_dma(ir->event_ring->deq_seg,
@@ -1943,15 +1943,12 @@ static void xhci_set_hc_event_deq(struct xhci_hcd *xhci, struct xhci_interrupter
 	if (!deq)
 		xhci_warn(xhci, "WARN something wrong with SW event ring dequeue ptr.\n");
 	/* Update HC event ring dequeue pointer */
-	temp = xhci_read_64(xhci, &ir->ir_set->erst_dequeue);
-	temp &= ERST_PTR_MASK;
 	/* Don't clear the EHB bit (which is RW1C) because
 	 * there might be more events to service.
 	 */
-	temp &= ~ERST_EHB;
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 		       "// Write event ring dequeue pointer, preserving EHB bit");
-	xhci_write_64(xhci, ((u64) deq & (u64) ~ERST_PTR_MASK) | temp,
+	xhci_write_64(xhci, ((u64) deq & (u64) ~ERST_PTR_MASK),
 			&ir->ir_set->erst_dequeue);
 }
 
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index cb94439629451..884a668cca367 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3167,7 +3167,7 @@ static void xhci_update_erst_dequeue(struct xhci_hcd *xhci,
 			return;
 
 		/* Update HC event ring dequeue pointer */
-		temp_64 &= ERST_DESI_MASK;
+		temp_64 = ir->event_ring->deq_seg->num & ERST_DESI_MASK;
 		temp_64 |= ((u64) deq & (u64) ~ERST_PTR_MASK);
 	}
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index df87e8bcb7d24..0325fccfaa2a4 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1293,6 +1293,7 @@ struct xhci_segment {
 	union xhci_trb		*trbs;
 	/* private to HCD */
 	struct xhci_segment	*next;
+	unsigned int		num;
 	dma_addr_t		dma;
 	/* Max packet sized bounce buffer for td-fragmant alignment */
 	dma_addr_t		bounce_dma;
-- 
2.39.5



