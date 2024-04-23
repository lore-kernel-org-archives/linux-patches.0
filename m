Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16C614388F;
	Tue, 23 Apr 2024 21:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908515; cv=none; b=TY818LBuKoviYfbUkmmlgca1l3AWJk1kgbvqTh9DZHhjzlMWr5f7BV+14kh5XHKzyW6vz5NitMEo7CHXTjM8vfOnjL3/XsSJe+kTG1Zd0ktrOeTbCXLHER5G+bjlD8xYuioTaMjsH7ajdZQo/eaD/UZRhlJqP4wtDq//YjZBIvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908515; c=relaxed/simple;
	bh=TedH9CkJFjrRcZCuvZFXkYGl9ey5C9yCWjlsP7mYi0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pS3wHAPFt5DxEGkfT+qD1MnsH/E4ENgcq7FtTeVB8P/2WD57Wg2V5YE6dl4Uj/uS9TcD73wTc/uIU9p7euXDXIScv03+mPbpvjD8cVKN449qzgRLzubKbqNIGOib8sn9oY0BqPmRyM3/l9tc7izRxfPWJNPxeOJk5yf9R/Pluaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyAPXwCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyAPXwCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5C1C32782;
	Tue, 23 Apr 2024 21:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908514;
	bh=TedH9CkJFjrRcZCuvZFXkYGl9ey5C9yCWjlsP7mYi0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyAPXwCMMfbBQHHn1z2e07TZClIOFVX7qMSnrDY1dnqxvlKoDqejY5W2i2MDyC8Ze
	 X6iw5MwSbbxX1tBAA7Y37hF+brcKTa/rR0npJPWhtQp6kKnSO0DQKwb/f9krX+v/TB
	 WwxsMvZMq6B45l4ZqYF/REeQSgmnlK/0BEvrLBro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Emil Kronborg <emil.kronborg@protonmail.com>
Subject: [PATCH 6.8 101/158] serial: mxs-auart: add spinlock around changing cts state
Date: Tue, 23 Apr 2024 14:38:43 -0700
Message-ID: <20240423213859.229882652@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Kronborg <emil.kronborg@protonmail.com>

commit 54c4ec5f8c471b7c1137a1f769648549c423c026 upstream.

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
---
 drivers/tty/serial/mxs-auart.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -1086,11 +1086,13 @@ static void mxs_auart_set_ldisc(struct u
 
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
@@ -1126,6 +1128,8 @@ static irqreturn_t mxs_auart_irq_handle(
 		istat &= ~AUART_INTR_TXIS;
 	}
 
+	uart_port_unlock(&s->port);
+
 	return IRQ_HANDLED;
 }
 


