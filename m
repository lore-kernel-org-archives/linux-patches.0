Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190741849D3;
	Wed,  3 Jul 2024 11:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005088; cv=none; b=AnVDTI+N6K2plMe/HT3FoV8ruhXzvMP9FpZCPKNBSEkKjoRg/20qBpcu++kt3oOByBEj5ulrsI+U0QzZcVJCxx3s2sEEbaMAsJNIOU6LvQYskwOMQih/41umRkEgMVzjL6EKiyx/4NDGtDXGwaFkaMQ/Wv7QUP0iJF99Zq+nw0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005088; c=relaxed/simple;
	bh=Es6cnd/Vx7itMKQSGFn7q/wJgVLIcdQKinz+pJ331jU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lC1NSnn5JZ7tjtcaVYIjhBkV+UJ8PGf+/KvWS0mrw5/vXTxAqk4DWpZOU1YQJHRl7PT+LSaWjgDisfCEYFHObxV2pMljQqv/FmG9ij69dYhVwxxdaLSVSFRHd7tM36VXMf50DD1O4XAYsSeRgz5ngvGYU/T7hN/tqq6Ece8iOxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xt0I6y2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xt0I6y2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89565C2BD10;
	Wed,  3 Jul 2024 11:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005087;
	bh=Es6cnd/Vx7itMKQSGFn7q/wJgVLIcdQKinz+pJ331jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xt0I6y2kXOBXs3r0hOMDITrVgDpvH7zF6e/hv8ghzQayfWlRxenv8P+DBVIo80pzQ
	 Kj2sCBx9+eEyQ4fY9K+FF3tpwdCYUiNlrQV/epDG7aAUsWiRjvRpxQlK4zFVkdT4So
	 QVxKSFMqoZtjR/S0jrErtYmO09F+6wcx6W5Qbusg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.10 255/290] usb: gadget: printer: fix races against disable
Date: Wed,  3 Jul 2024 12:40:36 +0200
Message-ID: <20240703102913.778302347@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -446,11 +446,8 @@ printer_read(struct file *fd, char __use
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
@@ -458,6 +455,9 @@ printer_read(struct file *fd, char __use
 	dev->reset_printer = 0;
 
 	setup_rx_reqs(dev);
+	/* this dropped the lock - need to retest */
+	if (dev->interface < 0)
+		goto out_disabled;
 
 	bytes_copied = 0;
 	current_rx_req = dev->current_rx_req;
@@ -491,6 +491,8 @@ printer_read(struct file *fd, char __use
 		wait_event_interruptible(dev->rx_wait,
 				(likely(!list_empty(&dev->rx_buffers))));
 		spin_lock_irqsave(&dev->lock, flags);
+		if (dev->interface < 0)
+			goto out_disabled;
 	}
 
 	/* We have data to return then copy it to the caller's buffer.*/
@@ -534,6 +536,9 @@ printer_read(struct file *fd, char __use
 			return -EAGAIN;
 		}
 
+		if (dev->interface < 0)
+			goto out_disabled;
+
 		/* If we not returning all the data left in this RX request
 		 * buffer then adjust the amount of data left in the buffer.
 		 * Othewise if we are done with this RX request buffer then
@@ -563,6 +568,11 @@ printer_read(struct file *fd, char __use
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
@@ -583,11 +593,8 @@ printer_write(struct file *fd, const cha
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
@@ -610,6 +617,8 @@ printer_write(struct file *fd, const cha
 		wait_event_interruptible(dev->tx_wait,
 				(likely(!list_empty(&dev->tx_reqs))));
 		spin_lock_irqsave(&dev->lock, flags);
+		if (dev->interface < 0)
+			goto out_disabled;
 	}
 
 	while (likely(!list_empty(&dev->tx_reqs)) && len) {
@@ -659,6 +668,9 @@ printer_write(struct file *fd, const cha
 			return -EAGAIN;
 		}
 
+		if (dev->interface < 0)
+			goto out_disabled;
+
 		list_add(&req->list, &dev->tx_reqs_active);
 
 		/* here, we unlock, and only unlock, to avoid deadlock. */
@@ -672,6 +684,8 @@ printer_write(struct file *fd, const cha
 			mutex_unlock(&dev->lock_printer_io);
 			return -EAGAIN;
 		}
+		if (dev->interface < 0)
+			goto out_disabled;
 	}
 
 	spin_unlock_irqrestore(&dev->lock, flags);
@@ -683,6 +697,11 @@ printer_write(struct file *fd, const cha
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


