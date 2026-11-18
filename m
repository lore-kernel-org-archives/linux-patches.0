Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045356;
	b=qd1XsO9KOqXjNbffuezsJn23GpObY+GwaY119rbWqZNQLcQXgA4HsN+iGQwOeqV9SOQ7
	 QYGH7Oi1LEE6CqfYxuNnfcmx/vInn4rTv5OBv7pATbOliKrP/6m/PI17f8fAW6NKkiTsA
	 11DpoM7xOmbqAhHanMsxFf+zh7vkuQoihZK09lodiaI/w7n6qnf0gkOHBVoho2nC+A/WE
	 cSPuHIsWoBqDd/8QhJ0CfJrjgzwGzf2MSuMP8qyLvJdqfDnEyp/A1QMOgCZsPn+cX2+8a
	 83rIlNJOnIr9/HFVU60a2BO752rDV5G8/0Ub1QGWwuY5RPUNlyN1IvcAKawu4zV4SEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6dM9sSfJael+SfBhiIzsnvnpnY0Cfa3vILnVI4kbaVQ=;
	b=FvEpTA9rThVXg/vmmmYKaz/vRAAJMOqQkjTLcbVAjbSMUKXQE5skCwDh9DCbCYswWFtf
	 Vh+BL80yZ2tUlRqy7Z5CH4vKyJWT+w0TkWAOYEAF4JqA1rJCbw83UgrHwRtQW5xKEiH1S
	 jF6SGO9b3Gc/K1lPJ1L71PwSPP1BZTigBuXu+kgf1TQklJD+GW588rJ1OclUYLamflzcv
	 bApC/5tI4YaIdF2ZfVhvqwxajJqPTTkeS810CQLUe3Rj4nWlj4JhpYQ+iCNb5gmoVWFHV
	 v7Eu8LWiCQlfseWg3LPaBJp70eebpNYJIjE+9owQA54w+zzZvNP5Yysu72Oh0n44TXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jAFW9YwB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51803606A31C;
	Wed, 18 Nov 2026 23:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jAFW9YwB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65211F000C4;
	Wed, 18 Nov 2026 23:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045356;
	bh=6dM9sSfJael+SfBhiIzsnvnpnY0Cfa3vILnVI4kbaVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jAFW9YwBlJjSpWxpUbhYSAC3F4fq7QpwGOeHCKzHUdT4HaYDyyFZH0HLk1EA2T06f
	 9jW8drid+TBXal8ZSSOstWeFptVQlWxyRujMbC9KXrJGlswSi8UyHe0lDx/QP0wX6b
	 Hwi3EEt3ntjtHi4UD6oxbf8pk95U+Y2dYtQ/lqEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.1 0844/2857] staging: greybus: uart: fix racy TIOCMIWAIT implementation
Date: Wed, 18 Nov 2026 15:31:18 +0100
Message-ID: <20261118150231.963865087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 0bdef38a15d72..8de0bf8de1d80 100644
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



