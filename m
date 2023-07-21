Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC73200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D328EC433C7;
	Fri, 21 Jul 2023 19:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966310;
	bh=8Xf50rlCfY3lWmuK08GUKg5pchhYV8FQzUQMqf+w/hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iYoIBqcsiuIPWLg/sQleqARTEjSy12l3jhSQEHIQVMg5moZxKZesx3Wf6yqXUe2wY
	 sE515QKG5h88UqBpo/F3TQjk73gWJIs82IUDIz55V2MB1/w8dtsiKPhcCJFeCoeMrN
	 PvyVycPGd4j+75cKp3tNhJaKE6iQbJgPKzzz+XX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Lindgren <tony@atomide.com>,
	Dhruva Gole <d-gole@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 299/532] serial: 8250_omap: Use force_suspend and resume for system suspend
Date: Fri, 21 Jul 2023 18:03:23 +0200
Message-ID: <20230721160630.614235885@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 20a41a62618df85f3a2981008edec5cadd785e0a ]

We should not rely on autosuspend timeout for system suspend. Instead,
let's use force_suspend and force_resume functions. Otherwise the serial
port controller device may not be idled on suspend.

As we are doing a register write on suspend to configure the serial port,
we still need to runtime PM resume the port on suspend.

While at it, let's switch to pm_runtime_resume_and_get() and check for
errors returned. And let's add the missing line break before return to the
suspend function while at it.

Fixes: 09d8b2bdbc5c ("serial: 8250: omap: Provide ability to enable/disable UART as wakeup source")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Tested-by: Dhruva Gole <d-gole@ti.com>
Message-ID: <20230614045922.4798-1-tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index de0447c87846b..a6b374c026a87 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1521,25 +1521,35 @@ static int omap8250_suspend(struct device *dev)
 {
 	struct omap8250_priv *priv = dev_get_drvdata(dev);
 	struct uart_8250_port *up = serial8250_get_port(priv->line);
+	int err;
 
 	serial8250_suspend_port(priv->line);
 
-	pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
+	if (err)
+		return err;
 	if (!device_may_wakeup(dev))
 		priv->wer = 0;
 	serial_out(up, UART_OMAP_WER, priv->wer);
-	pm_runtime_mark_last_busy(dev);
-	pm_runtime_put_autosuspend(dev);
-
+	err = pm_runtime_force_suspend(dev);
 	flush_work(&priv->qos_work);
-	return 0;
+
+	return err;
 }
 
 static int omap8250_resume(struct device *dev)
 {
 	struct omap8250_priv *priv = dev_get_drvdata(dev);
+	int err;
 
+	err = pm_runtime_force_resume(dev);
+	if (err)
+		return err;
 	serial8250_resume_port(priv->line);
+	/* Paired with pm_runtime_resume_and_get() in omap8250_suspend() */
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
+
 	return 0;
 }
 #else
-- 
2.39.2



