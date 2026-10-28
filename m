Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215170;
	b=CNgpRuZCuDikuZFo13S5rsoAWEdx5WFX526nsHyE2Q5sZ9M3FMjGJ3YWP5ePeoKi405M
	 uhv1KmPoJDJgqdpAF1bOnrLntRIimuHi8RMXpPrLmGEQQ9FQllMiIenuZsMpoS2Gx0oIw
	 nvpcYo9hD5vvqmHeKDWVtNbm+gEiWIqdMAK+0KeuOj9mqNplxNL4hVf420RexXQUrC67A
	 MUCSBEoTx/Qb3Wl+L9zu4Q9dx2UuBQVQM8bAxQR6Ez4KPPZBKDJXZ2XWsA9rZKzFdz973
	 vRXaMLj5AV1XraWAVCSr4aW8idiypGx8Vng3+SRjd9/WJseSP01EiI3r3m4HOpkSItQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FBxwfhqVKL0vuc6Aft2NMoXLUypdtrDgr6CvkzCiMXo=;
	b=VYaeJMfv5tVatvTB0ckAxoCWLbdnpuMfPMT/iLn2xKv4JhqDjZ44FZ16W1ykAz4v3j7B
	 ZZOBHXsMhbpJoO4M4OUs8OVqW5Xkdc1CuzqNJ4WrWIv8lsnc6dDIPIC4/XLnAJbliaOkm
	 rHqv3HGVewM1yB7HSOf72SxJtDxcEkLU/daopykkYKoVHHPFR7VwDiWwebF+wQupH7Ycy
	 Sn5mcvEn+EVdTU5EYmnrSSR1Xy+ON5g/L/llffdtIu7G1l+37oU8Rv7RbfDkzw1325gqw
	 k3j+A+Vd35zUMFPGhE71vu2zbZ+mblwJfRoqoKoQcHNhVwjSXIqvO4GSYkbvOyyIKPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lH/J/gtO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983CA606A330;
	Wed, 28 Oct 2026 19:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lH/J/gtO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DE81F01825;
	Wed, 28 Oct 2026 19:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215170;
	bh=FBxwfhqVKL0vuc6Aft2NMoXLUypdtrDgr6CvkzCiMXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lH/J/gtOdOThPzCn1MAsNijHOhpMfb5V04jQTpGaru3cWVkQb2gLJ+QlG8uEbKEZS
	 sAWZLTyxdEFAfM2vWKiVK+QPfbB91fldDTXu0RIV8tC2Z1T0xI9Mx6dyJWMU+HkHwI
	 QGz/MS2pj2yI8JpEF4fHaNqQrfSYI8Pm3SUU/F8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+81c7c6b52649fd07299d@syzkaller.appspotmail.com,
	Ian Bridges <icb@fastmail.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1116/1887] fbdev: fix use-after-free in store_modes()
Date: Wed, 28 Oct 2026 17:53:32 +0100
Message-ID: <20261028170524.798494120@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 2c1c805c65fb7dc7524e20376d6987721e73a0b1 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbsysfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbsysfs.c b/drivers/video/fbdev/core/fbsysfs.c
index 4d7f63892dcc4..2d93adb18d8bd 100644
--- a/drivers/video/fbdev/core/fbsysfs.c
+++ b/drivers/video/fbdev/core/fbsysfs.c
@@ -194,8 +194,15 @@ static ssize_t store_modes(struct device *device,
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
-- 
2.53.0



