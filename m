Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064309;
	b=DvoKBwRJ99McFK4zY1borTSeIQheTE379oo4nelIYKjlriwtSN2X0rGifa8t+rXkAa0w
	 pJw8itcEuKYPa7z+tQTS3UlZCtADpvGhsxmLmzQAGyPa5zLv1sYTFjmcDmgKebd71p+WY
	 J9lododUsMwLwcCqOcn6RWhFaqcyc7aNo0tu9IF8U9ZBxFbcXSPslLmyjWO/hsIcbzowX
	 THVBkyq4m0NM9HEltsk+pmbuwIVgbRuvc/eyqPdH+T4rXdaPWC+PKrmBWb0EI0dp+eu/t
	 7BT5UdPM9vqe39UaV5ShJ8nxBjmggZW7yVTsVR065kmADwJDHelte/PSgnGLSQPeHaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4cxzjGvejxDxZaM4Hs69LerBX51PSjjvPLwL/ApoxyQ=;
	b=Dk9rMIr4Odi6+i73MYpJJdkmKQKMmqQfoe2G/p4/egdjErdWInzmBraYEF81UaJAk/Kf
	 lpUipxGW84XK6J3Ik9ydUWR5TkqGwQ5Svsw7HjDaVRbaAwdltwpDFgmtXz8Mz8JwZ936i
	 yFx7LbiNHixo5p8uYeA0bjFtu4Lss4VzrXm+dfmqaTmMZTVnxhMODCsEVj0YyV9H3GnxQ
	 uZhW7oWrCrzFGkDwMa5XeKkVICZv4lFCJB2ZdQUdUoTJRdQq7z1SPXUqRHLrl2RYZpJZD
	 4eGvFRJ0L0DCy/i3x2Le0WjjUYaTylQMrmZYclZZqdneIpPbQ5LyFnGpltVYPqSIrfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1Icxybp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75291606C030;
	Sat,  7 Nov 2026 15:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1Icxybp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209841F0089F;
	Sat,  7 Nov 2026 15:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064309;
	bh=4cxzjGvejxDxZaM4Hs69LerBX51PSjjvPLwL/ApoxyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1IcxybpyxaqYOHTQMnd9cmVq+ojYlUVu8D/q3zqk71J/mBWRR3vF3EF7qbFZ3NTN
	 zGitxRTG2SgOxXmUyHzBbBIUPN626SpXkCRhlz3k2t/Nt7N8uB6dLiC6Ecco/Ck98P
	 KtD4fFQx+hLTYydJ4zMwtNZ6M0ayjRRLfuVXhcVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 7.3 0400/1257] staging: greybus: uart: fix racy TIOCMIWAIT implementation
Date: Sat,  7 Nov 2026 08:44:56 -0500
Message-ID: <20261107134950.583527540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 172cf900eaf0b..2c47418a11ef8 100644
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
@@ -643,11 +642,16 @@ static int wait_serial_change(struct gb_tty *gb_tty, unsigned long arg)
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
@@ -657,18 +661,20 @@ static int wait_serial_change(struct gb_tty *gb_tty, unsigned long arg)
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



