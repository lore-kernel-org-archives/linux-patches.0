Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5929F2459EC;
	Tue, 29 Apr 2025 17:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947317; cv=none; b=qmC/Vjc7rjk6IQpP2i5ITbVVFBW+VwTIDhWRYeHwgDxNOKqG8CXziOiC1HMmQNApcSKFkN8icYACNxdFeFD9WVcw/OqCJ3b+c879tUlttsjBbXjGipwFS8bVoUiaUzTk/464UzM7v4NB0gtYRDuo4INjpBt1gGSiyqy8UjeGicI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947317; c=relaxed/simple;
	bh=+OIy3H3qUket8mn1JKZaBaf/m/A/zKPv5kaHRzMlBn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fljc6nYo02Kj9X9IeT/x3Ic0zoQl/3e2aiy90k3Y7GYaSTnxAw4WWbpaBW43A7Y2hX0lIIWMHc32WMaAbtkJ8tO/Gmn0aYCmEPypxIuISeCRgYijdm7qsT5rlpKH8sFbXTJmHEqrHBdlJKovLqT79E1iyMoioABnYobeI0SdSdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qN56ZU0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qN56ZU0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536F8C4CEE3;
	Tue, 29 Apr 2025 17:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947316;
	bh=+OIy3H3qUket8mn1JKZaBaf/m/A/zKPv5kaHRzMlBn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qN56ZU0S13T+ZEaREXIA1jSVVoPJUN92OZQlYF3DOftLyQgPlZi+nvKkTMScOJSym
	 Clpxz2/u5A4iCQt9GU9RmDfT1LOQ2JRqdEZ+DS1b8fCKRvwKPFkCo2oMAJLIHM/Su9
	 y3GCePasZcgcSVzHqv19I3dDG+t2UzAUGDzzhETU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryo Takakura <ryotkkr98@gmail.com>,
	Petr Mladek <pmladek@suse.com>,
	John Ogness <john.ogness@linutronix.de>
Subject: [PATCH 5.10 243/286] serial: sifive: lock port in startup()/shutdown() callbacks
Date: Tue, 29 Apr 2025 18:42:27 +0200
Message-ID: <20250429161117.919285452@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryo Takakura <ryotkkr98@gmail.com>

commit e1ca3ff28ab1e2c1e70713ef3fa7943c725742c3 upstream.

startup()/shutdown() callbacks access SIFIVE_SERIAL_IE_OFFS.
The register is also accessed from write() callback.

If console were printing and startup()/shutdown() callback
gets called, its access to the register could be overwritten.

Add port->lock to startup()/shutdown() callbacks to make sure
their access to SIFIVE_SERIAL_IE_OFFS is synchronized against
write() callback.

Fixes: 45c054d0815b ("tty: serial: add driver for the SiFive UART")
Signed-off-by: Ryo Takakura <ryotkkr98@gmail.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: stable@vger.kernel.org
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Rule: add
Link: https://lore.kernel.org/stable/20250330003522.386632-1-ryotkkr98%40gmail.com
Link: https://lore.kernel.org/r/20250412001847.183221-1-ryotkkr98@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sifive.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -596,8 +596,11 @@ static void sifive_serial_break_ctl(stru
 static int sifive_serial_startup(struct uart_port *port)
 {
 	struct sifive_serial_port *ssp = port_to_sifive_serial_port(port);
+	unsigned long flags;
 
+	uart_port_lock_irqsave(&ssp->port, &flags);
 	__ssp_enable_rxwm(ssp);
+	uart_port_unlock_irqrestore(&ssp->port, flags);
 
 	return 0;
 }
@@ -605,9 +608,12 @@ static int sifive_serial_startup(struct
 static void sifive_serial_shutdown(struct uart_port *port)
 {
 	struct sifive_serial_port *ssp = port_to_sifive_serial_port(port);
+	unsigned long flags;
 
+	uart_port_lock_irqsave(&ssp->port, &flags);
 	__ssp_disable_rxwm(ssp);
 	__ssp_disable_txwm(ssp);
+	uart_port_unlock_irqrestore(&ssp->port, flags);
 }
 
 /**


