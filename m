Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A467144CF44;
	Fri,  9 Oct 2026 14:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556015; cv=none; b=FRoNFs78EBedCySEGhwBNPYPIcVxbvkdA8ld+5ISofHJKyPDMEWRpT5IPOV9/yvRsoLNdefQ08FwaBSmpz8XiaRcr0nLJSUXryL3xxvV9BrC6te3V8j5DdCC8fccc0mRuXHnAsZO9Sk/yz6FBFMPjlaleW7LeOA0VGHo8vGDFAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556015; c=relaxed/simple;
	bh=FFa6FqQ9og+6qgSNMR7zLZ46gnMcr8zPF+3bAVxkQdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEebsBiDjnOi9owLNDv4dCH9fRRVC3jeAPwILT/6bYYRUeOk3IP4Oune3sQEtQaJaZrBvnYfGhtGhkMjj81FlyTzVbdB56e9Es58J3sgEbHk6yFg6G8CjXdIIpf9req0+2lhvCoXIuwdRUXyqebGNiy7R/TYrqsLGW7rLtV+2I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3pP28Fm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3pP28Fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066711F000FF;
	Fri,  9 Oct 2026 14:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556014;
	bh=IpyfvJtUMvnGJ8WC2R42OgnDK0sYSFvxb1l0cjRPxSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z3pP28FmZc8qcRLydVndTGdizlUlVxx0QtgjaUv2zoJXF/1Lev1TsDmrlCeTYl3t/
	 rTSy+poPrrpJpiu7+D+qPueU329amTFUo4U2iShVvcBDOxpUfNWy2XzSJRaMvK1uYo
	 cY05Pl0rWKNKwB9tv62SoQwPVz+KZNwe48yEL/4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 160/403] USB: cdc-acm: fix racy TIOCMIWAIT implementation
Date: Fri,  9 Oct 2026 16:08:41 +0200
Message-ID: <20261009140955.825534054@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -331,7 +331,6 @@ static void acm_process_notification(str
 
 		spin_lock_irqsave(&acm->read_lock, flags);
 		acm->ctrlin = newctrl;
-		acm->oldcount = acm->iocount;
 
 		if (difference & USB_CDC_SERIAL_STATE_DSR)
 			acm->iocount.dsr++;
@@ -1027,11 +1026,16 @@ static int wait_serial_change(struct acm
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
@@ -1044,22 +1048,20 @@ static int wait_serial_change(struct acm
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


