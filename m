Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E2A2517A8;
	Tue, 29 Apr 2025 18:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950536; cv=none; b=VH7O+JYm0X58FiEllWyU++kvkPSx7FCaRWO9PX77gVuksXiTu4mxArYrBC5GSrPPMna+e70lvTvIi8c3gSlUxQafDqLQeET1vvdU6skWDpBxG/f2ksWMgMnFY7xvltjo5CZPQ3jd8GTFtbaaXjxlQEiQtZzl/ShqYPIGvpbCYq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950536; c=relaxed/simple;
	bh=ZaOoIMxRRO83GQt8sxZrzAVcI8VkBs8GfEBbQHfqmYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+wMnXz5wrjSdcDdX63vkACV8pPcDaSMQ6UlFLNw1bCmO/oQjyn6SHPnZAvCyO107ensO5fR08ajd+ujWGVmtBdCy1gpg7KyYR3OjxuN07wDgoqXh5BOLAqAACqWajjyX/oG6CEN+uZVK47t+SeuNwh6jKQ2mR3QE7OSJep/HRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aouyxgpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aouyxgpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608C5C4CEE3;
	Tue, 29 Apr 2025 18:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950535;
	bh=ZaOoIMxRRO83GQt8sxZrzAVcI8VkBs8GfEBbQHfqmYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aouyxgpUs6jTOxn3GPiAscUmJK7tZ3KIbV6BEVP3AuXGq44/ENACl3v9fDxCOmHw0
	 eoxgq9mY7c45fw4wrn2Qt757REmuxSpcvCXwRXEXO8yhJHXd0bqTBlGHOqRSDSFv90
	 68Cogkwkfpb7rJhRNV6aDe5VZS3SEJHyP8Tgo3Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryo Takakura <ryotkkr98@gmail.com>,
	Petr Mladek <pmladek@suse.com>,
	John Ogness <john.ogness@linutronix.de>
Subject: [PATCH 6.6 098/204] serial: sifive: lock port in startup()/shutdown() callbacks
Date: Tue, 29 Apr 2025 18:43:06 +0200
Message-ID: <20250429161103.445547504@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -562,8 +562,11 @@ static void sifive_serial_break_ctl(stru
 static int sifive_serial_startup(struct uart_port *port)
 {
 	struct sifive_serial_port *ssp = port_to_sifive_serial_port(port);
+	unsigned long flags;
 
+	uart_port_lock_irqsave(&ssp->port, &flags);
 	__ssp_enable_rxwm(ssp);
+	uart_port_unlock_irqrestore(&ssp->port, flags);
 
 	return 0;
 }
@@ -571,9 +574,12 @@ static int sifive_serial_startup(struct
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


