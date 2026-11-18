Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052408;
	b=G/LAYLE55Vo1DOlwHyLjB9sCwOKrIoaqCdLCJEakLUx2u8Bi2EKSpg8VjiuLclAIC5T0
	 X5QkDn/IjFIM0GL/4wGmdR4dtOodu5iXV2QWou1Gh5l3ivSzBTNQ4KosK4KvnhQq7W6ce
	 miAq4ANlXftED/c22/lL8AJumuZuRrw66l+eiA6c4Muxphk79Vy3tyH/J008stGrGzYPF
	 8Co4x1xlDJ4GN9OuSSr6G9+Ng7pIzHGThB37wB/TfX8dW5pSFPFW5NuMXv2jonrvvTl/M
	 6AE/ToDX3XDgZ+/FsEdeSQWqiRNR/uALd/zl7EvxQGnDxkP1yjwS6GHc1y6o/VIlzNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JlnY4/FYIE2IGe3p+zVGo8vTW3szrEicH23pV5YIfmQ=;
	b=ZS82zWZYeNJiZ5ijWrTIpldum2KgmP5Ln7UAjbqfTh3OiAKPLT4jLrIGBcr66lfUl5rA
	 es8v4Z1NCINHGrktwPJSmp7XpPHHh2ZzNCOcpX2FcdJGhvoZZLJHaN5YLzBUwEe5mi+hG
	 dT1ruykeM4bUFVvx7iGTuW7um2JUUyKJ4pjRzy/8d28cMfvxB91F1tkFa9f5PamgAEFiH
	 seu4Y9bWf7BO1U62nWQFAIHgxiAcUpMvxj0R1qVI414//WyS9g6chrA6eQx5uMHi6aogd
	 HpyS7KEjFRb50QuhK4UGW94gBO4yDUd9JLhnNGOAl5ih/FkAMBupWxFufdS7QiwV18Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+eLkzXz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1424606A333;
	Thu, 19 Nov 2026 01:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+eLkzXz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6EC1F000C7;
	Thu, 19 Nov 2026 01:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052408;
	bh=JlnY4/FYIE2IGe3p+zVGo8vTW3szrEicH23pV5YIfmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+eLkzXzchNMJe+sMK09rJDfXx9ajv4ZeF6ChD8QknwC6vYsBk+34uhHY6t0ZIOxw
	 LdcESsSfQbgoYkIG54CBmA9KEeWw9kBLo/MorNirDkHeru5FoIgTz9EZRy+onD7VWH
	 WTtLpZI+ycaEHUbNePdUy5Y4wtlS1qpdk0whhSPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 5.15 0552/2214] staging: greybus: uart: fix racy TIOCMIWAIT implementation
Date: Wed, 18 Nov 2026 15:37:08 +0100
Message-ID: <20261118150033.074981288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index 87e9e349b3c61..6438ba930a594 100644
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
@@ -642,11 +641,16 @@ static int wait_serial_change(struct gb_tty *gb_tty, unsigned long arg)
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
@@ -656,18 +660,20 @@ static int wait_serial_change(struct gb_tty *gb_tty, unsigned long arg)
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



