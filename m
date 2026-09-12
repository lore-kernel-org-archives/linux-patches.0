Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058D639FCDC;
	Sat, 12 Sep 2026 08:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201429; cv=none; b=YJhy1ot5Szx3YrICc/Pj3wC7QlHAlmqcy6Rj58/paZ69swDfdc2H6fnI7ZebGbnBYsicfBJhQkctmdGNea8Zcf7ojwQjduYuICm3SR5BfkeJMcvBBcTFokCOyT4N99bMD1ocSLYpUh5v0gSaCVA3lj7yAj4NTaaWhjXS/M89wn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201429; c=relaxed/simple;
	bh=sKTA7v/7L5goJhcAx9RW+jMR+ribHlu7SlAFxOIG0Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X98FiHh7EiD+Djy9cFJNkkhZJRSx5msToOLEuHxgZ8BdYW6ygv2ypKLtU7M3RtDjenMoSG3s3f9aEIrFtgcmmTHlv6x7gM0eyoirzv9kKAv8bYpzFTMZXplquR+4yfzF/3KFNIiTcfH1aP6Xo8v/u8lRM3DUIeEErPIvS7FnwJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pyg/ubkH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pyg/ubkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC99A1F000FF;
	Sat, 12 Sep 2026 08:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201427;
	bh=Tvb+W4pdiEF35UP0k33dMVtSt0hQrI4Sc9QjDwSDXS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pyg/ubkHoS1oGSlrB3hDgM+a/kQadtIOJ86LuXOyWUH7G8I6THOeg6BlToQ5towpk
	 o/6jGd2QmgRrw1+kgwYGaGvFnA0S7vLFkHA+7OzC0qRPChYRbQwTRc/HkAWXpCAvJu
	 gt0aozdAKBg1F0/gbdew+b7tbpV3EyNZf+PLyV+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0993/1815] serial: amba-pl011: unprepare console clock on unregister
Date: Sat, 12 Sep 2026 08:45:43 +0200
Message-ID: <20260912065712.309909358@linuxfoundation.org>
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
index 9abaeecd05fc8..4751bf7b4cc90 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2572,6 +2572,15 @@ static int pl011_console_setup(struct console *co, char *options)
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
@@ -2725,6 +2734,7 @@ static struct console amba_console = {
 	.name		= "ttyAMA",
 	.device		= uart_console_device,
 	.setup		= pl011_console_setup,
+	.exit		= pl011_console_exit,
 	.match		= pl011_console_match,
 	.write_atomic	= pl011_console_write_atomic,
 	.write_thread	= pl011_console_write_thread,
-- 
2.53.0



