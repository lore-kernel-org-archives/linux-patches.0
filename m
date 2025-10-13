Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9A230E835;
	Mon, 13 Oct 2025 14:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366940; cv=none; b=PBR1hD9Hntvr854HwFQopyFCGfgC39A/z7Rw6JhQEt8LfvjjocW3expcdfM1OG9xFWcMk1ppe6zVz7sEM5EXfeYQc02CCGhN2mS/E0I1De0DrLcbFY2l5ROuapf9eIMDo2X3V4VrvY6XIJVZ+9M1BHL2EYFUo+o7oJCQoXLxVew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366940; c=relaxed/simple;
	bh=YFJwdQjmhANHXliMvKOrjX00lVPUHJcFBkFm+0O8c74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkzxMRkUmfZnp+rxUgk2widwbbC4JqURBZvHvWWjvSt+tcDV2yHUb7qLYEBhcFUgwQJn7E+WDsvup8txM3X1K+aU/DDo3afFm+hrxYx98MVOwvbbBcNcXrfoQWQDAnWPB8jbpavx8wDTB9vYFuy/5jn8ZV8pGX1svhtEDQqc2Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUlRE0ME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUlRE0ME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FA1C4CEE7;
	Mon, 13 Oct 2025 14:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366939;
	bh=YFJwdQjmhANHXliMvKOrjX00lVPUHJcFBkFm+0O8c74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUlRE0MEpmSMqZDrGy8bKShcdYW+PP7DC4teqkjab354dtAzwcDbmtj8g2drYg3pk
	 +MKuYY5XYEAaOPggXeE9PFMbYfo569mVPhBOzJ7g9goUHZIK+iwOcBGZpZketj9XrZ
	 Mu+nKeVSpwIb9+Xp85U1BMY3sPSiUbYF/HOaUEl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yufeng <chenyufeng@iie.ac.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/196] can: hi311x: fix null pointer dereference when resuming from sleep before interface was enabled
Date: Mon, 13 Oct 2025 16:43:29 +0200
Message-ID: <20251013144315.894145166@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Yufeng <chenyufeng@iie.ac.cn>

[ Upstream commit 6b696808472197b77b888f50bc789a3bae077743 ]

This issue is similar to the vulnerability in the `mcp251x` driver,
which was fixed in commit 03c427147b2d ("can: mcp251x: fix resume from
sleep before interface was brought up").

In the `hi311x` driver, when the device resumes from sleep, the driver
schedules `priv->restart_work`. However, if the network interface was
not previously enabled, the `priv->wq` (workqueue) is not allocated and
initialized, leading to a null pointer dereference.

To fix this, we move the allocation and initialization of the workqueue
from the `hi3110_open` function to the `hi3110_can_probe` function.
This ensures that the workqueue is properly initialized before it is
used during device resume. And added logic to destroy the workqueue
in the error handling paths of `hi3110_can_probe` and in the
`hi3110_can_remove` function to prevent resource leaks.

Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
Link: https://patch.msgid.link/20250911150820.250-1-chenyufeng@iie.ac.cn
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/hi311x.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 57ea7dfe8a596..1acd4fc7adc8b 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -545,8 +545,6 @@ static int hi3110_stop(struct net_device *net)
 
 	priv->force_quit = 1;
 	free_irq(spi->irq, priv);
-	destroy_workqueue(priv->wq);
-	priv->wq = NULL;
 
 	mutex_lock(&priv->hi3110_lock);
 
@@ -771,34 +769,23 @@ static int hi3110_open(struct net_device *net)
 		goto out_close;
 	}
 
-	priv->wq = alloc_workqueue("hi3110_wq", WQ_FREEZABLE | WQ_MEM_RECLAIM,
-				   0);
-	if (!priv->wq) {
-		ret = -ENOMEM;
-		goto out_free_irq;
-	}
-	INIT_WORK(&priv->tx_work, hi3110_tx_work_handler);
-	INIT_WORK(&priv->restart_work, hi3110_restart_work_handler);
-
 	ret = hi3110_hw_reset(spi);
 	if (ret)
-		goto out_free_wq;
+		goto out_free_irq;
 
 	ret = hi3110_setup(net);
 	if (ret)
-		goto out_free_wq;
+		goto out_free_irq;
 
 	ret = hi3110_set_normal_mode(spi);
 	if (ret)
-		goto out_free_wq;
+		goto out_free_irq;
 
 	netif_wake_queue(net);
 	mutex_unlock(&priv->hi3110_lock);
 
 	return 0;
 
- out_free_wq:
-	destroy_workqueue(priv->wq);
  out_free_irq:
 	free_irq(spi->irq, priv);
 	hi3110_hw_sleep(spi);
@@ -915,6 +902,15 @@ static int hi3110_can_probe(struct spi_device *spi)
 	if (ret)
 		goto out_clk;
 
+	priv->wq = alloc_workqueue("hi3110_wq", WQ_FREEZABLE | WQ_MEM_RECLAIM,
+				   0);
+	if (!priv->wq) {
+		ret = -ENOMEM;
+		goto out_clk;
+	}
+	INIT_WORK(&priv->tx_work, hi3110_tx_work_handler);
+	INIT_WORK(&priv->restart_work, hi3110_restart_work_handler);
+
 	priv->spi = spi;
 	mutex_init(&priv->hi3110_lock);
 
@@ -950,6 +946,8 @@ static int hi3110_can_probe(struct spi_device *spi)
 	return 0;
 
  error_probe:
+	destroy_workqueue(priv->wq);
+	priv->wq = NULL;
 	hi3110_power_enable(priv->power, 0);
 
  out_clk:
@@ -970,6 +968,9 @@ static void hi3110_can_remove(struct spi_device *spi)
 
 	hi3110_power_enable(priv->power, 0);
 
+	destroy_workqueue(priv->wq);
+	priv->wq = NULL;
+
 	clk_disable_unprepare(priv->clk);
 
 	free_candev(net);
-- 
2.51.0



