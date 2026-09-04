Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0032A36F421;
	Fri,  4 Sep 2026 05:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498547; cv=none; b=Q16IRrWhoqcCSZfaDroUZrJ3VEWFu1aNhnxOcDT2e3n8KpC/BjojuEuEflcw9VwIe+I5OdFKqvHeir5/AumzoYj6XjTqu1dsBJ5wcC4dShUrBa9mfXKAzCwstCOnq6bbVmT0EXuLG8P6gnQdE5s2nEovylTzmElEBytBfuAHnDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498547; c=relaxed/simple;
	bh=XtWEftrjm8mhaquAZ/fCVdhQpGlsjJycBAV3BdFywDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EvdHjlkFkGNTj8v0IvbmIS62ykvV08q7/3NDwbBvFG0JETy4HDGBlXtrMpCWPsCdTbIF5418sxS0UbV5rBBKChQj0Nl6BXt1y7OiCEeLi6CiPFcwV4ZE1IGcbXcPGgnZeazcce9w5nEw91+4WPeVNIhxCx+gN+D0fSNsZKa/MWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CuqBmU4T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CuqBmU4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01F21F00A3D;
	Fri,  4 Sep 2026 05:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498545;
	bh=dIPDX2kTkvltmJfsfwOd1RNbbTO3BSjPjy5ImJOSSOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuqBmU4Ti/qfqJ1DtH2Uzxc+x7npMno0+yo0QpA7R1KYXzU2Pj3n6EyCHzwmkEJwo
	 MLUgA9wSj+YggK+G6VvIYA+IURM7WT68HRzMxY7knUIkeojk9M9hJovjA0JGdZlzIm
	 kuU++Hc5SmGLnGz+IIPSlS1D+dvJ3yOVSczqBgZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 7.2 101/713] serial: imx: serialize imx_uart_ports[] lifetime
Date: Fri,  4 Sep 2026 06:51:09 +0200
Message-ID: <20260904045806.101287438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

commit 8b0b29fdcb47907ae0296b8fe829e918e05e300f upstream.

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
---
 drivers/tty/serial/imx.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -22,6 +22,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/ktime.h>
+#include <linux/mutex.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/rational.h>
 #include <linux/slab.h>
@@ -2080,6 +2081,9 @@ static const struct uart_ops imx_uart_po
 
 static struct imx_port *imx_uart_ports[UART_NR];
 
+/* Held across uart_add/remove_one_port(); console callbacks must not take it. */
+static DEFINE_MUTEX(imx_uart_ports_lock);
+
 #if IS_ENABLED(CONFIG_SERIAL_IMX_CONSOLE)
 static void imx_uart_console_putchar(struct uart_port *port, unsigned char ch)
 {
@@ -2632,11 +2636,19 @@ static int imx_uart_probe(struct platfor
 		}
 	}
 
-	imx_uart_ports[sport->port.line] = sport;
-
 	platform_set_drvdata(pdev, sport);
 
-	ret = uart_add_one_port(&imx_uart_uart_driver, &sport->port);
+	scoped_guard(mutex, &imx_uart_ports_lock) {
+		if (imx_uart_ports[sport->port.line]) {
+			ret = -EBUSY;
+		} else {
+			imx_uart_ports[sport->port.line] = sport;
+			ret = uart_add_one_port(&imx_uart_uart_driver,
+						&sport->port);
+			if (ret)
+				imx_uart_ports[sport->port.line] = NULL;
+		}
+	}
 
 err_clk:
 	clk_disable_unprepare(sport->clk_ipg);
@@ -2648,7 +2660,9 @@ static void imx_uart_remove(struct platf
 {
 	struct imx_port *sport = platform_get_drvdata(pdev);
 
+	guard(mutex)(&imx_uart_ports_lock);
 	uart_remove_one_port(&imx_uart_uart_driver, &sport->port);
+	imx_uart_ports[sport->port.line] = NULL;
 }
 
 static void imx_uart_restore_context(struct imx_port *sport)


