Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B239B251791;
	Mon, 23 Jun 2025 13:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685407; cv=none; b=Jxj9+Z69sLtPxmilT9j+NIoc8H0I94xmkwF5CelsYxl+HoEcU1wtKpomVKKsYjgi+XbixshZJgqDkP4xJTAtu3D5Z+Nj5Dj3jIynt3uk6q/eJUcnZbTijfJA7POMdUkyZPYOqXUm5+VPYyWmmeFIO4NsA5S05k7JSKLyWDC2nVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685407; c=relaxed/simple;
	bh=rXxSIhTqiMFwDjKvTBX261kbzxGZZpFOsT+w6WMo5U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etOOwsPp14k3WDvlKmKLz8tv5n/pdEKwdDDbfOgCZk/78z1B9nRCyISgLv74gQ8dLMk1BmHnpH65LlH6b7BAioy558+r5dFRoBBZA9IU3pXEXriynqxplu7YovuJjuYGy3vVR/YSBewej4N4zsq/tBYmmmenomoI5oA1no0E7Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5XF10UF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5XF10UF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E66C4CEEA;
	Mon, 23 Jun 2025 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685407;
	bh=rXxSIhTqiMFwDjKvTBX261kbzxGZZpFOsT+w6WMo5U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5XF10UFJCNh4JtmT9H53W5zxdM9NEXbWVZJWIbQPErCb82O1zOohT1wQM1g0Q/tD
	 5FxfAeOGy7nFjQpGB/K4iywQctIFI+LgSSKh6WJs0r+jVtulkQWWIG+FrWrFFHEeb3
	 bpHSMhdJcTZgUfZmfyqmnGF3+b5wGCJDl3j26S6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 118/222] fbdev: Fix fb_set_var to prevent null-ptr-deref in fb_videomode_to_var
Date: Mon, 23 Jun 2025 15:07:33 +0200
Message-ID: <20250623130615.649372942@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1057,8 +1057,10 @@ fb_set_var(struct fb_info *info, struct
 	    !list_empty(&info->modelist))
 		ret = fb_add_videomode(&mode, &info->modelist);
 
-	if (ret)
+	if (ret) {
+		info->var = old_var;
 		return ret;
+	}
 
 	event.info = info;
 	event.data = &mode;


