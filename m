Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B52436493F;
	Tue, 16 Jun 2026 16:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628281; cv=none; b=ffpvHywStofFi0mm11xE42aayTO2W0MmNnHrSrT5pu40ILoBrZ3IxnOxomqe527Yx79XptTkEboB5Nvm8M+1xeH1776oyhFejVy+o6QWlWW98g2nULHCczqIVfIDwxc4En4zDyQM0hwMOtLHWux8viPjqwlIWDgd37GQIZkkQls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628281; c=relaxed/simple;
	bh=0Wn+fwuRruur8S45AlFeIFv2gDQmKt8BFI5wM+LzDO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWIVcI54BOoQag3LkWunUHjSZY0MD75kn18BZt8LH02zJcY32DdRCSozlsvMdTOpzeyF1CjAvzIJ0dJoPkKR9AmkO9Ln/CEiwluSzrC6n5kwMwYujSyskN5k2DxfcNVO7zvYET/VjNYhg87qXtS3VBmXHn/xzvdCikEL2tWo/6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=roLGj11D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="roLGj11D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FFF1F000E9;
	Tue, 16 Jun 2026 16:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628280;
	bh=6+SskHldMZWryoZDFsGE3Kj64T5MfhL6AFdQRrR5pnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=roLGj11DJKntYqAKlj3LUiJQAGy/QHmogtDTmndkOttO5ufFmVBGOjkIPQodvEAC6
	 OD22Ez/IxNNK7bC2Xj/jhVukz8W5ttkaGkl+WOgZRLb5bwnwwig2INGR6oqUC3EHoM
	 RrYH1cK/aVhZ/jk4Vb2EaelkpYL3qu7X57wpxlbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Wenshan Lan <jetlan9@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/452] drm/fbdev-helper: Set and clear VGA switcheroo client from fb_info
Date: Tue, 16 Jun 2026 20:24:52 +0530
Message-ID: <20260616145121.356199655@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 02257549daf7ff839e2be6d4f3cac975e522fd7a ]

Call vga_switcheroo_client_fb_set() with the PCI device from the
instance of struct fb_info. All fbdev clients now run these calls.
For non-PCI devices or drivers without vga-switcheroo, this does
nothing. For i915 and radeon, it allows these drivers to use a
common fbdev client.

The device is the same as the one stored in struct drm_client and
struct drm_fb_helper, so there is no difference in behavior. Some
NULL-pointer checks are being removed, where those pointers cannot
be NULL.

v4:
- clarify call semantics for drm_fb_helper_unregister_info() (Javier)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240924071734.98201-3-tzimmermann@suse.de
[ The variable 'dev' in the function drm_fb_helper_single_fb_probe() is
unused; remove it in v6.6. ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fb_helper.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index b507c1c008a3e9..eee7b56d441f71 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -567,7 +567,7 @@ EXPORT_SYMBOL(drm_fb_helper_release_info);
 
 /**
  * drm_fb_helper_unregister_info - unregister fb_info framebuffer device
- * @fb_helper: driver-allocated fbdev helper, can be NULL
+ * @fb_helper: driver-allocated fbdev helper, must not be NULL
  *
  * A wrapper around unregister_framebuffer, to release the fb_info
  * framebuffer device. This must be called before releasing all resources for
@@ -575,8 +575,12 @@ EXPORT_SYMBOL(drm_fb_helper_release_info);
  */
 void drm_fb_helper_unregister_info(struct drm_fb_helper *fb_helper)
 {
-	if (fb_helper && fb_helper->info)
-		unregister_framebuffer(fb_helper->info);
+	struct fb_info *info = fb_helper->info;
+	struct device *dev = info->device;
+
+	if (dev_is_pci(dev))
+		vga_switcheroo_client_fb_set(to_pci_dev(dev), NULL);
+	unregister_framebuffer(fb_helper->info);
 }
 EXPORT_SYMBOL(drm_fb_helper_unregister_info);
 
@@ -1668,8 +1672,8 @@ static int drm_fb_helper_find_sizes(struct drm_fb_helper *fb_helper,
 static int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper)
 {
 	struct drm_client_dev *client = &fb_helper->client;
-	struct drm_device *dev = fb_helper->dev;
 	struct drm_fb_helper_surface_size sizes;
+	struct fb_info *info;
 	int ret;
 
 	ret = drm_fb_helper_find_sizes(fb_helper, &sizes);
@@ -1687,9 +1691,11 @@ static int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper)
 
 	strcpy(fb_helper->fb->comm, "[fbcon]");
 
+	info = fb_helper->info;
+
 	/* Set the fb info for vgaswitcheroo clients. Does nothing otherwise. */
-	if (dev_is_pci(dev->dev))
-		vga_switcheroo_client_fb_set(to_pci_dev(dev->dev), fb_helper->info);
+	if (dev_is_pci(info->device))
+		vga_switcheroo_client_fb_set(to_pci_dev(info->device), info);
 
 	return 0;
 }
-- 
2.53.0



