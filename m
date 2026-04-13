Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6686E3093B2;
	Mon, 13 Apr 2026 16:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097453; cv=none; b=i/67nPHuDV05gYUOJOfEOrrnrHh/X/vkMNVf/2eC+fAaB71RNfCo4kVvgkFh5bkXwV9JxJLKkicEI9Zh+9oq1sVnqcXxfhCnjo6aNArRgeri31stoe9hSGRy2ki89p6M2hfyVHpoGCBF/7jgsQuhRfk69GU6EJ/WplkpPrjSy2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097453; c=relaxed/simple;
	bh=eDaRyjCPlElYWWSid9w8WvUlhs0YFB3NzXBoHj6S4w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iq4EKvg6MpWNUlIqIThRZu4YKEnohMzFrQ05TCtC7Hr7jGF2p4lEWD0777OER3CGEb7LJRgX/hkddGEGft3TiBFHmSNE8gf7RRsKlv0L1EWNxC8uXG8gqaXFkBL1TjwICK2D8ZaDn0DBoKPFdj+vpxbO7hcfcH7DM7PLsS3f6ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6T6N2TM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6T6N2TM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9F3C2BCAF;
	Mon, 13 Apr 2026 16:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097453;
	bh=eDaRyjCPlElYWWSid9w8WvUlhs0YFB3NzXBoHj6S4w0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6T6N2TM11bdVmRlfVeZiQSjcRBP8g25hqMJ/cBWchBmU+DoukICEEgThw3Eao3D8
	 hTyT0qC67BxMM8cgNtMLD3rLE0PNIFamdmazwbFj3A9/V77hvBSWdbBjni2Jra8rOk
	 fkryTwztZXPDSYNlOUd4gOoWtpeYA/RV1XG+HojY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 142/570] USB: core: Limit the length of unkillable synchronous timeouts
Date: Mon, 13 Apr 2026 17:54:33 +0200
Message-ID: <20260413155835.762150150@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -44,6 +44,8 @@ static void usb_api_blocking_completion(
  * Starts urb and waits for completion or timeout.
  * Whether or not the wait is killable depends on the flag passed in.
  * For example, compare usb_bulk_msg() and usb_bulk_msg_killable().
+ *
+ * For non-killable waits, we enforce a maximum limit on the timeout value.
  */
 static int usb_start_wait_urb(struct urb *urb, int timeout, int *actual_length,
 		bool killable)
@@ -60,7 +62,9 @@ static int usb_start_wait_urb(struct urb
 	if (unlikely(retval))
 		goto out;
 
-	expire = timeout ? msecs_to_jiffies(timeout) : MAX_SCHEDULE_TIMEOUT;
+	if (!killable && (timeout <= 0 || timeout > USB_MAX_SYNCHRONOUS_TIMEOUT))
+		timeout = USB_MAX_SYNCHRONOUS_TIMEOUT;
+	expire = (timeout > 0) ? msecs_to_jiffies(timeout) : MAX_SCHEDULE_TIMEOUT;
 	if (killable)
 		rc = wait_for_completion_killable_timeout(&ctx.done, expire);
 	else
@@ -126,8 +130,7 @@ static int usb_internal_control_msg(stru
  * @index: USB message index value
  * @data: pointer to the data to send
  * @size: length in bytes of the data to send
- * @timeout: time in msecs to wait for the message to complete before timing
- *	out (if 0 the wait is forever)
+ * @timeout: time in msecs to wait for the message to complete before timing out
  *
  * Context: task context, might sleep.
  *
@@ -182,8 +185,7 @@ EXPORT_SYMBOL_GPL(usb_control_msg);
  * @index: USB message index value
  * @driver_data: pointer to the data to send
  * @size: length in bytes of the data to send
- * @timeout: time in msecs to wait for the message to complete before timing
- *	out (if 0 the wait is forever)
+ * @timeout: time in msecs to wait for the message to complete before timing out
  * @memflags: the flags for memory allocation for buffers
  *
  * Context: !in_interrupt ()
@@ -241,8 +243,7 @@ EXPORT_SYMBOL_GPL(usb_control_msg_send);
  * @index: USB message index value
  * @driver_data: pointer to the data to be filled in by the message
  * @size: length in bytes of the data to be received
- * @timeout: time in msecs to wait for the message to complete before timing
- *	out (if 0 the wait is forever)
+ * @timeout: time in msecs to wait for the message to complete before timing out
  * @memflags: the flags for memory allocation for buffers
  *
  * Context: !in_interrupt ()
@@ -313,8 +314,7 @@ EXPORT_SYMBOL_GPL(usb_control_msg_recv);
  * @len: length in bytes of the data to send
  * @actual_length: pointer to a location to put the actual length transferred
  *	in bytes
- * @timeout: time in msecs to wait for the message to complete before
- *	timing out (if 0 the wait is forever)
+ * @timeout: time in msecs to wait for the message to complete before timing out
  *
  * Context: task context, might sleep.
  *
@@ -346,8 +346,7 @@ EXPORT_SYMBOL_GPL(usb_interrupt_msg);
  * @len: length in bytes of the data to send
  * @actual_length: pointer to a location to put the actual length transferred
  *	in bytes
- * @timeout: time in msecs to wait for the message to complete before
- *	timing out (if 0 the wait is forever)
+ * @timeout: time in msecs to wait for the message to complete before timing out
  *
  * Context: task context, might sleep.
  *
@@ -407,12 +406,12 @@ EXPORT_SYMBOL_GPL(usb_bulk_msg);
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
@@ -1805,6 +1805,9 @@ void usb_buffer_unmap_sg(const struct us
  *                         SYNCHRONOUS CALL SUPPORT                  *
  *-------------------------------------------------------------------*/
 
+/* Maximum value allowed for timeout in synchronous routines below */
+#define USB_MAX_SYNCHRONOUS_TIMEOUT		60000	/* ms */
+
 extern int usb_control_msg(struct usb_device *dev, unsigned int pipe,
 	__u8 request, __u8 requesttype, __u16 value, __u16 index,
 	void *data, __u16 size, int timeout);


