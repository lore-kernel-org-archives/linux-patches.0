Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2E01C5799;
	Sat, 12 Sep 2026 18:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239477; cv=none; b=WiYWfrUnNUTSaehkeQDO7Ov+wusTsxciObxqjZ4pPt8FENZQEbB2ufpwbFPyTl8k90Lbu8J+BtA+no7vmfLk1hFUYJE0t/HOryez+g978YTAL5410UZZfIAeIrZ/RZVfXbDpRjUXJ8quIL6zac5Z40g0Dmdsmdn4Zu7+Xd9P9Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239477; c=relaxed/simple;
	bh=MWFaRQouReKisMOzQGP4DLLhDlMt5562Ys2rKvvG+Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3pdYzA1lXUVSk6wesi52ff0fpI91syo8/SXwOpFd4gWXOjnNyA5xl+OhpGI9pl0D8ju/+opBbPmc1miP8iC8G2CMIvWKNQlwTCHv46OE9sfyPOsloCjoMhicc+7NAe0AJBCkKzIjRDRiSdQmXvRQLhDiVjCjhpR77f4w9tHGZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjRKfgNi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjRKfgNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BAD1F000FF;
	Sat, 12 Sep 2026 18:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239476;
	bh=RXL8q14Ym8pZCVKgU04vQV6i3MOIwOCzmUYhxUINZTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjRKfgNiuCa90pCCQrLcvLNXN8sCpMRhUc2AsIvAOuITE77j9KYKpQXk4RpYGyvH9
	 CxkPmd/OSCeMsJjdX2Pwyajd3U0nZVSuJ+9scmzGCYMdWtlnEZbBm4Mck7xZTDdgTA
	 99sG6Tr/wpglIt9lkpfs0CYikBNdivqw/IERUxVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 670/935] serial: amba-pl011: unprepare console clock on unregister
Date: Sat, 12 Sep 2026 09:01:40 +0200
Message-ID: <20260912065542.209870769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 7f93da9d78d433c37836d85de475c5d884ad58ed ]

pl011_console_setup() calls clk_prepare() on the UART clock, but the
console provides no matching teardown, so the clock is never unprepared
when the console is unregistered -- via the sysfs "console" attribute or
a driver unbind. Each re-registration prepares the clock again, leaking
one prepare reference per cycle.

Even where preparing the clock has no hardware effect, the stale
reference leaves the clock framework's prepare count unbalanced. For
providers with prepare/unprepare operations or runtime-PM integration,
it may also retain resources after the console is unregistered.

Add a console .exit() callback that clk_unprepare()s the clock,
balancing the clk_prepare() in pl011_console_setup().

Fixes: 4b4851c65d92 ("clk: amba-pl011: convert to clk_prepare()/clk_unprepare()")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260724213348.77418-2-kmehltretter@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 82d5b49194099..a5340c5e11b10 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2470,6 +2470,15 @@ static int pl011_console_setup(struct console *co, char *options)
 	return uart_set_options(&uap->port, co, baud, parity, bits, flow);
 }
 
+static int pl011_console_exit(struct console *co)
+{
+	struct uart_amba_port *uap = amba_ports[co->index];
+
+	clk_unprepare(uap->clk);
+
+	return 0;
+}
+
 /**
  *	pl011_console_match - non-standard console matching
  *	@co:	  registering console
@@ -2536,6 +2545,7 @@ static struct console amba_console = {
 	.write		= pl011_console_write,
 	.device		= uart_console_device,
 	.setup		= pl011_console_setup,
+	.exit		= pl011_console_exit,
 	.match		= pl011_console_match,
 	.flags		= CON_PRINTBUFFER | CON_ANYTIME,
 	.index		= -1,
-- 
2.53.0



