Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C7226ED46;
	Sat, 12 Sep 2026 19:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242471; cv=none; b=IqDKrD5dJPz6EybgOe6S19SfUG41iJTYMbF04TBEHb+dHjbqbK8MTSezGDoYVAAOxDOa3NQXFs1YdHn1Rt3gJsKmtBu2r74Rww1GcExjnF9eN70rm/RDT0z6SrnE8wiIV8CMOmCzr0mo21Td/XJ0yK1NIyzlasiQwZr88HaEGPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242471; c=relaxed/simple;
	bh=URg16rRE9TTxtQ0PwZdAyYDPOO3533kbpPyINroYpBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u869kci/VwYXn6YsbjsLwZcf1gZ7ukAoly794lsdjR1qVR9h7tBBZ3986aY0LtoPT825alqRX9CYA6XWCeh6jgWycmEOrmXE+cTrfqVahXfGgIc8ub4FzcJkWn2aZctfY5tNp84CE7JD8MvYQqOdTIZugClYhc88gHLC4X6ioU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxyqMpTi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxyqMpTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36EC1F000FF;
	Sat, 12 Sep 2026 19:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242470;
	bh=yWCAjvv16Fii7DT8vYA2so21T6W84HmghisZPZf4JaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WxyqMpTiN3fMjqDS7p/pBwg7ZXwBNjqzluwmMyS8ymf8lMrz8WXjGCJlGzSvrhtjO
	 EvFnU58nNB0oUWuDmzAvRVWsLm+jkwkihOJGnkmAQI+PqLtoT4GZvS9ltiQXZtHEwA
	 YtTV8lPv0Q0kxmtZ1NK7p+3EO5uWrS+bxZLwhqUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 414/798] driver core: platform: change logic implementing platform_driver_probe
Date: Sat, 12 Sep 2026 09:00:42 +0200
Message-ID: <20260912065526.640739697@linuxfoundation.org>
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

[ Upstream commit 16085668eacdc56c46652d0f3bfef81ecace57de ]

Instead of overwriting the core driver's probe function handle probing
devices for drivers loaded by platform_driver_probe() in the platform
driver probe function.

The intended goal is to not have to change the probe function to
simplify converting the platform bus to use bus functions.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20201119124611.2573057-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 589b9e6f96be ("usb: renesas_usbhs: Fix power-off ordering on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index fa023cf80dc48..16426eb934632 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -743,12 +743,25 @@ struct platform_device *platform_device_register_full(
 }
 EXPORT_SYMBOL_GPL(platform_device_register_full);
 
+static int platform_probe_fail(struct platform_device *pdev);
+
 static int platform_drv_probe(struct device *_dev)
 {
 	struct platform_driver *drv = to_platform_driver(_dev->driver);
 	struct platform_device *dev = to_platform_device(_dev);
 	int ret;
 
+	/*
+	 * A driver registered using platform_driver_probe() cannot be bound
+	 * again later because the probe function usually lives in __init code
+	 * and so is gone. For these drivers .probe is set to
+	 * platform_probe_fail in __platform_driver_probe(). Don't even
+	 * prepare clocks and PM domains for these to match the traditional
+	 * behaviour.
+	 */
+	if (unlikely(drv->probe == platform_probe_fail))
+		return -ENXIO;
+
 	ret = of_clk_set_defaults(_dev->of_node, false);
 	if (ret < 0)
 		return ret;
@@ -822,7 +835,7 @@ void platform_driver_unregister(struct platform_driver *drv)
 }
 EXPORT_SYMBOL_GPL(platform_driver_unregister);
 
-static int platform_drv_probe_fail(struct device *_dev)
+static int platform_probe_fail(struct platform_device *pdev)
 {
 	return -ENXIO;
 }
@@ -887,10 +900,9 @@ int __init_or_module __platform_driver_probe(struct platform_driver *drv,
 	 * new devices fail.
 	 */
 	spin_lock(&drv->driver.bus->p->klist_drivers.k_lock);
-	drv->probe = NULL;
+	drv->probe = platform_probe_fail;
 	if (code == 0 && list_empty(&drv->driver.p->klist_devices.k_list))
 		retval = -ENODEV;
-	drv->driver.probe = platform_drv_probe_fail;
 	spin_unlock(&drv->driver.bus->p->klist_drivers.k_lock);
 
 	if (code != retval)
-- 
2.53.0



