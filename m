Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D6947DFA7;
	Thu, 20 Aug 2026 16:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244391; cv=none; b=sVQ53SOgn5AwPMSXw4GKBMqYHSj0NtXxeMAJO1RmrUc7IbjKwPXaK5luFIMZYDuQkZl87vLF11AqQ517xuyBMBjSBz+yncKAbiUaoFzjCZvE/lNRdDwYtNqc7K0KBx9pnTz4ufuXX+tVjDB8Z22nqfUdet99GQxQCpj6MD3K1EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244391; c=relaxed/simple;
	bh=RztFQLe8TWGmvA436jlNWpS+4SHsLk/EdZU3GaqaRcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M63NUpEojqls53dEt+vCQnuzrSaaI+u47KlaO/85Cv13CSpWH44fQbvcLjH1/blaijSGS4ZF5C1Jsd3Z7agigXU/UHVnwSjjW0YHwJEiXJfIyZvpOZWM+fBg8kMKLdNfOS0szCCbJaQtrSqp2G43oPGyQzGQgRAGCWQe18l+fCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqPwYR/P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqPwYR/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FF71F000E9;
	Thu, 20 Aug 2026 16:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244390;
	bh=z5f0bdM88f8qXgWUh8abKnFGggAd8FOQxTad1kMzuJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YqPwYR/PAjgMbhMMXLOEvxcNA25c20P0fepZvnU8trqjD0v77GJlRkQ0vdqyPtghs
	 HNUccEX5mNqKJfRal1HCO0qht+a2ePu/JVjobCeN6GQJEgPDddMz8MrUaz5W+Y318+
	 2Engb83WFN+p/h3eZSerEKp+EPAYwOjoHDHk/OFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	dri-devel@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/235] drm/tegra: fbdev: Remove offset into framebuffer memory
Date: Thu, 20 Aug 2026 16:56:29 +0200
Message-ID: <20260820145221.096513837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/tegra/fb.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/tegra/fb.c
+++ b/drivers/gpu/drm/tegra/fb.c
@@ -211,7 +211,6 @@ static int tegra_fbdev_probe(struct drm_
 	struct drm_mode_fb_cmd2 cmd = { 0 };
 	unsigned int bytes_per_pixel;
 	struct drm_framebuffer *fb;
-	unsigned long offset;
 	struct fb_info *info;
 	struct tegra_bo *bo;
 	size_t size;
@@ -257,9 +256,6 @@ static int tegra_fbdev_probe(struct drm_
 
 	drm_fb_helper_fill_info(info, helper, sizes);
 
-	offset = info->var.xoffset * bytes_per_pixel +
-		 info->var.yoffset * fb->pitches[0];
-
 	if (bo->pages) {
 		bo->vaddr = vmap(bo->pages, bo->num_pages, VM_MAP,
 				 pgprot_writecombine(PAGE_KERNEL));
@@ -271,9 +267,9 @@ static int tegra_fbdev_probe(struct drm_
 	}
 
 	drm->mode_config.fb_base = (resource_size_t)bo->iova;
-	info->screen_base = (void __iomem *)bo->vaddr + offset;
+	info->screen_base = (void __iomem *)bo->vaddr;
 	info->screen_size = size;
-	info->fix.smem_start = (unsigned long)(bo->iova + offset);
+	info->fix.smem_start = (unsigned long)(bo->iova);
 	info->fix.smem_len = size;
 
 	return 0;


