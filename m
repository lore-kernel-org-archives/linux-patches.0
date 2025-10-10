Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E812F39B4;
	Fri, 10 Oct 2025 13:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102442; cv=none; b=R0yX919DoKaouAluxCJb3Vobyva8MrnEihe7JaXbjn6j5PXnnv7yrQj/Gxw11wg7+LFiF4wK707+C44h88htGi/BK7T49g0g+m8IE2bE7J6JVuYsenlAd2/7Ibw0YGc+oAZbAcgWfQMIgRwM4RmVOZgi87/hMbieywzcEKyMZEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102442; c=relaxed/simple;
	bh=dN5kPRzjXjTq6xAwAAPezDyNQig/asG37xprOW/mBLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6i4BaFDWUMlZFkwaWB0VQAC1HFJ3s18KfaZ6tz4C8Js6XBFV0LWNQxANq8YBjcJS5SRoijSY3AXkIW0TVc9oDCDfF3L8Zn+/LlcgwzR6NBhrWwBa+Pf5LvbKpOCLJMxxv034CqHQQa4zYgytxkfimjZR4aHNtIZHBpbMQxaVcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqGT3tmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqGT3tmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06223C4CEF1;
	Fri, 10 Oct 2025 13:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102442;
	bh=dN5kPRzjXjTq6xAwAAPezDyNQig/asG37xprOW/mBLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqGT3tmPmJ8OvZBcfaO0nOHcldR2uV7JuQmXi6jhcEHIqRDwsRIW/OBbHH8R0gzfa
	 Ab06dRiWEVwP2ixF2p0a3g2RuacJ2ywO4JmusmmnkAbgYbahCo3611THwcXvK09Y9L
	 PBtxe433Xe2fW6p8toVtYyvAUaDPG7X1Cx/+VlgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yufeng <chenyufeng@iie.ac.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 16/35] can: hi311x: fix null pointer dereference when resuming from sleep before interface was enabled
Date: Fri, 10 Oct 2025 15:16:18 +0200
Message-ID: <20251010131332.381102894@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ff39afc77d7d2..c9eba1d37b0eb 100644
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
@@ -910,6 +897,15 @@ static int hi3110_can_probe(struct spi_device *spi)
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
 
@@ -945,6 +941,8 @@ static int hi3110_can_probe(struct spi_device *spi)
 	return 0;
 
  error_probe:
+	destroy_workqueue(priv->wq);
+	priv->wq = NULL;
 	hi3110_power_enable(priv->power, 0);
 
  out_clk:
@@ -965,6 +963,9 @@ static void hi3110_can_remove(struct spi_device *spi)
 
 	hi3110_power_enable(priv->power, 0);
 
+	destroy_workqueue(priv->wq);
+	priv->wq = NULL;
+
 	clk_disable_unprepare(priv->clk);
 
 	free_candev(net);
-- 
2.51.0



