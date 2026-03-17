Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31743F23B3;
	Tue, 17 Mar 2026 16:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766045; cv=none; b=U90jMBTMouvjutbgUEelkB3TQ+3m5pwgAzNtIfderm+wNl8DHdjEPJ+c9KVOonwkIkndcNeV8M+UhsPAB4oreo+e7vw+XxvTNgngo0waZ3AIpcR8kkyBSbUpQZ3eToejY8euurr3WDinJHms+dYbW0+uEYTvj+Bu0TEgokHUO3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766045; c=relaxed/simple;
	bh=/bZnktj/O/JTiVmzYbe9wPn7/2OQOQKCdTt5CXzw6nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cups60momlbooKi/WEi5Rjao7KcbBdBuXnIiipm616a1534+wg986/vd8bdT0g8YeDGrIF4G527ZWV/nh9gvAvEgRi7UeVPfPzd/vlhUpelQVEi8H54l/Oc9nEp8VSrJXakLYwZqW6YLWE4cV5ycbMww29msasc3QIDK8tZkUm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOE1ZFC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOE1ZFC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA395C4CEF7;
	Tue, 17 Mar 2026 16:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766045;
	bh=/bZnktj/O/JTiVmzYbe9wPn7/2OQOQKCdTt5CXzw6nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOE1ZFC0n14kNQvNBbVmcrRXteGaTF+6fnBcWkU7ubqU6TTof3N7zEJE9lulu4BmT
	 mhIkHzLX07TUfLgryDrGR+UGzFNrUS49sS0yT29cUL8moEK1cKMkthYLiANMgf2rXH
	 soiY3VGQatUOTyN/G7EeXzg7/z7QJeLbvu2Mufcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.19 157/378] USB: core: Limit the length of unkillable synchronous timeouts
Date: Tue, 17 Mar 2026 17:31:54 +0100
Message-ID: <20260317163012.788975784@linuxfoundation.org>
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

commit 1015c27a5e1a63efae2b18a9901494474b4d1dc3 upstream.

The usb_control_msg(), usb_bulk_msg(), and usb_interrupt_msg() APIs in
usbcore allow unlimited timeout durations.  And since they use
uninterruptible waits, this leaves open the possibility of hanging a
task for an indefinitely long time, with no way to kill it short of
unplugging the target device.

To prevent this sort of problem, enforce a maximum limit on the length
of these unkillable timeouts.  The limit chosen here, somewhat
arbitrarily, is 60 seconds.  On many systems (although not all) this
is short enough to avoid triggering the kernel's hung-task detector.

In addition, clear up the ambiguity of negative timeout values by
treating them the same as 0, i.e., using the maximum allowed timeout.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/linux-usb/3acfe838-6334-4f6d-be7c-4bb01704b33d@rowland.harvard.edu/
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
CC: stable@vger.kernel.org
Link: https://patch.msgid.link/15fc9773-a007-47b0-a703-df89a8cf83dd@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/message.c |   27 +++++++++++++--------------
 include/linux/usb.h        |    3 +++
 2 files changed, 16 insertions(+), 14 deletions(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -45,6 +45,8 @@ static void usb_api_blocking_completion(
  * Starts urb and waits for completion or timeout.
  * Whether or not the wait is killable depends on the flag passed in.
  * For example, compare usb_bulk_msg() and usb_bulk_msg_killable().
+ *
+ * For non-killable waits, we enforce a maximum limit on the timeout value.
  */
 static int usb_start_wait_urb(struct urb *urb, int timeout, int *actual_length,
 		bool killable)
@@ -61,7 +63,9 @@ static int usb_start_wait_urb(struct urb
 	if (unlikely(retval))
 		goto out;
 
-	expire = timeout ? msecs_to_jiffies(timeout) : MAX_SCHEDULE_TIMEOUT;
+	if (!killable && (timeout <= 0 || timeout > USB_MAX_SYNCHRONOUS_TIMEOUT))
+		timeout = USB_MAX_SYNCHRONOUS_TIMEOUT;
+	expire = (timeout > 0) ? msecs_to_jiffies(timeout) : MAX_SCHEDULE_TIMEOUT;
 	if (killable)
 		rc = wait_for_completion_killable_timeout(&ctx.done, expire);
 	else
@@ -127,8 +131,7 @@ static int usb_internal_control_msg(stru
  * @index: USB message index value
  * @data: pointer to the data to send
  * @size: length in bytes of the data to send
- * @timeout: time in msecs to wait for the message to complete before timing
- *	out (if 0 the wait is forever)
+ * @timeout: time in msecs to wait for the message to complete before timing out
  *
  * Context: task context, might sleep.
  *
@@ -183,8 +186,7 @@ EXPORT_SYMBOL_GPL(usb_control_msg);
  * @index: USB message index value
  * @driver_data: pointer to the data to send
  * @size: length in bytes of the data to send
- * @timeout: time in msecs to wait for the message to complete before timing
- *	out (if 0 the wait is forever)
+ * @timeout: time in msecs to wait for the message to complete before timing out
  * @memflags: the flags for memory allocation for buffers
  *
  * Context: !in_interrupt ()
@@ -242,8 +244,7 @@ EXPORT_SYMBOL_GPL(usb_control_msg_send);
  * @index: USB message index value
  * @driver_data: pointer to the data to be filled in by the message
  * @size: length in bytes of the data to be received
- * @timeout: time in msecs to wait for the message to complete before timing
- *	out (if 0 the wait is forever)
+ * @timeout: time in msecs to wait for the message to complete before timing out
  * @memflags: the flags for memory allocation for buffers
  *
  * Context: !in_interrupt ()
@@ -314,8 +315,7 @@ EXPORT_SYMBOL_GPL(usb_control_msg_recv);
  * @len: length in bytes of the data to send
  * @actual_length: pointer to a location to put the actual length transferred
  *	in bytes
- * @timeout: time in msecs to wait for the message to complete before
- *	timing out (if 0 the wait is forever)
+ * @timeout: time in msecs to wait for the message to complete before timing out
  *
  * Context: task context, might sleep.
  *
@@ -347,8 +347,7 @@ EXPORT_SYMBOL_GPL(usb_interrupt_msg);
  * @len: length in bytes of the data to send
  * @actual_length: pointer to a location to put the actual length transferred
  *	in bytes
- * @timeout: time in msecs to wait for the message to complete before
- *	timing out (if 0 the wait is forever)
+ * @timeout: time in msecs to wait for the message to complete before timing out
  *
  * Context: task context, might sleep.
  *
@@ -408,12 +407,12 @@ EXPORT_SYMBOL_GPL(usb_bulk_msg);
  * @actual_length: pointer to a location to put the actual length transferred
  *	in bytes
  * @timeout: time in msecs to wait for the message to complete before
- *	timing out (if 0 the wait is forever)
+ *	timing out (if <= 0, the wait is as long as possible)
  *
  * Context: task context, might sleep.
  *
- * This function is just like usb_blk_msg() except that it waits in a
- * killable state.
+ * This function is just like usb_blk_msg(), except that it waits in a
+ * killable state and there is no limit on the timeout length.
  *
  * Return:
  * If successful, 0. Otherwise a negative error number. The number of actual
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1863,6 +1863,9 @@ void usb_free_noncoherent(struct usb_dev
  *                         SYNCHRONOUS CALL SUPPORT                  *
  *-------------------------------------------------------------------*/
 
+/* Maximum value allowed for timeout in synchronous routines below */
+#define USB_MAX_SYNCHRONOUS_TIMEOUT		60000	/* ms */
+
 extern int usb_control_msg(struct usb_device *dev, unsigned int pipe,
 	__u8 request, __u8 requesttype, __u16 value, __u16 index,
 	void *data, __u16 size, int timeout);


