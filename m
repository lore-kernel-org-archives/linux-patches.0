Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210928;
	b=lUMKi/QqDtNrQKwY/jJ9HOM9zViGf7U8wdKOuBpgZWLbPpwis3JH97rCVJ8nfhuvR/qu
	 Fwx9fDoK7eAq8gSR4vdLnerD3j6ZQcfMxccb9WVZOTPS1eg3MXNxymkSY4UKwMuB/W+ys
	 bxheJQiD9JSwQwmaBT6JYm1xP2MLUqjwrSOtPlxxFQ7d0sBW+68VlkWeItrwb7Ekg9vNZ
	 99HBwHysCIKfSHHCSYYwar94Rm3eqK88DUmvwDCQVBVzoufyWLX/KuP0PanfIOQrpCFeK
	 IFxtryulhd1G4cGXf2yJFg1qTJlKXXKARQsns37vyYrJocvrYJBDNyrcc2kz7N1rtnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vDJYLd3zF7X1JOp/T3/Wh2Na4tJL+NV1ZyjIU6HEeYc=;
	b=BXyX9mynIAk6BQh6JQIGITlMHElLVUFeDdXR3At+N8fk/mY5iagC3V+4PouZEGapya63
	 Ot2HVQXjilg9+wbiw86Mg50JyPejhEF9iA9Aikyd8NudVj0GtxoGT6QQbQbvZmXcFGHF2
	 /aRlVYxD2HCK4aPjmgubkQ1BMHgnLdwgfIYojIFOt4ciE1Y2kNbI1rWKAQL/EwIdNUro+
	 jM1WQAcXtOljbwpZNxm0do8fdIQWMEnY347A0gmghE6X64De9nW3z1/5pi7cpwNrdjjAH
	 tlf4+RB5WgGPZ4y45LZ7IhN+xOx0niSnhpHIaAhqoOoAz6BYO9VJwsxsXnnGGCsJxWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pc8HOzPX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B522D606A31D;
	Wed, 28 Oct 2026 18:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pc8HOzPX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F551F01825;
	Wed, 28 Oct 2026 18:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210927;
	bh=vDJYLd3zF7X1JOp/T3/Wh2Na4tJL+NV1ZyjIU6HEeYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pc8HOzPXvB3cgiciubPz49t+b6EDzyOTBu2JMtpaS4QEoUjF2+sFq/dW5+PFjZk2l
	 RVNg504SZwAdyyK+a1/+ZfPYtdZPUqE9LeEoyRJ9uCy8K4547gn/0p29Tr9m6uMgps
	 YnGbnGfnDWrbrWjhbGHfmhz2SqkzqFyifWI2Cdio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 198/571] USB: cdc-acm: fix racy TIOCMIWAIT implementation
Date: Wed, 28 Oct 2026 17:55:45 +0100
Message-ID: <20261028170012.705560481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 
 		if (difference & ACM_CTRL_DSR)
 			acm->iocount.dsr++;
@@ -994,11 +993,16 @@ static int wait_serial_change(struct acm
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
@@ -1011,22 +1015,20 @@ static int wait_serial_change(struct acm
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
@@ -118,7 +118,6 @@ struct acm {
 	unsigned int ctrlin;				/* input control lines (DCD, DSR, RI, break, overruns) */
 	unsigned int ctrlout;				/* output control lines (DTR, RTS) */
 	struct async_icount iocount;			/* counters for control line changes */
-	struct async_icount oldcount;			/* for comparison of counter */
 	wait_queue_head_t wioctl;			/* for ioctl */
 	unsigned int writesize;				/* max packet size for the output bulk endpoint */
 	unsigned int readsize,ctrlsize;			/* buffer sizes for freeing */


