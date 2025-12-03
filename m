Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F34033033B;
	Wed,  3 Dec 2025 15:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777128; cv=none; b=kxtlL4Cl8kfG+MnNz5z/VygafykseJhs5wP5hf5d2GM0ttH8obBiMPHNvSePhEH+ijDS1Qsm+XEq94pdjp9SfAyCNeOcCZgFnkd4vxpF7WO2UO/Kl8TurBpKK1Jb4FmfSqSOp4P8hFNFZfW+f0iEkaPRMnax8LM3+i45o05JI8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777128; c=relaxed/simple;
	bh=YChEWkKxygULu9HXbwc6YSvoGwoyOh7/HA7GfIA3z60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkOS3F2xco5RZe5aK9noWCr+zPIRrhS9h2gZlL6qyBlif2TOUuzjbBo83GthjeZHbZmAzFBRUeeQMqwyvVr3i8EGYlE/mpae88WNfv0QPFHHGpahqZaCNqz8TGatR/x7ZLYki1I73Hf4e0jigKVv9dIibWb7jksZnXjd+WwMiTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ih4A6LCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ih4A6LCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F894C4CEF5;
	Wed,  3 Dec 2025 15:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777128;
	bh=YChEWkKxygULu9HXbwc6YSvoGwoyOh7/HA7GfIA3z60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ih4A6LCor/zR3bo6gzm2i2uiMj1hEHR2GelGbhIHRC1ksnYtbwLVdiGk0LklEvfL2
	 LVNTxKhwcswWDhu1J2FMo3I3ZOp9ZJzgmEY61vTU6lbBO8OaWzjWrj8aX5EBGqRwcz
	 8yCLdtBD3gTpZyOYdRlKCNHW2eFEYjh4jic/wPUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	amd-gfx@lists.freedesktop.org,
	linux-fbdev@vger.kernel.org
Subject: [PATCH 6.17 090/146] drm, fbcon, vga_switcheroo: Avoid race condition in fbcon setup
Date: Wed,  3 Dec 2025 16:27:48 +0100
Message-ID: <20251203152349.753412961@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit eb76d0f5553575599561010f24c277cc5b31d003 upstream.

Protect vga_switcheroo_client_fb_set() with console lock. Avoids OOB
access in fbcon_remap_all(). Without holding the console lock the call
races with switching outputs.

VGA switcheroo calls fbcon_remap_all() when switching clients. The fbcon
function uses struct fb_info.node, which is set by register_framebuffer().
As the fb-helper code currently sets up VGA switcheroo before registering
the framebuffer, the value of node is -1 and therefore not a legal value.
For example, fbcon uses the value within set_con2fb_map() [1] as an index
into an array.

Moving vga_switcheroo_client_fb_set() after register_framebuffer() can
result in VGA switching that does not switch fbcon correctly.

Therefore move vga_switcheroo_client_fb_set() under fbcon_fb_registered(),
which already holds the console lock. Fbdev calls fbcon_fb_registered()
from within register_framebuffer(). Serializes the helper with VGA
switcheroo's call to fbcon_remap_all().

Although vga_switcheroo_client_fb_set() takes an instance of struct fb_info
as parameter, it really only needs the contained fbcon state. Moving the
call to fbcon initialization is therefore cleaner than before. Only amdgpu,
i915, nouveau and radeon support vga_switcheroo. For all other drivers,
this change does nothing.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://elixir.bootlin.com/linux/v6.17/source/drivers/video/fbdev/core/fbcon.c#L2942 # [1]
Fixes: 6a9ee8af344e ("vga_switcheroo: initial implementation (v15)")
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Cc: dri-devel@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: amd-gfx@lists.freedesktop.org
Cc: linux-fbdev@vger.kernel.org
Cc: <stable@vger.kernel.org> # v2.6.34+
Link: https://patch.msgid.link/20251105161549.98836-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_fb_helper.c  |   14 --------------
 drivers/video/fbdev/core/fbcon.c |    9 +++++++++
 2 files changed, 9 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -31,9 +31,7 @@
 
 #include <linux/console.h>
 #include <linux/export.h>
-#include <linux/pci.h>
 #include <linux/sysrq.h>
-#include <linux/vga_switcheroo.h>
 
 #include <drm/drm_atomic.h>
 #include <drm/drm_drv.h>
@@ -566,11 +564,6 @@ EXPORT_SYMBOL(drm_fb_helper_release_info
  */
 void drm_fb_helper_unregister_info(struct drm_fb_helper *fb_helper)
 {
-	struct fb_info *info = fb_helper->info;
-	struct device *dev = info->device;
-
-	if (dev_is_pci(dev))
-		vga_switcheroo_client_fb_set(to_pci_dev(dev), NULL);
 	unregister_framebuffer(fb_helper->info);
 }
 EXPORT_SYMBOL(drm_fb_helper_unregister_info);
@@ -1632,7 +1625,6 @@ static int drm_fb_helper_single_fb_probe
 	struct drm_client_dev *client = &fb_helper->client;
 	struct drm_device *dev = fb_helper->dev;
 	struct drm_fb_helper_surface_size sizes;
-	struct fb_info *info;
 	int ret;
 
 	if (drm_WARN_ON(dev, !dev->driver->fbdev_probe))
@@ -1653,12 +1645,6 @@ static int drm_fb_helper_single_fb_probe
 
 	strcpy(fb_helper->fb->comm, "[fbcon]");
 
-	info = fb_helper->info;
-
-	/* Set the fb info for vgaswitcheroo clients. Does nothing otherwise. */
-	if (dev_is_pci(info->device))
-		vga_switcheroo_client_fb_set(to_pci_dev(info->device), info);
-
 	return 0;
 }
 
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -66,6 +66,7 @@
 #include <linux/string.h>
 #include <linux/kd.h>
 #include <linux/panic.h>
+#include <linux/pci.h>
 #include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/fb.h>
@@ -78,6 +79,7 @@
 #include <linux/interrupt.h>
 #include <linux/crc32.h> /* For counting font checksums */
 #include <linux/uaccess.h>
+#include <linux/vga_switcheroo.h>
 #include <asm/irq.h>
 
 #include "fbcon.h"
@@ -2906,6 +2908,9 @@ void fbcon_fb_unregistered(struct fb_inf
 
 	console_lock();
 
+	if (info->device && dev_is_pci(info->device))
+		vga_switcheroo_client_fb_set(to_pci_dev(info->device), NULL);
+
 	fbcon_registered_fb[info->node] = NULL;
 	fbcon_num_registered_fb--;
 
@@ -3039,6 +3044,10 @@ static int do_fb_registered(struct fb_in
 		}
 	}
 
+	/* Set the fb info for vga_switcheroo clients. Does nothing otherwise. */
+	if (info->device && dev_is_pci(info->device))
+		vga_switcheroo_client_fb_set(to_pci_dev(info->device), info);
+
 	return ret;
 }
 


