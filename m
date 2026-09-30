Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3EB4FD78D;
	Wed, 30 Sep 2026 16:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785491; cv=none; b=XjNiuWnr1HWS4TbnDxH2qsk+A1jF8CXAflBw5MRrWcfgrvy89Bfy8mFd6NFicQvMShnCXrFKRr0lq4AK4ZYE+24gBhMttQTuNM/kDiPBty52P9nv3C4to3ceTdVaNnogBRGRCEl5nI6s0wHzRtN4VbTwgO2vQFq99ZRzJEIHTGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785491; c=relaxed/simple;
	bh=kxmw40VnVsOO184sQp6+daiD+K+SFDpcZ7MKqO45ozY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1Obu00g47Q4e5ij+COHdtB1AgnfNasr1wbXxQeSGujuyNvOAsFeuxTfU+AB62bJXw+oZYIkJGqMn5oYu4bmEae8zUMhzWs9MYYWwXzNjmu2jfP2gsRJSi/KjVGKI8QQ4y8lCnPtuh8i7kaXfzECtBrHqTzD9eDARvU7iDNhPxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nbj0+hN3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nbj0+hN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A86F1F00893;
	Wed, 30 Sep 2026 16:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785483;
	bh=7BS1PV6fd2y7XL93rSMzzl2FZSX09FrCxZh9m8Ft5Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nbj0+hN3b4ZesvuGILCWNe4DCOxiKnGKCGChg2kDxy1SyhdmiOHvbl0WiGtEiNT3G
	 zDymscgMGQ/VsUXSlD2a+cgT2OKtO3A97Hbu46vp3TYTKjpFJR8QgiO5jV5EaQwMJR
	 LzSkMLuXg5VuzYh8qQRanO6CAdvwXea7xbbPpTyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+c25629c98ba36ebe@bugs.sh,
	stable@kernel.org,
	Weiming Shi <bestswngs@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 524/982] fbdev: vfb: defer cleanup until the last reference
Date: Wed, 30 Sep 2026 17:21:00 +0200
Message-ID: <20260930152428.031617482@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 	.fb_read        = fb_sys_read,
 	.fb_write       = fb_sys_write,
@@ -89,6 +96,7 @@ static const struct fb_ops vfb_ops = {
 	.fb_copyarea	= sys_copyarea,
 	.fb_imageblit	= sys_imageblit,
 	.fb_mmap	= vfb_mmap,
+	.fb_destroy	= vfb_destroy,
 };
 
     /*
@@ -485,9 +493,6 @@ static int vfb_remove(struct platform_de
 
 	if (info) {
 		unregister_framebuffer(info);
-		vfree(videomemory);
-		fb_dealloc_cmap(&info->cmap);
-		framebuffer_release(info);
 	}
 	return 0;
 }


