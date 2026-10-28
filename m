Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208781;
	b=dx0yQk9KISTsg9C42AnjLwQJ6asLzqvzyOzDpki10fRI9fT7zBAQKeoVSWrMJYgetKnK
	 edFxOzl0Y72L93tZNCtXf2lAFrjjwPVDFwZ41mnsj1mxj+D8zfiQaYnt2EgFs4paRFuvw
	 fO5B3pD6aVZ3rngkw3JhbU1b5Ym9yPnYp8nOpJJ+pihDJPkenLavNOCGAn7BRkw2wxtWc
	 VYU7GJ6Tr5EjAMkhMNUrNSqmjelZOst/ahTlxEAjsxDaZWLvKJTqDiQBAyWLM6RVz4a2m
	 ShvGqJRRU67DLDnd9Vl6wjtoh4itJYo7Ik2CJgOxK3RgrLjMFpAJI7B77CUQWu70lEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hktkzAGJnjMtb5Cz6wQrX2Zk88DB9jYoJozdo3zNVqY=;
	b=vQZ97VbURg3T3rXBGV2l7ni3AY6u+u6aGjU9jdoWFMZREYxP5pWuCkIaH140puCuOwhG
	 cHWFagpa+wpWnAHdAzQXa5nEGrQs0hNPVum0Qi/5mTJyF8hL7rsLG/lH/KoONKPMAhF0X
	 eNa9q9IIHkZ9gGOs+XtzveqWzu6aMHAvZMCmI8ARTt/UkXDb3Ba/VsHevK4XLm3Dma8Cg
	 9J/M11iIYWC7oK+lHyx6O3qip/rMCAYhp+xKZw+h6zAqH0qWSuz3bJ+qzFsVjRDxDOdgG
	 Yd3U8DjbiELiEwkNJsEgmSr3qsX77LfuopQvUFir62+S3l19LXoI9AeQwGyhweBdPJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1z+zLznr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F97F606A31A;
	Wed, 28 Oct 2026 17:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1z+zLznr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AEB1F01825;
	Wed, 28 Oct 2026 17:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208781;
	bh=hktkzAGJnjMtb5Cz6wQrX2Zk88DB9jYoJozdo3zNVqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1z+zLznroq7TYfJX/sItjhv8jDJ2uimfWXq0t4SCcVm+Xz1Yp6Dvls07nAtUC8RAH
	 em8TyRBVVKyUbvukpibbv6q4eLGOAkD1O6vdDdcSxfrLBcpJOpdJ4/JUg+sdaOEsko
	 5DCz3BRspb1I+jfApe7lw7JseVEZdXGrBljz2a2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minseo Kim <neck3922@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 196/516] USB: gadget: dummy-hcd: Fix wait for outstanding request completions
Date: Wed, 28 Oct 2026 17:55:48 +0100
Message-ID: <20261028170008.145697938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -339,9 +339,11 @@ static void dummy_giveback(struct dummy
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
@@ -753,11 +755,13 @@ static int dummy_queue(struct usb_ep *_e
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


