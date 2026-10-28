Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212991;
	b=2bwFO/YsYrkmtYToobJJ0tKlLDxuYGxHVy23fGoBbjOoPkzFJ2Q0GfYu8uNv+UcGmsE3
	 vze0lod4974pVZJqhrrb1Rp4E0FTnfmpbze7gobqdcjWcjxWYut93feH7t6aNb/uCvFeo
	 becQSvLfnbOJsVh9a8VGKgHBNYasedNFnZRjxOutc4kfE+njjcP9rG/46NLzc0XtLx0Kw
	 pTnZOYFV0oFtEVJ8FOnYSTBhbaFnT9qqffMX1nDrWoZ/L1Y5hAiNv7fQWqxtZlplg5c2K
	 igUgIdju3TWrnkc+PMkoO2OA4dD0qq8ZV+6pKcOFVWvAGgml7sfNYeALfNLim9SH4RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TDZbdDuFsVtKGP2/zUTxl7/bPDhUOpf84ZyMR3iEP2I=;
	b=qs5Spl2jJzCWDvMqa/6B1rYcr3lhS5jgpS8xMuIwEuu48VXcVDfpauJNfymB4Hvfqt3/
	 sVxVsFbv0dZsaF2qq83ms3GekAZ9NS3OQq6Tz24obRsy5MBOafUcV05sLvyAmbUVpZ+4G
	 Jh1AJA5KDu4xhUmLy8J+hHTnH/DSGrtdGPegI+CSqqXyV0sm6LpkRP9rM/1oXWXGW7YVN
	 C1djW4m5MkU4MgY6T5qeJQekcz7AsVV8iVesoVImuPYKDv/Drtm4ArnIFZ5yPDSs+CoiG
	 1kFLIreOzyhBM2QP2xsgrC6Cj6q9La1eMEuZX9HXRCNufDsUgIX+SpTXptliV4gacFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EprHkh0Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0581606A320;
	Wed, 28 Oct 2026 18:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EprHkh0Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D64F1F01825;
	Wed, 28 Oct 2026 18:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212990;
	bh=TDZbdDuFsVtKGP2/zUTxl7/bPDhUOpf84ZyMR3iEP2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EprHkh0Qbbm1lpBzKmuMs9pWvfMVxeSc8wav8q7pvU1PhaWu/gsi9JRreBtDuJQJ2
	 jrA7ANTwG8WiBc1XP/Z57l3WqnGgh5mnsVA0069O1SysYWIhi+jJLUUeP96M3FpLSf
	 NsdOEYxZNHcuV5pedfOpkFGB/0ZpiU4xv3ee/1a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0294/1887] tty: abort break signalling on hangup
Date: Wed, 28 Oct 2026 17:39:50 +0100
Message-ID: <20261028170505.920407342@linuxfoundation.org>
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

commit 845a2737e0f5ffe5ca8d38de556012b0c9472cdd upstream.

The break ioctls can race with hangup and end up calling into a tty
driver for a device that is already gone or powered down.

Drivers must handle this race, but TCSBRK and TCSBRKP should still be
aborted to avoid calling back into the driver after a user-controlled
timeout (possibly even after the tty has been reopened).

Note that drivers should disable any break state on shutdown so just
return on hangup (calling break_ctl() again is racy and will most likely
fail for drivers handling the race).

Fixes: f34d7a5b7010 ("tty: The big operations rework")
Cc: stable <stable@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260903163736.1499280-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_io.c |   36 +++++++++++++++++++++++++++---------
 include/linux/tty.h  |    1 +
 2 files changed, 28 insertions(+), 9 deletions(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -630,6 +630,8 @@ static void __tty_hangup(struct tty_stru
 
 	tty_ldisc_hangup(tty, cons_filp != NULL);
 
+	wake_up_interruptible(&tty->break_wait);
+
 	spin_lock_irq(&tty->ctrl.lock);
 	clear_bit(TTY_THROTTLED, &tty->flags);
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
@@ -2457,6 +2459,7 @@ static int tiocgetd(struct tty_struct *t
  * send_break	-	performed time break
  * @tty: device to break on
  * @duration: timeout in mS
+ * @file: file object
  *
  * Perform a timed break on hardware that lacks its own driver level timed
  * break functionality.
@@ -2464,8 +2467,9 @@ static int tiocgetd(struct tty_struct *t
  * Locking:
  *	@tty->atomic_write_lock serializes
  */
-static int send_break(struct tty_struct *tty, unsigned int duration)
+static int send_break(struct file *file, struct tty_struct *tty, unsigned int duration)
 {
+	long timeout;
 	int retval;
 
 	if (tty->ops->break_ctl == NULL)
@@ -2479,13 +2483,26 @@ static int send_break(struct tty_struct
 		return -EINTR;
 
 	retval = tty->ops->break_ctl(tty, -1);
-	if (!retval) {
-		msleep_interruptible(duration);
-		retval = tty->ops->break_ctl(tty, 0);
-	} else if (retval == -EOPNOTSUPP) {
-		/* some drivers can tell only dynamically */
-		retval = 0;
+	if (retval) {
+		if (retval == -EOPNOTSUPP) {
+			/* some drivers can tell only dynamically */
+			retval = 0;
+		}
+		goto out_unlock;
+	}
+
+	timeout = msecs_to_jiffies(duration);
+	timeout = wait_event_interruptible_timeout(tty->break_wait,
+						   tty_hung_up_p(file),
+						   timeout);
+	/* return early on hangup only */
+	if (timeout > 0) {
+		retval = -EIO;
+		goto out_unlock;
 	}
+
+	retval = tty->ops->break_ctl(tty, 0);
+out_unlock:
 	tty_write_unlock(tty);
 
 	if (signal_pending(current))
@@ -2738,10 +2755,10 @@ long tty_ioctl(struct file *file, unsign
 		 * This is used by the tcdrain() termios function.
 		 */
 		if (!arg)
-			return send_break(tty, 250);
+			return send_break(file, tty, 250);
 		return 0;
 	case TCSBRKP:	/* support for POSIX tcsendbreak() */
-		return send_break(tty, arg ? arg*100 : 250);
+		return send_break(file, tty, arg ? arg * 100 : 250);
 
 	case TIOCMGET:
 		return tty_tiocmget(tty, p);
@@ -3104,6 +3121,7 @@ struct tty_struct *alloc_tty_struct(stru
 	init_ldsem(&tty->ldisc_sem);
 	init_waitqueue_head(&tty->write_wait);
 	init_waitqueue_head(&tty->read_wait);
+	init_waitqueue_head(&tty->break_wait);
 	INIT_WORK(&tty->hangup_work, do_tty_hangup);
 	mutex_init(&tty->atomic_write_lock);
 	spin_lock_init(&tty->ctrl.lock);
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -235,6 +235,7 @@ struct tty_struct {
 	struct fasync_struct *fasync;
 	wait_queue_head_t write_wait;
 	wait_queue_head_t read_wait;
+	wait_queue_head_t break_wait;
 	struct work_struct hangup_work;
 	void *disc_data;
 	void *driver_data;


