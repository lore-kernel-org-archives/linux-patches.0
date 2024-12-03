Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708151F8AC6;
	Tue,  3 Dec 2024 16:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242621; cv=none; b=qQETUlQisN70m4mzzDvr8bNHkWwJrFZZp06YwUgx1CyZUjC/Fa9nTWIco4q7d2yXdp8AdYUV3XtPfIEGnD6hIsrzjtT1xaKxCJzkCKCNPXblyIRCm2XSNXJUeiSL8VWaX4LUcAXsSCo7pXaCGefAc+iMRktoQp6qBWhyIedsNBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242621; c=relaxed/simple;
	bh=4MMwSP1EV1PqYK43qq5aRXDkLkDqPZs3cyC2PG3aqls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZOdLfrENWhHNqgjCv+q2p0grVWiThr0Qv06DB1jnYuD/rhQ1DkVAsc19t1kiJMVRGZXI/xcLtJMDydnF685CSUhrCN0U/gqZSSmTEjnT/C8wkph7w2d5fjHnv6ASby/wtPtkClIStZ48rYG/6cfIiujZLN+hqAFrb9YptD5ZxyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOgDIOVA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOgDIOVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2A4C4CECF;
	Tue,  3 Dec 2024 16:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242621;
	bh=4MMwSP1EV1PqYK43qq5aRXDkLkDqPZs3cyC2PG3aqls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOgDIOVAzizhQlcoAk6572JqVzXaYlked0+BwTR7SGGrTwYS5AzlPf1ZY26p1Y31b
	 iUe/Zqhuy2zPtlkO9CBkNuVJ4fkvyzIhcCfovTzLlWjdW7Vd5LYQjK/1xqxxxhXGBC
	 rhA6lj5pSTpVNswaIl+puPDzdBGnOnpDg3IDpPfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Hubert=20Wi=C5=9Bniewski?= <hubert.wisniewski.25632@gmail.com>
Subject: [PATCH 6.12 759/826] usb: musb: Fix hardware lockup on first Rx endpoint request
Date: Tue,  3 Dec 2024 15:48:06 +0100
Message-ID: <20241203144813.373667736@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hubert Wiśniewski <hubert.wisniewski.25632@gmail.com>

commit 3fc137386c4620305bbc2a216868c53f9245670a upstream.

There is a possibility that a request's callback could be invoked from
usb_ep_queue() (call trace below, supplemented with missing calls):

req->complete from usb_gadget_giveback_request
	(drivers/usb/gadget/udc/core.c:999)
usb_gadget_giveback_request from musb_g_giveback
	(drivers/usb/musb/musb_gadget.c:147)
musb_g_giveback from rxstate
	(drivers/usb/musb/musb_gadget.c:784)
rxstate from musb_ep_restart
	(drivers/usb/musb/musb_gadget.c:1169)
musb_ep_restart from musb_ep_restart_resume_work
	(drivers/usb/musb/musb_gadget.c:1176)
musb_ep_restart_resume_work from musb_queue_resume_work
	(drivers/usb/musb/musb_core.c:2279)
musb_queue_resume_work from musb_gadget_queue
	(drivers/usb/musb/musb_gadget.c:1241)
musb_gadget_queue from usb_ep_queue
	(drivers/usb/gadget/udc/core.c:300)

According to the docstring of usb_ep_queue(), this should not happen:

"Note that @req's ->complete() callback must never be called from within
usb_ep_queue() as that can create deadlock situations."

In fact, a hardware lockup might occur in the following sequence:

1. The gadget is initialized using musb_gadget_enable().
2. Meanwhile, a packet arrives, and the RXPKTRDY flag is set, raising an
   interrupt.
3. If IRQs are enabled, the interrupt is handled, but musb_g_rx() finds an
   empty queue (next_request() returns NULL). The interrupt flag has
   already been cleared by the glue layer handler, but the RXPKTRDY flag
   remains set.
4. The first request is enqueued using usb_ep_queue(), leading to the call
   of req->complete(), as shown in the call trace above.
5. If the callback enables IRQs and another packet is waiting, step (3)
   repeats. The request queue is empty because usb_g_giveback() removes the
   request before invoking the callback.
6. The endpoint remains locked up, as the interrupt triggered by hardware
   setting the RXPKTRDY flag has been handled, but the flag itself remains
   set.

For this scenario to occur, it is only necessary for IRQs to be enabled at
some point during the complete callback. This happens with the USB Ethernet
gadget, whose rx_complete() callback calls netif_rx(). If called in the
task context, netif_rx() disables the bottom halves (BHs). When the BHs are
re-enabled, IRQs are also enabled to allow soft IRQs to be processed. The
gadget itself is initialized at module load (or at boot if built-in), but
the first request is enqueued when the network interface is brought up,
triggering rx_complete() in the task context via ioctl(). If a packet
arrives while the interface is down, it can prevent the interface from
receiving any further packets from the USB host.

The situation is quite complicated with many parties involved. This
particular issue can be resolved in several possible ways:

1. Ensure that callbacks never enable IRQs. This would be difficult to
   enforce, as discovering how netif_rx() interacts with interrupts was
   already quite challenging and u_ether is not the only function driver.
   Similar "bugs" could be hidden in other drivers as well.
2. Disable MUSB interrupts in musb_g_giveback() before calling the callback
   and re-enable them afterwars (by calling musb_{dis,en}able_interrupts(),
   for example). This would ensure that MUSB interrupts are not handled
   during the callback, even if IRQs are enabled. In fact, it would allow
   IRQs to be enabled when releasing the lock. However, this feels like an
   inelegant hack.
3. Modify the interrupt handler to clear the RXPKTRDY flag if the request
   queue is empty. While this approach also feels like a hack, it wastes
   CPU time by attempting to handle incoming packets when the software is
   not ready to process them.
4. Flush the Rx FIFO instead of calling rxstate() in musb_ep_restart().
   This ensures that the hardware can receive packets when there is at
   least one request in the queue. Once IRQs are enabled, the interrupt
   handler will be able to correctly process the next incoming packet
   (eventually calling rxstate()). This approach may cause one or two
   packets to be dropped (two if double buffering is enabled), but this
   seems to be a minor issue, as packet loss can occur when the software is
   not yet ready to process them. Additionally, this solution makes the
   gadget driver compliant with the rule mentioned in the docstring of
   usb_ep_queue().

There may be additional solutions, but from these four, the last one has
been chosen as it seems to be the most appropriate, as it addresses the
"bad" behavior of the driver.

Fixes: baebdf48c360 ("net: dev: Makes sure netif_rx() can be invoked in any context.")
Cc: stable@vger.kernel.org
Signed-off-by: Hubert Wiśniewski <hubert.wisniewski.25632@gmail.com>
Link: https://lore.kernel.org/r/4ee1ead4525f78fb5909a8cbf99513ad0082ad21.camel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/musb_gadget.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1161,12 +1161,19 @@ void musb_free_request(struct usb_ep *ep
  */
 void musb_ep_restart(struct musb *musb, struct musb_request *req)
 {
+	u16 csr;
+	void __iomem *epio = req->ep->hw_ep->regs;
+
 	trace_musb_req_start(req);
 	musb_ep_select(musb->mregs, req->epnum);
-	if (req->tx)
+	if (req->tx) {
 		txstate(musb, req);
-	else
-		rxstate(musb, req);
+	} else {
+		csr = musb_readw(epio, MUSB_RXCSR);
+		csr |= MUSB_RXCSR_FLUSHFIFO | MUSB_RXCSR_P_WZC_BITS;
+		musb_writew(epio, MUSB_RXCSR, csr);
+		musb_writew(epio, MUSB_RXCSR, csr);
+	}
 }
 
 static int musb_ep_restart_resume_work(struct musb *musb, void *data)


