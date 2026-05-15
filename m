Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1177F3FBB5C;
	Fri, 15 May 2026 16:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861663; cv=none; b=c7+dpMKOgY8Sfrgmf6ohcf/FNuyJzIUKA2v8ZTDwZo2nCFxom2OTBtvoKrcjSNfSGDs8WllbREu5LrmvtBKHlpSl9EM5jshv/oiS2wd+Jrb221csoNU2B4cY5XVcmmaaCOWrl0aakinW7Ey0HRc4mi00W8fF47IPZ9cXL1dXDJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861663; c=relaxed/simple;
	bh=eI/5iiYAif+2ANBLrKx7Kt6tSBLN+/Ewy4X3W7sI0FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+TYD8TDb7CHyIo/nXuDzHcx849ttFig13o0pIFSvHnLGAXXB2tPPNbdOOndXa1lWuh3RIu93pkxj+UODOv4bYyLgVu9QbGitce71Ik6gPUuH/E3Xyae6tUyv+mmCHPJm4DKFD/j3TwGL3iDw2USosSgs1kEIKmaoQ++pAG7k/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgWzzlaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgWzzlaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92413C2BCB3;
	Fri, 15 May 2026 16:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861662;
	bh=eI/5iiYAif+2ANBLrKx7Kt6tSBLN+/Ewy4X3W7sI0FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgWzzlaNtWFvlA9U5QEXqEMwpS44Wo6Zw2d7ySZ3tkJ0MLXX/Qs/QLqaKLUtcSyaR
	 P54DaHbtMq4YwgZUg0EHR4MgyWgqQvJkqEbxdZipNW3kXUlR47gtWye0vvDFc1k52D
	 sju7nBnq9IQDijxjKfmgUbZt2WQlyXxhTKdq9FCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 414/474] ALSA: misc: Use guard() for spin locks
Date: Fri, 15 May 2026 17:48:43 +0200
Message-ID: <20260515154724.017254633@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b8e1684163ae52db90f428965bd9aaff7205c02e ]

Clean up the code using guard() for spin locks.

Merely code refactoring, and no behavior change.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250829151335.7342-20-tiwai@suse.de
Stable-dep-of: 5337213381df ("ALSA: core: Serialize deferred fasync state checks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/misc.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -202,35 +202,30 @@ int snd_fasync_helper(int fd, struct fil
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
 


