Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25AA373C0B;
	Sat, 28 Feb 2026 17:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301537; cv=none; b=JsLzRCoVaPpXnb1M+WPghy8OSdfgYiHNG21qjgBuTT3SgDaGvJ0+VO5WZvLhs/bGp9bFVctjq0SEN4G2zmNPxgnF43Xnp1BNfHxIz0lkExFLiShS/eFLPEfkczffsn6zy6xma52EhxSC1uqM76lZ/trKqxIJCa7DhYi7Tmr99EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301537; c=relaxed/simple;
	bh=D22sXEeJMslmAAsbB8Dliwp+gkAeNSn++Ovxt/kE01Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FA81X8hG4PzcIvD8MjsZ5JVniqN2GJive6hesX3BZYtW5kDWkujVtlkx7tnnvlpB80LyFHfCkSdM6obm4NdgnLoGYPhe131xTU/ezkaP8mSrFNsueyjL8I39hpgoX0HVKP3eikNh/euSvJXF6vjxqVml8SWU0gaDWVDPKrAwFP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2XBjPIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2XBjPIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082BAC2BC87;
	Sat, 28 Feb 2026 17:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301537;
	bh=D22sXEeJMslmAAsbB8Dliwp+gkAeNSn++Ovxt/kE01Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2XBjPIeygYtf1+RLjU1T9B4EWHtxru4Ho6ftC4Cl2s15aHYTVODqtwUEb+iSot0L
	 PEUTbDI1QIB8/xf4TmjNrbsRbofCCXRCcue5luk3Ei/RtbpD4BGJWoLPzPiAJZfYbl
	 lxg2Zv6wtNLqdgp0XdIHDRZ+86kGVosDgVx4hb4bQy3xdbPubAqJrsQyFDhJMzaus+
	 x16q6/G7qntiISLyIUhw5o17wSt+62NRz82419lwjpRK6lpgLj4xnLhVTI0Fkl1Vq4
	 bUcQGEH7ZTZrA/xhmLFMbu+oxxLls/P0tCGUuXq68yWF1YZFuWsw+iHbRSyLcK0T1X
	 m80a0kW06d82Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hans de Goede <johannes.goede@oss.qualcomm.com>,
	stable@vger.kernel.org,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 719/752] fbdev: Use device_create_with_groups() to fix sysfs groups registration race
Date: Sat, 28 Feb 2026 12:47:10 -0500
Message-ID: <20260228174750.1542406-719-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

[ Upstream commit 68eeb0871e986ae5462439dae881e3a27bcef85f ]

The fbdev sysfs attributes are registered after sending the uevent for
the device creation, leaving a race window where e.g. udev rules may
not be able to access the sysfs attributes because the registration is
not done yet.

Fix this by switching to device_create_with_groups(). This also results in
a nice cleanup. After switching to device_create_with_groups() all that
is left of fb_init_device() is setting the drvdata and that can be passed
to device_create[_with_groups]() too. After which fb_init_device() can
be completely removed.

Dropping fb_init_device() + fb_cleanup_device() in turn allows removing
fb_info.class_flag as they were the only user of this field.

Fixes: 5fc830d6aca1 ("fbdev: Register sysfs groups through device_add_group")
Cc: stable@vger.kernel.org
Cc: Shixiong Ou <oushixiong@kylinos.cn>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbsysfs.c | 36 +++---------------------------
 include/linux/fb.h                 |  1 -
 2 files changed, 3 insertions(+), 34 deletions(-)

diff --git a/drivers/video/fbdev/core/fbsysfs.c b/drivers/video/fbdev/core/fbsysfs.c
index b8344c40073b4..baa2bae0fb5b3 100644
--- a/drivers/video/fbdev/core/fbsysfs.c
+++ b/drivers/video/fbdev/core/fbsysfs.c
@@ -12,8 +12,6 @@
 
 #include "fb_internal.h"
 
-#define FB_SYSFS_FLAG_ATTR 1
-
 static int activate(struct fb_info *fb_info, struct fb_var_screeninfo *var)
 {
 	int err;
@@ -451,33 +449,7 @@ static struct attribute *fb_device_attrs[] = {
 	NULL,
 };
 
-static const struct attribute_group fb_device_attr_group = {
-	.attrs          = fb_device_attrs,
-};
-
-static int fb_init_device(struct fb_info *fb_info)
-{
-	int ret;
-
-	dev_set_drvdata(fb_info->dev, fb_info);
-
-	fb_info->class_flag |= FB_SYSFS_FLAG_ATTR;
-
-	ret = device_add_group(fb_info->dev, &fb_device_attr_group);
-	if (ret)
-		fb_info->class_flag &= ~FB_SYSFS_FLAG_ATTR;
-
-	return 0;
-}
-
-static void fb_cleanup_device(struct fb_info *fb_info)
-{
-	if (fb_info->class_flag & FB_SYSFS_FLAG_ATTR) {
-		device_remove_group(fb_info->dev, &fb_device_attr_group);
-
-		fb_info->class_flag &= ~FB_SYSFS_FLAG_ATTR;
-	}
-}
+ATTRIBUTE_GROUPS(fb_device);
 
 int fb_device_create(struct fb_info *fb_info)
 {
@@ -485,14 +457,13 @@ int fb_device_create(struct fb_info *fb_info)
 	dev_t devt = MKDEV(FB_MAJOR, node);
 	int ret;
 
-	fb_info->dev = device_create(fb_class, fb_info->device, devt, NULL, "fb%d", node);
+	fb_info->dev = device_create_with_groups(fb_class, fb_info->device, devt, fb_info,
+						 fb_device_groups, "fb%d", node);
 	if (IS_ERR(fb_info->dev)) {
 		/* Not fatal */
 		ret = PTR_ERR(fb_info->dev);
 		pr_warn("Unable to create device for framebuffer %d; error %d\n", node, ret);
 		fb_info->dev = NULL;
-	} else {
-		fb_init_device(fb_info);
 	}
 
 	return 0;
@@ -505,7 +476,6 @@ void fb_device_destroy(struct fb_info *fb_info)
 	if (!fb_info->dev)
 		return;
 
-	fb_cleanup_device(fb_info);
 	device_destroy(fb_class, devt);
 	fb_info->dev = NULL;
 }
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 05cc251035da9..c3302d5135466 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -497,7 +497,6 @@ struct fb_info {
 #if defined(CONFIG_FB_DEVICE)
 	struct device *dev;		/* This is this fb device */
 #endif
-	int class_flag;                    /* private sysfs flags */
 #ifdef CONFIG_FB_TILEBLITTING
 	struct fb_tile_ops *tileops;    /* Tile Blitting */
 #endif
-- 
2.51.0

