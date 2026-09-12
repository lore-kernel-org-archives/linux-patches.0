Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007504BEE54;
	Sat, 12 Sep 2026 07:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198171; cv=none; b=JaYQx4L6Loqa38tAgwRI+tiJVj2wZi5uoE0fG8QXFZ0ijJNNYlMTsajvKVdBkbvhYSuFVqOEwyJvswgucdU++KdDEhZ4kj9/Hk7VdgOOY5MaaeWhaACYyOLWDX6l9MV3V0HtHAr6H5NWInVIUNuv3iPxXJ2bPsJI7QvrBcHoouU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198171; c=relaxed/simple;
	bh=xMh7FI3pNMoJF6cbEQXTkLaWKIsFTBQ60rxAs9BdYBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbibDsyq3NWPgz/j856mwU6rManzlFnB4ZInWTCvB1bUf1KOq8T1V/4UWAX4VjiU2IO58TKMG0kcjqOS/7lbUpfsehWOxcEhnm3xuiPRYyS9Vc8fmNm0EsaaxsMW719H+DZjsKKSlQTOgaKK7jHyzyBpXiRkuCFyl+IKpYxgvXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQ+1Nsp/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQ+1Nsp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0F81F00893;
	Sat, 12 Sep 2026 07:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198163;
	bh=wBn6/WvI2eg9WZPXAi83Gqbp5JxJ/HlV98eWm/TnDPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQ+1Nsp/9/Own7NbOJ5ltit1eCX0DVVMdquUobuJUIqqPxxhLUi3Z4AYB9Pn8RCKA
	 RZMEgMuC2DBAg0L0o3qCwJTAU/9UD96ZHuvDu7Nm4r+NUhypZ5Sa5C00NwalVXucug
	 3z7yXHRtsf2u+IAPtgRSLSm5Zn6Mm2i+hb8LmfnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fushuai Wang <wangfushuai@baidu.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0317/1815] serial: 8250: Clear CON_PRINTBUFFER on port re-registration
Date: Sat, 12 Sep 2026 08:34:27 +0200
Message-ID: <20260912065656.380445832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fushuai Wang <wangfushuai@baidu.com>

[ Upstream commit d338ab1d90603f875c4f7ed223406535378173a5 ]

When two PnP devices map to the same physical port, the serial8250 driver
removes and re-registers the console structure for the same port.

During re-registration, the console structure still has CON_PRINTBUFFER set
from the initial registration, which causes console_init_seq() to set
console->seq to syslog_seq. This results in re-printing the entire
system log buffer, which may lead to RCU stall on slow serial consoles.

Clear CON_PRINTBUFFER when re-registering a port to prevent duplicate
log printing.

Fixes: 835d844d1a28 ("8250_pnp: do pnp probe before legacy probe")
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
Link: https://patch.msgid.link/20260522101042.21976-1-fushuai.wang@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index f49862d90eebb..c0e8a4efbdcc8 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -720,8 +720,12 @@ int serial8250_register_8250_port(const struct uart_8250_port *up)
 	/* Preserve specified console flow control. */
 	cons_flow = uart_cons_flow_enabled(&uart->port);
 
-	if (uart->port.dev)
+	if (uart->port.dev) {
+		if (uart_console(&uart->port))
+			uart->port.cons->flags &= ~CON_PRINTBUFFER;
+
 		uart_remove_one_port(&serial8250_reg, &uart->port);
+	}
 
 	uart->port.ctrl_id	= up->port.ctrl_id;
 	uart->port.port_id	= up->port.port_id;
-- 
2.53.0



