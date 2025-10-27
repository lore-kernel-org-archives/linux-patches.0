Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD58932C925;
	Mon, 27 Oct 2025 19:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593537; cv=none; b=ti4ODuYqtQEE34GD65kpE3jhEQqbuJtqEoulsNKjNDw2BRitwEW7qV1ldUv56NV4hQCN1ilpaq1IxYnJKKGMiq716yWyPxstC7gReauuzVGAWS9iMdpcenixncdr8RXqFAaZykrN8aHced6j66R3fe8rG6Pz/1kwAtbZYSWIBvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593537; c=relaxed/simple;
	bh=vdy6r1QMioIRQFCyEVCXTzhvoVh8XG0iZ/6tRjVZSK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qw4cr/pBuo+IHoRb43yqG3KIq5Aen9CckVZDjlSMsT8zLUvhFxq5Dlnkv7cK4S+HVNSNBek/TqPoKLJcj9F8sPHopcN1gHdUEtk8y7hs/EqyKYQ98wT6drF6/6tny+7k3dNG4iIHLveVe1MLqgcb70T8usw+oDtwhM5mUwN+VOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sN72UoSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sN72UoSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524D6C4CEF1;
	Mon, 27 Oct 2025 19:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593537;
	bh=vdy6r1QMioIRQFCyEVCXTzhvoVh8XG0iZ/6tRjVZSK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sN72UoSYqyufGwVg5ey0AQQ/3DoWHtRtAQ0X/PBLeQhz333a/vPYox028DeEWT+C/
	 QzxpUoWqpQjFQppP/cPkZAvX7zydX+GJOMllWIeUOw4TheJvQhB/nQajJs290iY3Sb
	 5XR2ToaEDlas86hKWBag2Z90s08zZ85r+VUB+1GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Subject: [PATCH 6.17 166/184] tty: serial: sh-sci: fix RSCI FIFO overrun handling
Date: Mon, 27 Oct 2025 19:37:28 +0100
Message-ID: <20251027183519.395438915@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>

commit ef8fef45c74b5a0059488fda2df65fa133f7d7d0 upstream.

The receive error handling code is shared between RSCI and all other
SCIF port types, but the RSCI overrun_reg is specified as a memory
offset, while for other SCIF types it is an enum value used to index
into the sci_port_params->regs array, as mentioned above the
sci_serial_in() function.

For RSCI, the overrun_reg is CSR (0x48), causing the sci_getreg() call
inside the sci_handle_fifo_overrun() function to index outside the
bounds of the regs array, which currently has a size of 20, as specified
by SCI_NR_REGS.

Because of this, we end up accessing memory outside of RSCI's
rsci_port_params structure, which, when interpreted as a plat_sci_reg,
happens to have a non-zero size, causing the following WARN when
sci_serial_in() is called, as the accidental size does not match the
supported register sizes.

The existence of the overrun_reg needs to be checked because
SCIx_SH3_SCIF_REGTYPE has overrun_reg set to SCLSR, but SCLSR is not
present in the regs array.

Avoid calling sci_getreg() for port types which don't use standard
register handling.

Use the ops->read_reg() and ops->write_reg() functions to properly read
and write registers for RSCI, and change the type of the status variable
to accommodate the 32-bit CSR register.

sci_getreg() and sci_serial_in() are also called with overrun_reg in the
sci_mpxed_interrupt() interrupt handler, but that code path is not used
for RSCI, as it does not have a muxed interrupt.

------------[ cut here ]------------
Invalid register access
WARNING: CPU: 0 PID: 0 at drivers/tty/serial/sh-sci.c:522 sci_serial_in+0x38/0xac
Modules linked in: renesas_usbhs at24 rzt2h_adc industrialio_adc sha256 cfg80211 bluetooth ecdh_generic ecc rfkill fuse drm backlight ipv6
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.17.0-rc1+ #30 PREEMPT
Hardware name: Renesas RZ/T2H EVK Board based on r9a09g077m44 (DT)
pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : sci_serial_in+0x38/0xac
lr : sci_serial_in+0x38/0xac
sp : ffff800080003e80
x29: ffff800080003e80 x28: ffff800082195b80 x27: 000000000000000d
x26: ffff8000821956d0 x25: 0000000000000000 x24: ffff800082195b80
x23: ffff000180e0d800 x22: 0000000000000010 x21: 0000000000000000
x20: 0000000000000010 x19: ffff000180e72000 x18: 000000000000000a
x17: ffff8002bcee7000 x16: ffff800080000000 x15: 0720072007200720
x14: 0720072007200720 x13: 0720072007200720 x12: 0720072007200720
x11: 0000000000000058 x10: 0000000000000018 x9 : ffff8000821a6a48
x8 : 0000000000057fa8 x7 : 0000000000000406 x6 : ffff8000821fea48
x5 : ffff00033ef88408 x4 : ffff8002bcee7000 x3 : ffff800082195b80
x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff800082195b80
Call trace:
 sci_serial_in+0x38/0xac (P)
 sci_handle_fifo_overrun.isra.0+0x70/0x134
 sci_er_interrupt+0x50/0x39c
 __handle_irq_event_percpu+0x48/0x140
 handle_irq_event+0x44/0xb0
 handle_fasteoi_irq+0xf4/0x1a0
 handle_irq_desc+0x34/0x58
 generic_handle_domain_irq+0x1c/0x28
 gic_handle_irq+0x4c/0x140
 call_on_irq_stack+0x30/0x48
 do_interrupt_handler+0x80/0x84
 el1_interrupt+0x34/0x68
 el1h_64_irq_handler+0x18/0x24
 el1h_64_irq+0x6c/0x70
 default_idle_call+0x28/0x58 (P)
 do_idle+0x1f8/0x250
 cpu_startup_entry+0x34/0x3c
 rest_init+0xd8/0xe0
 console_on_rootfs+0x0/0x6c
 __primary_switched+0x88/0x90
---[ end trace 0000000000000000 ]---

Cc: stable <stable@kernel.org>
Fixes: 0666e3fe95ab ("serial: sh-sci: Add support for RZ/T2H SCI")
Signed-off-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Link: https://patch.msgid.link/20250923154707.1089900-1-cosmin-gabriel.tanislav.xa@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 538b2f991609..62bb62b82cbe 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1014,16 +1014,18 @@ static int sci_handle_fifo_overrun(struct uart_port *port)
 	struct sci_port *s = to_sci_port(port);
 	const struct plat_sci_reg *reg;
 	int copied = 0;
-	u16 status;
+	u32 status;
 
-	reg = sci_getreg(port, s->params->overrun_reg);
-	if (!reg->size)
-		return 0;
+	if (s->type != SCI_PORT_RSCI) {
+		reg = sci_getreg(port, s->params->overrun_reg);
+		if (!reg->size)
+			return 0;
+	}
 
-	status = sci_serial_in(port, s->params->overrun_reg);
+	status = s->ops->read_reg(port, s->params->overrun_reg);
 	if (status & s->params->overrun_mask) {
 		status &= ~s->params->overrun_mask;
-		sci_serial_out(port, s->params->overrun_reg, status);
+		s->ops->write_reg(port, s->params->overrun_reg, status);
 
 		port->icount.overrun++;
 
-- 
2.51.1



