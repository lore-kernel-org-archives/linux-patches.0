Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A108346A0F;
	Tue, 11 Nov 2025 01:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823655; cv=none; b=bpKakqFXTV5s0N1pb/Leve7wW2K4dEncAko6ElkQG0CaLbgS4cZNRZ+oYylRZ0hA+2aH1a11VkEWIEYsYoVF/X1QHRnzk1ayyXQc+K6aRUhCdA2q1Ga1drMNB14ad6Pa7+7jHjWb9s3TgHDzIpgJ687M7DmQFMm/JOsHLAjfqow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823655; c=relaxed/simple;
	bh=sdY4fhzfD6lloFaDqHjO8x1YvU5N36KmPimE4KrHPYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MyLGiQWCSdHuy/+0MU+1nEF+HBoGAcW6ehM3fxkH4imAHuZqKlsjqOQXGVTCVZfMvZYD4lYJPnXtYSraWJGVtOt3NG//HJc58GPX/ainPMMmyzfeJzrI0n4Ii1lGKYUO3N7MI24PYj36nDVdxVvKgRGumtUL6iIxXbFYrSvFh04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5D0tuEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5D0tuEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717F6C16AAE;
	Tue, 11 Nov 2025 01:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823654;
	bh=sdY4fhzfD6lloFaDqHjO8x1YvU5N36KmPimE4KrHPYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5D0tuEe/fWnVsiWBNZOv7vdsr2dgnL6QvQoq8tmE5zJClh26MXe8NMcqgthx65Ou
	 HQa88Txr3S6YY8gXex9PF5GQTDbhYZ3rgs/2A4b66C0t1hRSMAZvWQLo2mYHyUNNGs
	 75FjHyb4DZNbvdRDjfC87TrV7NpvPDNTadYZKJIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Summers <stuart.summers@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 344/849] drm/xe/pcode: Initialize data0 for pcode read routine
Date: Tue, 11 Nov 2025 09:38:34 +0900
Message-ID: <20251111004544.737166448@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Summers <stuart.summers@intel.com>

[ Upstream commit 2515d2b9ab4108c11a0b23935e68de27abb8b2a7 ]

There are two registers filled in when reading data from
pcode besides the mailbox itself. Currently, we allow a NULL
value for the second of these two (data1) and assume the first
is defined. However, many of the routines that are calling
this function assume that pcode will ignore the value being
passed in and so leave that first value (data0) defined but
uninitialized. To be safe, make sure this value is always
initialized to something (0 generally) in the event pcode
behavior changes and starts using this value.

v2: Fix sob/author

Signed-off-by: Stuart Summers <stuart.summers@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Link: https://lore.kernel.org/r/20250819201054.393220-1-stuart.summers@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device_sysfs.c | 8 ++++----
 drivers/gpu/drm/xe/xe_hwmon.c        | 8 ++++----
 drivers/gpu/drm/xe/xe_vram_freq.c    | 4 ++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device_sysfs.c b/drivers/gpu/drm/xe/xe_device_sysfs.c
index 927ee7991696b..896484c8fbcc7 100644
--- a/drivers/gpu/drm/xe/xe_device_sysfs.c
+++ b/drivers/gpu/drm/xe/xe_device_sysfs.c
@@ -76,7 +76,7 @@ lb_fan_control_version_show(struct device *dev, struct device_attribute *attr, c
 {
 	struct xe_device *xe = pdev_to_xe_device(to_pci_dev(dev));
 	struct xe_tile *root = xe_device_get_root_tile(xe);
-	u32 cap, ver_low = FAN_TABLE, ver_high = FAN_TABLE;
+	u32 cap = 0, ver_low = FAN_TABLE, ver_high = FAN_TABLE;
 	u16 major = 0, minor = 0, hotfix = 0, build = 0;
 	int ret;
 
@@ -115,7 +115,7 @@ lb_voltage_regulator_version_show(struct device *dev, struct device_attribute *a
 {
 	struct xe_device *xe = pdev_to_xe_device(to_pci_dev(dev));
 	struct xe_tile *root = xe_device_get_root_tile(xe);
-	u32 cap, ver_low = VR_CONFIG, ver_high = VR_CONFIG;
+	u32 cap = 0, ver_low = VR_CONFIG, ver_high = VR_CONFIG;
 	u16 major = 0, minor = 0, hotfix = 0, build = 0;
 	int ret;
 
@@ -153,7 +153,7 @@ static int late_bind_create_files(struct device *dev)
 {
 	struct xe_device *xe = pdev_to_xe_device(to_pci_dev(dev));
 	struct xe_tile *root = xe_device_get_root_tile(xe);
-	u32 cap;
+	u32 cap = 0;
 	int ret;
 
 	xe_pm_runtime_get(xe);
@@ -186,7 +186,7 @@ static void late_bind_remove_files(struct device *dev)
 {
 	struct xe_device *xe = pdev_to_xe_device(to_pci_dev(dev));
 	struct xe_tile *root = xe_device_get_root_tile(xe);
-	u32 cap;
+	u32 cap = 0;
 	int ret;
 
 	xe_pm_runtime_get(xe);
diff --git a/drivers/gpu/drm/xe/xe_hwmon.c b/drivers/gpu/drm/xe/xe_hwmon.c
index c5b63e10bb911..5ade08f90b89a 100644
--- a/drivers/gpu/drm/xe/xe_hwmon.c
+++ b/drivers/gpu/drm/xe/xe_hwmon.c
@@ -179,7 +179,7 @@ static int xe_hwmon_pcode_rmw_power_limit(const struct xe_hwmon *hwmon, u32 attr
 					  u32 clr, u32 set)
 {
 	struct xe_tile *root_tile = xe_device_get_root_tile(hwmon->xe);
-	u32 val0, val1;
+	u32 val0 = 0, val1 = 0;
 	int ret = 0;
 
 	ret = xe_pcode_read(root_tile, PCODE_MBOX(PCODE_POWER_SETUP,
@@ -737,7 +737,7 @@ static int xe_hwmon_power_curr_crit_read(struct xe_hwmon *hwmon, int channel,
 					 long *value, u32 scale_factor)
 {
 	int ret;
-	u32 uval;
+	u32 uval = 0;
 
 	mutex_lock(&hwmon->hwmon_lock);
 
@@ -921,7 +921,7 @@ xe_hwmon_power_write(struct xe_hwmon *hwmon, u32 attr, int channel, long val)
 static umode_t
 xe_hwmon_curr_is_visible(const struct xe_hwmon *hwmon, u32 attr, int channel)
 {
-	u32 uval;
+	u32 uval = 0;
 
 	/* hwmon sysfs attribute of current available only for package */
 	if (channel != CHANNEL_PKG)
@@ -1023,7 +1023,7 @@ xe_hwmon_energy_read(struct xe_hwmon *hwmon, u32 attr, int channel, long *val)
 static umode_t
 xe_hwmon_fan_is_visible(struct xe_hwmon *hwmon, u32 attr, int channel)
 {
-	u32 uval;
+	u32 uval = 0;
 
 	if (!hwmon->xe->info.has_fan_control)
 		return 0;
diff --git a/drivers/gpu/drm/xe/xe_vram_freq.c b/drivers/gpu/drm/xe/xe_vram_freq.c
index b26e26d73dae6..17bc84da4cdcc 100644
--- a/drivers/gpu/drm/xe/xe_vram_freq.c
+++ b/drivers/gpu/drm/xe/xe_vram_freq.c
@@ -34,7 +34,7 @@ static ssize_t max_freq_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
 	struct xe_tile *tile = dev_to_tile(dev);
-	u32 val, mbox;
+	u32 val = 0, mbox;
 	int err;
 
 	mbox = REG_FIELD_PREP(PCODE_MB_COMMAND, PCODE_FREQUENCY_CONFIG)
@@ -56,7 +56,7 @@ static ssize_t min_freq_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
 	struct xe_tile *tile = dev_to_tile(dev);
-	u32 val, mbox;
+	u32 val = 0, mbox;
 	int err;
 
 	mbox = REG_FIELD_PREP(PCODE_MB_COMMAND, PCODE_FREQUENCY_CONFIG)
-- 
2.51.0



