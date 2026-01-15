Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873D73D3315;
	Thu, 15 Jan 2026 17:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499874; cv=none; b=Pyzlb80hJjRmBBQ927yWaS5BcahcQFy2s8WXDRYx/3PXFWpN2aavvl0II57yPTNlnHcMoMe5ypJQ3jOpDupe3S6684K6K5OGzJRMQlEsl/ZvIUwMbz9VQthVN+BibqJ1sv3ET3EsSjraTcJF8pp/+smx6vzBpVlQjU5on8japC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499874; c=relaxed/simple;
	bh=DfecdWbEGGD3s3ruAWvQt71l+mFSEpTyIkjdWZ2KBlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBOqI/NI840BHzi/ZLJ6yjtDD3CnUn2uekQqn1QcgnahhdPAhVnd+2mcfKSQKH/DWKgoJg/kgEfDooz96/OMQLL44f20ICZng3ZeNaaijbaUkf0/6ls62Ld2jG+uyptxiZH0vYKCSumDGYQBf/SCVcabOb8MLS7kO08AoBR3sY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuAmIgLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuAmIgLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148ECC116D0;
	Thu, 15 Jan 2026 17:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499874;
	bh=DfecdWbEGGD3s3ruAWvQt71l+mFSEpTyIkjdWZ2KBlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zuAmIgLsnROqciPdF6/w8CN1RN0gCs718wg49HCEu7WW68qYKhh4lt6ZpuN5dA2QL
	 DeHUTMIqPSyBMcViTuDdlsF9vwfhMtK/fUxbtuYAQZuTCLrkHkbrc5rlnI4zcD97lb
	 62Dw6UU91gxH0qFwgWFtEgr833zPGof0gvuJXqAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 5.10 346/451] usb: xhci: move link chain bit quirk checks into one helper function.
Date: Thu, 15 Jan 2026 17:49:07 +0100
Message-ID: <20260115164243.412573100@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Niklas Neronin <niklas.neronin@linux.intel.com>

commit 7476a2215c07703db5e95efaa3fc5b9f957b9417 upstream.

Older 0.95 xHCI hosts and some other specific newer hosts require the
chain bit to be set for Link TRBs even if the link TRB is not in the
middle of a transfer descriptor (TD).

move the checks for all those cases  into one xhci_link_chain_quirk()
function to clean up and avoid code duplication.

No functional changes.

[skip renaming chain_links flag, reword commit message -Mathias]

Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240626124835.1023046-10-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Shivani: Modified to apply on v5.10.y-v6.1.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mem.c  |   10 ++--------
 drivers/usb/host/xhci-ring.c |    8 ++------
 drivers/usb/host/xhci.h      |    7 +++++--
 3 files changed, 9 insertions(+), 16 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -133,10 +133,7 @@ static void xhci_link_rings(struct xhci_
 	if (!ring || !first || !last)
 		return;
 
-	/* Set chain bit for 0.95 hosts, and for isoc rings on AMD 0.96 host */
-	chain_links = !!(xhci_link_trb_quirk(xhci) ||
-			 (ring->type == TYPE_ISOC &&
-			  (xhci->quirks & XHCI_AMD_0x96_HOST)));
+	chain_links = xhci_link_chain_quirk(xhci, ring->type);
 
 	next = ring->enq_seg->next;
 	xhci_link_segments(ring->enq_seg, first, ring->type, chain_links);
@@ -326,10 +323,7 @@ static int xhci_alloc_segments_for_ring(
 	struct xhci_segment *prev;
 	bool chain_links;
 
-	/* Set chain bit for 0.95 hosts, and for isoc rings on AMD 0.96 host */
-	chain_links = !!(xhci_link_trb_quirk(xhci) ||
-			 (type == TYPE_ISOC &&
-			  (xhci->quirks & XHCI_AMD_0x96_HOST)));
+	chain_links = xhci_link_chain_quirk(xhci, type);
 
 	prev = xhci_segment_alloc(xhci, cycle_state, max_packet, flags);
 	if (!prev)
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -230,9 +230,7 @@ static void inc_enq(struct xhci_hcd *xhc
 		 * AMD 0.96 host, carry over the chain bit of the previous TRB
 		 * (which may mean the chain bit is cleared).
 		 */
-		if (!(ring->type == TYPE_ISOC &&
-		      (xhci->quirks & XHCI_AMD_0x96_HOST)) &&
-		    !xhci_link_trb_quirk(xhci)) {
+		if (!xhci_link_chain_quirk(xhci, ring->type)) {
 			next->link.control &= cpu_to_le32(~TRB_CHAIN);
 			next->link.control |= cpu_to_le32(chain);
 		}
@@ -3138,9 +3136,7 @@ static int prepare_ring(struct xhci_hcd
 		/* If we're not dealing with 0.95 hardware or isoc rings
 		 * on AMD 0.96 host, clear the chain bit.
 		 */
-		if (!xhci_link_trb_quirk(xhci) &&
-		    !(ep_ring->type == TYPE_ISOC &&
-		      (xhci->quirks & XHCI_AMD_0x96_HOST)))
+		if (!xhci_link_chain_quirk(xhci, ep_ring->type))
 			ep_ring->enqueue->link.control &=
 				cpu_to_le32(~TRB_CHAIN);
 		else
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1998,9 +1998,12 @@ static inline void xhci_write_64(struct
 	lo_hi_writeq(val, regs);
 }
 
-static inline int xhci_link_trb_quirk(struct xhci_hcd *xhci)
+
+/* Link TRB chain should always be set on 0.95 hosts, and AMD 0.96 ISOC rings */
+static inline bool xhci_link_chain_quirk(struct xhci_hcd *xhci, enum xhci_ring_type type)
 {
-	return xhci->quirks & XHCI_LINK_TRB_QUIRK;
+	return (xhci->quirks & XHCI_LINK_TRB_QUIRK) ||
+	       (type == TYPE_ISOC && (xhci->quirks & XHCI_AMD_0x96_HOST));
 }
 
 /* xHCI debugging */


