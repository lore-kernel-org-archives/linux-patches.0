Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5BB193;
	Fri,  6 Dec 2024 14:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496340; cv=none; b=IsarjOYk439zD7fMVhG/0og3+kmaKS2IyaeS2ZvcQbFKI1TRS72u7VrTmJHFlh0CQRPwA7dPvP6Y8Fz2fwpESt3MrYXD3gwdRteqwE9e++l4FOb0DmzZeHYsZ7I72U09yUhgFo7GBst24Mvwn7phdjm/l48C6qka3E0QTE6XiXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496340; c=relaxed/simple;
	bh=ExU1xBn+s5IssvAsm96gZQcZTRs1LzcA2dp5Mly6xJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWw71BiPVLDM2+ZYlgvslWrb+3Iv/Jv4fa/qvf6aWAGmZfiyBAREGALIjiUwI8/XVzEUI7TeFzCRXdglRalDaj8wAge6NNyTc4LhX5is+VvG5SRqIZVmPLdO94af2vG3SJ2NaxUOb15pvE96G+gAxOSUFu2uWywa8j//Nu6EXx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9Z3LwaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9Z3LwaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D73CC4CED1;
	Fri,  6 Dec 2024 14:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496340;
	bh=ExU1xBn+s5IssvAsm96gZQcZTRs1LzcA2dp5Mly6xJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9Z3LwaGG9ImQR0EiIxO6Y7OR3jsEpaSyq+jNpMo8T0kuIm3Llgv+SjBFnBluzFRA
	 K6OcdzEOfeZjo3NW42QDHsnC9PjyMFAwd6roIYO5MW6ZVR6Q3dUiAL3pBhIxEunh6h
	 4jSl/ZbAs/cQ/xYtMsNunwRrWTNNTMPAm8rraTWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	kernel test robot <lkp@intel.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>
Subject: [PATCH 6.12 124/146] drm/fbdev-dma: Select FB_DEFERRED_IO
Date: Fri,  6 Dec 2024 15:37:35 +0100
Message-ID: <20241206143532.427411437@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 67c40c9b2ec5f375bf78274d4e9ef0e3b8315bea upstream.

Commit 808a40b69468 ("drm/fbdev-dma: Implement damage handling and
deferred I/O") added deferred I/O for fbdev-dma. Also select the
Kconfig symbol FB_DEFERRED_IO (via FB_DMAMEM_HELPERS_DEFERRED). Fixes
build errors about missing fbdefio, such as

drivers/gpu/drm/drm_fbdev_dma.c:218:26: error: 'struct drm_fb_helper' has no member named 'fbdefio'
  218 |                 fb_helper->fbdefio.delay = HZ / 20;
      |                          ^~
drivers/gpu/drm/drm_fbdev_dma.c:219:26: error: 'struct drm_fb_helper' has no member named 'fbdefio'
  219 |                 fb_helper->fbdefio.deferred_io = drm_fb_helper_deferred_io;
      |                          ^~
drivers/gpu/drm/drm_fbdev_dma.c:221:21: error: 'struct fb_info' has no member named 'fbdefio'
  221 |                 info->fbdefio = &fb_helper->fbdefio;
      |                     ^~
drivers/gpu/drm/drm_fbdev_dma.c:221:43: error: 'struct drm_fb_helper' has no member named 'fbdefio'
  221 |                 info->fbdefio = &fb_helper->fbdefio;
      |                                           ^~

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410050241.Mox9QRjP-lkp@intel.com/
Fixes: 808a40b69468 ("drm/fbdev-dma: Implement damage handling and deferred I/O")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: <stable@vger.kernel.org> # v6.11+
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241014085740.582287-4-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -327,7 +327,7 @@ config DRM_TTM_HELPER
 config DRM_GEM_DMA_HELPER
 	tristate
 	depends on DRM
-	select FB_DMAMEM_HELPERS if DRM_FBDEV_EMULATION
+	select FB_DMAMEM_HELPERS_DEFERRED if DRM_FBDEV_EMULATION
 	help
 	  Choose this if you need the GEM DMA helper functions
 


