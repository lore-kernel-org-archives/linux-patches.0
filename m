Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9754A267F57;
	Tue,  8 Apr 2025 11:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113022; cv=none; b=WBMtjzLg/lNtIGTB0/6SeKwWwKDG4aHuykbVFfbY3IWZI1kt40b+9GQDQwbBdP+R8y9CRHpjdPO6YGH24yHjfw4kgeUoLfYRwur5fL5vPPE24XilND8RWK9IdTlUvBngftgM0ZwktD1KgiwJXmRhDU/jcPNe/sCp/yMsKHh8Xbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113022; c=relaxed/simple;
	bh=thP7a4N6uV0lVke1MdTfAoWYfdr80TWg8O0iAWdsvbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2yUW3rubXw0Q5KEx7NKogdiBRxp2K/AfoY1YtEz8LXjKkCQGUOE9xo5jYTYjvrJW6tnl2MentlmmqVHC9i2aA1nOggXchdLHggL3JKrbdSQl3gy9EoMt18syA/GIGW+fbEkf/ED7deyUInVCQYGTyISBnOfh3Asvh2bBFXdv4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZzXnC4h8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZzXnC4h8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28233C4CEE5;
	Tue,  8 Apr 2025 11:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113022;
	bh=thP7a4N6uV0lVke1MdTfAoWYfdr80TWg8O0iAWdsvbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZzXnC4h8fZaaijKBAxj4zpMVTokrN49KmyHzHULzo6kpHYnyLHqHpKN/NBtZ7RkQ2
	 M45qL2lK8mijFWnA9N/F0HIE9eIjivtgaibGXVA3tk2ig4eef1D3R0q2gkdqvWScfR
	 tsOzLWZFlsmks93f6b4lBgvNdxpijf3B7FVESOok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sherry Sun <sherry.sun@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 256/279] tty: serial: fsl_lpuart: disable transmitter before changing RS485 related registers
Date: Tue,  8 Apr 2025 12:50:39 +0200
Message-ID: <20250408104833.291427081@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit f5cb528d6441eb860250a2f085773aac4f44085e ]

According to the LPUART reference manual, TXRTSE and TXRTSPOL of MODIR
register only can be changed when the transmitter is disabled.
So disable the transmitter before changing RS485 related registers and
re-enable it after the change is done.

Fixes: 67b01837861c ("tty: serial: lpuart: Add RS485 support for 32-bit uart flavour")
Cc: stable <stable@kernel.org>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250312022503.1342990-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index fe1fba335483f..6684f6512fb16 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1397,6 +1397,19 @@ static int lpuart32_config_rs485(struct uart_port *port,
 
 	unsigned long modem = lpuart32_read(&sport->port, UARTMODIR)
 				& ~(UARTMODIR_TXRTSPOL | UARTMODIR_TXRTSE);
+	u32 ctrl;
+
+	/* TXRTSE and TXRTSPOL only can be changed when transmitter is disabled. */
+	ctrl = lpuart32_read(&sport->port, UARTCTRL);
+	if (ctrl & UARTCTRL_TE) {
+		/* wait for the transmit engine to complete */
+		lpuart32_wait_bit_set(&sport->port, UARTSTAT, UARTSTAT_TC);
+		lpuart32_write(&sport->port, ctrl & ~UARTCTRL_TE, UARTCTRL);
+
+		while (lpuart32_read(&sport->port, UARTCTRL) & UARTCTRL_TE)
+			cpu_relax();
+	}
+
 	lpuart32_write(&sport->port, modem, UARTMODIR);
 
 	/* clear unsupported configurations */
@@ -1437,6 +1450,10 @@ static int lpuart32_config_rs485(struct uart_port *port,
 	sport->port.rs485 = *rs485;
 
 	lpuart32_write(&sport->port, modem, UARTMODIR);
+
+	if (ctrl & UARTCTRL_TE)
+		lpuart32_write(&sport->port, ctrl, UARTCTRL);
+
 	return 0;
 }
 
-- 
2.39.5



