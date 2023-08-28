Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96D311C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCCAC433C7;
	Mon, 28 Aug 2023 10:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219076;
	bh=ZsdyR5WaBTiL1I4sK+PMn6xLDoCylZT6d1p00EH5YsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vT9nPUOB7SP1Lv971mryJ6+5pyfwq6XGZjEc7R7dNKMwkIW6asOmEI+4f3sR58Xv8
	 8YkOuUBrqvxtbdiy+Stwc8YqcAfZOYnTuujglSKYHXXahNiKSx0qyxBWI8CNawmbFz
	 rAdwVPyAHx0iXNQym0LUTZqthj5EFpyLL99gAXhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/158] PM: runtime: Add pm_runtime_get_if_active()
Date: Mon, 28 Aug 2023 12:12:13 +0200
Message-ID: <20230828101158.560055099@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit c111566bea7ccd8a05e2c56f1fb3cbb6f4b7b441 ]

pm_runtime_get_if_in_use() bumps up the PM-runtime usage count if it
is not equal to zero and the device's PM-runtime status is 'active'.
This works for drivers that do not use autoidle, but for those that
do, the function returns zero even when the device is active.

In order to maintain sane device state while the device is powered on
in the hope that it'll be needed, pm_runtime_get_if_active(dev, true)
returns a positive value if the device's PM-runtime status is 'active'
when it is called, in which case it also increments the device's usage
count.

If the second argument of pm_runtime_get_if_active() is 'false', the
function behaves just like pm_runtime_get_if_in_use(), so redefine
the latter as a wrapper around the former.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
[ rjw: Changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 81302b1c7c99 ("ALSA: hda: Fix unhandled register update during auto-suspend period")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/power/runtime_pm.rst |  6 +++++
 drivers/base/power/runtime.c       | 36 ++++++++++++++++++++++--------
 include/linux/pm_runtime.h         | 12 +++++++++-
 3 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/Documentation/power/runtime_pm.rst b/Documentation/power/runtime_pm.rst
index 2c2ec99b50886..78bef529464fa 100644
--- a/Documentation/power/runtime_pm.rst
+++ b/Documentation/power/runtime_pm.rst
@@ -382,6 +382,12 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
       nonzero, increment the counter and return 1; otherwise return 0 without
       changing the counter
 
+  `int pm_runtime_get_if_active(struct device *dev, bool ign_usage_count);`
+    - return -EINVAL if 'power.disable_depth' is nonzero; otherwise, if the
+      runtime PM status is RPM_ACTIVE, and either ign_usage_count is true
+      or the device's usage_count is non-zero, increment the counter and
+      return 1; otherwise return 0 without changing the counter
+
   `void pm_runtime_put_noidle(struct device *dev);`
     - decrement the device's usage counter
 
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 6e110c80079d7..7f93ac63b5b64 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1129,29 +1129,47 @@ int __pm_runtime_resume(struct device *dev, int rpmflags)
 EXPORT_SYMBOL_GPL(__pm_runtime_resume);
 
 /**
- * pm_runtime_get_if_in_use - Conditionally bump up the device's usage counter.
+ * pm_runtime_get_if_active - Conditionally bump up the device's usage counter.
  * @dev: Device to handle.
  *
  * Return -EINVAL if runtime PM is disabled for the device.
  *
- * If that's not the case and if the device's runtime PM status is RPM_ACTIVE
- * and the runtime PM usage counter is nonzero, increment the counter and
- * return 1.  Otherwise return 0 without changing the counter.
+ * Otherwise, if the device's runtime PM status is RPM_ACTIVE and either
+ * ign_usage_count is true or the device's usage_count is non-zero, increment
+ * the counter and return 1. Otherwise return 0 without changing the counter.
+ *
+ * If ign_usage_count is true, the function can be used to prevent suspending
+ * the device when its runtime PM status is RPM_ACTIVE.
+ *
+ * If ign_usage_count is false, the function can be used to prevent suspending
+ * the device when both its runtime PM status is RPM_ACTIVE and its usage_count
+ * is non-zero.
+ *
+ * The caller is resposible for putting the device's usage count when ther
+ * return value is greater than zero.
  */
-int pm_runtime_get_if_in_use(struct device *dev)
+int pm_runtime_get_if_active(struct device *dev, bool ign_usage_count)
 {
 	unsigned long flags;
 	int retval;
 
 	spin_lock_irqsave(&dev->power.lock, flags);
-	retval = dev->power.disable_depth > 0 ? -EINVAL :
-		dev->power.runtime_status == RPM_ACTIVE
-			&& atomic_inc_not_zero(&dev->power.usage_count);
+	if (dev->power.disable_depth > 0) {
+		retval = -EINVAL;
+	} else if (dev->power.runtime_status != RPM_ACTIVE) {
+		retval = 0;
+	} else if (ign_usage_count) {
+		retval = 1;
+		atomic_inc(&dev->power.usage_count);
+	} else {
+		retval = atomic_inc_not_zero(&dev->power.usage_count);
+	}
 	trace_rpm_usage_rcuidle(dev, 0);
 	spin_unlock_irqrestore(&dev->power.lock, flags);
+
 	return retval;
 }
-EXPORT_SYMBOL_GPL(pm_runtime_get_if_in_use);
+EXPORT_SYMBOL_GPL(pm_runtime_get_if_active);
 
 /**
  * __pm_runtime_set_status - Set runtime PM status of a device.
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 7145795b4b9da..f615e217e575a 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -38,7 +38,7 @@ extern int pm_runtime_force_resume(struct device *dev);
 extern int __pm_runtime_idle(struct device *dev, int rpmflags);
 extern int __pm_runtime_suspend(struct device *dev, int rpmflags);
 extern int __pm_runtime_resume(struct device *dev, int rpmflags);
-extern int pm_runtime_get_if_in_use(struct device *dev);
+extern int pm_runtime_get_if_active(struct device *dev, bool ign_usage_count);
 extern int pm_schedule_suspend(struct device *dev, unsigned int delay);
 extern int __pm_runtime_set_status(struct device *dev, unsigned int status);
 extern int pm_runtime_barrier(struct device *dev);
@@ -59,6 +59,11 @@ extern void pm_runtime_put_suppliers(struct device *dev);
 extern void pm_runtime_new_link(struct device *dev);
 extern void pm_runtime_drop_link(struct device_link *link);
 
+static inline int pm_runtime_get_if_in_use(struct device *dev)
+{
+	return pm_runtime_get_if_active(dev, false);
+}
+
 static inline void pm_suspend_ignore_children(struct device *dev, bool enable)
 {
 	dev->power.ignore_children = enable;
@@ -142,6 +147,11 @@ static inline int pm_runtime_get_if_in_use(struct device *dev)
 {
 	return -EINVAL;
 }
+static inline int pm_runtime_get_if_active(struct device *dev,
+					   bool ign_usage_count)
+{
+	return -EINVAL;
+}
 static inline int __pm_runtime_set_status(struct device *dev,
 					    unsigned int status) { return 0; }
 static inline int pm_runtime_barrier(struct device *dev) { return 0; }
-- 
2.40.1



