Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1394DD3D1;
	Wed, 30 Sep 2026 16:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784228; cv=none; b=d8JCLxZTCwl7jTQdBCX/kZxtuTU68vbrGt2d2WZ0NjtY6r2Ux6ASysmkW2e9NIA288BYJiz2kIUPzAIm/cwZqBl34qa+xNCrZjmFTrO/F9WQcMz79I8FRhmRDj+6OhejPxzlW1pr+A24LJWNC0tZ9znpCGgnzjdMoSz9oLYgjEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784228; c=relaxed/simple;
	bh=55Nt86UESOWSDTt6mhr3LKYIeHAChHO+yxABXYlL05A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQx5FrytAwv0euIZEngXzCl8Yc35jAKsConh+yh1p/+jvRzVzvTdUZpQ2jyBPJ9pwSO8w/OZeCeeTBNEupiPA7WyW/XHPOI2JYhUUTZnVHAnZshbD5g0+F4sGK+uFTS+/pfQuSqzBo8UfQ7J2mIatn9bQuZkFZgwEXpPPs2aqRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeNQ7VFI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeNQ7VFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32621F00893;
	Wed, 30 Sep 2026 16:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784224;
	bh=HGKBDc5YwMpc66Vidt4qgELuaV9lFegUedlgf0FNMjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeNQ7VFIvNMZZ37GI0kX+/28k8+1BGNgfN+DGcG04YsfS7qKCPJuwSXxm295I/cU/
	 xOUUNOFf4ItWtqKcAQbiuUZCBoOat8itsk6yKKnHbkHqxW3r04uCZbuo/wYXfCNNLl
	 LFPbdG7D2lVh3UT/4nsh0Fkd52h6pWhf4dMc+xeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/982] serial: 8250: fix possible ISR soft lockup
Date: Wed, 30 Sep 2026 17:13:37 +0200
Message-ID: <20260930152418.551142563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a1fce56100254..fbb65cb6a0cc9 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1933,6 +1933,13 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 
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



