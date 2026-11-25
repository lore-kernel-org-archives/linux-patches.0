Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626107;
	b=2pjgseq48DNDsJjnPzlAUIcUovHN5F7J8eZwIyY7as6l+QrYBmi9GXRiDTq7e5A9lN7i
	 /6DiS5Zw24GZn/SmUU2Jf4KZdMFs+gB42F+UXsPD8uBJN5k51zsNTK2b6jJpohWZo7C6S
	 exar0WK7xLAoJyoSnbOgZuX4I52O16+dqGXfWs+qRQWEryiN3BpVFe6vS+OuyUJOMOCeq
	 PogMLlGEHcXZECsthCfF1iEWlIJPLedtxq9CBFmm0H/hEZbcBeCCawms5J75qQ41CTiCw
	 QqYV297MsB/X2cenMpU9l2DeR+blftCWv40CPhzyl7JdoqCDODKDL5c5tCjmJO/5iew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AWLWb+TsyqcM17j2W9W7Gd6d2y/3Kbj5IS0hWRUH/+0=;
	b=V2z9x3gLigel6vcLRxq2e05dLiZFCgqV/Ip12sb2SIOjVFoO7h7c3v1UOqcLbJps74P1
	 9eOtKil7VHbgvG26X+iUXtV+TYJMCvtNa++7twxH8oZLlhpd6I/paT4K9NDtMKaz8BFVA
	 iJlkJYh9nlM2JioYSRxvV1ThF4L/1m9SrNU3FX1haPnaPPFLab20fLX7HVylM6m+dXEA+
	 wfZ4KYyLCzFa2RRiCgl77nbaj6Pq6bLVxMvoM2AfM7mz3qNSH5ejBEdF/qtdka31KMskI
	 Bf/z1gksp3HVjyw2z83Fun9zcU17ALUOVGa59940xIJZ62Qjc6oXxpMKY/W/MMC5A8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BeiZsRa7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6AD606A31E;
	Wed, 25 Nov 2026 17:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BeiZsRa7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822D41F000C0;
	Wed, 25 Nov 2026 17:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626107;
	bh=AWLWb+TsyqcM17j2W9W7Gd6d2y/3Kbj5IS0hWRUH/+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BeiZsRa7znVcLfEuiQcjzpV8MgxQatsvWwixnKN1XBeMQlGVR1rWsfxdN3RydjumS
	 ORSU3DrRszUEXfMw9xJ1JiwVcWBkt9o7j8sPLvUyJhaJ/QtLfq7oMoz/aOscmZUmyM
	 wb0YtNlEbFLDLmAOzR8zaTL0gMWNnAlFuuTYdUuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
	Olof Johansson <olof@lixom.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 6.12 733/816] serial: rda: free the interrupt on shutdown
Date: Wed, 25 Nov 2026 15:38:01 +0100
Message-ID: <20261125143906.146895697@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 859f7c56709b161a72b629b6f2f1384dcd374404 upstream.

rda_uart_startup() requests the interrupt, and nothing ever frees it.
It is not shared, so once the port has been closed, the next startup
fails with -EBUSY and the port cannot be opened any more.

Free it in rda_uart_shutdown().

Fixes: c10b13325ced ("tty: serial: Add RDA8810PL UART driver")
Cc: stable <stable@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Andreas Färber" <afaerber@suse.de>
Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20261027-tty-llm-v1-20-99b0202ae546@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/rda-uart.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/serial/rda-uart.c
+++ b/drivers/tty/serial/rda-uart.c
@@ -471,6 +471,8 @@ static void rda_uart_shutdown(struct uar
 	rda_uart_write(port, val, RDA_UART_CTRL);
 
 	uart_port_unlock_irqrestore(port, flags);
+
+	free_irq(port->irq, port);
 }
 
 static const char *rda_uart_type(struct uart_port *port)


