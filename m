Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019B412C49E;
	Tue, 30 Apr 2024 10:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473842; cv=none; b=E4YWxb9azUdw6x+ERmiP+B4hSTpaM4vZiaf7vhRhC1QSopH6z15J20qtha7bBDEhRwy1WAteriq8CNlGK6JOO0KROlrUk3xUy31pfH48xA28CWuk6Ah7rvywoUI5Dj5E5WHy3kYduQIbXBtqbX+Bmlut9De5WINamsLiDm+rKQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473842; c=relaxed/simple;
	bh=7bDadnZU89zv16zi0xSwLJzP6Xu9xu2O3gyIwbt3NwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUPLEKk36W6VmmIe41p11SiXuy00TyA1W/QuxqA3H0lBjchle9FG86TxloLgZtmQfqhF1Btir6X1s5qaVyiDoAcm1PXqwGtnZ0mWZvH/xQYpqARK0BqoS2eIjBbKXkG+butoi3QBLlCfXeL1XJ+Os9MF8Vj33aWE38I/uQPHUiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJMHJG5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJMHJG5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BD2C2BBFC;
	Tue, 30 Apr 2024 10:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473841;
	bh=7bDadnZU89zv16zi0xSwLJzP6Xu9xu2O3gyIwbt3NwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJMHJG5DcFOl3oZYhdNZY4m7qm0UUUCzpJUgkz9O0CJCeSb9mLaxH9qAlqqqnjZEN
	 dErTBil7Y/umR+0cxS29RQLAYuZLkVDG5P2ro98THUpN+dZXAnfD5HQhFEioJI2PrK
	 K157GUQ73mbQbS4kNfG3+A2OKEuzNY69E6xLT138=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Emil Kronborg <emil.kronborg@protonmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 54/77] serial: mxs-auart: add spinlock around changing cts state
Date: Tue, 30 Apr 2024 12:39:33 +0200
Message-ID: <20240430103042.732668552@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 63810eefa44b8..9ac2f21be8d72 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -1128,11 +1128,13 @@ static void mxs_auart_set_ldisc(struct uart_port *port,
 
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
@@ -1168,6 +1170,8 @@ static irqreturn_t mxs_auart_irq_handle(int irq, void *context)
 		istat &= ~AUART_INTR_TXIS;
 	}
 
+	uart_port_unlock(&s->port);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.43.0



