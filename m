Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5528733D4E2;
	Thu, 30 Jul 2026 14:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421561; cv=none; b=k3C6JnaS/7lRi9Jj3TOUZmk9K69g1Z83nC4wnWoVUQQoOt8txITNvQTcZmH8hadiottYiAOu0YLjA3a+n6h+2bs68nnTgo3UncbyhCZRl62kzDGM0/HkbaUtXeQMa7AI8ACB12UNuoTS7rcVCQy7tnuL5Nn6ugvd4af6G66VVTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421561; c=relaxed/simple;
	bh=elb+DUqo2pBs5sk0sW0oQ9nnc00DkgJaYJNqPFPHiEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qu4XTXZjZ/zVAWXKJ5/QCt0DUfRtlvcZ1gQxihXDPvgF53klhttMBOqyLdjO8TIezS5Hij5dpBKifUz7bvsZ3PFDqkDuuXwgTAM4+RjxErjhLboRY2UZL+z9EjCUigzMvQ7zq5Syv4R8roRz1pWPOnHgmQVCB6IX0xqZVnX1U78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nV2Mif6s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nV2Mif6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1C51F000E9;
	Thu, 30 Jul 2026 14:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421560;
	bh=FRBlMlt8t4xUYU5X49XKTPFpKn29AIoUu4GRQ5zsyUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nV2Mif6s/47qqUoyyw31nv35kpR/N0sxg1GZOIx75hDfoAn6EGsNQQQIGxOK9TLnz
	 QCtruT7oIbKcwXFzN4gEl/SRJh/kZ8leT2JX6Y9gBOjWDnrXgQBPulKrP4AkgbAAHU
	 iRtBUw6VxB4QjALgR0L1gvugNqE8lLYC7jSkhwfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peter Chen <peter.chen@kernel.org>,
	Melbin K Mathew <mlbnkm1@gmail.com>
Subject: [PATCH 7.1 145/744] usb: gadget: printer: fix infinite loop in printer_read()
Date: Thu, 30 Jul 2026 16:06:58 +0200
Message-ID: <20260730141447.369344937@linuxfoundation.org>
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
@@ -431,7 +431,7 @@ printer_read(struct file *fd, char __use
 {
 	struct printer_dev		*dev = fd->private_data;
 	unsigned long			flags;
-	size_t				size;
+	size_t				size, not_copied, copied;
 	size_t				bytes_copied;
 	struct usb_request		*req;
 	/* This is a pointer to the current USB rx request. */
@@ -524,10 +524,12 @@ printer_read(struct file *fd, char __use
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
 
@@ -542,6 +544,17 @@ printer_read(struct file *fd, char __use
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


