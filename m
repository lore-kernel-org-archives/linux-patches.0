Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BA622370A;
	Mon, 23 Jun 2025 22:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717604; cv=none; b=f6jOXFfiwxFJVxsMU9lWhRg+IaZXBPru5JD6RLKUbjpKus7CF0MX/x5/iLcgSqQTU+GE/xEcENXkP+4Dj+dH3gUPMB49qbDebXfDEHyJ90SZnYz+V9ogczWDMX3J5EySL0DWpAvCBjZXH9O75TXMJwjty2OD+w+fsbdBDNlPKyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717604; c=relaxed/simple;
	bh=i5L+HbxuEhwwh8Y3q4oFmttZTqvW8MfEZUkliR54EJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bS52Huk16u9EyYN/xl8P/xOi3WgMwEyw5D82YzGFtiHzXfC5oBRuSCvQOQatpE8hDFYNJLf/cbtOQsDLf25eGdrknAInDIHYR4BY0OKkTQdkrsjTaZzNquATZdXPJnGJkS/Dr1GXJFwVw3RgXun0I8EIEp0yEW3Hs0AMwlFQsm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Df/UaCfW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Df/UaCfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C546C4CEED;
	Mon, 23 Jun 2025 22:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717604;
	bh=i5L+HbxuEhwwh8Y3q4oFmttZTqvW8MfEZUkliR54EJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Df/UaCfWRr9qzYG1zLEObTMS5Y8MVaJOr77Y5xrtGmQeSGojEQ4qL2r+Z2pZ0d9oc
	 7aJPlcoDOpTM9Enpw0Zb+VcnYljB9IO4Ta2r8njN4P1pz48pl8AAy9xNfCwpU+VCAU
	 dw/cJ5Y/LpQbS3Nh0HTy4fOcLeuA04dHRuxsYf7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.12 399/414] serial: sh-sci: Increment the runtime usage counter for the earlycon device
Date: Mon, 23 Jun 2025 15:08:56 +0200
Message-ID: <20250623130651.913249351@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 651dee03696e1dfde6d9a7e8664bbdcd9a10ea7f upstream.

In the sh-sci driver, serial ports are mapped to the sci_ports[] array,
with earlycon mapped at index zero.

The uart_add_one_port() function eventually calls __device_attach(),
which, in turn, calls pm_request_idle(). The identified code path is as
follows:

uart_add_one_port() ->
  serial_ctrl_register_port() ->
    serial_core_register_port() ->
      serial_core_port_device_add() ->
        serial_base_port_add() ->
          device_add() ->
            bus_probe_device() ->
              device_initial_probe() ->
                __device_attach() ->
                  // ...
                  if (dev->p->dead) {
                    // ...
                  } else if (dev->driver) {
                    // ...
                  } else {
                    // ...
                    pm_request_idle(dev);
                    // ...
                  }

The earlycon device clocks are enabled by the bootloader. However, the
pm_request_idle() call in __device_attach() disables the SCI port clocks
while earlycon is still active.

The earlycon write function, serial_console_write(), calls
sci_poll_put_char() via serial_console_putchar(). If the SCI port clocks
are disabled, writing to earlycon may sometimes cause the SR.TDFE bit to
remain unset indefinitely, causing the while loop in sci_poll_put_char()
to never exit. On single-core SoCs, this can result in the system being
blocked during boot when this issue occurs.

To resolve this, increment the runtime PM usage counter for the earlycon
SCI device before registering the UART port.

Fixes: 0b0cced19ab1 ("serial: sh-sci: Add CONFIG_SERIAL_EARLYCON support")
Cc: stable@vger.kernel.org
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250116182249.3828577-6-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -3455,6 +3455,22 @@ static int sci_probe_single(struct platf
 
 	if (sci_uart_earlycon && sci_ports[0].port.mapbase == sci_res->start) {
 		/*
+		 * In case:
+		 * - this is the earlycon port (mapped on index 0 in sci_ports[]) and
+		 * - it now maps to an alias other than zero and
+		 * - the earlycon is still alive (e.g., "earlycon keep_bootcon" is
+		 *   available in bootargs)
+		 *
+		 * we need to avoid disabling clocks and PM domains through the runtime
+		 * PM APIs called in __device_attach(). For this, increment the runtime
+		 * PM reference counter (the clocks and PM domains were already enabled
+		 * by the bootloader). Otherwise the earlycon may access the HW when it
+		 * has no clocks enabled leading to failures (infinite loop in
+		 * sci_poll_put_char()).
+		 */
+		pm_runtime_get_noresume(&dev->dev);
+
+		/*
 		 * Skip cleanup the sci_port[0] in early_console_exit(), this
 		 * port is the same as the earlycon one.
 		 */


