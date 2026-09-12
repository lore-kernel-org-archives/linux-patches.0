Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B7D35201F;
	Sat, 12 Sep 2026 11:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212853; cv=none; b=mGnjPLoDTh1yyydb1bArKv5Y2X83MJtKUsWOsW9s69Q/I442NVHnZcITJdjxFBrCiXkzTJRBQ/QmZ1araOZJ4U2bhJTD71YHM8MMRlUmda/EFkV8ZHLPy68JlkVzs+LMr/KivNWVIoKk3PlF8ATBtXl5aSnVq4EX1tS8tEeKgn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212853; c=relaxed/simple;
	bh=zP0qrMd/NibxSw2XD7tz56PEtA/dTr6ANxLp50/Coyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4c5VkBLZhwfmbhfV/RiJeeJQn9ImvdOGYvA1EIKeLKpw5J2goTiZ+AZCOFklki2Xa9ukPSbK6lTec8AxHzQTA71iLCbugsO7eaWVvElKXYWmK6JfhZjWMmq+Wrp4JB/upQ4iApVpTOxM1ZEWox1P9o4uy2e6l4TjBvOW+DFPSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCihVUS2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCihVUS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898411F000FF;
	Sat, 12 Sep 2026 11:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212852;
	bh=keZr+YeDRlSWmEyTXjrnWNE46va3nVq1jWcDeWQ0IaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JCihVUS2XNUICQt/nGvHnWGShezKMm2I9vFUxSQFiqlith6b1oFbjjRKBlFhTHCOn
	 jshMk6n9O9hZFJk/JeXGQdUsV30K2NDNFq1VdVuBFSUldbV2+vIxvFtOPC+sh3szoo
	 mqtVs6q/6Ef1gshf+9SAOWqeEWgk1qg7gaUsUQMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1467/1518] serial: 8250: Ignore flow control on suspend/resume with no_console_suspend
Date: Sat, 12 Sep 2026 09:00:36 +0200
Message-ID: <20260912065656.741393050@linuxfoundation.org>
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

[ Upstream commit 302fbbb4fcbdeac2dc8c63a56c1c4e38c4781958 ]

If no_console_suspend is specified, on suspend the 8250 console driver
uses a scratch register (UART_SCR) to store a special canary value. This
is used during the resume path to identify a printk() call before the
driver's own ->resume() callback. In this case,
serial8250_console_restore() is called to quickly re-init the 8250 for
console printing.

See commit 4516d50aabed ("serial: 8250: Use canary to restart console after
suspend") for the original motivation.

Unfortunately, this canary workaround does not work in all cases (such as
suspend to mem) because the scratch register will not reset. This has not
been a real issue until now because it could simply lead to some garbage
characters upon resume. However, with the introduction of console flow
control it becomes a real problem because a failed suspend/resume detection
when flow control is enabled leads to all characters hitting the flow
control timeout.

Workaround this issue by temporarily ignoring console flow control when
the debug canary suspend/resume detection is active.

Fixes: 5e6dfb87b191 ("serial: 8250: Add support for console flow control")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Link: https://patch.msgid.link/20260707141032.5074-1-john.ogness@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 19b5b754a132d..d3ffba16c0f96 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1990,8 +1990,14 @@ static void wait_for_xmitr(struct uart_8250_port *up, int bits)
 
 	wait_for_lsr(up, bits);
 
-	/* Wait up to 1s for flow control if necessary */
-	if (uart_console_hwflow_active(&up->port)) {
+	/*
+	 * Wait up to 1s for flow control if necessary.
+	 * When 'no_console_suspend' is active (in the window between
+	 * suspend() and resume()), flow control is temporarily ignored
+	 * because the canary workaround is not reliable in all situations,
+	 * leading to flow control timeouts for every character.
+	 */
+	if (uart_console_hwflow_active(&up->port) && !up->canary) {
 		for (tmout = 1000000; tmout; tmout--) {
 			unsigned int msr = serial_in(up, UART_MSR);
 			up->msr_saved_flags |= msr & MSR_SAVE_FLAGS;
-- 
2.53.0



