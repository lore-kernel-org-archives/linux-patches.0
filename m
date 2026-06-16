Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E05544CF4A;
	Tue, 16 Jun 2026 15:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623840; cv=none; b=CM15E3lS6FqulBF+KBcs7KzJHM38T88kavaV1lCNcKxzZL9R5GwEq9TWImt+tNbh3GXnCoqMHqj+QgXYpSBtqb4cdwGBlh/3qPPaVvpFNeQAHt1dtPPoMkIUiSsUY/KoT3DAzUwh/5cXTVwyY9+V17a3cN6npx4mSIpvbzzSBDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623840; c=relaxed/simple;
	bh=AmKiG+WrKuWEHQug467TihMt33MiPHj0if1TvO7H9KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1aQiYIdQEhGwLmCJELIOxVZTG9DrfELbTB+MwKQhWOuEzj+RHWJQ/RWu3E2oxaLtJqohqpj4Ed2GO9hFkfrrNFPYhr/jzAIO7GrICWJTUbmu2bzTum+OJ1GByAcrP1mlBicREIqvn/A3nRpgDPfIvTKe8LVyWJjjK2MCWxWcOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxDT080V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxDT080V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09FF1F000E9;
	Tue, 16 Jun 2026 15:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623838;
	bh=QO5kmEHJ8M1vCZaP7t6seg5PP8LwlzWy4SQezPGmFPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vxDT080Vo6qarG2OXIVfsNnc6nLrxIXk8HOInlNJ/ScoGpIAMVmib6fCAETm0jxF7
	 82rDruaGKi0mGFd1gtEXKX7bX4Qo1KhRchD9ToFETBbtn0gwhtg1yfwW6a9FuSKtOk
	 R0luPQfyswdfUVdc5Pdq8+VYNtWZM3jdcwmQdo14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 211/378] ALSA: timer: Forcibly close timer instances at closing
Date: Tue, 16 Jun 2026 20:27:22 +0530
Message-ID: <20260616145121.466667396@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit da3039e91d1f835874ed6e9a33ea19ee80c2cb92 upstream.

When snd_timer object is freed via snd_timer_free() and still pending
snd_timer_instance objects are assigned to the timer object, it tries
to unlink all instances and just set NULL to each ti->timer, then
releases the resources immediately.  The problem is, however, when
there are slave timer instances that are associated with a master
instance linked to this timer: namely, those slave instances still
point to the freed timer object although the master instance is
unlinked, which may lead to user-after-free.  The bug can be easily
triggered particularly when a new userspace-driven timers
(CONFIG_SND_UTIMER) is involved, since it can create and delete the
timer object via a simple file open/close, while the other
applications may keep accessing to that timer.

This patch is an attempt to paper over the problem above: now instead
of just unlinking, call snd_timer_close[_locked]() forcibly for each
pending timer instance, so that all assigned slave timer instances are
properly detached, too.  Since snd_timer_close() might be called later
by the driver that created that instance, the check of
SNDRV_TIMER_IFLG_DEAD is added at the beginning, too.

Reported-by: Kyle Zeng <kylebot@openai.com>
Tested-by: Kyle Zeng <kylebot@openai.com>
Fixes: 37745918e0e7 ("ALSA: timer: Introduce virtual userspace-driven timers")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260606161145.1933447-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/timer.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -422,6 +422,8 @@ static void snd_timer_close_locked(struc
 
 	if (timer) {
 		guard(spinlock_irq)(&timer->lock);
+		if (timeri->flags & SNDRV_TIMER_IFLG_DEAD)
+			return; /* already closed */
 		timeri->flags |= SNDRV_TIMER_IFLG_DEAD;
 	}
 
@@ -964,18 +966,18 @@ EXPORT_SYMBOL(snd_timer_new);
 
 static int snd_timer_free(struct snd_timer *timer)
 {
+	struct snd_timer_instance *ti, *n;
+
 	if (!timer)
 		return 0;
 
 	guard(mutex)(&register_mutex);
 	if (! list_empty(&timer->open_list_head)) {
-		struct list_head *p, *n;
-		struct snd_timer_instance *ti;
-		pr_warn("ALSA: timer %p is busy?\n", timer);
-		list_for_each_safe(p, n, &timer->open_list_head) {
-			list_del_init(p);
-			ti = list_entry(p, struct snd_timer_instance, open_list);
-			ti->timer = NULL;
+		list_for_each_entry_safe(ti, n, &timer->open_list_head, open_list) {
+			struct device *card_dev_to_put = NULL;
+
+			snd_timer_close_locked(ti, &card_dev_to_put);
+			put_device(card_dev_to_put);
 		}
 	}
 	list_del(&timer->device_list);


