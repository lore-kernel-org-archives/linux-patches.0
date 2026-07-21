Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A932135AD;
	Tue, 21 Jul 2026 18:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659214; cv=none; b=JsBdtz0MK47oz5JJgve3TN58mMp3Hssx6QKZql8+QVjwd02bsDB10fxktmIJvoCf8wpOQCvDwsw2dEcn7JdOVnULO7CxCTOqgP74LHsNNwmpRbbWV1SuNDzlA+Ov02W7z7ZoEcC7XcOqFtmajFev6W4k887Bo2elSkhXUstEdC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659214; c=relaxed/simple;
	bh=KHtEE7EWbsmorqM/mWjiMOAVTLwFS4I6xHXIwSy6+rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fm4yohsTQLkM8ShTiljc4L0pfzXlGs6oIj1VNsuiVfXBNXXazx7bD9/8mi9KT4ThmhrJDzj2/tqxgDnPzIcjcB9z+BX1isA+YySkgFz2BJiaHY6N1JjTEmxeWB4U/6P2VLBI4e70rGA5cqhENssZXNl+9gNjS40jDbDkQa6QFQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMdzRSgL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMdzRSgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF971F000E9;
	Tue, 21 Jul 2026 18:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659213;
	bh=04F0zilJH1ExSi8/5IXaqQqu7obaJuZO8V5cnRcXwWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMdzRSgLRRmFECRQoXhSd2zx/YnMpWywgbXGIQm6K2hu59i+trSxgc+RlRSzBfZDp
	 rms6gwFMJ0YmyfjctEV9qVk2T5u6IYrTsL1KZujEn956DiBGEpboQMXelgTV0QHbN7
	 Mu6L2z45X7Nod58G9NVZfDSClxPoOkr+kG3D9fAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 1434/1611] hwmon: (occ) unregister sysfs devices outside occ lock
Date: Tue, 21 Jul 2026 17:25:50 +0200
Message-ID: <20260721152547.697634614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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


