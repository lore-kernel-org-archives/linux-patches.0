Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216526;
	b=2v0j1EU/dy9+aVAovz7flyF4qd2nS/zfTo1fswPWmKppNALJ2oup+EGj0trsFceb4w6o
	 7kchCWRGQYEpbQhCPNkbe3zEsX1YyIzjUzlzr/4tw+zwQNLqQ2MT5HmIKC8bl3hqd1Eom
	 qTZ25DsnBBlDHsHZJrVZOwI9usZtxAVtXvRyc07g0tx5RnqKXsxbkSyxYAE1+b2QJ4bjT
	 z09TpMEkqHBi+RfPCuzu41mOfP9oTJ8CUdE3PejdkLDXdHY2jBBmbkm0+ldtJuCqL+Gdv
	 F+EuLRKi4pbaQnUN75AeY8HAmrNqN1Tdb2A97mbADPhM/IEzeX19145adQknBGYeTyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216526;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0nHudbokOex7dUKaCMF+/WCWOzCYXPBdhCzbA0VcYfM=;
	b=sS1AfGKu7GM14YBWUXGO+SVr9BL0lfqvBwADVmYEW4cgiKEUGX2v1/fM+kdE6bEEDhNs
	 BUiDQNG1bfsgPrC3BZCXQ+Fj+zC8BdvmAIUsqEAudDMR7W367RQtFxk8X8D6mDUntcPmd
	 3vxTlyEihdB4P/mQ31FPRDowRpl/sLklM4f80zUyMN8UrYzbxyYSA/Z9N8qGRavpvs2QF
	 NQo6e4ok/Rq3ryfDS/2r4DEk5dRxdYdZXWIzkUyb5zFTyNt3UgBQLC/zvvc42+9kGXxod
	 hQaahFLwznXqy82OgHc/ffLRbzoOC05Kg7PbMATDRUsWjHH7xJ7PbbgdMRiqIo4rCUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fNGFjQlM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B739606A31A;
	Wed, 28 Oct 2026 19:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fNGFjQlM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6748A1F01825;
	Wed, 28 Oct 2026 19:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216526;
	bh=0nHudbokOex7dUKaCMF+/WCWOzCYXPBdhCzbA0VcYfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNGFjQlMmLeICIYhd3FDye+DqpFNQo888f7XtmU+Vf/eTQIclQSBqK9xTh/zxrbf9
	 c/nW11aYN8ITpMVVYjAamnRc9es3foHANUTh3I7zOj9Pa+2HDPzWuaqTi1QQGU/ePt
	 mFjEquNQxMPmuMTY8Fqaepcsulkqjj6cRYMaxW7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1586/1887] serial: core: do fallible allocations before the console can be registered
Date: Wed, 28 Oct 2026 18:01:22 +0100
Message-ID: <20261028170535.559780943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3e2ecbf5dd91d..69845f9e7aea0 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3094,7 +3094,6 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	struct tty_port *port;
 	int ret = 0;
 	struct device *tty_dev;
-	int num_groups;
 
 	if (uport->line >= drv->nr)
 		return -EINVAL;
@@ -3109,6 +3108,25 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
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
@@ -3118,12 +3136,6 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
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
@@ -3140,17 +3152,6 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 
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



