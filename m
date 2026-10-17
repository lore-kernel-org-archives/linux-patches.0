Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E95C37268A;
	Sat, 17 Oct 2026 17:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259257; cv=none; b=NVhXQz0gxLDDMjXzw5E3ndADp5lSQh8QGbFxlmPhbDjZLe6OPtEunFwzIDzJrDOQNAryCCwck5tL6w+mzeENf1JXkCAClHCXXRQHR0e+NIW7c5/2Hfmr3xLHR3QF9caKT/iB4vgSV5kosIBBgwvWcDQgUOp22TU7YMOA/Bvs5cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259257; c=relaxed/simple;
	bh=JvSj98dnsGvYpxga8eNISLrvWV8g5LyMBKckij5xTJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+jxppqW0Ika8OCRKZTBOkmoAcfWJhRMTcWtVQ+p+gxw69I1fxVt/iu1ugghmF1DOSFEuhbPUadcYJMJquJ12Spf1GgLlF8NWybgl+7s4PgaElR4UoEs8IY9VIrdogaJHWU9fQzx08tnr6toYCKK79zRf1RzQXZv4gPrPges/m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPdpIpat; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPdpIpat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6A71F000C4;
	Sat, 17 Oct 2026 17:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259256;
	bh=3EU26JokMUajswaL7KoPGQ3O3qjH1RN6xT7BWZkAbwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPdpIpatgVrfdiJ+6G7eSEU07JYnrce67qIaGnpE1CcSo8BNTIhYnJbMpX0l7q1Xo
	 DlZA0byOceTQSr4AabBeW1Wp57D77Hx6jeU+yyAQInSywKDK6Z156takaoRbfyjKmI
	 fFA+esH0MNuXEVHlxnHAOwb7VnZFacEJjc/Gli/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1154/1674] ALSA: seq: Clean up fifo locking with guard
Date: Sat, 17 Oct 2026 17:57:06 +0200
Message-ID: <20261017160500.770912938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

[ Upstream commit 9314e34e37292f2d3d43dcc8a7f54366b4c0811d ]

Yet more cleanup, now for seq_fifo.c about its refcount calls; the
manual refcount calls (either snd_use_lock_*() or snd_seq_fifo_lock())
are replaced with guard(snd_seq_fifo).

Only code refactoring, and no behavior change.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250827080520.7544-8-tiwai@suse.de
Stable-dep-of: e546128291f8 ("ALSA: seq: avoid stale FIFO cells during resize")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c |  3 +--
 sound/core/seq/seq_fifo.c      | 15 ++++-----------
 sound/core/seq/seq_fifo.h      |  1 +
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 1fddeb91c9f46..30dc8310bfa84 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -463,7 +463,7 @@ static ssize_t snd_seq_read(struct file *file, char __user *buf, size_t count,
 
 	cell = NULL;
 	err = 0;
-	snd_seq_fifo_lock(fifo);
+	guard(snd_seq_fifo)(fifo);
 
 	if (IS_ENABLED(CONFIG_SND_SEQ_UMP) && client->midi_version > 0)
 		aligned_size = sizeof(struct snd_seq_ump_event);
@@ -522,7 +522,6 @@ static ssize_t snd_seq_read(struct file *file, char __user *buf, size_t count,
 		if (err == -EAGAIN && result > 0)
 			err = 0;
 	}
-	snd_seq_fifo_unlock(fifo);
 
 	return (err < 0) ? err : result;
 }
diff --git a/sound/core/seq/seq_fifo.c b/sound/core/seq/seq_fifo.c
index 3a10b081f129c..f23c6b7ae2403 100644
--- a/sound/core/seq/seq_fifo.c
+++ b/sound/core/seq/seq_fifo.c
@@ -106,12 +106,11 @@ int snd_seq_fifo_event_in(struct snd_seq_fifo *f,
 	if (snd_BUG_ON(!f))
 		return -EINVAL;
 
-	snd_use_lock_use(&f->use_lock);
+	guard(snd_seq_fifo)(f);
 	err = snd_seq_event_dup(f->pool, event, &cell, 1, NULL, NULL); /* always non-blocking */
 	if (err < 0) {
 		if ((err == -ENOMEM) || (err == -EAGAIN))
 			atomic_inc(&f->overflow);
-		snd_use_lock_free(&f->use_lock);
 		return err;
 	}
 		
@@ -130,8 +129,6 @@ int snd_seq_fifo_event_in(struct snd_seq_fifo *f,
 	if (waitqueue_active(&f->input_sleep))
 		wake_up(&f->input_sleep);
 
-	snd_use_lock_free(&f->use_lock);
-
 	return 0; /* success */
 
 }
@@ -263,14 +260,10 @@ int snd_seq_fifo_resize(struct snd_seq_fifo *f, int poolsize)
 /* get the number of unused cells safely */
 int snd_seq_fifo_unused_cells(struct snd_seq_fifo *f)
 {
-	int cells;
-
 	if (!f)
 		return 0;
 
-	snd_use_lock_use(&f->use_lock);
-	scoped_guard(spinlock_irqsave, &f->lock)
-		cells = snd_seq_unused_cells(f->pool);
-	snd_use_lock_free(&f->use_lock);
-	return cells;
+	guard(snd_seq_fifo)(f);
+	guard(spinlock_irqsave)(&f->lock);
+	return snd_seq_unused_cells(f->pool);
 }
diff --git a/sound/core/seq/seq_fifo.h b/sound/core/seq/seq_fifo.h
index b56a7b897c9c3..4c9c49127746b 100644
--- a/sound/core/seq/seq_fifo.h
+++ b/sound/core/seq/seq_fifo.h
@@ -37,6 +37,7 @@ int snd_seq_fifo_event_in(struct snd_seq_fifo *f, struct snd_seq_event *event);
 /* lock fifo from release */
 #define snd_seq_fifo_lock(fifo)		snd_use_lock_use(&(fifo)->use_lock)
 #define snd_seq_fifo_unlock(fifo)	snd_use_lock_free(&(fifo)->use_lock)
+DEFINE_GUARD(snd_seq_fifo, struct snd_seq_fifo *, snd_seq_fifo_lock(_T), snd_seq_fifo_unlock(_T))
 
 /* get a cell from fifo - fifo should be locked */
 int snd_seq_fifo_cell_out(struct snd_seq_fifo *f, struct snd_seq_event_cell **cellp, int nonblock);
-- 
2.53.0



