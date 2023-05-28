Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A68611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76ACDC433D2;
	Sun, 28 May 2023 19:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303362;
	bh=RkjJpEksO7Gkk8sRv+nWTalwhTC1TxebAskc7LmiyUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxzax4yViCoFYT5TFAcB7J1hhpbve5zyit2VBKSkluocsN5rgj95sAOky6921EniW
	 0Spf7wrKKeyr9CJkA+iGK63ucVm10cWLPNg1q2pYzIYgi7SoLNhGW5ISE1HKSSZyc9
	 htsjr9SQF6Hwt7Ysy+bcA6Vj/uo9CIydfDRH5Y4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.15 46/69] power: supply: bq27xxx: Fix poll_interval handling and races on remove
Date: Sun, 28 May 2023 20:12:06 +0100
Message-Id: <20230528190830.098159281@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

commit c00bc80462afc7963f449d7f21d896d2f629cacc upstream.

Before this patch bq27xxx_battery_teardown() was setting poll_interval = 0
to avoid bq27xxx_battery_update() requeuing the delayed_work item.

There are 2 problems with this:

1. If the driver is unbound through sysfs, rather then the module being
   rmmod-ed, this changes poll_interval unexpectedly

2. This is racy, after it being set poll_interval could be changed
   before bq27xxx_battery_update() checks it through
   /sys/module/bq27xxx_battery/parameters/poll_interval

Fix this by added a removed attribute to struct bq27xxx_device_info and
using that instead of setting poll_interval to 0.

There also is another poll_interval related race on remove(), writing
/sys/module/bq27xxx_battery/parameters/poll_interval will requeue
the delayed_work item for all devices on the bq27xxx_battery_devices
list and the device being removed was only removed from that list
after cancelling the delayed_work item.

Fix this by moving the removal from the bq27xxx_battery_devices list
to before cancelling the delayed_work item.

Fixes: 8cfaaa811894 ("bq27x00_battery: Fix OOPS caused by unregistring bq27x00 driver")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq27xxx_battery.c |   22 +++++++++-------------
 include/linux/power/bq27xxx_battery.h  |    1 +
 2 files changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1807,7 +1807,7 @@ static void bq27xxx_battery_update_unloc
 
 	di->last_update = jiffies;
 
-	if (poll_interval > 0)
+	if (!di->removed && poll_interval > 0)
 		mod_delayed_work(system_wq, &di->work, poll_interval * HZ);
 }
 
@@ -2138,22 +2138,18 @@ EXPORT_SYMBOL_GPL(bq27xxx_battery_setup)
 
 void bq27xxx_battery_teardown(struct bq27xxx_device_info *di)
 {
-	/*
-	 * power_supply_unregister call bq27xxx_battery_get_property which
-	 * call bq27xxx_battery_poll.
-	 * Make sure that bq27xxx_battery_poll will not call
-	 * schedule_delayed_work again after unregister (which cause OOPS).
-	 */
-	poll_interval = 0;
-
-	cancel_delayed_work_sync(&di->work);
-
-	power_supply_unregister(di->bat);
-
 	mutex_lock(&bq27xxx_list_lock);
 	list_del(&di->list);
 	mutex_unlock(&bq27xxx_list_lock);
 
+	/* Set removed to avoid bq27xxx_battery_update() re-queuing the work */
+	mutex_lock(&di->lock);
+	di->removed = true;
+	mutex_unlock(&di->lock);
+
+	cancel_delayed_work_sync(&di->work);
+
+	power_supply_unregister(di->bat);
 	mutex_destroy(&di->lock);
 }
 EXPORT_SYMBOL_GPL(bq27xxx_battery_teardown);
--- a/include/linux/power/bq27xxx_battery.h
+++ b/include/linux/power/bq27xxx_battery.h
@@ -68,6 +68,7 @@ struct bq27xxx_device_info {
 	struct bq27xxx_access_methods bus;
 	struct bq27xxx_reg_cache cache;
 	int charge_design_full;
+	bool removed;
 	unsigned long last_update;
 	struct delayed_work work;
 	struct power_supply *bat;


