Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A77318EC1;
	Thu,  2 Jul 2026 16:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010528; cv=none; b=Y8XX663mXrL1IixBXpaXtS4fVL9yqJ0WcuDY3CvrS8uMkADloKu3fiDt6Z4luHY1b75JJUJrY/63ez+r4qn5QRIuKfl53TOJsCQXlHpgTj3X4LNBXKRrN0mBQz3L3CAyDvG7ZL+r+XimQUt1Ov4M3+fTs2xsCNq9x2nIJHFW7Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010528; c=relaxed/simple;
	bh=wGX3h7KvilYOoCB9u/zYiktWodWQI+F89Sv+gWz1cIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXzEJv2/yvEJW/6ITX88xX8RXnIJogPxAjqInoosnQ6rM2S8KZq/Nk7UpmlodDjpw3ayyl9vK9t1BNGniw4IB06/YnA9RPYxr8sKPsvG/b6xGKq7spEqXvsfdPHmzY7l/xqUm6kL4xggjLtV60o8txmobVuzsqrOYPz7bUESQWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxO8S1Jr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxO8S1Jr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C0E1F000E9;
	Thu,  2 Jul 2026 16:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010527;
	bh=Crd5PlLOZuwSWmhlVn9lI5z348M42Rh6SJ+lcisgEN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oxO8S1JrmbD7vp+PSk2Swlmg0zGZKgvrDO9QyHrvlDjiybuOaa38aeSbScrF+rB59
	 gNVFa+UCkkyXD8ZsekLbr0mv/4qKfUOuny71fHX8alFqRLAgnMkau+IG5Wos3Tum4y
	 gCRzvwi81Zixb3Gz5hgyOTldIwOXMqwl4vR6Tm/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+81c7c6b52649fd07299d@syzkaller.appspotmail.com,
	Ian Bridges <icb@fastmail.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 142/204] fbdev: fix use-after-free in store_modes()
Date: Thu,  2 Jul 2026 18:19:59 +0200
Message-ID: <20260702155121.634481387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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
 
 #define FB_SYSFS_FLAG_ATTR 1
 
@@ -113,8 +114,15 @@ static ssize_t store_modes(struct device
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


