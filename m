Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A397B3F23A6;
	Tue, 13 Oct 2026 12:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895112; cv=none; b=dKUEtyuFg+XgKZrb5i/CV+miKb6C35PQ+4vpWvxLHQ4VF+byrMymkAPqMwN6KRs+p1OEn2EN5o7Xh+OfII7YnMISh4RLzk7vRFGXAx1qcg/rzzTN6vgpho6xOEEMU/xSk6meT0pV3kCZ6pu/kiweqS3G+Akr+NRKBfVWgZXODTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895112; c=relaxed/simple;
	bh=dgEvSnww9dH+7atvQ1w+U2b4naHWHgXLPhLkORgEG8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqb1CjQoAGNzF9fVftZivgx++Bd83p82dDnOiw78eAtIfWmxC8FNx2TdB0n0xcwmTUTjksIrdarEfvGIss6XbBJ7fouqqyOtzdb/aEpfbPoSQorl//qZ+tIa1eAiU+CN1dVFUJLfAr7YLWi2QK2BDwcw0kTPHcLmr1KJKHNnWIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYVE4Sat; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYVE4Sat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD34B1F000FF;
	Tue, 13 Oct 2026 12:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895111;
	bh=s9lVdm6hsGMfQJViEJwpJ59N0XdtXlx7Wg++SGwzeEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dYVE4SatR6j/V26STIbGiKzrHtZkoUBvYx5rWKyPhCuuAXg5dXwfNKQLWkTk0uV7L
	 VlKsOEyA3MFHD2kkMOq9uCfyztC2d27k/d5rRr8GCwHejz4LXEIjWTpltrRe8SzE6i
	 9BULWIFFiJzdmqic09S0Crf3xzZipq8OW+x4uYyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 164/497] tty: abort break signalling on hangup
Date: Tue, 13 Oct 2026 13:35:31 +0200
Message-ID: <20261013112911.781955110@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -623,6 +623,8 @@ static void __tty_hangup(struct tty_stru
 
 	tty_ldisc_hangup(tty, cons_filp != NULL);
 
+	wake_up_interruptible(&tty->break_wait);
+
 	spin_lock_irq(&tty->ctrl.lock);
 	clear_bit(TTY_THROTTLED, &tty->flags);
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
@@ -2468,6 +2470,7 @@ static int tiocgetd(struct tty_struct *t
  * send_break - performed time break
  * @tty: device to break on
  * @duration: timeout in mS
+ * @file: file object
  *
  * Perform a timed break on hardware that lacks its own driver level timed
  * break functionality.
@@ -2475,8 +2478,9 @@ static int tiocgetd(struct tty_struct *t
  * Locking:
  *	@tty->atomic_write_lock serializes
  */
-static int send_break(struct tty_struct *tty, unsigned int duration)
+static int send_break(struct file *file, struct tty_struct *tty, unsigned int duration)
 {
+	long timeout;
 	int retval;
 
 	if (tty->ops->break_ctl == NULL)
@@ -2490,13 +2494,26 @@ static int send_break(struct tty_struct
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
@@ -2765,10 +2782,10 @@ long tty_ioctl(struct file *file, unsign
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
@@ -3131,6 +3148,7 @@ struct tty_struct *alloc_tty_struct(stru
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


