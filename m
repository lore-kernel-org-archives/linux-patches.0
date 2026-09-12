Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05C13932D3;
	Sat, 12 Sep 2026 09:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206936; cv=none; b=PMsiENTnsPfVrW/Yf8GNvu191YxxsDfiso6J7Nh+baNzNpCjT6/KtYiCabqWiI02LEzCgfuWsxOqVGwuE7RoRUU+VKbT7dgxeufVUVdZEIWj+KP3ZW76ZiuxLjJys7nA2lDheSdv0twO2UiwVXnUWI61xMscsZeBeVmochbVNCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206936; c=relaxed/simple;
	bh=dpLKCZ6AD4v+hm3Q8sBxrLlgQxvsHwEYTOR+XYUmRCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjuuWr6OP27QK67Dc3p5/ZJRxWNEW7P8VRRyK0oONPqsnPIlvILfbso9O0LPcOtwbklvHnu4U5TidvRSjQwx82/QuBuxSsJ4JnEFed5IbnJVsZTo4n7BAwQoSzy3orot0H6X7k7DPDTkKbooxJQH/KCI4BWnqQo/I1bFWnYkRew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7r03cqx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7r03cqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B449E1F000FF;
	Sat, 12 Sep 2026 09:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206934;
	bh=fwjfzRtCLLNNGIZRnJHUw0CqKwOVRKfpnb5dseuGV1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7r03cqxqjqX5t/xi3cyWykOkzSJCBMr7j+84EcWGD7Fn7dha7J7QbxAi2xZx0i2y
	 g9DJhZy3abiqgCpawmhF8SBjudGmA6kWstQDMVboFBn9rcCf+4w91IA7ymDZ3me9nk
	 Ynrbga+3JQl42yizyIOdtKq9W7R8BDyE7uB6WLKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0308/1518] serial: core: Add dedicated uart_port field for console flow
Date: Sat, 12 Sep 2026 08:41:17 +0200
Message-ID: <20260912065630.448544478@linuxfoundation.org>
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

[ Upstream commit 9c7eb1c9c3e3bfecb556fc8fa1b68939385444de ]

Currently the UPF_CONS_FLOW bit in the uart_port.flags field is used
by serial console drivers to identify if a user has configured flow
control on the console. Usually this policy is setup during early
boot, but can be changed at runtime.

The bits in uart_port.flags are either hardware and driver
properties that are initialized before usage or are properties that
can be changed via the tty layer.

The UPF_CONS_FLOW bit is an exception because it is a console-only
policy that can change at runtime and its setting and usage have
nothing to do with the tty layer. This actually causes a problem
for its usage because uart_port.flags is synchronized by a related
tty_port.mutex, but a console has no relation to a tty (other than
sharing the port).

This is probably why console flow control is not properly available
for most serial drivers. And it is hindering being able to provide a
proper implementation. Commit d01f4d181c92 ("serial: core: Privatize
tty->hw_stopped") addressed a similar issue to deal with software
assisted CTS flow state tracking.

Add a new uart_port boolean field "cons_flow" to store the user
configuration for console flow control. Add getter/setter wrappers
to allow for adding more policies later and/or locking constraint
validation.

Mark UPF_CONS_FLOW as deprecated.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
Link: https://patch.msgid.link/20260506121606.5805-2-john.ogness@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: d338ab1d9060 ("serial: 8250: Clear CON_PRINTBUFFER on port re-registration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/serial_core.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 110ad4e2aef99..d1404c97dc524 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -533,6 +533,7 @@ struct uart_port {
 #define UPF_HARD_FLOW		((__force upf_t) (UPF_AUTO_CTS | UPF_AUTO_RTS))
 /* Port has hardware-assisted s/w flow control */
 #define UPF_SOFT_FLOW		((__force upf_t) BIT_ULL(22))
+/* Deprecated: use uart_set_cons_flow_enabled()/uart_cons_flow_enabled() instead. */
 #define UPF_CONS_FLOW		((__force upf_t) BIT_ULL(23))
 #define UPF_SHARE_IRQ		((__force upf_t) BIT_ULL(24))
 #define UPF_EXAR_EFR		((__force upf_t) BIT_ULL(25))
@@ -567,6 +568,7 @@ struct uart_port {
 #define UPSTAT_SYNC_FIFO	((__force upstat_t) (1 << 5))
 
 	bool			hw_stopped;		/* sw-assisted CTS flow state */
+	bool			cons_flow;		/* user specified console flow control */
 	unsigned int		mctrl;			/* current modem ctrl settings */
 	unsigned int		frame_time;		/* frame timing in ns */
 	unsigned int		type;			/* port type */
@@ -1163,6 +1165,16 @@ static inline bool uart_softcts_mode(struct uart_port *uport)
 	return ((uport->status & mask) == UPSTAT_CTS_ENABLE);
 }
 
+static inline void uart_set_cons_flow_enabled(struct uart_port *uport, bool enabled)
+{
+	uport->cons_flow = enabled;
+}
+
+static inline bool uart_cons_flow_enabled(const struct uart_port *uport)
+{
+	return uport->cons_flow;
+}
+
 /*
  * The following are helper functions for the low level drivers.
  */
-- 
2.53.0



