Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4311F51B177;
	Thu, 17 Sep 2026 17:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667356; cv=none; b=RXpqS66BbTZsBAlgbbnhRTiCdUKKJy2P5TMfpFtGGHB3h3fIn0QJSdhwIWdnN/G+ZsvI5Zn1GrbP6bRm0iAwnWEih4MVPBbMtZ7ZyjJkLrussbrGXhpvczBewo8awhvpa/f4qrQSEHmwFm0btI0jEwQYBk+jja6AX7+CP9ysxvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667356; c=relaxed/simple;
	bh=n9w2c6zXfV7zJt6cShfiY9Vn/D8Qito6tpslUYGw4ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHi/Ru5fLNzLJ8KoGR1Rx6TeRpIP2crf8d8H7ANBYVLKBZKU7IakgCZsxQgomBmMZHCPRUiyRZwsY+dJJAZhJfhcfeJDmHllPDGXceiYmaKbQyFccTwGhyujZCpN02pn01b4tPiUPgwM3vskGNi60eCvwo1VN0+6QhQJdU7X6wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgUZK6kP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgUZK6kP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484D61F00893;
	Thu, 17 Sep 2026 17:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667354;
	bh=7FDZq2HxW+ftmYCUNjpn1F7IgTknAh2Ez3AHd2uj7FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rgUZK6kP8GFbFlu+SMk03FXgGtpzGqFISsK3k5TZurJZ+9pz8soOiwNadGbncvcDm
	 cYiEuaVt5ymq4C3WclFT7NUZYiPIgr63wrJJw54qmle9atS8+rpwH5UvPW/Mqm7PDo
	 m6zahOvJsuUGJSGh0TlB2Z4hV91Hy/d3Yn15xLFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwendal Grignou <gwendal@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0065/1102] platform/chrome: Resolve kb_wake_angle visibility race
Date: Thu, 17 Sep 2026 16:00:08 +0100
Message-ID: <20260917151541.090627358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 9c944146ee507..1134cfc496083 100644
--- a/drivers/platform/chrome/cros_ec_sysfs.c
+++ b/drivers/platform/chrome/cros_ec_sysfs.c
@@ -334,7 +334,8 @@ static int cros_ec_sysfs_probe(struct platform_device *pd)
 	struct device *dev = &pd->dev;
 	int ret;
 
-	ret = sysfs_create_group(&ec_dev->class_dev.kobj, &cros_ec_attr_group);
+	ec_dev->group = &cros_ec_attr_group;
+	ret = sysfs_create_group(&ec_dev->class_dev.kobj, ec_dev->group);
 	if (ret < 0)
 		dev_err(dev, "failed to create attributes. err=%d\n", ret);
 
@@ -345,7 +346,7 @@ static void cros_ec_sysfs_remove(struct platform_device *pd)
 {
 	struct cros_ec_dev *ec_dev = dev_get_drvdata(pd->dev.parent);
 
-	sysfs_remove_group(&ec_dev->class_dev.kobj, &cros_ec_attr_group);
+	sysfs_remove_group(&ec_dev->class_dev.kobj, ec_dev->group);
 }
 
 static const struct platform_device_id cros_ec_sysfs_id[] = {
diff --git a/include/linux/platform_data/cros_ec_proto.h b/include/linux/platform_data/cros_ec_proto.h
index b34ed0cc1f8dc..25944537e78cd 100644
--- a/include/linux/platform_data/cros_ec_proto.h
+++ b/include/linux/platform_data/cros_ec_proto.h
@@ -215,6 +215,7 @@ struct cros_ec_platform {
 /**
  * struct cros_ec_dev - ChromeOS EC device entry point.
  * @class_dev: Device structure used in sysfs.
+ * @group: sysfs attributes groups for this EC.
  * @ec_dev: cros_ec_device structure to talk to the physical device.
  * @dev: Pointer to the platform device.
  * @debug_info: cros_ec_debugfs structure for debugging information.
@@ -224,6 +225,7 @@ struct cros_ec_platform {
  */
 struct cros_ec_dev {
 	struct device class_dev;
+	const struct attribute_group *group;
 	struct cros_ec_device *ec_dev;
 	struct device *dev;
 	struct cros_ec_debugfs *debug_info;
-- 
2.53.0



