Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1D03D091A;
	Tue, 16 Jun 2026 18:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635986; cv=none; b=OkaSRci/FMRfTbM+44xOkT6GWn5As+n7GUW9fD6jj+TZF/4L9OduV46+bLsDmIJF4U6QYgadxlj7IlDqoBFrJNFJjlO1eCBczZSc9xQPqw34NWT4OCWzstAkLFWN7eBU3L61chRAK76oFtrQvcU2TDiDulorGWXBPM+psXDDGvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635986; c=relaxed/simple;
	bh=ukQ1QFAhgTy6L/9lnDDK4m+4DgeafPzZAcC2huLjTOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgQa+AtgyQYsDqnRH2QxZX4Ag+x8jCF/79PiK/RzdYSawvtIupHV4ETigd+bu8tMUv3hh3HPRzK+jvKGGdazDwPG73gnJFbGGbYufj5wUp9XBe/YZIZNqtOlkhUBoBTDXn+k358N3PyzY1AdsBjhPFKXrTGcjUlfzPk7lr+8Ank=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJYW5DIJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJYW5DIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DE01F000E9;
	Tue, 16 Jun 2026 18:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635985;
	bh=NvSh5VYREawBYFYjpIOsXujrzt0YG2KIqpaBibBLU7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJYW5DIJYQI2wMi1yaWMZWILX2vPI1D6458HbIHSo1N9518/6Huzfk291b+P+NCca
	 7XK2qcdiGeQCrM61ywp33gn23ZsTn1oyg7Uh01slNHgzAqw9kr7PrZy4eOZM4FFmKT
	 2dGdZPLTK0rCf5nax/kysVib6Q23KOh8+dpYudDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Zhou <eilaimemedsnaimel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 152/342] ALSA: PCM: Fix wait queue list corruption in snd_pcm_drain() on linked streams
Date: Tue, 16 Jun 2026 20:27:28 +0530
Message-ID: <20260616145055.245421962@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 09b4ad414ffbe0..51e5dd9ee793b5 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2161,9 +2161,8 @@ static int snd_pcm_drain(struct snd_pcm_substream *substream,
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
@@ -2181,7 +2180,7 @@ static int snd_pcm_drain(struct snd_pcm_substream *substream,
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



