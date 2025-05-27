Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9F6194A67;
	Tue, 27 May 2025 16:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365031; cv=none; b=KMm4lo0Os3YK76y9E5FTmT18tAPWZrqbnQNeAJrVAS5JoDqG+7U2/2HXr+n2WzqJE36EBe5M7ff9z7GahMqytGNakq0lUqgc9GBJsMo5QelX6MROb8ZfjqLG8UDBZGJ5NAAU4oFgYRR1my9X1DrfVeey/Dd6JbNhz/Zo7YXEmbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365031; c=relaxed/simple;
	bh=P7B6ezigUKg+siJepV9VmZlhCv2h8ThXvfS+f2He0JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ot+zHHXiIUSsaVAqiiiZoO7SIewf/AkVlzc1QzjjHDb7IXpgfWpalxWURNwgV1oCiW98UI/GAQ86rU833XSl7DqkQsgEUgOgNBNTaCl6f1ClOvaNWAPwpelVZQprU5eKNIsHqH9haOE4q9DjHsaHXSf/J8z6v4dfFzptSHuf5y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylxxtGqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylxxtGqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C030AC4CEE9;
	Tue, 27 May 2025 16:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365031;
	bh=P7B6ezigUKg+siJepV9VmZlhCv2h8ThXvfS+f2He0JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylxxtGqBNGzm9HWuHdjfSWKGr73a8Xg+anhCPIvY4cKa1G5EbqMKf9GTWNNdzzivX
	 J/D9h0bss7a+oU9L2Fe2k8y/EovVFTW7GwaT9Q7xZ3mGoY+ALVYPgoL839u0zDN/0H
	 4DX8TNrXiAK8Wd15+6FIJqjeaPak5daIIonWOrDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2d373c9936c00d7e120c@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 215/626] ALSA: seq: Improve data consistency at polling
Date: Tue, 27 May 2025 18:21:48 +0200
Message-ID: <20250527162453.758023963@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b74de9c0969fc..9e59a97f47472 100644
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
 
@@ -2583,8 +2582,6 @@ int snd_seq_kernel_client_write_poll(int clientid, struct file *file, poll_table
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



