Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD4C43B49E;
	Mon, 17 Aug 2026 13:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974662; cv=none; b=X25jPkfzHuzCVEgiVa6j7Kd+4AsbwE0UQP5k/5jdUFneMqlAAsAzXTXmQOjI+gsSs87OpYoOIgUZb6VeeKu+L1gugEaCYR81FdgT10ams88Ii+CCGCjy9IJJ9/BN1YCAWSkCW6BC8dmRjuCP7kFlyOM7Sz7VkaY/9n/oWh7Zqvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974662; c=relaxed/simple;
	bh=La8VgLa/nqBDE5yz67raa2YdHccpAh8yk4w6NFGEL24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTUCPqg4CYQrO7KAQCn2LQENZCsRunnJDzZp4ZCs9fN5fxuBgHCD+Qo49hj4i7GuOhvf9R9dEBqcR6zzAFsk9dp4kLoV/LfuhYbQIdu/DaD2UwrfhETwdNylOsyiDHPkOxnQAa1TXvgeTCJFxnFTilOJIGW3OxsDGCgpH6zjLMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtGqTEdU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtGqTEdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B84B1F00A3A;
	Mon, 17 Aug 2026 13:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974652;
	bh=fMlt8pTlaCkRUpDDCieGllPCZT8dNBCWTUBkpPZ9xtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtGqTEdUEkIDWcpcq7jN2xDG1dgMBKPAKEPRHAQHx2ZipK3yuefNr296MtNMxAOwr
	 IH/dJZbUWD01ND1gGHkhT7qFApbFu9e1R1ITnyRZb3bY6ACyIqPQfVOtaOsimrz+Qu
	 7oGTLOr+GobC2JSQze09PKou4Z2QtLa1OhQ46ysg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.1 248/271] Revert "thermal: hwmon: Register a hwmon device for each thermal zone"
Date: Mon, 17 Aug 2026 15:32:53 +0200
Message-ID: <20260817132546.955858333@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit f93d951ce0d02b5dca01c0c72add411fb17849bb upstream.

Revert commit d6323469bcfb ("thermal: hwmon: Register a hwmon device
for each thermal zone") that changed the names of hwmon class devices
associated with thermal zones and their sysfs layout which made user
space unhappy.

Closes: https://lore.kernel.org/linux-pm/cafd8af9-c6e9-4bf2-b496-23e796fbc9a6@linux.dev/
Closes: https://lore.kernel.org/linux-hwmon/ab8b093b-46e6-4738-afcf-4b97c9ad5af9@googlemail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2301040.irdbgypaU6@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_hwmon.c |  151 +++++++++++++++++++++++++++-------------
 1 file changed, 104 insertions(+), 47 deletions(-)

--- a/drivers/thermal/thermal_hwmon.c
+++ b/drivers/thermal/thermal_hwmon.c
@@ -19,33 +19,30 @@
 #include "thermal_hwmon.h"
 #include "thermal_core.h"
 
-/*
- * Needs to be large enough to hold a thermal zone type string followed by an
- * underline character and a 32-bit integer in decimal representation.
- */
-#define THERMAL_HWMON_NAME_LENGTH (THERMAL_NAME_LENGTH + 11)
+/* hwmon sys I/F */
+/* thermal zone devices with the same type share one hwmon device */
+struct thermal_hwmon_device {
+	char type[THERMAL_NAME_LENGTH];
+	struct device *device;
+	int count;
+	struct list_head tz_list;
+	struct list_head node;
+};
 
 struct thermal_hwmon_attr {
 	struct device_attribute attr;
+	char name[16];
 };
 
 /* one temperature input for each thermal zone */
 struct thermal_hwmon_temp {
+	struct list_head hwmon_node;
 	struct thermal_zone_device *tz;
 	struct thermal_hwmon_attr temp_input;	/* hwmon sys attr */
 	struct thermal_hwmon_attr temp_crit;	/* hwmon sys attr */
 	bool temp_crit_present;
 };
 
-/* hwmon sys I/F */
-/* thermal zone devices with the same type share one hwmon device */
-struct thermal_hwmon_device {
-	char name[THERMAL_HWMON_NAME_LENGTH];
-	struct device *device;
-	struct list_head node;
-	struct thermal_hwmon_temp tz_temp;
-};
-
 static LIST_HEAD(thermal_hwmon_list);
 
 static DEFINE_MUTEX(thermal_hwmon_list_lock);
@@ -91,6 +88,45 @@ temp_crit_show(struct device *dev, struc
 	return sysfs_emit(buf, "%d\n", temperature);
 }
 
+
+static struct thermal_hwmon_device *
+thermal_hwmon_lookup_by_type(const struct thermal_zone_device *tz)
+{
+	struct thermal_hwmon_device *hwmon;
+	char type[THERMAL_NAME_LENGTH];
+
+	mutex_lock(&thermal_hwmon_list_lock);
+	list_for_each_entry(hwmon, &thermal_hwmon_list, node) {
+		strscpy(type, tz->type);
+		strreplace(type, '-', '_');
+		if (!strcmp(hwmon->type, type)) {
+			mutex_unlock(&thermal_hwmon_list_lock);
+			return hwmon;
+		}
+	}
+	mutex_unlock(&thermal_hwmon_list_lock);
+
+	return NULL;
+}
+
+/* Find the temperature input matching a given thermal zone */
+static struct thermal_hwmon_temp *
+thermal_hwmon_lookup_temp(const struct thermal_hwmon_device *hwmon,
+			  const struct thermal_zone_device *tz)
+{
+	struct thermal_hwmon_temp *temp;
+
+	mutex_lock(&thermal_hwmon_list_lock);
+	list_for_each_entry(temp, &hwmon->tz_list, hwmon_node)
+		if (temp->tz == tz) {
+			mutex_unlock(&thermal_hwmon_list_lock);
+			return temp;
+		}
+	mutex_unlock(&thermal_hwmon_list_lock);
+
+	return NULL;
+}
+
 static bool thermal_zone_crit_temp_valid(struct thermal_zone_device *tz)
 {
 	int temp;
@@ -101,39 +137,54 @@ int thermal_add_hwmon_sysfs(struct therm
 {
 	struct thermal_hwmon_device *hwmon;
 	struct thermal_hwmon_temp *temp;
+	int new_hwmon_device = 1;
 	int result;
 
+	hwmon = thermal_hwmon_lookup_by_type(tz);
+	if (hwmon) {
+		new_hwmon_device = 0;
+		goto register_sys_interface;
+	}
+
 	hwmon = kzalloc_obj(*hwmon);
 	if (!hwmon)
 		return -ENOMEM;
 
-	/*
-	 * Append the thermal zone ID preceded by an underline character to the
-	 * type to disambiguate the sensors command output.
-	 */
-	scnprintf(hwmon->name, THERMAL_HWMON_NAME_LENGTH, "%s_%d", tz->type, tz->id);
-	strreplace(hwmon->name, '-', '_');
+	INIT_LIST_HEAD(&hwmon->tz_list);
+	strscpy(hwmon->type, tz->type, THERMAL_NAME_LENGTH);
+	strreplace(hwmon->type, '-', '_');
 	hwmon->device = hwmon_device_register_for_thermal(&tz->device,
-							  hwmon->name, hwmon);
+							  hwmon->type, hwmon);
 	if (IS_ERR(hwmon->device)) {
 		result = PTR_ERR(hwmon->device);
 		goto free_mem;
 	}
 
-	temp = &hwmon->tz_temp;
+ register_sys_interface:
+	temp = kzalloc_obj(*temp);
+	if (!temp) {
+		result = -ENOMEM;
+		goto unregister_name;
+	}
 
 	temp->tz = tz;
+	hwmon->count++;
 
-	temp->temp_input.attr.attr.name = "temp1_input";
+	snprintf(temp->temp_input.name, sizeof(temp->temp_input.name),
+		 "temp%d_input", hwmon->count);
+	temp->temp_input.attr.attr.name = temp->temp_input.name;
 	temp->temp_input.attr.attr.mode = 0444;
 	temp->temp_input.attr.show = temp_input_show;
 	sysfs_attr_init(&temp->temp_input.attr.attr);
 	result = device_create_file(hwmon->device, &temp->temp_input.attr);
 	if (result)
-		goto unregister_name;
+		goto free_temp_mem;
 
 	if (thermal_zone_crit_temp_valid(tz)) {
-		temp->temp_crit.attr.attr.name = "temp1_crit";
+		snprintf(temp->temp_crit.name,
+				sizeof(temp->temp_crit.name),
+				"temp%d_crit", hwmon->count);
+		temp->temp_crit.attr.attr.name = temp->temp_crit.name;
 		temp->temp_crit.attr.attr.mode = 0444;
 		temp->temp_crit.attr.show = temp_crit_show;
 		sysfs_attr_init(&temp->temp_crit.attr.attr);
@@ -145,17 +196,21 @@ int thermal_add_hwmon_sysfs(struct therm
 		temp->temp_crit_present = true;
 	}
 
-	/* The list is needed for hwmon lookup during removal. */
 	mutex_lock(&thermal_hwmon_list_lock);
-	list_add_tail(&hwmon->node, &thermal_hwmon_list);
+	if (new_hwmon_device)
+		list_add_tail(&hwmon->node, &thermal_hwmon_list);
+	list_add_tail(&temp->hwmon_node, &hwmon->tz_list);
 	mutex_unlock(&thermal_hwmon_list_lock);
 
 	return 0;
 
  unregister_input:
 	device_remove_file(hwmon->device, &temp->temp_input.attr);
+ free_temp_mem:
+	kfree(temp);
  unregister_name:
-	hwmon_device_unregister(hwmon->device);
+	if (new_hwmon_device)
+		hwmon_device_unregister(hwmon->device);
  free_mem:
 	if (new_hwmon_device)
 		kfree(hwmon);
@@ -164,37 +219,39 @@ int thermal_add_hwmon_sysfs(struct therm
 }
 EXPORT_SYMBOL_GPL(thermal_add_hwmon_sysfs);
 
-static struct thermal_hwmon_device *
-thermal_hwmon_lookup(const struct thermal_zone_device *tz)
-{
-	struct thermal_hwmon_device *hwmon;
-
-	list_for_each_entry(hwmon, &thermal_hwmon_list, node) {
-		if (hwmon->tz_temp.tz == tz)
-			return hwmon;
-	}
-	return NULL;
-}
-
 void thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
 {
 	struct thermal_hwmon_device *hwmon;
 	struct thermal_hwmon_temp *temp;
 
-	scoped_guard(mutex, &thermal_hwmon_list_lock) {
-		hwmon = thermal_hwmon_lookup(tz);
-		if (!hwmon)
-			return;
-
-		list_del(&hwmon->node);
+	hwmon = thermal_hwmon_lookup_by_type(tz);
+	if (unlikely(!hwmon)) {
+		/* Should never happen... */
+		dev_dbg(&tz->device, "hwmon device lookup failed!\n");
+		return;
 	}
 
-	temp = &hwmon->tz_temp;
+	temp = thermal_hwmon_lookup_temp(hwmon, tz);
+	if (unlikely(!temp)) {
+		/* Should never happen... */
+		dev_dbg(&tz->device, "temperature input lookup failed!\n");
+		return;
+	}
 
 	device_remove_file(hwmon->device, &temp->temp_input.attr);
 	if (temp->temp_crit_present)
 		device_remove_file(hwmon->device, &temp->temp_crit.attr);
 
+	mutex_lock(&thermal_hwmon_list_lock);
+	list_del(&temp->hwmon_node);
+	kfree(temp);
+	if (!list_empty(&hwmon->tz_list)) {
+		mutex_unlock(&thermal_hwmon_list_lock);
+		return;
+	}
+	list_del(&hwmon->node);
+	mutex_unlock(&thermal_hwmon_list_lock);
+
 	hwmon_device_unregister(hwmon->device);
 	kfree(hwmon);
 }


