Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A551E525;
	Mon,  1 Apr 2024 16:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990034; cv=none; b=JSHyrJxcKO9/fQva48kRnYf9Y3yPw2myO+GbG4GlX/hIVbIT+jETFWtoN2mKLB2ZyoYsQlhJTX/YFW4w5esJLzJ8cbd4R3E/OAln6guO93DzBxG9JPFud5rnIhML2gth84ZYz+8r9U/eZaAKvsbc2qglmiTu9TMwMgxdNdE1R5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990034; c=relaxed/simple;
	bh=TiTXvtU0w/nZlvAgXGhoi39i7rmq2bSnAYBQFGF2I/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjmTNvGBDfy+DSFi1+rgHZdQoeHYxx+bUO9SEABtUgZefxH/7B1dBsgP9673xUoNqlC/XoB/I4yPErRrRCUApYjHWYHQw1qyVeH95SHDLoNW5KLnQSyqwrLwccQcJVvHi9jIUjIT56yY/dxAX6dkhHJRreO7JUCG8YWgGrERaMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwGqS4n8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwGqS4n8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F6FC433F1;
	Mon,  1 Apr 2024 16:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990033;
	bh=TiTXvtU0w/nZlvAgXGhoi39i7rmq2bSnAYBQFGF2I/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwGqS4n8jS6aim/rDtvI3ME9lHHtJSgXVnnlRIddA0M6nMEzFfTUAcThWAeJIzWAN
	 0c/fTXYcz/yXxa8/ZjatHU24E0IdUJprIeJMuyZdU6D5Ejt1I2VgYWQtHnnqvDDexf
	 r4BanJo44Kn3oMjBHyYVd5cMarN1PbATdVraJND8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Collingbourne <pcc@google.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.6 227/396] serial: 8250_dw: Do not reclock if already at correct rate
Date: Mon,  1 Apr 2024 17:44:36 +0200
Message-ID: <20240401152554.687535422@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Peter Collingbourne <pcc@google.com>

commit e5d6bd25f93d6ae158bb4cd04956cb497a85b8ef upstream.

When userspace opens the console, we call set_termios() passing a
termios with the console's configured baud rate. Currently this causes
dw8250_set_termios() to disable and then re-enable the UART clock at
the same frequency as it was originally. This can cause corruption
of any concurrent console output. Fix it by skipping the reclocking
if we are already at the correct rate.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Fixes: 4e26b134bd17 ("serial: 8250_dw: clock rate handling for all ACPI platforms")
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240222192635.1050502-1-pcc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -357,9 +357,9 @@ static void dw8250_set_termios(struct ua
 	long rate;
 	int ret;
 
-	clk_disable_unprepare(d->clk);
 	rate = clk_round_rate(d->clk, newrate);
-	if (rate > 0) {
+	if (rate > 0 && p->uartclk != rate) {
+		clk_disable_unprepare(d->clk);
 		/*
 		 * Note that any clock-notifer worker will block in
 		 * serial8250_update_uartclk() until we are done.
@@ -367,8 +367,8 @@ static void dw8250_set_termios(struct ua
 		ret = clk_set_rate(d->clk, newrate);
 		if (!ret)
 			p->uartclk = rate;
+		clk_prepare_enable(d->clk);
 	}
-	clk_prepare_enable(d->clk);
 
 	dw8250_do_set_termios(p, termios, old);
 }


