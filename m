Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8C63CB57C;
	Sat, 17 Oct 2026 18:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260120; cv=none; b=t79Ak6g6t6hBqCgDeB7vc8T2cHtEfmjUsDC8WpWKBXG5LfV1buTQpcPggtv0sa4nNcbl7SHliOgGXQ2zgA4Kalbhm/GH4yETKhVungvzVYb8fcKIr4QNnpnfjztpoXncCYdLHzh2Vqb8hkPDYVq8g2Ii/g48ognJiWdMH/3LNws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260120; c=relaxed/simple;
	bh=9htmpGkfu+EDzbgwpC2kdioFiXz+Of9mPSBQaEnj/G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNxnlCQBJzXXFOlvnflWZy9Y7PtAcTeDC8MGieKMNyNuN5EDd5F8Auwnb0csdKqQP19DpB9MS+D2A1yKnEOLVkt4LaX9pbBSjPMuP3KgjiWBaZs9qS0qM1IxvTdj8qZRC7oTcEXQxSBWlcv+x080dWP/1jYEU2Y1Vf19n8C1S24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NM/kBNBM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NM/kBNBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D537F1F000C4;
	Sat, 17 Oct 2026 18:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260119;
	bh=k/bv2deNBUKjbpydIFCQyZnyP08scEYROrH53dnE7k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NM/kBNBM3+sD7mt6tqOGGVFEq6Y8cBe7dHSdhojWaaCv+fPCl+ywjN0EWtt0R8iyZ
	 OHq7sVSAMU56RlY8ew7Mm/g/MKpFWY2ruWfO1Xn7JkbVox3ysspkPfYProRLym9VH8
	 quFetiC94fwPTIDoAHAt5ZMv/i9Rop1I5b67AWPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1439/1674] serial: core: do fallible allocations before the console can be registered
Date: Sat, 17 Oct 2026 18:01:51 +0200
Message-ID: <20261017160508.117705517@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ee5da5d2bc91d..d3abab6177b10 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3160,7 +3160,6 @@ static int serial_core_add_one_port(struct uart_driver *drv, struct uart_port *u
 	struct tty_port *port;
 	int ret = 0;
 	struct device *tty_dev;
-	int num_groups;
 
 	if (uport->line >= drv->nr)
 		return -EINVAL;
@@ -3174,6 +3173,25 @@ static int serial_core_add_one_port(struct uart_driver *drv, struct uart_port *u
 		goto out;
 	}
 
+	uport->name = kasprintf(GFP_KERNEL, "%s%d", drv->dev_name,
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
@@ -3183,12 +3201,6 @@ static int serial_core_add_one_port(struct uart_driver *drv, struct uart_port *u
 	state->pm_state = UART_PM_STATE_UNDEFINED;
 	uport->cons = drv->cons;
 	uport->minor = drv->tty_driver->minor_start + uport->line;
-	uport->name = kasprintf(GFP_KERNEL, "%s%d", drv->dev_name,
-				drv->tty_driver->name_base + uport->line);
-	if (!uport->name) {
-		ret = -ENOMEM;
-		goto out;
-	}
 
 	/*
 	 * If this port is in use as a console then the spinlock is already
@@ -3205,17 +3217,6 @@ static int serial_core_add_one_port(struct uart_driver *drv, struct uart_port *u
 
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



