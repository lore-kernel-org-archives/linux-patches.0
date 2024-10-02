Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375331D07BC;
	Wed,  2 Oct 2024 14:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880533; cv=none; b=eteYUYiEcED5Tu5KcU0/Wo4zmQmb1H6WpVknyWGqwOU8HeOyZBK273YkaOtzcXgxZ4H4CXkhpKgofLEghc3HDerqfM92iZTOyKt21Sesi/UbIoGVJnyTi2N3DzhA8AK9O9QwbowwpTv60BhF/Rly2t3BYiNc4+9cVZEhZnjqGLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880533; c=relaxed/simple;
	bh=xT///9N7eW7W/budWTyZ1Wk2bwTuXYHVe40Q0aThB/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7iWBO90tJYPWtgeFglQuutKURAXHyYAfS5juWsC5x2g6s+0+R32b5lFg+v4nz9je0sULddD1kV49IA0gZH7SwXwUY5NQHHQOmqqTPPkrMod7Oa/xlrrci7IlKpdAR6JjYHH5Q9NCxHkCfa45QDIctdzCsB1k7UUZY9WuhmiB1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0S0ErNrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0S0ErNrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B352BC4CECD;
	Wed,  2 Oct 2024 14:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880533;
	bh=xT///9N7eW7W/budWTyZ1Wk2bwTuXYHVe40Q0aThB/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0S0ErNrLtWgn6uBxtu4V402c2iaLcqQEv35jcj3vWUixO4NucToQ3Uoyo8raASsPj
	 LZw3Z4VA4d8z5jCDnP5HsDHo6U/r6ej+BT3YU/MSb7PwK3ErHzVFmTtNzBK8d8/nyT
	 QkDdhX1IU7GAarnuN6k5w8bslQ1L3BFy/5eSnMYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Michael Trimarchi <michael@amarulasolutions.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 491/538] tty: serial: kgdboc: Fix 8250_* kgdb over serial
Date: Wed,  2 Oct 2024 15:02:10 +0200
Message-ID: <20241002125811.821465832@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Trimarchi <michael@amarulasolutions.com>

[ Upstream commit 788aeef392d27545ae99af2875068a9dd0531d5f ]

Check if port type is not PORT_UNKNOWN during poll_init.
The kgdboc calls the tty_find_polling_driver that check
if the serial is able to use poll_init. The poll_init calls
the uart uart_poll_init that try to configure the uart with the
selected boot parameters. The uart must be ready before setting
parameters. Seems that PORT_UNKNOWN is already used by other
functions in serial_core to detect uart status, so use the same
to avoid to use it in invalid state.

The crash happen for instance in am62x architecture where the 8250
register the platform driver after the 8250 core is initialized.

Follow the report crash coming from KGDB

Thread 2 received signal SIGSEGV, Segmentation fault.
[Switching to Thread 1]
_outb (addr=<optimized out>, value=<optimized out>) at ./include/asm-generic/io.h:584
584		__raw_writeb(value, PCI_IOBASE + addr);
(gdb) bt

This section of the code is too early because in this case
the omap serial is not probed

Thread 2 received signal SIGSEGV, Segmentation fault.
[Switching to Thread 1]
_outb (addr=<optimized out>, value=<optimized out>) at ./include/asm-generic/io.h:584
584		__raw_writeb(value, PCI_IOBASE + addr);
(gdb) bt

Thread 2 received signal SIGSEGV, Segmentation fault.
[Switching to Thread 1]
_outb (addr=<optimized out>, value=<optimized out>) at ./include/asm-generic/io.h:584
584		__raw_writeb(value, PCI_IOBASE + addr);
(gdb) bt
0  _outb (addr=<optimized out>, value=<optimized out>) at ./include/asm-generic/io.h:584
1  logic_outb (value=0 '\000', addr=18446739675637874689) at lib/logic_pio.c:299
2  0xffff80008082dfcc in io_serial_out (p=0x0, offset=16760830, value=0) at drivers/tty/serial/8250/8250_port.c:416
3  0xffff80008082fe34 in serial_port_out (value=<optimized out>, offset=<optimized out>, up=<optimized out>)
    at ./include/linux/serial_core.h:677
4  serial8250_do_set_termios (port=0xffff8000828ee940 <serial8250_ports+1568>, termios=0xffff80008292b93c, old=0x0)
    at drivers/tty/serial/8250/8250_port.c:2860
5  0xffff800080830064 in serial8250_set_termios (port=0xfffffbfffe800000, termios=0xffbffe, old=0x0)
    at drivers/tty/serial/8250/8250_port.c:2912
6  0xffff80008082571c in uart_set_options (port=0xffff8000828ee940 <serial8250_ports+1568>, co=0x0, baud=115200, parity=110, bits=8, flow=110)
    at drivers/tty/serial/serial_core.c:2285
7  0xffff800080828434 in uart_poll_init (driver=0xfffffbfffe800000, line=16760830, options=0xffff8000828f7506 <config+6> "115200n8")
    at drivers/tty/serial/serial_core.c:2656
8  0xffff800080801690 in tty_find_polling_driver (name=0xffff8000828f7500 <config> "ttyS2,115200n8", line=0xffff80008292ba90)
    at drivers/tty/tty_io.c:410
9  0xffff80008086c0b0 in configure_kgdboc () at drivers/tty/serial/kgdboc.c:194
10 0xffff80008086c1ec in kgdboc_probe (pdev=0xfffffbfffe800000) at drivers/tty/serial/kgdboc.c:249
11 0xffff8000808b399c in platform_probe (_dev=0xffff000000ebb810) at drivers/base/platform.c:1404
12 0xffff8000808b0b44 in call_driver_probe (drv=<optimized out>, dev=<optimized out>) at drivers/base/dd.c:579
13 really_probe (dev=0xffff000000ebb810, drv=0xffff80008277f138 <kgdboc_platform_driver+48>) at drivers/base/dd.c:658
14 0xffff8000808b0d2c in __driver_probe_device (drv=0xffff80008277f138 <kgdboc_platform_driver+48>, dev=0xffff000000ebb810)
    at drivers/base/dd.c:800
15 0xffff8000808b0eb8 in driver_probe_device (drv=0xfffffbfffe800000, dev=0xffff000000ebb810) at drivers/base/dd.c:830
16 0xffff8000808b0ff4 in __device_attach_driver (drv=0xffff80008277f138 <kgdboc_platform_driver+48>, _data=0xffff80008292bc48)
    at drivers/base/dd.c:958
17 0xffff8000808ae970 in bus_for_each_drv (bus=0xfffffbfffe800000, start=0x0, data=0xffff80008292bc48,
    fn=0xffff8000808b0f3c <__device_attach_driver>) at drivers/base/bus.c:457
18 0xffff8000808b1408 in __device_attach (dev=0xffff000000ebb810, allow_async=true) at drivers/base/dd.c:1030
19 0xffff8000808b16d8 in device_initial_probe (dev=0xfffffbfffe800000) at drivers/base/dd.c:1079
20 0xffff8000808af9f4 in bus_probe_device (dev=0xffff000000ebb810) at drivers/base/bus.c:532
21 0xffff8000808ac77c in device_add (dev=0xfffffbfffe800000) at drivers/base/core.c:3625
22 0xffff8000808b3428 in platform_device_add (pdev=0xffff000000ebb800) at drivers/base/platform.c:716
23 0xffff800081b5dc0c in init_kgdboc () at drivers/tty/serial/kgdboc.c:292
24 0xffff800080014db0 in do_one_initcall (fn=0xffff800081b5dba4 <init_kgdboc>) at init/main.c:1236
25 0xffff800081b0114c in do_initcall_level (command_line=<optimized out>, level=<optimized out>) at init/main.c:1298
26 do_initcalls () at init/main.c:1314
27 do_basic_setup () at init/main.c:1333
28 kernel_init_freeable () at init/main.c:1551
29 0xffff8000810271ec in kernel_init (unused=0xfffffbfffe800000) at init/main.c:1441
30 0xffff800080015e80 in ret_from_fork () at arch/arm64/kernel/entry.S:857

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
Link: https://lore.kernel.org/r/20231224131200.266224-1-michael@amarulasolutions.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: d0009a32c9e4 ("serial: don't use uninitialized value in uart_poll_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index ed8798fdf522a..3fb55f46a8914 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2697,7 +2697,8 @@ static int uart_poll_init(struct tty_driver *driver, int line, char *options)
 	mutex_lock(&tport->mutex);
 
 	port = uart_port_check(state);
-	if (!port || !(port->ops->poll_get_char && port->ops->poll_put_char)) {
+	if (!port || port->type == PORT_UNKNOWN ||
+	    !(port->ops->poll_get_char && port->ops->poll_put_char)) {
 		ret = -1;
 		goto out;
 	}
-- 
2.43.0



