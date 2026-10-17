Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0457404E;
	Sat, 17 Oct 2026 16:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254698; cv=none; b=jZcf7WknTmB7p4ng3kc81n6jiALXVy1z9xULyDmijh9pSpKjrkIPq4cFgwWa5glR7XX+KKUYoPejj+tWdADLWJZgVW3DLf2TkeVm2Q2y71kIvQq9cKj1ZPu6uj50YLExGUAsPiNKgle7RU/fJeLA+80utlu9bBfubbsOcacafoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254698; c=relaxed/simple;
	bh=XGMqXt2FkCSzQQ74nYZM2D02idiVMM48QGeuGqGyZyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFgyC0yod/BTG+IsYt9cgV0+jyBAMLFNYiLelTdbL3iriA6aRyS6jpuAEbpnjnILUZhR4Ypu55D8cGqfLj0OSZRp3os0P2lUvySKP/OWybR4Kcogm159sJlLb1vJGAm1zp8LMFeVrMNHY7KT+01zsTIs+UL3uCZvusXi1kvd1m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GcHBCdKS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GcHBCdKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0441F000C4;
	Sat, 17 Oct 2026 16:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254697;
	bh=hCUzC1hoJqXUE850S1hJCniRYF/IYVGA+kVQgmc2lmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GcHBCdKSHXXXwYj0HTGqFNDRtfeuL3AI4lAbJ97s2oGyzAVa1jwRZJxy7vE4W42Lw
	 jpjhPUCe5nEIL85Bod6fd47N7l2ngAgcTpatjNdXHTGEshNvoMKSp+mvuaEEQ4VmRv
	 DDfBnU43vNEREuaa6c8uUcQR2clIHVXRF2gJJ/a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 532/869] ALSA: seq: oss: Serialize readq reset state with q->lock
Date: Sat, 17 Oct 2026 17:56:13 +0200
Message-ID: <20261017160050.746160593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 49ce92d207820f588b0406add82f053decfbe5d9 ]

snd_seq_oss_readq_clear() resets qlen, head, and tail without
q->lock even though the normal reader and producer paths serialize the
same ring state under that spinlock. A reset can therefore race
snd_seq_oss_readq_free() or snd_seq_oss_readq_put_event() and leave
stale records in the queue, drop freshly queued ones, or report the
wrong readiness after wakeup. KCSAN reports a data race between
snd_seq_oss_readq_clear() and snd_seq_oss_readq_free().

Take q->lock while clearing the ring and resetting input_time. Factor
the enqueue logic into a caller-locked helper so
snd_seq_oss_readq_put_timestamp() updates its suppression state under
the same lock instead of racing the reset path.

The buggy scenario involves two paths, with each column showing the
order within that path:

reset path:                      locked readq updater:
1. snd_seq_oss_reset() or        1. A reader or callback producer
   release reaches                  takes q->lock on the same queue.
   snd_seq_oss_readq_clear().
2. snd_seq_oss_readq_clear()     2. The updater tests or modifies
   resets qlen, head, tail,         qlen, head, and tail.
   and input_time.
3. snd_seq_oss_readq_clear()     3. The updater completes its
   wakes sleepers on                read-modify-write sequence.
   q->midi_sleep.
4. Without q->lock, the reset    4. The resulting ring state drives
   can overlap the locked           later reads and readiness.
   update.

KCSAN reports:

BUG: KCSAN: data-race in snd_seq_oss_readq_clear /
snd_seq_oss_readq_free

write to 0xffff8881069fe608 of 4 bytes by task 120516 on cpu 0:
  snd_seq_oss_readq_free+0x6c/0x80
  snd_seq_oss_read+0xcb/0x250
  odev_read+0x38/0x60
  vfs_read+0xff/0x600
  ksys_read+0xb4/0x140
  __x64_sys_read+0x46/0x60
  do_syscall_64+0xbb/0x2f0
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff8881069fe608 of 4 bytes by task 120517 on cpu 1:
  snd_seq_oss_readq_clear+0x1f/0x90
  snd_seq_oss_reset+0xa7/0xf0
  snd_seq_oss_ioctl+0x6f6/0x7e0
  odev_ioctl+0x56/0xc0
  __x64_sys_ioctl+0xd1/0x120
  do_syscall_64+0xbb/0x2f0
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

value changed: 0x00000001 -> 0x00000000

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/20260614004801.3507773-1-zzzccc427@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/oss/seq_oss_readq.c | 83 +++++++++++++++++++-----------
 1 file changed, 52 insertions(+), 31 deletions(-)

diff --git a/sound/core/seq/oss/seq_oss_readq.c b/sound/core/seq/oss/seq_oss_readq.c
index f0db5d3dcba47..b7cdb1c61f265 100644
--- a/sound/core/seq/oss/seq_oss_readq.c
+++ b/sound/core/seq/oss/seq_oss_readq.c
@@ -73,13 +73,17 @@ snd_seq_oss_readq_delete(struct seq_oss_readq *q)
 void
 snd_seq_oss_readq_clear(struct seq_oss_readq *q)
 {
-	if (q->qlen) {
-		q->qlen = 0;
-		q->head = q->tail = 0;
+	scoped_guard(spinlock_irqsave, &q->lock) {
+		if (q->qlen) {
+			q->qlen = 0;
+			q->head = 0;
+			q->tail = 0;
+		}
+		q->input_time = (unsigned long)-1;
 	}
+
 	/* if someone sleeping, wake'em up */
 	wake_up(&q->midi_sleep);
-	q->input_time = (unsigned long)-1;
 }
 
 /*
@@ -136,28 +140,37 @@ int snd_seq_oss_readq_sysex(struct seq_oss_readq *q, int dev,
 /*
  * copy an event to input queue:
  * return zero if enqueued
+ * caller must hold lock
  */
-int
-snd_seq_oss_readq_put_event(struct seq_oss_readq *q, union evrec *ev)
+static int snd_seq_oss_readq_put_event_locked(struct seq_oss_readq *q,
+					      union evrec *ev)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&q->lock, flags);
-	if (q->qlen >= q->maxlen - 1) {
-		spin_unlock_irqrestore(&q->lock, flags);
+	if (q->qlen >= q->maxlen - 1)
 		return -ENOMEM;
-	}
 
 	memcpy(&q->q[q->tail], ev, sizeof(*ev));
 	q->tail = (q->tail + 1) % q->maxlen;
 	q->qlen++;
 
-	/* wake up sleeper */
-	wake_up(&q->midi_sleep);
+	return 0;
+}
 
-	spin_unlock_irqrestore(&q->lock, flags);
+/*
+ * copy an event to input queue:
+ * return zero if enqueued
+ */
+int
+snd_seq_oss_readq_put_event(struct seq_oss_readq *q, union evrec *ev)
+{
+	int rc;
 
-	return 0;
+	scoped_guard(spinlock_irqsave, &q->lock) {
+		rc = snd_seq_oss_readq_put_event_locked(q, ev);
+		if (!rc)
+			wake_up(&q->midi_sleep);
+	}
+
+	return rc;
 }
 
 
@@ -215,23 +228,31 @@ snd_seq_oss_readq_poll(struct seq_oss_readq *q, struct file *file, poll_table *w
 int
 snd_seq_oss_readq_put_timestamp(struct seq_oss_readq *q, unsigned long curt, int seq_mode)
 {
-	if (curt != q->input_time) {
-		union evrec rec;
-		memset(&rec, 0, sizeof(rec));
-		switch (seq_mode) {
-		case SNDRV_SEQ_OSS_MODE_SYNTH:
-			rec.echo = (curt << 8) | SEQ_WAIT;
-			snd_seq_oss_readq_put_event(q, &rec);
-			break;
-		case SNDRV_SEQ_OSS_MODE_MUSIC:
-			rec.t.code = EV_TIMING;
-			rec.t.cmd = TMR_WAIT_ABS;
-			rec.t.time = curt;
-			snd_seq_oss_readq_put_event(q, &rec);
-			break;
+	int queued = 0;
+
+	scoped_guard(spinlock_irqsave, &q->lock) {
+		if (curt != q->input_time) {
+			union evrec rec;
+
+			memset(&rec, 0, sizeof(rec));
+			switch (seq_mode) {
+			case SNDRV_SEQ_OSS_MODE_SYNTH:
+				rec.echo = (curt << 8) | SEQ_WAIT;
+				queued = !snd_seq_oss_readq_put_event_locked(q, &rec);
+				break;
+			case SNDRV_SEQ_OSS_MODE_MUSIC:
+				rec.t.code = EV_TIMING;
+				rec.t.cmd = TMR_WAIT_ABS;
+				rec.t.time = curt;
+				queued = !snd_seq_oss_readq_put_event_locked(q, &rec);
+				break;
+			}
+			q->input_time = curt;
 		}
-		q->input_time = curt;
 	}
+	if (queued)
+		wake_up(&q->midi_sleep);
+
 	return 0;
 }
 
-- 
2.53.0



