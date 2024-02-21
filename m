Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB3D55E5E;
	Wed, 21 Feb 2024 13:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523485; cv=none; b=PJTKvO2M5s71fQoELYlnfKzBl2bQLoSnFcgsWdYfyUwyjm5WQIJDSIB7xKUmm1bJZFAIk1kanc1jKlM48Gy+CnU5ogWtiOIR7yi0XSTVPvtTy3bM6wPCIqkdzMaLHKzwDopG0b2ebm93uTgbiMhAuTlWZTfCDOT/qXXk7oKEAqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523485; c=relaxed/simple;
	bh=3d+8lN8ssKpk/zdhfADUg4mvP+E6ki0M8x9g+XJAFr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQJPCKl447+4/Gva9cm6WrevdvtbMKQUEqRpej2vhkZHGFMfP8PJVGZV6/skiYZPMZn8QY8l314/aeogTaB6/ghdadyBXsskFXT8vaBTRdU34t3TqD7Q++Mvydmj55RSaBR7DbHIjC/SHMLhsRtOVz5eQsI1dR9J2hYXx58Ipu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxq9wVrJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxq9wVrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC613C433C7;
	Wed, 21 Feb 2024 13:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523485;
	bh=3d+8lN8ssKpk/zdhfADUg4mvP+E6ki0M8x9g+XJAFr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xxq9wVrJuVhxd6SvXQ+5gGF8Bvxkd08K/nz3uxFK3ftkoRcUHMg7bbVyvsYcGuNpe
	 gjLwax7bA0SCdaYSxzAUtAHV8kOhn28MDlqshMPVgp4fSR82diZNolod9qkDclELwk
	 ayr+SNRu+tga575YiSmKKXEZrZL4fkJUqpqFwgRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 447/476] fbdev: Dont sort deferred-I/O pages by default
Date: Wed, 21 Feb 2024 14:08:18 +0100
Message-ID: <20240221130024.555704253@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 8c30e2d81bfddc5ab9f6b04db1c0f7d6ca7bdf46 ]

Fbdev's deferred I/O sorts all dirty pages by default, which incurs a
significant overhead. Make the sorting step optional and update the few
drivers that require it. Use a FIFO list by default.

Most fbdev drivers with deferred I/O build a bounding rectangle around
the dirty pages or simply flush the whole screen. The only two affected
DRM drivers, generic fbdev and vmwgfx, both use a bounding rectangle.
In those cases, the exact order of the pages doesn't matter. The other
drivers look at the page index or handle pages one-by-one. The patch
sets the sort_pagelist flag for those, even though some of them would
probably work correctly without sorting. Driver maintainers should update
their driver accordingly.

Sorting pages by memory offset for deferred I/O performs an implicit
bubble-sort step on the list of dirty pages. The algorithm goes through
the list of dirty pages and inserts each new page according to its
index field. Even worse, list traversal always starts at the first
entry. As video memory is most likely updated scanline by scanline, the
algorithm traverses through the complete list for each updated page.

For example, with 1024x768x32bpp each page covers exactly one scanline.
Writing a single screen update from top to bottom requires updating
768 pages. With an average list length of 384 entries, a screen update
creates (768 * 384 =) 294912 compare operation.

Fix this by making the sorting step opt-in and update the few drivers
that require it. All other drivers work with unsorted page lists. Pages
are appended to the list. Therefore, in the common case of writing the
framebuffer top to bottom, pages are still sorted by offset, which may
have a positive effect on performance.

Playing a video [1] in mplayer's benchmark mode shows the difference
(i7-4790, FullHD, simpledrm, kernel with debugging).

  mplayer -benchmark -nosound -vo fbdev ./big_buck_bunny_720p_stereo.ogg

With sorted page lists:

  BENCHMARKs: VC:  32.960s VO:  73.068s A:   0.000s Sys:   2.413s =  108.441s
  BENCHMARK%: VC: 30.3947% VO: 67.3802% A:  0.0000% Sys:  2.2251% = 100.0000%

With unsorted page lists:

  BENCHMARKs: VC:  31.005s VO:  42.889s A:   0.000s Sys:   2.256s =   76.150s
  BENCHMARK%: VC: 40.7156% VO: 56.3219% A:  0.0000% Sys:  2.9625% = 100.0000%

VC shows the overhead of video decoding, VO shows the overhead of the
video output. Using unsorted page lists reduces the benchmark's run time
by ~32s/~25%.

v2:
	* Make sorted pagelists the special case (Sam)
	* Comment on drivers' use of pagelist (Sam)
	* Warn about the overhead in comment

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://download.blender.org/peach/bigbuckbunny_movies/big_buck_bunny_720p_stereo.ogg # [1]
Link: https://patchwork.freedesktop.org/patch/msgid/20220211094640.21632-3-tzimmermann@suse.de
Stable-dep-of: 33cd6ea9c067 ("fbdev: flush deferred IO before closing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fbtft-core.c  |  1 +
 drivers/video/fbdev/broadsheetfb.c  |  1 +
 drivers/video/fbdev/core/fb_defio.c | 24 +++++++++++++++++-------
 drivers/video/fbdev/metronomefb.c   |  1 +
 drivers/video/fbdev/udlfb.c         |  1 +
 include/linux/fb.h                  |  1 +
 6 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index 1690358b8f01..52b19ec580a4 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -654,6 +654,7 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	fbops->fb_blank     =      fbtft_fb_blank;
 
 	fbdefio->delay =           HZ / fps;
+	fbdefio->sort_pagelist =   true;
 	fbdefio->deferred_io =     fbtft_deferred_io;
 	fb_deferred_io_init(info);
 
diff --git a/drivers/video/fbdev/broadsheetfb.c b/drivers/video/fbdev/broadsheetfb.c
index fd66f4d4a621..b9054f658838 100644
--- a/drivers/video/fbdev/broadsheetfb.c
+++ b/drivers/video/fbdev/broadsheetfb.c
@@ -1059,6 +1059,7 @@ static const struct fb_ops broadsheetfb_ops = {
 
 static struct fb_deferred_io broadsheetfb_defio = {
 	.delay		= HZ/4,
+	.sort_pagelist	= true,
 	.deferred_io	= broadsheetfb_dpy_deferred_io,
 };
 
diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
index 95264a621221..bead69f39ffc 100644
--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -92,7 +92,7 @@ static vm_fault_t fb_deferred_io_mkwrite(struct vm_fault *vmf)
 	struct page *page = vmf->page;
 	struct fb_info *info = vmf->vma->vm_private_data;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
-	struct page *cur;
+	struct list_head *pos = &fbdefio->pagelist;
 
 	/* this is a callback we get when userspace first tries to
 	write to the page. we schedule a workqueue. that workqueue
@@ -133,14 +133,24 @@ static vm_fault_t fb_deferred_io_mkwrite(struct vm_fault *vmf)
 	if (!list_empty(&page->lru))
 		goto page_already_added;
 
-	/* we loop through the pagelist before adding in order
-	to keep the pagelist sorted */
-	list_for_each_entry(cur, &fbdefio->pagelist, lru) {
-		if (cur->index > page->index)
-			break;
+	if (unlikely(fbdefio->sort_pagelist)) {
+		/*
+		 * We loop through the pagelist before adding in order to
+		 * keep the pagelist sorted. This has significant overhead
+		 * of O(n^2) with n being the number of written pages. If
+		 * possible, drivers should try to work with unsorted page
+		 * lists instead.
+		 */
+		struct page *cur;
+
+		list_for_each_entry(cur, &fbdefio->pagelist, lru) {
+			if (cur->index > page->index)
+				break;
+		}
+		pos = &cur->lru;
 	}
 
-	list_add_tail(&page->lru, &cur->lru);
+	list_add_tail(&page->lru, pos);
 
 page_already_added:
 	mutex_unlock(&fbdefio->lock);
diff --git a/drivers/video/fbdev/metronomefb.c b/drivers/video/fbdev/metronomefb.c
index 952826557a0c..af858dd23ea6 100644
--- a/drivers/video/fbdev/metronomefb.c
+++ b/drivers/video/fbdev/metronomefb.c
@@ -568,6 +568,7 @@ static const struct fb_ops metronomefb_ops = {
 
 static struct fb_deferred_io metronomefb_defio = {
 	.delay		= HZ,
+	.sort_pagelist	= true,
 	.deferred_io	= metronomefb_dpy_deferred_io,
 };
 
diff --git a/drivers/video/fbdev/udlfb.c b/drivers/video/fbdev/udlfb.c
index 0de7b867714a..8603898bf37e 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -982,6 +982,7 @@ static int dlfb_ops_open(struct fb_info *info, int user)
 
 		if (fbdefio) {
 			fbdefio->delay = DL_DEFIO_WRITE_DELAY;
+			fbdefio->sort_pagelist = true;
 			fbdefio->deferred_io = dlfb_dpy_deferred_io;
 		}
 
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 3d7306c9a706..9a77ab615c36 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -204,6 +204,7 @@ struct fb_pixmap {
 struct fb_deferred_io {
 	/* delay between mkwrite and deferred handler */
 	unsigned long delay;
+	bool sort_pagelist; /* sort pagelist by offset */
 	struct mutex lock; /* mutex that protects the page list */
 	struct list_head pagelist; /* list of touched pages */
 	/* callback */
-- 
2.43.0



