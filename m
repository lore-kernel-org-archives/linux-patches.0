Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBE318EFD6;
	Wed,  3 Jul 2024 10:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003680; cv=none; b=ZRBg0mQqi29Ymy+voNBGXN/CP9BKC7gqzZbiWTFZWVosQZ9VmPtSbn2fPjNxPQW5Uq3k+k6sTEOaAzzebEXPmL8N7dbYY2deTzM53Go/DLml+tSotAiG5XqdXs83pPpzJujh7YjoogT5vVyoM41MG9yvw1RRMYBsSwaM93pd0Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003680; c=relaxed/simple;
	bh=fHxEcQq4okh4sLJie27rwAU0lBCEj+NKr9UVNP1xYG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvrqxhzZEeDSix5OM0FfQ+su5XbQXQ92orj1LGJfQDwgHv/Dr1wqIkV9N42k1aN2HY4e4VRKxr8JmvTbv5mVwRuvA4EolU4yFNwXTtfjrveW8j7wNH/5wRVMA4rJ8OtlHBzL6JU2XfZf07kVKfzxXWZNfZr8DxnX8FqF+VYH6go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRNVEKTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRNVEKTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59863C2BD10;
	Wed,  3 Jul 2024 10:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003679;
	bh=fHxEcQq4okh4sLJie27rwAU0lBCEj+NKr9UVNP1xYG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRNVEKTFjVQHPu1jEGr9shyczMf0vp7YuD890kVv+V9B44OPvUikXvMo8npnve7r8
	 eXtTWGejuXea1SGWGMlRnPITwsIyqQxsJk7phKmlvtwv3rBtZCR3RUx4ZheFNGq7wY
	 uyBJvv0MJOgk4cHvHzRQNuEnV8tPCublJPyPWRZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 096/139] xhci: Use soft retry to recover faster from transaction errors
Date: Wed,  3 Jul 2024 12:39:53 +0200
Message-ID: <20240703102834.065083791@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit f8f80be501aa2f10669585c3e328fad079d8cb3a ]

Use soft retry to recover from a USB Transaction Errors that are caused by
temporary error conditions. The USB device is not aware that the xHC
has halted the endpoint, and will be waiting for another retry

A Soft Retry perform additional retries and recover from an error which has
caused the xHC to halt an endpoint.

Soft retry has some limitations:
Soft Retry attempts shall not be performed on Isoch endpoints
Soft Retry attempts shall not be performed if the device is behind a TT in
a HS Hub

Software shall limit the number of unsuccessful Soft Retry attempts to
prevent an infinite loop.

For more details on Soft retry see xhci specs  4.6.8.1

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f0260589b439 ("xhci: Set correct transferred length for cancelled bulk transfers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 19 +++++++++++++++++++
 drivers/usb/host/xhci.h      |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 8723c7f1c24fe..614fb89ddef61 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1213,6 +1213,10 @@ static void xhci_handle_cmd_reset_ep(struct xhci_hcd *xhci, int slot_id,
 		/* Clear our internal halted state */
 		ep->ep_state &= ~EP_HALTED;
 	}
+
+	/* if this was a soft reset, then restart */
+	if ((le32_to_cpu(trb->generic.field[3])) & TRB_TSP)
+		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 }
 
 static void xhci_handle_cmd_enable_slot(struct xhci_hcd *xhci, int slot_id,
@@ -2245,10 +2249,16 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	union xhci_trb *ep_trb, struct xhci_transfer_event *event,
 	struct xhci_virt_ep *ep, int *status)
 {
+	struct xhci_slot_ctx *slot_ctx;
 	struct xhci_ring *ep_ring;
 	u32 trb_comp_code;
 	u32 remaining, requested, ep_trb_len;
+	unsigned int slot_id;
+	int ep_index;
 
+	slot_id = TRB_TO_SLOT_ID(le32_to_cpu(event->flags));
+	slot_ctx = xhci_get_slot_ctx(xhci, xhci->devs[slot_id]->out_ctx);
+	ep_index = TRB_TO_EP_ID(le32_to_cpu(event->flags)) - 1;
 	ep_ring = xhci_dma_to_transfer_ring(ep, le64_to_cpu(event->buffer));
 	trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
 	remaining = EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
@@ -2257,6 +2267,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 
 	switch (trb_comp_code) {
 	case COMP_SUCCESS:
+		ep_ring->err_count = 0;
 		/* handle success with untransferred data as short packet */
 		if (ep_trb != td->last_trb || remaining) {
 			xhci_warn(xhci, "WARN Successful completion on short TX\n");
@@ -2280,6 +2291,14 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		ep_trb_len	= 0;
 		remaining	= 0;
 		break;
+	case COMP_USB_TRANSACTION_ERROR:
+		if ((ep_ring->err_count++ > MAX_SOFT_RETRY) ||
+		    le32_to_cpu(slot_ctx->tt_info) & TT_SLOT)
+			break;
+		*status = 0;
+		xhci_cleanup_halted_endpoint(xhci, slot_id, ep_index,
+					ep_ring->stream_id, td, EP_SOFT_RESET);
+		return 0;
 	default:
 		/* do nothing */
 		break;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index f2bf3431cd6f4..cd5eb506ddd18 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1517,6 +1517,7 @@ static inline const char *xhci_trb_type_string(u8 type)
 /* How much data is left before the 64KB boundary? */
 #define TRB_BUFF_LEN_UP_TO_BOUNDARY(addr)	(TRB_MAX_BUFF_SIZE - \
 					(addr & (TRB_MAX_BUFF_SIZE - 1)))
+#define MAX_SOFT_RETRY		3
 
 struct xhci_segment {
 	union xhci_trb		*trbs;
@@ -1604,6 +1605,7 @@ struct xhci_ring {
 	 * if we own the TRB (if we are the consumer).  See section 4.9.1.
 	 */
 	u32			cycle_state;
+	unsigned int            err_count;
 	unsigned int		stream_id;
 	unsigned int		num_segs;
 	unsigned int		num_trbs_free;
-- 
2.43.0



