Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3574ED1B7;
	Thu, 17 Sep 2026 16:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661124; cv=none; b=RY7Z9p1dl9nUjsTbS2SF4NhFCQOEh2JT9wA0XqMJAhY3k/H6jv0OtZC8e2JwB5Bjq4HX3f8N+jGM+rUWjW/r9cTUyphKq3NImzA+o6AbYcWhBlEhdQpyrF22zhT1fg0i4iRSdhDmkNB7LYdpKUsW0Xm/mSZu57KLgQtnVXkfYb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661124; c=relaxed/simple;
	bh=jkhRVfDVfnzvncQHQI0KKmT0+zNvDh38XrtI23mmlrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLxVJH0iC6LbLCKCbqTgu6e95UtZcmYD3gIidL1PvuccwAkGNtmrDPxLQAaHlPuh45R41mttS+d38YpIM1kzr10754GjVHBPcuInSwipa42JQinX8LmfEKU1CdRy6mhJbMmSt/wjBVcM5fYAA/lm9PH+uGflr3sS8XZVLQnV6r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmY+Oo2+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmY+Oo2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68CD1F00893;
	Thu, 17 Sep 2026 16:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661123;
	bh=pBw+3cBYgAlshXOsGnzkEP/rIoXpUpRW+2qIufroE2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmY+Oo2+Ag34QTw1whlB2S2O2az2M6xiajZWaCIcAd6JHXDSGoM/mJp+TEiAGUb0b
	 2xyiKrUfC9Ws59Og7OARNEXROWriJVZcSQF3wMNDkUcWR3pVcuf4t80C5CNt7B77hi
	 HkQSuGDpQjBGsGLoTWUalYskgg17jZitYQDv7J4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwendal Grignou <gwendal@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0091/1250] platform/chrome: Resolve kb_wake_angle visibility race
Date: Thu, 17 Sep 2026 15:58:06 +0100
Message-ID: <20260917151554.451341087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit c40f5f9927b5bf6062daa1e293ae32d83afc963e ]

A race condition exists between the probe of cros-ec-sysfs and
cros-ec-sensorhub.

The `kb_wake_angle` attribute should only be visible if the sensor hub
detects two or more accelerometers.  If cros_ec_sysfs_probe() runs
before cros_ec_sensorhub_register() completes sensor enumeration, the
sysfs attributes are created while `has_kb_wake_angle` is still false,
hiding `kb_wake_angle` incorrectly.

Store the created attribute group pointer in `ec_dev->group`.  When
the sensor hub completes sensor enumeration, it checks for this group
and calls sysfs_update_group() to notify the sysfs core to re-evaluate
attribute visibility.  This ensures the `kb_wake_angle` attribute
visibility is correctly updated regardless of the driver probe order.

Co-developed-by: Gwendal Grignou <gwendal@chromium.org>
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Link: https://lore.kernel.org/r/20260407102615.1605317-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_sensorhub.c | 6 +++++-
 drivers/platform/chrome/cros_ec_sysfs.c     | 5 +++--
 include/linux/platform_data/cros_ec_proto.h | 2 ++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_sensorhub.c b/drivers/platform/chrome/cros_ec_sensorhub.c
index 9bad8f72680ea..f938c3fc84e4f 100644
--- a/drivers/platform/chrome/cros_ec_sensorhub.c
+++ b/drivers/platform/chrome/cros_ec_sensorhub.c
@@ -122,8 +122,12 @@ static int cros_ec_sensorhub_register(struct device *dev,
 		sensor_type[sensorhub->resp->info.type]++;
 	}
 
-	if (sensor_type[MOTIONSENSE_TYPE_ACCEL] >= 2)
+	if (sensor_type[MOTIONSENSE_TYPE_ACCEL] >= 2) {
 		ec->has_kb_wake_angle = true;
+		if (ec->group && sysfs_update_group(&ec->class_dev.kobj,
+						    ec->group))
+			dev_warn(dev, "Unable to update sysfs");
+	}
 
 	if (cros_ec_check_features(ec,
 				   EC_FEATURE_REFINED_TABLET_MODE_HYSTERESIS)) {
diff --git a/drivers/platform/chrome/cros_ec_sysfs.c b/drivers/platform/chrome/cros_ec_sysfs.c
index f22e9523da3e8..9d3767ab15480 100644
--- a/drivers/platform/chrome/cros_ec_sysfs.c
+++ b/drivers/platform/chrome/cros_ec_sysfs.c
@@ -405,7 +405,8 @@ static int cros_ec_sysfs_probe(struct platform_device *pd)
 	struct device *dev = &pd->dev;
 	int ret;
 
-	ret = sysfs_create_group(&ec_dev->class_dev.kobj, &cros_ec_attr_group);
+	ec_dev->group = &cros_ec_attr_group;
+	ret = sysfs_create_group(&ec_dev->class_dev.kobj, ec_dev->group);
 	if (ret < 0)
 		dev_err(dev, "failed to create attributes. err=%d\n", ret);
 
@@ -416,7 +417,7 @@ static void cros_ec_sysfs_remove(struct platform_device *pd)
 {
 	struct cros_ec_dev *ec_dev = dev_get_drvdata(pd->dev.parent);
 
-	sysfs_remove_group(&ec_dev->class_dev.kobj, &cros_ec_attr_group);
+	sysfs_remove_group(&ec_dev->class_dev.kobj, ec_dev->group);
 }
 
 static const struct platform_device_id cros_ec_sysfs_id[] = {
diff --git a/include/linux/platform_data/cros_ec_proto.h b/include/linux/platform_data/cros_ec_proto.h
index de14923720a53..6ed1c4c5ce2ef 100644
--- a/include/linux/platform_data/cros_ec_proto.h
+++ b/include/linux/platform_data/cros_ec_proto.h
@@ -228,6 +228,7 @@ struct cros_ec_platform {
 /**
  * struct cros_ec_dev - ChromeOS EC device entry point.
  * @class_dev: Device structure used in sysfs.
+ * @group: sysfs attributes groups for this EC.
  * @ec_dev: cros_ec_device structure to talk to the physical device.
  * @dev: Pointer to the platform device.
  * @debug_info: cros_ec_debugfs structure for debugging information.
@@ -237,6 +238,7 @@ struct cros_ec_platform {
  */
 struct cros_ec_dev {
 	struct device class_dev;
+	const struct attribute_group *group;
 	struct cros_ec_device *ec_dev;
 	struct device *dev;
 	struct cros_ec_debugfs *debug_info;
-- 
2.53.0



