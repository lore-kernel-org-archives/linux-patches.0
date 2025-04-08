Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEC826F472;
	Tue,  8 Apr 2025 12:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117029; cv=none; b=gU+FiQKsXfrgs73TLQAgmVrSQEwMrgM6C0g4FLMu+NH0ZiJTgHF6fPr15gcQkQRmSCZ8BvEbP5NzBBcpO8ut90IuDRXGLenbdisrbBlpMG/joKvI19lCKPkE2qa1OI8WqIGwSe3Etvp8T2gHsTZcJkwweF+xfNzodv6yxUXRyLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117029; c=relaxed/simple;
	bh=Sbc+Ta3GLYQRauiofZcgUh8WFGOp1Niymi73j81C2Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feITfMrwq7sAmiLwIoWgS+PTf2n/em8EM9N/NZ4DIntMjMMjehG7U+yuxvY6hJ1KnXITQGsSAP6TDsqPT5coWi+IhIqNkClD1Jiom5B7+Kq56MkHjaAx1w75NTPHDYhv47Ic2jEqftZiDDh+/I0Pd87MOqBHGJKhFj0Bdxc7fiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LepbCyne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LepbCyne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6F3C4CEEA;
	Tue,  8 Apr 2025 12:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117029;
	bh=Sbc+Ta3GLYQRauiofZcgUh8WFGOp1Niymi73j81C2Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LepbCyneM35j4vuoxhz7I+i6iTjyqHsojlyBdxOhOB0aHwi8he3UBkLoi4NfkjXgO
	 Pd6GQC+5x+bMjJklHdYKolv4Y77IkDVg7ZYIp+ec5/+TbFbnnJiPnyWZMHAMv4hiyV
	 UnH+Z2tz0wskKOFjwy0J+sIib+mepnfcHg6Vi4ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sherry Sun <sherry.sun@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 359/423] tty: serial: lpuart: only disable CTS instead of overwriting the whole UARTMODIR register
Date: Tue,  8 Apr 2025 12:51:25 +0200
Message-ID: <20250408104854.218824166@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c2b522843b72c..951c3cdac3b94 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2330,15 +2330,19 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
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
@@ -2346,8 +2350,6 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	lpuart32_write(port, bd, UARTBAUD);
 	lpuart32_serial_setbrg(sport, baud);
-	/* disable CTS before enabling UARTCTRL_TE to avoid pending idle preamble */
-	lpuart32_write(port, modem & ~UARTMODIR_TXCTSE, UARTMODIR);
 	/* restore control register */
 	lpuart32_write(port, ctrl, UARTCTRL);
 	/* re-enable the CTS if needed */
-- 
2.39.5



