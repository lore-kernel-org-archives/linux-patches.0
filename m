Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCF41C4EC9;
	Tue, 27 Aug 2024 15:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770913; cv=none; b=WyFZVw111MsVXiSoIkiHtDGA1sskLoyfMYBLFilEQSlUkZxqimNcdAg13eE10nPoCUji7GiBUsHIeCzrcVp5V6EFwSZdFKOlOcxrhj7zTssNfypgNDN4orhQMYbDqnyQ3MN5jn4jE4yHrNZz6E7avgMGulJEs2bpX4zY0fezJC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770913; c=relaxed/simple;
	bh=je2Ip9sX0tKdSqm0L+9Opt/5kcDWR14whv3ALCKc/oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQXrYKmEtXo0FIH9xDqk91kXF1oIo2aVEyTlGOwXsxhdXE/HJnF2/B17UwL8fq+lDQeUDzlLSquVYOK3RFs1lhM85kus2pkPuH6ckFg9Te6s7AlpND39N1nQ+NY3A9UDgklad+C60kGPP+pFtRGs6FyQ/UHpX2ZJinZ82qBD8Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzvZeaOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzvZeaOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3145C4DDF3;
	Tue, 27 Aug 2024 15:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770912;
	bh=je2Ip9sX0tKdSqm0L+9Opt/5kcDWR14whv3ALCKc/oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IzvZeaOHcAyzaemI4CiT4DwzkOdvd8GmSqWaQfpr+Pszi9wkmPyHKxWbZYOsf5mLf
	 tyj/1AdmfYGsXgblvsnnNYgqP4BwbdsFtsweTASfUU7QGIIcBo4zPcOTjWm6xnXOGU
	 wdw6EwmFFde/21O2ikoXUu4+BRHQpvSKqowJ3GSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richard <thomas.richard@bootlin.com>,
	stable <stable@kernel.org>,
	Kevin Hilman <khilman@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.10 006/273] Revert "serial: 8250_omap: Set the console genpd always on if no console suspend"
Date: Tue, 27 Aug 2024 16:35:30 +0200
Message-ID: <20240827143833.621909552@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit 0863bffda1131fd2fa9c05b653ad9ee3d8db127e upstream.

This reverts commit 68e6939ea9ec3d6579eadeab16060339cdeaf940.

Kevin reported that this causes a crash during suspend on platforms that
dont use PM domains.

Link: https://lore.kernel.org/r/7ha5hgpchq.fsf@baylibre.com
Cc: Thomas Richard <thomas.richard@bootlin.com>
Fixes: 68e6939ea9ec ("serial: 8250_omap: Set the console genpd always on if no console suspend")
Cc: stable <stable@kernel.org>
Reported-by: Kevin Hilman <khilman@kernel.org>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Link: https://lore.kernel.org/r/20240814111747.82371-1-griffin@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_omap.c | 33 +++++------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 1af9aed99c65..afef1dd4ddf4 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -27,7 +27,6 @@
 #include <linux/pm_wakeirq.h>
 #include <linux/dma-mapping.h>
 #include <linux/sys_soc.h>
-#include <linux/pm_domain.h>
 
 #include "8250.h"
 
@@ -119,12 +118,6 @@
 #define UART_OMAP_TO_L                 0x26
 #define UART_OMAP_TO_H                 0x27
 
-/*
- * Copy of the genpd flags for the console.
- * Only used if console suspend is disabled
- */
-static unsigned int genpd_flags_console;
-
 struct omap8250_priv {
 	void __iomem *membase;
 	int line;
@@ -1655,7 +1648,6 @@ static int omap8250_suspend(struct device *dev)
 {
 	struct omap8250_priv *priv = dev_get_drvdata(dev);
 	struct uart_8250_port *up = serial8250_get_port(priv->line);
-	struct generic_pm_domain *genpd = pd_to_genpd(dev->pm_domain);
 	int err = 0;
 
 	serial8250_suspend_port(priv->line);
@@ -1666,19 +1658,8 @@ static int omap8250_suspend(struct device *dev)
 	if (!device_may_wakeup(dev))
 		priv->wer = 0;
 	serial_out(up, UART_OMAP_WER, priv->wer);
-	if (uart_console(&up->port)) {
-		if (console_suspend_enabled)
-			err = pm_runtime_force_suspend(dev);
-		else {
-			/*
-			 * The pd shall not be powered-off (no console suspend).
-			 * Make copy of genpd flags before to set it always on.
-			 * The original value is restored during the resume.
-			 */
-			genpd_flags_console = genpd->flags;
-			genpd->flags |= GENPD_FLAG_ALWAYS_ON;
-		}
-	}
+	if (uart_console(&up->port) && console_suspend_enabled)
+		err = pm_runtime_force_suspend(dev);
 	flush_work(&priv->qos_work);
 
 	return err;
@@ -1688,16 +1669,12 @@ static int omap8250_resume(struct device *dev)
 {
 	struct omap8250_priv *priv = dev_get_drvdata(dev);
 	struct uart_8250_port *up = serial8250_get_port(priv->line);
-	struct generic_pm_domain *genpd = pd_to_genpd(dev->pm_domain);
 	int err;
 
 	if (uart_console(&up->port) && console_suspend_enabled) {
-		if (console_suspend_enabled) {
-			err = pm_runtime_force_resume(dev);
-			if (err)
-				return err;
-		} else
-			genpd->flags = genpd_flags_console;
+		err = pm_runtime_force_resume(dev);
+		if (err)
+			return err;
 	}
 
 	serial8250_resume_port(priv->line);
-- 
2.46.0



