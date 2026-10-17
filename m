Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA163ACEE0;
	Sat, 17 Oct 2026 17:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256623; cv=none; b=WgHYaiJZ1X4rLYJeHMGe63YtXQo0/XGm4ZpHLKBVjWxQeWILT3M9VanCAEciSLddDdHdQzXzRN71TEGIaeNsbccvNi6RaRJqNKx851Mn+lQF77AZvEtBBzV+s4LPPQKeGdA03BuApK+SSPTsTJ+w2Z/rsRZ67p3D9rTW1bzxKPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256623; c=relaxed/simple;
	bh=nfdTreNsmwXe7GeBLcqaR+p7URCNYYtfYxAph4UJBL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZPMB6/KJYCdtPNuyAnfGQbK4vhmcykkOL1b3i9eO8V3qdhkHewXlh4iCl26C8qtxoCdnYKI1djDta6ptqjI4T54ZpGnWSgBqroXJjM63iQt7G4MAX/s2yjirwE2FnDEy1mLgYcRmznIlHLGDFaww0ihOW8ay0WiqFz4qQDjfE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrK39bo7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrK39bo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D491F000C4;
	Sat, 17 Oct 2026 17:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256622;
	bh=kPindba07v37IW8z0o24c9AeYbcoWTwfx7OtUEB5tAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wrK39bo7tprWihBdbxl4P/wwaG19P0ET+xfQ1SqXF8PIzuAaVvIT250S8bFB31c6A
	 wIjm83FtyMS9twmT7uxphHHWDdfy6IjY+/KKc83u0W4hgdIj9+BuqnD6nRK/xmyEE2
	 LXC1U7GqlJT0mHM9NjJk7XExCTta8BY7/RXDmSDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 0255/1674] USB: cdc-acm: fix racy TIOCMIWAIT implementation
Date: Sat, 17 Oct 2026 17:42:07 +0200
Message-ID: <20261017160437.671796026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


