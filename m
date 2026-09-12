Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D0F36492C;
	Sat, 12 Sep 2026 08:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201437; cv=none; b=J8WfvocpyDsEeg5XgIXB27QmWYSIbsvECk88doKLKiUnzMgyooTQDDTnkKRr6LqIRGJyHdlXTPH951zZtudRkBk5castwaucdeUtEv8T7U4X/wLkzasE8WZ4M+XvXY7C4Ib4YLweAwO+3BesVDnx9H+ZnV6USI4CCJZ5iELC7TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201437; c=relaxed/simple;
	bh=dF79NW2QhcbaNW+UPxT6GBjFjrndRx6lzGmrq+/tVvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxPxCH6SLeAQyfp2d+g4vpDsw7DKSJwNIKXEM+tvh9/8Lk11LW1XMDUs2IJz+j0aAFC5LvQTdAck7sfr7NXgWiU3iNm2Kenc+cLw4FsxMScXUtKf8YpRZRXhVhbRLo9Sr6f5NEJ1FYDh+6PeEycwBsqNbSM38HsiaJTzjoMQVlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnenkWsG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnenkWsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99F81F000FF;
	Sat, 12 Sep 2026 08:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201436;
	bh=0+U6khZJ8/4XgPnch8bAjEn1j6zZF8D8yup8QmD2ycM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MnenkWsG9yz6F4d1p3o6sxGjJbl3N+S+XGyDoB3/7fdp0X/dLJbNt4x7mAr6lUcTo
	 I+/f02UXUsaaR7GvfzS/djBiMNUPa9kQrky8jqWX16HaRX64YqXal3ROB0nNLL1iw1
	 w93v4QZ3rpx8ufycI9FEH22dhPMyD2LuW8S+EZ1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0995/1815] serial: core: do fallible allocations before the console can be registered
Date: Sat, 12 Sep 2026 08:45:45 +0200
Message-ID: <20260912065712.356654021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/tty/serial/serial_core.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index a530ad372b434..03ee3d038f4e1 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3056,7 +3056,6 @@ static int serial_core_add_one_port(struct uart_driver *drv, struct uart_port *u
 	struct uart_state *state;
 	struct tty_port *port;
 	struct device *tty_dev;
-	int num_groups;
 
 	if (uport->line >= drv->nr)
 		return -EINVAL;
@@ -3068,6 +3067,22 @@ static int serial_core_add_one_port(struct uart_driver *drv, struct uart_port *u
 	if (state->uart_port)
 		return -EINVAL;
 
+	uport->name = kasprintf(GFP_KERNEL, "%s%u", drv->dev_name,
+				drv->tty_driver->name_base + uport->line);
+	if (!uport->name)
+		return -ENOMEM;
+
+	/*
+	 * uart_configure_port() may set uport->attr_group and register the
+	 * console. Allocate room for both groups and a NULL terminator first.
+	 */
+	uport->tty_groups = kzalloc_objs(*uport->tty_groups, 3);
+	if (!uport->tty_groups) {
+		kfree(uport->name);
+		return -ENOMEM;
+	}
+	uport->tty_groups[0] = &tty_dev_attr_group;
+
 	/* Link the port to the driver state table and vice versa */
 	atomic_set(&state->refcount, 1);
 	init_waitqueue_head(&state->remove_wait);
@@ -3084,10 +3099,6 @@ static int serial_core_add_one_port(struct uart_driver *drv, struct uart_port *u
 	state->pm_state = UART_PM_STATE_UNDEFINED;
 	uart_port_set_cons(uport, drv->cons);
 	uport->minor = drv->tty_driver->minor_start + uport->line;
-	uport->name = kasprintf(GFP_KERNEL, "%s%u", drv->dev_name,
-				drv->tty_driver->name_base + uport->line);
-	if (!uport->name)
-		return -ENOMEM;
 
 	if (uport->cons && uport->dev)
 		of_console_check(uport->dev->of_node, uport->cons->name, uport->line);
@@ -3102,15 +3113,6 @@ static int serial_core_add_one_port(struct uart_driver *drv, struct uart_port *u
 
 	port->console = uart_console(uport);
 
-	num_groups = 2;
-	if (uport->attr_group)
-		num_groups++;
-
-	uport->tty_groups = kzalloc_objs(*uport->tty_groups, num_groups);
-	if (!uport->tty_groups)
-		return -ENOMEM;
-
-	uport->tty_groups[0] = &tty_dev_attr_group;
 	if (uport->attr_group)
 		uport->tty_groups[1] = uport->attr_group;
 
-- 
2.53.0



