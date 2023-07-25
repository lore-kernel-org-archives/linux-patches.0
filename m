Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7934B1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBC4C433C9;
	Tue, 25 Jul 2023 11:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284216;
	bh=mYXwphH08uk94R8pvkGz3BjiMMvpUNCJu99oWlnwoIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJZnwQNnyR+t6+q8tXHX6Ud+r16Mci8B+AaeIxIAJq3JBVe0R1uutfIupyrfKlSLv
	 o+crgiBxryt7WFVYo4KaXIsb3BRqZ1xUeezCtAO+kUNL1y7oKlQG/F0Qc+grHMA/zB
	 C9FapkERV0E3nk6/90B7lX3wy/Hjj7hQB8V7zkMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Lindgren <tony@atomide.com>,
	Dhruva Gole <d-gole@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/509] serial: 8250_omap: Use force_suspend and resume for system suspend
Date: Tue, 25 Jul 2023 12:43:08 +0200
Message-ID: <20230725104605.142999096@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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
index af39a2c4c2eee..e26ac3f42e05c 100644
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



