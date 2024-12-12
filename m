Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD17229677;
	Thu, 12 Dec 2024 17:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022835; cv=none; b=m/5VJtTjYK9EMK7+9svhPTQ7gKZDU6FyDC8oacaZDmPwwpc/5oN03+nD76tC5oNFWRnKq7UdPtbxRpN0WyudZVAIK1+QbFSDcyl3RIvj5g6TV6E4Wbs4HNL2Z35g4DGql4JlbkI9zir/kNNc+UxXCUbMD+yA021F7kKmKPuiolI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022835; c=relaxed/simple;
	bh=45HJAv7vsQOwuGUcJuPAcvL5AVL627pp46UKzk5W70g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOZeqAWDCYfvl5Lrj76VdqX4O5NRofEnpeXhPUkMTW6QHjDhbBZg17SQtvbF6W2L+SyP4akRPdxF8ixVQjQv4cIrj+KVis6MuUcxnR6SywqYesT9cfuWvbcPkLZxUQkdg4XehLDQH7tRS2NBmA6zLHv+vpXD52spYvvFCVhwu1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDOsDpS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDOsDpS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E07C4CECE;
	Thu, 12 Dec 2024 17:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022835;
	bh=45HJAv7vsQOwuGUcJuPAcvL5AVL627pp46UKzk5W70g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDOsDpS2mLC91X7FjT5UE3OL5nbLyzFb98ePgiSAjc70M3URbovfqKTes654TcKLA
	 hi/h0RI07Ro/GvXMnU+Kg/OJm+bjQ6Oq6LX0MN5wUxdFVJRtByfBoVtWZlSdWFFAwl
	 wtGTY9sSqyMqpqMojSUo3BI6fmlbWZfHiGMaNBB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 320/565] usb: xhci: Fix TD invalidation under pending Set TR Dequeue
Date: Thu, 12 Dec 2024 15:58:35 +0100
Message-ID: <20241212144324.250655676@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

commit 484c3bab2d5dfa13ff659a51a06e9a393141eefc upstream.

xhci_invalidate_cancelled_tds() may not work correctly if the hardware
is modifying endpoint or stream contexts at the same time by executing
a Set TR Dequeue command. And even if it worked, it would be unable to
queue Set TR Dequeue for the next stream, failing to clear xHC cache.

On stream endpoints, a chain of Set TR Dequeue commands may take some
time to execute and we may want to cancel more TDs during this time.
Currently this leads to Stop Endpoint completion handler calling this
function without testing for SET_DEQ_PENDING, which will trigger the
aforementioned problems when it happens.

On all endpoints, a halt condition causes Reset Endpoint to be queued
and an error status given to the class driver, which may unlink more
URBs in response. Stop Endpoint is queued and its handler may execute
concurrently with Set TR Dequeue queued by Reset Endpoint handler.

(Reset Endpoint handler calls this function too, but there seems to
be no possibility of it running concurrently with Set TR Dequeue).

Fix xhci_invalidate_cancelled_tds() to work correctly under a pending
Set TR Dequeue. Bail out of the function when SET_DEQ_PENDING is set,
then make the completion handler call the function again and also call
xhci_giveback_invalidated_tds(), which needs to be called next.

This seems to fix another potential bug, where the handler would call
xhci_invalidate_cancelled_tds(), which may clear some deferred TDs if
a sanity check fails, and the TDs wouldn't be given back promptly.

Said sanity check seems to be wrong and prone to false positives when
the endpoint halts, but fixing it is beyond the scope of this change,
besides ensuring that cleared TDs are given back properly.

Fixes: 5ceac4402f5d ("xhci: Handle TD clearing for multiple streams case")
CC: stable@vger.kernel.org
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241106101459.775897-33-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -961,6 +961,13 @@ static int xhci_invalidate_cancelled_tds
 	unsigned int		slot_id = ep->vdev->slot_id;
 	int			err;
 
+	/*
+	 * This is not going to work if the hardware is changing its dequeue
+	 * pointers as we look at them. Completion handler will call us later.
+	 */
+	if (ep->ep_state & SET_DEQ_PENDING)
+		return 0;
+
 	xhci = ep->xhci;
 
 	list_for_each_entry_safe(td, tmp_td, &ep->cancelled_td_list, cancelled_td_list) {
@@ -1386,7 +1393,6 @@ static void xhci_handle_cmd_set_deq(stru
 	struct xhci_ep_ctx *ep_ctx;
 	struct xhci_slot_ctx *slot_ctx;
 	struct xhci_td *td, *tmp_td;
-	bool deferred = false;
 
 	ep_index = TRB_TO_EP_INDEX(le32_to_cpu(trb->generic.field[3]));
 	stream_id = TRB_TO_STREAM_ID(le32_to_cpu(trb->generic.field[2]));
@@ -1487,8 +1493,6 @@ static void xhci_handle_cmd_set_deq(stru
 			xhci_dbg(ep->xhci, "%s: Giveback cancelled URB %p TD\n",
 				 __func__, td->urb);
 			xhci_td_cleanup(ep->xhci, td, ep_ring, td->status);
-		} else if (td->cancel_status == TD_CLEARING_CACHE_DEFERRED) {
-			deferred = true;
 		} else {
 			xhci_dbg(ep->xhci, "%s: Keep cancelled URB %p TD as cancel_status is %d\n",
 				 __func__, td->urb, td->cancel_status);
@@ -1499,11 +1503,15 @@ cleanup:
 	ep->queued_deq_seg = NULL;
 	ep->queued_deq_ptr = NULL;
 
-	if (deferred) {
-		/* We have more streams to clear */
+	/* Check for deferred or newly cancelled TDs */
+	if (!list_empty(&ep->cancelled_td_list)) {
 		xhci_dbg(ep->xhci, "%s: Pending TDs to clear, continuing with invalidation\n",
 			 __func__);
 		xhci_invalidate_cancelled_tds(ep);
+		/* Try to restart the endpoint if all is done */
+		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
+		/* Start giving back any TDs invalidated above */
+		xhci_giveback_invalidated_tds(ep);
 	} else {
 		/* Restart any rings with pending URBs */
 		xhci_dbg(ep->xhci, "%s: All TDs cleared, ring doorbell\n", __func__);


