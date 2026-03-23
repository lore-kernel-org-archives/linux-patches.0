Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8BD3AD51A;
	Mon, 23 Mar 2026 13:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273964; cv=none; b=aEEjX/dfnnTExvw797yg2AyK4DSGV5aCeaVr4kPxNZQfNxKje+cZTd4mpDWOBMfot4ISzeED7a2tP5/bwhkGcZXE0/N1QzNtjH/WzfaCDufrLH6iX9WDLTLZ+Mo7krA3P2KFLeEX5HCvlvAeYbodn+DKm0mLztchjCpHsZu7Znc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273964; c=relaxed/simple;
	bh=oz91XzRwYA1uG27+qzsJk34sNb0UE50h3eFARlO5STk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SAsU4Ixy8U+vHUi/KbY9ZdRB6tAo3pgt14cFSsTKWzoB6bOzLp+nwUNORX7bAA979oBxquth9M960/kNsQhyzH5y35zBNvxUNlTkXwVWUK9jAzo0TriBE4EPQlsWparfVVH7EXQFedAqySzHkUoUUpu9UBHL+iDh3Ui4DBbvC2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMpvnEJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMpvnEJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4605C4CEF7;
	Mon, 23 Mar 2026 13:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273964;
	bh=oz91XzRwYA1uG27+qzsJk34sNb0UE50h3eFARlO5STk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMpvnEJduozbBzgqMtUn5DtiXhDvRUBWrleuw+dtprhhn9JU8C5kaoQkoCu2RRFMa
	 xqkxc1+uM1bq11JFrGHG444sX5g3l6WptGFdJbKShY5bHnnPPMMsDuHuUAY6tJA4nv
	 eSXDq+P0v6hsi0mSXgxyjsgm2Aq9ttj7MERjOdBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bandal, Shankar" <shankar.bandal@intel.com>,
	"Murthy, Shanth" <shanth.murthy@intel.com>,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.19 064/220] serial: 8250: Add serial8250_handle_irq_locked()
Date: Mon, 23 Mar 2026 14:44:01 +0100
Message-ID: <20260323134506.614860954@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 8324a54f604da18f21070702a8ad82ab2062787b upstream.

8250_port exports serial8250_handle_irq() to HW specific 8250 drivers.
It takes port's lock within but a HW specific 8250 driver may want to
take port's lock itself, do something, and then call the generic
handler in 8250_port but to do that, the caller has to release port's
lock for no good reason.

Introduce serial8250_handle_irq_locked() which a HW specific driver can
call while already holding port's lock.

As this is new export, put it straight into a namespace (where all 8250
exports should eventually be moved).

Tested-by: Bandal, Shankar <shankar.bandal@intel.com>
Tested-by: Murthy, Shanth <shanth.murthy@intel.com>
Cc: stable <stable@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260203171049.4353-4-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |   24 ++++++++++++++++--------
 include/linux/serial_8250.h         |    1 +
 2 files changed, 17 insertions(+), 8 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -18,6 +18,7 @@
 #include <linux/irq.h>
 #include <linux/console.h>
 #include <linux/gpio/consumer.h>
+#include <linux/lockdep.h>
 #include <linux/sysrq.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
@@ -1782,20 +1783,16 @@ static bool handle_rx_dma(struct uart_82
 }
 
 /*
- * This handles the interrupt from one port.
+ * Context: port's lock must be held by the caller.
  */
-int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
+void serial8250_handle_irq_locked(struct uart_port *port, unsigned int iir)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
 	struct tty_port *tport = &port->state->port;
 	bool skip_rx = false;
-	unsigned long flags;
 	u16 status;
 
-	if (iir & UART_IIR_NO_INT)
-		return 0;
-
-	uart_port_lock_irqsave(port, &flags);
+	lockdep_assert_held_once(&port->lock);
 
 	status = serial_lsr_in(up);
 
@@ -1828,8 +1825,19 @@ int serial8250_handle_irq(struct uart_po
 		else if (!up->dma->tx_running)
 			__stop_tx(up);
 	}
+}
+EXPORT_SYMBOL_NS_GPL(serial8250_handle_irq_locked, "SERIAL_8250");
+
+/*
+ * This handles the interrupt from one port.
+ */
+int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
+{
+	if (iir & UART_IIR_NO_INT)
+		return 0;
 
-	uart_unlock_and_check_sysrq_irqrestore(port, flags);
+	guard(uart_port_lock_irqsave)(port);
+	serial8250_handle_irq_locked(port, iir);
 
 	return 1;
 }
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -195,6 +195,7 @@ void serial8250_do_set_mctrl(struct uart
 void serial8250_do_set_divisor(struct uart_port *port, unsigned int baud,
 			       unsigned int quot);
 int fsl8250_handle_irq(struct uart_port *port);
+void serial8250_handle_irq_locked(struct uart_port *port, unsigned int iir);
 int serial8250_handle_irq(struct uart_port *port, unsigned int iir);
 u16 serial8250_rx_chars(struct uart_8250_port *up, u16 lsr);
 void serial8250_read_char(struct uart_8250_port *up, u16 lsr);


