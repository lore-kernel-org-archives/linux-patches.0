Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5B2242D7B;
	Tue, 26 Aug 2025 13:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213759; cv=none; b=YZz3j+IGHHwmv06nv9UA8By30I6Ot3M8TVIc8PswQlXsSlXFWfZrTeOfqNynGjBQfUMylGELkQgXmod8kQHWpgngQU2tPmuAC0RDKk89wvnxnzBwB7vKCj/0reKOp3mjDi9rimbQoxnjEvWqhFp9FCperCCbu07oI7avv+SudY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213759; c=relaxed/simple;
	bh=BBNpcBzAlSUTZVMidv8Bg4rGcBiALZ92Kw9HNJBANjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Opprok/IGI4hZkm/az245lzkRN9P6xlhXnGXHcGEdW0wNq/jF9LC0OK803kiXgaqZDeymZiOeIHzGSOlY9rRiIgvdQDobO1X2/qLn6jGp9Zr7J8hHb5lTojmWPeicNhtafVC5h/3lnGq7/r6jIZG9eOMCB9qdisqnXjSKwSRP7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPs1gSmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPs1gSmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64A5C4CEF4;
	Tue, 26 Aug 2025 13:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213755;
	bh=BBNpcBzAlSUTZVMidv8Bg4rGcBiALZ92Kw9HNJBANjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPs1gSmhd+psMN1Nb3SoSr8M3P4dSEPINsyjcxjXwjvXoG2nA5vlKRqI1PqlaD+/2
	 MsowF3U/W1imflNBGV4MB2bArYIlGwJ7Pl3vKdYPJDC8QrGx54gdN2bgLCbb843uqa
	 vMHtITohlrBP+/aFwcqxlpdVgKmujlC0eKOr+PPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Alex Elder <elder@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.6 467/587] PM: runtime: Simplify pm_runtime_get_if_active() usage
Date: Tue, 26 Aug 2025 13:10:16 +0200
Message-ID: <20250826111004.859046586@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit c0ef3df8dbaef51ee4cfd58a471adf2eaee6f6b3 ]

There are two ways to opportunistically increment a device's runtime PM
usage count, calling either pm_runtime_get_if_active() or
pm_runtime_get_if_in_use(). The former has an argument to tell whether to
ignore the usage count or not, and the latter simply calls the former with
ign_usage_count set to false. The other users that want to ignore the
usage_count will have to explicitly set that argument to true which is a
bit cumbersome.

To make this function more practical to use, remove the ign_usage_count
argument from the function. The main implementation is in a static
function called pm_runtime_get_conditional() and implementations of
pm_runtime_get_if_active() and pm_runtime_get_if_in_use() are moved to
runtime.c.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Takashi Iwai <tiwai@suse.de> # sound/
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com> # drivers/accel/ivpu/
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com> # drivers/gpu/drm/i915/
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com> # drivers/pci/
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ Removed changes to code that didn't exist in older trees ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/power/runtime_pm.rst      |    5 +---
 drivers/base/power/runtime.c            |   35 ++++++++++++++++++++++++++++++--
 drivers/gpu/drm/i915/intel_runtime_pm.c |    5 +++-
 drivers/media/i2c/ccs/ccs-core.c        |    2 -
 drivers/net/ipa/ipa_smp2p.c             |    2 -
 drivers/pci/pci.c                       |    2 -
 drivers/ufs/core/ufshcd-priv.h          |    2 -
 include/linux/pm_runtime.h              |   18 ++--------------
 sound/hda/hdac_device.c                 |    2 -
 9 files changed, 47 insertions(+), 26 deletions(-)

--- a/Documentation/power/runtime_pm.rst
+++ b/Documentation/power/runtime_pm.rst
@@ -398,10 +398,9 @@ drivers/base/power/runtime.c and include
       nonzero, increment the counter and return 1; otherwise return 0 without
       changing the counter
 
-  `int pm_runtime_get_if_active(struct device *dev, bool ign_usage_count);`
+  `int pm_runtime_get_if_active(struct device *dev);`
     - return -EINVAL if 'power.disable_depth' is nonzero; otherwise, if the
-      runtime PM status is RPM_ACTIVE, and either ign_usage_count is true
-      or the device's usage_count is non-zero, increment the counter and
+      runtime PM status is RPM_ACTIVE, increment the counter and
       return 1; otherwise return 0 without changing the counter
 
   `void pm_runtime_put_noidle(struct device *dev);`
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1175,7 +1175,7 @@ int __pm_runtime_resume(struct device *d
 EXPORT_SYMBOL_GPL(__pm_runtime_resume);
 
 /**
- * pm_runtime_get_if_active - Conditionally bump up device usage counter.
+ * pm_runtime_get_conditional - Conditionally bump up device usage counter.
  * @dev: Device to handle.
  * @ign_usage_count: Whether or not to look at the current usage counter value.
  *
@@ -1196,7 +1196,7 @@ EXPORT_SYMBOL_GPL(__pm_runtime_resume);
  * The caller is responsible for decrementing the runtime PM usage counter of
  * @dev after this function has returned a positive value for it.
  */
-int pm_runtime_get_if_active(struct device *dev, bool ign_usage_count)
+static int pm_runtime_get_conditional(struct device *dev, bool ign_usage_count)
 {
 	unsigned long flags;
 	int retval;
@@ -1217,9 +1217,40 @@ int pm_runtime_get_if_active(struct devi
 
 	return retval;
 }
+
+/**
+ * pm_runtime_get_if_active - Bump up runtime PM usage counter if the device is
+ *			      in active state
+ * @dev: Target device.
+ *
+ * Increment the runtime PM usage counter of @dev if its runtime PM status is
+ * %RPM_ACTIVE, in which case it returns 1. If the device is in a different
+ * state, 0 is returned. -EINVAL is returned if runtime PM is disabled for the
+ * device, in which case also the usage_count will remain unmodified.
+ */
+int pm_runtime_get_if_active(struct device *dev)
+{
+	return pm_runtime_get_conditional(dev, true);
+}
 EXPORT_SYMBOL_GPL(pm_runtime_get_if_active);
 
 /**
+ * pm_runtime_get_if_in_use - Conditionally bump up runtime PM usage counter.
+ * @dev: Target device.
+ *
+ * Increment the runtime PM usage counter of @dev if its runtime PM status is
+ * %RPM_ACTIVE and its runtime PM usage counter is greater than 0, in which case
+ * it returns 1. If the device is in a different state or its usage_count is 0,
+ * 0 is returned. -EINVAL is returned if runtime PM is disabled for the device,
+ * in which case also the usage_count will remain unmodified.
+ */
+int pm_runtime_get_if_in_use(struct device *dev)
+{
+	return pm_runtime_get_conditional(dev, false);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_get_if_in_use);
+
+/**
  * __pm_runtime_set_status - Set runtime PM status of a device.
  * @dev: Device to handle.
  * @status: New runtime PM status of the device.
--- a/drivers/gpu/drm/i915/intel_runtime_pm.c
+++ b/drivers/gpu/drm/i915/intel_runtime_pm.c
@@ -434,7 +434,10 @@ static intel_wakeref_t __intel_runtime_p
 		 * function, since the power state is undefined. This applies
 		 * atm to the late/early system suspend/resume handlers.
 		 */
-		if (pm_runtime_get_if_active(rpm->kdev, ignore_usecount) <= 0)
+		if ((ignore_usecount &&
+		     pm_runtime_get_if_active(rpm->kdev) <= 0) ||
+		    (!ignore_usecount &&
+		     pm_runtime_get_if_in_use(rpm->kdev) <= 0))
 			return 0;
 	}
 
--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -665,7 +665,7 @@ static int ccs_set_ctrl(struct v4l2_ctrl
 		break;
 	}
 
-	pm_status = pm_runtime_get_if_active(&client->dev, true);
+	pm_status = pm_runtime_get_if_active(&client->dev);
 	if (!pm_status)
 		return 0;
 
--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -92,7 +92,7 @@ static void ipa_smp2p_notify(struct ipa_
 		return;
 
 	dev = &smp2p->ipa->pdev->dev;
-	smp2p->power_on = pm_runtime_get_if_active(dev, true) > 0;
+	smp2p->power_on = pm_runtime_get_if_active(dev) > 0;
 
 	/* Signal whether the IPA power is enabled */
 	mask = BIT(smp2p->enabled_bit);
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2475,7 +2475,7 @@ static void pci_pme_list_scan(struct wor
 			 * course of the call.
 			 */
 			if (bdev) {
-				bref = pm_runtime_get_if_active(bdev, true);
+				bref = pm_runtime_get_if_active(bdev);
 				if (!bref)
 					continue;
 
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -326,7 +326,7 @@ static inline int ufshcd_rpm_get_sync(st
 
 static inline int ufshcd_rpm_get_if_active(struct ufs_hba *hba)
 {
-	return pm_runtime_get_if_active(&hba->ufs_device_wlun->sdev_gendev, true);
+	return pm_runtime_get_if_active(&hba->ufs_device_wlun->sdev_gendev);
 }
 
 static inline int ufshcd_rpm_put_sync(struct ufs_hba *hba)
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -73,7 +73,8 @@ extern int pm_runtime_force_resume(struc
 extern int __pm_runtime_idle(struct device *dev, int rpmflags);
 extern int __pm_runtime_suspend(struct device *dev, int rpmflags);
 extern int __pm_runtime_resume(struct device *dev, int rpmflags);
-extern int pm_runtime_get_if_active(struct device *dev, bool ign_usage_count);
+extern int pm_runtime_get_if_active(struct device *dev);
+extern int pm_runtime_get_if_in_use(struct device *dev);
 extern int pm_schedule_suspend(struct device *dev, unsigned int delay);
 extern int __pm_runtime_set_status(struct device *dev, unsigned int status);
 extern int pm_runtime_barrier(struct device *dev);
@@ -96,18 +97,6 @@ extern void pm_runtime_release_supplier(
 extern int devm_pm_runtime_enable(struct device *dev);
 
 /**
- * pm_runtime_get_if_in_use - Conditionally bump up runtime PM usage counter.
- * @dev: Target device.
- *
- * Increment the runtime PM usage counter of @dev if its runtime PM status is
- * %RPM_ACTIVE and its runtime PM usage counter is greater than 0.
- */
-static inline int pm_runtime_get_if_in_use(struct device *dev)
-{
-	return pm_runtime_get_if_active(dev, false);
-}
-
-/**
  * pm_suspend_ignore_children - Set runtime PM behavior regarding children.
  * @dev: Target device.
  * @enable: Whether or not to ignore possible dependencies on children.
@@ -277,8 +266,7 @@ static inline int pm_runtime_get_if_in_u
 {
 	return -EINVAL;
 }
-static inline int pm_runtime_get_if_active(struct device *dev,
-					   bool ign_usage_count)
+static inline int pm_runtime_get_if_active(struct device *dev)
 {
 	return -EINVAL;
 }
--- a/sound/hda/hdac_device.c
+++ b/sound/hda/hdac_device.c
@@ -611,7 +611,7 @@ EXPORT_SYMBOL_GPL(snd_hdac_power_up_pm);
 int snd_hdac_keep_power_up(struct hdac_device *codec)
 {
 	if (!atomic_inc_not_zero(&codec->in_pm)) {
-		int ret = pm_runtime_get_if_active(&codec->dev, true);
+		int ret = pm_runtime_get_if_active(&codec->dev);
 		if (!ret)
 			return -1;
 		if (ret < 0)


