Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36719352019;
	Thu, 28 May 2026 20:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999267; cv=none; b=RTLI4uUdy5fmULaoaT5JtRcktB+D22kIAy2XuLuHp9DqSyNQOmFgD35wJEVkU9AENJIVMqOyI1eZv/c4Guqgfw9Y+0V6i8ijnz5KcMSBCR+O2+jih69VS0lu8b1WSV1lAVTO16vl2WQH4BFdtcIESPhkxmYZ0uEeS2VxD0XDC1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999267; c=relaxed/simple;
	bh=xG0hKcA2v4wDloHWl7exaeKiUEYMRXAMB9PYVhKDxlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMn6mbKEuLLYlkgg4XJ977fV11fm2ItDpFyC3xmyVxM6OQuCAUJG0IDCxM8MyrITsNTjn+UXtsBXo4NN//NqdOegdibpGv4oTx/ABRtRD6eRjpcBSaZ4xHxw3H+tqwxUdo2fWXXcnKpscS3Xs3KmvXLZ/SeYnhG+rGFfhl8H4sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gp/60j4p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gp/60j4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B641F000E9;
	Thu, 28 May 2026 20:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999266;
	bh=u32zkViXeG+/vcX0vz9ODeNtpEZ9qSL7gHzj6LXIRQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gp/60j4pNhiCouslB7Z/HfWysGogUTeH+g1KveqWBRCHKoSqG1SPj8EFZNmGym+XK
	 8SEZ/6cheYihk/ohqj178JVZue3ndmxyJ/6l5ckPrVijLjT3xxuDqY2GKDTtghXTlV
	 2UYbEXt0ahaXeof09dxNSiZ/f2WTcoPOuRAVf9zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 438/461] gpio: aggregator: stop using dev-sync-probe
Date: Thu, 28 May 2026 21:49:27 +0200
Message-ID: <20260528194700.209314430@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index b45fb799e36c1..e63096002e92d 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1986,7 +1986,6 @@ menu "Virtual GPIO drivers"
 config GPIO_AGGREGATOR
 	tristate "GPIO Aggregator"
 	select CONFIGFS_FS
-	select DEV_SYNC_PROBE
 	help
 	  Say yes here to enable the GPIO Aggregator, which provides a way to
 	  aggregate existing GPIO lines into a new virtual GPIO chip.
diff --git a/drivers/gpio/gpio-aggregator.c b/drivers/gpio/gpio-aggregator.c
index 6c84ca3ff1b64..b53230065f50e 100644
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
@@ -962,12 +961,23 @@ static int gpio_aggregator_activate(struct gpio_aggregator *aggr)
 
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
@@ -981,7 +991,8 @@ static int gpio_aggregator_activate(struct gpio_aggregator *aggr)
 
 static void gpio_aggregator_deactivate(struct gpio_aggregator *aggr)
 {
-	dev_sync_probe_unregister(&aggr->probe_data);
+	platform_device_unregister(aggr->pdev);
+	aggr->pdev = NULL;
 	gpiod_remove_lookup_table(aggr->lookups);
 	kfree(aggr->lookups->dev_id);
 	kfree(aggr->lookups);
@@ -1145,7 +1156,7 @@ gpio_aggregator_device_dev_name_show(struct config_item *item, char *page)
 
 	guard(mutex)(&aggr->lock);
 
-	pdev = aggr->probe_data.pdev;
+	pdev = aggr->pdev;
 	if (pdev)
 		return sysfs_emit(page, "%s\n", dev_name(&pdev->dev));
 
@@ -1322,7 +1333,6 @@ gpio_aggregator_make_group(struct config_group *group, const char *name)
 		return ERR_PTR(ret);
 
 	config_group_init_type_name(&aggr->group, name, &gpio_aggregator_device_type);
-	dev_sync_probe_init(&aggr->probe_data);
 
 	return &aggr->group;
 }
@@ -1471,12 +1481,6 @@ static ssize_t gpio_aggregator_new_device_store(struct device_driver *driver,
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
@@ -1495,7 +1499,7 @@ static ssize_t gpio_aggregator_new_device_store(struct device_driver *driver,
 		goto remove_table;
 	}
 
-	aggr->probe_data.pdev = pdev;
+	aggr->pdev = pdev;
 	module_put(THIS_MODULE);
 	return count;
 
-- 
2.53.0



