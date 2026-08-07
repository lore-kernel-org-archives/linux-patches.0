Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F3B3806B0;
	Fri,  7 Aug 2026 14:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114655; cv=none; b=M0IvkiOoHWVt9LCXtA5Qs3fR1knq435FpcUQ/f01XA3h1w78KU/4uEcGdBfOG/R54ujZtF1GxPilSNxpiVdKYrMBpsXnkI9QZ14ZaOjEksh24seGkKXc1haTPuycjVpDiWQjCCHkkNrpDxTPM7J4KvnQYyRBzqAT/4piLhhdsoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114655; c=relaxed/simple;
	bh=aNgMHEfDOGGzw8tlco2WHQ9jFA9iz3aKFKegSbUkGbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXhxz959bFEGrEPv6mU5goABurOuLh/lFCg3AGgAZjeXnNeN+hRYQZ2C9vspBE+ULl/7851hTcn+HkVgRmIca+Iso2Zc7mhpGhwU3Ovbq2UDi1EtHoA29K+fHpSNjnu3RYBFoTuRje/3K+Rp9ZBPNwMek5+dnN3BtQ82vk2UMEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OiSKdHm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OiSKdHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FFF1F000E9;
	Fri,  7 Aug 2026 14:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114653;
	bh=i7qAU9PC85pfCMpTQw3RP3v9Z9elbZRQagbuUnQXWrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0OiSKdHmExVI5i1sO+qICb7IuNeeWXFdiYR9Wi78F7D7XvzQzEEVBxxUMEcAw87Vc
	 QTgXpk/vxf/0qveEBQL0IeC04hEk44J72t3nmR5khc/9uMipB4CzbXFvsaPJRNz8uT
	 RhdA9ePb3WjFAZCOweLmSDuwoOLNh+wki8NOXQc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	dri-devel@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 315/337] drm/tegra: fbdev: Remove offset into framebuffer memory
Date: Fri,  7 Aug 2026 16:38:38 +0200
Message-ID: <20260807143425.357899490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -75,7 +75,6 @@ static int tegra_fbdev_probe(struct drm_
 	struct fb_info *info = helper->info;
 	unsigned int bytes_per_pixel;
 	struct drm_framebuffer *fb;
-	unsigned long offset;
 	struct tegra_bo *bo;
 	size_t size;
 	int err;
@@ -112,9 +111,6 @@ static int tegra_fbdev_probe(struct drm_
 
 	drm_fb_helper_fill_info(info, helper, sizes);
 
-	offset = info->var.xoffset * bytes_per_pixel +
-		 info->var.yoffset * fb->pitches[0];
-
 	if (bo->pages) {
 		bo->vaddr = vmap(bo->pages, bo->num_pages, VM_MAP,
 				 pgprot_writecombine(PAGE_KERNEL));
@@ -126,9 +122,9 @@ static int tegra_fbdev_probe(struct drm_
 	}
 
 	info->flags |= FBINFO_VIRTFB;
-	info->screen_buffer = bo->vaddr + offset;
+	info->screen_buffer = bo->vaddr;
 	info->screen_size = size;
-	info->fix.smem_start = (unsigned long)(bo->iova + offset);
+	info->fix.smem_start = (unsigned long)(bo->iova);
 	info->fix.smem_len = size;
 
 	return 0;


