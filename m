Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FD0233159;
	Mon, 10 Mar 2025 17:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626515; cv=none; b=Tv8ZYQGG/rFAZOQ7HZR6D7QM8vQxc9hKcQK6fbf3Cb5OshjVLmf1BV/szv4PdwXMxoU074oElWSLRJCJbM12XaOaZO9Eyv3sSlh2cPmbio5syqHSWxvTmwIfpVIwNF5bGGMaGBaojz6hWQ7DENRPYqgJxQ7zQthL7FH9pcm3tF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626515; c=relaxed/simple;
	bh=cc+6RU6mjA2+3VfnMaJkpcqualvcXDWW7xBLl5oOvC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qA7eZuUziFfMnG5vt3qbcJw3u/xDTUBUQxcSXtshQ3Bizx/W9phkixyCM7rBj2I0TCgqUjXXzEpA06qd/W296wz4e8O+iXtlr3dqUOvD3KweXBt5XU10wcpbccxnRx6YHC5lwNu3oPudv05DCeLrHjPt2bJC7HdqGseGkNpoXek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5Cywk3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5Cywk3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB640C4CEE5;
	Mon, 10 Mar 2025 17:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626515;
	bh=cc+6RU6mjA2+3VfnMaJkpcqualvcXDWW7xBLl5oOvC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5Cywk3YudinaPsabbOkjo3msEXoG0JCQQhsY+Va3sgciimQC1kYe53ZWZgoPqjWT
	 al+dh/uAMD9j1rSncQYU1r0u1Iwsophuy/3YtrIw6tTXzszWMxHkz/RYmqF5BQ0/5H
	 rMu9JKOmEmWYUxJDbrmLk9+AL8R54rSKsI6ARIc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.13 019/207] HID: corsair-void: Update power supply values with a unified work handler
Date: Mon, 10 Mar 2025 18:03:32 +0100
Message-ID: <20250310170448.533614748@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>

commit 0c28e4d1e10d2aae608094620bb386e6fd73d55e upstream.

corsair_void_process_receiver can be called from an interrupt context,
locking battery_mutex in it was causing a kernel panic.
Fix it by moving the critical section into its own work, sharing this
work with battery_add_work and battery_remove_work to remove the need
for any locking

Closes: https://bugzilla.suse.com/show_bug.cgi?id=1236843
Fixes: 6ea2a6fd3872 ("HID: corsair-void: Add Corsair Void headset family driver")
Cc: stable@vger.kernel.org
Signed-off-by: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-corsair-void.c | 83 ++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 40 deletions(-)

diff --git a/drivers/hid/hid-corsair-void.c b/drivers/hid/hid-corsair-void.c
index 56e858066c3c..afbd67aa9719 100644
--- a/drivers/hid/hid-corsair-void.c
+++ b/drivers/hid/hid-corsair-void.c
@@ -71,11 +71,9 @@
 
 #include <linux/bitfield.h>
 #include <linux/bitops.h>
-#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/hid.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
 #include <linux/power_supply.h>
 #include <linux/usb.h>
 #include <linux/workqueue.h>
@@ -120,6 +118,12 @@ enum {
 	CORSAIR_VOID_BATTERY_CHARGING	= 5,
 };
 
+enum {
+	CORSAIR_VOID_ADD_BATTERY	= 0,
+	CORSAIR_VOID_REMOVE_BATTERY	= 1,
+	CORSAIR_VOID_UPDATE_BATTERY	= 2,
+};
+
 static enum power_supply_property corsair_void_battery_props[] = {
 	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_PRESENT,
@@ -155,12 +159,12 @@ struct corsair_void_drvdata {
 
 	struct power_supply *battery;
 	struct power_supply_desc battery_desc;
-	struct mutex battery_mutex;
 
 	struct delayed_work delayed_status_work;
 	struct delayed_work delayed_firmware_work;
-	struct work_struct battery_remove_work;
-	struct work_struct battery_add_work;
+
+	unsigned long battery_work_flags;
+	struct work_struct battery_work;
 };
 
 /*
@@ -260,11 +264,9 @@ static void corsair_void_process_receiver(struct corsair_void_drvdata *drvdata,
 
 	/* Inform power supply if battery values changed */
 	if (memcmp(&orig_battery_data, battery_data, sizeof(*battery_data))) {
-		scoped_guard(mutex, &drvdata->battery_mutex) {
-			if (drvdata->battery) {
-				power_supply_changed(drvdata->battery);
-			}
-		}
+		set_bit(CORSAIR_VOID_UPDATE_BATTERY,
+			&drvdata->battery_work_flags);
+		schedule_work(&drvdata->battery_work);
 	}
 }
 
@@ -536,29 +538,11 @@ static void corsair_void_firmware_work_handler(struct work_struct *work)
 
 }
 
-static void corsair_void_battery_remove_work_handler(struct work_struct *work)
+static void corsair_void_add_battery(struct corsair_void_drvdata *drvdata)
 {
-	struct corsair_void_drvdata *drvdata;
-
-	drvdata = container_of(work, struct corsair_void_drvdata,
-			       battery_remove_work);
-	scoped_guard(mutex, &drvdata->battery_mutex) {
-		if (drvdata->battery) {
-			power_supply_unregister(drvdata->battery);
-			drvdata->battery = NULL;
-		}
-	}
-}
-
-static void corsair_void_battery_add_work_handler(struct work_struct *work)
-{
-	struct corsair_void_drvdata *drvdata;
 	struct power_supply_config psy_cfg = {};
 	struct power_supply *new_supply;
 
-	drvdata = container_of(work, struct corsair_void_drvdata,
-			       battery_add_work);
-	guard(mutex)(&drvdata->battery_mutex);
 	if (drvdata->battery)
 		return;
 
@@ -583,16 +567,42 @@ static void corsair_void_battery_add_work_handler(struct work_struct *work)
 	drvdata->battery = new_supply;
 }
 
+static void corsair_void_battery_work_handler(struct work_struct *work)
+{
+	struct corsair_void_drvdata *drvdata = container_of(work,
+		struct corsair_void_drvdata, battery_work);
+
+	bool add_battery = test_and_clear_bit(CORSAIR_VOID_ADD_BATTERY,
+					      &drvdata->battery_work_flags);
+	bool remove_battery = test_and_clear_bit(CORSAIR_VOID_REMOVE_BATTERY,
+						 &drvdata->battery_work_flags);
+	bool update_battery = test_and_clear_bit(CORSAIR_VOID_UPDATE_BATTERY,
+						 &drvdata->battery_work_flags);
+
+	if (add_battery && !remove_battery) {
+		corsair_void_add_battery(drvdata);
+	} else if (remove_battery && !add_battery && drvdata->battery) {
+		power_supply_unregister(drvdata->battery);
+		drvdata->battery = NULL;
+	}
+
+	if (update_battery && drvdata->battery)
+		power_supply_changed(drvdata->battery);
+
+}
+
 static void corsair_void_headset_connected(struct corsair_void_drvdata *drvdata)
 {
-	schedule_work(&drvdata->battery_add_work);
+	set_bit(CORSAIR_VOID_ADD_BATTERY, &drvdata->battery_work_flags);
+	schedule_work(&drvdata->battery_work);
 	schedule_delayed_work(&drvdata->delayed_firmware_work,
 			      msecs_to_jiffies(100));
 }
 
 static void corsair_void_headset_disconnected(struct corsair_void_drvdata *drvdata)
 {
-	schedule_work(&drvdata->battery_remove_work);
+	set_bit(CORSAIR_VOID_REMOVE_BATTERY, &drvdata->battery_work_flags);
+	schedule_work(&drvdata->battery_work);
 
 	corsair_void_set_unknown_wireless_data(drvdata);
 	corsair_void_set_unknown_batt(drvdata);
@@ -678,13 +688,7 @@ static int corsair_void_probe(struct hid_device *hid_dev,
 	drvdata->battery_desc.get_property = corsair_void_battery_get_property;
 
 	drvdata->battery = NULL;
-	INIT_WORK(&drvdata->battery_remove_work,
-		  corsair_void_battery_remove_work_handler);
-	INIT_WORK(&drvdata->battery_add_work,
-		  corsair_void_battery_add_work_handler);
-	ret = devm_mutex_init(drvdata->dev, &drvdata->battery_mutex);
-	if (ret)
-		return ret;
+	INIT_WORK(&drvdata->battery_work, corsair_void_battery_work_handler);
 
 	ret = sysfs_create_group(&hid_dev->dev.kobj, &corsair_void_attr_group);
 	if (ret)
@@ -721,8 +725,7 @@ static void corsair_void_remove(struct hid_device *hid_dev)
 	struct corsair_void_drvdata *drvdata = hid_get_drvdata(hid_dev);
 
 	hid_hw_stop(hid_dev);
-	cancel_work_sync(&drvdata->battery_remove_work);
-	cancel_work_sync(&drvdata->battery_add_work);
+	cancel_work_sync(&drvdata->battery_work);
 	if (drvdata->battery)
 		power_supply_unregister(drvdata->battery);
 
-- 
2.48.1



