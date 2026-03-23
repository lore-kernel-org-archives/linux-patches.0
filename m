Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345741DA0E1;
	Mon, 23 Mar 2026 16:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282829; cv=none; b=knyxH7uCVFKpKin9iR6AzZzwsypX/ZvSQVhBI9QkKyMeLrNxV+KvUWzgKDWO7RJ6NjJpNzJPahVRnsBUwELeQpSt3gwK9UiAjHHC0XuT1P1J8D8EFKXqu1vryennOTEAPvZ6oc2FPXet7DKdGgqrkSBNrvt5KMxllaLa7NPy50I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282829; c=relaxed/simple;
	bh=+Fzb3pEwpkPWE8dREIyOCMNztaaB2bEoT+Pc02fvz+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cp+tyQd9QMsQlUPFqa5AO0rMACX20AUjvC0ll9+oww/LeBpK/PSfEvhbxTcv3vOIowKAkhVk4+11Z7tABha+xjZ2QcMBsHq9V0stldSPpu2AZn6T6l+VSzNetMGrQDmhKNjJw/j3cGY/7RYi3mm7Jeowc2+GgSOLrA2ICPR+jrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Km2CbchD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Km2CbchD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B34C4CEF7;
	Mon, 23 Mar 2026 16:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282829;
	bh=+Fzb3pEwpkPWE8dREIyOCMNztaaB2bEoT+Pc02fvz+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Km2CbchD+PcqVxJvfD3fN2aBsGqCqCEBUZRQmWexnYs75VbNmHjznZQy1gbrNTRor
	 kFmqboq9aqMet5m/odmdVgVf/KeB75gZ0vJMY4ibMrb0B3LJtLxqcnw2gIz2BVEg4w
	 JmF6Mc7FUr5/TgNVo3gdyqbli8zaPq/gQR9V56gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Bandal, Shankar" <shankar.bandal@intel.com>,
	"Murthy, Shanth" <shanth.murthy@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.1 301/481] serial: 8250: Add late synchronize_irq() to shutdown to handle DW UART BUSY
Date: Mon, 23 Mar 2026 14:44:43 +0100
Message-ID: <20260323134532.449750301@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit e0a368ae79531ff92105a2692f10d83052055856 upstream.

When DW UART is !uart_16550_compatible, it can indicate BUSY at any
point (when under constant Rx pressure) unless a complex sequence of
steps is performed. Any LCR write can run a foul with the condition
that prevents writing LCR while the UART is BUSY, which triggers
BUSY_DETECT interrupt that seems unmaskable using IER bits.

Normal flow is that dw8250_handle_irq() handles BUSY_DETECT condition
by reading USR register. This BUSY feature, however, breaks the
assumptions made in serial8250_do_shutdown(), which runs
synchronize_irq() after clearing IER and assumes no interrupts can
occur after that point but then proceeds to update LCR, which on DW
UART can trigger an interrupt.

If serial8250_do_shutdown() releases the interrupt handler before the
handler has run and processed the BUSY_DETECT condition by read the USR
register, the IRQ is not deasserted resulting in interrupt storm that
triggers "irq x: nobody cared" warning leading to disabling the IRQ.

Add late synchronize_irq() into serial8250_do_shutdown() to ensure
BUSY_DETECT from DW UART is handled before port's interrupt handler is
released. Alternative would be to add DW UART specific shutdown
function but it would mostly duplicate the generic code and the extra
synchronize_irq() seems pretty harmless in serial8250_do_shutdown().

Fixes: 7d4008ebb1c9 ("tty: add a DesignWare 8250 driver")
Cc: stable <stable@kernel.org>
Reported-by: Bandal, Shankar <shankar.bandal@intel.com>
Tested-by: Bandal, Shankar <shankar.bandal@intel.com>
Tested-by: Murthy, Shanth <shanth.murthy@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260203171049.4353-7-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2526,6 +2526,12 @@ void serial8250_do_shutdown(struct uart_
 	 * the IRQ chain.
 	 */
 	serial_port_in(port, UART_RX);
+	/*
+	 * LCR writes on DW UART can trigger late (unmaskable) IRQs.
+	 * Handle them before releasing the handler.
+	 */
+	synchronize_irq(port->irq);
+
 	serial8250_rpm_put(up);
 
 	up->ops->release_irq(up);


