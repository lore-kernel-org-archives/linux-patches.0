Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AE019D8BC;
	Sat, 12 Sep 2026 09:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206955; cv=none; b=GIBD+K9CInXAwx63WsTz9vMU7CkVmtWhR3PI0VqM3nBjU+UOGQa8kV//moJmK2SgMoAS/h9zRffQhJpt9RD6T2NyLJsjfgip2zIVGnPZ/64byqh3tlNnaMFNv3hUqSz1xzWjeKA68gkNrZSFutLbKKX/I2jlPny4kWrnwpdgoeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206955; c=relaxed/simple;
	bh=eN8DbuvhYhBAh9nQ2yLinz2KypT/H40I6rzXzPE+CW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilQkIf0ssklDFtfMlUofKxJJetvlLDShS/HY1Q4MDYhHfOEssSvaNeVzKGRT7qCISI178dYNB4/OXL1cSgZO4QJfG7nl596O+/Yfi9lfReVKGdXfxolN9x1fWnwlJkovCVAQKRN16hvTOpzd/wswXDSDlE9cA45k9kGBUOkMrs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEc443N2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEc443N2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5CD1F0089A;
	Sat, 12 Sep 2026 09:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206954;
	bh=hTrtslW0/dzMscmhkQBPZjIFJk4GDi7QNNbDjst56js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jEc443N2XCR+zEBohaGeuegS+TYF6roPgKoELp8qhTYkSTN7JX6pj1kLwnGQ0LxI/
	 UUrOlySo/MUwG1NwUNSQyRYByRPKyqhU19LEMxFHjW5Ad+lXpXsV7id2wPM2N+vOhD
	 KypHTTJ+h6QCNOfb+7X/VzbGjX4Abe/iHFFJm9y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fushuai Wang <wangfushuai@baidu.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0312/1518] serial: 8250: Clear CON_PRINTBUFFER on port re-registration
Date: Sat, 12 Sep 2026 08:41:21 +0200
Message-ID: <20260912065630.538066740@linuxfoundation.org>
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
index ccd5a18f53356..b6568880f750d 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -716,8 +716,12 @@ int serial8250_register_8250_port(const struct uart_8250_port *up)
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



