Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246FE3BB112;
	Fri,  9 Oct 2026 14:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556696; cv=none; b=Khidst08RGf+1samvBNBHeVUO75F7VeUinEyDsYjy11Atd8Guf1ZApvNO8jGTfjY8dSZPL/0iJmj6Okx4taZUXaU1BO0iTjMxf5UqV99D1tBiyfWUPFHgjFsQD3gUE+ZqUwUCSvY4jesEGlKXl8tFDkQNEHBE9GKqke3kM6a80A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556696; c=relaxed/simple;
	bh=DZVqeBflRJLKgkz+4ZvdiwTSt/xqARGklOepdz0+YpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdQCP7oOxxs8RiqqBQA3h8aHwwbb7Lqpl8bT1ieLZT73DtNoNOB52uKAKIwkWo6l5d18TdppeQoaBvzrfFzpVI13MIbJxoJH7UrCL+KNkjIWRUEyOax71LuMjcbBmMOWVlEkQshC1dpTVdRSTT8OI1VSZiA07MYsncWZyQwGpMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aL0UfQC+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aL0UfQC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834511F000FF;
	Fri,  9 Oct 2026 14:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556695;
	bh=n4k6g7WNwylrWfpNHuiTgqTXaAVe5sKOw/PtY7tbpBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aL0UfQC+dgDz5Zbn5RIhE6IcczK+BYppYVBubyLQ8mDF82EFqzRiJttS61cS4V9Jk
	 qxSSm5MYT2nBU/RWUSFmHwmJdTw+PIKhI162phH8FSIBde6fXJyohyE9e0m4Tv965U
	 DAJW5VqmAkwps8Lum//h62xAA60RyvORFKA5T/Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minseo Kim <neck3922@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>
Subject: [PATCH 7.2 222/428] USB: gadget: dummy-hcd: Fix wait for outstanding request completions
Date: Fri,  9 Oct 2026 16:09:19 +0200
Message-ID: <20261009140950.995756555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit b263ff9b0fc5c1f371d65c4eb196b31263d039ff upstream.

The dummy-hcd driver emulates synchronize_irq() by waiting until its
private callback_usage counter drops to 0 (with the private lock not
held).  This counter is incremented whenever a gadget driver callback
occurs (which requires the private lock to be dropped), but not when a
request completion handler is called.

This is an oversight.  Request completion is triggered by timer
interrupts (emulating device IRQs in a real UDC), and the interrupt
handlers are supposed to have completed when the synchronize_irq()
emulation routine returns -- they aren't supposed to be in the middle
of a completion callback.  If this happens it can lead to a gadget
driver's unbind routine running before all outstanding request
completions have finished, maybe even allowing the gadget driver's
module to be unloaded while a completion handler is still running.

Fix the oversight by incrementing the callback_usage value across
request completion callbacks.

Link: https://lore.kernel.org/linux-usb/7a87e293-633c-4100-aa8d-91560ba5e5c5@rowland.harvard.edu/
Fixes: 7dbd8f4cabd9 ("USB: dummy-hcd: Fix erroneous synchronization change")
Tested-by: Minseo Kim <neck3922@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/f23b9e1a-f110-441a-a1d8-95f442ec09d5@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -343,9 +343,11 @@ static void dummy_giveback(struct dummy
 {
 	bool fifo = req == &dum->fifo_req;
 
+	++dum->callback_usage;
 	spin_unlock(&dum->lock);
 	usb_gadget_giveback_request(_ep, &req->req);
 	spin_lock(&dum->lock);
+	--dum->callback_usage;
 	if (fifo)
 		dum->fifo_req_busy = 0;
 }
@@ -759,11 +761,13 @@ static int dummy_queue(struct usb_ep *_e
 		req->req.complete = fifo_complete;
 
 		list_add_tail(&req->queue, &ep->queue);
+		++dum->callback_usage;
 		spin_unlock(&dum->lock);
 		_req->actual = _req->length;
 		_req->status = 0;
 		usb_gadget_giveback_request(_ep, _req);
 		spin_lock(&dum->lock);
+		--dum->callback_usage;
 	}  else
 		list_add_tail(&req->queue, &ep->queue);
 	spin_unlock_irqrestore(&dum->lock, flags);


