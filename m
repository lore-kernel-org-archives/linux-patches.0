Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99733314A6B;
	Mon, 13 Apr 2026 16:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098820; cv=none; b=oZSU4/xHYL6YtwF/fonaDQZiJaTtgmsntiQlil6sHQ/UKolxb9jECxmrIeWBTNuvMi385iO9KKQ1Uqj/upEvleQuNCqI6ReUij/U+/eYO6Fz+Bm1PL8NIsALW2DRSPJY7WDRUG/RsQReoCEt9pW+6wSIsArhUC+jdsamMgZD8Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098820; c=relaxed/simple;
	bh=OOvUvcH08mdjRSoPI/uWylDpnMo0fZFf52pTDYI92Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IV8BABie3oPq0J6hWchfnPOOqMqXdqk/6IWs2XSL/7YlcHUHYT/+KqafNcYllGUZxJawfHIloUgTC+Uv3wiYSDRprTR6EHmvlbnYipFkbjswwlox6syGlbo84r763aQgTb30CaTQB8/zZhvnyZjZMGNT3rzuyt7T3KWjhNAmtaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQLxLTTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQLxLTTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E52C2BCAF;
	Mon, 13 Apr 2026 16:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098820;
	bh=OOvUvcH08mdjRSoPI/uWylDpnMo0fZFf52pTDYI92Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qQLxLTTPR/CqKsLi0OjSv+VMfRPaiGA9Pk7HvMOcRqb4uwJdnWJCepeVINOfyI/lW
	 dAHLKUPylfofMDc4iJwMjiF9te2XOEFtVUOqTrCtLvvGpGhUWKC49QmzfOGU4oMZnN
	 sMYROFmshTbfCk4vUjql9k0kpAlqeiPpgfkZxkto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 100/491] USB: core: Limit the length of unkillable synchronous timeouts
Date: Mon, 13 Apr 2026 17:55:45 +0200
Message-ID: <20260413155822.788962967@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/usb/core/message.c |   24 ++++++++++++------------
 include/linux/usb.h        |    3 +++
 2 files changed, 15 insertions(+), 12 deletions(-)

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
  * Context: !in_interrupt ()
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
@@ -245,8 +247,7 @@ EXPORT_SYMBOL_GPL(usb_control_msg_send);
  * @index: USB message index value
  * @driver_data: pointer to the data to be filled in by the message
  * @size: length in bytes of the data to be received
- * @timeout: time in msecs to wait for the message to complete before timing
- *	out (if 0 the wait is forever)
+ * @timeout: time in msecs to wait for the message to complete before timing out
  * @memflags: the flags for memory allocation for buffers
  *
  * Context: !in_interrupt ()
@@ -317,8 +318,7 @@ EXPORT_SYMBOL_GPL(usb_control_msg_recv);
  * @len: length in bytes of the data to send
  * @actual_length: pointer to a location to put the actual length transferred
  *	in bytes
- * @timeout: time in msecs to wait for the message to complete before
- *	timing out (if 0 the wait is forever)
+ * @timeout: time in msecs to wait for the message to complete before timing out
  *
  * Context: !in_interrupt ()
  *
@@ -411,12 +411,12 @@ EXPORT_SYMBOL_GPL(usb_bulk_msg);
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
@@ -1798,6 +1798,9 @@ void usb_buffer_unmap_sg(const struct us
  *                         SYNCHRONOUS CALL SUPPORT                  *
  *-------------------------------------------------------------------*/
 
+/* Maximum value allowed for timeout in synchronous routines below */
+#define USB_MAX_SYNCHRONOUS_TIMEOUT		60000	/* ms */
+
 extern int usb_control_msg(struct usb_device *dev, unsigned int pipe,
 	__u8 request, __u8 requesttype, __u16 value, __u16 index,
 	void *data, __u16 size, int timeout);


