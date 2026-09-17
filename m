Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C00C4E36DB;
	Thu, 17 Sep 2026 17:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667566; cv=none; b=km40vbIuPZCXEWuNerH9jTBho60yST8Egg1WGP3BQomT886FgNtTwaH/lk77i7wfoCiJagQs1P0w9Ug2/pLyIfXwEyn7IZASsydM5fopT/QrgB7Zz/GJte2l+HcErEd0VCpxV5SaxwxOa1luagP0Avu/XuSwQYKydWyCUcqUN7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667566; c=relaxed/simple;
	bh=/kx3RaGxpsy4yWJy9eWbtXz9In7ke2ID6ZVyErdngZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UD4M3AGI9aygpuAWBPvN3KrxaH+4MPyJGLrSV1vYDb6xUT7M5OkBk1J9GR+nZjkqmWe/64ntVRp6T0tdH5LgkBKF3ipKDY/boPomI9/WJl760aY3dBjwNU/Mx5VAXR/EZE5HVHtWLb0VlsNNX6osJDy4+fUlvcD1kdV7P0xMMWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfwOnUj0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfwOnUj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6131F000FF;
	Thu, 17 Sep 2026 17:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667565;
	bh=7CMuHPkSSbgymybMbxz1n2veTr/60VRzwH4ggxlTxfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JfwOnUj0rT1kw7suywkh4LecFIZ8+gNGLwqGbR6F5CWxVax1PI5It1bsCg3CIPYj3
	 XAddm9BwM1Y8JiYIxpkngKiq2DHDpJPDUc+DyL2UP5nd1A5lVaDmlXehhSXHWqOzz1
	 xCjmew98P5Oby3NiCaSHMb2VZROszAoGw/QoN1iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0136/1102] serial: 8250: fix possible ISR soft lockup
Date: Thu, 17 Sep 2026 16:01:19 +0100
Message-ID: <20260917151542.936612227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 0c6bf45e5a345cc3b9ffbeaf9083ecac3c2293eb ]

There are rare cases in which the host gets stuck in the ISR because it
is flooded with messages during the startup phase.

The reason for the soft lockup in the ISR is the missing FIFO error IRQ
(FIFOE) handling. Not handling it and reporting IRQ_HANDLED triggers
the IRQ immediately again.

Fix this by adding a check for the FIFOE status and clearing the FIFO
if no data is ready (DR).

This behavior was observed on an AM62L device which uses the OMAP 8250
driver. Fix it for all 8250 drivers, since the OMAP driver's special
IRQ setup handling may trigger this behavior more frequently, but it
is not ensured that other 8250 drivers aren't affected.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Link: https://patch.msgid.link/20260519-v7-1-topic-serial-8250-v1-1-56b04293a246@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index b4c8388ea6fc3..0d9ff0d5b73a1 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1901,6 +1901,13 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 
 	status = serial_lsr_in(up);
 
+	/*
+	 * Recover from no-data-ready and FIFO error condition to avoid getting
+	 * stuck in the ISR.
+	 */
+	if (!(status & UART_LSR_DR) && (status & UART_LSR_FIFOE))
+		serial8250_clear_and_reinit_fifos(up);
+
 	/*
 	 * If port is stopped and there are no error conditions in the
 	 * FIFO, then don't drain the FIFO, as this may lead to TTY buffer
-- 
2.53.0



