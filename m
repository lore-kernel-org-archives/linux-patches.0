Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72252745E;
	Fri, 21 Nov 2025 13:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732154; cv=none; b=asSd9XRhKjast903RHWKMI0fq5jB5GgvWhBDjxR4doka7hI9808ZUpF02+MjiibH96q+2S9VzBgF8hLDUTzw4SnWH9U1mnMDdLTQcaAyv6iluNjDBydfIezRjR7mhP4ynfqozdYl0v90LVzjg8yRBkTyJ+EBi+WJOiVuyXF9v6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732154; c=relaxed/simple;
	bh=5nENHSDtuqOLH+C6ZSH4bqBYH1xCuRc/AxXpS4rfIlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hm9eT2pbDoYceyS5IJl2UJ0eHVf+O2DNqdpCJhAB1GpOAvBomBgl5f3ugXl37vEhjlYDWH7smQ9Iw/IP7aJW3rSsO1LaeKZcFiBWAKp9q5fNYQ8yKWBQhl3B8CdecW6gvsm8Fd349mberg2PXlcBYDR98ZWVwPeQwgDpYnx0txw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6HCnO0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6HCnO0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58824C4CEF1;
	Fri, 21 Nov 2025 13:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732154;
	bh=5nENHSDtuqOLH+C6ZSH4bqBYH1xCuRc/AxXpS4rfIlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6HCnO0iNxh2RPB1osm0akSS5vvHnrl/h1/x1v4CWkTOS27Af6W77UcyiC87otwKN
	 YEF3qzEhjzePW7MJ0Rbu0fPUuwIZHVhIIB/K7D++CDu8txFiIOM29zccM5cBNbx5Fi
	 rutjN2oISImm+Y8rb1IZA8JxIAgaSLCFI4q8VmzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 003/529] fbcon: Set fb_display[i]->mode to NULL when the mode is released
Date: Fri, 21 Nov 2025 14:05:02 +0100
Message-ID: <20251121130231.116119916@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
@@ -2824,6 +2824,25 @@ int fbcon_mode_deleted(struct fb_info *i
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
@@ -1030,6 +1030,7 @@ static void do_unregister_framebuffer(st
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


