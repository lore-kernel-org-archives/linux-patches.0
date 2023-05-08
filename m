Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF19C171A5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D81C433D2;
	Mon,  8 May 2023 11:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545397;
	bh=DI3dL5wAYAj9dvsKRwcTS7ZSFSZ4gzi/SybpIB5hmxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qi7t22sbjcFDLvwVc/vG4ykHdXVEIbmuGhcfRw/vvOv4dfMikOgFVmApjCltsNO67
	 re8fd5B4/H1LWkSv63BSKs23tU2oI/wzvIMRn0QmAwFZNYNEdXejvbkE47leuEIpeW
	 1rhtNmRu3znfBfEvyW0A+ZwQFnBQMEYiGV7Z66qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.15 026/371] tty: Prevent writing chars during tcsetattr TCSADRAIN/FLUSH
Date: Mon,  8 May 2023 11:43:47 +0200
Message-Id: <20230508094813.169655835@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 094fb49a2d0d6827c86d2e0840873e6db0c491d2 upstream.

If userspace races tcsetattr() with a write, the drained condition
might not be guaranteed by the kernel. There is a race window after
checking Tx is empty before tty_set_termios() takes termios_rwsem for
write. During that race window, more characters can be queued by a
racing writer.

Any ongoing transmission might produce garbage during HW's
->set_termios() call. The intent of TCSADRAIN/FLUSH seems to be
preventing such a character corruption. If those flags are set, take
tty's write lock to stop any writer before performing the lower layer
Tx empty check and wait for the pending characters to be sent (if any).

The initial wait for all-writers-done must be placed outside of tty's
write lock to avoid deadlock which makes it impossible to use
tty_wait_until_sent(). The write lock is retried if a racing write is
detected.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230317113318.31327-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty.h       |    2 ++
 drivers/tty/tty_io.c    |    4 ++--
 drivers/tty/tty_ioctl.c |   45 +++++++++++++++++++++++++++++++++------------
 3 files changed, 37 insertions(+), 14 deletions(-)

--- a/drivers/tty/tty.h
+++ b/drivers/tty/tty.h
@@ -62,6 +62,8 @@ int __tty_check_change(struct tty_struct
 int tty_check_change(struct tty_struct *tty);
 void __stop_tty(struct tty_struct *tty);
 void __start_tty(struct tty_struct *tty);
+void tty_write_unlock(struct tty_struct *tty);
+int tty_write_lock(struct tty_struct *tty, int ndelay);
 void tty_vhangup_session(struct tty_struct *tty);
 void tty_open_proc_set_tty(struct file *filp, struct tty_struct *tty);
 int tty_signal_session_leader(struct tty_struct *tty, int exit_session);
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -950,13 +950,13 @@ static ssize_t tty_read(struct kiocb *io
 	return i;
 }
 
-static void tty_write_unlock(struct tty_struct *tty)
+void tty_write_unlock(struct tty_struct *tty)
 {
 	mutex_unlock(&tty->atomic_write_lock);
 	wake_up_interruptible_poll(&tty->write_wait, EPOLLOUT);
 }
 
-static int tty_write_lock(struct tty_struct *tty, int ndelay)
+int tty_write_lock(struct tty_struct *tty, int ndelay)
 {
 	if (!mutex_trylock(&tty->atomic_write_lock)) {
 		if (ndelay)
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -421,21 +421,42 @@ static int set_termios(struct tty_struct
 	tmp_termios.c_ispeed = tty_termios_input_baud_rate(&tmp_termios);
 	tmp_termios.c_ospeed = tty_termios_baud_rate(&tmp_termios);
 
-	ld = tty_ldisc_ref(tty);
+	if (opt & (TERMIOS_FLUSH|TERMIOS_WAIT)) {
+retry_write_wait:
+		retval = wait_event_interruptible(tty->write_wait, !tty_chars_in_buffer(tty));
+		if (retval < 0)
+			return retval;
 
-	if (ld != NULL) {
-		if ((opt & TERMIOS_FLUSH) && ld->ops->flush_buffer)
-			ld->ops->flush_buffer(tty);
-		tty_ldisc_deref(ld);
-	}
+		if (tty_write_lock(tty, 0) < 0)
+			goto retry_write_wait;
 
-	if (opt & TERMIOS_WAIT) {
-		tty_wait_until_sent(tty, 0);
-		if (signal_pending(current))
-			return -ERESTARTSYS;
-	}
+		/* Racing writer? */
+		if (tty_chars_in_buffer(tty)) {
+			tty_write_unlock(tty);
+			goto retry_write_wait;
+		}
+
+		ld = tty_ldisc_ref(tty);
+		if (ld != NULL) {
+			if ((opt & TERMIOS_FLUSH) && ld->ops->flush_buffer)
+				ld->ops->flush_buffer(tty);
+			tty_ldisc_deref(ld);
+		}
 
-	tty_set_termios(tty, &tmp_termios);
+		if ((opt & TERMIOS_WAIT) && tty->ops->wait_until_sent) {
+			tty->ops->wait_until_sent(tty, 0);
+			if (signal_pending(current)) {
+				tty_write_unlock(tty);
+				return -ERESTARTSYS;
+			}
+		}
+
+		tty_set_termios(tty, &tmp_termios);
+
+		tty_write_unlock(tty);
+	} else {
+		tty_set_termios(tty, &tmp_termios);
+	}
 
 	/* FIXME: Arguably if tmp_termios == tty->termios AND the
 	   actual requested termios was not tmp_termios then we may


