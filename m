Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35964431A51;
	Sat, 12 Sep 2026 10:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209720; cv=none; b=Ib2v078NtGYufdJC/+sqnmu/f02KZ7oNm2WH2VLhy6KTuovBBrxA1P5oqCdANYT3jWm54nozX2kKKuTptdRy6IFdVjkLyyJ4zIsT5cN10EmJrt9bYUDBm25+CrrfKcWRBOmJ17ifaLlqy19/Yy9IxyP9WpBaO7L+qa+gpnBfB9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209720; c=relaxed/simple;
	bh=QOsX6uelCj/i81NqRLrtFNvLGZDzlsjZ2fcZBad4fUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9jS35sHKY/uUB2TTi9yKeftf2vWe22UzV1gYzoJezfuRh9HF1QwavFvCqGa/mUkL7yURUX91f5cPuSEQZlQ+USfRIUqpKlflJpO2bUDw7FOKP1DRqvF1RxqtHjY6ca9/kzwOEV2GcZ/ZhVoeYUXCKiCBZ1b4F2Z1q7hLTzN5ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MA1ZSATu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MA1ZSATu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5C51F00893;
	Sat, 12 Sep 2026 10:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209715;
	bh=pVCaPIowCqHYVxjX1CkHhjAutx938wNI7Te24OO0u3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MA1ZSATuV7vSVyePsubBjsYDqqL1h9NoAjCJPIpHKd+PxwvGU52n1R4YdTh+KWMS0
	 Se94VwMGS6PYSzwNU9lCIJT0Ah2SPrdY8nYwz0nNSGuI/817K1EpPi6MJmtPX/h1kW
	 LMuiGTvGui3rLSyvSF/MUE4DwfGEVqvCh10/fOW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0835/1518] serial: amba-pl011: unprepare console clock on unregister
Date: Sat, 12 Sep 2026 08:50:04 +0200
Message-ID: <20260912065642.329450692@linuxfoundation.org>
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
index 9bfccb0213836..66a6d336255bd 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2475,6 +2475,15 @@ static int pl011_console_setup(struct console *co, char *options)
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
@@ -2628,6 +2637,7 @@ static struct console amba_console = {
 	.name		= "ttyAMA",
 	.device		= uart_console_device,
 	.setup		= pl011_console_setup,
+	.exit		= pl011_console_exit,
 	.match		= pl011_console_match,
 	.write_atomic	= pl011_console_write_atomic,
 	.write_thread	= pl011_console_write_thread,
-- 
2.53.0



