Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB445FBB5;
	Tue, 13 Feb 2024 17:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845121; cv=none; b=YJyjEv1ef1eONF3bUac/paR4JTpvGMoBOnGOkhN1ZlcY9hKYBNN1xZYfwUmg26aUpuafubNp1LmTaL5Y71tIfd7+Zy4x3bVmmr7GhwmBiEXPIrm/36ckYH/22gP/QQfCAmaunzoAdRLtXgFcWfI6s7C38tbO7CsGnixbTAytxjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845121; c=relaxed/simple;
	bh=DlY/qvP5OeuX2Dg49+3oREk3twCCSc587LrrfNv/l/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oSSG1tYdnhAkjMIAAZI8AQilESP5aHiBfSUojboIxyaLSG++eNTmdY/R7px7p3oUkLPedlFm/ASmJb5V3abThVZ1rjbaxMdPRYobIkGC5V3UcX6l7AkEm3PKY82MvU7Q+Es7qb/uFsyjyAkSkdL1gVTyfumAFIMOA6l8MeCCKU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzs8zG0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzs8zG0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FB9C433F1;
	Tue, 13 Feb 2024 17:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845121;
	bh=DlY/qvP5OeuX2Dg49+3oREk3twCCSc587LrrfNv/l/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gzs8zG0SEWGJ2VUO5Avpr4+1mTuPuMldkW+MYNp9D65RcosZHIHHLQvVqTArkwOEl
	 MAcm0we2FFj0sn6nm+PUsfXSVYFab+O8Mpx0QIRAtZP7XsvU4bKyUgYtDKddWpef/X
	 gyz3pKk3kZHYt/IPkOQ5CiPjO6ZE4IEbbbUSd6do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Pecio?= <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 53/64] xhci: process isoc TD properly when there was a transaction error mid TD.
Date: Tue, 13 Feb 2024 18:21:39 +0100
Message-ID: <20240213171846.401480216@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 5372c65e1311a16351ef03dd096ff576e6477674 upstream.

The last TRB of a isoc TD might not trigger an event if there was
an error event for a TRB mid TD. This is seen on a NEC Corporation
uPD720200 USB 3.0 Host

After an error mid a multi-TRB TD the xHC should according to xhci 4.9.1
generate events for passed TRBs with IOC flag set if it proceeds to the
next TD. This event is either a copy of the original error, or a
"success" transfer event.

If that event is missing then the driver and xHC host get out of sync as
the driver is still expecting a transfer event for that first TD, while
xHC host is already sending events for the next TD in the list.
This leads to
"Transfer event TRB DMA ptr not part of current TD" messages.

As a solution we tag the isoc TDs that get error events mid TD.
If an event doesn't match the first TD, then check if the tag is
set, and event points to the next TD.
In that case give back the fist TD and process the next TD normally

Make sure TD status and transferred length stay valid in both cases
with and without final TD completion event.

Reported-by: Michał Pecio <michal.pecio@gmail.com>
Closes: https://lore.kernel.org/linux-usb/20240112235205.1259f60c@foxbook/
Tested-by: Michał Pecio <michal.pecio@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240125152737.2983959-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |   74 ++++++++++++++++++++++++++++++++++---------
 drivers/usb/host/xhci.h      |    1 
 2 files changed, 61 insertions(+), 14 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2363,6 +2363,9 @@ static int process_isoc_td(struct xhci_h
 	/* handle completion code */
 	switch (trb_comp_code) {
 	case COMP_SUCCESS:
+		/* Don't overwrite status if TD had an error, see xHCI 4.9.1 */
+		if (td->error_mid_td)
+			break;
 		if (remaining) {
 			frame->status = short_framestatus;
 			if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
@@ -2388,8 +2391,9 @@ static int process_isoc_td(struct xhci_h
 		break;
 	case COMP_USB_TRANSACTION_ERROR:
 		frame->status = -EPROTO;
+		sum_trbs_for_length = true;
 		if (ep_trb != td->last_trb)
-			return 0;
+			td->error_mid_td = true;
 		break;
 	case COMP_STOPPED:
 		sum_trbs_for_length = true;
@@ -2409,6 +2413,9 @@ static int process_isoc_td(struct xhci_h
 		break;
 	}
 
+	if (td->urb_length_set)
+		goto finish_td;
+
 	if (sum_trbs_for_length)
 		frame->actual_length = sum_trb_lengths(xhci, ep->ring, ep_trb) +
 			ep_trb_len - remaining;
@@ -2417,6 +2424,14 @@ static int process_isoc_td(struct xhci_h
 
 	td->urb->actual_length += frame->actual_length;
 
+finish_td:
+	/* Don't give back TD yet if we encountered an error mid TD */
+	if (td->error_mid_td && ep_trb != td->last_trb) {
+		xhci_dbg(xhci, "Error mid isoc TD, wait for final completion event\n");
+		td->urb_length_set = true;
+		return 0;
+	}
+
 	return finish_td(xhci, ep, ep_ring, td, trb_comp_code);
 }
 
@@ -2801,17 +2816,51 @@ static int handle_tx_event(struct xhci_h
 		}
 
 		if (!ep_seg) {
-			if (!ep->skip ||
-			    !usb_endpoint_xfer_isoc(&td->urb->ep->desc)) {
-				/* Some host controllers give a spurious
-				 * successful event after a short transfer.
-				 * Ignore it.
-				 */
-				if ((xhci->quirks & XHCI_SPURIOUS_SUCCESS) &&
-						ep_ring->last_td_was_short) {
-					ep_ring->last_td_was_short = false;
-					goto cleanup;
+
+			if (ep->skip && usb_endpoint_xfer_isoc(&td->urb->ep->desc)) {
+				skip_isoc_td(xhci, td, ep, status);
+				goto cleanup;
+			}
+
+			/*
+			 * Some hosts give a spurious success event after a short
+			 * transfer. Ignore it.
+			 */
+			if ((xhci->quirks & XHCI_SPURIOUS_SUCCESS) &&
+			    ep_ring->last_td_was_short) {
+				ep_ring->last_td_was_short = false;
+				goto cleanup;
+			}
+
+			/*
+			 * xhci 4.10.2 states isoc endpoints should continue
+			 * processing the next TD if there was an error mid TD.
+			 * So host like NEC don't generate an event for the last
+			 * isoc TRB even if the IOC flag is set.
+			 * xhci 4.9.1 states that if there are errors in mult-TRB
+			 * TDs xHC should generate an error for that TRB, and if xHC
+			 * proceeds to the next TD it should genete an event for
+			 * any TRB with IOC flag on the way. Other host follow this.
+			 * So this event might be for the next TD.
+			 */
+			if (td->error_mid_td &&
+			    !list_is_last(&td->td_list, &ep_ring->td_list)) {
+				struct xhci_td *td_next = list_next_entry(td, td_list);
+
+				ep_seg = trb_in_td(xhci, td_next->start_seg, td_next->first_trb,
+						   td_next->last_trb, ep_trb_dma, false);
+				if (ep_seg) {
+					/* give back previous TD, start handling new */
+					xhci_dbg(xhci, "Missing TD completion event after mid TD error\n");
+					ep_ring->dequeue = td->last_trb;
+					ep_ring->deq_seg = td->last_trb_seg;
+					inc_deq(xhci, ep_ring);
+					xhci_td_cleanup(xhci, td, ep_ring, td->status);
+					td = td_next;
 				}
+			}
+
+			if (!ep_seg) {
 				/* HC is busted, give up! */
 				xhci_err(xhci,
 					"ERROR Transfer event TRB DMA ptr not "
@@ -2823,9 +2872,6 @@ static int handle_tx_event(struct xhci_h
 					  ep_trb_dma, true);
 				return -ESHUTDOWN;
 			}
-
-			skip_isoc_td(xhci, td, ep, status);
-			goto cleanup;
 		}
 		if (trb_comp_code == COMP_SHORT_PACKET)
 			ep_ring->last_td_was_short = true;
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1570,6 +1570,7 @@ struct xhci_td {
 	struct xhci_segment	*bounce_seg;
 	/* actual_length of the URB has already been set */
 	bool			urb_length_set;
+	bool			error_mid_td;
 	unsigned int		num_trbs;
 };
 


