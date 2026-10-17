Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EF33CAE99;
	Sat, 17 Oct 2026 18:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260094; cv=none; b=kPgTa+49Ib+yGrcjxL9dLb1uzxLQKsXjFBvnjZ9L9FfEY3whglq9QiC4G0HGp2f/sdm9ZwyAPat8jnelP9zah2g42WnlGO75rEUFzpXDJ88ECs0iJyA+ITUPQQdFxd0WizmXig52Hjpuo3n8DJDFJh/01nEcxpRZj6FHhIeWX8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260094; c=relaxed/simple;
	bh=KfnZNN33Tk+pPVgIgmZbwTlV1Aib2IXRzFi4Zsn6qIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8dZZmTDZqSRhaSgXmgviwiy7dQy3Zau/2C8Qb4r3XWujWB1ldFSBYcntvjIKuo8flYWkDW9W4/R/u5L9mVJmaYI+Q+fotb1F+oz4LSaYxicQIzuWWBYcU0qYV9HQh84xe9ZlgN76szPssquo0ZpTLHQrVGM8MvEbHuFBR6hLKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kiT9uZEX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kiT9uZEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC271F000C4;
	Sat, 17 Oct 2026 18:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260093;
	bh=7o83MH+oxak6bo7xAoDpXrM0m0HegRfpA1Ay+LrJt08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kiT9uZEXIsyddJ5LKr1e9+T1CZkj0raKMTWZZL8+AvqPc7CltvyU9vvWChNscB0RR
	 v3iWnhkU0wJedi277XZUt+oYajbVa5aPp2WRccZxJE8bf6T3OnNTK4hnvfImQ5LXV7
	 +9HzV/rD91cI1cYAZmm3WdgZ+heQyNO7GmsnQlLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1431/1674] thermal: hwmon: Remove hwmon class device along with its parent
Date: Sat, 17 Oct 2026 18:01:43 +0200
Message-ID: <20261017160507.913072888@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 2b57e24d34b2dfc43c81942bb359d6315bf302fb ]

The current code creates one hwmon device per thermal zone type and that
device is registered under the first thermal zone of the given type.

That turns out to be problematic when the thermal zone holding the
hwmon device is removed.

For example, say that there are two ACPI thermal zones on a system

 /sys/devices/virtual/thermal/thermal_zone0/
 /sys/devices/virtual/thermal/thermal_zone1/

The current code registers a hwmon class device for thermal_zone0 only:

 /sys/devices/virtual/thermal/thermal_zone0/hwmon0/

because the type is "acpitz" for both of them, but it adds a sysfs
attribute that belongs to thermal_zone1 under it:

 /sys/devices/virtual/thermal/thermal_zone0/hwmon0/temp2_input

There is also

 /sys/devices/virtual/thermal/thermal_zone0/hwmon0/temp1_input

which belongs to thermal_zone0.

When thermal_zone0 is removed, say because the ACPI thermal driver is
unbound from the underlying platform device, thermal_remove_hwmon_sysfs()
skips the removal of hwmon0 because of the temp2_input attribute
belonging to thermal_zone1 which effectively prevents thermal_zone0
removal from making progress.

Address this by making thermal_remove_hwmon_sysfs() remove the entire
hwmon class device interface for the given thermal zone type when the
thermal zone device holding it is removed.

To prevent races with thermal_add_hwmon_sysfs() that may interfere
with this, carry out the entire addition and removal of hwmon sysfs
interfaces for thermal zones under thermal_hwmon_list_lock.

Also adjust the layout of the labels in thermal_add_hwmon_sysfs() to
the current kernel coding style to align with the new "unlock" label.

Link: https://lore.kernel.org/linux-pm/20260402021828.16556-1-liujia6264@gmail.com/
Fixes: f6b6b52ef7a5 ("thermal_hwmon: Pass the originating device down to hwmon_device_register_with_info")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/5094738.GXAFRqVoOG@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_hwmon.c | 87 +++++++++++++--------------------
 1 file changed, 34 insertions(+), 53 deletions(-)

diff --git a/drivers/thermal/thermal_hwmon.c b/drivers/thermal/thermal_hwmon.c
index 79a4de5f9f0e1..55a9bd111d258 100644
--- a/drivers/thermal/thermal_hwmon.c
+++ b/drivers/thermal/thermal_hwmon.c
@@ -101,34 +101,12 @@ thermal_hwmon_lookup_by_type(const struct thermal_zone_device *tz)
 	struct thermal_hwmon_device *hwmon;
 	char type[THERMAL_NAME_LENGTH];
 
-	mutex_lock(&thermal_hwmon_list_lock);
 	list_for_each_entry(hwmon, &thermal_hwmon_list, node) {
 		strcpy(type, tz->type);
 		strreplace(type, '-', '_');
-		if (!strcmp(hwmon->type, type)) {
-			mutex_unlock(&thermal_hwmon_list_lock);
+		if (!strcmp(hwmon->type, type))
 			return hwmon;
-		}
 	}
-	mutex_unlock(&thermal_hwmon_list_lock);
-
-	return NULL;
-}
-
-/* Find the temperature input matching a given thermal zone */
-static struct thermal_hwmon_temp *
-thermal_hwmon_lookup_temp(const struct thermal_hwmon_device *hwmon,
-			  const struct thermal_zone_device *tz)
-{
-	struct thermal_hwmon_temp *temp;
-
-	mutex_lock(&thermal_hwmon_list_lock);
-	list_for_each_entry(temp, &hwmon->tz_list, hwmon_node)
-		if (temp->tz == tz) {
-			mutex_unlock(&thermal_hwmon_list_lock);
-			return temp;
-		}
-	mutex_unlock(&thermal_hwmon_list_lock);
 
 	return NULL;
 }
@@ -144,7 +122,9 @@ int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 	struct thermal_hwmon_device *hwmon;
 	struct thermal_hwmon_temp *temp;
 	int new_hwmon_device = 1;
-	int result;
+	int result = 0;
+
+	mutex_lock(&thermal_hwmon_list_lock);
 
 	hwmon = thermal_hwmon_lookup_by_type(tz);
 	if (hwmon) {
@@ -153,8 +133,10 @@ int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 	}
 
 	hwmon = kzalloc(sizeof(*hwmon), GFP_KERNEL);
-	if (!hwmon)
-		return -ENOMEM;
+	if (!hwmon) {
+		result = -ENOMEM;
+		goto unlock;
+	}
 
 	INIT_LIST_HEAD(&hwmon->tz_list);
 	strscpy(hwmon->type, tz->type, THERMAL_NAME_LENGTH);
@@ -202,24 +184,24 @@ int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 		temp->temp_crit_present = true;
 	}
 
-	mutex_lock(&thermal_hwmon_list_lock);
 	if (new_hwmon_device)
 		list_add_tail(&hwmon->node, &thermal_hwmon_list);
 	list_add_tail(&temp->hwmon_node, &hwmon->tz_list);
-	mutex_unlock(&thermal_hwmon_list_lock);
 
-	return 0;
+	goto unlock;
 
- unregister_input:
+unregister_input:
 	device_remove_file(hwmon->device, &temp->temp_input.attr);
- free_temp_mem:
+free_temp_mem:
 	kfree(temp);
- unregister_name:
+unregister_name:
 	if (new_hwmon_device)
 		hwmon_device_unregister(hwmon->device);
- free_mem:
+free_mem:
 	if (new_hwmon_device)
 		kfree(hwmon);
+unlock:
+	mutex_unlock(&thermal_hwmon_list_lock);
 
 	return result;
 }
@@ -227,8 +209,11 @@ EXPORT_SYMBOL_GPL(thermal_add_hwmon_sysfs);
 
 void thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
 {
+	struct thermal_hwmon_temp *temp, *entry;
 	struct thermal_hwmon_device *hwmon;
-	struct thermal_hwmon_temp *temp;
+	bool unregister;
+
+	guard(mutex)(&thermal_hwmon_list_lock);
 
 	hwmon = thermal_hwmon_lookup_by_type(tz);
 	if (unlikely(!hwmon)) {
@@ -237,29 +222,25 @@ void thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
 		return;
 	}
 
-	temp = thermal_hwmon_lookup_temp(hwmon, tz);
-	if (unlikely(!temp)) {
-		/* Should never happen... */
-		dev_dbg(&tz->device, "temperature input lookup failed!\n");
-		return;
-	}
+	unregister = hwmon->device->parent == &tz->device;
 
-	device_remove_file(hwmon->device, &temp->temp_input.attr);
-	if (temp->temp_crit_present)
-		device_remove_file(hwmon->device, &temp->temp_crit.attr);
+	list_for_each_entry_safe_reverse(temp, entry, &hwmon->tz_list, hwmon_node) {
+		if (!unregister && temp->tz != tz)
+			continue;
 
-	mutex_lock(&thermal_hwmon_list_lock);
-	list_del(&temp->hwmon_node);
-	kfree(temp);
-	if (!list_empty(&hwmon->tz_list)) {
-		mutex_unlock(&thermal_hwmon_list_lock);
-		return;
+		device_remove_file(hwmon->device, &temp->temp_input.attr);
+		if (temp->temp_crit_present)
+			device_remove_file(hwmon->device, &temp->temp_crit.attr);
+
+		list_del(&temp->hwmon_node);
+		kfree(temp);
 	}
-	list_del(&hwmon->node);
-	mutex_unlock(&thermal_hwmon_list_lock);
 
-	hwmon_device_unregister(hwmon->device);
-	kfree(hwmon);
+	if (unregister) {
+		list_del(&hwmon->node);
+		hwmon_device_unregister(hwmon->device);
+		kfree(hwmon);
+	}
 }
 EXPORT_SYMBOL_GPL(thermal_remove_hwmon_sysfs);
 
-- 
2.53.0



