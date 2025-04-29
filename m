Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BD682C60;
	Tue, 29 Apr 2025 17:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946271; cv=none; b=TehQaTchYLQSKVDSrDjXVVs5XTodTZnDbUzQp6o+C3n8wQSf6FXixIT0MS+D8sDJnQwDi5hJGg2IHCkoltvVaFkYMjJmdKLzH+rZalDbELa7JfQASdrkh5aHt5RxSMaIhxsgQb8qdIbsEmZ8TQuHHX9/I+17Sk8F5PvQiEaFeGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946271; c=relaxed/simple;
	bh=z1aDlTfdvDkeWsJTiJ2pR5yZolONi+Cn7qTbI9Re8gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIO7zI2V+OJF8lUlKIBYEiRR8oXAn1t7fjfjVJuwQiBD2bNwnKbXrENMhL18Tfz8tP9bMK6edHAeTLwXr1OduIButtpw9uYDIw1TQyr8136fV94SHlypF+w3mMvV7LNUsi3c6+5PUmR0I54Wxv2fOlK1u3RNo17cv55OaZevx5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0I0BqEBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0I0BqEBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7401CC4CEE3;
	Tue, 29 Apr 2025 17:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946270;
	bh=z1aDlTfdvDkeWsJTiJ2pR5yZolONi+Cn7qTbI9Re8gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0I0BqEBZSr2P5B/CGSoUwlV2Rlz7b+kocp0DFlwaxT7EARmyZmgHxesZASF3dGpZs
	 aPLXr4KWVPDUI47uetPdM/1VrslcW5vJx1cgokylwo0JEwq1T+L5KGBZFddQ7Wvnmt
	 i1DNWGx8pGF+Not0Y0htE88eDD7LvA08VHNokT6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 210/311] usb: xhci: Fix isochronous Ring Underrun/Overrun event handling
Date: Tue, 29 Apr 2025 18:40:47 +0200
Message-ID: <20250429161129.605541237@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

[ Upstream commit 906dec15b9b321b546fd31a3c99ffc13724c7af4 ]

The TRB pointer of these events points at enqueue at the time of error
occurrence on xHCI 1.1+ HCs or it's NULL on older ones. By the time we
are handling the event, a new TD may be queued at this ring position.

I can trigger this race by rising interrupt moderation to increase IRQ
handling delay. Similar delay may occur naturally due to system load.

If this ever happens after a Missed Service Error, missed TDs will be
skipped and the new TD processed as if it matched the event. It could
be given back prematurely, risking data loss or buffer UAF by the xHC.

Don't complete TDs on xrun events and don't warn if queued TDs don't
match the event's TRB pointer, which can be NULL or a link/no-op TRB.
Don't warn if there are no queued TDs at all.

Now that it's safe, also handle xrun events if the skip flag is clear.
This ensures completion of any TD stuck in 'error mid TD' state right
before the xrun event, which could happen if a driver submits a finite
number of URBs to a buggy HC and then an error occurs on the last TD.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250306144954.3507700-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 7721215be79ff..12b1c14efeb21 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2664,6 +2664,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 	int status = -EINPROGRESS;
 	struct xhci_ep_ctx *ep_ctx;
 	u32 trb_comp_code;
+	bool ring_xrun_event = false;
 
 	slot_id = TRB_TO_SLOT_ID(le32_to_cpu(event->flags));
 	ep_index = TRB_TO_EP_ID(le32_to_cpu(event->flags)) - 1;
@@ -2770,14 +2771,12 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		 * Underrun Event for OUT Isoch endpoint.
 		 */
 		xhci_dbg(xhci, "Underrun event on slot %u ep %u\n", slot_id, ep_index);
-		if (ep->skip)
-			break;
-		return 0;
+		ring_xrun_event = true;
+		break;
 	case COMP_RING_OVERRUN:
 		xhci_dbg(xhci, "Overrun event on slot %u ep %u\n", slot_id, ep_index);
-		if (ep->skip)
-			break;
-		return 0;
+		ring_xrun_event = true;
+		break;
 	case COMP_MISSED_SERVICE_ERROR:
 		/*
 		 * When encounter missed service error, one or more isoc tds
@@ -2850,6 +2849,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		 */
 		if (trb_comp_code != COMP_STOPPED &&
 		    trb_comp_code != COMP_STOPPED_LENGTH_INVALID &&
+		    !ring_xrun_event &&
 		    !ep_ring->last_td_was_short) {
 			xhci_warn(xhci, "Event TRB for slot %u ep %u with no TDs queued\n",
 				  slot_id, ep_index);
@@ -2884,6 +2884,10 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 				goto check_endpoint_halted;
 			}
 
+			/* TD was queued after xrun, maybe xrun was on a link, don't panic yet */
+			if (ring_xrun_event)
+				return 0;
+
 			/*
 			 * Skip the Force Stopped Event. The 'ep_trb' of FSE is not in the current
 			 * TD pointed by 'ep_ring->dequeue' because that the hardware dequeue
@@ -2930,6 +2934,10 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 	 */
 	} while (ep->skip);
 
+	/* Get out if a TD was queued at enqueue after the xrun occurred */
+	if (ring_xrun_event)
+		return 0;
+
 	if (trb_comp_code == COMP_SHORT_PACKET)
 		ep_ring->last_td_was_short = true;
 	else
-- 
2.39.5



