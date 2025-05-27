Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E131AF0BB;
	Tue, 27 May 2025 17:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367039; cv=none; b=T1b9zm1fJUWB7goognV+7MktCVGJajo/vkNls7oM0wrKfpmHhYZV8wbSIUOpd5JY574T714z/RW55VkFAKgi3Z0nlseYWNQnAWi8YBFJz21/51Ep1ez3btWiEQGTwFJYN/oDYhAIojPW4lTI3oox5ycYeX+0cOEPIGyP5ryon5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367039; c=relaxed/simple;
	bh=7iqHLBoOMMofXmTzucxlBGep+qQ1o1mQsKmF7k9Z4yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VncN9mzePEpPV62aAW8JBzTBK9QyT00jtXpnjlhBaQaSFjOD3uLqnRzX0BDW1iBF7TEmy3gxMj7d1Fb1m6nX3kdBlv8jKGsHrwo5gmRGvlosgqoRI1oFOOB2B5mHLouxquZDyOXTF8buaNZ6f+Ha87HhHasT87Ve0JyTqDjwqEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZMzYqUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZMzYqUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D062C4CEE9;
	Tue, 27 May 2025 17:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367039;
	bh=7iqHLBoOMMofXmTzucxlBGep+qQ1o1mQsKmF7k9Z4yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZMzYqUYOzwXr8p0byv2Ce8mUxaUe8uIOHOGPoX1wOSmKcmu5j7J3KTYPPrsLErMt
	 OpBNiuq1s90DoTAnCUd+TWSCCbK4xZzC6BOGFChUQr5KAnsxHM936EIalgbuHdeTdt
	 SCzBmUxvIM7ju+JWurDqqnkgyBuR+m+Gh7ViUqh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2d373c9936c00d7e120c@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 259/783] ALSA: seq: Improve data consistency at polling
Date: Tue, 27 May 2025 18:20:56 +0200
Message-ID: <20250527162523.641588599@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit e3cd33ab17c33bd8f1a9df66ec83a15dd8f7afbb ]

snd_seq_poll() calls snd_seq_write_pool_allocated() that reads out a
field in client->pool object, while it can be updated concurrently via
ioctls, as reported by syzbot.  The data race itself is harmless, as
it's merely a poll() call, and the state is volatile.  OTOH, the read
out of poll object info from the caller side is fragile, and we can
leave it better in snd_seq_pool_poll_wait() alone.

A similar pattern is seen in snd_seq_kernel_client_write_poll(), too,
which is called from the OSS sequencer.

This patch drops the pool checks from the caller side and add the
pool->lock in snd_seq_pool_poll_wait() for better data consistency.

Reported-by: syzbot+2d373c9936c00d7e120c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/67c88903.050a0220.15b4b9.0028.GAE@google.com
Link: https://patch.msgid.link/20250307084246.29271-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c | 5 +----
 sound/core/seq/seq_memory.c    | 1 +
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 0ae01b85bb18c..198683a69a534 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -1164,8 +1164,7 @@ static __poll_t snd_seq_poll(struct file *file, poll_table * wait)
 	if (snd_seq_file_flags(file) & SNDRV_SEQ_LFLG_OUTPUT) {
 
 		/* check if data is available in the pool */
-		if (!snd_seq_write_pool_allocated(client) ||
-		    snd_seq_pool_poll_wait(client->pool, file, wait))
+		if (snd_seq_pool_poll_wait(client->pool, file, wait))
 			mask |= EPOLLOUT | EPOLLWRNORM;
 	}
 
@@ -2600,8 +2599,6 @@ int snd_seq_kernel_client_write_poll(int clientid, struct file *file, poll_table
 	if (client == NULL)
 		return -ENXIO;
 
-	if (! snd_seq_write_pool_allocated(client))
-		return 1;
 	if (snd_seq_pool_poll_wait(client->pool, file, wait))
 		return 1;
 	return 0;
diff --git a/sound/core/seq/seq_memory.c b/sound/core/seq/seq_memory.c
index 20155e3e87c6a..ccde0ca3d2082 100644
--- a/sound/core/seq/seq_memory.c
+++ b/sound/core/seq/seq_memory.c
@@ -427,6 +427,7 @@ int snd_seq_pool_poll_wait(struct snd_seq_pool *pool, struct file *file,
 			   poll_table *wait)
 {
 	poll_wait(file, &pool->output_sleep, wait);
+	guard(spinlock_irq)(&pool->lock);
 	return snd_seq_output_ok(pool);
 }
 
-- 
2.39.5



