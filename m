Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1467468C20;
	Fri,  7 Aug 2026 15:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115719; cv=none; b=hLhyx8OxWi6zfkN1Ofw+o9y7ZoqpPFzB4RVJyr4JCX7owwyR97QaJH0SgCSIeDoKB+uZllbUo1E1Ndp2X6FCwoSGHUl1JlaRqIKBFR2g2C63pM3FWPD3Z/vMVvJFa1rKjIH5xBamcQm5U7U3x/iwvDuIsBR6yVgiFrSNaapbo38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115719; c=relaxed/simple;
	bh=f/caM0N3RnSVZDerdHsjA/MX0+DIIg6Twwn12zJpdJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSzNXDwYVkYkaBBEd0r4PsXyQH88cjyUZgCqjSV9a0A5Z6PKxOO4+p3VyoTYiiQJ+9ObHjb+cbWwjw9bx0SR9dcJ6iMIzSCkfbBk9XhbHwP1lNkDZZGVhyTkQntqzBYMrg1DIV4S8TXNJA/wqevfFD9hYAkirrSefd8kfu5Kpfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ctHpOp6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ctHpOp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093CA1F000E9;
	Fri,  7 Aug 2026 15:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115718;
	bh=7g8Y+FgcmohVTs7tyS+7VOkxjtVPgvUC4Na94V0Aexk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ctHpOp6FWrezPa8ErNITypHnWjC+E1y4JQa7IHpJKov5qAZfEoDvpFCmd2VG+tML
	 Z37hjsdApXugyDC2n1eaeYnwf16i3y+onmcEEKpIio6R3SQVqmqm4jcczppsOTm1mw
	 o2nGmv8r9kgWcSDzmMNahgFpCQZRQeU6vOAn722A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	dri-devel@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 373/396] drm/tegra: fbdev: Remove offset into framebuffer memory
Date: Fri,  7 Aug 2026 16:38:53 +0200
Message-ID: <20260807143432.328519401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit a18b6e30ecd69096beda4a0c96d2570900c3879a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tegra/fbdev.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/tegra/fbdev.c
+++ b/drivers/gpu/drm/tegra/fbdev.c
@@ -78,7 +78,6 @@ int tegra_fbdev_driver_fbdev_probe(struc
 	struct fb_info *info = helper->info;
 	unsigned int bytes_per_pixel;
 	struct drm_framebuffer *fb;
-	unsigned long offset;
 	struct tegra_bo *bo;
 	size_t size;
 	int err;
@@ -118,9 +117,6 @@ int tegra_fbdev_driver_fbdev_probe(struc
 
 	drm_fb_helper_fill_info(info, helper, sizes);
 
-	offset = info->var.xoffset * bytes_per_pixel +
-		 info->var.yoffset * fb->pitches[0];
-
 	if (bo->pages) {
 		bo->vaddr = vmap(bo->pages, bo->num_pages, VM_MAP,
 				 pgprot_writecombine(PAGE_KERNEL));
@@ -132,9 +128,9 @@ int tegra_fbdev_driver_fbdev_probe(struc
 	}
 
 	info->flags |= FBINFO_VIRTFB;
-	info->screen_buffer = bo->vaddr + offset;
+	info->screen_buffer = bo->vaddr;
 	info->screen_size = size;
-	info->fix.smem_start = (unsigned long)(bo->iova + offset);
+	info->fix.smem_start = (unsigned long)(bo->iova);
 	info->fix.smem_len = size;
 
 	return 0;


