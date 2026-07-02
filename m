Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B556F23EAAD;
	Thu,  2 Jul 2026 16:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011271; cv=none; b=Pjhrui1eaEQvXqyQQxTfed6ILGHUsX0R8a99lgtb11loZxWwltGzhh3HpifyJQERRcITHBHhKQj0gkSFZsZFxvT/ZidAT9irkXGB4+R8FWyU+0mOUXgbEObW7EpeNnweSwfXaUgTHy004rvwLSUQK2ZbNsnCRSJB6bPDn5GcWJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011271; c=relaxed/simple;
	bh=diQusmUA+JUKv6GdKA23md/UAEve72Kvd4KOdBILcmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pk9roLshVeuzEt9nGfemDDWKIYqy4oWUIsGWKN/EhAKpfbN9iN4rvIiFDWx4WBE1X/z94H7M+1JtTNfF2Gi/oQPhCP25D5k8eE+Jnl8hsdKrQrtAFt7gs12/Mpz8o6MKps4HUV8LDzbGlz1p7lXiypE/0Le78yGaUuD8tovCjtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6f5QihN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6f5QihN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F651F000E9;
	Thu,  2 Jul 2026 16:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011270;
	bh=q8fFru/iKUVy2HlL9V+ZQ3kWthiVDHKnWJsUKwObrME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P6f5QihNc0ByfKZYxZt7kvm0l+BrTKY3MT7yPC8z/uzBzRZEenYlyHE9xqoGpzbYl
	 Sbru3ysv1dCD03VLhT0OurfV2WXhv6PywrxHeAXoHtFnDLdsmsnmr9T4VVmnrfS+yM
	 DQ6K4NZ0aJMyzs7ttYnXaeSCs0VXCjDgkcLjnm8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+81c7c6b52649fd07299d@syzkaller.appspotmail.com,
	Ian Bridges <icb@fastmail.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 043/108] fbdev: fix use-after-free in store_modes()
Date: Thu,  2 Jul 2026 18:20:40 +0200
Message-ID: <20260702155113.000180740@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

commit 2c1c805c65fb7dc7524e20376d6987721e73a0b1 upstream.

store_modes() replaces a framebuffer's modelist with modes from userspace.
On success it frees the old modelist with fb_destroy_modelist(). Two
fields still point into that freed list.

One pointer is fb_display[i].mode, the mode a console is using.
fbcon_new_modelist() moves these pointers to the new list. It only does so
for consoles still mapped to the framebuffer. An unmapped console is
skipped and keeps its stale pointer. Unbinding fbcon, for example, sets
con2fb_map[i] to -1 but leaves fb_display[i].mode set. An
FBIOPUT_VSCREENINFO ioctl with FB_ACTIVATE_INV_MODE later reaches
fbcon_mode_deleted(). That function reads the stale fb_display[i].mode
through fb_mode_is_equal(). The read is a use-after-free.

The other pointer is fb_info->mode, the current mode. It is set through
the mode sysfs attribute. store_modes() does not update fb_info->mode, so
it is left pointing into the freed list. show_mode(), the attribute's read
handler, dereferences the stale fb_info->mode through mode_string(). The
read is a use-after-free.

Clear both pointers before freeing the list. Commit a1f305893074 ("fbcon:
Set fb_display[i]->mode to NULL when the mode is released") added the
helper fbcon_delete_modelist(). It clears every fb_display[i].mode that
points into a given list. So far it is called only from the unregister
path. Call it from store_modes() too, and set fb_info->mode to NULL.

Reported-by: syzbot+81c7c6b52649fd07299d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=81c7c6b52649fd07299d
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/ajjoDhAi2y4ArSlz@dev/
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fbsysfs.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/fbsysfs.c
+++ b/drivers/video/fbdev/core/fbsysfs.c
@@ -11,6 +11,7 @@
 #include <linux/major.h>
 
 #include "fb_internal.h"
+#include "fbcon.h"
 
 static int activate(struct fb_info *fb_info, struct fb_var_screeninfo *var)
 {
@@ -111,8 +112,15 @@ static ssize_t store_modes(struct device
 	if (fb_new_modelist(fb_info)) {
 		fb_destroy_modelist(&fb_info->modelist);
 		list_splice(&old_list, &fb_info->modelist);
-	} else
+	} else {
+		/*
+		 * fb_display[i].mode and fb_info->mode both point into the old
+		 * list. Clear them before it is freed.
+		 */
+		fbcon_delete_modelist(&old_list);
+		fb_info->mode = NULL;
 		fb_destroy_modelist(&old_list);
+	}
 
 	unlock_fb_info(fb_info);
 	console_unlock();


