Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4FB4314B5;
	Thu, 30 Jul 2026 14:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422367; cv=none; b=ZxFYZg38rGKxppNP3dx+lN/sIsk7DAokThizbKdMk5CJB6uXjvMkXWCHUHQonvaCzekLY7+8Y/r9+Mbs8+ofI2cl7ULBBHDo7PluJm2t3q6QHjxIW10DjTmJXclILY0T2Mb/10VzG+dKdOVJVF6AW7lJlMAwtToV2IrBdcsgd3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422367; c=relaxed/simple;
	bh=PGe2pDue1qu4xyGfn8T5bI+eGulFB+nAvlNERoVdhjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmAZF9cRT/n1kwyeDwO1b8/wqsh10qQaBLi8Hvx45DMcV6q9boK1SmNrvYB10AtdhzMMotEvL/WJ8ZB8m3tINhAgHlHHQZ0Nsd38UeIqLHvx3ZScUBo8s2YsUu7z9jXXIYgX4IGwfXxPRQVloAknJ2rEcQ6ZzJ8pLtytyyv2PmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aH/LWaaC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aH/LWaaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1571F000E9;
	Thu, 30 Jul 2026 14:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422366;
	bh=9nRjBa2LBQWItYFoD3xn1W/FOWLzIBvigFF73kkfcsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aH/LWaaC+M8tN5wYMCybbK23yzrByHB4sxmALNegNsB6IUVDHNrgjnBBwWQ4zGAeB
	 2UJGP7MTojatKp1RLG9Fbj1ZDU1LRWKy8gLkOWNRI4bxm4Azp70usBI/xsOz2CjuCl
	 qnNaqBIqjxocO1Vs+lMEDhPL76ZwnE7rwZayDc1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	dri-devel@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 7.1 369/744] drm/tegra: fbdev: Remove offset into framebuffer memory
Date: Thu, 30 Jul 2026 16:10:42 +0200
Message-ID: <20260730141452.130617945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit a18b6e30ecd69096beda4a0c96d2570900c3879a upstream.

The screen_buffer field in struct fb_info contains the kernel address
of the first byte of framebuffer memory. Do not add the display offset.
This offset only describes scrolling during scanout.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: de2ba664c30f ("gpu: host1x: drm: Add memory manager and fb")
Cc: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org
Cc: <stable@vger.kernel.org> # v3.10+
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260421073646.144712-3-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tegra/fbdev.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/tegra/fbdev.c
+++ b/drivers/gpu/drm/tegra/fbdev.c
@@ -76,7 +76,6 @@ int tegra_fbdev_driver_fbdev_probe(struc
 	struct fb_info *info = helper->info;
 	unsigned int bytes_per_pixel;
 	struct drm_framebuffer *fb;
-	unsigned long offset;
 	struct tegra_bo *bo;
 	size_t size;
 	int err;
@@ -115,9 +114,6 @@ int tegra_fbdev_driver_fbdev_probe(struc
 
 	drm_fb_helper_fill_info(info, helper, sizes);
 
-	offset = info->var.xoffset * bytes_per_pixel +
-		 info->var.yoffset * fb->pitches[0];
-
 	if (bo->pages) {
 		bo->vaddr = vmap(bo->pages, bo->num_pages, VM_MAP,
 				 pgprot_writecombine(PAGE_KERNEL));
@@ -129,9 +125,9 @@ int tegra_fbdev_driver_fbdev_probe(struc
 	}
 
 	info->flags |= FBINFO_VIRTFB;
-	info->screen_buffer = bo->vaddr + offset;
+	info->screen_buffer = bo->vaddr;
 	info->screen_size = size;
-	info->fix.smem_start = (unsigned long)(bo->iova + offset);
+	info->fix.smem_start = (unsigned long)(bo->iova);
 	info->fix.smem_len = size;
 
 	return 0;


