Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062195;
	b=Sxx0kiP4tOrNw5cX6yGAflYjy+0OiJkVkLsSZAnuHlheXZDSJlwWX6TSqwaqVJyD/ph/
	 GYuaHQwxs5WDgBBAY5E+FmDa9hjV1B1p1uWNTdIgwoe7Wttv9ChjgOVhTrooFHnYfkC4V
	 JtTMNDiURnk8v+k4ZpGiZuawbvqR+0vF8IJZV7aka3H6EBIA/tSDuPKXCWE+lsxeatQo4
	 7y4cGzh7q+wNogqsbIzgASqz32DSKjhsjmMUPxOFFZtl50fGU549HBixFjhqsKc7Vl9tA
	 fs3u0UeWeH7z1XZNgELr2YFxYi/SQcYGrFmYRNSIjuT3c/FyIMO+kmGJyfW21hyYc9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UXaYIBi2w64bJ1Rllg1x1KLyFa+eHnhkjjbfekAQ8r0=;
	b=0vVHbfcvOgQUwMR2BQ96TPW94DZaFtHn6WEabjMDceyqg+EM1/JbFKgGUPRtQXTFYosq
	 /M/hwUBqq+iQVSMo0wACvSXBvYxC03DvsiT71waXLQaZwCuGMkiuVBdy/im62glA3MEPQ
	 Hj3soRONs1kc6GrDGIzUzy6auoSBGh9j65MvCnyHxPRBclzf5qmOaLbtIcLlfV9+NrNvo
	 LO8Uh/YXkQ04PerVLNcCOdwZXLtFslBj0SJXEShpwxNXy4dX3u1TihAZ++opElNHnUm3H
	 67XfZCG8jsKHUVt0/j8h3bFZmk8yZTD2RiL/DJAM6LygkpGAbvf4mjOEupJjxlqRzjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EjExoPxb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C35606A326;
	Sat,  7 Nov 2026 14:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EjExoPxb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3F41F0089F;
	Sat,  7 Nov 2026 14:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062195;
	bh=UXaYIBi2w64bJ1Rllg1x1KLyFa+eHnhkjjbfekAQ8r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EjExoPxbZKs2010++e6veXiyXR+CW3YA3mbbehz0g8ohC0fg8lRDytL5DiXP1dKk7
	 n3fRlXFb1mrKrTZpQdzeRT7ULhxFQQa+hA1bewXJACrCmt2jdqOIo4dwF/wG4B7sc4
	 93PSL8cIs4s9JLVduvNunAsNB67bp1HNXAPVmKz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.12 1115/1536] staging: greybus: uart: fix racy TIOCMIWAIT implementation
Date: Sat,  7 Nov 2026 08:52:11 -0500
Message-ID: <20261107135029.025050006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 025b4cda74b9f..eb1e78fcd7257 100644
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



