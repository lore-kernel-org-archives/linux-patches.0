Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8E4267B15;
	Tue,  8 Apr 2025 12:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114309; cv=none; b=p4nL3xA+L+WZRXqpe7FgkR99VdxF2PPQSnswtkdC5kQbsgzwDScii9eYt169IZG5B1EeGEB/dnkyrAcz8SgfUBGd7kBJabAbD0DhnhNXSpuIqOSOka2qzsmLDybetf7RYDVJZQcjZB5FaKIFJq1zCvF/tBQcWxTjm9hdqA86t1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114309; c=relaxed/simple;
	bh=DOoRYo37E3s8M+bsFUTcHsud68QyA1s+OLc3Nsq8hMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmlihUOP2ralvPsFTf9/fti4d98w+Q861xmA47JuhHkNMzz/QR1faQQBDwdJZdodM8etF6UwvUuFkNrJO5wSWOH/xcFkyqTZnrqu20iMjzt26CGIQ6VrmjOQi2fGDbiAI9xE4Bj+WABQp7pJy/eD85dlUZpv+TlZHcKYD61Q3l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDDRYD33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDDRYD33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36B5C4CEE5;
	Tue,  8 Apr 2025 12:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114309;
	bh=DOoRYo37E3s8M+bsFUTcHsud68QyA1s+OLc3Nsq8hMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDDRYD33s4k9BUsntWvnLk9qSVB0s7O+afEslbDvM4f/ePKYvpMg2SQqWuf4x3U0/
	 K8KR+sbHe7mr7uWMzlN3hnCBQSmQYPoN2MNFiEHcTFLmj9AoYUhxPW+pZPwbU9sliZ
	 G4iasYp9bVdvd7R8PFoyup+qtVCiDriDG0QR3xWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2b96f44164236dda0f3b@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 059/499] ALSA: timer: Dont take register_mutex with copy_from/to_user()
Date: Tue,  8 Apr 2025 12:44:31 +0200
Message-ID: <20250408104852.707737036@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 3424c8f53bc63c87712a7fc22dc13d0cc85fb0d6 ]

The infamous mmap_lock taken in copy_from/to_user() can be often
problematic when it's called inside another mutex, as they might lead
to deadlocks.

In the case of ALSA timer code, the bad pattern is with
guard(mutex)(&register_mutex) that covers copy_from/to_user() -- which
was mistakenly introduced at converting to guard(), and it had been
carefully worked around in the past.

This patch fixes those pieces simply by moving copy_from/to_user() out
of the register mutex lock again.

Fixes: 3923de04c817 ("ALSA: pcm: oss: Use guard() for setup")
Reported-by: syzbot+2b96f44164236dda0f3b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/67dd86c8.050a0220.25ae54.0059.GAE@google.com
Link: https://patch.msgid.link/20250321172653.14310-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/timer.c | 147 ++++++++++++++++++++++++---------------------
 1 file changed, 77 insertions(+), 70 deletions(-)

diff --git a/sound/core/timer.c b/sound/core/timer.c
index fbada79380f9e..d774b9b71ce23 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -1515,91 +1515,97 @@ static void snd_timer_user_copy_id(struct snd_timer_id *id, struct snd_timer *ti
 	id->subdevice = timer->tmr_subdevice;
 }
 
-static int snd_timer_user_next_device(struct snd_timer_id __user *_tid)
+static void get_next_device(struct snd_timer_id *id)
 {
-	struct snd_timer_id id;
 	struct snd_timer *timer;
 	struct list_head *p;
 
-	if (copy_from_user(&id, _tid, sizeof(id)))
-		return -EFAULT;
-	guard(mutex)(&register_mutex);
-	if (id.dev_class < 0) {		/* first item */
+	if (id->dev_class < 0) {		/* first item */
 		if (list_empty(&snd_timer_list))
-			snd_timer_user_zero_id(&id);
+			snd_timer_user_zero_id(id);
 		else {
 			timer = list_entry(snd_timer_list.next,
 					   struct snd_timer, device_list);
-			snd_timer_user_copy_id(&id, timer);
+			snd_timer_user_copy_id(id, timer);
 		}
 	} else {
-		switch (id.dev_class) {
+		switch (id->dev_class) {
 		case SNDRV_TIMER_CLASS_GLOBAL:
-			id.device = id.device < 0 ? 0 : id.device + 1;
+			id->device = id->device < 0 ? 0 : id->device + 1;
 			list_for_each(p, &snd_timer_list) {
 				timer = list_entry(p, struct snd_timer, device_list);
 				if (timer->tmr_class > SNDRV_TIMER_CLASS_GLOBAL) {
-					snd_timer_user_copy_id(&id, timer);
+					snd_timer_user_copy_id(id, timer);
 					break;
 				}
-				if (timer->tmr_device >= id.device) {
-					snd_timer_user_copy_id(&id, timer);
+				if (timer->tmr_device >= id->device) {
+					snd_timer_user_copy_id(id, timer);
 					break;
 				}
 			}
 			if (p == &snd_timer_list)
-				snd_timer_user_zero_id(&id);
+				snd_timer_user_zero_id(id);
 			break;
 		case SNDRV_TIMER_CLASS_CARD:
 		case SNDRV_TIMER_CLASS_PCM:
-			if (id.card < 0) {
-				id.card = 0;
+			if (id->card < 0) {
+				id->card = 0;
 			} else {
-				if (id.device < 0) {
-					id.device = 0;
+				if (id->device < 0) {
+					id->device = 0;
 				} else {
-					if (id.subdevice < 0)
-						id.subdevice = 0;
-					else if (id.subdevice < INT_MAX)
-						id.subdevice++;
+					if (id->subdevice < 0)
+						id->subdevice = 0;
+					else if (id->subdevice < INT_MAX)
+						id->subdevice++;
 				}
 			}
 			list_for_each(p, &snd_timer_list) {
 				timer = list_entry(p, struct snd_timer, device_list);
-				if (timer->tmr_class > id.dev_class) {
-					snd_timer_user_copy_id(&id, timer);
+				if (timer->tmr_class > id->dev_class) {
+					snd_timer_user_copy_id(id, timer);
 					break;
 				}
-				if (timer->tmr_class < id.dev_class)
+				if (timer->tmr_class < id->dev_class)
 					continue;
-				if (timer->card->number > id.card) {
-					snd_timer_user_copy_id(&id, timer);
+				if (timer->card->number > id->card) {
+					snd_timer_user_copy_id(id, timer);
 					break;
 				}
-				if (timer->card->number < id.card)
+				if (timer->card->number < id->card)
 					continue;
-				if (timer->tmr_device > id.device) {
-					snd_timer_user_copy_id(&id, timer);
+				if (timer->tmr_device > id->device) {
+					snd_timer_user_copy_id(id, timer);
 					break;
 				}
-				if (timer->tmr_device < id.device)
+				if (timer->tmr_device < id->device)
 					continue;
-				if (timer->tmr_subdevice > id.subdevice) {
-					snd_timer_user_copy_id(&id, timer);
+				if (timer->tmr_subdevice > id->subdevice) {
+					snd_timer_user_copy_id(id, timer);
 					break;
 				}
-				if (timer->tmr_subdevice < id.subdevice)
+				if (timer->tmr_subdevice < id->subdevice)
 					continue;
-				snd_timer_user_copy_id(&id, timer);
+				snd_timer_user_copy_id(id, timer);
 				break;
 			}
 			if (p == &snd_timer_list)
-				snd_timer_user_zero_id(&id);
+				snd_timer_user_zero_id(id);
 			break;
 		default:
-			snd_timer_user_zero_id(&id);
+			snd_timer_user_zero_id(id);
 		}
 	}
+}
+
+static int snd_timer_user_next_device(struct snd_timer_id __user *_tid)
+{
+	struct snd_timer_id id;
+
+	if (copy_from_user(&id, _tid, sizeof(id)))
+		return -EFAULT;
+	scoped_guard(mutex, &register_mutex)
+		get_next_device(&id);
 	if (copy_to_user(_tid, &id, sizeof(*_tid)))
 		return -EFAULT;
 	return 0;
@@ -1620,23 +1626,24 @@ static int snd_timer_user_ginfo(struct file *file,
 	tid = ginfo->tid;
 	memset(ginfo, 0, sizeof(*ginfo));
 	ginfo->tid = tid;
-	guard(mutex)(&register_mutex);
-	t = snd_timer_find(&tid);
-	if (!t)
-		return -ENODEV;
-	ginfo->card = t->card ? t->card->number : -1;
-	if (t->hw.flags & SNDRV_TIMER_HW_SLAVE)
-		ginfo->flags |= SNDRV_TIMER_FLG_SLAVE;
-	strscpy(ginfo->id, t->id, sizeof(ginfo->id));
-	strscpy(ginfo->name, t->name, sizeof(ginfo->name));
-	scoped_guard(spinlock_irq, &t->lock)
-		ginfo->resolution = snd_timer_hw_resolution(t);
-	if (t->hw.resolution_min > 0) {
-		ginfo->resolution_min = t->hw.resolution_min;
-		ginfo->resolution_max = t->hw.resolution_max;
-	}
-	list_for_each(p, &t->open_list_head) {
-		ginfo->clients++;
+	scoped_guard(mutex, &register_mutex) {
+		t = snd_timer_find(&tid);
+		if (!t)
+			return -ENODEV;
+		ginfo->card = t->card ? t->card->number : -1;
+		if (t->hw.flags & SNDRV_TIMER_HW_SLAVE)
+			ginfo->flags |= SNDRV_TIMER_FLG_SLAVE;
+		strscpy(ginfo->id, t->id, sizeof(ginfo->id));
+		strscpy(ginfo->name, t->name, sizeof(ginfo->name));
+		scoped_guard(spinlock_irq, &t->lock)
+			ginfo->resolution = snd_timer_hw_resolution(t);
+		if (t->hw.resolution_min > 0) {
+			ginfo->resolution_min = t->hw.resolution_min;
+			ginfo->resolution_max = t->hw.resolution_max;
+		}
+		list_for_each(p, &t->open_list_head) {
+			ginfo->clients++;
+		}
 	}
 	if (copy_to_user(_ginfo, ginfo, sizeof(*ginfo)))
 		return -EFAULT;
@@ -1674,31 +1681,31 @@ static int snd_timer_user_gstatus(struct file *file,
 	struct snd_timer_gstatus gstatus;
 	struct snd_timer_id tid;
 	struct snd_timer *t;
-	int err = 0;
 
 	if (copy_from_user(&gstatus, _gstatus, sizeof(gstatus)))
 		return -EFAULT;
 	tid = gstatus.tid;
 	memset(&gstatus, 0, sizeof(gstatus));
 	gstatus.tid = tid;
-	guard(mutex)(&register_mutex);
-	t = snd_timer_find(&tid);
-	if (t != NULL) {
-		guard(spinlock_irq)(&t->lock);
-		gstatus.resolution = snd_timer_hw_resolution(t);
-		if (t->hw.precise_resolution) {
-			t->hw.precise_resolution(t, &gstatus.resolution_num,
-						 &gstatus.resolution_den);
+	scoped_guard(mutex, &register_mutex) {
+		t = snd_timer_find(&tid);
+		if (t != NULL) {
+			guard(spinlock_irq)(&t->lock);
+			gstatus.resolution = snd_timer_hw_resolution(t);
+			if (t->hw.precise_resolution) {
+				t->hw.precise_resolution(t, &gstatus.resolution_num,
+							 &gstatus.resolution_den);
+			} else {
+				gstatus.resolution_num = gstatus.resolution;
+				gstatus.resolution_den = 1000000000uL;
+			}
 		} else {
-			gstatus.resolution_num = gstatus.resolution;
-			gstatus.resolution_den = 1000000000uL;
+			return -ENODEV;
 		}
-	} else {
-		err = -ENODEV;
 	}
-	if (err >= 0 && copy_to_user(_gstatus, &gstatus, sizeof(gstatus)))
-		err = -EFAULT;
-	return err;
+	if (copy_to_user(_gstatus, &gstatus, sizeof(gstatus)))
+		return -EFAULT;
+	return 0;
 }
 
 static int snd_timer_user_tselect(struct file *file,
-- 
2.39.5



