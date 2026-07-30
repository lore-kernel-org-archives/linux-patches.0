Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0644740B360;
	Thu, 30 Jul 2026 14:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421553; cv=none; b=hTn7W7wLCqgAqbBamrGUb1+9/q340DGyd2cBUJrn6TLx9BJzaAs0L24m8CCtXpY4IUIJ4ZhbP6OQnOaEncZae26XaIhwamx9UQuBrHonswTjuyPt91TwV3uDOzIvLZ85pBcs/aD0g2KZZnrLy2aseAdhO/ESuPsIydlzJIsHKSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421553; c=relaxed/simple;
	bh=QN0/5w5yqX9gwFZBK/szZRDHhUTo0ydXLQXubhz/vZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1zPLu2BDsmN6IsauNLerwmbyipombv7cSAouWysMlMcEpDq0fEL/0BwJsF/DPUDITSDdUzKu6nDiXUWFVCV2V0SQnS2LY10VGbm00nHw4ACC8+o3PuprCHiGnxfhwCK8fkuJTlALSXt93PGVhLH6Kg5dno/fkFqE/ULy90xgIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXWOss5d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXWOss5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2310A1F00A3A;
	Thu, 30 Jul 2026 14:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421551;
	bh=aEJqG3G1d/n01s5uZ8GfuUbndahYl/tDTO9ZY0I8Dxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXWOss5dhdcHj+uJcqI6OyU+E7NrUx6TouaponQDDFxG8InHfitEzk7FpHPxVAgOw
	 qO3+ZoRF//1lwKkBmYJ48o+dY1iQ3SYUN5OT2lHLuKnyegjXThdxIYuK/Y9QdRSrUO
	 gHuV/B4O7wlbrfL9Oy9PXGHPsfSjEYeluRMirSno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+faf3a6cf579fc65591ca@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 7.1 143/744] usb: gadget: dummy_hcd: prevent fifo_req reuse during giveback
Date: Thu, 30 Jul 2026 16:06:56 +0200
Message-ID: <20260730141447.326438208@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinchao Wang <wangjinchao600@gmail.com>

commit d5e5cd3654d2b5359a12ea6586120f05b28634ee upstream.

dummy_hcd embeds a single shared usb_request (dum->fifo_req) that the
"emulated single-request FIFO" fast-path in dummy_queue() reuses for
small IN transfers: it copies the caller's request into it
(req->req = *_req) and queues it, treating list_empty(&fifo_req.queue)
as "the slot is free".

The completion side (dummy_timer/transfer/nuke/dummy_dequeue) follows
the standard pattern: list_del_init(&req->queue) unlinks the request,
then the lock is dropped and usb_gadget_giveback_request() invokes
req->complete().  But list_del_init() makes fifo_req.queue look empty
*before* the completion callback returns, so a concurrent dummy_queue()
on another CPU sees the slot as free, reuses fifo_req and runs
req->req = *_req -- overwriting req->complete while dummy_timer is
mid-calling it.  The indirect call then jumps to a clobbered pointer,
causing a general protection fault / page fault in dummy_timer
(syzkaller extid faf3a6cf579fc65591ca).  The clobbering write is an
in-bounds memcpy on a live shared object, so KASAN cannot flag it.

Add a fifo_req_busy bit covering the shared request's whole lifetime:
set it in dummy_queue() when the FIFO fast-path takes fifo_req (making
it the fast-path guard, replacing the list_empty(&fifo_req.queue)
test), and clear it after the completion callback has returned, via a
dummy_giveback() helper used at all four gadget-request giveback
sites.  The shared slot can no longer be reused until its completion
callback has finished.

Reported-by: syzbot+faf3a6cf579fc65591ca@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=faf3a6cf579fc65591ca
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@kernel.org>
Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/5db8bba5b3499a86cd2e776f9918126b68b2508b.1784198306.git.wangjinchao600@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c |   40 ++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -278,6 +278,7 @@ struct dummy {
 	unsigned			ints_enabled:1;
 	unsigned			udc_suspended:1;
 	unsigned			pullup:1;
+	unsigned			fifo_req_busy:1;
 
 	/*
 	 * HOST side support
@@ -329,6 +330,26 @@ static inline struct dummy *gadget_dev_t
 
 /* DEVICE/GADGET SIDE UTILITY ROUTINES */
 
+/*
+ * Give back a gadget request with dum->lock dropped around the callback.
+ * If @req is the shared fifo_req, clear fifo_req_busy afterward: the flag
+ * was set in dummy_queue() when the shared request was taken and must stay
+ * set until its completion callback has returned; list_del_init() alone
+ * makes the request look idle while the callback is still running.
+ * Caller holds dum->lock and has already done list_del_init() + status.
+ */
+static void dummy_giveback(struct dummy *dum, struct usb_ep *_ep,
+			   struct dummy_request *req)
+{
+	bool fifo = req == &dum->fifo_req;
+
+	spin_unlock(&dum->lock);
+	usb_gadget_giveback_request(_ep, &req->req);
+	spin_lock(&dum->lock);
+	if (fifo)
+		dum->fifo_req_busy = 0;
+}
+
 /* called with spinlock held */
 static void nuke(struct dummy *dum, struct dummy_ep *ep)
 {
@@ -339,9 +360,7 @@ static void nuke(struct dummy *dum, stru
 		list_del_init(&req->queue);
 		req->req.status = -ESHUTDOWN;
 
-		spin_unlock(&dum->lock);
-		usb_gadget_giveback_request(&ep->ep, &req->req);
-		spin_lock(&dum->lock);
+		dummy_giveback(dum, &ep->ep, req);
 	}
 }
 
@@ -728,10 +747,11 @@ static int dummy_queue(struct usb_ep *_e
 
 	/* implement an emulated single-request FIFO */
 	if (ep->desc && (ep->desc->bEndpointAddress & USB_DIR_IN) &&
-			list_empty(&dum->fifo_req.queue) &&
+			!dum->fifo_req_busy &&
 			list_empty(&ep->queue) &&
 			_req->length <= FIFO_SIZE) {
 		req = &dum->fifo_req;
+		dum->fifo_req_busy = 1;
 		req->req = *_req;
 		req->req.buf = dum->fifo_buf;
 		memcpy(dum->fifo_buf, _req->buf, _req->length);
@@ -785,9 +805,7 @@ static int dummy_dequeue(struct usb_ep *
 		dev_dbg(udc_dev(dum),
 				"dequeued req %p from %s, len %d buf %p\n",
 				req, _ep->name, _req->length, _req->buf);
-		spin_unlock(&dum->lock);
-		usb_gadget_giveback_request(_ep, _req);
-		spin_lock(&dum->lock);
+		dummy_giveback(dum, _ep, req);
 	}
 	spin_unlock_irqrestore(&dum->lock, flags);
 	return retval;
@@ -1523,9 +1541,7 @@ top:
 		if (req->req.status != -EINPROGRESS) {
 			list_del_init(&req->queue);
 
-			spin_unlock(&dum->lock);
-			usb_gadget_giveback_request(&ep->ep, &req->req);
-			spin_lock(&dum->lock);
+			dummy_giveback(dum, &ep->ep, req);
 
 			/* requests might have been unlinked... */
 			rescan = 1;
@@ -1910,9 +1926,7 @@ restart:
 				dev_dbg(udc_dev(dum), "stale req = %p\n",
 						req);
 
-				spin_unlock(&dum->lock);
-				usb_gadget_giveback_request(&ep->ep, &req->req);
-				spin_lock(&dum->lock);
+				dummy_giveback(dum, &ep->ep, req);
 				ep->already_seen = 0;
 				goto restart;
 			}


