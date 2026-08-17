Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDC73B42DC;
	Mon, 17 Aug 2026 14:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976786; cv=none; b=Z/WnrTLjyIief6Dr6M+8g7fuA/6IYwrnyatiYaeYaS9EpjM8/d6wm85bsej2fm0Y9iIVYyCVXHeGVbUrw65HC85HDkMowAOn1qhgTgXXg4T290y1lwE/fgg0zMJsWRYPcpd0badqVs3WIsv5C0djGSJTydxH+ua7oQoP9HujZ64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976786; c=relaxed/simple;
	bh=GALs1WfeOTy0isLWgrTr0i1PZYvNDgnUVz8o7+NmtV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9x5TEfSHEg2RnOvUdoRJJJ+dbWegUInw3LmfyV4mmTnIX4GPLbBjbSRPjOXNOtYIZ1gjNkaF6hBweLXGqmqIFZjM+VNqqAncoqzIoj9kIi+ZFFXEpaiLPUq4Y8T1fXJQQXRcjeh1Aa8vzquPRmySTv2+aJxGkRTvJYrKC5JIGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSHfEcoV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSHfEcoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972191F000E9;
	Mon, 17 Aug 2026 14:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976785;
	bh=uCaVh45dEb3CkXZ0lwqk1a0B35hmv8NE3BIz6E+9uxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSHfEcoVzWOJQ51h+wSFtwbuC7ZH50EDV+WCucVoxRSS3RpEv1IOoG0Nv0OlUGS9Y
	 cFWhBrf0mkEKD8BkpHUim2FPyUh+J+6wgy0YdkzbfLZE4cJmTnZT+PGf12DfICPAvC
	 rDoQO+QSz7EYeclicPPt+6SSLXE0sAhbWJRVW3qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peter Chen <peter.chen@kernel.org>,
	Melbin K Mathew <mlbnkm1@gmail.com>
Subject: [PATCH 5.15 064/456] usb: gadget: printer: fix infinite loop in printer_read()
Date: Mon, 17 Aug 2026 15:27:34 +0200
Message-ID: <20260817132542.554549629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Melbin K Mathew <mlbnkm1@gmail.com>

commit c2e819be6a5c7f34344926b4bd7e3dfca58cf48a upstream.

printer_read() uses the same variable for the requested copy size and
the number of bytes actually copied to user space. copy_to_user()
returns the number of bytes not copied, so when it fails to copy
anything, the computed copied length becomes zero.

In that case len, buf, current_rx_bytes and current_rx_buf are left
unchanged. If RX data is available and the user buffer remains
unwritable, the read loop can repeat indefinitely.

Track the copied length separately and return -EFAULT, or the number of
bytes already copied, if an iteration makes no progress.

Fixes: b185f01a9ab7 ("usb: gadget: printer: factor out f_printer")
Cc: stable <stable@kernel.org>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
Link: https://patch.msgid.link/20260709205622.55700-1-mlbnkm1@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_printer.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -430,7 +430,7 @@ printer_read(struct file *fd, char __use
 {
 	struct printer_dev		*dev = fd->private_data;
 	unsigned long			flags;
-	size_t				size;
+	size_t				size, not_copied, copied;
 	size_t				bytes_copied;
 	struct usb_request		*req;
 	/* This is a pointer to the current USB rx request. */
@@ -523,10 +523,12 @@ printer_read(struct file *fd, char __use
 		else
 			size = len;
 
-		size -= copy_to_user(buf, current_rx_buf, size);
-		bytes_copied += size;
-		len -= size;
-		buf += size;
+		not_copied = copy_to_user(buf, current_rx_buf, size);
+		copied = size - not_copied;
+
+		bytes_copied += copied;
+		len -= copied;
+		buf += copied;
 
 		spin_lock_irqsave(&dev->lock, flags);
 
@@ -541,6 +543,17 @@ printer_read(struct file *fd, char __use
 		if (dev->interface < 0)
 			goto out_disabled;
 
+		if (!copied) {
+			dev->current_rx_req = current_rx_req;
+			dev->current_rx_bytes = current_rx_bytes;
+			dev->current_rx_buf = current_rx_buf;
+			spin_unlock_irqrestore(&dev->lock, flags);
+			mutex_unlock(&dev->lock_printer_io);
+			return bytes_copied ? bytes_copied : -EFAULT;
+		}
+
+		size = copied;
+
 		/* If we not returning all the data left in this RX request
 		 * buffer then adjust the amount of data left in the buffer.
 		 * Othewise if we are done with this RX request buffer then


