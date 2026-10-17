Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0FD3ABD99;
	Sat, 17 Oct 2026 16:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255107; cv=none; b=RjJLbba5cQU1naWG0zbEhgAdBw/ndnlRMtLxUBNo2MgQRuYpdj5JFydsjt97cLKSvi0n081kzTS7SEO2XkvLQeV6bOJ2XaXhwZNHgGBuJYbmdlcumTCoehErwo0vZlgGpZmkCIkXGijp29JJQI57sx09RPRtMUujORbuhwCvRUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255107; c=relaxed/simple;
	bh=9P+ZpHLWXmB/o/miD3j01JW+KfYliMOyrxTxqiZH0Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keFL/Ak+A2huqGDE3m8H2v2bMliPlQER5hY6vrE/atCzc3Ory2Z6/itGzeDf3NvlNnlo02Ioo1J57H9ICfJYze3fwy2OxfI/CELDPXFzrSgzMk5C8MBN0lOc2UYOk/7fu10QHUuW97SOJ36+UMg6KHVW1wOiZACnvUSJWYyXl8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1LJpIrB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1LJpIrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E79D1F000C4;
	Sat, 17 Oct 2026 16:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255106;
	bh=AfNLJIk1lQ3yT3bEGvB/578jadpATEDgEuVW4bGD3ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1LJpIrBMNzqAtWYZDE/Dr8blsgiw/dVjViwtoI13lAweRtFn+sjwPlE5+Xb3d1F+
	 ks44VLRu4RE0sGJl5mxXNQxjL7jPsyXdQkK+Ib5AtaW/4IOjJRw5Bo53AjWx9fEYct
	 vqsUEudNJGVWdzWhoPA+aFQRQYLxebEWD5HiZ3Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 668/869] serial: core: do fallible allocations before the console can be registered
Date: Sat, 17 Oct 2026 17:58:29 +0200
Message-ID: <20261017160054.119058898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 1a0e4fbce5d9c1bc179a35a2fd9ed142664299e3 ]

serial_core_add_one_port() allocates uport->tty_groups after
uart_configure_port(), which may register the console. If the allocation
fails, the driver unwinds the port while its console remains registered.
The earlier uport->name allocation has a related failure path that leaves
state->uart_port linked to a port being freed.

Failslab reproduced a NULL dereference in PL011 console output and a KASAN
use-after-free in i.MX console output after failed binds.

Allocate the name and tty_groups before linking the port and configuring
it. Reserve space for the optional driver attribute group because
config_port() may populate uport->attr_group during configuration.

Fixes: 266dcff03eed ("Serial: allow port drivers to have a default attribute group")
Fixes: f7048b15900f ("tty: serial_core: Add name field to uart_port struct")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260719070454.D6FA21F000E9@smtp.kernel.org/
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260731181844.11330-2-kmehltretter@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 37 ++++++++++++++++----------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 2da161227200a..230df69c9f932 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3144,7 +3144,6 @@ static int serial_core_add_one_port(struct uart_driver *drv, struct uart_port *u
 	struct tty_port *port;
 	int ret = 0;
 	struct device *tty_dev;
-	int num_groups;
 
 	if (uport->line >= drv->nr)
 		return -EINVAL;
@@ -3158,6 +3157,25 @@ static int serial_core_add_one_port(struct uart_driver *drv, struct uart_port *u
 		goto out;
 	}
 
+	uport->name = kasprintf(GFP_KERNEL, "%s%u", drv->dev_name,
+				drv->tty_driver->name_base + uport->line);
+	if (!uport->name) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/*
+	 * uart_configure_port() may set uport->attr_group and register the
+	 * console. Allocate room for both groups and a NULL terminator first.
+	 */
+	uport->tty_groups = kcalloc(3, sizeof(*uport->tty_groups), GFP_KERNEL);
+	if (!uport->tty_groups) {
+		kfree(uport->name);
+		ret = -ENOMEM;
+		goto out;
+	}
+	uport->tty_groups[0] = &tty_dev_attr_group;
+
 	/* Link the port to the driver state table and vice versa */
 	atomic_set(&state->refcount, 1);
 	init_waitqueue_head(&state->remove_wait);
@@ -3174,12 +3192,6 @@ static int serial_core_add_one_port(struct uart_driver *drv, struct uart_port *u
 	state->pm_state = UART_PM_STATE_UNDEFINED;
 	uart_port_set_cons(uport, drv->cons);
 	uport->minor = drv->tty_driver->minor_start + uport->line;
-	uport->name = kasprintf(GFP_KERNEL, "%s%u", drv->dev_name,
-				drv->tty_driver->name_base + uport->line);
-	if (!uport->name) {
-		ret = -ENOMEM;
-		goto out;
-	}
 
 	if (uport->cons && uport->dev)
 		of_console_check(uport->dev->of_node, uport->cons->name, uport->line);
@@ -3189,17 +3201,6 @@ static int serial_core_add_one_port(struct uart_driver *drv, struct uart_port *u
 
 	port->console = uart_console(uport);
 
-	num_groups = 2;
-	if (uport->attr_group)
-		num_groups++;
-
-	uport->tty_groups = kcalloc(num_groups, sizeof(*uport->tty_groups),
-				    GFP_KERNEL);
-	if (!uport->tty_groups) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	uport->tty_groups[0] = &tty_dev_attr_group;
 	if (uport->attr_group)
 		uport->tty_groups[1] = uport->attr_group;
 
-- 
2.53.0



