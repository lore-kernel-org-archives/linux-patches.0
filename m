Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9269C1798C;
	Mon, 14 Oct 2024 14:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916288; cv=none; b=ckoM+lxx3HkfeeezsMvzqEZp6zHF2lownC92nQ8Z0c/1HqZzsXdxpuBxup4CGznfxyExTToXnJhnJeL1GgVYUrR/WWmj4k5vn3UQ3ic5FLJqU26IFXPFyDQMoEOxXtyHrlrczcQwuBXb4ATe1wxec5LbS+MoKlm5dTbgmtuKsCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916288; c=relaxed/simple;
	bh=sHOvTNkSWMioRijk87nSB0qFA/AzWKqYJmO1hEKZTWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxnBMmirkEwTMX8k7WbLK+YrhdWuSWCh5eTyKQkXqxrsTa0xEOOs3jPloRvOtUvz98IbRLJKfd8Wnb9k+uKwACWm9fjJ0ujlByZWLrVPqPB7bIB87Va2fOMozPRprzpxkKu2jcECrme3n3/7vmyFlyKsKoGriw/bZhSHvmueRD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBiykfLj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBiykfLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1565EC4CEC3;
	Mon, 14 Oct 2024 14:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916288;
	bh=sHOvTNkSWMioRijk87nSB0qFA/AzWKqYJmO1hEKZTWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBiykfLj79yazcMi2xS3+pIGkLEvhszMpR9lY4vgpmTbKdh7ZH6rWYHQZfGJMxMv0
	 dedrhNkzT4Hh8uqqdq9dQRERcs6cSs3LmjqI+tK4DUf5awblZT8Csc/cRXRwwIgMg6
	 lkqsAeS3a+QprpaoSl5AyvXIMG3zMRCB5+5Gf9wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 139/214] drm/fbdev-dma: Only cleanup deferred I/O if necessary
Date: Mon, 14 Oct 2024 16:20:02 +0200
Message-ID: <20241014141050.414348299@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Grunau <j@jannau.net>

[ Upstream commit fcddc71ec7ecf15b4df3c41288c9cf0b8e886111 ]

Commit 5a498d4d06d6 ("drm/fbdev-dma: Only install deferred I/O if
necessary") initializes deferred I/O only if it is used.
drm_fbdev_dma_fb_destroy() however calls fb_deferred_io_cleanup()
unconditionally with struct fb_info.fbdefio == NULL. KASAN with the
out-of-tree Apple silicon display driver posts following warning from
__flush_work() of a random struct work_struct instead of the expected
NULL pointer derefs.

[   22.053799] ------------[ cut here ]------------
[   22.054832] WARNING: CPU: 2 PID: 1 at kernel/workqueue.c:4177 __flush_work+0x4d8/0x580
[   22.056597] Modules linked in: uhid bnep uinput nls_ascii ip6_tables ip_tables i2c_dev loop fuse dm_multipath nfnetlink zram hid_magicmouse btrfs xor xor_neon brcmfmac_wcc raid6_pq hci_bcm4377 bluetooth brcmfmac hid_apple brcmutil nvmem_spmi_mfd simple_mfd_spmi dockchannel_hid cfg80211 joydev regmap_spmi nvme_apple ecdh_generic ecc macsmc_hid rfkill dwc3 appledrm snd_soc_macaudio macsmc_power nvme_core apple_isp phy_apple_atc apple_sart apple_rtkit_helper apple_dockchannel tps6598x macsmc_hwmon snd_soc_cs42l84 videobuf2_v4l2 spmi_apple_controller nvmem_apple_efuses videobuf2_dma_sg apple_z2 videobuf2_memops spi_nor panel_summit videobuf2_common asahi videodev pwm_apple apple_dcp snd_soc_apple_mca apple_admac spi_apple clk_apple_nco i2c_pasemi_platform snd_pcm_dmaengine mc i2c_pasemi_core mux_core ofpart adpdrm drm_dma_helper apple_dart apple_soc_cpufreq leds_pwm phram
[   22.073768] CPU: 2 UID: 0 PID: 1 Comm: systemd-shutdow Not tainted 6.11.2-asahi+ #asahi-dev
[   22.075612] Hardware name: Apple MacBook Pro (13-inch, M2, 2022) (DT)
[   22.077032] pstate: 01400005 (nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[   22.078567] pc : __flush_work+0x4d8/0x580
[   22.079471] lr : __flush_work+0x54/0x580
[   22.080345] sp : ffffc000836ef820
[   22.081089] x29: ffffc000836ef880 x28: 0000000000000000 x27: ffff80002ddb7128
[   22.082678] x26: dfffc00000000000 x25: 1ffff000096f0c57 x24: ffffc00082d3e358
[   22.084263] x23: ffff80004b7862b8 x22: dfffc00000000000 x21: ffff80005aa1d470
[   22.085855] x20: ffff80004b786000 x19: ffff80004b7862a0 x18: 0000000000000000
[   22.087439] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000005
[   22.089030] x14: 1ffff800106ddf0a x13: 0000000000000000 x12: 0000000000000000
[   22.090618] x11: ffffb800106ddf0f x10: dfffc00000000000 x9 : 1ffff800106ddf0e
[   22.092206] x8 : 0000000000000000 x7 : aaaaaaaaaaaaaaaa x6 : 0000000000000001
[   22.093790] x5 : ffffc000836ef728 x4 : 0000000000000000 x3 : 0000000000000020
[   22.095368] x2 : 0000000000000008 x1 : 00000000000000aa x0 : 0000000000000000
[   22.096955] Call trace:
[   22.097505]  __flush_work+0x4d8/0x580
[   22.098330]  flush_delayed_work+0x80/0xb8
[   22.099231]  fb_deferred_io_cleanup+0x3c/0x130
[   22.100217]  drm_fbdev_dma_fb_destroy+0x6c/0xe0 [drm_dma_helper]
[   22.101559]  unregister_framebuffer+0x210/0x2f0
[   22.102575]  drm_fb_helper_unregister_info+0x48/0x60
[   22.103683]  drm_fbdev_dma_client_unregister+0x4c/0x80 [drm_dma_helper]
[   22.105147]  drm_client_dev_unregister+0x1cc/0x230
[   22.106217]  drm_dev_unregister+0x58/0x570
[   22.107125]  apple_drm_unbind+0x50/0x98 [appledrm]
[   22.108199]  component_del+0x1f8/0x3a8
[   22.109042]  dcp_platform_shutdown+0x24/0x38 [apple_dcp]
[   22.110357]  platform_shutdown+0x70/0x90
[   22.111219]  device_shutdown+0x368/0x4d8
[   22.112095]  kernel_restart+0x6c/0x1d0
[   22.112946]  __arm64_sys_reboot+0x1c8/0x328
[   22.113868]  invoke_syscall+0x78/0x1a8
[   22.114703]  do_el0_svc+0x124/0x1a0
[   22.115498]  el0_svc+0x3c/0xe0
[   22.116181]  el0t_64_sync_handler+0x70/0xc0
[   22.117110]  el0t_64_sync+0x190/0x198
[   22.117931] ---[ end trace 0000000000000000 ]---

Signed-off-by: Janne Grunau <j@jannau.net>
Fixes: 5a498d4d06d6 ("drm/fbdev-dma: Only install deferred I/O if necessary")
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/ZwLNuZL-8Gh5UUQb@robin
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fbdev_dma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_fbdev_dma.c b/drivers/gpu/drm/drm_fbdev_dma.c
index b0602c4f36283..51c2d742d1998 100644
--- a/drivers/gpu/drm/drm_fbdev_dma.c
+++ b/drivers/gpu/drm/drm_fbdev_dma.c
@@ -50,7 +50,8 @@ static void drm_fbdev_dma_fb_destroy(struct fb_info *info)
 	if (!fb_helper->dev)
 		return;
 
-	fb_deferred_io_cleanup(info);
+	if (info->fbdefio)
+		fb_deferred_io_cleanup(info);
 	drm_fb_helper_fini(fb_helper);
 
 	drm_client_buffer_vunmap(fb_helper->buffer);
-- 
2.43.0



