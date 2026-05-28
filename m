Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A615B25F7B9;
	Thu, 28 May 2026 20:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000269; cv=none; b=BhKZhTMDZIVhAtQCwQmFny6gom1GA3jaQHZSdsAzhdGUpsCKYgiqg3aLhcG63lRRLwjy1RCkKPAvxkvC7vs97h3999v147yV8YTN6oVxnjAX7j5u9MaJ+YDIYy25kdi19BZjuYirZ6h7DL5t7G4+Wdx2LSCZoeJZLP5IEdYJ+JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000269; c=relaxed/simple;
	bh=xlmxaqT0fXwnIO28XZfKbABnirFe+1kuVD+W5S1sam4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6GrQf5hk2/MYz8jPGPVlvMN5dbAi3khqsodXnmuN8wL13fD435CshU7nZc4n+ncgqm3lyu1Ih3e9kmGJ1lFLX2zmHAG0ZP5tVRYStbqmu4oGB47YBYyjGqCjLCI2KITJdmf/NCSEkkS4QRMVhrgJnVztvisEgvhYsnY5whV3P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7SF/oJp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7SF/oJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0271F000E9;
	Thu, 28 May 2026 20:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000268;
	bh=Wiyn6DLhzkcLirUqH0rhLr0GVstCXP5BuQ4IjMwkvxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r7SF/oJpbKck1jb+0LqNAcWyCUga9t6/3mx/BXaHBXvwv6ZdTmaTpW2iTGpuMQmiK
	 u3Mi3QACBYF0HQn7INrAk2xXQTlFMyMkXJ6ogknOx1wTOKb0ePONXOmypeuChwA7G5
	 DHXmXuwPadgwZIzIrsV8L0K3zwl4MU+jwP4ryP0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 363/377] gpio: aggregator: stop using dev-sync-probe
Date: Thu, 28 May 2026 21:50:01 +0200
Message-ID: <20260528194648.938895486@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 3a27f40b457053e6112a63d14590e4a3ff553b44 ]

dev-err-probe is an overengineered solution to a simple problem. Use a
combination of wait_for_probe() and device_is_bound() to synchronously
wait for the platform device to probe.

Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260327-gpio-kill-dev-sync-probe-v1-2-efac254f1a1d@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Stable-dep-of: 61fef83f239e ("gpio: aggregator: remove the software node when deactivating the aggregator")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/Kconfig           |  1 -
 drivers/gpio/gpio-aggregator.c | 38 +++++++++++++++++++---------------
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 4d644dcecad93..3b7284938babf 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1968,7 +1968,6 @@ menu "Virtual GPIO drivers"
 config GPIO_AGGREGATOR
 	tristate "GPIO Aggregator"
 	select CONFIGFS_FS
-	select DEV_SYNC_PROBE
 	help
 	  Say yes here to enable the GPIO Aggregator, which provides a way to
 	  aggregate existing GPIO lines into a new virtual GPIO chip.
diff --git a/drivers/gpio/gpio-aggregator.c b/drivers/gpio/gpio-aggregator.c
index a68665700733d..23987c38a2468 100644
--- a/drivers/gpio/gpio-aggregator.c
+++ b/drivers/gpio/gpio-aggregator.c
@@ -32,8 +32,6 @@
 #include <linux/gpio/forwarder.h>
 #include <linux/gpio/machine.h>
 
-#include "dev-sync-probe.h"
-
 #define AGGREGATOR_MAX_GPIOS 512
 #define AGGREGATOR_LEGACY_PREFIX "_sysfs"
 
@@ -42,7 +40,7 @@
  */
 
 struct gpio_aggregator {
-	struct dev_sync_probe_data probe_data;
+	struct platform_device *pdev;
 	struct config_group group;
 	struct gpiod_lookup_table *lookups;
 	struct mutex lock;
@@ -135,7 +133,7 @@ static bool gpio_aggregator_is_active(struct gpio_aggregator *aggr)
 {
 	lockdep_assert_held(&aggr->lock);
 
-	return aggr->probe_data.pdev && platform_get_drvdata(aggr->probe_data.pdev);
+	return aggr->pdev && platform_get_drvdata(aggr->pdev);
 }
 
 /* Only aggregators created via legacy sysfs can be "activating". */
@@ -143,7 +141,7 @@ static bool gpio_aggregator_is_activating(struct gpio_aggregator *aggr)
 {
 	lockdep_assert_held(&aggr->lock);
 
-	return aggr->probe_data.pdev && !platform_get_drvdata(aggr->probe_data.pdev);
+	return aggr->pdev && !platform_get_drvdata(aggr->pdev);
 }
 
 static size_t gpio_aggregator_count_lines(struct gpio_aggregator *aggr)
@@ -909,6 +907,7 @@ static int gpio_aggregator_activate(struct gpio_aggregator *aggr)
 {
 	struct platform_device_info pdevinfo;
 	struct gpio_aggregator_line *line;
+	struct platform_device *pdev;
 	struct fwnode_handle *swnode;
 	unsigned int n = 0;
 	int ret = 0;
@@ -963,12 +962,23 @@ static int gpio_aggregator_activate(struct gpio_aggregator *aggr)
 
 	gpiod_add_lookup_table(aggr->lookups);
 
-	ret = dev_sync_probe_register(&aggr->probe_data, &pdevinfo);
-	if (ret)
+	pdev = platform_device_register_full(&pdevinfo);
+	if (IS_ERR(pdev)) {
+		ret = PTR_ERR(pdev);
 		goto err_remove_lookup_table;
+	}
 
+	wait_for_device_probe();
+	if (!device_is_bound(&pdev->dev)) {
+		ret = -ENXIO;
+		goto err_unregister_pdev;
+	}
+
+	aggr->pdev = pdev;
 	return 0;
 
+err_unregister_pdev:
+	platform_device_unregister(pdev);
 err_remove_lookup_table:
 	gpiod_remove_lookup_table(aggr->lookups);
 	kfree(aggr->lookups->dev_id);
@@ -982,7 +992,8 @@ static int gpio_aggregator_activate(struct gpio_aggregator *aggr)
 
 static void gpio_aggregator_deactivate(struct gpio_aggregator *aggr)
 {
-	dev_sync_probe_unregister(&aggr->probe_data);
+	platform_device_unregister(aggr->pdev);
+	aggr->pdev = NULL;
 	gpiod_remove_lookup_table(aggr->lookups);
 	kfree(aggr->lookups->dev_id);
 	kfree(aggr->lookups);
@@ -1146,7 +1157,7 @@ gpio_aggregator_device_dev_name_show(struct config_item *item, char *page)
 
 	guard(mutex)(&aggr->lock);
 
-	pdev = aggr->probe_data.pdev;
+	pdev = aggr->pdev;
 	if (pdev)
 		return sysfs_emit(page, "%s\n", dev_name(&pdev->dev));
 
@@ -1323,7 +1334,6 @@ gpio_aggregator_make_group(struct config_group *group, const char *name)
 		return ERR_PTR(ret);
 
 	config_group_init_type_name(&aggr->group, name, &gpio_aggregator_device_type);
-	dev_sync_probe_init(&aggr->probe_data);
 
 	return &aggr->group;
 }
@@ -1473,12 +1483,6 @@ static ssize_t gpio_aggregator_new_device_store(struct device_driver *driver,
 	scnprintf(name, sizeof(name), "%s.%d", AGGREGATOR_LEGACY_PREFIX, aggr->id);
 	config_group_init_type_name(&aggr->group, name, &gpio_aggregator_device_type);
 
-	/*
-	 * Since the device created by sysfs might be toggled via configfs
-	 * 'live' attribute later, this initialization is needed.
-	 */
-	dev_sync_probe_init(&aggr->probe_data);
-
 	/* Expose to configfs */
 	res = configfs_register_group(&gpio_aggregator_subsys.su_group,
 				      &aggr->group);
@@ -1497,7 +1501,7 @@ static ssize_t gpio_aggregator_new_device_store(struct device_driver *driver,
 		goto remove_table;
 	}
 
-	aggr->probe_data.pdev = pdev;
+	aggr->pdev = pdev;
 	module_put(THIS_MODULE);
 	return count;
 
-- 
2.53.0



