Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1654215218A;
	Tue,  2 Jul 2024 17:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941130; cv=none; b=kyb7Tegt3+Tpar8GjOHf9DqjUFsDOxEDG9OQKhgctKO985JvK/eohXC6FbfZ3F8hdO4Fb2lpkGq58K4EO9Mh8IJggGQZUodCDAHz4jyTEZo3f2hYcAEBW6ITnJwowrLsz3UTN0eauSHP3w3Yu9U5QDYfN9kHHY685105Qy/LUII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941130; c=relaxed/simple;
	bh=fbXWAiN6RzH07CstN6eNdKuT/9q9hd/H3NAeUBnrNkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7v5zCl0JO/g9ydIX16PK90ubWa2mI0ifmRn7Bglmy9usAWllRbm86b/CxNKnjDqFYjANgRFNKKH5FGTG/PR8784f3hZSc7ah3F6Xm9h5QKvhAJHeh5xMsgC1HGjlmB0E/qT6NcWE1rZ/mcHVN8JzAbQpdN5owW6L3WBnFkW2c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UuhQwXjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UuhQwXjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6A3C116B1;
	Tue,  2 Jul 2024 17:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941130;
	bh=fbXWAiN6RzH07CstN6eNdKuT/9q9hd/H3NAeUBnrNkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuhQwXjXe6ABdzWxbIwh7yboqzcx8jp2a3ICOceIdbZLVkAp1oId60zlt7Ag1uCqC
	 GB9V6k2Nb7cC3/9ap+tmJcaMlByRd/PTVKKFHEa2WmWK2AUoS8W0lHMo4ZaLx8nhGG
	 zPn84Cj6/gtnBoPaLbYC/dWbxALe6sHje1RqPc3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.6 106/163] usb: gadget: printer: fix races against disable
Date: Tue,  2 Jul 2024 19:03:40 +0200
Message-ID: <20240702170237.071050260@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -450,11 +450,8 @@ printer_read(struct file *fd, char __use
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
@@ -462,6 +459,9 @@ printer_read(struct file *fd, char __use
 	dev->reset_printer = 0;
 
 	setup_rx_reqs(dev);
+	/* this dropped the lock - need to retest */
+	if (dev->interface < 0)
+		goto out_disabled;
 
 	bytes_copied = 0;
 	current_rx_req = dev->current_rx_req;
@@ -495,6 +495,8 @@ printer_read(struct file *fd, char __use
 		wait_event_interruptible(dev->rx_wait,
 				(likely(!list_empty(&dev->rx_buffers))));
 		spin_lock_irqsave(&dev->lock, flags);
+		if (dev->interface < 0)
+			goto out_disabled;
 	}
 
 	/* We have data to return then copy it to the caller's buffer.*/
@@ -538,6 +540,9 @@ printer_read(struct file *fd, char __use
 			return -EAGAIN;
 		}
 
+		if (dev->interface < 0)
+			goto out_disabled;
+
 		/* If we not returning all the data left in this RX request
 		 * buffer then adjust the amount of data left in the buffer.
 		 * Othewise if we are done with this RX request buffer then
@@ -567,6 +572,11 @@ printer_read(struct file *fd, char __use
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
@@ -587,11 +597,8 @@ printer_write(struct file *fd, const cha
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
@@ -614,6 +621,8 @@ printer_write(struct file *fd, const cha
 		wait_event_interruptible(dev->tx_wait,
 				(likely(!list_empty(&dev->tx_reqs))));
 		spin_lock_irqsave(&dev->lock, flags);
+		if (dev->interface < 0)
+			goto out_disabled;
 	}
 
 	while (likely(!list_empty(&dev->tx_reqs)) && len) {
@@ -663,6 +672,9 @@ printer_write(struct file *fd, const cha
 			return -EAGAIN;
 		}
 
+		if (dev->interface < 0)
+			goto out_disabled;
+
 		list_add(&req->list, &dev->tx_reqs_active);
 
 		/* here, we unlock, and only unlock, to avoid deadlock. */
@@ -675,6 +687,8 @@ printer_write(struct file *fd, const cha
 			mutex_unlock(&dev->lock_printer_io);
 			return -EAGAIN;
 		}
+		if (dev->interface < 0)
+			goto out_disabled;
 	}
 
 	spin_unlock_irqrestore(&dev->lock, flags);
@@ -686,6 +700,11 @@ printer_write(struct file *fd, const cha
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


