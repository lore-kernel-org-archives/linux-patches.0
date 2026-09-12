Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8612C4BEE5E;
	Sat, 12 Sep 2026 16:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231494; cv=none; b=O6h3SVLJ04tC5zKKUGphBkzvfUlZ6EkQIoLtgRKa02k5XO4s6s8gzRb/kmRy9PsKPMP+m4TicOy4X8Ro35Lfo4hUhBVQsw3HQdxHBNVlh/G2IYOTaom4iU19Zh0TjxGU9jYTO37l04Wb8jpWoaS97wZr0UHtWYhMUQRdF+IkvYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231494; c=relaxed/simple;
	bh=wfLkD+Kw2SFow+LQD7OdRxalJv1IQfSOLp6HcC8C69I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVeTh3rQ3bVmQ/M9kSdhjXbjdZ5xQDLJEc1n82v5n9nFYWh14JHpK9VgvBoQDpSOeutPgGUai/4L80+bIUE+mLs0WzyQeFgZZROZKjKU/OH5ZCekSyXUjAVH1kOMS7Sjm5P0+1jO7OnAY3aOJxnYjUsQDcFqLCsZZX1uIfb0xc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmUem7/M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmUem7/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34141F000FF;
	Sat, 12 Sep 2026 16:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231493;
	bh=N2/19d1lplUdMa7v0X9/VIQzLpK5DNPPNvVz8kk+ZnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nmUem7/Mk2HA2DT7dsaZGrvDNpBHdlQ6k2cfbJ1PNpR1kyUD8AtMCofEoVRlxftme
	 sto3xDz2MJQxeDmkKkcaDG2gUowi6FaWl6GfaK9i3CyiJ8XOEKKcLlFfbum3FuJ1kc
	 aG7GrusKgoN3TJKcCi4tp846js4TdfqFz8HneGto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7061d72c26b7daebe2b4@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1008/1191] ALSA: core: Fix use-after-free in snd_card_do_free()
Date: Sat, 12 Sep 2026 09:02:16 +0200
Message-ID: <20260912065610.835801956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Nogikh <nogikh@google.com>

[ Upstream commit 5ae1a690c522fea2900ff56c8c2ace7b059f5e04 ]

A use-after-free was detected in snd_card_do_free() when a sound card
managed by devres is unbound while a user-space application still holds an
open file descriptor.

For managed cards, the memory is allocated using devres_alloc(), and its
release function is set to __snd_card_release(), which calls
snd_card_free(). When the device is unbound, the unbind thread calls
snd_card_free(), which drops a reference to the card's device. If the user
thread still has an open file descriptor, the reference count does not
reach zero, and the unbind thread blocks on wait_for_completion(&released).

When the user thread closes the file descriptor, it drops the final
reference, invoking the device release callback release_card_device(),
which calls snd_card_do_free(). snd_card_do_free() performs cleanup and
calls complete(card->release_completion). This wakes up the unbind thread,
which returns from snd_card_free() and __snd_card_release(). The devres
core then immediately frees the memory block containing the snd_card
structure.

Meanwhile, the user thread continues execution in snd_card_do_free() and
evaluates `if (!card->managed)`. It reads the `managed` boolean from the
snd_card structure that was just freed by the unbind thread, triggering a
KASAN use-after-free.

Fix this by caching the value of card->managed in a local variable before
calling complete(). This ensures that the card pointer is not dereferenced
after the unbind thread has been woken up and potentially freed the card.

BUG: KASAN: use-after-free in snd_card_do_free sound/core/init.c:604
[inline]
BUG: KASAN: use-after-free in release_card_device+0x1ab/0x1b0
sound/core/init.c:153
Read of size 1 at addr ffff8881912ec909 by task syz-executor130/5857

Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 snd_card_do_free sound/core/init.c:604 [inline]
 release_card_device+0x1ab/0x1b0 sound/core/init.c:153
 device_release+0xc4/0x1f0 drivers/base/core.c:-1
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x222/0x550 lib/kobject.c:737
 snd_card_file_remove+0x331/0x390 sound/core/init.c:1125
 snd_pcm_release+0x12c/0x160 sound/core/pcm_native.c:2986
 __fput+0x418/0xa50 fs/file_table.c:512
 fput_close_sync+0x11f/0x240 fs/file_table.c:617
 __do_sys_close fs/open.c:1511 [inline]
 __se_sys_close fs/open.c:1496 [inline]
 __x64_sys_close+0x7e/0x110 fs/open.c:1496
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Fixes: e8ad415b7a55 ("ALSA: core: Add managed card creation")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+7061d72c26b7daebe2b4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7061d72c26b7daebe2b4
Link: https://syzkaller.appspot.com/ai_job?id=24752a23-f0b6-49c1-bf20-4fa89c2e7eb2
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Link: https://patch.msgid.link/02042186-27b7-42a9-b64e-f93ce8fbe05a@mail.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index 4b95d885a7dcf..2cb554b393fce 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -595,6 +595,8 @@ EXPORT_SYMBOL_GPL(snd_card_disconnect_sync);
 
 static int snd_card_do_free(struct snd_card *card)
 {
+	bool managed = card->managed;
+
 	card->releasing = true;
 #if IS_ENABLED(CONFIG_SND_MIXER_OSS)
 	if (snd_mixer_oss_notify_callback)
@@ -609,7 +611,7 @@ static int snd_card_do_free(struct snd_card *card)
 	}
 	if (card->release_completion)
 		complete(card->release_completion);
-	if (!card->managed)
+	if (!managed)
 		kfree(card);
 	return 0;
 }
-- 
2.53.0



