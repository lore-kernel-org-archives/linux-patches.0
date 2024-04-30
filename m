Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2FC12D745;
	Tue, 30 Apr 2024 11:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476254; cv=none; b=iPA1Ji1+nEn8KFdBUfohCkJYcyoP7l/NYBDAm1OQ7I5hQ9Wf4x+soqzI8QLW8fBwJd/tXYLSpZps8AcSHntnyGF9BPkhLzbjuApgNc4L4gkH5OxrX3ERmKRIsGInR+KU5RF14JKMf/mOxdx3tUZM200e5P39XvdDaKnQhUArH/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476254; c=relaxed/simple;
	bh=QjN3qMx1vOTq2vdWSNykbsp+/4pffcGkXAi8puLoWPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOUtrW2scH8EEw8V0h/+Jn4E/sg2YreZquVh0KdbNhxbtyyL1QPwKD9CDf3fqXiEvynYef2ZS+cLz22am0mBIjRVZQ/ra5qu2HWwhakMNSDueXnueOTLhiNE8Q34biZwKlmCv1yzKQV+UCFdWCFd0zCMzFtOVRBvIm6dY3BVbn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BB4eMT8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BB4eMT8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57BDC2BBFC;
	Tue, 30 Apr 2024 11:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476254;
	bh=QjN3qMx1vOTq2vdWSNykbsp+/4pffcGkXAi8puLoWPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BB4eMT8MfWfN8vecCwSIKHJuFokSuPpXd1zyTcDclW+8Bn2IPyo2Xs6qqGUFBA4aP
	 WnEDe/7u3Yac7nhbJ3G2ykvy61qzgec6LhsdKBg8EqH/nm1hNBNeWs+18WC9+pXPaG
	 fFgSFqZSwMUEdJHUjL29vfAxYIgiA57oVfm34Ofo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Emil Kronborg <emil.kronborg@protonmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/107] serial: mxs-auart: add spinlock around changing cts state
Date: Tue, 30 Apr 2024 12:40:40 +0200
Message-ID: <20240430103047.019012601@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Kronborg <emil.kronborg@protonmail.com>

[ Upstream commit 54c4ec5f8c471b7c1137a1f769648549c423c026 ]

The uart_handle_cts_change() function in serial_core expects the caller
to hold uport->lock. For example, I have seen the below kernel splat,
when the Bluetooth driver is loaded on an i.MX28 board.

    [   85.119255] ------------[ cut here ]------------
    [   85.124413] WARNING: CPU: 0 PID: 27 at /drivers/tty/serial/serial_core.c:3453 uart_handle_cts_change+0xb4/0xec
    [   85.134694] Modules linked in: hci_uart bluetooth ecdh_generic ecc wlcore_sdio configfs
    [   85.143314] CPU: 0 PID: 27 Comm: kworker/u3:0 Not tainted 6.6.3-00021-gd62a2f068f92 #1
    [   85.151396] Hardware name: Freescale MXS (Device Tree)
    [   85.156679] Workqueue: hci0 hci_power_on [bluetooth]
    (...)
    [   85.191765]  uart_handle_cts_change from mxs_auart_irq_handle+0x380/0x3f4
    [   85.198787]  mxs_auart_irq_handle from __handle_irq_event_percpu+0x88/0x210
    (...)

Cc: stable@vger.kernel.org
Fixes: 4d90bb147ef6 ("serial: core: Document and assert lock requirements for irq helpers")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Emil Kronborg <emil.kronborg@protonmail.com>
Link: https://lore.kernel.org/r/20240320121530.11348-1-emil.kronborg@protonmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/mxs-auart.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index 5d483e996514f..a8eb98e37af48 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -1126,11 +1126,13 @@ static void mxs_auart_set_ldisc(struct uart_port *port,
 
 static irqreturn_t mxs_auart_irq_handle(int irq, void *context)
 {
-	u32 istat;
+	u32 istat, stat;
 	struct mxs_auart_port *s = context;
 	u32 mctrl_temp = s->mctrl_prev;
-	u32 stat = mxs_read(s, REG_STAT);
 
+	uart_port_lock(&s->port);
+
+	stat = mxs_read(s, REG_STAT);
 	istat = mxs_read(s, REG_INTR);
 
 	/* ack irq */
@@ -1166,6 +1168,8 @@ static irqreturn_t mxs_auart_irq_handle(int irq, void *context)
 		istat &= ~AUART_INTR_TXIS;
 	}
 
+	uart_port_unlock(&s->port);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.43.0



