Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C518D12CDA5;
	Sun,  7 Jun 2026 10:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829815; cv=none; b=Oqw5Aw+d/lGEM0ykmNlSxEkEL7zJ5XE+SL/iIuDNNffvFtDR8BoyD91VcJJ5FvJTlyfO9MXSDdmSTWlwvYJc1pJnOdtnv15P7OhMbiM2s8QL7YLpn8YWSLraHuxEOlQfAHYqs8NaHL/9K8ZmrYQgSFX4t5VuY0g20crhPXTtYcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829815; c=relaxed/simple;
	bh=USR1GX/iTwimqhGLrdvXZsIGU0IGQBW0jj1gPXYpNZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uv6Nc1w/urv/derZ7rUEInVk2377HgUQPi+iFHCKMeQuySDjwsSy2ZZA+fumTus7xIDgoEmpXP2ui8Q8vFgsTQ240W3rJt43Mri/kT2GzTvMD0/JDYAoJLg6r+g/ctpDIzoo5VIZWvyuMc8JJwIewySkSHvdlMD44AFd+9CBWJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwqtEPEV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwqtEPEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15491F00893;
	Sun,  7 Jun 2026 10:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829814;
	bh=nF52bDA+Vo84wxrabO2Wc8tnNemC579h98qNHl+Ul+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qwqtEPEVn0xyrNySPtd4V52D4yeKFNVGfne9ZPRThMxsjlOvJNu/uqjPLLL521BD4
	 4OaL0yKLebQrQ8lqd0O2m3K7sBnSQWWdjug2I1pLDvCXWgBKKlmZrKqUzgzz2jCTux
	 2KoY5XkrkqhZNtMqgbobc5WSip5piRNWxaoMpQS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacques Nilo <jnilo@free.fr>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.0 315/332] serial: core: introduce guard(uart_port_lock_check_sysrq_irqsave)
Date: Sun,  7 Jun 2026 12:01:24 +0200
Message-ID: <20260607095739.688716201@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacques Nilo <jnilo@free.fr>

commit c3cce2e67bb22a223f5b8ef05db0fcde70994068 upstream.

uart_handle_break() and uart_prepare_sysrq_char() (in
include/linux/serial_core.h) capture a SysRq character into
port->sysrq_ch while the port lock is held and rely on the unlock
helper -- uart_unlock_and_check_sysrq_irqrestore() -- to dispatch the
captured character to handle_sysrq() on scope exit.

The existing guard(uart_port_lock_irqsave) cannot be used by IRQ
handlers that process RX, because its destructor calls plain
uart_port_unlock_irqrestore() and silently drops port->sysrq_ch.

Add a dedicated guard(uart_port_lock_check_sysrq_irqsave) variant
whose destructor is the sysrq-aware unlock helper. The lock side is
identical to uart_port_lock_irqsave -- only the unlock-time behaviour
differs. Callers that may capture SysRq characters must use
guard(uart_port_lock_check_sysrq_irqsave); the existing
guard(uart_port_lock_irqsave) keeps its current plain-unlock semantics
for the many callers that do not process RX.

The new macro is placed after the CONFIG_MAGIC_SYSRQ_SERIAL block so
both definitions of uart_unlock_and_check_sysrq_irqrestore() (sysrq
enabled and disabled) are visible at expansion time. When
CONFIG_MAGIC_SYSRQ_SERIAL=n the destructor degenerates to plain
uart_port_unlock_irqrestore(), so there is no overhead.

No functional change on its own; users are converted in the following
patches.

Cc: stable@vger.kernel.org
Signed-off-by: Jacques Nilo <jnilo@free.fr>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/3849af4bc55d5d2a424fa850844e94d641b2f8a6.1778675349.git.jnilo@free.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/serial_core.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -1275,6 +1275,18 @@ static inline void uart_unlock_and_check
 #endif	/* CONFIG_MAGIC_SYSRQ_SERIAL */
 
 /*
+ * Variant of guard(uart_port_lock_irqsave) for IRQ handlers that may capture
+ * a SysRq character via uart_prepare_sysrq_char(). The destructor uses the
+ * sysrq-aware unlock helper so that a captured port->sysrq_ch is dispatched
+ * to handle_sysrq() on scope exit. The plain guard variant silently drops
+ * sysrq_ch and must not be used by callers that process RX.
+ */
+DEFINE_LOCK_GUARD_1(uart_port_lock_check_sysrq_irqsave, struct uart_port,
+                    uart_port_lock_irqsave(_T->lock, &_T->flags),
+                    uart_unlock_and_check_sysrq_irqrestore(_T->lock, _T->flags),
+                    unsigned long flags);
+
+/*
  * We do the SysRQ and SAK checking like this...
  */
 static inline int uart_handle_break(struct uart_port *port)


