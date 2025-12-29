Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5781B6D08;
	Mon, 29 Dec 2025 16:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025523; cv=none; b=XLb7oHo4POLdlpJEBlp+b/iiO8ydQeMTpBRUM017ixaJKcVOfAwYl9M0u/xDwz4DyrlEelUqB3RExrvfG0Ez8WI+PJz0KMbDlz+mefFyQ5k6S8vjp4jz8k5dwl4pyVPyOSn40DwedlM0LvfcoxyIDz6iwueWCKbsc3OWf4deCUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025523; c=relaxed/simple;
	bh=y0O0UHDR0uBhrYu5VL+XPRNW7eKBS6A4y1k+2X2x1j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pABGd2t1xm0Zdzy4DnvkSQvrCmjAliKhsxxC5m6yNxeRxJLt6TgqwPa7QaR5T1BDEGLcV5ClEhgsix07n+ht/TnmbPOc31noxEDjU91trkdHbLm35BpJ9zHJr9S7zz1nqUi9dpQW8eA4wBEeHfHp7lk9H7py9RJGFFcmgx/cU+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hl2BUW59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hl2BUW59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898C5C4CEF7;
	Mon, 29 Dec 2025 16:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025522;
	bh=y0O0UHDR0uBhrYu5VL+XPRNW7eKBS6A4y1k+2X2x1j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hl2BUW59KOC6zSYx3cwP0yd7cJdAl2aXKm2i6tIQ6KCvT8YAcbuz1WhTbxgkNAWNj
	 UU0RdhZvJcRyb5vUIF8n6ox+jx9ZPN8nS3ve3DBoJ59hNaUJKcnUxZjfO0YY5RSYmO
	 NW+fqKP2Mxq1GkBBkhi0wEMfbTNpkra3IkRXpNRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 201/430] usb: xhci: Dont unchain link TRBs on quirky HCs
Date: Mon, 29 Dec 2025 17:10:03 +0100
Message-ID: <20251229160731.751786124@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Michal Pecio <michal.pecio@gmail.com>

[ Upstream commit e6aec6d9f5794e85d2312497a5d81296d885090e ]

Some old HCs ignore transfer ring link TRBs whose chain bit is unset.
This breaks endpoint operation and sometimes makes it execute other
ring's TDs, which may corrupt their buffers or cause unwanted device
action. We avoid this by chaining all link TRBs on affected rings.

Fix an omission which allows them to be unchained by cancelling TDs.

The patch was tested by reproducing this condition on an isochronous
endpoint (non-power-of-two TDs are sometimes split not to cross 64K)
and printing link TRBs in trb_to_noop() on good and buggy HCs.

Actual hardware malfunction is rare since it requires Missed Service
Error shortly before the unchained link TRB, at least on NEC and AMD.
I have never seen it after commit bb0ba4cb1065 ("usb: xhci: Apply the
link chain quirk on NEC isoc endpoints"), but it's Russian roulette
and I can't test all affected hosts and workloads. Fairly often MSEs
happen after cancellation because the endpoint was stopped.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20251119142417.2820519-11-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 5bdcf9ab2b99..25185552287c 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -128,11 +128,11 @@ static void inc_td_cnt(struct urb *urb)
 	urb_priv->num_tds_done++;
 }
 
-static void trb_to_noop(union xhci_trb *trb, u32 noop_type)
+static void trb_to_noop(union xhci_trb *trb, u32 noop_type, bool unchain_links)
 {
 	if (trb_is_link(trb)) {
-		/* unchain chained link TRBs */
-		trb->link.control &= cpu_to_le32(~TRB_CHAIN);
+		if (unchain_links)
+			trb->link.control &= cpu_to_le32(~TRB_CHAIN);
 	} else {
 		trb->generic.field[0] = 0;
 		trb->generic.field[1] = 0;
@@ -465,7 +465,7 @@ static void xhci_handle_stopped_cmd_ring(struct xhci_hcd *xhci,
 		xhci_dbg(xhci, "Turn aborted command %p to no-op\n",
 			 i_cmd->command_trb);
 
-		trb_to_noop(i_cmd->command_trb, TRB_CMD_NOOP);
+		trb_to_noop(i_cmd->command_trb, TRB_CMD_NOOP, false);
 
 		/*
 		 * caller waiting for completion is called when command
@@ -797,13 +797,18 @@ static int xhci_move_dequeue_past_td(struct xhci_hcd *xhci,
  * (The last TRB actually points to the ring enqueue pointer, which is not part
  * of this TD.)  This is used to remove partially enqueued isoc TDs from a ring.
  */
-static void td_to_noop(struct xhci_td *td, bool flip_cycle)
+static void td_to_noop(struct xhci_hcd *xhci, struct xhci_virt_ep *ep,
+			struct xhci_td *td, bool flip_cycle)
 {
+	bool unchain_links;
 	struct xhci_segment *seg	= td->start_seg;
 	union xhci_trb *trb		= td->start_trb;
 
+	/* link TRBs should now be unchained, but some old HCs expect otherwise */
+	unchain_links = !xhci_link_chain_quirk(xhci, ep->ring ? ep->ring->type : TYPE_STREAM);
+
 	while (1) {
-		trb_to_noop(trb, TRB_TR_NOOP);
+		trb_to_noop(trb, TRB_TR_NOOP, unchain_links);
 
 		/* flip cycle if asked to */
 		if (flip_cycle && trb != td->start_trb && trb != td->end_trb)
@@ -1091,16 +1096,16 @@ static int xhci_invalidate_cancelled_tds(struct xhci_virt_ep *ep)
 						  "Found multiple active URBs %p and %p in stream %u?\n",
 						  td->urb, cached_td->urb,
 						  td->urb->stream_id);
-					td_to_noop(cached_td, false);
+					td_to_noop(xhci, ep, cached_td, false);
 					cached_td->cancel_status = TD_CLEARED;
 				}
-				td_to_noop(td, false);
+				td_to_noop(xhci, ep, td, false);
 				td->cancel_status = TD_CLEARING_CACHE;
 				cached_td = td;
 				break;
 			}
 		} else {
-			td_to_noop(td, false);
+			td_to_noop(xhci, ep, td, false);
 			td->cancel_status = TD_CLEARED;
 		}
 	}
@@ -1125,7 +1130,7 @@ static int xhci_invalidate_cancelled_tds(struct xhci_virt_ep *ep)
 				continue;
 			xhci_warn(xhci, "Failed to clear cancelled cached URB %p, mark clear anyway\n",
 				  td->urb);
-			td_to_noop(td, false);
+			td_to_noop(xhci, ep, td, false);
 			td->cancel_status = TD_CLEARED;
 		}
 	}
@@ -4273,7 +4278,7 @@ static int xhci_queue_isoc_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 	 */
 	urb_priv->td[0].end_trb = ep_ring->enqueue;
 	/* Every TRB except the first & last will have its cycle bit flipped. */
-	td_to_noop(&urb_priv->td[0], true);
+	td_to_noop(xhci, xep, &urb_priv->td[0], true);
 
 	/* Reset the ring enqueue back to the first TRB and its cycle bit. */
 	ep_ring->enqueue = urb_priv->td[0].start_trb;
-- 
2.51.0



