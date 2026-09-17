Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22464D4879;
	Thu, 17 Sep 2026 15:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660346; cv=none; b=ERJJwUGjimsh0XwdtoAJlJqV4X73xSmNQ/6FNayRMDmodIQA1Aa5HZREkxkW7ioUmiNEFCmuPbM8ZW2XDREUg+Nv2icBRdJQw9b+u6TGAoSgXIY17+rdD3ch67trfbQ/tqf/95jfd8CfdMNxKLXTVZSWwjebrYnH9beQRtVb65U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660346; c=relaxed/simple;
	bh=1XtCSFvYRKh947qze6czv/XqwWz7qwwDDhvguPPS/Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjdyerdwOfbnrvNNcxUxnQvLA6hdJXDjmXfLALyHzNaTEA75jSXuRdSxHtt5lDFOgB7LQlrgshXIDxPw3DNQRGjTuLq1Ea+U0FoBekPhs+gZ5z2Tj1lEenmBY0iv9TiptYLuL1UZM+bWeOo2MYvxYQQVLMkqsxwaQDcgpsYzy94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHrWHzhi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHrWHzhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE291F000FF;
	Thu, 17 Sep 2026 15:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660345;
	bh=pwq06PWFmx6micY8RODE3lR7NYnKcBLbvSFGrZe3TOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHrWHzhiSsHKtoJnxZO5gAUx81sToSD10HpHxbnGXM3hYLLVnVoFH/SYTdLSonMiC
	 wIDkI4pxnhqYenV6c1mXe58kWzK7QZVc5/WnZZnVkz2gh41KQ/T4aGEsQCzh2f2nOh
	 rWK3ghcUZkl5rXknNKkPbKRqmBlQKGsRnC34f5d8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+c25629c98ba36ebe@bugs.sh,
	stable@kernel.org,
	Weiming Shi <bestswngs@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.2 561/733] fbdev: vfb: defer cleanup until the last reference
Date: Thu, 17 Sep 2026 16:14:29 +0100
Message-ID: <20260917151406.291614803@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 


