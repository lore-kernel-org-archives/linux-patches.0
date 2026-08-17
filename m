Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523453DBD43;
	Mon, 17 Aug 2026 13:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974371; cv=none; b=Rd7FAsacUPt1cFnsZtBYlaSIRLBQcAJPJZ+tZgH7nZ5OG2x3PSrQpmgu34w8numm/U43ExH6DWE0g7l78+RSbKcJill7gxWy4r/TEVniqZVrviZdMHT0QlfxRUA0s2rS8ckf2EVnTlPIy13Aw2L6mPavQoQA3wkoBThG5aLdyao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974371; c=relaxed/simple;
	bh=JTfNLflyq3Q5utclGfsklHPsseuM6R3tSIZGc31TCos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQWI7DHkf/19ily5Sk1LANzGsCvtiU9uTtyF87MpC1bMJR+cH4FyaGzX+5tYTmZALoag2et2W4Sg6ZM6zKWSuT7kGmwf+Nyt4TzZAHal9jWCBK7P7HkNPw+Vukl2IFakluWWzjfJenkxe1eiFLD+Gnw9WY4Jihuh9pP3L7IDiNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGtA4Dli; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGtA4Dli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14161F000E9;
	Mon, 17 Aug 2026 13:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974365;
	bh=ENOJiAeta7kaPWdQcfhZywMNstU3t5zW1QtkrgAIOVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wGtA4DliakjjEnC5CKDxB119wnMAA531kyH/BakdksjLP9mZdPPV8csurtzjhvXfC
	 vxVq4gBUSbvJkHFuBHgVUnARsZirHMt5S/Z2d/DsRrUOlfdJjSdLpYfxisTSHpPA2A
	 KAPuzVdlUx+Z0STBEZH951z+MbuqAdG43G6yjW2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH 7.1 181/271] serial: amba-pl011: fix indefinite RS485 post-send delay
Date: Mon, 17 Aug 2026 15:31:46 +0200
Message-ID: <20260817132544.278121459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit dcb2f7576ce460eb4f6b9048b7c266c8da5848a8 upstream.

The RS485 stop hrtimer is used both to drain the transmitter and to wait
out delay_rts_after_send. The callback cannot tell the two apart, so it
restarts the post-send delay on every expiry and the timer never stops.

Add a WAIT_AFTER_SEND_DELAY state so its expiry ends the stop sequence
instead of restarting the delay.

Fixes: 2c1fd53af21b ("serial: amba-pl011: Fix RTS handling in RS485 mode")
Cc: stable <stable@kernel.org>
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260731085915.326775-2-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -277,6 +277,7 @@ enum pl011_rs485_tx_state {
 	WAIT_AFTER_RTS,
 	SEND,
 	WAIT_AFTER_SEND,
+	WAIT_AFTER_SEND_DELAY,
 };
 
 /*
@@ -1318,6 +1319,7 @@ static void pl011_rs485_tx_stop(struct u
 			return;
 		}
 		if (port->rs485.delay_rts_after_send > 0) {
+			uap->rs485_tx_state = WAIT_AFTER_SEND_DELAY;
 			hrtimer_start(&uap->trigger_stop_tx,
 				      ms_to_ktime(port->rs485.delay_rts_after_send),
 				      HRTIMER_MODE_REL);
@@ -1383,7 +1385,8 @@ static void pl011_rs485_tx_start(struct
 		uap->rs485_tx_state = SEND;
 		return;
 	}
-	if (uap->rs485_tx_state == WAIT_AFTER_SEND) {
+	if (uap->rs485_tx_state == WAIT_AFTER_SEND ||
+	    uap->rs485_tx_state == WAIT_AFTER_SEND_DELAY) {
 		hrtimer_try_to_cancel(&uap->trigger_stop_tx);
 		uap->rs485_tx_state = SEND;
 		return;
@@ -1450,7 +1453,8 @@ static enum hrtimer_restart pl011_trigge
 	unsigned long flags;
 
 	uart_port_lock_irqsave(&uap->port, &flags);
-	if (uap->rs485_tx_state == WAIT_AFTER_SEND)
+	if (uap->rs485_tx_state == WAIT_AFTER_SEND ||
+	    uap->rs485_tx_state == WAIT_AFTER_SEND_DELAY)
 		pl011_rs485_tx_stop(uap);
 	uart_port_unlock_irqrestore(&uap->port, flags);
 


