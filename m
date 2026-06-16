Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B6643E4BB;
	Tue, 16 Jun 2026 15:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623083; cv=none; b=WC93oGkshQlltA2vy/xODJraodusM3nnQLxUEe9tPLM3zHIPs2zAlVKPclDVK4u2qJWuz9WCwvmbL9mTT0qRtE0sXq/gxrcIfhq9sNHo3f4RIFctW92QLDA7VdMNdaivKCxYZNWsIY1m2O7skA2Qg1dJBbn9Ql4BBlTIaTqoa/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623083; c=relaxed/simple;
	bh=RAE7hLRjDGIUq8mnTGDdMGQ+RX84hDpdqalzj10o8sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iy0/yxgW+2xBKXaHXrWTPhXzpNh8wM4dE50kpDhULXfCZiUeGWMCS+t6CYmuPYvey9QRRV8EdL+Gj5nQ3cSrDcJpjj5VSNaKqnfJtFbBU2JjvLGzv/CK/eXpp0yVKCrU2CF9s4U8SJdW2WsBCtRqKc5gmBi9Wk+TOyoNGdkpAS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AU6GWwUt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AU6GWwUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B75C1F000E9;
	Tue, 16 Jun 2026 15:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623082;
	bh=QFs1Rd7VpFbdFe9cvwD4zKdaH56/RgG1kDFFvxnoKKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AU6GWwUt1Oh2TQ+bEs0BDNOiFsZeK/VAOon8SnJqAKVltnjz/Fc1ufeMONtIZZY0l
	 jy/KNSUeVtV0zgMCa7+21yntFDRntu97f3tALWbS6axifsFnrJlbGyi09E0ZZCe9Fa
	 DZ50QW0Rzmjp+k/V1yv6gIq47GX6CFglHbVcenJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 085/378] ALSA: PCM: Fix wait queue list corruption in snd_pcm_drain() on linked streams
Date: Tue, 16 Jun 2026 20:25:16 +0530
Message-ID: <20260616145114.722843392@linuxfoundation.org>
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

From: Ji'an Zhou <eilaimemedsnaimel@gmail.com>

[ Upstream commit 88fe2e3658726cb21ff2dcf9770bf672f9b9d31b ]

snd_pcm_drain() uses init_waitqueue_entry which does not clear
entry.prev/next, and add_wait_queue with a conditional
remove_wait_queue that is skipped when to_check is no longer
in the group after concurrent UNLINK.  The orphaned wait entry
remains on the unlinked substream sleep queue.  On the next
drain iteration, add_wait_queue adds the entry to a new queue
while still linked on the old one, corrupting both lists.  A
subsequent wake_up dereferences NULL at the func pointer
(mapped from the spinlock at offset 0 of the misinterpreted
wait_queue_head_t), causing a kernel panic.

Replace init_waitqueue_entry/add_wait_queue/conditional
remove_wait_queue with init_wait_entry/prepare_to_wait/
finish_wait.  init_wait_entry clears prev/next via
INIT_LIST_HEAD on each iteration and sets
autoremove_wake_function which auto-removes the entry on
wake-up.  finish_wait safely handles both the already-removed
and still-queued cases.

Fixes: 9b1dbd69ba6f ("ALSA: pcm: fix use-after-free on linked stream runtime in snd_pcm_drain")
Signed-off-by: Ji'an Zhou <eilaimemedsnaimel@gmail.com>
Link: https://patch.msgid.link/20260604142559.3840881-1-eilaimemedsnaimel@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 5a64453da7283a..6fd479d135a4d1 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2176,9 +2176,8 @@ static int snd_pcm_drain(struct snd_pcm_substream *substream,
 		drain_no_period_wakeup = to_check->no_period_wakeup;
 		drain_rate = to_check->rate;
 		drain_bufsz = to_check->buffer_size;
-		init_waitqueue_entry(&wait, current);
-		set_current_state(TASK_INTERRUPTIBLE);
-		add_wait_queue(&to_check->sleep, &wait);
+		init_wait_entry(&wait, 0);
+		prepare_to_wait(&to_check->sleep, &wait, TASK_INTERRUPTIBLE);
 		snd_pcm_stream_unlock_irq(substream);
 		if (drain_no_period_wakeup)
 			tout = MAX_SCHEDULE_TIMEOUT;
@@ -2196,7 +2195,7 @@ static int snd_pcm_drain(struct snd_pcm_substream *substream,
 		group = snd_pcm_stream_group_ref(substream);
 		snd_pcm_group_for_each_entry(s, substream) {
 			if (s->runtime == to_check) {
-				remove_wait_queue(&to_check->sleep, &wait);
+				finish_wait(&to_check->sleep, &wait);
 				break;
 			}
 		}
-- 
2.53.0



