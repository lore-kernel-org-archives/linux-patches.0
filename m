Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0D6315785;
	Mon,  4 May 2026 14:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904527; cv=none; b=eQk/kymvDjwXfOCWyEZO+umYZfnBNIc8aFCFQhnMyblVEvNehHdpKvVC4D7mF9izFgrDDmXiqXVWcPFlE32Bmowq3qVskLKaMFgtfyYYgJ1NBOfiGLNThXVgD9+fZ3sRTwXFSOQgap/XqezqOcbdXRe6559M0xrtQ4rJHNEqoDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904527; c=relaxed/simple;
	bh=9i6oaUeWIgHdl557BUdgaYMHVLDn7m4K7XzVkxNtylo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzUsUaBnTj5AKaRUxOHPqaO6cecr4FMq5RryxK1eFk9GObjiLG5Jge3EUyBHNrSTKtenZxpg+YzK2pLVYM6EcVeWPKTEU9cQ9zYnUMVlctbwYbWOt92pCVTA+PCSWg2Nmf3iMwjgZw1s4YIiohoiQmY1nJEG2nn6AMn7n/d9AJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DShm5Syp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DShm5Syp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151EDC2BCB8;
	Mon,  4 May 2026 14:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904527;
	bh=9i6oaUeWIgHdl557BUdgaYMHVLDn7m4K7XzVkxNtylo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DShm5SypiydcUBUfKUZ57iODJ8tNHpsm4gCUN1grG4xM4LYNcdMjdHAjKWt7NSgBc
	 3HmtGNuEWYNbK15KV2mzE/lH6Ai0MkX0QqVOciqdSVKMssyx3H/ZSNw1bsTVkLD09A
	 eFRnTtukRTt7KdtCkzITR4fIylj2M72gOjIT6Gr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Lamberson <lamberson.jake@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 074/215] ALSA: core: Fix potential data race at fasync handling
Date: Mon,  4 May 2026 15:51:33 +0200
Message-ID: <20260504135132.870298758@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 8146cd333d235ed32d48bb803fdf743472d7c783 upstream.

In snd_fasync_work_fn(), which is the offload work for traversing and
processing the pending fasync list, the call of kill_fasync() is done
outside the snd_fasync_lock for avoiding deadlocks.  The problem is
that its the references of fasync->on, fasync->signal and fasync->poll
are done there also outside the lock.  Since these may be modified by
snd_kill_fasync() call concurrently from other process, inconsistent
values might be passed to kill_fasync().  Although there shouldn't be
critical UAF, it's still better to be addressed.

This patch moves the kill_fasync() argument evaluations inside the
snd_fasync_lock for avoiding the data races above.  The handling in
fasync->on flag is optimized in the loop to skip directly.

Also, for more clarity, snd_fasync_free() takes the lock and unlink
the pending entry more directly instead of clearing fasync->on flag.

Reported-by: Jake Lamberson <lamberson.jake@gmail.com>
Fixes: ef34a0ae7a26 ("ALSA: core: Add async signal helpers")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260420061721.3253644-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/misc.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -100,14 +100,18 @@ static LIST_HEAD(snd_fasync_list);
 static void snd_fasync_work_fn(struct work_struct *work)
 {
 	struct snd_fasync *fasync;
+	int signal, poll;
 
 	spin_lock_irq(&snd_fasync_lock);
 	while (!list_empty(&snd_fasync_list)) {
 		fasync = list_first_entry(&snd_fasync_list, struct snd_fasync, list);
 		list_del_init(&fasync->list);
+		if (!fasync->on)
+			continue;
+		signal = fasync->signal;
+		poll = fasync->poll;
 		spin_unlock_irq(&snd_fasync_lock);
-		if (fasync->on)
-			kill_fasync(&fasync->fasync, fasync->signal, fasync->poll);
+		kill_fasync(&fasync->fasync, signal, poll);
 		spin_lock_irq(&snd_fasync_lock);
 	}
 	spin_unlock_irq(&snd_fasync_lock);
@@ -163,7 +167,10 @@ void snd_fasync_free(struct snd_fasync *
 {
 	if (!fasync)
 		return;
-	fasync->on = 0;
+
+	scoped_guard(spinlock_irq, &snd_fasync_lock)
+		list_del_init(&fasync->list);
+
 	flush_work(&snd_fasync_work);
 	kfree(fasync);
 }


