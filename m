Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0A9267B05;
	Sat, 30 May 2026 17:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162120; cv=none; b=HOqheBH735A1ISaIVkH9DaIhDFCtsy3edQaq9GuF6iDTr9A1Z95vg6FNqcJzAkty24m6ml+dcJHnpUVQIMRpDYL5/hrd6U3gijxba62HBN+/4SwGuQZio/x0WjSl6nYEfDqqDcuBZU24fCl29GtglR3FP43y08ZngU6EqO1BOVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162120; c=relaxed/simple;
	bh=L7UTBSqG5D7B94lSlx/kYTs6lMctdCKJRbZ0lMLHPHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0pULuFEwoZbR+h3syCn7r/9jXQIiWEhikbp2ogcsXZwTNW7LycFpJ4mP0VsjFmJCOr92MECWH+xfMMCFg/Yqbiqwcpu7nKOpKvQHw2oIw66omoUCJ8KyBh8CtUIQ9nLQIp1zH93dSd79r5KBp/UmCehH9gzxZU2V99Xui+8ghE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecNY6khj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecNY6khj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4B01F00893;
	Sat, 30 May 2026 17:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162119;
	bh=wM5USvf6/cDNAR61Uwvh6FANurQ7Cy+J3pEEfaX7Q2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecNY6khjflxwzvRsG4wMFA/VsonlieYgSB7WnFlakwgQpVmXaph8oPulMT3G4mHgj
	 BYsXj0zKod0F6CLoPyT8FNPOT/fn2EwfHoaq8bh1mK+zTtFTM0V+UpSY4f94Qi6fa/
	 HnjHIQu5hIfnKgxSkqDHrG8CpBVx05p6PatFmIt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 797/969] ALSA: misc: Use guard() for spin locks
Date: Sat, 30 May 2026 18:05:21 +0200
Message-ID: <20260530160322.629968491@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b8e1684163ae52db90f428965bd9aaff7205c02e ]

Clean up the code using guard() for spin locks.

Merely code refactoring, and no behavior change.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250829151335.7342-20-tiwai@suse.de
Stable-dep-of: 5337213381df ("ALSA: core: Serialize deferred fasync state checks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/misc.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/sound/core/misc.c b/sound/core/misc.c
index 856edaa1dedbc..918d59a541c82 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -202,35 +202,30 @@ int snd_fasync_helper(int fd, struct file *file, int on,
 		INIT_LIST_HEAD(&fasync->list);
 	}
 
-	spin_lock_irq(&snd_fasync_lock);
-	if (*fasyncp) {
-		kfree(fasync);
-		fasync = *fasyncp;
-	} else {
-		if (!fasync) {
-			spin_unlock_irq(&snd_fasync_lock);
-			return 0;
+	scoped_guard(spinlock_irq, &snd_fasync_lock) {
+		if (*fasyncp) {
+			kfree(fasync);
+			fasync = *fasyncp;
+		} else {
+			if (!fasync)
+				return 0;
+			*fasyncp = fasync;
 		}
-		*fasyncp = fasync;
+		fasync->on = on;
 	}
-	fasync->on = on;
-	spin_unlock_irq(&snd_fasync_lock);
 	return fasync_helper(fd, file, on, &fasync->fasync);
 }
 EXPORT_SYMBOL_GPL(snd_fasync_helper);
 
 void snd_kill_fasync(struct snd_fasync *fasync, int signal, int poll)
 {
-	unsigned long flags;
-
 	if (!fasync || !fasync->on)
 		return;
-	spin_lock_irqsave(&snd_fasync_lock, flags);
+	guard(spinlock_irqsave)(&snd_fasync_lock);
 	fasync->signal = signal;
 	fasync->poll = poll;
 	list_move(&fasync->list, &snd_fasync_list);
 	schedule_work(&snd_fasync_work);
-	spin_unlock_irqrestore(&snd_fasync_lock, flags);
 }
 EXPORT_SYMBOL_GPL(snd_kill_fasync);
 
-- 
2.53.0



