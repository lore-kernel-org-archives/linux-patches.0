Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F76139FCCD;
	Fri,  9 Oct 2026 14:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556397; cv=none; b=EihjQB0ym1F07AK5nd3NA5ozv/2x26f2nl9vRXabxW4hbTNuWMTwFi1SDBjiLt2Ej4oiWnK8SoM54X7WUhbfyuP9TzF4gwLmeEvscOGYB8yjFRz/jsLSYJv634biv7n0m5Fzi+MzzTIomDp2btoeXUgibXMYXwhKO91nhKulN+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556397; c=relaxed/simple;
	bh=EXXqSEAKcujF09UPpFMgMIw/9stoHoyOhsnu2oyCNqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c95oOb8aqXo3HHp5CZHm0aRkX7GBP6SO+Kj9HGJ5bt+SLqS2ezHeV4cioSpIoAkGTqxJVF4ppjroEX1xuoSumNMLYRKORJuXZsIic9iU/BU8iRT9sq1rmQwSQxRqkCm+RX5YQKWhUQ/IPsoiKtT8tVp1hGNWxu/O/nyi4oSCJ8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPZdY1Eo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPZdY1Eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61081F000FF;
	Fri,  9 Oct 2026 14:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556396;
	bh=qPVNbrbhxWY/ouVwfpnfmMKJ1SCEEtVxiqI3xOCe0XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VPZdY1EoIAcHdhNtwdT4E4cRl0XkOu6TYzJp3oBen+nvrUsbgx6uKDFvGKP/xD5sF
	 sAU6GwdVuJq2BDID9fghbieQhi3rFy5GLaMgOpDyKbx2vnBTlQVBNp8XmyVsCwnnBV
	 q5pHMfI+BnLqUWHg7Gyx9+aF9LCl5fidi7FvKpE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kendall Willis <k-willis@ti.com>,
	Tony Lindgren <tony.lindgren@linux.intel.com>
Subject: [PATCH 6.18 200/403] serial: 8250_omap: fix wake irq cleared during suspend
Date: Fri,  9 Oct 2026 16:09:21 +0200
Message-ID: <20261009140956.810543786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kendall Willis <k-willis@ti.com>

commit 73f3e6ca7a6a7c952977c7c94f1c6dddebcafa34 upstream.

The wake irq was cleared in shutdown(), which runs during the suspend
sequence, making it impossible to wake the system via UART.
Move wake irq setup to probe() and teardown to remove() so the irq
remains armed during suspend when the UART is a wakeup source.

Cc: stable@kernel.org
Fixes: 61929cf0169d ("tty: serial: Add 8250-core based omap driver")
Signed-off-by: Kendall Willis <k-willis@ti.com>
Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Link: https://patch.msgid.link/20260825-uart-wakeirq-fix-v2-1-0b9fba03d9b6@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_omap.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -727,12 +727,6 @@ static int omap_8250_startup(struct uart
 	struct uart_8250_dma *dma = &priv->omap8250_dma;
 	int ret;
 
-	if (priv->wakeirq) {
-		ret = dev_pm_set_dedicated_wake_irq(port->dev, priv->wakeirq);
-		if (ret)
-			return ret;
-	}
-
 #ifdef CONFIG_PM
 	up->capabilities |= UART_CAP_RPM;
 #endif
@@ -803,7 +797,6 @@ static void omap_8250_shutdown(struct ua
 	}
 
 	disable_irq_nosync(port->irq);
-	dev_pm_clear_wake_irq(port->dev);
 
 	serial8250_release_dma(up);
 	up->dma = NULL;
@@ -1602,6 +1595,12 @@ static int omap8250_probe(struct platfor
 
 	priv->wakeirq = irq_of_parse_and_map(np, 1);
 
+	if (priv->wakeirq) {
+		ret = dev_pm_set_dedicated_wake_irq(&pdev->dev, priv->wakeirq);
+		if (ret)
+			goto err;
+	}
+
 	ret = serial8250_register_8250_port(&up);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "unable to register 8250 port\n");
@@ -1617,6 +1616,7 @@ static int omap8250_probe(struct platfor
 
 	return 0;
 err:
+	dev_pm_clear_wake_irq(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
 	flush_work(&priv->qos_work);
@@ -1639,6 +1639,7 @@ static void omap8250_remove(struct platf
 	omap_8250_shutdown(&up->port);
 	serial8250_unregister_port(priv->line);
 	priv->line = -ENODEV;
+	dev_pm_clear_wake_irq(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
 	flush_work(&priv->qos_work);


