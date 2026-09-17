Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43495547041;
	Thu, 17 Sep 2026 17:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666415; cv=none; b=MlynbZRmmj6stTBVSn3bsQI3ow7kmTiK/rmo+ShssbHctnnccHhx2j3Nz3usGc1s2zRFPMoyi1hGt3k2cI1TqDuUDOvYRT7GEVcWksBZ8tmNEXDj8mfgHT9SfekMxsjDy8G8SskmX6E4q+rgaJOhIIcr7SJa5EELxK/VjEusjUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666415; c=relaxed/simple;
	bh=AIO4LduQIVRC69mrwewmBLXKMFpz7wwZtYI0Ct/qcpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtqttvfNQOJbzFMVcGKo4Osc6g5v2hnumZrB7x5Ia1rOlo4dW3L3zYvXoS7hdLQFjG4CbkTWNducwUb77/WH+dXXpFM47KtOyhk7EWVoX9GTnu5su/yg0nUWbiX9ktzkKffROElYDWQNeTPw78KWaY0OwOWeQDonjiy1Op8dA/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSPu2+9t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSPu2+9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A8E1F000FF;
	Thu, 17 Sep 2026 17:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666413;
	bh=+n/iQ0jLd7O9/nyyykIpgVwrcOwoYrbzeikzS2tS+6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSPu2+9tbt+XP6G6k3Ow526Ycwh1kZGZx31Dyn2mtyrtmyITaBdjHXO1Vuo+clCsB
	 GBLlgvKLdZMS2frrdHLgYZVk0/m4uhwwgWbhwfFg1LTXSlb6UxVqPG7kcRfiv/adL2
	 Md0mgnvCVpvwH3MrTsMdqq3RuLjb15uIF5JHlTfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+c25629c98ba36ebe@bugs.sh,
	stable@kernel.org,
	Weiming Shi <bestswngs@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 1030/1250] fbdev: vfb: defer cleanup until the last reference
Date: Thu, 17 Sep 2026 16:13:45 +0100
Message-ID: <20260917151619.989786094@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

commit a0a34a40ed299c9c7cff6af163a5b883ee9d6d73 upstream.

FBIOGETCMAP takes a shallow snapshot of info->cmap and performs the
usercopy after dropping info->lock. vfb_remove() frees the colormap
immediately after unregistering the framebuffer, even when an open file
still holds a reference to fb_info. A concurrent driver unbind can
therefore free the colormap while the ioctl copies it to userspace.

KASAN reports:

  BUG: KASAN: slab-use-after-free in _copy_to_user
  Read of size 512 by task poc/125

   _copy_to_user (./include/linux/instrumented.h:129 ./include/linux/uaccess.h:201 lib/usercopy.c:24)
   fb_cmap_to_user (./include/linux/uaccess.h:230 drivers/video/fbdev/core/fbcmap.c:211)
   do_fb_ioctl (drivers/video/fbdev/core/fb_chrdev.c:114)

   Allocated by task 1:
   fb_alloc_cmap_gfp (./include/linux/slab.h:973 ./include/linux/slab.h:1290 drivers/video/fbdev/core/fbcmap.c:108)
   vfb_probe (drivers/video/fbdev/vfb.c:459)

   Freed by task 124:
   fb_dealloc_cmap (drivers/video/fbdev/core/fbcmap.c:151)
   vfb_remove (drivers/video/fbdev/vfb.c:489)

unregister_framebuffer() drops the registration reference, and fbdev calls
fb_destroy after the last put_fb_info(). Move the registered framebuffer's
cleanup into an fb_destroy callback so its colormap and screen buffer stay
alive until all file references have been released.

Fixes: 5e266e2e0e19 ("vfb: fix memory leaks in removal path")
Reported-by: co+c25629c98ba36ebe@bugs.sh
Cc: stable@kernel.org
Closes: https://lore.kernel.org/linux-fbdev/f2Kf9GYn1lKR5S1dbvGVtykMxK1RlgP5z8sW@bugs.sh/
Assisted-by: Codex:gpt-5
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://lore.kernel.org/linux-fbdev/f2Kf9GYn1lKR5S1dbvGVtykMxK1RlgP5z8sW@bugs.sh/
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/vfb.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/video/fbdev/vfb.c
+++ b/drivers/video/fbdev/vfb.c
@@ -78,6 +78,13 @@ static int vfb_pan_display(struct fb_var
 static int vfb_mmap(struct fb_info *info,
 		    struct vm_area_struct *vma);
 
+static void vfb_destroy(struct fb_info *info)
+{
+	vfree(info->screen_buffer);
+	fb_dealloc_cmap(&info->cmap);
+	framebuffer_release(info);
+}
+
 static const struct fb_ops vfb_ops = {
 	.owner		= THIS_MODULE,
 	__FB_DEFAULT_SYSMEM_OPS_RDWR,
@@ -87,6 +94,7 @@ static const struct fb_ops vfb_ops = {
 	.fb_pan_display	= vfb_pan_display,
 	__FB_DEFAULT_SYSMEM_OPS_DRAW,
 	.fb_mmap	= vfb_mmap,
+	.fb_destroy	= vfb_destroy,
 };
 
     /*
@@ -485,9 +493,6 @@ static void vfb_remove(struct platform_d
 
 	if (info) {
 		unregister_framebuffer(info);
-		vfree(videomemory);
-		fb_dealloc_cmap(&info->cmap);
-		framebuffer_release(info);
 	}
 }
 


