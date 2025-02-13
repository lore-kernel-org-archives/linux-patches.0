Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DBC281360;
	Thu, 13 Feb 2025 14:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457257; cv=none; b=eE0UxmTkyuhOGzRTBZMtW9QZLv44wFUAG+4/2k1WOJjaImK74ltHKa7Q4DJSyz7K3Y3pBuE8srCiSonMw2vLzb6FVaYOg7AhHACLPxuXJM0TDoLSQDn2CIMwzXPB1yrQLjXcvwctF+/Qq5wyECvEtpfrS3Tpot96pHhsyAJ02/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457257; c=relaxed/simple;
	bh=eLMIkcNn0bqqO9IlVA4cEJWYEnu88UfCTGWkiPZEiJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uILhVwx2h4Ctrgti+IwJmPI1p1pEtMa1BvIVbWN7lTbQPnxYJt5PThmGy4lpWBc1GZNCWrRdV9uXxNibB83yBSB/YXQbmT5QgsMH8gbZCRf3GEPF7P60SPyvUwX0//C4MV5gN4wL+0ADh51kVKwZ8XcBGqeg8O0g25MZWPKQw8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uniPYWkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uniPYWkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D293CC4CEE8;
	Thu, 13 Feb 2025 14:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457257;
	bh=eLMIkcNn0bqqO9IlVA4cEJWYEnu88UfCTGWkiPZEiJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uniPYWkEn75KcbIghLcVOkyX5q1EgjPF2P9776H+GMGOJ0vTCF2J/M92CHdJqTUNX
	 71CjPwDg6YL+kRkAGH0+QqP4Wvd2SV1Q0PMTRoGD3XPd8aQXPBNMh7gN7fq9RiIi/c
	 rLmFgbEgv3ogaVSCRTXY17z/REGC9GuUPBrHa6OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Dustin L. Howett" <dustin@howett.net>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/422] drm: Add panel backlight quirks
Date: Thu, 13 Feb 2025 15:22:47 +0100
Message-ID: <20250213142437.256174174@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 22e5c7ae12145af13785e3ff138395d5b1a22116 ]

Panels using a PWM-controlled backlight source do not have a standard
way to communicate their valid PWM ranges.
On x86 the ranges are read from ACPI through driver-specific tables.
The built-in ranges are not necessarily correct, or may grow stale if an
older device can be retrofitted with newer panels.

Add a quirk infrastructure with which the minimum valid backlight value
can be maintained as part of the kernel.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Tested-by: Dustin L. Howett <dustin@howett.net>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241111-amdgpu-min-backlight-quirk-v7-1-f662851fda69@weissschuh.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/gpu/drm-kms-helpers.rst        |  3 +
 drivers/gpu/drm/Kconfig                      |  4 ++
 drivers/gpu/drm/Makefile                     |  1 +
 drivers/gpu/drm/drm_panel_backlight_quirks.c | 70 ++++++++++++++++++++
 include/drm/drm_utils.h                      |  4 ++
 5 files changed, 82 insertions(+)
 create mode 100644 drivers/gpu/drm/drm_panel_backlight_quirks.c

diff --git a/Documentation/gpu/drm-kms-helpers.rst b/Documentation/gpu/drm-kms-helpers.rst
index c3e58856f75b3..96c03b9a644e4 100644
--- a/Documentation/gpu/drm-kms-helpers.rst
+++ b/Documentation/gpu/drm-kms-helpers.rst
@@ -230,6 +230,9 @@ Panel Helper Reference
 .. kernel-doc:: drivers/gpu/drm/drm_panel_orientation_quirks.c
    :export:
 
+.. kernel-doc:: drivers/gpu/drm/drm_panel_backlight_quirks.c
+   :export:
+
 Panel Self Refresh Helper Reference
 ===================================
 
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 610e159d362ad..7408ea8caacc3 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -486,6 +486,10 @@ config DRM_HYPERV
 config DRM_EXPORT_FOR_TESTS
 	bool
 
+# Separate option as not all DRM drivers use it
+config DRM_PANEL_BACKLIGHT_QUIRKS
+	tristate
+
 config DRM_LIB_RANDOM
 	bool
 	default n
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 784229d4504dc..84746054c721a 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -93,6 +93,7 @@ drm-$(CONFIG_DRM_PANIC_SCREEN_QR_CODE) += drm_panic_qr.o
 obj-$(CONFIG_DRM)	+= drm.o
 
 obj-$(CONFIG_DRM_PANEL_ORIENTATION_QUIRKS) += drm_panel_orientation_quirks.o
+obj-$(CONFIG_DRM_PANEL_BACKLIGHT_QUIRKS) += drm_panel_backlight_quirks.o
 
 #
 # Memory-management helpers
diff --git a/drivers/gpu/drm/drm_panel_backlight_quirks.c b/drivers/gpu/drm/drm_panel_backlight_quirks.c
new file mode 100644
index 0000000000000..6b8bbed77c7f1
--- /dev/null
+++ b/drivers/gpu/drm/drm_panel_backlight_quirks.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/array_size.h>
+#include <linux/dmi.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <drm/drm_edid.h>
+#include <drm/drm_utils.h>
+
+struct drm_panel_min_backlight_quirk {
+	struct {
+		enum dmi_field field;
+		const char * const value;
+	} dmi_match;
+	struct drm_edid_ident ident;
+	u8 min_brightness;
+};
+
+static const struct drm_panel_min_backlight_quirk drm_panel_min_backlight_quirks[] = {
+};
+
+static bool drm_panel_min_backlight_quirk_matches(const struct drm_panel_min_backlight_quirk *quirk,
+						  const struct drm_edid *edid)
+{
+	if (!dmi_match(quirk->dmi_match.field, quirk->dmi_match.value))
+		return false;
+
+	if (!drm_edid_match(edid, &quirk->ident))
+		return false;
+
+	return true;
+}
+
+/**
+ * drm_get_panel_min_brightness_quirk - Get minimum supported brightness level for a panel.
+ * @edid: EDID of the panel to check
+ *
+ * This function checks for platform specific (e.g. DMI based) quirks
+ * providing info on the minimum backlight brightness for systems where this
+ * cannot be probed correctly from the hard-/firm-ware.
+ *
+ * Returns:
+ * A negative error value or
+ * an override value in the range [0, 255] representing 0-100% to be scaled to
+ * the drivers target range.
+ */
+int drm_get_panel_min_brightness_quirk(const struct drm_edid *edid)
+{
+	const struct drm_panel_min_backlight_quirk *quirk;
+	size_t i;
+
+	if (!IS_ENABLED(CONFIG_DMI))
+		return -ENODATA;
+
+	if (!edid)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(drm_panel_min_backlight_quirks); i++) {
+		quirk = &drm_panel_min_backlight_quirks[i];
+
+		if (drm_panel_min_backlight_quirk_matches(quirk, edid))
+			return quirk->min_brightness;
+	}
+
+	return -ENODATA;
+}
+EXPORT_SYMBOL(drm_get_panel_min_brightness_quirk);
+
+MODULE_DESCRIPTION("Quirks for panel backlight overrides");
+MODULE_LICENSE("GPL");
diff --git a/include/drm/drm_utils.h b/include/drm/drm_utils.h
index 70775748d243b..15fa9b6865f44 100644
--- a/include/drm/drm_utils.h
+++ b/include/drm/drm_utils.h
@@ -12,8 +12,12 @@
 
 #include <linux/types.h>
 
+struct drm_edid;
+
 int drm_get_panel_orientation_quirk(int width, int height);
 
+int drm_get_panel_min_brightness_quirk(const struct drm_edid *edid);
+
 signed long drm_timeout_abs_to_jiffies(int64_t timeout_nsec);
 
 #endif
-- 
2.39.5



