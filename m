Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209037;
	b=dC0v816/RupQFhyFv8Nrbv1nOmxElv2xPqVPL9nwkxYHd2Aho5bl/6sUL3GteyyJuAC8
	 fVV0Vyqk/MdCH4U917OHzJoDc9TXJ7KgeVFlwYR90zxb5SoGvcoRAs+AejlW0kFGWVNbe
	 DCxMVzR2lK9x3Vw0RCko4CMkTq2n7mGmYZcPbzJsFiohOls1cdI3bvt58vt/F1PwE3f8i
	 coeJct9BOGRWyANNMHvYNZvq6/IaznDLRg8vXAqG4WNRb4kA3ceW4gfMTGip2PMxD1rGO
	 YOwOBdAc13zJDhU33Wi76qIY+Vezq+bwQvyJVwyhKteqxemerGO4z9ox1DAptMyT3Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1sD0m+MoDgF2k0CPHePg8iUwb6r2rj06XAazGzpuR/k=;
	b=sYM6vHLVIR4vZdolPnMETczZMeYBZfjiHpOxHigyxVL9tGaD1XyOa6d5XbFZ8QjyAPaj
	 O8UceogSvvEE34I7Dj+9xOLSp3hmr60JRSNgQYQAh/NaBrMaF//aYqgD44EJMRqr88IxL
	 qemP1RPv0evGiK1f3wjweBAJeNV5Fuve16Lt8PXOBFQlJbk3Hf/+pJxV1WL7BuqkTXRLA
	 LS/X49tQBwgjVFkjJ1PBmYXjwiHgsFA9UqIAK/0rUFBXbzgqBw6T4sydbeqglkWZi2gs5
	 Cw9yjDo6feviXFBqeh3jnOOo9tVsnLjAIdls+A/MkxbG0kQEB+BEjpNrMEOgRDwQB9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d5CrQVCT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264CB606A332;
	Wed, 28 Oct 2026 17:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d5CrQVCT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B211F031E1;
	Wed, 28 Oct 2026 17:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209036;
	bh=1sD0m+MoDgF2k0CPHePg8iUwb6r2rj06XAazGzpuR/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d5CrQVCTa8lYSexHMd8xbH25hFII7RXVOZNeAId6OUP2xIlfjo2KYCfdHNQOWPmHi
	 ygISthDhFClZJsrvFPKPMM+CmmjecvMvq4b1/fB5sFq63cry6f+UAyEr68AC4MNHh/
	 8RvHCo3cFHmCA1hJxSj55qz4IlXqSD4+jSzmxSy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 287/516] tty: abort break signalling on hangup
Date: Wed, 28 Oct 2026 17:57:19 +0100
Message-ID: <20261028170010.291426100@linuxfoundation.org>
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

[ Upstream commit 845a2737e0f5ffe5ca8d38de556012b0c9472cdd ]

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
[ sashal: Adjusted hangup context to use the existing tty->ctrl_lock instead of tty->ctrl.lock. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_io.c | 36 +++++++++++++++++++++++++++---------
 include/linux/tty.h  |  1 +
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index d6322a1493861..af8a45dcf1354 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -624,6 +624,8 @@ static void __tty_hangup(struct tty_struct *tty, int exit_session)
 
 	tty_ldisc_hangup(tty, cons_filp != NULL);
 
+	wake_up_interruptible(&tty->break_wait);
+
 	spin_lock_irq(&tty->ctrl_lock);
 	clear_bit(TTY_THROTTLED, &tty->flags);
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
@@ -2453,6 +2455,7 @@ static int tiocgetd(struct tty_struct *tty, int __user *p)
  *	send_break	-	performed time break
  *	@tty: device to break on
  *	@duration: timeout in mS
+ *	@file: file object
  *
  *	Perform a timed break on hardware that lacks its own driver level
  *	timed break functionality.
@@ -2462,8 +2465,9 @@ static int tiocgetd(struct tty_struct *tty, int __user *p)
  *
  */
 
-static int send_break(struct tty_struct *tty, unsigned int duration)
+static int send_break(struct file *file, struct tty_struct *tty, unsigned int duration)
 {
+	long timeout;
 	int retval;
 
 	if (tty->ops->break_ctl == NULL)
@@ -2477,13 +2481,26 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
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
 	}
+
+	timeout = msecs_to_jiffies(duration);
+	timeout = wait_event_interruptible_timeout(tty->break_wait,
+						   tty_hung_up_p(file),
+						   timeout);
+	/* return early on hangup only */
+	if (timeout > 0) {
+		retval = -EIO;
+		goto out_unlock;
+	}
+
+	retval = tty->ops->break_ctl(tty, 0);
+out_unlock:
 	tty_write_unlock(tty);
 
 	if (signal_pending(current))
@@ -2710,10 +2727,10 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
@@ -3093,6 +3110,7 @@ struct tty_struct *alloc_tty_struct(struct tty_driver *driver, int idx)
 	init_ldsem(&tty->ldisc_sem);
 	init_waitqueue_head(&tty->write_wait);
 	init_waitqueue_head(&tty->read_wait);
+	init_waitqueue_head(&tty->break_wait);
 	INIT_WORK(&tty->hangup_work, do_tty_hangup);
 	mutex_init(&tty->atomic_write_lock);
 	spin_lock_init(&tty->ctrl_lock);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index e51d75f5165b5..12a841779552d 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -303,6 +303,7 @@ struct tty_struct {
 	struct fasync_struct *fasync;
 	wait_queue_head_t write_wait;
 	wait_queue_head_t read_wait;
+	wait_queue_head_t break_wait;
 	struct work_struct hangup_work;
 	void *disc_data;
 	void *driver_data;
-- 
2.53.0



