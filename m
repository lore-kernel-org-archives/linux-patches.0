Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE5012CDA5;
	Sun,  7 Jun 2026 10:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829840; cv=none; b=lIXfHjOiIU1z+N54phhzOx5Cqd35HTlrEWVKIWE9ut704SAqVG4zBoB6FOkvbQBtw6Tg/CXDLH9nlrWbhfrxgNE/gGYwGnD10f7SvLR4FlGDUCCFaV7k2KVo/hpe9ziK0jWG1gOGBiaan39+B9RssSIBQRomX8qbZxXvbWQjGEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829840; c=relaxed/simple;
	bh=fMD5VuYY64CB+7Zd1JUjZJLZKfCAHp6QCxKuvgULrb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CwwAOzQlsf4l/CwpYhOc5rp1mCJgAT3QZ6TuxOxwR+zaGQ2YTpYqSEWD96sReO1z2JYxKwlenEdVz8ScrXElS8HkwkB/3bPDAMuM0Vh2sATdxJFeDMZjJR5XvggrvvyZKz4/GmvgPsgpy0Daq2hUcC3btwMAjDtZqX0dpyZneWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjqhdlj3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjqhdlj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE45C1F00893;
	Sun,  7 Jun 2026 10:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829839;
	bh=Qtwy777/P7GYfJGy5RxNr0R36u3EsTZuA983l69Xp94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rjqhdlj3l30TevXm1CJJUbxcbUEXy9nujNNlbhp2PgqOCwovtbuHT9vtrUJ/AiBHL
	 rVel+5qfz42DaO5x2JYLEsi2+zJLmb/JFMyOaI36OsfrgzfR+6oefomxQnGywn1opO
	 G68OPAxoiSPrpPLc/iFEXR5hgmvTOcdelLiyAObo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jacques Nilo <jnilo@free.fr>
Subject: [PATCH 7.0 317/332] serial: 8250_dw: dispatch SysRq character in dw8250_handle_irq()
Date: Sun,  7 Jun 2026 12:01:26 +0200
Message-ID: <20260607095739.762038020@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacques Nilo <jnilo@free.fr>

commit 2e211723953f7740e54b53f3d3a0d5e351a5e223 upstream.

dw8250_handle_irq() calls serial8250_handle_irq_locked() with the port
lock held via guard(uart_port_lock_irqsave). The guard destructor is
plain uart_port_unlock_irqrestore(), so a SysRq character captured into
port->sysrq_ch by uart_prepare_sysrq_char() is dropped without ever
being dispatched to handle_sysrq().

This is the same regression pattern as in serial8250_handle_irq(),
introduced when 883c5a2bc934 ("serial: 8250_dw: Rework
dw8250_handle_irq() locking and IIR handling") moved the function to
the guard()-based locking scheme without using the sysrq-aware unlock
helper.

Switch to guard(uart_port_lock_check_sysrq_irqsave) so that captured
sysrq_ch is dispatched on scope exit, matching the fix in
serial8250_handle_irq().

Fixes: 883c5a2bc934 ("serial: 8250_dw: Rework dw8250_handle_irq() locking and IIR handling")
Cc: stable@vger.kernel.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Jacques Nilo <jnilo@free.fr>
Link: https://patch.msgid.link/ed56fcaf4af24e4ed011a7bce206e0182acb761c.1778675349.git.jnilo@free.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -427,7 +427,7 @@ static int dw8250_handle_irq(struct uart
 	unsigned int quirks = d->pdata->quirks;
 	unsigned int status;
 
-	guard(uart_port_lock_irqsave)(p);
+	guard(uart_port_lock_check_sysrq_irqsave)(p);
 
 	switch (FIELD_GET(DW_UART_IIR_IID, iir)) {
 	case UART_IIR_NO_INT:


