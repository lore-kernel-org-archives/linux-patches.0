Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1169335BA0;
	Wed,  3 Dec 2025 15:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777205; cv=none; b=B4viC9+2LJ7FQAKsMXGARmx/yroFew8bhNN8LyOEjd0C1+anf39s+SkS6uLDEAFbLKw+P9mO1T2jCDJwWc/TnvewX9usVaSLqMdmRK7t9cuNySpv4Brj4tLDpJUr4GRdqz2k+ivHwR3R/VVnqdHUd7X8o2cSsSkKVpzNqbRgQEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777205; c=relaxed/simple;
	bh=oDeqMQ9hfvXn5JqimyL+BqqZ5rgijyOsK16dDk32+44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bNrBJVBffApmWXRKrga5O+uSO8ALmO6MjQ/eUDO8SgPDJjMZFhBvth/n4SWvVFaz8VxRHTu/fp0zQhXuzyu3zT2ptCazkoxOrxVxgLiMp1TwnUMVqtNYeHHOXkipRNbXx/3+lm5/e6hL2Wv3qTOwqIf5IyeEYdGQUvaxw271XjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJHvBLWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJHvBLWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A978C116B1;
	Wed,  3 Dec 2025 15:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777204;
	bh=oDeqMQ9hfvXn5JqimyL+BqqZ5rgijyOsK16dDk32+44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJHvBLWn0INQHS4XaMAnJdPbXJXbI817MqfQ1AJxGNdjVVRQjVNT3W6JwDhKDaQLn
	 JI5b88SM+3pRUFmuIOYZIIt6QEk85z32Ce2LjBcti1nl8XL590Z3OeorXDyWCSJig2
	 ETbothsGzkx/jwHPlCKoicjXcnJ+IiSdkv/zNt/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Alex Davis <alex47794@gmail.com>,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.17 107/146] serial: 8250: Fix 8250_rsa symbol loop
Date: Wed,  3 Dec 2025 16:28:05 +0100
Message-ID: <20251203152350.382374233@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 2bf95a9bcb50002ca9d47403d60aedaeb2e19abe upstream.

Depmod fails for a kernel made with:
  make allnoconfig
  echo -e "CONFIG_MODULES=y\nCONFIG_SERIAL_8250=m\nCONFIG_SERIAL_8250_EXTENDED=y\nCONFIG_SERIAL_8250_RSA=y" >> .config
  make olddefconfig

...due to a dependency loop:

  depmod: ERROR: Cycle detected: 8250 -> 8250_base -> 8250
  depmod: ERROR: Found 2 modules in dependency cycles!

This is caused by the move of 8250 RSA code from 8250_port.c (in
8250_base.ko) into 8250_rsa.c (in 8250.ko) by the commit 5a128fb475fb
("serial: 8250: move RSA functions to 8250_rsa.c"). The commit
b20d6576cdb3 ("serial: 8250: export RSA functions") tried to fix a
missing symbol issue with EXPORTs but those then cause this dependency
cycle.

Break dependency loop by moving 8250_rsa.o from 8250.ko to 8250_base.ko
and by passing univ8250_port_base_ops to univ8250_rsa_support() that
can make a local copy of it.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Alex Davis <alex47794@gmail.com>
Fixes: 5a128fb475fb ("serial: 8250: move RSA functions to 8250_rsa.c")
Fixes: b20d6576cdb3 ("serial: 8250: export RSA functions")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/all/87frc3sd8d.fsf@posteo.net/
Link: https://lore.kernel.org/all/CADiockCvM6v+d+UoFZpJSMoLAdpy99_h-hJdzUsdfaWGn3W7-g@mail.gmail.com/
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20251110105043.4062-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250.h          |    4 ++--
 drivers/tty/serial/8250/8250_platform.c |    2 +-
 drivers/tty/serial/8250/8250_rsa.c      |   26 +++++++++++++++++---------
 drivers/tty/serial/8250/Makefile        |    2 +-
 4 files changed, 21 insertions(+), 13 deletions(-)

--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -317,13 +317,13 @@ static inline void serial8250_pnp_exit(v
 #endif
 
 #ifdef CONFIG_SERIAL_8250_RSA
-void univ8250_rsa_support(struct uart_ops *ops);
+void univ8250_rsa_support(struct uart_ops *ops, const struct uart_ops *core_ops);
 void rsa_enable(struct uart_8250_port *up);
 void rsa_disable(struct uart_8250_port *up);
 void rsa_autoconfig(struct uart_8250_port *up);
 void rsa_reset(struct uart_8250_port *up);
 #else
-static inline void univ8250_rsa_support(struct uart_ops *ops) { }
+static inline void univ8250_rsa_support(struct uart_ops *ops, const struct uart_ops *core_ops) { }
 static inline void rsa_enable(struct uart_8250_port *up) {}
 static inline void rsa_disable(struct uart_8250_port *up) {}
 static inline void rsa_autoconfig(struct uart_8250_port *up) {}
--- a/drivers/tty/serial/8250/8250_platform.c
+++ b/drivers/tty/serial/8250/8250_platform.c
@@ -74,7 +74,7 @@ static void __init __serial8250_isa_init
 
 	/* chain base port ops to support Remote Supervisor Adapter */
 	univ8250_port_ops = *univ8250_port_base_ops;
-	univ8250_rsa_support(&univ8250_port_ops);
+	univ8250_rsa_support(&univ8250_port_ops, univ8250_port_base_ops);
 
 	if (share_irqs)
 		irqflag = IRQF_SHARED;
--- a/drivers/tty/serial/8250/8250_rsa.c
+++ b/drivers/tty/serial/8250/8250_rsa.c
@@ -14,6 +14,8 @@
 static unsigned long probe_rsa[PORT_RSA_MAX];
 static unsigned int probe_rsa_count;
 
+static const struct uart_ops *core_port_base_ops;
+
 static int rsa8250_request_resource(struct uart_8250_port *up)
 {
 	struct uart_port *port = &up->port;
@@ -67,7 +69,7 @@ static void univ8250_config_port(struct
 		}
 	}
 
-	univ8250_port_base_ops->config_port(port, flags);
+	core_port_base_ops->config_port(port, flags);
 
 	if (port->type != PORT_RSA && up->probe & UART_PROBE_RSA)
 		rsa8250_release_resource(up);
@@ -78,11 +80,11 @@ static int univ8250_request_port(struct
 	struct uart_8250_port *up = up_to_u8250p(port);
 	int ret;
 
-	ret = univ8250_port_base_ops->request_port(port);
+	ret = core_port_base_ops->request_port(port);
 	if (ret == 0 && port->type == PORT_RSA) {
 		ret = rsa8250_request_resource(up);
 		if (ret < 0)
-			univ8250_port_base_ops->release_port(port);
+			core_port_base_ops->release_port(port);
 	}
 
 	return ret;
@@ -94,15 +96,25 @@ static void univ8250_release_port(struct
 
 	if (port->type == PORT_RSA)
 		rsa8250_release_resource(up);
-	univ8250_port_base_ops->release_port(port);
+	core_port_base_ops->release_port(port);
 }
 
-void univ8250_rsa_support(struct uart_ops *ops)
+/*
+ * It is not allowed to directly reference any symbols from 8250.ko here as
+ * that would result in a dependency loop between the 8250.ko and
+ * 8250_base.ko modules. This function is called from 8250.ko and is used to
+ * break the symbolic dependency cycle. Anything that is needed from 8250.ko
+ * has to be passed as pointers to this function which then can adjust those
+ * variables on 8250.ko side or store them locally as needed.
+ */
+void univ8250_rsa_support(struct uart_ops *ops, const struct uart_ops *core_ops)
 {
+	core_port_base_ops = core_ops;
 	ops->config_port  = univ8250_config_port;
 	ops->request_port = univ8250_request_port;
 	ops->release_port = univ8250_release_port;
 }
+EXPORT_SYMBOL_FOR_MODULES(univ8250_rsa_support, "8250");
 
 module_param_hw_array(probe_rsa, ulong, ioport, &probe_rsa_count, 0444);
 MODULE_PARM_DESC(probe_rsa, "Probe I/O ports for RSA");
@@ -147,7 +159,6 @@ void rsa_enable(struct uart_8250_port *u
 	if (up->port.uartclk == SERIAL_RSA_BAUD_BASE * 16)
 		serial_out(up, UART_RSA_FRR, 0);
 }
-EXPORT_SYMBOL_FOR_MODULES(rsa_enable, "8250_base");
 
 /*
  * Attempts to turn off the RSA FIFO and resets the RSA board back to 115kbps compat mode. It is
@@ -179,7 +190,6 @@ void rsa_disable(struct uart_8250_port *
 		up->port.uartclk = SERIAL_RSA_BAUD_BASE_LO * 16;
 	uart_port_unlock_irq(&up->port);
 }
-EXPORT_SYMBOL_FOR_MODULES(rsa_disable, "8250_base");
 
 void rsa_autoconfig(struct uart_8250_port *up)
 {
@@ -192,7 +202,6 @@ void rsa_autoconfig(struct uart_8250_por
 	if (__rsa_enable(up))
 		up->port.type = PORT_RSA;
 }
-EXPORT_SYMBOL_FOR_MODULES(rsa_autoconfig, "8250_base");
 
 void rsa_reset(struct uart_8250_port *up)
 {
@@ -201,7 +210,6 @@ void rsa_reset(struct uart_8250_port *up
 
 	serial_out(up, UART_RSA_FRR, 0);
 }
-EXPORT_SYMBOL_FOR_MODULES(rsa_reset, "8250_base");
 
 #ifdef CONFIG_SERIAL_8250_DEPRECATED_OPTIONS
 #ifndef MODULE
--- a/drivers/tty/serial/8250/Makefile
+++ b/drivers/tty/serial/8250/Makefile
@@ -7,7 +7,6 @@ obj-$(CONFIG_SERIAL_8250)		+= 8250.o
 8250-y					:= 8250_core.o
 8250-y					+= 8250_platform.o
 8250-$(CONFIG_SERIAL_8250_PNP)		+= 8250_pnp.o
-8250-$(CONFIG_SERIAL_8250_RSA)		+= 8250_rsa.o
 
 obj-$(CONFIG_SERIAL_8250)		+= 8250_base.o
 8250_base-y				:= 8250_port.o
@@ -15,6 +14,7 @@ obj-$(CONFIG_SERIAL_8250)		+= 8250_base.
 8250_base-$(CONFIG_SERIAL_8250_DWLIB)	+= 8250_dwlib.o
 8250_base-$(CONFIG_SERIAL_8250_FINTEK)	+= 8250_fintek.o
 8250_base-$(CONFIG_SERIAL_8250_PCILIB)	+= 8250_pcilib.o
+8250_base-$(CONFIG_SERIAL_8250_RSA)	+= 8250_rsa.o
 
 obj-$(CONFIG_SERIAL_8250_CONSOLE)	+= 8250_early.o
 


