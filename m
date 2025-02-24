Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E94527701;
	Mon, 24 Feb 2025 14:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408805; cv=none; b=DK9iKJ7gSY/Nt0IoxkR/86dXYjneHi3Z6qzUVCt1ca5kZUTe+C96CrtgEtBnJO/9sFAdCELay1K3yBlUOsXkhnnTtJnEe07T8PdgUonHmv98ylPS6XTrQQ8whlFMbqsv0SoIQijoQUw/1fCUrFOj9nPVAxqjztMeOogWAX0Kv7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408805; c=relaxed/simple;
	bh=G3o/VtsRQiPs3keLTYGcTvCCozDFeZE1TCEr+PKDMTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyN9sbEMwBHPEMiHXKGwYXth4HRnCNzCbzuwx+EvF7HQoEbuhzdTRlgFqVrIufOfnml5Sp9CQ6LoHRYEDWvuO6yiiIeE1FSQQVek3MXatuxtLdDrMlIz/kyrsdvk4Vr+xhRIwmI8y0LkWia/7e8SnpD2J5o39N9jXzsFSzA5LgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7LaUvtc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7LaUvtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE5FC4CED6;
	Mon, 24 Feb 2025 14:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408805;
	bh=G3o/VtsRQiPs3keLTYGcTvCCozDFeZE1TCEr+PKDMTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I7LaUvtcfIgyOIanvhk7O0HYrgPpQlZPX2pu3NK2NsDFvfmXRw+F/77A6D6VMUh/y
	 isrv8ojUgguD9TgSqDd3+0cX+yxUDgnR1x4zGo+ZtMeTinXWRw/wbQXw+mBlSCMc1l
	 6Pmb8KqCkQebM2pkzID2j4KEPLhnZzlAOuR5VDtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 011/138] serial: sh-sci: Increment the runtime usage counter for the earlycon device
Date: Mon, 24 Feb 2025 15:34:01 +0100
Message-ID: <20250224142604.904040579@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 651dee03696e1dfde6d9a7e8664bbdcd9a10ea7f ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sh-sci.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 12215d4107d1c..1a050ec9912cb 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -3436,6 +3436,22 @@ static int sci_probe_single(struct platform_device *dev,
 	}
 
 	if (sci_uart_earlycon && sci_ports[0].port.mapbase == sci_res->start) {
+		/*
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
 		/*
 		 * Skip cleanup the sci_port[0] in early_console_exit(), this
 		 * port is the same as the earlycon one.
-- 
2.39.5



