Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12695369D72;
	Sat, 12 Sep 2026 12:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217037; cv=none; b=dyfBC7tetwp4QVa3e8wCkHXqsxd3O8sNI8ReYB+JOvQ7FPJzF6fLg+S9yMh1TqPUyHervZemeaVXNPy5deFABHEprpOkb7T0nXS42EqtpesfuUh72YOA8ygLJACDKOejzl1jztqiR6Fr3eqDY2dJqE0M8fTwLH3HUfGF+eiXDAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217037; c=relaxed/simple;
	bh=GwuYqsb4QiH8KL0FTYU3bx7b1yyocqt9Uo/Ixo1vtTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikyBifqANPJ6546c1Z9/Sp6IOHmhxeqBEP1IdlIY8EvE4sdU6t8OkEslGcLGYWbdUCQ3l2jykACvgAR/BLK+lxOl24kIz6ClXeBYDYS3hBqbE4MGtc6leGuYTOQblsHewvpkh6RSso9/Fykl+k9iu8NtbxorsY94YHRQbWXVMdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNsGzhmH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNsGzhmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F3C1F000FF;
	Sat, 12 Sep 2026 12:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217035;
	bh=lZILwS8Zgj8DVCsBPmVdQOIwevP/6n1man9+K5Tn/AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cNsGzhmHkFh5xHavlbHJozv/lQhUow16SeaDwbn1fyqgDSolvjB21QeTtsr3bYLjg
	 J5hdZmU7iboRJtH88SqCQqF0xjclA/0Ks+KRRo1jh91PCoGRMOp8FYxChz+7p9QcjW
	 sQiatMOZHsTJgyIQVP9jtCNGmm/JKSbE0m9btG4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0859/1376] serial: amba-pl011: unprepare console clock on unregister
Date: Sat, 12 Sep 2026 08:54:45 +0200
Message-ID: <20260912065626.706076146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 8934fbdb0cf98..3e1932a3bfbbd 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2434,6 +2434,15 @@ static int pl011_console_setup(struct console *co, char *options)
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
@@ -2500,6 +2509,7 @@ static struct console amba_console = {
 	.write		= pl011_console_write,
 	.device		= uart_console_device,
 	.setup		= pl011_console_setup,
+	.exit		= pl011_console_exit,
 	.match		= pl011_console_match,
 	.flags		= CON_PRINTBUFFER | CON_ANYTIME,
 	.index		= -1,
-- 
2.53.0



