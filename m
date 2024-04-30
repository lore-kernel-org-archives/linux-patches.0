Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E76912C462;
	Tue, 30 Apr 2024 11:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475023; cv=none; b=PJKhZxyxGddTF7R0Kz7AWDusKN2Pk7QYTxJvZoWPoXYkrmxvvoFZrU5YjBWmcQBZhPKSFlNLgFJr5+a+j38UOM+6af0WBd0xH485H21Z9lt/yYDnG+ICrKoEYsoK4sXBAGquHt0rcgU4Lf32CbpvQPPT3o7nNj/VkC3yapHyCXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475023; c=relaxed/simple;
	bh=ygfQbFuxYCQQozINux669HjvKBx00Npdgef9xdRnOMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mx4PFgfSTzExK1x8V5K005E6z8NEdqgtWHpXYJy5yNLIFVvtwOModeHiQFX+VkcQX2D4Pn4tzE8s4spiSN/5unwdwPsnEhNPhl/JLs8JakbektM3KfT1+JXxyzYoUa81HI/HHJLZwhWT5PBkUVUOR8u3ohhKW5VuVlooGtQd57w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhwpx/ok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhwpx/ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB126C4AF19;
	Tue, 30 Apr 2024 11:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475023;
	bh=ygfQbFuxYCQQozINux669HjvKBx00Npdgef9xdRnOMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhwpx/oklBFfomP8K5gFq8jQWWfXwP2g/i4+/kl8MNmBsehhP1+9MT9n3fSsr33Kr
	 BWnT2kh1RndORDifRUBkdY3IAw1nqCsJyBt3w+sjvelV2rGWUxC/CGW9aFT9jbdnIu
	 caeiRYBnHvsUtlK4JLSyUw5ZDfCGiaDApNNCRjps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Emil Kronborg <emil.kronborg@protonmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/138] serial: mxs-auart: add spinlock around changing cts state
Date: Tue, 30 Apr 2024 12:39:53 +0200
Message-ID: <20240430103052.591152003@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b784323a6a7b0..be6c8b9f1606e 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -1122,11 +1122,13 @@ static void mxs_auart_set_ldisc(struct uart_port *port,
 
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
@@ -1162,6 +1164,8 @@ static irqreturn_t mxs_auart_irq_handle(int irq, void *context)
 		istat &= ~AUART_INTR_TXIS;
 	}
 
+	uart_port_unlock(&s->port);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.43.0



