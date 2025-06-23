Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEAC3FD4;
	Mon, 23 Jun 2025 21:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715277; cv=none; b=h/rmM6mHVKvk/S/t/gTkjLcV3FdNuf2a1baPcyPwfQemGLrLi648WhnkNpCSiigeDpJJ2IdvH4orYlFNS128sJkGPm+OPdecQg9sM7tbTE8NeIc6PCqzcQ8n78k9ImV5ce0t0c+joN15olMq/AX6/QQkrcA/uWC6WY59rOg6ukU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715277; c=relaxed/simple;
	bh=RSDFTBeg47yFIsa0eusvFfTA84MB8d5zWh5cTS7nxmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgUiR9N/D9FTmcAw9OO55u4OAF+dp7/dslxrkcRgxQtMk0YPzg3U9G7nl/sneIPzK3rflJrtF3+52Qe9TKWN2DrF81uAlSf49hndyR8O/hdgxf1Y/7tNNqRtv2Y7KkKvDiVfj1+v0Jzb7ctzHImlsGeLBHVZW421IlRLCF+7C64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSUklDp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSUklDp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0CEC4CEEA;
	Mon, 23 Jun 2025 21:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715277;
	bh=RSDFTBeg47yFIsa0eusvFfTA84MB8d5zWh5cTS7nxmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSUklDp/51jNhFygkWwRB1SHTlJwK/PSZOYMNpTN+oeExw1McVNSiRuvaNWtCpE/e
	 dN1RrnUsrNhtQ1uTQSWquTwuh82h6FxbrdX1ht+rSWNF8PuXdqiDOO+8ugsdsnHRzg
	 4gP99ZO2GLKc/nMCPRBCKO9i2qjd1KCL/xShZbEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 236/411] fbdev: Fix fb_set_var to prevent null-ptr-deref in fb_videomode_to_var
Date: Mon, 23 Jun 2025 15:06:20 +0200
Message-ID: <20250623130639.597274634@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@mt-integration.ru>

commit 05f6e183879d9785a3cdf2f08a498bc31b7a20aa upstream.

If fb_add_videomode() in fb_set_var() fails to allocate memory for
fb_videomode, later it may lead to a null-ptr dereference in
fb_videomode_to_var(), as the fb_info is registered while not having the
mode in modelist that is expected to be there, i.e. the one that is
described in fb_info->var.

================================================================
general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 PID: 30371 Comm: syz-executor.1 Not tainted 5.10.226-syzkaller #0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
RIP: 0010:fb_videomode_to_var+0x24/0x610 drivers/video/fbdev/core/modedb.c:901
Call Trace:
 display_to_var+0x3a/0x7c0 drivers/video/fbdev/core/fbcon.c:929
 fbcon_resize+0x3e2/0x8f0 drivers/video/fbdev/core/fbcon.c:2071
 resize_screen drivers/tty/vt/vt.c:1176 [inline]
 vc_do_resize+0x53a/0x1170 drivers/tty/vt/vt.c:1263
 fbcon_modechanged+0x3ac/0x6e0 drivers/video/fbdev/core/fbcon.c:2720
 fbcon_update_vcs+0x43/0x60 drivers/video/fbdev/core/fbcon.c:2776
 do_fb_ioctl+0x6d2/0x740 drivers/video/fbdev/core/fbmem.c:1128
 fb_ioctl+0xe7/0x150 drivers/video/fbdev/core/fbmem.c:1203
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x19a/0x210 fs/ioctl.c:739
 do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x67/0xd1
================================================================

The reason is that fb_info->var is being modified in fb_set_var(), and
then fb_videomode_to_var() is called. If it fails to add the mode to
fb_info->modelist, fb_set_var() returns error, but does not restore the
old value of fb_info->var. Restore fb_info->var on failure the same way
it is done earlier in the function.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbmem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1064,8 +1064,10 @@ fb_set_var(struct fb_info *info, struct
 	    !list_empty(&info->modelist))
 		ret = fb_add_videomode(&mode, &info->modelist);
 
-	if (ret)
+	if (ret) {
+		info->var = old_var;
 		return ret;
+	}
 
 	event.info = info;
 	event.data = &mode;


