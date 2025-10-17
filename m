Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B70C3370FA;
	Fri, 17 Oct 2025 15:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713968; cv=none; b=Xfo0ZfjzLzB8EBbp81Ss5g1Khecz1L8dLt/MaCOAI9rVRBwS8wB+i+K8VDFmAcUCCVQplgQMSE4pwvhlxHKrJYmdqYzpB+ixopjg/CisGDP9r0s/dCfXivQdlg/IywMAzhHFCivcNsM7bXNJ3WWHhSqGxl95uWdeKxG5zon7aJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713968; c=relaxed/simple;
	bh=SgHtOU2TlC53J6BcH8CrOf8qsgjungTChrnKXKv2Z7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pB9PgMZdaK7scrYptwSfKWSoMcekofz5eLJxmawfWDYhYz2pxsSZ65/bKugfiHmzMpGILSC//SSJ6vlUe2Wb/4Htt0F4yjblWHmhSN2jDljoc3OohV8/6Ud+C3qMFU/f1hi+Ulec6RfBmGENIlo8s+yFRHzQxM/rc/gsFEJYar4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cv8eUypv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cv8eUypv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E115C4CEF9;
	Fri, 17 Oct 2025 15:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713968;
	bh=SgHtOU2TlC53J6BcH8CrOf8qsgjungTChrnKXKv2Z7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cv8eUypvS3qjAXdc5iEJrrgeP86XKyNO/YriYmLWzNCgFmXL+yphuYoPxfZm4VnjY
	 pfFn6joCYh0UhkEI5fGawnw73Rc9OG7tWh59S30qSf+Jr5Zj5le+HvI5qHpssqvhPR
	 Q8yAaxprM6hQupt1+jyiR4rZqQB9/y4cnQHLY0XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GuangFei Luo <luogf2025@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/201] ACPI: battery: Add synchronization between interface updates
Date: Fri, 17 Oct 2025 16:54:02 +0200
Message-ID: <20251017145141.405080597@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 399dbcadc01ebf0035f325eaa8c264f8b5cd0a14 ]

There is no synchronization between different code paths in the ACPI
battery driver that update its sysfs interface or its power supply
class device interface.  In some cases this results to functional
failures due to race conditions.

One example of this is when two ACPI notifications:

  - ACPI_BATTERY_NOTIFY_STATUS (0x80)
  - ACPI_BATTERY_NOTIFY_INFO   (0x81)

are triggered (by the platform firmware) in a row with a little delay
in between after removing and reinserting a laptop battery.  Both
notifications cause acpi_battery_update() to be called and if the delay
between them is sufficiently small, sysfs_add_battery() can be re-entered
before battery->bat is set which leads to a duplicate sysfs entry error:

 sysfs: cannot create duplicate filename '/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0A:00/power_supply/BAT1'
 CPU: 1 UID: 0 PID: 185 Comm: kworker/1:4 Kdump: loaded Not tainted 6.12.38+deb13-amd64 #1  Debian 6.12.38-1
 Hardware name: Gateway          NV44             /SJV40-MV        , BIOS V1.3121 04/08/2009
 Workqueue: kacpi_notify acpi_os_execute_deferred
 Call Trace:
  <TASK>
  dump_stack_lvl+0x5d/0x80
  sysfs_warn_dup.cold+0x17/0x23
  sysfs_create_dir_ns+0xce/0xe0
  kobject_add_internal+0xba/0x250
  kobject_add+0x96/0xc0
  ? get_device_parent+0xde/0x1e0
  device_add+0xe2/0x870
  __power_supply_register.part.0+0x20f/0x3f0
  ? wake_up_q+0x4e/0x90
  sysfs_add_battery+0xa4/0x1d0 [battery]
  acpi_battery_update+0x19e/0x290 [battery]
  acpi_battery_notify+0x50/0x120 [battery]
  acpi_ev_notify_dispatch+0x49/0x70
  acpi_os_execute_deferred+0x1a/0x30
  process_one_work+0x177/0x330
  worker_thread+0x251/0x390
  ? __pfx_worker_thread+0x10/0x10
  kthread+0xd2/0x100
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x34/0x50
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 kobject: kobject_add_internal failed for BAT1 with -EEXIST, don't try to register things with the same name in the same directory.

There are also other scenarios in which analogous issues may occur.

Address this by using a common lock in all of the code paths leading
to updates of driver interfaces: ACPI Notify () handler, system resume
callback and post-resume notification, device addition and removal.

This new lock replaces sysfs_lock that has been used only in
sysfs_remove_battery() which now is going to be always called under
the new lock, so it doesn't need any internal locking any more.

Fixes: 10666251554c ("ACPI: battery: Install Notify() handler directly")
Closes: https://lore.kernel.org/linux-acpi/20250910142653.313360-1-luogf2025@163.com/
Reported-by: GuangFei Luo <luogf2025@163.com>
Tested-by: GuangFei Luo <luogf2025@163.com>
Cc: 6.6+ <stable@vger.kernel.org> # 6.6+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/battery.c |   43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -94,7 +94,7 @@ enum {
 
 struct acpi_battery {
 	struct mutex lock;
-	struct mutex sysfs_lock;
+	struct mutex update_lock;
 	struct power_supply *bat;
 	struct power_supply_desc bat_desc;
 	struct acpi_device *device;
@@ -888,15 +888,12 @@ static int sysfs_add_battery(struct acpi
 
 static void sysfs_remove_battery(struct acpi_battery *battery)
 {
-	mutex_lock(&battery->sysfs_lock);
-	if (!battery->bat) {
-		mutex_unlock(&battery->sysfs_lock);
+	if (!battery->bat)
 		return;
-	}
+
 	battery_hook_remove_battery(battery);
 	power_supply_unregister(battery->bat);
 	battery->bat = NULL;
-	mutex_unlock(&battery->sysfs_lock);
 }
 
 static void find_battery(const struct dmi_header *dm, void *private)
@@ -1056,6 +1053,9 @@ static void acpi_battery_notify(acpi_han
 
 	if (!battery)
 		return;
+
+	guard(mutex)(&battery->update_lock);
+
 	old = battery->bat;
 	/*
 	 * On Acer Aspire V5-573G notifications are sometimes triggered too
@@ -1078,21 +1078,22 @@ static void acpi_battery_notify(acpi_han
 }
 
 static int battery_notify(struct notifier_block *nb,
-			       unsigned long mode, void *_unused)
+			  unsigned long mode, void *_unused)
 {
 	struct acpi_battery *battery = container_of(nb, struct acpi_battery,
 						    pm_nb);
-	int result;
 
-	switch (mode) {
-	case PM_POST_HIBERNATION:
-	case PM_POST_SUSPEND:
+	if (mode == PM_POST_SUSPEND || mode == PM_POST_HIBERNATION) {
+		guard(mutex)(&battery->update_lock);
+
 		if (!acpi_battery_present(battery))
 			return 0;
 
 		if (battery->bat) {
 			acpi_battery_refresh(battery);
 		} else {
+			int result;
+
 			result = acpi_battery_get_info(battery);
 			if (result)
 				return result;
@@ -1104,7 +1105,6 @@ static int battery_notify(struct notifie
 
 		acpi_battery_init_alarm(battery);
 		acpi_battery_get_state(battery);
-		break;
 	}
 
 	return 0;
@@ -1182,6 +1182,8 @@ static int acpi_battery_update_retry(str
 {
 	int retry, ret;
 
+	guard(mutex)(&battery->update_lock);
+
 	for (retry = 5; retry; retry--) {
 		ret = acpi_battery_update(battery, false);
 		if (!ret)
@@ -1192,6 +1194,13 @@ static int acpi_battery_update_retry(str
 	return ret;
 }
 
+static void sysfs_battery_cleanup(struct acpi_battery *battery)
+{
+	guard(mutex)(&battery->update_lock);
+
+	sysfs_remove_battery(battery);
+}
+
 static int acpi_battery_add(struct acpi_device *device)
 {
 	int result = 0;
@@ -1214,7 +1223,7 @@ static int acpi_battery_add(struct acpi_
 	if (result)
 		return result;
 
-	result = devm_mutex_init(&device->dev, &battery->sysfs_lock);
+	result = devm_mutex_init(&device->dev, &battery->update_lock);
 	if (result)
 		return result;
 
@@ -1244,7 +1253,7 @@ fail_pm:
 	device_init_wakeup(&device->dev, 0);
 	unregister_pm_notifier(&battery->pm_nb);
 fail:
-	sysfs_remove_battery(battery);
+	sysfs_battery_cleanup(battery);
 
 	return result;
 }
@@ -1263,6 +1272,9 @@ static void acpi_battery_remove(struct a
 
 	device_init_wakeup(&device->dev, 0);
 	unregister_pm_notifier(&battery->pm_nb);
+
+	guard(mutex)(&battery->update_lock);
+
 	sysfs_remove_battery(battery);
 }
 
@@ -1280,6 +1292,9 @@ static int acpi_battery_resume(struct de
 		return -EINVAL;
 
 	battery->update_time = 0;
+
+	guard(mutex)(&battery->update_lock);
+
 	acpi_battery_update(battery, true);
 	return 0;
 }


