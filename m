Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212755;
	b=yrgzmUssfflle3HH294TalyCS0ql0maIoUpmmx8QWshqGRm7Ytlf1dQmPFXFCGdW6OWe
	 eN51DqLK5ADw2B3ez732Zj8FMIVfCsPb6PB/SCzRrjwCoeQsEJQtmt6082iFhmmMvvRGD
	 vnXZMDE8T2QOHlO+3+3CBDrJsgdM5tNdfRi9g57OWWsAbQJrgNgdJtXmvvCWc/+q3R5Ud
	 1xYFFHDu3k5EYP+9TiDasULo1ZC2AyI6+AnAafKFqQO2zentJR46+spfxgZkvbrbLfZmx
	 NTiR9vHqhrB9AC8wyM3EJMujVYbb5PMEkAuC4dnIdqpBP2ywKe4dCaEYY1kOvep1MZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=004Qy79VB1VoRC8ZAwdmaQDdq5+xXOe7u7zVc67ErF0=;
	b=QoOu4cVTtgkFNEG4USrJxeS7vwRc+mSptoc8DnVcxHoli4RC2GiJa2Ia3E0Hx8S3YvTI
	 3e2voxWv6ycyl68OWrwEmtgp89018ZrN+4qt7aS60R+uA1dVUqoMNABXs2V/9WMr9ZE3B
	 oiUXMhrq2JUTtQPdyZdUAOfxhcPZRrTYG4psBQfzDLLWqdkM2dAUd3xiXFfGtg36E9tCh
	 aL8FFW2YKU4Nd8AcKxjpouJXeK16DoYnk80AHBF7OS0s19k4OIh4iziJ7fgoFa3ExHA0g
	 zI0EcrJJxeBaPJX5fKhKSjL/DArgmXwTfwHnWzo2iaOVboCu4uJTXAaGiohABXnhN4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=slvniuNY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083E3606A31C;
	Wed, 28 Oct 2026 18:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=slvniuNY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575501F01825;
	Wed, 28 Oct 2026 18:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212754;
	bh=004Qy79VB1VoRC8ZAwdmaQDdq5+xXOe7u7zVc67ErF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=slvniuNY0PT4bXkHOt5YhUpbv0sJMCxcNHEcFwMmchbV9r3BDZfordj0nTb8qR5Rp
	 Pme1tgrCPepD2zEWe5pHONi90TIhJJgmQMi/cViN9wXengFVIWBMSsm0awfC7ylOO5
	 HeCBPPlsun/Kyd/gutagIUk6HQ7Uo+a2oYZUb4Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0266/1887] USB: cdc-acm: fix racy TIOCMIWAIT implementation
Date: Wed, 28 Oct 2026 17:39:22 +0100
Message-ID: <20261028170505.282417366@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit be4219dd98608736e13e0b790ef742b76a13254d upstream.

Check the wakeup condition after adding the task to the waitqueue and
updating the task state to avoid missing a racing modem status update or
disconnect.

Store the old icount on entry and do not update it in the completion
handler to avoid missing events or reporting spurious ones (due to modem
status changes before TIOCMIWAIT was called).

Fixes: 5a6a62bdb925 ("cdc-acm: add TIOCMIWAIT")
Cc: stable <stable@kernel.org>
Cc: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260907095130.130636-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |   36 +++++++++++++++++++-----------------
 drivers/usb/class/cdc-acm.h |    1 -
 2 files changed, 19 insertions(+), 18 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -320,7 +320,6 @@ static void acm_process_notification(str
 		difference = acm->ctrlin ^ newctrl;
 		spin_lock_irqsave(&acm->read_lock, flags);
 		acm->ctrlin = newctrl;
-		acm->oldcount = acm->iocount;
 
 		if (difference & USB_CDC_SERIAL_STATE_DSR)
 			acm->iocount.dsr++;
@@ -1002,11 +1001,16 @@ static int wait_serial_change(struct acm
 	DECLARE_WAITQUEUE(wait, current);
 	struct async_icount old, new;
 
-	do {
+	spin_lock_irq(&acm->read_lock);
+	old = acm->iocount;
+	spin_unlock_irq(&acm->read_lock);
+
+	add_wait_queue(&acm->wioctl, &wait);
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
 		spin_lock_irq(&acm->read_lock);
-		old = acm->oldcount;
 		new = acm->iocount;
-		acm->oldcount = new;
 		spin_unlock_irq(&acm->read_lock);
 
 		if ((arg & TIOCM_DSR) &&
@@ -1019,22 +1023,20 @@ static int wait_serial_change(struct acm
 			old.rng != new.rng)
 			break;
 
-		add_wait_queue(&acm->wioctl, &wait);
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule();
-		remove_wait_queue(&acm->wioctl, &wait);
 		if (acm->disconnected) {
-			if (arg & TIOCM_CD)
-				break;
-			else
-				rv = -ENODEV;
-		} else {
-			if (signal_pending(current))
-				rv = -ERESTARTSYS;
+			rv = -ENODEV;
+			break;
 		}
-	} while (!rv);
 
-	
+		schedule();
+
+		if (signal_pending(current)) {
+			rv = -ERESTARTSYS;
+			break;
+		}
+	}
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&acm->wioctl, &wait);
 
 	return rv;
 }
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -90,7 +90,6 @@ struct acm {
 	unsigned int ctrlin;				/* input control lines (DCD, DSR, RI, break, overruns) */
 	unsigned int ctrlout;				/* output control lines (DTR, RTS) */
 	struct async_icount iocount;			/* counters for control line changes */
-	struct async_icount oldcount;			/* for comparison of counter */
 	wait_queue_head_t wioctl;			/* for ioctl */
 	unsigned int writesize;				/* max packet size for the output bulk endpoint */
 	unsigned int readsize,ctrlsize;			/* buffer sizes for freeing */


