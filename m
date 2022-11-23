Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623C51C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9405DC433C1;
	Wed, 23 Nov 2022 09:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195269;
	bh=wjX57u5osdOPfI3ShBegGvmaL++AdfPr8lU+F2tIDs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sirgIzp79EcAnEmh50Cw2hMoyfXDEJp17bC0eW3UviLBZg/UBx6Rtir4ea+Zni7M5
	 nSCe+p0RitFnCm2gTlWxn52jR+rsI4A7xUUjy9Zpy6vpQkqOXs3ng3mnwq+F1ksK50
	 quI7PXzIfInYR8+t/wAped+A9iV5sFC+F96TGNKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Merlijn Wajer <merlijn@wizzup.org>,
	Romain Naour <romain.naour@smile.fr>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/149] serial: 8250: omap: Fix missing PM runtime calls for omap8250_set_mctrl()
Date: Wed, 23 Nov 2022 09:50:20 +0100
Message-Id: <20221123084559.326531155@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 93810191f5d23652c0b8a1a9b3a4a89d6fd5063e ]

There are cases where omap8250_set_mctrl() may get called after the
UART has already autoidled causing an asynchronous external abort.

This can happen on ttyport_open():

mem_serial_in from omap8250_set_mctrl+0x38/0xa0
omap8250_set_mctrl from uart_update_mctrl+0x4c/0x58
uart_update_mctrl from uart_dtr_rts+0x60/0xa8
uart_dtr_rts from tty_port_block_til_ready+0xd0/0x2a8
tty_port_block_til_ready from uart_open+0x14/0x1c
uart_open from ttyport_open+0x64/0x148

And on ttyport_close():

omap8250_set_mctrl from uart_update_mctrl+0x3c/0x48
uart_update_mctrl from uart_dtr_rts+0x54/0x9c
uart_dtr_rts from tty_port_shutdown+0x78/0x9c
tty_port_shutdown from tty_port_close+0x3c/0x74
tty_port_close from ttyport_close+0x40/0x58

It can also happen on disassociate_ctty() calling uart_shutdown()
that ends up calling omap8250_set_mctrl().

Let's fix the issue by adding missing PM runtime calls to
omap8250_set_mctrl(). To do this, we need to add __omap8250_set_mctrl()
that can be called from both omap8250_set_mctrl(), and from runtime PM
resume path when restoring the registers.

Fixes: 61929cf0169d ("tty: serial: Add 8250-core based omap driver")
Reported-by: Merlijn Wajer <merlijn@wizzup.org>
Reported-by: Romain Naour <romain.naour@smile.fr>
Reported-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Tested-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Depends-on: dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
Link: https://lore.kernel.org/r/20221024063613.25943-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index f3744ac805ec..7c7cfd6d48d8 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -157,7 +157,11 @@ static u32 uart_read(struct uart_8250_port *up, u32 reg)
 	return readl(up->port.membase + (reg << up->port.regshift));
 }
 
-static void omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
+/*
+ * Called on runtime PM resume path from omap8250_restore_regs(), and
+ * omap8250_set_mctrl().
+ */
+static void __omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
 	struct omap8250_priv *priv = up->port.private_data;
@@ -181,6 +185,20 @@ static void omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 	}
 }
 
+static void omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	int err;
+
+	err = pm_runtime_resume_and_get(port->dev);
+	if (err)
+		return;
+
+	__omap8250_set_mctrl(port, mctrl);
+
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
+}
+
 /*
  * Work Around for Errata i202 (2430, 3430, 3630, 4430 and 4460)
  * The access to uart register after MDR1 Access
@@ -341,7 +359,7 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 
 	omap8250_update_mdr1(up, priv);
 
-	up->port.ops->set_mctrl(&up->port, up->port.mctrl);
+	__omap8250_set_mctrl(&up->port, up->port.mctrl);
 
 	if (up->port.rs485.flags & SER_RS485_ENABLED)
 		serial8250_em485_stop_tx(up);
-- 
2.35.1



