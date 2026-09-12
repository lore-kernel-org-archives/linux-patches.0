Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB45919D8BC;
	Sat, 12 Sep 2026 09:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206945; cv=none; b=YncBYwPBkF4+X+kW9cMleAP98F+qfCf2LlAp1tHc63XzJ9SgFfqwI5GVBuJ+d1a0CHqs7Z9qG2P6yvLhlzOTklW2ZNsdqDSpcqQQIR4V1pKwWl/glphaybb4Xg1+7Q4HdOoQv10g+EqUmfIBo8xBBK6PCtVvgG5WMpbzcb2MH4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206945; c=relaxed/simple;
	bh=PmsU1u6EOoSU3x/zAiClpj4oGE3rzpfMiwb1j8tdH+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ld8zR0nwyHj0qV/2sEYxXJOXov346xJq0s5SNx/eawOxuJfRFS1EEgTJHE/BlvK6CDMKddISlqnBUO24M0kHyZusk0WuBl204Ux0/BjpY6k4oX1v4hBaScYclccOA3ax563V6juzX+hx11a94i60mnOHEp4BpZz2jnML9eAnEPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzNR5G6L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzNR5G6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8904C1F000FF;
	Sat, 12 Sep 2026 09:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206944;
	bh=0WZOwkqFTB1C9DhDkN7SPxYb5JIUZuL0N730CZ6Ozhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzNR5G6LR3s/IP2FA7HAVuHoQfqmzZtyc5tvPuY5O6jnpDACpzat0e0eolp+umjRB
	 zH3yqgz+K9IrpF7RvDOKxJcLLwkevtCFxzCKPjo/N4EtnVmStuil+SNIb8FOSj3+/P
	 ACZHeKm7M5cSkhwWDUZHhskirPeQKO3/tPRZeV44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0310/1518] serial: 8250: Set cons_flow on port registration
Date: Sat, 12 Sep 2026 08:41:19 +0200
Message-ID: <20260912065630.493697722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit f69ec492244d54068f08c20f90979274d8ac3655 ]

Since console flow control policy is no longer part of uart_port.flags,
explicitly set the policy for the port.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
Link: https://patch.msgid.link/20260511152706.151498-2-john.ogness@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: d338ab1d9060 ("serial: 8250: Clear CON_PRINTBUFFER on port re-registration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index bfa421ab32536..d8baeee9cca52 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -742,6 +742,8 @@ int serial8250_register_8250_port(const struct uart_8250_port *up)
 	uart->lsr_save_mask	= up->lsr_save_mask;
 	uart->dma		= up->dma;
 
+	uart_set_cons_flow_enabled(&uart->port, uart_cons_flow_enabled(&up->port));
+
 	/* Take tx_loadsz from fifosize if it wasn't set separately */
 	if (uart->port.fifosize && !uart->tx_loadsz)
 		uart->tx_loadsz = uart->port.fifosize;
-- 
2.53.0



