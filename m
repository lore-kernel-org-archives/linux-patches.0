Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BB02690FA;
	Tue,  8 Apr 2025 11:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110215; cv=none; b=q0dt5G4TPH3o87sqr5UahyR+giTz+SFnAWNLG5D4HGtbfcF3P9R59J/jOOgMiEyts1yN/06SEqvnkGdyFx+VzvgZ048v4HvB/r54tHHFIon+ShFHEH53LoowXxAGxeb1VPFXvq+BetJa0BIsiUtFQIfWoP4DF9uXB31m7mzpz3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110215; c=relaxed/simple;
	bh=QhMrO+7VY63DlftVMUJiWx7uMnUsdLCOxhOB0DYb704=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kpxb5AAt8i42q9lxghb9/GBKcO2DPheVAz+/LcQ+/G8Nuvy7HzWPYKsQN5cjU2vtJ69GzZnmtc/gsKLYUUNQw6L9a+9ILLBi8gvB12cpAdDnswgXTCCjt15qeBmvpN3nWtyPKqTlmR2TCsKItBRj4v7Ip4sXTHkQ4OkGRHUmNfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9kXWdlF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9kXWdlF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CC4C4CEE5;
	Tue,  8 Apr 2025 11:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110215;
	bh=QhMrO+7VY63DlftVMUJiWx7uMnUsdLCOxhOB0DYb704=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9kXWdlFP7AISeOfQOZLSuFtZk9wNI78mgvCEZQTdBo95l9RfNGD+eQ93klCmipzM
	 1O0eJIVSz0CePsdyDG34ArCeg6qOysY7ktlGQwB3HhvXfejTWXYMOvtWLGiyBId2Ue
	 tRrbrXtIc61nbx0D77pFV1H3YndPKCaIo68kwoGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sherry Sun <sherry.sun@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 208/227] tty: serial: fsl_lpuart: disable transmitter before changing RS485 related registers
Date: Tue,  8 Apr 2025 12:49:46 +0200
Message-ID: <20250408104826.553691778@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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
index 5135cdc0b6644..110d98fed7260 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1352,6 +1352,19 @@ static int lpuart32_config_rs485(struct uart_port *port,
 
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
@@ -1392,6 +1405,10 @@ static int lpuart32_config_rs485(struct uart_port *port,
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



