Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211160;
	b=U2bp6f1qmZWf1mOuFt9F9gFKvD4QkAbPuhmZGpKm8XZkV3FUn2Qn11rVbontPJHWXtDI
	 wgVr7I1UdnsSUQwyjuXd8wIkgDyYMkKFCbE+SxYx0rLH3MuRvl3lrke/Rs4v2ehfe5mDE
	 HvP+8GnuCdA3BVz7kyrgiz2AbpaOJs+zRDVlL43IVug7ukHuDfs0F/VOcHUkTXfB+qvG2
	 padu+QBXUk7HBcPoY3LrmIv2ufJsH4KJYZNJAQIfFotSbYRjD6zsQNpYcfAdlW27ztK8Z
	 iZ1qJBkrn9zQw6ili9tQ5M+sfBP34ZyowNgVywBeSEClg25agFpwhbQJJ+XnFIcnR8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/RslRrzMopYJ0mimz+/SS8KMqWGDAROgY4+E7UiEnN8=;
	b=M268of6qS7V2oq5d4hu3n8kuK60GbgfqEY6XtTUXn9fAyYZt+ZDL9UnQajiL62cjkjDF
	 Y2xr77y6rzmHH1Lh4HHNUCvcyhGWGJjK7McrqHXbXmViLWRj/vA2AcXbyn5Rql2FcRg4m
	 7ta8GHNqWRvb2S+CB73Ai7rJcTYuF4UVvrkF/z6LojzAM8S27tFUbTpBFQnw9mgQ37VBD
	 BpG3Xnz2O22DLLJukGSP5caf+n5LIS+ktadcJBsP/RqCtZs7ubuEVYAmVuYR9PhFbYYmx
	 8K/TmR5SBjmzFAhwtOC6cWcQeCY3cK+cPIqZfjC9jLhVdwGLnkfCvuHAC+mfBFdERNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Omy59LcO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664EF60A2634;
	Wed, 28 Oct 2026 18:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Omy59LcO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D2F1F01829;
	Wed, 28 Oct 2026 18:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211160;
	bh=/RslRrzMopYJ0mimz+/SS8KMqWGDAROgY4+E7UiEnN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Omy59LcORLPOQwSSwB02hHtPDGo61yE+dR+uLgwHlEjl38PuRB9rks5SL06ydlCUA
	 ZThCpPSO5tQFQaBVZtRlbrsPORYvd55a4q0LQIh8lT/EnA+mMCEJIWuH1NtxIXt72z
	 dtf+QeP9gYUX5qx4R4PrqO1F+K7JTJGJPzlqd+vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 281/571] serial: imx: serialize imx_uart_ports[] lifetime
Date: Wed, 28 Oct 2026 17:57:08 +0100
Message-ID: <20261028170014.669866043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 8b0b29fdcb47907ae0296b8fe829e918e05e300f ]

imx_uart_probe() publishes its devm-allocated port in imx_uart_ports[]
before uart_add_one_port() because console setup uses the table. The entry
is not cleared when adding the port fails or after removal, leaving a
dangling pointer.

A sibling probe can register the shared console through that stale entry.
This was reproduced under KASAN on QEMU mcimx6ul-evk by unbinding a
sibling UART, unbinding the console UART and rebinding the sibling.

Keep the entry valid through uart_remove_one_port(), then clear it. Protect
port addition and removal together with their table updates so sibling
operations cannot interleave. Reject an occupied slot rather than
clobbering an active port during a duplicate-line probe.

Fixes: dbff4e9ea2e8 ("IMX UART: remove statically initialized tables")
Fixes: 9f322ad064f9 ("imx: serial: handle initialisation failure correctly")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/20260719162850.043B41F000E9@smtp.kernel.org
Link: https://lore.kernel.org/all/20260719222501.CB4CB1F000E9@smtp.kernel.org
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260731181844.11330-6-kmehltretter@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ replaced scoped_guard() with explicit mutex_lock()/mutex_unlock() calls for GNU89 compatibility ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -21,6 +21,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/ktime.h>
+#include <linux/mutex.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/rational.h>
 #include <linux/slab.h>
@@ -2005,6 +2006,9 @@ static const struct uart_ops imx_uart_po
 
 static struct imx_port *imx_uart_ports[UART_NR];
 
+/* Held across uart_add/remove_one_port(); console callbacks must not take it. */
+static DEFINE_MUTEX(imx_uart_ports_lock);
+
 #if IS_ENABLED(CONFIG_SERIAL_IMX_CONSOLE)
 static void imx_uart_console_putchar(struct uart_port *port, int ch)
 {
@@ -2472,11 +2476,18 @@ static int imx_uart_probe(struct platfor
 		}
 	}
 
-	imx_uart_ports[sport->port.line] = sport;
-
 	platform_set_drvdata(pdev, sport);
 
-	ret = uart_add_one_port(&imx_uart_uart_driver, &sport->port);
+	mutex_lock(&imx_uart_ports_lock);
+	if (imx_uart_ports[sport->port.line]) {
+		ret = -EBUSY;
+	} else {
+		imx_uart_ports[sport->port.line] = sport;
+		ret = uart_add_one_port(&imx_uart_uart_driver, &sport->port);
+		if (ret)
+			imx_uart_ports[sport->port.line] = NULL;
+	}
+	mutex_unlock(&imx_uart_ports_lock);
 
 err_clk:
 	clk_disable_unprepare(sport->clk_ipg);
@@ -2488,7 +2499,9 @@ static void imx_uart_remove(struct platf
 {
 	struct imx_port *sport = platform_get_drvdata(pdev);
 
+	guard(mutex)(&imx_uart_ports_lock);
 	uart_remove_one_port(&imx_uart_uart_driver, &sport->port);
+	imx_uart_ports[sport->port.line] = NULL;
 }
 
 static void imx_uart_restore_context(struct imx_port *sport)


