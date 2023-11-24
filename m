Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CA0286B5;
	Fri, 24 Nov 2023 18:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnUI0nJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDC5C433C8;
	Fri, 24 Nov 2023 18:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852004;
	bh=+FY6OxSJkjCLyxAD3zjAg8/p+YbqKDPXcJDcqZKQFRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnUI0nJJHSxHszZkNiRyqAEzPhEgS/IHEc0x3gT7RVRv6bVRXOV8GEDJQeIHqj5i3
	 zCXa5mmh+o+eSlhaA+2llcTe9WtGmMx50niEXLx52Fw4xIrtroSd3lwjb7XJYGRmZh
	 bqoo/FlNTRBnOknpMPs2Deng+uti2vEjAJwQKI38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Krasavin <pkrasavin@imaqliq.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Rokosov <ddrokosov@salutedevices.com>
Subject: [PATCH 6.1 181/372] tty: serial: meson: fix hard LOCKUP on crtscts mode
Date: Fri, 24 Nov 2023 17:49:28 +0000
Message-ID: <20231124172016.498535623@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Krasavin <pkrasavin@imaqliq.com>

commit 2a1d728f20edeee7f26dc307ed9df4e0d23947ab upstream.

There might be hard lockup if we set crtscts mode on port without RTS/CTS configured:

# stty -F /dev/ttyAML6 crtscts; echo 1 > /dev/ttyAML6; echo 2 > /dev/ttyAML6
[   95.890386] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[   95.890857] rcu:     3-...0: (201 ticks this GP) idle=e33c/1/0x4000000000000000 softirq=5844/5846 fqs=4984
[   95.900212] rcu:     (detected by 2, t=21016 jiffies, g=7753, q=296 ncpus=4)
[   95.906972] Task dump for CPU 3:
[   95.910178] task:bash            state:R  running task     stack:0     pid:205   ppid:1      flags:0x00000202
[   95.920059] Call trace:
[   95.922485]  __switch_to+0xe4/0x168
[   95.925951]  0xffffff8003477508
[   95.974379] watchdog: Watchdog detected hard LOCKUP on cpu 3
[   95.974424] Modules linked in: 88x2cs(O) rtc_meson_vrtc

Possible solution would be to not allow to setup crtscts on such port.

Tested on S905X3 based board.

Fixes: ff7693d079e5 ("ARM: meson: serial: add MesonX SoC on-chip uart driver")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Krasavin <pkrasavin@imaqliq.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Dmitry Rokosov <ddrokosov@salutedevices.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/meson_uart.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/meson_uart.c
+++ b/drivers/tty/serial/meson_uart.c
@@ -380,10 +380,14 @@ static void meson_uart_set_termios(struc
 	else
 		val |= AML_UART_STOP_BIT_1SB;
 
-	if (cflags & CRTSCTS)
-		val &= ~AML_UART_TWO_WIRE_EN;
-	else
+	if (cflags & CRTSCTS) {
+		if (port->flags & UPF_HARD_FLOW)
+			val &= ~AML_UART_TWO_WIRE_EN;
+		else
+			termios->c_cflag &= ~CRTSCTS;
+	} else {
 		val |= AML_UART_TWO_WIRE_EN;
+	}
 
 	writel(val, port->membase + AML_UART_CONTROL);
 
@@ -698,6 +702,7 @@ static int meson_uart_probe(struct platf
 	u32 fifosize = 64; /* Default is 64, 128 for EE UART_0 */
 	int ret = 0;
 	int irq;
+	bool has_rtscts;
 
 	if (pdev->dev.of_node)
 		pdev->id = of_alias_get_id(pdev->dev.of_node, "serial");
@@ -725,6 +730,7 @@ static int meson_uart_probe(struct platf
 		return irq;
 
 	of_property_read_u32(pdev->dev.of_node, "fifo-size", &fifosize);
+	has_rtscts = of_property_read_bool(pdev->dev.of_node, "uart-has-rtscts");
 
 	if (meson_ports[pdev->id]) {
 		dev_err(&pdev->dev, "port %d already allocated\n", pdev->id);
@@ -744,6 +750,8 @@ static int meson_uart_probe(struct platf
 	port->mapsize = resource_size(res_mem);
 	port->irq = irq;
 	port->flags = UPF_BOOT_AUTOCONF | UPF_LOW_LATENCY;
+	if (has_rtscts)
+		port->flags |= UPF_HARD_FLOW;
 	port->has_sysrq = IS_ENABLED(CONFIG_SERIAL_MESON_CONSOLE);
 	port->dev = &pdev->dev;
 	port->line = pdev->id;


