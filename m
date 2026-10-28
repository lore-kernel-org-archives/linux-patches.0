Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208784;
	b=huAtylgawG+VyLPaEmfdlMl/g3CuZfmK9KEQNeQtrPVps1Tgv/EvEaauNe30+k+nPmWi
	 PNGuVMYewFPwrRhoWa/aiiTYz9MoYw2tpBjcM/GGB3CKEy6yUDCb7fp6/Ok+YtyZ0oRqi
	 ZTdRvopI/mnwgoZFLBplGr0mju0VX5MfaDWPNMgdsTjc3rG2dxbU+V6OGGoLFBPRWxmAu
	 zjK9YJs8QftcHv3dYGWzYsRt3aXIQUjnMqMfCuKokzwzGvOSp+V+LQeHjYfrio7RICt0C
	 G9uR3He3CzeofoauYwPmfV1Er7yF7nvF6uQG+LM6ZEk7uQPjfkU9RZnXbq9pb7KKb2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1APNU6eTwqvRhLDQhbKdbtjYX6mti6P8KyoMVNI87e8=;
	b=Tk7hZF3spbqh7C3rD5sMGuCp2u/qnh6bL681Dox79Z5IKcib6mR7rU7M08trye8g///t
	 1elIIpwa2Kv/i7YDgbnprnM5H07esikjVUQv4hh3BJrlfDYsnaKvRNXfBViidEf6dYOl1
	 XGPUccZzd5n8g5sk7fhKldD2YRbsxGdba4QbecDrRLM3sZqxRmzh8joAUYToISj77wh+k
	 9GtNzY2xHNDZ4Ylc9JKeaTruDEBQrEWp+tZoN4gQXLr3zL8BtTCqPoHdz9L+Q2TUCbt7O
	 a7G9DsoPba0MKk+qQHh7gru2wdUCU2WqRd8n1GpasMCbpE0jeMo04CnslZUpM484DUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S33VaSWf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A156606A31C;
	Wed, 28 Oct 2026 17:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S33VaSWf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEC71F01825;
	Wed, 28 Oct 2026 17:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208784;
	bh=1APNU6eTwqvRhLDQhbKdbtjYX6mti6P8KyoMVNI87e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S33VaSWfkreZ0UeYffCCYF31RVLWo5zEfRuUjOEzxennenc4F/XNNdCMg90Aucmce
	 thCt8lgIbC4EREaoM3/d89SzRJ7le1bcf5redTpLr4IEPKLHUykP3veLrydQSBdn3a
	 WREknz8qE716rz1wwZh3FtrdibnR9jxiiU5eLrvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 187/516] USB: cdc-acm: fix racy TIOCMIWAIT implementation
Date: Wed, 28 Oct 2026 17:55:39 +0100
Message-ID: <20261028170007.932945726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


