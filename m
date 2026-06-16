Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FBA3D75A4;
	Tue, 16 Jun 2026 18:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634478; cv=none; b=gVAojEBCpVtirR3jxFqpIpuqgTZeCSczVyetkujXPj9YpQKPxeUdd33CWq5qnNUHqIfxux1eSdoMIMBCk5g2y+FPK3b7XsKahXTHMDNDMnWCFb9BxZPeEpNB6KlVyecAs9nKfldEBupkQIsvM+Fj8qE0T885VFAKT0gznyBKPBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634478; c=relaxed/simple;
	bh=Kw8j68MUfaw1dNnx7oKFgQS6L/klvz65r5Z7sJ+UI4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBpl1e36DH+PV98P6EopZae0TFQY2MejPixqailhtcWwr+HQL+8GMmKAB1qENIYuHtMlk9KvYLTNWFhc1L/2F8eAviFDUMuXdiU60NeLzmhqfPOOPzvRA6rVjO2mwgjVZuyvH1+hDXr6bY3FcFWbQB/OdOSPcY78oGZYx8Xer/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zvg7P0YW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zvg7P0YW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA141F000E9;
	Tue, 16 Jun 2026 18:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634477;
	bh=DneBzZ0NbR0t6pixUfdpeUbsMRIyAe3WW43vAUxMAsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zvg7P0YWhOPvudAFh9L0jlqbRPtCr8+IpOaV1FJiPCMV5Tcsl1U+iJJyf3zyzB0aD
	 CRv8t1AsebqxhbAI88CU97XrYVAAImwUOIpwqilBU+39S935YSQoU1jL/Aj0xX08oN
	 3w0rXIhv4wSUu90lIhLKj25Gc8hSpS/URHuJeGdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Lamberson <lamberson.jake@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 273/411] ALSA: core: Fix potential data race at fasync handling
Date: Tue, 16 Jun 2026 20:28:31 +0530
Message-ID: <20260616145115.627507951@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 8146cd333d235ed32d48bb803fdf743472d7c783 ]

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
[ replaced scoped_guard(spinlock_irq, &snd_fasync_lock) with explicit spin_lock_irq()/spin_unlock_irq() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/misc.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -171,14 +171,18 @@ static LIST_HEAD(snd_fasync_list);
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
@@ -234,7 +238,11 @@ void snd_fasync_free(struct snd_fasync *
 {
 	if (!fasync)
 		return;
-	fasync->on = 0;
+
+	spin_lock_irq(&snd_fasync_lock);
+	list_del_init(&fasync->list);
+	spin_unlock_irq(&snd_fasync_lock);
+
 	flush_work(&snd_fasync_work);
 	kfree(fasync);
 }


