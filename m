Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC114E0B91;
	Fri,  9 Oct 2026 14:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556462; cv=none; b=P4eS6MOtaiyxgnTjKquduP0yEXEZv9+m925Oruu9AhFY5nyaZCkiBUyNEX5NxuceObrOHNGitNckj+ICpxUWHxuyiCPGhbLSyXWzQ8Fvpbn1PWP/bQBxulOyCf8vFRFoBzZFrn/8T3yfEeM8KAdQivS6lLEYNMndfaMFugSDgBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556462; c=relaxed/simple;
	bh=PV289Uaafq6KJqtl4PCY59L9d2cnCL4h7Tm9RYyYWB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAq1O6TyE11KAYmCLYc4rvVixRGWMod7qeNnKphMk71a/Qy/t7SXhWnLFzBAu7Inl0l/AosBTtEzNAMWVUrTfqtBYTMR4u7iN3NWc6ls4kpl2uO0pea/S68j7FAecEoTCXBFlsLpo2cCThBQGde+8P8tOcSWxeOzzNvNiw5QzFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wItstuLM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wItstuLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C791F000FF;
	Fri,  9 Oct 2026 14:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556459;
	bh=Zq8JWaeskuYhYna9dIhTbkzvSl+MDHxCL59HR92882Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wItstuLMTvHRUqM6W/8ghtevO+BIWv5Io/q1nz9xXZHKJa3in4RKQs/VKXyhqrmIH
	 LS2gUcTIZdxDFS8ui1tEgv52H3Q4Xa3jwEmMJBm1Vm3eCO20biiDpvHrEYIhtM4N9I
	 Jv86jH7VLZhIJVcIxdQHyQrg4DWNBXn7WpyMmG0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.18 201/403] serial: revert guards in uart_wait_modem_status()
Date: Fri,  9 Oct 2026 16:09:22 +0200
Message-ID: <20261009140956.834629604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
@@ -1220,15 +1220,16 @@ static int uart_wait_modem_status(struct
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
 


