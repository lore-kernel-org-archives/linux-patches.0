Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7485A357736;
	Tue, 16 Dec 2025 12:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886596; cv=none; b=SthZfA+G/X59uCdN/X2gfV5fLogKq9MDWs/7IglNIog8zT9xJp2Jkmg6t4FdusHbfE8yxJNCDrx0hgpCGzA8K/9/y8fSChdX7+DyUZrJXY0X/a/x4l4l3Lpxn07J3Qw5J3Z2cjC5alRtCcu6pEaXTeN0iYGReu1Lr29hvvQqefQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886596; c=relaxed/simple;
	bh=Bkh8PphUyRedExyisd9usqtyPNk17m545F2+rZUmXuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p4xXehVIdQ8V5S9+koy46KvRFgtT/gExIbGiq1rou4rO17JXIbeGS5uAT+Rg+H8r/LEkgyZ9Sb8r/1nunhiLviZlVqk2mGVqD7YCd/VpjtGtSbboIIbg5191aChj3q6knLBmZnJ9EeBezlkstCGlfeSYReLg6yakoEpKdCKprfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmXBB8f6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmXBB8f6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BF1C4CEF5;
	Tue, 16 Dec 2025 12:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886596;
	bh=Bkh8PphUyRedExyisd9usqtyPNk17m545F2+rZUmXuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmXBB8f6Eu6NuuCOMWtHZCmPNnFfUgvvoSELWahYQit1EmgYfOBA5RPXWpDhVfHCp
	 49A9suk4oWB8blMUmsQIslKbQZMAs2ndxmIp1QuCelbqW3vAdH/iaWdTnehKrZiAh8
	 crx11wx6NpD+A2nBFoIn7dePSkMPmFo2UIyvmpfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 483/507] drm/{i915, xe}/fbdev: deduplicate struct drm_mode_fb_cmd2 init
Date: Tue, 16 Dec 2025 12:15:24 +0100
Message-ID: <20251216111402.939621514@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit f9ff39f940f5ddd1d4ffcff602de7206aa1ff05d ]

Pull struct drm_mode_fb_cmd2 initialization out of the driver dependent
code into shared display code.

v2: Rebase on xe stride alignment change

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://lore.kernel.org/r/e922e47bfd39f9c5777f869ff23c23309ebbb380.1758184771.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: 460b31720369 ("drm/i915/fbdev: Hold runtime PM ref during fbdev BO creation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_fbdev.c    | 32 ++++++++++++++++++-
 drivers/gpu/drm/i915/display/intel_fbdev_fb.c | 25 ++++-----------
 drivers/gpu/drm/i915/display/intel_fbdev_fb.h |  4 +--
 drivers/gpu/drm/xe/display/intel_fbdev_fb.c   | 25 ++++-----------
 4 files changed, 45 insertions(+), 41 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_fbdev.c b/drivers/gpu/drm/i915/display/intel_fbdev.c
index 46c6de5f60888..e46c08762b847 100644
--- a/drivers/gpu/drm/i915/display/intel_fbdev.c
+++ b/drivers/gpu/drm/i915/display/intel_fbdev.c
@@ -207,6 +207,35 @@ static const struct drm_fb_helper_funcs intel_fb_helper_funcs = {
 	.fb_set_suspend = intelfb_set_suspend,
 };
 
+static void intel_fbdev_fill_mode_cmd(struct drm_fb_helper_surface_size *sizes,
+				      struct drm_mode_fb_cmd2 *mode_cmd)
+{
+	/* we don't do packed 24bpp */
+	if (sizes->surface_bpp == 24)
+		sizes->surface_bpp = 32;
+
+	mode_cmd->width = sizes->surface_width;
+	mode_cmd->height = sizes->surface_height;
+
+	mode_cmd->pitches[0] = ALIGN(mode_cmd->width * DIV_ROUND_UP(sizes->surface_bpp, 8), 64);
+	mode_cmd->pixel_format = drm_mode_legacy_fb_format(sizes->surface_bpp,
+							   sizes->surface_depth);
+}
+
+static struct intel_framebuffer *
+__intel_fbdev_fb_alloc(struct intel_display *display,
+		       struct drm_fb_helper_surface_size *sizes)
+{
+	struct drm_mode_fb_cmd2 mode_cmd = {};
+	struct intel_framebuffer *fb;
+
+	intel_fbdev_fill_mode_cmd(sizes, &mode_cmd);
+
+	fb = intel_fbdev_fb_alloc(display->drm, &mode_cmd);
+
+	return fb;
+}
+
 int intel_fbdev_driver_fbdev_probe(struct drm_fb_helper *helper,
 				   struct drm_fb_helper_surface_size *sizes)
 {
@@ -237,7 +266,8 @@ int intel_fbdev_driver_fbdev_probe(struct drm_fb_helper *helper,
 	if (!fb || drm_WARN_ON(display->drm, !intel_fb_bo(&fb->base))) {
 		drm_dbg_kms(display->drm,
 			    "no BIOS fb, allocating a new one\n");
-		fb = intel_fbdev_fb_alloc(display->drm, sizes);
+
+		fb = __intel_fbdev_fb_alloc(display, sizes);
 		if (IS_ERR(fb))
 			return PTR_ERR(fb);
 	} else {
diff --git a/drivers/gpu/drm/i915/display/intel_fbdev_fb.c b/drivers/gpu/drm/i915/display/intel_fbdev_fb.c
index 4de13d1a4c7a7..685612e6afc53 100644
--- a/drivers/gpu/drm/i915/display/intel_fbdev_fb.c
+++ b/drivers/gpu/drm/i915/display/intel_fbdev_fb.c
@@ -3,7 +3,7 @@
  * Copyright © 2023 Intel Corporation
  */
 
-#include <drm/drm_fb_helper.h>
+#include <linux/fb.h>
 
 #include "gem/i915_gem_lmem.h"
 
@@ -14,28 +14,15 @@
 #include "intel_fbdev_fb.h"
 
 struct intel_framebuffer *intel_fbdev_fb_alloc(struct drm_device *drm,
-					       struct drm_fb_helper_surface_size *sizes)
+					       struct drm_mode_fb_cmd2 *mode_cmd)
 {
 	struct intel_display *display = to_intel_display(drm);
 	struct drm_i915_private *dev_priv = to_i915(drm);
 	struct drm_framebuffer *fb;
-	struct drm_mode_fb_cmd2 mode_cmd = {};
 	struct drm_i915_gem_object *obj;
 	int size;
 
-	/* we don't do packed 24bpp */
-	if (sizes->surface_bpp == 24)
-		sizes->surface_bpp = 32;
-
-	mode_cmd.width = sizes->surface_width;
-	mode_cmd.height = sizes->surface_height;
-
-	mode_cmd.pitches[0] = ALIGN(mode_cmd.width *
-				    DIV_ROUND_UP(sizes->surface_bpp, 8), 64);
-	mode_cmd.pixel_format = drm_mode_legacy_fb_format(sizes->surface_bpp,
-							  sizes->surface_depth);
-
-	size = mode_cmd.pitches[0] * mode_cmd.height;
+	size = mode_cmd->pitches[0] * mode_cmd->height;
 	size = PAGE_ALIGN(size);
 
 	obj = ERR_PTR(-ENODEV);
@@ -64,9 +51,9 @@ struct intel_framebuffer *intel_fbdev_fb_alloc(struct drm_device *drm,
 
 	fb = intel_framebuffer_create(intel_bo_to_drm_bo(obj),
 				      drm_get_format_info(drm,
-							  mode_cmd.pixel_format,
-							  mode_cmd.modifier[0]),
-				      &mode_cmd);
+							  mode_cmd->pixel_format,
+							  mode_cmd->modifier[0]),
+				      mode_cmd);
 	if (IS_ERR(fb)) {
 		i915_gem_object_put(obj);
 		goto err;
diff --git a/drivers/gpu/drm/i915/display/intel_fbdev_fb.h b/drivers/gpu/drm/i915/display/intel_fbdev_fb.h
index 668ae355f5e5b..83454ffbf79cd 100644
--- a/drivers/gpu/drm/i915/display/intel_fbdev_fb.h
+++ b/drivers/gpu/drm/i915/display/intel_fbdev_fb.h
@@ -7,14 +7,14 @@
 #define __INTEL_FBDEV_FB_H__
 
 struct drm_device;
-struct drm_fb_helper_surface_size;
 struct drm_gem_object;
+struct drm_mode_fb_cmd2;
 struct fb_info;
 struct i915_vma;
 struct intel_display;
 
 struct intel_framebuffer *intel_fbdev_fb_alloc(struct drm_device *drm,
-					       struct drm_fb_helper_surface_size *sizes);
+					       struct drm_mode_fb_cmd2 *mode_cmd);
 int intel_fbdev_fb_fill_info(struct intel_display *display, struct fb_info *info,
 			     struct drm_gem_object *obj, struct i915_vma *vma);
 
diff --git a/drivers/gpu/drm/xe/display/intel_fbdev_fb.c b/drivers/gpu/drm/xe/display/intel_fbdev_fb.c
index 4c9e4de92d3c7..96ad1c1009310 100644
--- a/drivers/gpu/drm/xe/display/intel_fbdev_fb.c
+++ b/drivers/gpu/drm/xe/display/intel_fbdev_fb.c
@@ -3,7 +3,7 @@
  * Copyright © 2023 Intel Corporation
  */
 
-#include <drm/drm_fb_helper.h>
+#include <linux/fb.h>
 
 #include "intel_display_core.h"
 #include "intel_display_types.h"
@@ -16,27 +16,14 @@
 #include <generated/xe_wa_oob.h>
 
 struct intel_framebuffer *intel_fbdev_fb_alloc(struct drm_device *drm,
-					       struct drm_fb_helper_surface_size *sizes)
+					       struct drm_mode_fb_cmd2 *mode_cmd)
 {
 	struct drm_framebuffer *fb;
 	struct xe_device *xe = to_xe_device(drm);
-	struct drm_mode_fb_cmd2 mode_cmd = {};
 	struct xe_bo *obj;
 	int size;
 
-	/* we don't do packed 24bpp */
-	if (sizes->surface_bpp == 24)
-		sizes->surface_bpp = 32;
-
-	mode_cmd.width = sizes->surface_width;
-	mode_cmd.height = sizes->surface_height;
-
-	mode_cmd.pitches[0] = ALIGN(mode_cmd.width *
-				    DIV_ROUND_UP(sizes->surface_bpp, 8), 64);
-	mode_cmd.pixel_format = drm_mode_legacy_fb_format(sizes->surface_bpp,
-							  sizes->surface_depth);
-
-	size = mode_cmd.pitches[0] * mode_cmd.height;
+	size = mode_cmd->pitches[0] * mode_cmd->height;
 	size = PAGE_ALIGN(size);
 	obj = ERR_PTR(-ENODEV);
 
@@ -67,9 +54,9 @@ struct intel_framebuffer *intel_fbdev_fb_alloc(struct drm_device *drm,
 
 	fb = intel_framebuffer_create(&obj->ttm.base,
 				      drm_get_format_info(drm,
-							  mode_cmd.pixel_format,
-							  mode_cmd.modifier[0]),
-				      &mode_cmd);
+							  mode_cmd->pixel_format,
+							  mode_cmd->modifier[0]),
+				      mode_cmd);
 	if (IS_ERR(fb)) {
 		xe_bo_unpin_map_no_vm(obj);
 		goto err;
-- 
2.51.0



