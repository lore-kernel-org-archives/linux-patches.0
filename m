Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1B022488E;
	Tue,  8 Apr 2025 12:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115319; cv=none; b=Ktw7tC+b6eIpZMdob9w8V7G5NuVZHVt/yuxOGPgIo45fMC1+/aB6HbjV3DbWra648UzMJdgWehDygGPjsqPIyklEAAzwxFv9UezTVTIRgQK64LBxPnkDmvIe/t6qwr2Vy306afVeDNhfvsdQknguhZ1WBIG4z9yqqpeb7LgZMUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115319; c=relaxed/simple;
	bh=SD6Six/t8viTd3pVD1u/q2rbMNrFrfBT8J4b1eIUBh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YO1M+mA80inVYhg0EO29PZRxOhmyHuEo+BgpWfatnfGFDBoLLgh6JIz5S00YudRMuZGWLcQKlQrRkUuwY+Kxm7yAxM6HyZVGSp1gdfDbnVJT1A1qWDQuCu5VjGbVCzNj3KuRoML60QYF4fz5DWDe8bVt0lXehLoFXWcsBamoqhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JS3x6cC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JS3x6cC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA94C4CEE5;
	Tue,  8 Apr 2025 12:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115319;
	bh=SD6Six/t8viTd3pVD1u/q2rbMNrFrfBT8J4b1eIUBh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JS3x6cC/onfmRB9UqhxMVbCDs92HaMBVkumrrlmI3Fsg7gxwjH+z4anwJ8pW2Oycq
	 Uvo08eHX/Aun2wHbcL7Um9r8ZNn8lfxMjsowYBzJkRdcR46wdh+wjF9syYqpoayzFA
	 5SqmsbDzf+cben1o91kunzW3hnmeSlE6anb9f3jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sherry Sun <sherry.sun@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 431/499] tty: serial: lpuart: only disable CTS instead of overwriting the whole UARTMODIR register
Date: Tue,  8 Apr 2025 12:50:43 +0200
Message-ID: <20250408104901.978199796@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit e98ab45ec5182605d2e00114cba3bbf46b0ea27f ]

No need to overwrite the whole UARTMODIR register before waiting the
transmit engine complete, actually our target here is only to disable
CTS flow control to avoid the dirty data in TX FIFO may block the
transmit engine complete.
Also delete the following duplicate CTS disable configuration.

Fixes: d5a2e0834364 ("tty: serial: lpuart: disable flow control while waiting for the transmit engine to complete")
Cc: stable <stable@kernel.org>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20250307065446.1122482-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 2971de64f6a3d..ca5beb0831153 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2341,15 +2341,19 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
 	/* update the per-port timeout */
 	uart_update_timeout(port, termios->c_cflag, baud);
 
+	/*
+	 * disable CTS to ensure the transmit engine is not blocked by the flow
+	 * control when there is dirty data in TX FIFO
+	 */
+	lpuart32_write(port, modem & ~UARTMODIR_TXCTSE, UARTMODIR);
+
 	/*
 	 * LPUART Transmission Complete Flag may never be set while queuing a break
 	 * character, so skip waiting for transmission complete when UARTCTRL_SBK is
 	 * asserted.
 	 */
-	if (!(old_ctrl & UARTCTRL_SBK)) {
-		lpuart32_write(port, 0, UARTMODIR);
+	if (!(old_ctrl & UARTCTRL_SBK))
 		lpuart32_wait_bit_set(port, UARTSTAT, UARTSTAT_TC);
-	}
 
 	/* disable transmit and receive */
 	lpuart32_write(port, old_ctrl & ~(UARTCTRL_TE | UARTCTRL_RE),
@@ -2357,8 +2361,6 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	lpuart32_write(port, bd, UARTBAUD);
 	lpuart32_serial_setbrg(sport, baud);
-	/* disable CTS before enabling UARTCTRL_TE to avoid pending idle preamble */
-	lpuart32_write(port, modem & ~UARTMODIR_TXCTSE, UARTMODIR);
 	/* restore control register */
 	lpuart32_write(port, ctrl, UARTCTRL);
 	/* re-enable the CTS if needed */
-- 
2.39.5



