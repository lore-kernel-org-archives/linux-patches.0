Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277282F39C2;
	Wed,  8 Apr 2026 18:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674577; cv=none; b=ennhZo15gMdBpjjdxZFqX8yJYDCnEqNfPat1Q9sWf6uw0U5sANEySPdvPaMBJl5GbqfAi5a1x5doZOIFdYefVb+Y+DSzTxNma9PmsFdps3ISvowIM2nBNDxqvpaJaKIXv9Zz/beCGiGoT75wvpF/Sq/UEccoBYhUaGafOWDqtY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674577; c=relaxed/simple;
	bh=L9i6ov+37pjusx2nFgDvVod4cQQ46PQpZcLSVfdeNSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+rcwc9DyBE8A+HY8a+B+CioHbvBLZCBQXPo2JQ5DM/ezoOb3P4Soo9jnDF2aWOdI5BKjeNpC6LP3cTLEi/AJu/VmnnR7HdHjfbPUy9XTb3E8PXwiav0z1Wq/w1tm6cZw2Hlv3X2WlzrOJ68LydJB903/Iq0ZyofCxWWj1gp7Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lq922YlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lq922YlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10F8C19421;
	Wed,  8 Apr 2026 18:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674577;
	bh=L9i6ov+37pjusx2nFgDvVod4cQQ46PQpZcLSVfdeNSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lq922YlQahQUUdZQ3Q+JOyq5TR13dTI4hDPhmPFmqK/hki6h/ew/Rc/EBhlTcxcM7
	 rlGL0q0IAjF6sDKQZHy8Cy/gU12EqK2DyN9NFv5Bl/E56ObMbrcZUWHf4m1z0F2N8B
	 frhwJYJPqCftq0Wxs2eN5Ma+P51DmKuSFmgHZxCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 152/311] drm/sysfb: Fix efidrm error handling and memory type mismatch
Date: Wed,  8 Apr 2026 20:02:32 +0200
Message-ID: <20260408175945.083623718@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 5e77923a3eb39cce91bf08ed7670f816bf86d4af ]

Fix incorrect error checking and memory type confusion in
efidrm_device_create(). devm_memremap() returns error pointers, not
NULL, and returns system memory while devm_ioremap() returns I/O memory.
The code incorrectly passes system memory to iosys_map_set_vaddr_iomem().

Restructure to handle each memory type separately. Use devm_ioremap*()
with ERR_PTR(-ENXIO) for WC/UC, and devm_memremap() with ERR_CAST() for
WT/WB.

Fixes: 32ae90c66fb6 ("drm/sysfb: Add efidrm for EFI displays")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260311064652.2903449-1-nichen@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sysfb/efidrm.c | 46 +++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/sysfb/efidrm.c b/drivers/gpu/drm/sysfb/efidrm.c
index 1b683d55d6ea4..ac48bfa47e081 100644
--- a/drivers/gpu/drm/sysfb/efidrm.c
+++ b/drivers/gpu/drm/sysfb/efidrm.c
@@ -151,7 +151,6 @@ static struct efidrm_device *efidrm_device_create(struct drm_driver *drv,
 	struct drm_sysfb_device *sysfb;
 	struct drm_device *dev;
 	struct resource *mem = NULL;
-	void __iomem *screen_base = NULL;
 	struct drm_plane *primary_plane;
 	struct drm_crtc *crtc;
 	struct drm_encoder *encoder;
@@ -236,21 +235,38 @@ static struct efidrm_device *efidrm_device_create(struct drm_driver *drv,
 
 	mem_flags = efidrm_get_mem_flags(dev, res->start, vsize);
 
-	if (mem_flags & EFI_MEMORY_WC)
-		screen_base = devm_ioremap_wc(&pdev->dev, mem->start, resource_size(mem));
-	else if (mem_flags & EFI_MEMORY_UC)
-		screen_base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
-	else if (mem_flags & EFI_MEMORY_WT)
-		screen_base = devm_memremap(&pdev->dev, mem->start, resource_size(mem),
-					    MEMREMAP_WT);
-	else if (mem_flags & EFI_MEMORY_WB)
-		screen_base = devm_memremap(&pdev->dev, mem->start, resource_size(mem),
-					    MEMREMAP_WB);
-	else
+	if (mem_flags & EFI_MEMORY_WC) {
+		void __iomem *screen_base = devm_ioremap_wc(&pdev->dev, mem->start,
+							    resource_size(mem));
+
+		if (!screen_base)
+			return ERR_PTR(-ENXIO);
+		iosys_map_set_vaddr_iomem(&sysfb->fb_addr, screen_base);
+	} else if (mem_flags & EFI_MEMORY_UC) {
+		void __iomem *screen_base = devm_ioremap(&pdev->dev, mem->start,
+							 resource_size(mem));
+
+		if (!screen_base)
+			return ERR_PTR(-ENXIO);
+		iosys_map_set_vaddr_iomem(&sysfb->fb_addr, screen_base);
+	} else if (mem_flags & EFI_MEMORY_WT) {
+		void *screen_base = devm_memremap(&pdev->dev, mem->start,
+						  resource_size(mem), MEMREMAP_WT);
+
+		if (IS_ERR(screen_base))
+			return ERR_CAST(screen_base);
+		iosys_map_set_vaddr(&sysfb->fb_addr, screen_base);
+	} else if (mem_flags & EFI_MEMORY_WB) {
+		void *screen_base = devm_memremap(&pdev->dev, mem->start,
+						  resource_size(mem), MEMREMAP_WB);
+
+		if (IS_ERR(screen_base))
+			return ERR_CAST(screen_base);
+		iosys_map_set_vaddr(&sysfb->fb_addr, screen_base);
+	} else {
 		drm_err(dev, "invalid mem_flags: 0x%llx\n", mem_flags);
-	if (!screen_base)
-		return ERR_PTR(-ENOMEM);
-	iosys_map_set_vaddr_iomem(&sysfb->fb_addr, screen_base);
+		return ERR_PTR(-EINVAL);
+	}
 
 	/*
 	 * Modesetting
-- 
2.53.0



