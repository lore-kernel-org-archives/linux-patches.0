Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0901C8FA7;
	Tue,  2 Jul 2024 17:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940662; cv=none; b=Vjk3uskVPiQvGF85WppGo5JjQWitGKGlkt51lVA4ofO8qWTyxfxCFtyiLk/Qd8FQqVC/ioHwnzVDJ1blqxAZy6Yj/xbQrEaDj1AM13nB4h8FZdELX49boRNWh+KdwykVKmNb4Xfs29Tcg2dOQaVlHQ3J2vHzHUn7D//YxLIwF8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940662; c=relaxed/simple;
	bh=V2almonY0bHuwiNHW2pSLafMHVT1OGhNacViKwA/wGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaZujRaVidzDvLYur2ZDrMv9b07ntsuOKzhfC9VL55+oDDtLIaPpkaSoZoEU91X5JXopqjs/WHBj6ro01d4q0ECPxKkBPKrQQ80sQpYWGl+HxS+AMaNo5wjtxlvqUuJAKsOOalP/ewGSCriGF4JlhjMMVGzDHTKzfRDUzxG3+MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfRs2S4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfRs2S4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F02CC4AF07;
	Tue,  2 Jul 2024 17:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940661;
	bh=V2almonY0bHuwiNHW2pSLafMHVT1OGhNacViKwA/wGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfRs2S4Q5I+u2Rj62pGbgOnKFilBM3S2p1xxOkTE4bfi1Ui2Om3Epe8NeJB270Srd
	 bS7dENq9l84Cgr7XHlXL5yD/o/38aG9chPeleu1uwnMfbyJi4onjtkoF6AtOKOaKcC
	 dBl5nV6EJnyyzerJdYvC1BethKnuVmT49kDu1fsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	"Peng Fan (OSS)" <peng.fan@oss.nxp.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 6.9 181/222] drm/fbdev-dma: Only set smem_start is enable per module option
Date: Tue,  2 Jul 2024 19:03:39 +0200
Message-ID: <20240702170250.894008343@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit d92a7580392ad4681b1d4f9275d00b95375ebe01 upstream.

Only export struct fb_info.fix.smem_start if that is required by the
user and the memory does not come from vmalloc().

Setting struct fb_info.fix.smem_start breaks systems where DMA
memory is backed by vmalloc address space. An example error is
shown below.

[    3.536043] ------------[ cut here ]------------
[    3.540716] virt_to_phys used for non-linear address: 000000007fc4f540 (0xffff800086001000)
[    3.552628] WARNING: CPU: 4 PID: 61 at arch/arm64/mm/physaddr.c:12 __virt_to_phys+0x68/0x98
[    3.565455] Modules linked in:
[    3.568525] CPU: 4 PID: 61 Comm: kworker/u12:5 Not tainted 6.6.23-06226-g4986cc3e1b75-dirty #250
[    3.577310] Hardware name: NXP i.MX95 19X19 board (DT)
[    3.582452] Workqueue: events_unbound deferred_probe_work_func
[    3.588291] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    3.595233] pc : __virt_to_phys+0x68/0x98
[    3.599246] lr : __virt_to_phys+0x68/0x98
[    3.603276] sp : ffff800083603990
[    3.677939] Call trace:
[    3.680393]  __virt_to_phys+0x68/0x98
[    3.684067]  drm_fbdev_dma_helper_fb_probe+0x138/0x238
[    3.689214]  __drm_fb_helper_initial_config_and_unlock+0x2b0/0x4c0
[    3.695385]  drm_fb_helper_initial_config+0x4c/0x68
[    3.700264]  drm_fbdev_dma_client_hotplug+0x8c/0xe0
[    3.705161]  drm_client_register+0x60/0xb0
[    3.709269]  drm_fbdev_dma_setup+0x94/0x148

Additionally, DMA memory is assumed to by contiguous in physical
address space, which is not guaranteed by vmalloc().

Resolve this by checking the module flag drm_leak_fbdev_smem when
DRM allocated the instance of struct fb_info. Fbdev-dma then only
sets smem_start only if required (via FBINFO_HIDE_SMEM_START). Also
guarantee that the framebuffer is not located in vmalloc address
space.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: Peng Fan (OSS) <peng.fan@oss.nxp.com>
Closes: https://lore.kernel.org/dri-devel/20240604080328.4024838-1-peng.fan@oss.nxp.com/
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Closes: https://lore.kernel.org/dri-devel/CAMuHMdX3N0szUvt1VTbroa2zrT1Nye_VzPb5qqCZ7z5gSm7HGw@mail.gmail.com/
Fixes: a51c7663f144 ("drm/fb-helper: Consolidate CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM")
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: <stable@vger.kernel.org> # v6.4+
Link: https://patchwork.freedesktop.org/patch/msgid/20240617152843.11886-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_fb_helper.c |    6 +++---
 drivers/gpu/drm/drm_fbdev_dma.c |    5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -524,6 +524,9 @@ struct fb_info *drm_fb_helper_alloc_info
 	if (!info)
 		return ERR_PTR(-ENOMEM);
 
+	if (!drm_leak_fbdev_smem)
+		info->flags |= FBINFO_HIDE_SMEM_START;
+
 	ret = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (ret)
 		goto err_release;
@@ -1860,9 +1863,6 @@ __drm_fb_helper_initial_config_and_unloc
 	info = fb_helper->info;
 	info->var.pixclock = 0;
 
-	if (!drm_leak_fbdev_smem)
-		info->flags |= FBINFO_HIDE_SMEM_START;
-
 	/* Need to drop locks to avoid recursive deadlock in
 	 * register_framebuffer. This is ok because the only thing left to do is
 	 * register the fbdev emulation instance in kernel_fb_helper_list. */
--- a/drivers/gpu/drm/drm_fbdev_dma.c
+++ b/drivers/gpu/drm/drm_fbdev_dma.c
@@ -130,7 +130,10 @@ static int drm_fbdev_dma_helper_fb_probe
 		info->flags |= FBINFO_READS_FAST; /* signal caching */
 	info->screen_size = sizes->surface_height * fb->pitches[0];
 	info->screen_buffer = map.vaddr;
-	info->fix.smem_start = page_to_phys(virt_to_page(info->screen_buffer));
+	if (!(info->flags & FBINFO_HIDE_SMEM_START)) {
+		if (!drm_WARN_ON(dev, is_vmalloc_addr(info->screen_buffer)))
+			info->fix.smem_start = page_to_phys(virt_to_page(info->screen_buffer));
+	}
 	info->fix.smem_len = info->screen_size;
 
 	return 0;


