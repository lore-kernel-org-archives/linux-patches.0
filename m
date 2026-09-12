Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EDB378828;
	Sat, 12 Sep 2026 19:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242474; cv=none; b=KW1/0M4AnBFXkfCuaZnvQEzDpDbK6edl7qPPAcCrHt3YAFhvncI4VIjsGEw7vCdAvQmZs7R3HLMzam4LV36PBky3oCfmzIur3XyAu3oqG/igq1yKQ7YOH2NGjOGHZorc3Oa38nOVf68o09TBzZZ/VzASfyptIk3JAzCcsxF2vw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242474; c=relaxed/simple;
	bh=Hag4ww44agBBfw5jl851KSkeW+NOupH3W4xve3qg3WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R5O5wJ9hj+dwAusPj6T75EPU1Et0l/01Wkyt97Sc4nWpPiTTVE08K1WVSZDx+QUZKwtbllAfcRIvYe2bKuPn5yZ+rupgMe0LYav7w+tLBQrBZ2tZq+XAtkoztsuygbs47N2nchDqJV/AHFg5xDgEbNxgbIYmKcAB+17u6n7j7a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6fMNHXb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6fMNHXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E15E1F000FF;
	Sat, 12 Sep 2026 19:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242473;
	bh=qhG5/zc3AISYnZkTfgeSZWx85aTQt0K2/UJ7LteMMqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q6fMNHXbHU58qS4Vz447c7doqnyqXVkhIv+8zAe3xpv+1BtQJGFj7ZQQarOX9rKLB
	 ZiZQkKZceAAZVZiePi8TtrOzyL1iCxczk3b7+caiXcYjpSuL3RLtTAZwzE1TbVwKUw
	 v5c35pxvEqJF/J537gnkyV/2fOBEyspzn0gHlbAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 415/798] driver core: platform: use bus_type functions
Date: Sat, 12 Sep 2026 09:00:43 +0200
Message-ID: <20260912065526.662383054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 9c30921fe7994907e0b3e0637b2c8c0fc4b5171f ]

This works towards the goal mentioned in 2006 in commit 594c8281f905
("[PATCH] Add bus_type probe, remove, shutdown methods.").

The functions are moved to where the other bus_type functions are
defined and renamed to match the already established naming scheme.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20201119124611.2573057-3-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 589b9e6f96be ("usb: renesas_usbhs: Fix power-off ordering on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform.c | 132 ++++++++++++++++++++--------------------
 1 file changed, 65 insertions(+), 67 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 16426eb934632..90166535a5c05 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -743,70 +743,6 @@ struct platform_device *platform_device_register_full(
 }
 EXPORT_SYMBOL_GPL(platform_device_register_full);
 
-static int platform_probe_fail(struct platform_device *pdev);
-
-static int platform_drv_probe(struct device *_dev)
-{
-	struct platform_driver *drv = to_platform_driver(_dev->driver);
-	struct platform_device *dev = to_platform_device(_dev);
-	int ret;
-
-	/*
-	 * A driver registered using platform_driver_probe() cannot be bound
-	 * again later because the probe function usually lives in __init code
-	 * and so is gone. For these drivers .probe is set to
-	 * platform_probe_fail in __platform_driver_probe(). Don't even
-	 * prepare clocks and PM domains for these to match the traditional
-	 * behaviour.
-	 */
-	if (unlikely(drv->probe == platform_probe_fail))
-		return -ENXIO;
-
-	ret = of_clk_set_defaults(_dev->of_node, false);
-	if (ret < 0)
-		return ret;
-
-	ret = dev_pm_domain_attach(_dev, true);
-	if (ret)
-		goto out;
-
-	if (drv->probe) {
-		ret = drv->probe(dev);
-		if (ret)
-			dev_pm_domain_detach(_dev, true);
-	}
-
-out:
-	if (drv->prevent_deferred_probe && ret == -EPROBE_DEFER) {
-		dev_warn(_dev, "probe deferral not supported\n");
-		ret = -ENXIO;
-	}
-
-	return ret;
-}
-
-static int platform_drv_remove(struct device *_dev)
-{
-	struct platform_driver *drv = to_platform_driver(_dev->driver);
-	struct platform_device *dev = to_platform_device(_dev);
-	int ret = 0;
-
-	if (drv->remove)
-		ret = drv->remove(dev);
-	dev_pm_domain_detach(_dev, true);
-
-	return ret;
-}
-
-static void platform_drv_shutdown(struct device *_dev)
-{
-	struct platform_driver *drv = to_platform_driver(_dev->driver);
-	struct platform_device *dev = to_platform_device(_dev);
-
-	if (drv->shutdown)
-		drv->shutdown(dev);
-}
-
 /**
  * __platform_driver_register - register a driver for platform-level devices
  * @drv: platform driver structure
@@ -817,9 +753,6 @@ int __platform_driver_register(struct platform_driver *drv,
 {
 	drv->driver.owner = owner;
 	drv->driver.bus = &platform_bus_type;
-	drv->driver.probe = platform_drv_probe;
-	drv->driver.remove = platform_drv_remove;
-	drv->driver.shutdown = platform_drv_shutdown;
 
 	return driver_register(&drv->driver);
 }
@@ -1329,6 +1262,68 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
+static int platform_probe(struct device *_dev)
+{
+	struct platform_driver *drv = to_platform_driver(_dev->driver);
+	struct platform_device *dev = to_platform_device(_dev);
+	int ret;
+
+	/*
+	 * A driver registered using platform_driver_probe() cannot be bound
+	 * again later because the probe function usually lives in __init code
+	 * and so is gone. For these drivers .probe is set to
+	 * platform_probe_fail in __platform_driver_probe(). Don't even prepare
+	 * clocks and PM domains for these to match the traditional behaviour.
+	 */
+	if (unlikely(drv->probe == platform_probe_fail))
+		return -ENXIO;
+
+	ret = of_clk_set_defaults(_dev->of_node, false);
+	if (ret < 0)
+		return ret;
+
+	ret = dev_pm_domain_attach(_dev, true);
+	if (ret)
+		goto out;
+
+	if (drv->probe) {
+		ret = drv->probe(dev);
+		if (ret)
+			dev_pm_domain_detach(_dev, true);
+	}
+
+out:
+	if (drv->prevent_deferred_probe && ret == -EPROBE_DEFER) {
+		dev_warn(_dev, "probe deferral not supported\n");
+		ret = -ENXIO;
+	}
+
+	return ret;
+}
+
+static int platform_remove(struct device *_dev)
+{
+	struct platform_driver *drv = to_platform_driver(_dev->driver);
+	struct platform_device *dev = to_platform_device(_dev);
+	int ret = 0;
+
+	if (drv->remove)
+		ret = drv->remove(dev);
+	dev_pm_domain_detach(_dev, true);
+
+	return ret;
+}
+
+static void platform_shutdown(struct device *_dev)
+{
+	struct platform_driver *drv = to_platform_driver(_dev->driver);
+	struct platform_device *dev = to_platform_device(_dev);
+
+	if (drv->shutdown)
+		drv->shutdown(dev);
+}
+
+
 int platform_dma_configure(struct device *dev)
 {
 	enum dev_dma_attr attr;
@@ -1355,6 +1350,9 @@ struct bus_type platform_bus_type = {
 	.dev_groups	= platform_dev_groups,
 	.match		= platform_match,
 	.uevent		= platform_uevent,
+	.probe		= platform_probe,
+	.remove		= platform_remove,
+	.shutdown	= platform_shutdown,
 	.dma_configure	= platform_dma_configure,
 	.pm		= &platform_dev_pm_ops,
 };
-- 
2.53.0



