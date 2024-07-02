Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2383F1BD00C;
	Tue,  2 Jul 2024 17:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941507; cv=none; b=pyTlAropI0GIjZpXo2Ox0+f8fCJZ2IYzhAyb3H5jC3Bhw5jY4Wy3fYqRflk2svbq4MMXTiSwZtI3yubCgD3+uKdy6XJz2sMrEQvS0FRa4GM7EiNEEwerU5jg6qeJW/NQXSj9ShNWE3ThjQzGTnLU2EZdnDqMwM9zAtYZ2RqUbwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941507; c=relaxed/simple;
	bh=g2eMLINrpfmOnIP948vxcCuf5Mb/ezWuo5RdGcC7I28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvXneUfYZOj+vnPJzFH1fh+ozCh03pZy02msdKA9HIm1dpMStJ9wFdivbnSFgcYNQ0h+gAz/6ei61iP+k5Yky8Pp3ZqUTjSH/2wCIykVHbHAUBugZUc50GHN+mUEb7QuwgzjCEEWaACTCKUDGSm0Vl3jSFZkftaBYlXF3X6i434=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ceTu4QWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ceTu4QWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0DBC116B1;
	Tue,  2 Jul 2024 17:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941507;
	bh=g2eMLINrpfmOnIP948vxcCuf5Mb/ezWuo5RdGcC7I28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ceTu4QWlVtTGUN5yQS3JBQfB4uMKaaoIWv+XF8eUxTh2OOmQON6gIB8iP2vHvsONs
	 5iGyKixlhf3tMMzATTSnKB8G+LMOLJaORByJ/DtosTnIRXixKyXQwR7EYUoQiC4m71
	 B1/a8gbHHd9wA1lzXzKVTmML32vG+XuOjq0DhBzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.1 084/128] usb: gadget: printer: fix races against disable
Date: Tue,  2 Jul 2024 19:04:45 +0200
Message-ID: <20240702170229.400200508@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Oliver Neukum <oneukum@suse.com>

commit e587a7633dfee8987a999cf253f7c52a8e09276c upstream.

printer_read() and printer_write() guard against the race
against disable() by checking the dev->interface flag,
which in turn is guarded by a spinlock.
These functions, however, drop the lock on multiple occasions.
This means that the test has to be redone after reacquiring
the lock and before doing IO.

Add the tests.

This also addresses CVE-2024-25741

Fixes: 7f2ca14d2f9b9 ("usb: gadget: function: printer: Interface is disabled and returns error")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20240620114039.5767-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_printer.c |   39 +++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 10 deletions(-)

--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -448,11 +448,8 @@ printer_read(struct file *fd, char __use
 	mutex_lock(&dev->lock_printer_io);
 	spin_lock_irqsave(&dev->lock, flags);
 
-	if (dev->interface < 0) {
-		spin_unlock_irqrestore(&dev->lock, flags);
-		mutex_unlock(&dev->lock_printer_io);
-		return -ENODEV;
-	}
+	if (dev->interface < 0)
+		goto out_disabled;
 
 	/* We will use this flag later to check if a printer reset happened
 	 * after we turn interrupts back on.
@@ -460,6 +457,9 @@ printer_read(struct file *fd, char __use
 	dev->reset_printer = 0;
 
 	setup_rx_reqs(dev);
+	/* this dropped the lock - need to retest */
+	if (dev->interface < 0)
+		goto out_disabled;
 
 	bytes_copied = 0;
 	current_rx_req = dev->current_rx_req;
@@ -493,6 +493,8 @@ printer_read(struct file *fd, char __use
 		wait_event_interruptible(dev->rx_wait,
 				(likely(!list_empty(&dev->rx_buffers))));
 		spin_lock_irqsave(&dev->lock, flags);
+		if (dev->interface < 0)
+			goto out_disabled;
 	}
 
 	/* We have data to return then copy it to the caller's buffer.*/
@@ -536,6 +538,9 @@ printer_read(struct file *fd, char __use
 			return -EAGAIN;
 		}
 
+		if (dev->interface < 0)
+			goto out_disabled;
+
 		/* If we not returning all the data left in this RX request
 		 * buffer then adjust the amount of data left in the buffer.
 		 * Othewise if we are done with this RX request buffer then
@@ -565,6 +570,11 @@ printer_read(struct file *fd, char __use
 		return bytes_copied;
 	else
 		return -EAGAIN;
+
+out_disabled:
+	spin_unlock_irqrestore(&dev->lock, flags);
+	mutex_unlock(&dev->lock_printer_io);
+	return -ENODEV;
 }
 
 static ssize_t
@@ -585,11 +595,8 @@ printer_write(struct file *fd, const cha
 	mutex_lock(&dev->lock_printer_io);
 	spin_lock_irqsave(&dev->lock, flags);
 
-	if (dev->interface < 0) {
-		spin_unlock_irqrestore(&dev->lock, flags);
-		mutex_unlock(&dev->lock_printer_io);
-		return -ENODEV;
-	}
+	if (dev->interface < 0)
+		goto out_disabled;
 
 	/* Check if a printer reset happens while we have interrupts on */
 	dev->reset_printer = 0;
@@ -612,6 +619,8 @@ printer_write(struct file *fd, const cha
 		wait_event_interruptible(dev->tx_wait,
 				(likely(!list_empty(&dev->tx_reqs))));
 		spin_lock_irqsave(&dev->lock, flags);
+		if (dev->interface < 0)
+			goto out_disabled;
 	}
 
 	while (likely(!list_empty(&dev->tx_reqs)) && len) {
@@ -661,6 +670,9 @@ printer_write(struct file *fd, const cha
 			return -EAGAIN;
 		}
 
+		if (dev->interface < 0)
+			goto out_disabled;
+
 		list_add(&req->list, &dev->tx_reqs_active);
 
 		/* here, we unlock, and only unlock, to avoid deadlock. */
@@ -673,6 +685,8 @@ printer_write(struct file *fd, const cha
 			mutex_unlock(&dev->lock_printer_io);
 			return -EAGAIN;
 		}
+		if (dev->interface < 0)
+			goto out_disabled;
 	}
 
 	spin_unlock_irqrestore(&dev->lock, flags);
@@ -684,6 +698,11 @@ printer_write(struct file *fd, const cha
 		return bytes_copied;
 	else
 		return -EAGAIN;
+
+out_disabled:
+	spin_unlock_irqrestore(&dev->lock, flags);
+	mutex_unlock(&dev->lock_printer_io);
+	return -ENODEV;
 }
 
 static int


