Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82B7215F7C;
	Tue, 29 Apr 2025 17:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948042; cv=none; b=b1aPh36JZl71ByjUypyJ0clbYkEmLWFBx2mqPJP5ORn0KL8ia94Bvg4WokXXlfPL2VZw4fisO8hjABDSqBV8RfasaqCEdtPQxow8fenqsserv/1IpFSeat7vd1EjC7oitWcy9eIKUUqL5+2JwsaZSBkGqayq8T5adOM267WUC30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948042; c=relaxed/simple;
	bh=X6nZXCwuWkydgbONGjLsdRE2uTkFxspzLEZ1los9m68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4dhqkp15THbX5b97I8TZvm/UvaNp3mkW0IIBxU+P9v6omNZzTVSQ9PK2KM8e7eVSGYc0g1ckLWIFeekAE9V/TUnReL9ZM8Mm7rkoqZTcNRC3TWrPW/hdCuh1ubETDOB4ZXZpvfT2TPrY45iw6K85E1s2lPv9sTDp5l6PwUEv5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Py8ZwP9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Py8ZwP9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52724C4CEE3;
	Tue, 29 Apr 2025 17:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948042;
	bh=X6nZXCwuWkydgbONGjLsdRE2uTkFxspzLEZ1los9m68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Py8ZwP9n/NR8zt1ljhS/8lE/jeaoL1QjO++mlQ2ViDmcrB2nPCtCCLj4dhIjF8Mp1
	 61FHhvUPuWXL0SZ4aVK8sy8zOhU1S8OwbM2BT7K27+lRPrhME94FMoG8+/xBtkTC76
	 y/+9McmYg9eYJkv6flBLNer5dx+cn7DurWcjsmco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/280] usb: xhci: Fix isochronous Ring Underrun/Overrun event handling
Date: Tue, 29 Apr 2025 18:41:58 +0200
Message-ID: <20250429161122.350363777@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7001f9725cf7c..6eb297b168fa4 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2662,6 +2662,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 	int status = -EINPROGRESS;
 	struct xhci_ep_ctx *ep_ctx;
 	u32 trb_comp_code;
+	bool ring_xrun_event = false;
 
 	slot_id = TRB_TO_SLOT_ID(le32_to_cpu(event->flags));
 	ep_index = TRB_TO_EP_ID(le32_to_cpu(event->flags)) - 1;
@@ -2768,14 +2769,12 @@ static int handle_tx_event(struct xhci_hcd *xhci,
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
@@ -2851,6 +2850,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		 */
 		if (trb_comp_code != COMP_STOPPED &&
 		    trb_comp_code != COMP_STOPPED_LENGTH_INVALID &&
+		    !ring_xrun_event &&
 		    !ep_ring->last_td_was_short) {
 			xhci_warn(xhci, "Event TRB for slot %u ep %u with no TDs queued\n",
 				  slot_id, ep_index);
@@ -2885,6 +2885,10 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 				goto check_endpoint_halted;
 			}
 
+			/* TD was queued after xrun, maybe xrun was on a link, don't panic yet */
+			if (ring_xrun_event)
+				return 0;
+
 			/*
 			 * Skip the Force Stopped Event. The 'ep_trb' of FSE is not in the current
 			 * TD pointed by 'ep_ring->dequeue' because that the hardware dequeue
@@ -2931,6 +2935,10 @@ static int handle_tx_event(struct xhci_hcd *xhci,
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



