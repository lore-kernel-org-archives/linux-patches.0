Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579073F54CB;
	Tue, 17 Mar 2026 16:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766032; cv=none; b=aO0i7mILaOLM0ZCCetaU6R0AniPZxdai0Zryj/q3yhgAgx3CRO2/CMJIOWuQIrVbY22wqG4/TR326ESh1QnsYiVbyi6Gk23FJY8zrXUTjRebdWco3W9Ofx/HH+LBxsYucZJKvSXrQc+Ybc3zWznNiJB00TyPyXWVSXlw7CzRwMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766032; c=relaxed/simple;
	bh=c0X2Sezdu62uQJKQs+qE7uv+KGPewXHoaeYAttqoYdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcmZaTwTM2XmiZhU/3X3nS3vx64H3TDuo/ijPHZ+gcGoePPYtfxrUMcnHnbA/E8HtechpDropW3m11tKG6JBgp6q7HAXNHi41ulr4qC8tH3Ooar/BsA5soXrS0V9Ke2UAVJwhhn5t5lanjWdqvcPLJwFHQy9h6m6/6sude3pPA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GRDFNwTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GRDFNwTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCECC4CEF7;
	Tue, 17 Mar 2026 16:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766032;
	bh=c0X2Sezdu62uQJKQs+qE7uv+KGPewXHoaeYAttqoYdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRDFNwTcyL6vdkKUQWitmEiTNv/0MmPEheDUAS4JbhtYvLBBbYuHrFW1m4DWj131S
	 kE6uHrYJafJxYT1y6sAtAKWxtaD7VYMG6mrA2T0soK+HfaZvn5jNzS50rxY1JUwNWd
	 osZUwi/WArEcXXcq8rMc9nyYCnNsEaFm1DSZCKcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.19 155/378] USB: usbcore: Introduce usb_bulk_msg_killable()
Date: Tue, 17 Mar 2026 17:31:52 +0100
Message-ID: <20260317163012.715589576@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 416909962e7cdf29fd01ac523c953f37708df93d upstream.

The synchronous message API in usbcore (usb_control_msg(),
usb_bulk_msg(), and so on) uses uninterruptible waits.  However,
drivers may call these routines in the context of a user thread, which
means it ought to be possible to at least kill them.

For this reason, introduce a new usb_bulk_msg_killable() function
which behaves the same as usb_bulk_msg() except for using
wait_for_completion_killable_timeout() instead of
wait_for_completion_timeout().  The same can be done later for
usb_control_msg() later on, if it turns out to be needed.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Suggested-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/linux-usb/3acfe838-6334-4f6d-be7c-4bb01704b33d@rowland.harvard.edu/
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
CC: stable@vger.kernel.org
Link: https://patch.msgid.link/248628b4-cc83-4e81-a620-3ce4e0376d41@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/message.c |   79 +++++++++++++++++++++++++++++++++++++++------
 include/linux/usb.h        |    5 +-
 2 files changed, 72 insertions(+), 12 deletions(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -42,16 +42,17 @@ static void usb_api_blocking_completion(
 
 
 /*
- * Starts urb and waits for completion or timeout. Note that this call
- * is NOT interruptible. Many device driver i/o requests should be
- * interruptible and therefore these drivers should implement their
- * own interruptible routines.
+ * Starts urb and waits for completion or timeout.
+ * Whether or not the wait is killable depends on the flag passed in.
+ * For example, compare usb_bulk_msg() and usb_bulk_msg_killable().
  */
-static int usb_start_wait_urb(struct urb *urb, int timeout, int *actual_length)
+static int usb_start_wait_urb(struct urb *urb, int timeout, int *actual_length,
+		bool killable)
 {
 	struct api_context ctx;
 	unsigned long expire;
 	int retval;
+	long rc;
 
 	init_completion(&ctx.done);
 	urb->context = &ctx;
@@ -61,12 +62,21 @@ static int usb_start_wait_urb(struct urb
 		goto out;
 
 	expire = timeout ? msecs_to_jiffies(timeout) : MAX_SCHEDULE_TIMEOUT;
-	if (!wait_for_completion_timeout(&ctx.done, expire)) {
+	if (killable)
+		rc = wait_for_completion_killable_timeout(&ctx.done, expire);
+	else
+		rc = wait_for_completion_timeout(&ctx.done, expire);
+	if (rc <= 0) {
 		usb_kill_urb(urb);
-		retval = (ctx.status == -ENOENT ? -ETIMEDOUT : ctx.status);
+		if (ctx.status != -ENOENT)
+			retval = ctx.status;
+		else if (rc == 0)
+			retval = -ETIMEDOUT;
+		else
+			retval = rc;
 
 		dev_dbg(&urb->dev->dev,
-			"%s timed out on ep%d%s len=%u/%u\n",
+			"%s timed out or killed on ep%d%s len=%u/%u\n",
 			current->comm,
 			usb_endpoint_num(&urb->ep->desc),
 			usb_urb_dir_in(urb) ? "in" : "out",
@@ -100,7 +110,7 @@ static int usb_internal_control_msg(stru
 	usb_fill_control_urb(urb, usb_dev, pipe, (unsigned char *)cmd, data,
 			     len, usb_api_blocking_completion, NULL);
 
-	retv = usb_start_wait_urb(urb, timeout, &length);
+	retv = usb_start_wait_urb(urb, timeout, &length, false);
 	if (retv < 0)
 		return retv;
 	else
@@ -385,10 +395,59 @@ int usb_bulk_msg(struct usb_device *usb_
 		usb_fill_bulk_urb(urb, usb_dev, pipe, data, len,
 				usb_api_blocking_completion, NULL);
 
-	return usb_start_wait_urb(urb, timeout, actual_length);
+	return usb_start_wait_urb(urb, timeout, actual_length, false);
 }
 EXPORT_SYMBOL_GPL(usb_bulk_msg);
 
+/**
+ * usb_bulk_msg_killable - Builds a bulk urb, sends it off and waits for completion in a killable state
+ * @usb_dev: pointer to the usb device to send the message to
+ * @pipe: endpoint "pipe" to send the message to
+ * @data: pointer to the data to send
+ * @len: length in bytes of the data to send
+ * @actual_length: pointer to a location to put the actual length transferred
+ *	in bytes
+ * @timeout: time in msecs to wait for the message to complete before
+ *	timing out (if 0 the wait is forever)
+ *
+ * Context: task context, might sleep.
+ *
+ * This function is just like usb_blk_msg() except that it waits in a
+ * killable state.
+ *
+ * Return:
+ * If successful, 0. Otherwise a negative error number. The number of actual
+ * bytes transferred will be stored in the @actual_length parameter.
+ *
+ */
+int usb_bulk_msg_killable(struct usb_device *usb_dev, unsigned int pipe,
+		 void *data, int len, int *actual_length, int timeout)
+{
+	struct urb *urb;
+	struct usb_host_endpoint *ep;
+
+	ep = usb_pipe_endpoint(usb_dev, pipe);
+	if (!ep || len < 0)
+		return -EINVAL;
+
+	urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!urb)
+		return -ENOMEM;
+
+	if ((ep->desc.bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
+			USB_ENDPOINT_XFER_INT) {
+		pipe = (pipe & ~(3 << 30)) | (PIPE_INTERRUPT << 30);
+		usb_fill_int_urb(urb, usb_dev, pipe, data, len,
+				usb_api_blocking_completion, NULL,
+				ep->desc.bInterval);
+	} else
+		usb_fill_bulk_urb(urb, usb_dev, pipe, data, len,
+				usb_api_blocking_completion, NULL);
+
+	return usb_start_wait_urb(urb, timeout, actual_length, true);
+}
+EXPORT_SYMBOL_GPL(usb_bulk_msg_killable);
+
 /*-------------------------------------------------------------------*/
 
 static void sg_clean(struct usb_sg_request *io)
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1869,8 +1869,9 @@ extern int usb_control_msg(struct usb_de
 extern int usb_interrupt_msg(struct usb_device *usb_dev, unsigned int pipe,
 	void *data, int len, int *actual_length, int timeout);
 extern int usb_bulk_msg(struct usb_device *usb_dev, unsigned int pipe,
-	void *data, int len, int *actual_length,
-	int timeout);
+	void *data, int len, int *actual_length, int timeout);
+extern int usb_bulk_msg_killable(struct usb_device *usb_dev, unsigned int pipe,
+	void *data, int len, int *actual_length, int timeout);
 
 /* wrappers around usb_control_msg() for the most common standard requests */
 int usb_control_msg_send(struct usb_device *dev, __u8 endpoint, __u8 request,


