Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036295;
	b=ajmHArC1PhAlwe068cQ7CxISXTx2dTtarpDYzynLqiPdHvY88LxiARFapI8rdl5UZC97
	 3V1vZCJXgM6WwTJbnhz9eoP6mpgpLQ243mtx3Md7oOqdUWUQDyuKgNJioOgQI4uBlwj6M
	 SZNi358Oxotiype7gSr7GdRrB9ykLe1vrn2//FE00HOh+QmKskdDuEeqAeRYdB0/iJZ0y
	 qj+bTyC4JBJh9m9ZdxtcyKpfINacgEkwpR/9pC5v5HdQt6b7NYaLK9+vvVHYYg7fCC2GV
	 fwSWpMBnhUl5JoiIFrcbyV4kScq1KxhyHrAidk6u9KpuwnTsk8SyrWMNxB2MfE740fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2bHgU839lY6SyHXuMtVzksfCwEzlmD0D9A1bRufTAMA=;
	b=npnD5e9qGor1bHtKuu+ym7CjO2u8sucTpFFc7ZNFqrXv/N01enTbqKgKHzlAgMVOE2BV
	 DLPmdrl3zBGi/gE3ejRG3QVZqOdMV75fM2mlnH3J7TSuuvQrUljHUc8I+dWMsbroOKDPI
	 Z8SW1sL4kYz3xuEqkeP8PLTgvIzcGtPxN/LMSVNa2sbeGKT6lQNTGwJp9+IRY0D+KyXyO
	 nn3dmt7+Z7Ropa5cJjNnxRb9ImHo27BocViFF6gqPfbN9SVwIb9B3gGnZjdg3eph0u6l/
	 mQ+yw8cpErh3HHcytKc9bDIoE0Gdq+hSyNY4k0Tr7KCcTdUYZgWvZZDsn0scWjHRzYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Toe262Og;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232E0606A31C;
	Wed, 18 Nov 2026 21:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Toe262Og
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5613D1F000C4;
	Wed, 18 Nov 2026 21:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036294;
	bh=2bHgU839lY6SyHXuMtVzksfCwEzlmD0D9A1bRufTAMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Toe262OggTKhFvNhlzfrXsaI9r1MuSPLvzoMKb0PWYpbXZvkFH+cPbP7/zaSelqcE
	 QccYZR2bxflgsJKqzSGw17f1s2z4miCw8zHG8BuhsF6OPOY4DeAqvH3zPn9naa4wCd
	 Fj6rXI+OdHDcUKw/4ELUglBK4cUVayCZwBHUmUno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.6 0971/3318] staging: greybus: uart: fix racy TIOCMIWAIT implementation
Date: Wed, 18 Nov 2026 15:26:33 +0100
Message-ID: <20261118150348.827481485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit e94cda6551d4716b17353fc458baa9e85ddea9ff ]

Check the wakeup condition after adding the task to the waitqueue and
updating the task state to avoid missing a racing modem status update or
disconnect.

Store the old icount on entry and do not update it in the completion
handler to avoid missing events or reporting spurious ones (due to modem
status changes before TIOCMIWAIT was called).

Fixes: e68453ed28c5 ("greybus: uart-gb: now builds, more framework added")
Cc: stable@kernel.org	# 4.9
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260907095305.130762-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/uart.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/greybus/uart.c b/drivers/staging/greybus/uart.c
index f067f26fefcb3..1dcb362495371 100644
--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -53,7 +53,6 @@ struct gb_tty {
 	spinlock_t read_lock;
 	spinlock_t write_lock;
 	struct async_icount iocount;
-	struct async_icount oldcount;
 	wait_queue_head_t wioctl;
 	struct mutex mutex;
 	u8 ctrlin;	/* input control lines */
@@ -641,11 +640,16 @@ static int wait_serial_change(struct gb_tty *gb_tty, unsigned long arg)
 	if (!(arg & (TIOCM_DSR | TIOCM_RI | TIOCM_CD)))
 		return -EINVAL;
 
-	do {
+	spin_lock_irq(&gb_tty->read_lock);
+	old = gb_tty->iocount;
+	spin_unlock_irq(&gb_tty->read_lock);
+
+	add_wait_queue(&gb_tty->wioctl, &wait);
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
 		spin_lock_irq(&gb_tty->read_lock);
-		old = gb_tty->oldcount;
 		new = gb_tty->iocount;
-		gb_tty->oldcount = new;
 		spin_unlock_irq(&gb_tty->read_lock);
 
 		if ((arg & TIOCM_DSR) && (old.dsr != new.dsr))
@@ -655,18 +659,20 @@ static int wait_serial_change(struct gb_tty *gb_tty, unsigned long arg)
 		if ((arg & TIOCM_RI) && (old.rng != new.rng))
 			break;
 
-		add_wait_queue(&gb_tty->wioctl, &wait);
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule();
-		remove_wait_queue(&gb_tty->wioctl, &wait);
 		if (gb_tty->disconnected) {
-			if (arg & TIOCM_CD)
-				break;
 			retval = -ENODEV;
-		} else if (signal_pending(current)) {
+			break;
+		}
+
+		schedule();
+
+		if (signal_pending(current)) {
 			retval = -ERESTARTSYS;
+			break;
 		}
-	} while (!retval);
+	}
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&gb_tty->wioctl, &wait);
 
 	return retval;
 }
-- 
2.53.0



