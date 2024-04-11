Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4FB145B07;
	Thu, 11 Apr 2024 10:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830346; cv=none; b=otyihVshqnazXWvcOKyuwxKzBKZ6Catn6Fy2/JScbOt/cdsuRdsWFE/Pds6pocSoH7GBVsTktnWY595X/TqYm28BxQhw39NqPItG0GWSDXdRx22YvaHb3si1fjHeTUMzEhcSlo2einwasHhvLLeUJZzsrhQb7pjXGrWq7I9fC5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830346; c=relaxed/simple;
	bh=46YYkSOd1s7rTHKco3EUrYl4YOeMDN/IZDotiJkxv3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j/xGpRj9TNCNWP8CdHFlwmADQScyR8AX8vz2VzIDIik6DTAJd2RVfMvPg9/ZuPYl6UMK/0nJFFr8UoOdj2DiVtBvKTvfY5zdePO8rVAIBxEfc73fop90ZgUgMOEAGLbwK+Wwucemf8w6qrKv2VMEJBKTgDj5rRVYlJ6CWebuQfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNwCfWfT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNwCfWfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575EDC433F1;
	Thu, 11 Apr 2024 10:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830345;
	bh=46YYkSOd1s7rTHKco3EUrYl4YOeMDN/IZDotiJkxv3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNwCfWfTye8nE8WXJOVAUpOI/yR7zvyzktuHWbN1g4i5ouZi859depZ6aKC8HgBsT
	 sH6KJvuAqVTC38I2piq6DhbdoL4WI5+8VsGTOmbYl6RpIIPHXvIkWFg/vYacs0u9Zc
	 1YzcLoupIEhGp6EF2j1er7wEjquBVRdxfo7siu7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 116/143] serial: 8250_of: Drop quirk fot NPCM from 8250_port
Date: Thu, 11 Apr 2024 11:56:24 +0200
Message-ID: <20240411095424.398540361@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit cd0eb354d441488feed6685adbeb1acd45db1b8d ]

We are not supposed to spread quirks in 8250_port module especially
when we have a separate driver for the hardware in question.

Move quirk from generic module to the driver that uses it.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240215145029.581389-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_of.c   | 44 +++++++++++++++++++++++++++--
 drivers/tty/serial/8250/8250_port.c | 24 ----------------
 2 files changed, 42 insertions(+), 26 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_of.c b/drivers/tty/serial/8250/8250_of.c
index 34f17a9785e79..9dcc17e332690 100644
--- a/drivers/tty/serial/8250/8250_of.c
+++ b/drivers/tty/serial/8250/8250_of.c
@@ -4,7 +4,10 @@
  *
  *    Copyright (C) 2006 Arnd Bergmann <arnd@arndb.de>, IBM Corp.
  */
+
+#include <linux/bits.h>
 #include <linux/console.h>
+#include <linux/math.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/serial_core.h>
@@ -25,6 +28,36 @@ struct of_serial_info {
 	int line;
 };
 
+/* Nuvoton NPCM timeout register */
+#define UART_NPCM_TOR          7
+#define UART_NPCM_TOIE         BIT(7)  /* Timeout Interrupt Enable */
+
+static int npcm_startup(struct uart_port *port)
+{
+	/*
+	 * Nuvoton calls the scratch register 'UART_TOR' (timeout
+	 * register). Enable it, and set TIOC (timeout interrupt
+	 * comparator) to be 0x20 for correct operation.
+	 */
+	serial_port_out(port, UART_NPCM_TOR, UART_NPCM_TOIE | 0x20);
+
+	return serial8250_do_startup(port);
+}
+
+/* Nuvoton NPCM UARTs have a custom divisor calculation */
+static unsigned int npcm_get_divisor(struct uart_port *port, unsigned int baud,
+				     unsigned int *frac)
+{
+	return DIV_ROUND_CLOSEST(port->uartclk, 16 * baud + 2) - 2;
+}
+
+static int npcm_setup(struct uart_port *port)
+{
+	port->get_divisor = npcm_get_divisor;
+	port->startup = npcm_startup;
+	return 0;
+}
+
 /*
  * Fill a struct uart_port for a given device node
  */
@@ -164,10 +197,17 @@ static int of_platform_serial_setup(struct platform_device *ofdev,
 	switch (type) {
 	case PORT_RT2880:
 		ret = rt288x_setup(port);
-		if (ret)
-			goto err_pmruntime;
+		break;
+	case PORT_NPCM:
+		ret = npcm_setup(port);
+		break;
+	default:
+		/* Nothing to do */
+		ret = 0;
 		break;
 	}
+	if (ret)
+		goto err_pmruntime;
 
 	if (IS_REACHABLE(CONFIG_SERIAL_8250_FSL) &&
 	    (of_device_is_compatible(np, "fsl,ns16550") ||
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 1d65055dde276..c0c34e410c581 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -38,10 +38,6 @@
 
 #include "8250.h"
 
-/* Nuvoton NPCM timeout register */
-#define UART_NPCM_TOR          7
-#define UART_NPCM_TOIE         BIT(7)  /* Timeout Interrupt Enable */
-
 /*
  * Debugging.
  */
@@ -2229,15 +2225,6 @@ int serial8250_do_startup(struct uart_port *port)
 				UART_DA830_PWREMU_MGMT_FREE);
 	}
 
-	if (port->type == PORT_NPCM) {
-		/*
-		 * Nuvoton calls the scratch register 'UART_TOR' (timeout
-		 * register). Enable it, and set TIOC (timeout interrupt
-		 * comparator) to be 0x20 for correct operation.
-		 */
-		serial_port_out(port, UART_NPCM_TOR, UART_NPCM_TOIE | 0x20);
-	}
-
 #ifdef CONFIG_SERIAL_8250_RSA
 	/*
 	 * If this is an RSA port, see if we can kick it up to the
@@ -2539,15 +2526,6 @@ static void serial8250_shutdown(struct uart_port *port)
 		serial8250_do_shutdown(port);
 }
 
-/* Nuvoton NPCM UARTs have a custom divisor calculation */
-static unsigned int npcm_get_divisor(struct uart_8250_port *up,
-		unsigned int baud)
-{
-	struct uart_port *port = &up->port;
-
-	return DIV_ROUND_CLOSEST(port->uartclk, 16 * baud + 2) - 2;
-}
-
 static unsigned int serial8250_do_get_divisor(struct uart_port *port,
 					      unsigned int baud,
 					      unsigned int *frac)
@@ -2592,8 +2570,6 @@ static unsigned int serial8250_do_get_divisor(struct uart_port *port,
 		quot = 0x8001;
 	else if (magic_multiplier && baud >= port->uartclk / 12)
 		quot = 0x8002;
-	else if (up->port.type == PORT_NPCM)
-		quot = npcm_get_divisor(up, baud);
 	else
 		quot = uart_get_divisor(port, baud);
 
-- 
2.43.0



