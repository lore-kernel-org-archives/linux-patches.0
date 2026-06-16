Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E9D32B138;
	Tue, 16 Jun 2026 17:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630087; cv=none; b=IxyiYwzn+Mh2Ivn5Pp/pCQnIML1BWElZIq+sjqp9GAoIECO+MUfEUpK6t0e5QNERvL6e2RUssvAT6z6vxZJesFeFQVi52z78SE5cALvXMZ6XsZNCluDqmTMzTpYM4E9IuoZlM/hvdcPqBEabswOE3iraCydxOwvbfk+5r0YMg1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630087; c=relaxed/simple;
	bh=AtzkLxMt4WMnCCoTypP6vQpEvhVMKf4UOkeVR/5bA/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbcMFEqS/QycSG1isEQjZ8xvLDtTuJ9Wa/VLjsURUdwkIJLRGD7KvBa4yLrsDvk63VMpINf7HMs62GJSyPnJasGC9JM8BVgKUx0kh176Mvx2fRr4jL2NmWmhChEKKFsL9hlt8kxLb41MesnYFfl/OBzUkRPdEpsoOUVt6G8GTuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVlr283m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVlr283m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4F21F000E9;
	Tue, 16 Jun 2026 17:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630085;
	bh=deiErL8Y7oY9f864BbnYeU+3A/92Y4BP6lE7VtbxNcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVlr283mQ1EmOseDBEhgDTWveUGQgrl0M4yZfn23/vMqDGJpaGJ/KVJGELf0lc/To
	 H93bMdeBzZksMbJqG0MOo8sELDoXsVBpoeHU2V0XeL91PeLgkObbGmwRz13ptKm9LF
	 ZytCMbcmhK81PN+/AO7TXZoKlgkAJJt5knrgiiq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Ben Hutchings <benh@debian.org>
Subject: [PATCH 6.6 375/452] fbdev/vt8500lcdfb: Initialize fb_ops with fbdev macros
Date: Tue, 16 Jun 2026 20:30:02 +0530
Message-ID: <20260616145136.695175208@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 63a11adaceb8b77d70bcce0890197fa9462ce160 upstream.

Initialize the instance of struct fb_ops with fbdev initializer
macros for framebuffers in DMA-able virtual address space. Set the
read/write, draw and mmap callbacks to the correct implementation
and avoid implicit defaults. Also select the necessary helpers in
Kconfig.

Fbdev drivers sometimes rely on the callbacks being NULL for a
default I/O-memory-based implementation to be invoked; hence
requiring the I/O helpers to be built in any case. Setting all
callbacks in all drivers explicitly will allow to make the I/O
helpers optional. This benefits systems that do not use these
functions.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231127131655.4020-23-tzimmermann@suse.de
Cc: Ben Hutchings <benh@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/Kconfig       |    1 +
 drivers/video/fbdev/vt8500lcdfb.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -1464,6 +1464,7 @@ config FB_VT8500
 	select FB_SYS_FILLRECT if (!FB_WMT_GE_ROPS)
 	select FB_SYS_COPYAREA if (!FB_WMT_GE_ROPS)
 	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
 	select FB_MODE_HELPERS
 	select VIDEOMODE_HELPERS
 	help
--- a/drivers/video/fbdev/vt8500lcdfb.c
+++ b/drivers/video/fbdev/vt8500lcdfb.c
@@ -241,6 +241,7 @@ static int vt8500lcd_blank(int blank, st
 
 static const struct fb_ops vt8500lcd_ops = {
 	.owner		= THIS_MODULE,
+	__FB_DEFAULT_DMAMEM_OPS_RDWR,
 	.fb_set_par	= vt8500lcd_set_par,
 	.fb_setcolreg	= vt8500lcd_setcolreg,
 	.fb_fillrect	= wmt_ge_fillrect,
@@ -250,6 +251,7 @@ static const struct fb_ops vt8500lcd_ops
 	.fb_ioctl	= vt8500lcd_ioctl,
 	.fb_pan_display	= vt8500lcd_pan_display,
 	.fb_blank	= vt8500lcd_blank,
+	// .fb_mmap needs DMA mmap
 };
 
 static irqreturn_t vt8500lcd_handle_irq(int irq, void *dev_id)
@@ -357,7 +359,7 @@ static int vt8500lcd_probe(struct platfo
 
 	fbi->fb.fix.smem_start	= fb_mem_phys;
 	fbi->fb.fix.smem_len	= fb_mem_len;
-	fbi->fb.screen_base	= fb_mem_virt;
+	fbi->fb.screen_buffer	= fb_mem_virt;
 
 	fbi->palette_size	= PAGE_ALIGN(512);
 	fbi->palette_cpu	= dma_alloc_coherent(&pdev->dev,


