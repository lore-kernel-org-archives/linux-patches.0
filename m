Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA306345749;
	Sat, 12 Sep 2026 14:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224533; cv=none; b=ccs+yUgUkZnDRkSTPtXQmqXws+RRdNa2m0Bb2JggWq+Ja1RUNCJxrye7QFOwcKXNUA9g2B/lO3lP3OalJTwC2rStR6wCnVU99FZzmjVPfxGtv6E+R3P/MyKS7nf08xHHYMKV8i91fC6fMZysz+sOM460dOyMXkJylT9/bK8LxCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224533; c=relaxed/simple;
	bh=K4lvMzzXnHEyzIr0j+bStkh0lOGROP22bkvR6Skj0Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGL/Ap74/BXscL6WPI4slje2ocUy/myf49Mo1UvR6RiPMPvfV2dk7kyUc4MlFANGhEPl746XP1PzyxBBrUPSg1n+y62qbE51HiYoDxZXA1uW0En301rKs55IjsuhzyvFrTV2lzI/enWeF+mfoZ3WVQy+mRVP6nx30xZdxtS0EAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oArmuhbs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oArmuhbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7376C1F00893;
	Sat, 12 Sep 2026 14:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224532;
	bh=kervJ/5h3mD6OBLp17c3K3o1zwF8CnFRaYixPjSj4TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oArmuhbsmZ8WKt8TXuxYDE+1JYAAsbcoExbN3AJO/fBwObCUNSvfZeosaQlqX4jQQ
	 NXEkQFPISgFyFAKPZB5/AQRuMifBOW1gSYvWxc00wOUb4PSwAxjDfu0nbtqaoQqjvJ
	 NW8RUHQxipp1q3nWtHX7oDoSyWOu77y9+Kz7EzL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1013/1424] serial: amba-pl011: unprepare console clock on unregister
Date: Sat, 12 Sep 2026 08:57:25 +0200
Message-ID: <20260912065629.996947987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4c107556ae315..17b8b56565194 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2457,6 +2457,15 @@ static int pl011_console_setup(struct console *co, char *options)
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
@@ -2523,6 +2532,7 @@ static struct console amba_console = {
 	.write		= pl011_console_write,
 	.device		= uart_console_device,
 	.setup		= pl011_console_setup,
+	.exit		= pl011_console_exit,
 	.match		= pl011_console_match,
 	.flags		= CON_PRINTBUFFER | CON_ANYTIME,
 	.index		= -1,
-- 
2.53.0



