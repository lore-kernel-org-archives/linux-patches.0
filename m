Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9DE1FDA92;
	Tue, 11 Nov 2025 00:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822205; cv=none; b=gbw2Dd8zWJliUYAbfWLti14VtLAyX5xGUq3SY0Dqmt6ODp5iL5NotBAEtf62ZC+y7jKvHpdvHR3X9eqFnGc9zQ3/Dy/O9pvS1a4qqE3QZ6aGElBWRUrwLNx5N+2FgPeKkzdLe1Q+/8I2sPB2LssB7BGvXFacwX/vjcJYrRMOms8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822205; c=relaxed/simple;
	bh=izEj7Kw81kcgciXxAS/DZrQuLDMV7sdAiOg1UTGTv+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NV6EFOBOpMdshAADewVZwmE64a/e8w3WoNC70l4Bt+NfdBk/9A4lqayG8V2Yp+AI1B8znCnzqwvT1BkgqCNEPkatiqpUsf6I/FfmQE3iPCapDeAAluUGipOYiQO4UaTFfnwA9QP7VqMbUSq1T3B1crpG/fglFCttn/eRey8SnXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8DSrMso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8DSrMso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A33C113D0;
	Tue, 11 Nov 2025 00:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822205;
	bh=izEj7Kw81kcgciXxAS/DZrQuLDMV7sdAiOg1UTGTv+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8DSrMsoOfi98h/jUCPdRxJqnanVanToMaI6+Wm85eZpxcwLgD/uDTf3OAl1H6AUV
	 PtNSSOVu9rLe1AU6wq6BteUGuOKwgig1x0XwbBzd87xx3LH++YIKrhCPDRpSTcbSA6
	 35j0i/17QcX9cgZorWSsyfNleYrA+GqF3qXbgR4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 003/565] fbcon: Set fb_display[i]->mode to NULL when the mode is released
Date: Tue, 11 Nov 2025 09:37:39 +0900
Message-ID: <20251111004526.914022334@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Quanmin Yan <yanquanmin1@huawei.com>

commit a1f3058930745d2b938b6b4f5bd9630dc74b26b7 upstream.

Recently, we discovered the following issue through syzkaller:

BUG: KASAN: slab-use-after-free in fb_mode_is_equal+0x285/0x2f0
Read of size 4 at addr ff11000001b3c69c by task syz.xxx
...
Call Trace:
 <TASK>
 dump_stack_lvl+0xab/0xe0
 print_address_description.constprop.0+0x2c/0x390
 print_report+0xb9/0x280
 kasan_report+0xb8/0xf0
 fb_mode_is_equal+0x285/0x2f0
 fbcon_mode_deleted+0x129/0x180
 fb_set_var+0xe7f/0x11d0
 do_fb_ioctl+0x6a0/0x750
 fb_ioctl+0xe0/0x140
 __x64_sys_ioctl+0x193/0x210
 do_syscall_64+0x5f/0x9c0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Based on experimentation and analysis, during framebuffer unregistration,
only the memory of fb_info->modelist is freed, without setting the
corresponding fb_display[i]->mode to NULL for the freed modes. This leads
to UAF issues during subsequent accesses. Here's an example of reproduction
steps:
1. With /dev/fb0 already registered in the system, load a kernel module
   to register a new device /dev/fb1;
2. Set fb1's mode to the global fb_display[] array (via FBIOPUT_CON2FBMAP);
3. Switch console from fb to VGA (to allow normal rmmod of the ko);
4. Unload the kernel module, at this point fb1's modelist is freed, leaving
   a wild pointer in fb_display[];
5. Trigger the bug via system calls through fb0 attempting to delete a mode
   from fb0.

Add a check in do_unregister_framebuffer(): if the mode to be freed exists
in fb_display[], set the corresponding mode pointer to NULL.

Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbcon.c |   19 +++++++++++++++++++
 drivers/video/fbdev/core/fbmem.c |    1 +
 include/linux/fbcon.h            |    2 ++
 3 files changed, 22 insertions(+)

--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2805,6 +2805,25 @@ int fbcon_mode_deleted(struct fb_info *i
 	return found;
 }
 
+static void fbcon_delete_mode(struct fb_videomode *m)
+{
+	struct fbcon_display *p;
+
+	for (int i = first_fb_vc; i <= last_fb_vc; i++) {
+		p = &fb_display[i];
+		if (p->mode == m)
+			p->mode = NULL;
+	}
+}
+
+void fbcon_delete_modelist(struct list_head *head)
+{
+	struct fb_modelist *modelist;
+
+	list_for_each_entry(modelist, head, list)
+		fbcon_delete_mode(&modelist->mode);
+}
+
 #ifdef CONFIG_VT_HW_CONSOLE_BINDING
 static void fbcon_unbind(void)
 {
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -490,6 +490,7 @@ static void do_unregister_framebuffer(st
 		fb_info->pixmap.addr = NULL;
 	}
 
+	fbcon_delete_modelist(&fb_info->modelist);
 	fb_destroy_modelist(&fb_info->modelist);
 	registered_fb[fb_info->node] = NULL;
 	num_registered_fb--;
--- a/include/linux/fbcon.h
+++ b/include/linux/fbcon.h
@@ -11,6 +11,7 @@ void fbcon_suspended(struct fb_info *inf
 void fbcon_resumed(struct fb_info *info);
 int fbcon_mode_deleted(struct fb_info *info,
 		       struct fb_videomode *mode);
+void fbcon_delete_modelist(struct list_head *head);
 void fbcon_new_modelist(struct fb_info *info);
 void fbcon_get_requirement(struct fb_info *info,
 			   struct fb_blit_caps *caps);
@@ -31,6 +32,7 @@ static inline void fbcon_suspended(struc
 static inline void fbcon_resumed(struct fb_info *info) {}
 static inline int fbcon_mode_deleted(struct fb_info *info,
 				     struct fb_videomode *mode) { return 0; }
+static inline void fbcon_delete_modelist(struct list_head *head) {}
 static inline void fbcon_new_modelist(struct fb_info *info) {}
 static inline void fbcon_get_requirement(struct fb_info *info,
 					 struct fb_blit_caps *caps) {}


