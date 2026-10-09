Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476BD33EB01;
	Fri,  9 Oct 2026 14:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556805; cv=none; b=N8+hO7IJ17rwceoM5W1z00j1h4ANO14f6NLcL/X7TDgmVA8VjftlSlxxsh+SvU5vtLI8Zbst3V6azMHhCrWouTJl3CPLenPaYGA4N5I6LyF2ow5Joy47JQY7eDQKeyHM0OlEqw0+vgMe2pDGqnZZ1WmneEIgeYx5HsavY3QdXCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556805; c=relaxed/simple;
	bh=oyy3KB70wjUdIBITapl54iDmEfxTCfHYxiVHv3OcUKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1rZe9mMHPv15+p+UmNmGooeUU+C61OXlFDBN7/cTlCRmfgZWKdtWSIpq7EGEmJhrLbYR28pJJSGiTyslX6av1hMJUurhMQ6el6gmhv1asfCwFLyGn1eTLhQEYuXeN3X+ynCsseV5HA7a6richiDC6Xh8FelimnSOvNUyY1wM+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=py7v8WMe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="py7v8WMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5E31F000FF;
	Fri,  9 Oct 2026 14:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556803;
	bh=1YV45/mubYPHAV3aeZn61wxV9E42b2xkdC519hnGvlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=py7v8WMeu3+Er9Q4haAsJsDv8swE5nY9N3+8FIcwEHbM964m5XpcorjRtxiXsqZRE
	 3Yt+SZCQQ6S1EfRobskndsnRbb/IcNfuCPsnq8kdjgBMTynG7KlXgL8jkEA4qJ11cD
	 fJrPmkXbhrt+Hmas4rcq/G5FBeCvwIXEIk2Zv6Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.2 245/428] tty: abort break signalling on hangup
Date: Fri,  9 Oct 2026 16:09:42 +0200
Message-ID: <20261009140951.490846788@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -620,6 +620,8 @@ static void __tty_hangup(struct tty_stru
 
 	tty_ldisc_hangup(tty, cons_filp != NULL);
 
+	wake_up_interruptible(&tty->break_wait);
+
 	spin_lock_irq(&tty->ctrl.lock);
 	clear_bit(TTY_THROTTLED, &tty->flags);
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
@@ -2458,6 +2460,7 @@ static int tiocgetd(struct tty_struct *t
  * send_break - performed time break
  * @tty: device to break on
  * @duration: timeout in mS
+ * @file: file object
  *
  * Perform a timed break on hardware that lacks its own driver level timed
  * break functionality.
@@ -2465,8 +2468,9 @@ static int tiocgetd(struct tty_struct *t
  * Locking:
  *	@tty->atomic_write_lock serializes
  */
-static int send_break(struct tty_struct *tty, unsigned int duration)
+static int send_break(struct file *file, struct tty_struct *tty, unsigned int duration)
 {
+	long timeout;
 	int retval;
 
 	if (tty->ops->break_ctl == NULL)
@@ -2480,13 +2484,26 @@ static int send_break(struct tty_struct
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
@@ -2754,10 +2771,10 @@ long tty_ioctl(struct file *file, unsign
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
@@ -3117,6 +3134,7 @@ struct tty_struct *alloc_tty_struct(stru
 	init_ldsem(&tty->ldisc_sem);
 	init_waitqueue_head(&tty->write_wait);
 	init_waitqueue_head(&tty->read_wait);
+	init_waitqueue_head(&tty->break_wait);
 	INIT_WORK(&tty->hangup_work, do_tty_hangup);
 	mutex_init(&tty->atomic_write_lock);
 	spin_lock_init(&tty->ctrl.lock);
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -230,6 +230,7 @@ struct tty_struct {
 	struct fasync_struct *fasync;
 	wait_queue_head_t write_wait;
 	wait_queue_head_t read_wait;
+	wait_queue_head_t break_wait;
 	struct work_struct hangup_work;
 	void *disc_data;
 	void *driver_data;


