Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD3B28DBA
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpag/cZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343E1C433C7;
	Mon, 16 Oct 2023 14:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467998;
	bh=DlCP2AitqwGWw26MZZeFUgYN/WMuUeqvVSOq0D6k3jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpag/cZk+0yaSgiEzM213JMRSPqKpWx43A2QcQLmvoZAZQVCOWcih3sRtVgSSSZj3
	 xufRgSKI1CcmDFxoHDvDxT0XmU4K1tZbaO3B+z/u8A/yHPnKuEMkZoKU88ijvKMUUN
	 qnBg418ZhMasvm4eegA81cW41UB01EZalsKOVhl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Udit Kumar <u-kumar1@ti.com>,
	Thomas Richard <thomas.richard@bootlin.com>,
	Tony Lindgren <tony@atomide.com>,
	Dhruva Gole <d-gole@ti.com>
Subject: [PATCH 6.5 132/191] serial: 8250_omap: Fix errors with no_console_suspend
Date: Mon, 16 Oct 2023 10:41:57 +0200
Message-ID: <20231016084018.473256054@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit 560706eff7c8e5621b0d63afe0866e0e1906e87e upstream.

We now get errors on system suspend if no_console_suspend is set as
reported by Thomas. The errors started with commit 20a41a62618d ("serial:
8250_omap: Use force_suspend and resume for system suspend").

Let's fix the issue by checking for console_suspend_enabled in the system
suspend and resume path.

Note that with this fix the checks for console_suspend_enabled in
omap8250_runtime_suspend() become useless. We now keep runtime PM usage
count for an attached kernel console starting with commit bedb404e91bb
("serial: 8250_port: Don't use power management for kernel console").

Fixes: 20a41a62618d ("serial: 8250_omap: Use force_suspend and resume for system suspend")
Cc: stable <stable@kernel.org>
Cc: Udit Kumar <u-kumar1@ti.com>
Reported-by: Thomas Richard <thomas.richard@bootlin.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Tested-by: Thomas Richard <thomas.richard@bootlin.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Link: https://lore.kernel.org/r/20230926061319.15140-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_omap.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1618,7 +1618,7 @@ static int omap8250_suspend(struct devic
 {
 	struct omap8250_priv *priv = dev_get_drvdata(dev);
 	struct uart_8250_port *up = serial8250_get_port(priv->line);
-	int err;
+	int err = 0;
 
 	serial8250_suspend_port(priv->line);
 
@@ -1628,7 +1628,8 @@ static int omap8250_suspend(struct devic
 	if (!device_may_wakeup(dev))
 		priv->wer = 0;
 	serial_out(up, UART_OMAP_WER, priv->wer);
-	err = pm_runtime_force_suspend(dev);
+	if (uart_console(&up->port) && console_suspend_enabled)
+		err = pm_runtime_force_suspend(dev);
 	flush_work(&priv->qos_work);
 
 	return err;
@@ -1637,11 +1638,15 @@ static int omap8250_suspend(struct devic
 static int omap8250_resume(struct device *dev)
 {
 	struct omap8250_priv *priv = dev_get_drvdata(dev);
+	struct uart_8250_port *up = serial8250_get_port(priv->line);
 	int err;
 
-	err = pm_runtime_force_resume(dev);
-	if (err)
-		return err;
+	if (uart_console(&up->port) && console_suspend_enabled) {
+		err = pm_runtime_force_resume(dev);
+		if (err)
+			return err;
+	}
+
 	serial8250_resume_port(priv->line);
 	/* Paired with pm_runtime_resume_and_get() in omap8250_suspend() */
 	pm_runtime_mark_last_busy(dev);
@@ -1718,16 +1723,6 @@ static int omap8250_runtime_suspend(stru
 
 	if (priv->line >= 0)
 		up = serial8250_get_port(priv->line);
-	/*
-	 * When using 'no_console_suspend', the console UART must not be
-	 * suspended. Since driver suspend is managed by runtime suspend,
-	 * preventing runtime suspend (by returning error) will keep device
-	 * active during suspend.
-	 */
-	if (priv->is_suspending && !console_suspend_enabled) {
-		if (up && uart_console(&up->port))
-			return -EBUSY;
-	}
 
 	if (priv->habit & UART_ERRATA_CLOCK_DISABLE) {
 		int ret;


