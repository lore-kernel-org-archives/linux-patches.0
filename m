Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063069;
	b=G/QJ+2g2TStVg8bpgal4Csa+dBgoqJp0YLL5eBdjQkekRDyLrJWBmHWEysLGLV/5mfB0
	 lQAfL+i8bzDdEfJLL3s1vrv80fNHtvsV2U/G9ZtOYUSqnWaVT2JoivJLjL4WJRN2rR/hk
	 PAa0z/8o2GEUSWDXdphzzKh5CDz5L2WoJ+DAOg3BxS/qc3M8SXZpMY8ezswa92s7er1O1
	 W5jlPB4uXLZuzu7ftW9jAw/5fwGW9807MQHika6+fzDbybFCw/303PVuj3czmB4CPVlUd
	 nK5yd23ncrf0C5e/sBIKKZ2s2hAIjJKRP++aKYUfN1FnTVtHAFtql8hqjPUOAwApuzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hcr9u6XVzhXsYum3Y8dLzQhjkm0Pgtlwpo/xzUKmF4s=;
	b=y3H2Wtwuew2DMsOPy2Q6VUX0Od+VBCs0m5tqTshaRBFvDr1EiXnhRZcpBp6nta4wYlsf
	 XSMrPXhZ4qloA820chCR29kRKMn1t1PGcxvN26oXfDMN5YS9r7BPCQ0a6xWisejpZo+/J
	 52JZd8iGSf8dSYjP9DF7kFgMKbcvMjJ7R3U/JKAv1Ef9x6K7LZRcBi+lwv7UMGdXltUNx
	 HWd+iELLqf11xQe3bsfI62+dWUIY1FuTdUa2OgKh6FcWySnKASmMJtCcBGuaiblUOYgUp
	 5vKeCvtj8KYTF/wk96vQb1LFZE10zsjHhM+4h7Mo+ixJpVLChAJ7cW0TOApc9YT2AIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xigO4g53;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BC8606D80F;
	Sat,  7 Nov 2026 14:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xigO4g53
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01901F0089F;
	Sat,  7 Nov 2026 14:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063069;
	bh=Hcr9u6XVzhXsYum3Y8dLzQhjkm0Pgtlwpo/xzUKmF4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xigO4g53MfEE9Ka3BvdXULlxbG/CttdZqaO0YBBiyWupTJGcSDPmFSf6dqQxRziAG
	 KyTyZr+1s1Ov7JcX/L/m8EyR7bgIYd4QWBVs4bUUb4tQn+kycI5314GAVaXVvA48WH
	 X2HH4oqyB5c02pTQA6G1l51aYJds6HwotbBGQdFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.18 308/869] staging: greybus: uart: fix racy TIOCMIWAIT implementation
Date: Sat,  7 Nov 2026 08:49:50 -0500
Message-ID: <20261107134902.973342695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 78bf8c4031e93..7d2844d9bcd9e 100644
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



