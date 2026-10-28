Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211260;
	b=3Bosr4UNk7XSCKMIRK1xqjti/uXlZxAK1a0ovAjdmcHxPaft4ssQCt8OGIAU2XsVVHG7
	 DSjEZ0Sc7RKM9sj9rfBUoJ6dps8FHY2onJiCKgT4mbN1KU+So5n6y8v/R92dhVPPj4HC5
	 aeqUZon0LC5Xn0t/cYFV7u7wtouzE3XL+jB51tBeOi3+MXdw4TSYMHPIuzcMg2AwXAxPo
	 553wEVnWx14fw4t1yjPoi50cf9KAoL0yeRhCP613DNn7vo8xVvp5N1qSGzWD5MuyUGQvJ
	 qS0Yh0SF8MOhgUpq9vK6KLznfVvFK3j5ceZYZQgsvI+138/EqzuLokcv7plWpRO4k0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HXg/bVLcjC5R4eur1vmOwXnWqLASZsOFdYkUSRle5cs=;
	b=1e2Zn16Kgbey8wbm0/yYsktf1NS+nlo7j2+5w3nrTGsZZqXP1DwwLj0OM2G8pgrD6unH
	 1vecCCuwEiM1qqndKemS0hzU0MmPJTTPrM9l2qzQRBnY+xy7rr16+K96BtZiShJ4ZLXkm
	 lFoWSlXcppotr2ROxtoKWgxuk966arG2MnMwgVEvLrokL6ApgBABwmq5TnBZWMVGurA/j
	 b7ptFfPOydKECHeW1EdrY72kWIClT+9Qv40mB2j12Ev2fCmo6Rbfk2ONKsOsOB9lEA3ss
	 lVVndPRz8AwjSTBS1Iv2F2c34HwbIk0dqi2pXfvJeGqC7PlV3A1YGw/kdsHYb+3nj9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4kr+K9H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7F2606BF56;
	Wed, 28 Oct 2026 18:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4kr+K9H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F361F01825;
	Wed, 28 Oct 2026 18:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211260;
	bh=HXg/bVLcjC5R4eur1vmOwXnWqLASZsOFdYkUSRle5cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4kr+K9H8UMsX0Iv5C7nLP4Z7alKYM9zq5XJJVbRAQ9HLbJTQW8AcsijgPrXQ1era
	 CfYlLgUGMgI8G31xfMzoTqSAbA4VCXOyWmIYczRJU72tMMEwI3arjWJvSv+WM3Lqfl
	 B/P3pruF1uWuJFJ4WnUJN7HFfO0pgbLZdNOFeZ7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 313/571] tty: abort break signalling on hangup
Date: Wed, 28 Oct 2026 17:57:40 +0100
Message-ID: <20261028170015.427117442@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_io.c | 36 +++++++++++++++++++++++++++---------
 include/linux/tty.h  |  1 +
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 1824a3c698486..ce15f9232195b 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -636,6 +636,8 @@ static void __tty_hangup(struct tty_struct *tty, int exit_session)
 
 	tty_ldisc_hangup(tty, cons_filp != NULL);
 
+	wake_up_interruptible(&tty->break_wait);
+
 	spin_lock_irq(&tty->ctrl.lock);
 	clear_bit(TTY_THROTTLED, &tty->flags);
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
@@ -2459,6 +2461,7 @@ static int tiocgetd(struct tty_struct *tty, int __user *p)
  * send_break	-	performed time break
  * @tty: device to break on
  * @duration: timeout in mS
+ * @file: file object
  *
  * Perform a timed break on hardware that lacks its own driver level timed
  * break functionality.
@@ -2466,8 +2469,9 @@ static int tiocgetd(struct tty_struct *tty, int __user *p)
  * Locking:
  *	@tty->atomic_write_lock serializes
  */
-static int send_break(struct tty_struct *tty, unsigned int duration)
+static int send_break(struct file *file, struct tty_struct *tty, unsigned int duration)
 {
+	long timeout;
 	int retval;
 
 	if (tty->ops->break_ctl == NULL)
@@ -2481,13 +2485,26 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
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
@@ -2740,10 +2757,10 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
@@ -3112,6 +3129,7 @@ struct tty_struct *alloc_tty_struct(struct tty_driver *driver, int idx)
 	init_ldsem(&tty->ldisc_sem);
 	init_waitqueue_head(&tty->write_wait);
 	init_waitqueue_head(&tty->read_wait);
+	init_waitqueue_head(&tty->break_wait);
 	INIT_WORK(&tty->hangup_work, do_tty_hangup);
 	mutex_init(&tty->atomic_write_lock);
 	spin_lock_init(&tty->ctrl.lock);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 168e57e40bbb8..9501a8640baa8 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -188,6 +188,7 @@ struct tty_struct {
 	struct fasync_struct *fasync;
 	wait_queue_head_t write_wait;
 	wait_queue_head_t read_wait;
+	wait_queue_head_t break_wait;
 	struct work_struct hangup_work;
 	void *disc_data;
 	void *driver_data;
-- 
2.53.0



