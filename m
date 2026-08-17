Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056BF422541;
	Mon, 17 Aug 2026 15:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979005; cv=none; b=DRVA/+a8ShrO9HYT3AjBKLtT1Wgry4nTFGGDelFhyJSHHYwF7eQKLwZF4KzcQ3WMzvgiYarM7CKLLfgwyvDUhj/Kd4TU/GpmKkoCh07uWeVnacDJpHAWHqO7crkYGOmmnV47DM2LOouQMZTqiW3kY+A9QrzKukKzqHtVGPPT0Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979005; c=relaxed/simple;
	bh=SvCjxxzcyJJ/6Vc4CoQ16rLL2+apd45X3hoioJIyLQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBMsH7o9sBzpOnPfSwANgKXCOEikwyPmDkG8sVQYKImOIWp9sw52O42e9wTtPuxbqL8WMoeMOK55hKUX6Z97Eu+1JFO2vv8gdVlxKubrIagnBOxsoFBuVobnv6iAV/2iq80RjInb/GyFaEZTFi6715zDQZNEBJKhd33Akl2HHqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MYt7gVRy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYt7gVRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E39B1F000E9;
	Mon, 17 Aug 2026 15:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979003;
	bh=oOr/0i4jeCg6SFWmRo4zrczGpHHqKaPQL2MgUao2iR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MYt7gVRydnFL3Dn4ZfuV8cLLSmHGVc0jkFEcFXohpit0ZI+UhM2/JrJDgw7JhsMnO
	 zZMgRVVYcnf69eDDIRAmc/QLdiqczXBp9PjqwgxVH3JuqmlRqIcNM1Ne3ryrgY2BbC
	 yncBNVlZO7Vn7o5EigACUwv+UixTuj5AWwf8D1cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+faf3a6cf579fc65591ca@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 076/609] usb: gadget: dummy_hcd: prevent fifo_req reuse during giveback
Date: Mon, 17 Aug 2026 15:26:12 +0200
Message-ID: <20260817132546.072290559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -277,6 +277,7 @@ struct dummy {
 	unsigned			ints_enabled:1;
 	unsigned			udc_suspended:1;
 	unsigned			pullup:1;
+	unsigned			fifo_req_busy:1;
 
 	/*
 	 * HOST side support
@@ -328,6 +329,26 @@ static inline struct dummy *gadget_dev_t
 
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
@@ -338,9 +359,7 @@ static void nuke(struct dummy *dum, stru
 		list_del_init(&req->queue);
 		req->req.status = -ESHUTDOWN;
 
-		spin_unlock(&dum->lock);
-		usb_gadget_giveback_request(&ep->ep, &req->req);
-		spin_lock(&dum->lock);
+		dummy_giveback(dum, &ep->ep, req);
 	}
 }
 
@@ -727,10 +746,11 @@ static int dummy_queue(struct usb_ep *_e
 
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
@@ -784,9 +804,7 @@ static int dummy_dequeue(struct usb_ep *
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
@@ -1909,9 +1925,7 @@ restart:
 				dev_dbg(udc_dev(dum), "stale req = %p\n",
 						req);
 
-				spin_unlock(&dum->lock);
-				usb_gadget_giveback_request(&ep->ep, &req->req);
-				spin_lock(&dum->lock);
+				dummy_giveback(dum, &ep->ep, req);
 				ep->already_seen = 0;
 				goto restart;
 			}


