Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCC3190685;
	Mon, 24 Feb 2025 15:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409262; cv=none; b=f6JJBeQES+8My4lza9yMh8GI3Vd4azru/2nLO0fMsgi0qIz/fbd7oONsBVN1/9Dr//E1Y4M6FfzgOtCcmbeMEOp+LrxuZXesJyxwPtzV0Zt2eyOC+f5ouWh+xFDsekEKZ12IogHV+UcuXLf2bCDCousEdncj8oaJ9gC1Kl+as/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409262; c=relaxed/simple;
	bh=VLslfXI9EoIyNTyedvOxz9Jedd/1mWbQlWO/M6ErYaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwwh9FHvoUoBMDrOynRzE+HcvBh112TPZvHqJTB+gfZcgVEaXvQXkcHuW8tgt4ae4F4R9Fp8MDC0qvwfjRE22ElZfZeyoojDiJMyjN1adv1cpMlExX28AzHzLxbrW+Ca32hvITAfEUR3pW8Njjj88YRbGQE/baeysdWfaoq5i/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QG9v2zy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QG9v2zy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B7AC4CED6;
	Mon, 24 Feb 2025 15:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409262;
	bh=VLslfXI9EoIyNTyedvOxz9Jedd/1mWbQlWO/M6ErYaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QG9v2zy4j4rl5B80q2NQiSgxFjWwdjn7VSwpmsN4ugDdC/rlEv0vU+bvXSkJOpY+0
	 NttA8P5s2hK7x48NxMGcGhPCQB2vQr8RU7Rgs+8VZMPJRgIW+8VS1e5GlN7ZVcmfOl
	 iXhRRmRvtw3cAIU02lNda9fsbt2sBATtj7CR48vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Arnd Bergmann <arnd@arndb.de>,
	NoisyCoil <noisycoil@disroot.org>
Subject: [PATCH 6.13 134/138] drm: select DRM_KMS_HELPER from DRM_GEM_SHMEM_HELPER
Date: Mon, 24 Feb 2025 15:36:04 +0100
Message-ID: <20250224142609.737297253@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit c40ca9ef7c5c9bbb0d2f7774c87417cc4f1713bf upstream.

In the combination of DRM_KMS_HELPER=m, DRM_GEM_SHMEM_HELPER=y, DRM_FBDEV_EMULATION=y,
The shmem code fails to link against the KMS helpers:

x86_64-linux-ld: vmlinux.o: in function `drm_fbdev_shmem_driver_fbdev_probe':
(.text+0xeec601): undefined reference to `drm_fb_helper_alloc_info'
x86_64-linux-ld: (.text+0xeec633): undefined reference to `drm_fb_helper_fill_info'
x86_64-linux-ld: vmlinux.o: in function `drm_fbdev_shmem_get_page':
drm_fbdev_shmem.c:(.text+0xeec7d2): undefined reference to `drm_gem_fb_get_obj'
x86_64-linux-ld: vmlinux.o: in function `drm_fbdev_shmem_fb_mmap':
drm_fbdev_shmem.c:(.text+0xeec9f6): undefined reference to `drm_gem_fb_get_obj'
x86_64-linux-ld: vmlinux.o: in function `drm_fbdev_shmem_defio_imageblit':
(.rodata+0x5b2288): undefined reference to `drm_fb_helper_check_var'
x86_64-linux-ld: (.rodata+0x5b2290): undefined reference to `drm_fb_helper_set_par'

This can happen for a number of device drivers that select DRM_GEM_SHMEM_HELPER
without also selecting DRM_KMS_HELPER. To work around this, add another select
that forces DRM_KMS_HELPER to be built-in rather than a loadable module, but
only if FBDEV emulation is also enabled. DRM_TTM_HELPER and DRM_GEM_DMA_HELPER
look like they have the same problem in theory even if there is no possible
configuration that shows it. For consistency, do the same change to those.

Closes: https://lore.kernel.org/all/20250121-greedy-flounder-of-abundance-4d2ee8-mkl@pengutronix.de
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20250122090211.3161186-1-arnd@kernel.org
Cc: NoisyCoil <noisycoil@disroot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -359,6 +359,7 @@ config DRM_TTM_HELPER
 	tristate
 	depends on DRM
 	select DRM_TTM
+	select DRM_KMS_HELPER if DRM_FBDEV_EMULATION
 	select FB_CORE if DRM_FBDEV_EMULATION
 	select FB_SYSMEM_HELPERS_DEFERRED if DRM_FBDEV_EMULATION
 	help
@@ -367,6 +368,7 @@ config DRM_TTM_HELPER
 config DRM_GEM_DMA_HELPER
 	tristate
 	depends on DRM
+	select DRM_KMS_HELPER if DRM_FBDEV_EMULATION
 	select FB_CORE if DRM_FBDEV_EMULATION
 	select FB_DMAMEM_HELPERS_DEFERRED if DRM_FBDEV_EMULATION
 	help
@@ -375,6 +377,7 @@ config DRM_GEM_DMA_HELPER
 config DRM_GEM_SHMEM_HELPER
 	tristate
 	depends on DRM && MMU
+	select DRM_KMS_HELPER if DRM_FBDEV_EMULATION
 	select FB_CORE if DRM_FBDEV_EMULATION
 	select FB_SYSMEM_HELPERS_DEFERRED if DRM_FBDEV_EMULATION
 	help


