Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAF84457A3;
	Mon, 17 Aug 2026 13:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975113; cv=none; b=QaCq1whYrHcBdwJ3nCeWAsgwAPRABNZv8L09oeMbkBCKFj4oNOZFLqkyQK4tLZNrLfjXTZgGOJk4FnfRbzs38l6oGVH8dtx4l7Bm6uCEGouqVPLRgx93AVrVH1+zzgoVE2TcPXpP0gppcp5bfNsu7I6vonegYja4HVlOdbsl1ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975113; c=relaxed/simple;
	bh=H8AVg0PrcLcUqcHTZkUgkqNooTmfLzJs86oXs2i/tNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CR7k+7LKbDonhTBADgbFDUXVQuowUD25SZqBaaT+XqTY1zaR9oNmb78MA0A4rvhTJnPrXt2ya4V1z1GYZmYJlitU7OyEf1D+HRDBvemH+R8juWpHCDwNzFL2sTlrppO6g1CWtOSecQJxqHalcORrJheFI19k43fiMtkbki7ynjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cB4LXYSn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cB4LXYSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495031F000E9;
	Mon, 17 Aug 2026 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975110;
	bh=U5fIN35kaZUJKhtV89WWWXXMlnz5weBra9xhWQz9t00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cB4LXYSn+wRiDxmc1KxSQ2nPYpauNeoyK6uqiAjn7GkPMHKLE6h+B6wyodLVeFsXS
	 tUjpHaj3Vd/lZ2a8ukMKFXeqlbJ+cdbQqETak1gBG3OUlVTRLjQ5AsOi6Z8RzRbDKY
	 ewBFrCuCGQl37ngEChQAqpTRQU/0l417RfSI91Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH 6.18 167/250] serial: amba-pl011: fix indefinite RS485 post-send delay
Date: Mon, 17 Aug 2026 15:32:08 +0200
Message-ID: <20260817132543.457524227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -253,6 +253,7 @@ enum pl011_rs485_tx_state {
 	WAIT_AFTER_RTS,
 	SEND,
 	WAIT_AFTER_SEND,
+	WAIT_AFTER_SEND_DELAY,
 };
 
 /*
@@ -1285,6 +1286,7 @@ static void pl011_rs485_tx_stop(struct u
 			return;
 		}
 		if (port->rs485.delay_rts_after_send > 0) {
+			uap->rs485_tx_state = WAIT_AFTER_SEND_DELAY;
 			hrtimer_start(&uap->trigger_stop_tx,
 				      ms_to_ktime(port->rs485.delay_rts_after_send),
 				      HRTIMER_MODE_REL);
@@ -1350,7 +1352,8 @@ static void pl011_rs485_tx_start(struct
 		uap->rs485_tx_state = SEND;
 		return;
 	}
-	if (uap->rs485_tx_state == WAIT_AFTER_SEND) {
+	if (uap->rs485_tx_state == WAIT_AFTER_SEND ||
+	    uap->rs485_tx_state == WAIT_AFTER_SEND_DELAY) {
 		hrtimer_try_to_cancel(&uap->trigger_stop_tx);
 		uap->rs485_tx_state = SEND;
 		return;
@@ -1417,7 +1420,8 @@ static enum hrtimer_restart pl011_trigge
 	unsigned long flags;
 
 	uart_port_lock_irqsave(&uap->port, &flags);
-	if (uap->rs485_tx_state == WAIT_AFTER_SEND)
+	if (uap->rs485_tx_state == WAIT_AFTER_SEND ||
+	    uap->rs485_tx_state == WAIT_AFTER_SEND_DELAY)
 		pl011_rs485_tx_stop(uap);
 	uart_port_unlock_irqrestore(&uap->port, flags);
 


