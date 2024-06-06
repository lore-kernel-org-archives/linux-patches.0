Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AE71A0DCF;
	Thu,  6 Jun 2024 14:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683166; cv=none; b=MaUDlJQs0gMwlKcAN/b9kRcVTbD4pqUGV0nMdoSNRgaoXNM9o3NVYMIytnSo/ghQsvNwRtrTgb+8f3+h4YmdBv301nnrGgu+3Hh1pExvkwd1SxVqBp+kC7ORy6coQAxNi9TJwam7Eh5NRGGJvEP58YrvDLFbyrSJ/GLEqRdnvpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683166; c=relaxed/simple;
	bh=pP5ondk5fPXQ7Sfx7dWAdice/3lP7HAVlfUyvkpSpPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1jQU/R2AHFR/UlvapQ6I2bOrI2zGUEc6arAjIrZvNIRN1A/40plQ2Xgx93SqyHXCg0gt2tnrxg3tn3LywnHgsfGyS8Nr3RTcLrOiJMXlNsXXshKX+Lo9oNYxwfdr2BWh904KCAQrti9rNAR+IgFU3SRnPvutTYxSjQw2hYd2dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LqfV011g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LqfV011g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE9FC2BD10;
	Thu,  6 Jun 2024 14:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683166;
	bh=pP5ondk5fPXQ7Sfx7dWAdice/3lP7HAVlfUyvkpSpPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LqfV011gK+kL8nmIgG81Hfq/SgTZu41+HT/qei31gy7GaTRxL6OQ2Mnlm1otxVIfs
	 xhtwQ4goK03yVJGxM/GQV5/w/l69mzSeLo8Odx5FJibJjkU4jEF8oBIHCvTCBW3eu/
	 iORG0BjzkEEAPie1Gnd6vAFu+utQyqpo9RJ1ji7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pin-yen Lin <treapking@chromium.org>
Subject: [PATCH 6.1 007/473] serial: 8520_mtk: Set RTS on shutdown for Rx in-band wakeup
Date: Thu,  6 Jun 2024 15:58:56 +0200
Message-ID: <20240606131700.057132691@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pin-yen Lin <treapking@chromium.org>

commit 4244f830a56058ee0670d80e7ac9fd7c982eb480 upstream.

When Rx in-band wakeup is enabled, set RTS to true in mtk8250_shutdown()
so the connected device can still send message and trigger IRQ when the
system is suspended.

Fixes: 18c9d4a3c249 ("serial: When UART is suspended, set RTS to false")
Cc: stable <stable@kernel.org>
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Link: https://lore.kernel.org/r/20240424130619.2924456-1-treapking@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mtk.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -209,15 +209,19 @@ static int mtk8250_startup(struct uart_p
 
 static void mtk8250_shutdown(struct uart_port *port)
 {
-#ifdef CONFIG_SERIAL_8250_DMA
 	struct uart_8250_port *up = up_to_u8250p(port);
 	struct mtk8250_data *data = port->private_data;
+	int irq = data->rx_wakeup_irq;
 
+#ifdef CONFIG_SERIAL_8250_DMA
 	if (up->dma)
 		data->rx_status = DMA_RX_SHUTDOWN;
 #endif
 
-	return serial8250_do_shutdown(port);
+	serial8250_do_shutdown(port);
+
+	if (irq >= 0)
+		serial8250_do_set_mctrl(&up->port, TIOCM_RTS);
 }
 
 static void mtk8250_disable_intrs(struct uart_8250_port *up, int mask)


