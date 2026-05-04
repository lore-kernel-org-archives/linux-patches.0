Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7B43DDDD7;
	Mon,  4 May 2026 13:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903136; cv=none; b=VhIpNqEM/bzYwIhDur6MXnSNkFhsAHdnVlISLHmU1x48dEKWzbfk2nLWywiE7lDtdyMKJ6H+gC7heAHz+7Hc2kFAwgAvlUwC6bmQamNAep4AOLz8DGxtzETxWy4rHdQlqYO6Qdzlh0mrFNLPClkffuimAN7Xza5SHbmeuUWW0gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903136; c=relaxed/simple;
	bh=qG5TjjwQtH2S6ul6+cp2fxPfuL6fWUs2q242PpLAQHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXO8Gts2jITZtQkdwWz4xCq5jtOhLsPSMIJyEB2nFavjDWwp38JFN/fh8usq6gsS3SEf14FIeAvUzlOu5vMjBTd6hI3MAy9+JiwGq/+96I4zOcyi40YLoqyf35IqcYJtDL+wOsYLYnRLk6ETn8lXJ+/J5LaJ1mYZc1xMWWbB8wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/jiNSh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/jiNSh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7787C2BCB8;
	Mon,  4 May 2026 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903136;
	bh=qG5TjjwQtH2S6ul6+cp2fxPfuL6fWUs2q242PpLAQHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/jiNSh5DI4/irA9w/9bA/5Kaym+kTxthITr0EqtfmPMSZJfpIR/A85GTCjjrkauK
	 xwK/98i73/1xgfmLVHf7XiyfDcDgCBEV+PVOXekqGgSTVwhnGHyJmQYZqAMzekGRGD
	 p31qz/kIunB914r9VlDKA6LZh1V01wOjzajS0mrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jake Lamberson <lamberson.jake@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 117/307] ALSA: core: Fix potential data race at fasync handling
Date: Mon,  4 May 2026 15:50:02 +0200
Message-ID: <20260504135147.207472708@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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
@@ -158,7 +162,10 @@ void snd_fasync_free(struct snd_fasync *
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


