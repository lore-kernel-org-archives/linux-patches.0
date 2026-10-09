Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4289D473C8D;
	Fri,  9 Oct 2026 14:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556856; cv=none; b=MKh8I7YCTRIJ+8+4sxPAw2u0nX30QU2FNvr2awy1XisPHsr0S1CfcxuIWI2G+Rk3TKMGEyxEOS1Wt+w9SgWp2XgQlDIArsqk5R7m+k3ucjpT49TeN5PKzyw5x8iOoEZ28EVD2d6gEw+e0HrLaKS/0svdPKT+jp69Ne9rMfA6WZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556856; c=relaxed/simple;
	bh=MVsrWP6buyP+L5NdkBkHibZsa4o8NNb5pxIJrBKsG+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6iCR+4O8C2ChQR2lHmWih0lsnhqflyapH5rw/YoOUN2jGW/57zIangKKA3IDXXbhM8+LZutasehGaKEX1Nj9jmMnB+PJl11GpbdgbdGT+N0mtngc8YnWefUjnBIg2tOwvcq8F1JZtByGMHZffTDWy//2/0TVCbNUfAONt+yvnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ar2i3BsV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ar2i3BsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FB11F000FF;
	Fri,  9 Oct 2026 14:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556855;
	bh=1bkGJKXbgdSl4V10PN0qPGiRbhkTZTlzX75RjriCp4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ar2i3BsVKVNPHs3D8wSRyIXK61nJ4HP85Yo7hdFvR42rPAFDGK4Y6SsoWNK6Ha7Hd
	 SH75rBERrkfOo/k1ZtR/u2+6ddWXiBZNF0UDdCRKZImjcHMxjNSn+Ajg1CokgeAbvW
	 6k55/EzcxmNt+Gmvt28DibTttqEPa/5zwuz7WJ6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	stable@kernel.org
Subject: [PATCH 7.2 253/428] serial: revert guards in uart_wait_modem_status()
Date: Fri,  9 Oct 2026 16:09:50 +0200
Message-ID: <20261009140951.662557080@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit f658e6bcd00a4eafaa9c98c0b7483cc2c5dac539 upstream.

Mixing scope-based and regular cleanup is discouraged and
uart_port_deref() used by uart_wait_modem_status() falls in the latter
category.

Revert the guard conversion in preparation for fixing a hangup race.

Fixes: 56609c050051 ("serial: serial_core: use guard()s")
Cc: stable@kernel.org	# 6.18
Cc: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260910130816.642699-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1212,15 +1212,16 @@ static int uart_wait_modem_status(struct
 	uport = uart_port_ref(state);
 	if (!uport)
 		return -EIO;
-	scoped_guard(uart_port_lock_irq, uport) {
-		memcpy(&cprev, &uport->icount, sizeof(struct uart_icount));
-		uart_enable_ms(uport);
-	}
+	uart_port_lock_irq(uport);
+	memcpy(&cprev, &uport->icount, sizeof(struct uart_icount));
+	uart_enable_ms(uport);
+	uart_port_unlock_irq(uport);
 
 	add_wait_queue(&port->delta_msr_wait, &wait);
 	for (;;) {
-		scoped_guard(uart_port_lock_irq, uport)
-			memcpy(&cnow, &uport->icount, sizeof(struct uart_icount));
+		uart_port_lock_irq(uport);
+		memcpy(&cnow, &uport->icount, sizeof(struct uart_icount));
+		uart_port_unlock_irq(uport);
 
 		set_current_state(TASK_INTERRUPTIBLE);
 


