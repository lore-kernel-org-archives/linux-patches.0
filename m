Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316064F93A3;
	Thu, 17 Sep 2026 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664254; cv=none; b=j6sz1I2TqQVYvY6pL7pk0X9DpmvTURL1DKjdB49tZw5h1HuNAkTcJOJQxX+UomQFGyMd5lY6MNyQyhjlS7sYUcmbLCkhAyn7VGYmqQ3VXXd7Ll1TZ5n+CCWw49MBEzAbvVMTGnk9ILhOZGj/MnNvqZJDlhqzVFSAQp7sDxcJres=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664254; c=relaxed/simple;
	bh=Wics+XY/EJgWKs6oD05T8LrrQQ/W3Zyk65+o+ct5j6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=haQPInQw0k2AT186BcH1Vcjj3PKB5shaAecrHaVBUBRB1ICgoqLHk1pAbgZOsHIg1xHeX3IiDv150irSfXw94rb8yQqJG6puKPPq2GHHhrfpZ5uexGXoSjvmeygeqXzAdJ44u3Cpp450XbWh/td2ntwvFNn5qOD2mFRcXkm4gSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pk2fSceY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pk2fSceY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6381F000FF;
	Thu, 17 Sep 2026 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664252;
	bh=DznF7fa2JGuLUrZNY4KtXcmiN/sMtNC2jPuJ7tZAZgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pk2fSceYdRUspIMVrX+3hLsrcshtTNJywGVDByBsbXn76vo517TyvJIHgjiSCAXC3
	 UxGl0EvFlxtCNk9Hj92Ok4ZftKjeLJWWkoew+eBhViNBcD9+cKV3MQf7ikoch/CM80
	 XydQW76k3aH6RVsDvKdhiB5IlWtFfBHDkOww/adY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0311/1250] usb: xhci: remove legacy num_trbs_free tracking
Date: Thu, 17 Sep 2026 16:01:46 +0100
Message-ID: <20260917151600.533912245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Neronin <niklas.neronin@linux.intel.com>

[ Upstream commit 7ee645963075651d72f8d85bee428a9b7f1f148c ]

Keeping track of free TRBs in a ring by adding and subtracting each time
a enqueue or dequeue pointer is modified has proven to be buggy and
complicated, especially over long periods of time.
The xhci driver has already moved to calculating free TRBs dynamically
based on ring size and the enqueue/dequeue positions.

The DbC path is the last user of 'num_trbs_free'. Rather than maintaining
two separate accounting mechanisms, remove the field entirely and switch
DbC to use xhci_num_trbs_free(). Since 'num_trbs_free' undercounts by one,
and xhci_num_trbs_free() does not, the check for sufficient free TRBs is
adjusted.

Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260603091132.1110849-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-dbgcap.c | 5 +----
 drivers/usb/host/xhci-mem.c    | 6 ------
 drivers/usb/host/xhci-ring.c   | 2 +-
 drivers/usb/host/xhci.h        | 2 +-
 4 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/xhci-dbgcap.c b/drivers/usb/host/xhci-dbgcap.c
index ecda964e018ac..e2e0694d0c22a 100644
--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -260,7 +260,6 @@ xhci_dbc_queue_trb(struct xhci_ring *ring, u32 field1,
 	trace_xhci_dbc_gadget_ep_queue(ring, &trb->generic,
 				       xhci_trb_virt_to_dma(ring->enq_seg,
 							    ring->enqueue));
-	ring->num_trbs_free--;
 	next = ++(ring->enqueue);
 	if (TRB_TYPE_LINK_LE32(next->link.control)) {
 		next->link.control ^= cpu_to_le32(TRB_CYCLE);
@@ -281,7 +280,7 @@ static int xhci_dbc_queue_bulk_tx(struct dbc_ep *dep,
 
 	num_trbs = count_trbs(req->dma, req->length);
 	WARN_ON(num_trbs != 1);
-	if (ring->num_trbs_free < num_trbs)
+	if (xhci_num_trbs_free(ring) <= num_trbs)
 		return -EBUSY;
 
 	addr	= req->dma;
@@ -782,7 +781,6 @@ static void dbc_handle_xfer_event(struct xhci_dbc *dbc, union xhci_trb *event)
 		}
 		if (r->status == -COMP_STALL_ERROR) {
 			dev_warn(dbc->dev, "Give back stale stalled req\n");
-			ring->num_trbs_free++;
 			xhci_dbc_giveback(r, 0);
 		}
 	}
@@ -847,7 +845,6 @@ static void dbc_handle_xfer_event(struct xhci_dbc *dbc, union xhci_trb *event)
 		break;
 	}
 
-	ring->num_trbs_free++;
 	req->actual = req->length - remain_length;
 	xhci_dbc_giveback(req, status);
 }
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 2bbbf64a32c87..932284dbd1b12 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -317,12 +317,6 @@ void xhci_initialize_ring_info(struct xhci_ring *ring)
 	 * handling ring expansion, set the cycle state equal to the old ring.
 	 */
 	ring->cycle_state = 1;
-
-	/*
-	 * Each segment has a link TRB, and leave an extra TRB for SW
-	 * accounting purpose
-	 */
-	ring->num_trbs_free = ring->num_segs * (TRBS_PER_SEGMENT - 1) - 1;
 }
 EXPORT_SYMBOL_GPL(xhci_initialize_ring_info);
 
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 75f0e438f34fd..5624765fb6645 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -339,7 +339,7 @@ static struct xhci_segment *trb_in_td(struct xhci_td *td, dma_addr_t suspect_dma
  * Only for transfer and command rings where driver is the producer, not for
  * event rings.
  */
-static unsigned int xhci_num_trbs_free(struct xhci_ring *ring)
+unsigned int xhci_num_trbs_free(struct xhci_ring *ring)
 {
 	struct xhci_segment *enq_seg = ring->enq_seg;
 	union xhci_trb *enq = ring->enqueue;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 5fd15b998b697..caa3fbee29f2c 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1368,7 +1368,6 @@ struct xhci_ring {
 	u32			cycle_state;
 	unsigned int		stream_id;
 	unsigned int		num_segs;
-	unsigned int		num_trbs_free; /* used only by xhci DbC */
 	unsigned int		bounce_buf_len;
 	enum xhci_ring_type	type;
 	u32			old_trb_comp_code;
@@ -1945,6 +1944,7 @@ void xhci_ring_doorbell_for_active_rings(struct xhci_hcd *xhci,
 void xhci_cleanup_command_queue(struct xhci_hcd *xhci);
 void inc_deq(struct xhci_hcd *xhci, struct xhci_ring *ring);
 unsigned int count_trbs(u64 addr, u64 len);
+unsigned int xhci_num_trbs_free(struct xhci_ring *ring);
 int xhci_stop_endpoint_sync(struct xhci_hcd *xhci, struct xhci_virt_ep *ep,
 			    int suspend, gfp_t gfp_flags);
 void xhci_process_cancelled_tds(struct xhci_virt_ep *ep);
-- 
2.53.0



