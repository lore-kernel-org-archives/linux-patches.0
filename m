Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D2D470105;
	Tue, 21 Jul 2026 20:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664100; cv=none; b=grPHtFALuqwwbRkGh4HfLs7tiudCVR4iYLoCEMon388ZWSzWelKmi6ta2QvFU9LSa1epivQZHNtR1EqD6jl8++Pa/HVdzkJYl+uNDF6wRTpK2XLObWqYdhePmowOLhbV26YM9peMyzbKQwj0vMADcabZuEKyZLuEtEEpHIpTlgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664100; c=relaxed/simple;
	bh=TDKDuevs2hhhiEMkP7OE9w2QULu8TfPPEq7EFg+30+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAh9EYVQeIL7H8zXPs//7f3DaXvC9cEI1bnC8tsNkvVXfvLcBlsIvkkM0VeKknB29JupB2y20dmUsgvM6GO5gDgPveU4rPP1Y13k153mxrGROKAsQP7opZU9M7/uTisz6mjsS/dHvqs+r3u32TrQlUwjyCtxZLq0ITrz7AWxBBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SJ7NR15; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SJ7NR15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E671F000E9;
	Tue, 21 Jul 2026 20:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664098;
	bh=fCK0FXtf4E0rXKxNbtDa5iD1QFeISLdyU9Ti9hePmGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SJ7NR15Jbebddm2gj9SuhliKmd1WNA9MCRcUspPS4eI3h9BS6qL9p0QetqyJJOtu
	 5qRWHLu2gBEvu5BgwQ8xVpo4frwQhMJltqqp1xiHvz4l/zhaR3Z6YhCwGyPMAdbofu
	 AZ7fHUV8fVwiZ2GdN3i9w6V5kR02PSr/5fZ2GkSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 1073/1276] hwmon: (occ) unregister sysfs devices outside occ lock
Date: Tue, 21 Jul 2026 17:25:16 +0200
Message-ID: <20260721152509.999050981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit e31408734332b8cc611342cdaaab6ba492180156 upstream.

occ_active(false) and occ_shutdown() unregister sysfs-backed devices while
occ->lock is held.  hwmon_device_unregister() and sysfs_remove_group() can
wait for active sysfs callbacks to drain, and those callbacks can enter the
OCC update path and try to take occ->lock again.  That gives the unregister
paths the lock ordering occ->lock -> sysfs callback drain, while a callback
has the opposite edge sysfs callback -> occ->lock.

This issue was found by our static analysis tool and then manually
reviewed against the current tree.

The grounded PoC kept the real unregister and callback carrier:

  occ_shutdown()
  hwmon_device_unregister()
  occ_show_temp_1()
  occ_update_response()

Lockdep reported the circular dependency with occ_shutdown() already
holding the OCC mutex and hwmon_device_unregister() waiting on the sysfs
side:

  WARNING: possible circular locking dependency detected
  ... (sysfs_lock) ... at: hwmon_device_unregister+0x12/0x30 [vuln_msv]
  ... (&test_occ.lock) ... at: occ_shutdown.constprop.0+0xe/0x40 [vuln_msv]
  occ_update_response.isra.0+0xb/0x20 [vuln_msv]
  occ_show_temp_1.constprop.0.isra.0+0x23/0x40 [vuln_msv]
  *** DEADLOCK ***

Serialize hwmon registration and removal with a separate hwmon_lock.
Under that lock, detach occ->hwmon and update occ->active while occ->lock
is held so concurrent OCC state changes still see a stable state, then
drop occ->lock before calling hwmon_device_unregister().  Remove the
driver sysfs group before taking occ->lock in occ_shutdown(), so draining
the driver attributes cannot wait while the OCC mutex is held.  Also make
OCC update callbacks return -ENODEV after deactivation, so callbacks that
already passed sysfs active protection do not poll the hardware after
teardown has detached the hwmon device.

Fixes: 849b0156d996 ("hwmon: (occ) Delay hwmon registration until user request")
Fixes: ac6888ac5a11 ("hwmon: (occ) Lock mutex in shutdown to prevent race with occ_active")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://lore.kernel.org/r/20260619015938.494464-1-runyu.xiao@seu.edu.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/occ/common.c |   34 ++++++++++++++++++++++++++++------
 drivers/hwmon/occ/common.h |    1 +
 2 files changed, 29 insertions(+), 6 deletions(-)

--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -214,6 +214,11 @@ int occ_update_response(struct occ *occ)
 	if (rc)
 		return rc;
 
+	if (!occ->active) {
+		rc = -ENODEV;
+		goto unlock;
+	}
+
 	/* limit the maximum rate of polling the OCC */
 	if (time_after(jiffies, occ->next_update)) {
 		rc = occ_poll(occ);
@@ -222,6 +227,7 @@ int occ_update_response(struct occ *occ)
 		rc = occ->last_error;
 	}
 
+unlock:
 	mutex_unlock(&occ->lock);
 	return rc;
 }
@@ -1105,11 +1111,16 @@ static void occ_parse_poll_response(stru
 
 int occ_active(struct occ *occ, bool active)
 {
-	int rc = mutex_lock_interruptible(&occ->lock);
+	struct device *hwmon = NULL;
+	int rc = mutex_lock_interruptible(&occ->hwmon_lock);
 
 	if (rc)
 		return rc;
 
+	rc = mutex_lock_interruptible(&occ->lock);
+	if (rc)
+		goto unlock_hwmon;
+
 	if (active) {
 		if (occ->active) {
 			rc = -EALREADY;
@@ -1154,14 +1165,17 @@ int occ_active(struct occ *occ, bool act
 			goto unlock;
 		}
 
-		if (occ->hwmon)
-			hwmon_device_unregister(occ->hwmon);
+		hwmon = occ->hwmon;
 		occ->active = false;
 		occ->hwmon = NULL;
 	}
 
 unlock:
 	mutex_unlock(&occ->lock);
+	if (hwmon)
+		hwmon_device_unregister(hwmon);
+unlock_hwmon:
+	mutex_unlock(&occ->hwmon_lock);
 	return rc;
 }
 
@@ -1170,6 +1184,7 @@ int occ_setup(struct occ *occ)
 	int rc;
 
 	mutex_init(&occ->lock);
+	mutex_init(&occ->hwmon_lock);
 	occ->groups[0] = &occ->group;
 
 	rc = occ_setup_sysfs(occ);
@@ -1190,15 +1205,22 @@ EXPORT_SYMBOL_GPL(occ_setup);
 
 void occ_shutdown(struct occ *occ)
 {
-	mutex_lock(&occ->lock);
+	struct device *hwmon;
 
 	occ_shutdown_sysfs(occ);
 
-	if (occ->hwmon)
-		hwmon_device_unregister(occ->hwmon);
+	mutex_lock(&occ->hwmon_lock);
+	mutex_lock(&occ->lock);
+
+	hwmon = occ->hwmon;
+	occ->active = false;
 	occ->hwmon = NULL;
 
 	mutex_unlock(&occ->lock);
+
+	if (hwmon)
+		hwmon_device_unregister(hwmon);
+	mutex_unlock(&occ->hwmon_lock);
 }
 EXPORT_SYMBOL_GPL(occ_shutdown);
 
--- a/drivers/hwmon/occ/common.h
+++ b/drivers/hwmon/occ/common.h
@@ -101,6 +101,7 @@ struct occ {
 
 	unsigned long next_update;
 	struct mutex lock;		/* lock OCC access */
+	struct mutex hwmon_lock;		/* serialize hwmon registration/removal */
 
 	struct device *hwmon;
 	struct occ_attribute *attrs;


