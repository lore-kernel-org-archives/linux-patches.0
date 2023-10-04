Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243E41C291
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWV0HcPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C6DC433C7;
	Wed,  4 Oct 2023 18:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444448;
	bh=ZqS+GkqVeGqmZZxOKJ712oQBjCE9AfIatqdOF0nfslY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mWV0HcPmJU6DpcmBrHxqAFbopVeayok4TGC4UabGNcCt0J5KkknRIY9GYpv3H5Za5
	 ezNJLJ2HYQ8ZQMGLTHPkVvj+6FYq/W7QBKWuRCPrFcS6W8maksCD6H/UEIc2Q72uUe
	 wAw9ut1Bd03CugsIjQL04rl22HhZp/H+3mKblJsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.5 254/321] serial: 8250_port: Check IRQ data before use
Date: Wed,  4 Oct 2023 19:56:39 +0200
Message-ID: <20231004175241.033799243@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit cce7fc8b29961b64fadb1ce398dc5ff32a79643b upstream.

In case the leaf driver wants to use IRQ polling (irq = 0) and
IIR register shows that an interrupt happened in the 8250 hardware
the IRQ data can be NULL. In such a case we need to skip the wake
event as we came to this path from the timer interrupt and quite
likely system is already awake.

Without this fix we have got an Oops:

    serial8250: ttyS0 at I/O 0x3f8 (irq = 0, base_baud = 115200) is a 16550A
    ...
    BUG: kernel NULL pointer dereference, address: 0000000000000010
    RIP: 0010:serial8250_handle_irq+0x7c/0x240
    Call Trace:
     ? serial8250_handle_irq+0x7c/0x240
     ? __pfx_serial8250_timeout+0x10/0x10

Fixes: 0ba9e3a13c6a ("serial: 8250: Add missing wakeup event reporting")
Cc: stable <stable@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20230831222555.614426-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1929,7 +1929,10 @@ int serial8250_handle_irq(struct uart_po
 		skip_rx = true;
 
 	if (status & (UART_LSR_DR | UART_LSR_BI) && !skip_rx) {
-		if (irqd_is_wakeup_set(irq_get_irq_data(port->irq)))
+		struct irq_data *d;
+
+		d = irq_get_irq_data(port->irq);
+		if (d && irqd_is_wakeup_set(d))
 			pm_wakeup_event(tport->tty->dev, 0);
 		if (!up->dma || handle_rx_dma(up, iir))
 			status = serial8250_rx_chars(up, status);


