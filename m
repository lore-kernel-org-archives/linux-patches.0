Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2364F17592;
	Tue, 30 Apr 2024 11:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475874; cv=none; b=Vrh6gcl6gN3jHjVzzATGxZ0s36ymgl9x0dyU04X8XST9ytBh1B/2wq+Yj06fpXQoWsgO+/mmLotoqKKI54SwvHVE2qo6Wr5pdZPBBJpeEKtMEDKPvwDFc7cX/um1q8L0vMsGbvK9WX59VyHrFGZPpkJ9cpiKFRtFgCDDOtYKsoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475874; c=relaxed/simple;
	bh=5z9j8Jya+JlwhYbdZlLZmNGiY78lLV0WA860yvLC4FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plZN8m9hTb3ZttpgMfc0SE2SibGjNN1l4VJqMSEpoKVAPWuJzJXaIO3eiCXikJ51PNDLfmlSte04mJo+Y8bMhDTpTna3b1foN176HQobfawYscAfuiOH4jVnkBG52A5MlAMhFJFsEYgm9ZoqpOgbnszr5uQ4E7eirhaquc8KBqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZJoWpqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZJoWpqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DA5C4AF18;
	Tue, 30 Apr 2024 11:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475873;
	bh=5z9j8Jya+JlwhYbdZlLZmNGiY78lLV0WA860yvLC4FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZJoWpqNgymCVORztpfFrjlwvGTj8wG5gXAPiXv52skkCqH6pjye6yhvFyByES77a
	 T88GsmKxhkgfotRbxv84Jasjyd17BT4Yfvc+PdwGGXm2Az2mDKdEXE0pIKIZ1sTW/d
	 KPDccsLqbMB7GOn0f54k6b6uwVUb5vlxJeuz1zEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Emil Kronborg <emil.kronborg@protonmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 45/80] serial: mxs-auart: add spinlock around changing cts state
Date: Tue, 30 Apr 2024 12:40:17 +0200
Message-ID: <20240430103044.750129582@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ac45f3386e974..dfedd3f1130e4 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -1094,11 +1094,13 @@ static void mxs_auart_set_ldisc(struct uart_port *port,
 
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
@@ -1134,6 +1136,8 @@ static irqreturn_t mxs_auart_irq_handle(int irq, void *context)
 		istat &= ~AUART_INTR_TXIS;
 	}
 
+	uart_port_unlock(&s->port);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.43.0



