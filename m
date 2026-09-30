Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF54351C06C;
	Wed, 30 Sep 2026 17:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790751; cv=none; b=RdivT8NdvTe/VUXlOQF6c7pXiqb4TX9CtdCwG10CnvaiyPJVoNJFpH3xEHjpdGBDQ5ACo6hs554kp1M7aSyLTdx4V6rvAMEJ4Np/YE+QBA/jXKuVZIQKJ2Br5z+LlQf1/mK2HZO3k6Yw5bTFjkmSddHqsP7aHOrJoMDRXiEsRyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790751; c=relaxed/simple;
	bh=PLhTzjBzFBZO7aa+XpO/S49WBWDU2DlbyfbwFvhA9tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4pL3OmDBjWee6VsOl1/6qydkUzqQmvAHgEj/LaLRIUxGoRU3qKavowwwxNJP253uZyIuJHVPpO/tkyZdZA3spQZptwrEbBH3Serxj2FKaHsliQyA36tF+nVH0+3qUSvdR1rdo/Ssk8duOXIefnIusSywx8fnbaH1ex2wOJSqAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5jiTS7r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5jiTS7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249E51F000FF;
	Wed, 30 Sep 2026 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790750;
	bh=KVPJpjwQiHYEyCTcsIQhzwbpK9NXJwtL9Ua+IpkJ3Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5jiTS7rnzdU9treV61SLV1UkPw4FJKroDP3vR8oEpcVFhxbBLZtmIHTJ8P4DUyPD
	 kw7aOJqExbsVW7hBOIgWeKqnE/5L4wTncabqMRNDAD0w+hzCVh9626dNGi/70CnmKE
	 oy7ZVlTJCPX9HnXWQoHNkF3Mt6LqB2DZ1ZaP6QWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/752] serial: 8250: fix possible ISR soft lockup
Date: Wed, 30 Sep 2026 17:18:50 +0200
Message-ID: <20260930152359.457913945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3e9b42c2860bc..8e1005b3df531 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1896,6 +1896,13 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 
 	status = serial_port_in(port, UART_LSR);
 
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



