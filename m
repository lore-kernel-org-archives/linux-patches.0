Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F328236B93B;
	Sat, 17 Oct 2026 16:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254497; cv=none; b=XLG5wIRXLN3fJFJBcChwli98/iSUOXp5Tk/pJOPo79oJUC9hzme3ySTyJd+/TCyxZsM3fcc2oVT5eneYI3QtPmdX76+frTfA7HlkvtjpYS69aBSXB6Z3DL598si938NQohOAMvf3RwR+3vrfngVhVDCJRFeDT8BdawARS45nkQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254497; c=relaxed/simple;
	bh=OlqVV32G4nn5JBYtredbv3xrwkMvuKV017tW84Iirzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1SxnGoKUqBWTsqWdkCRxC1jh/BkM7TfoGA7dW9dxjHV+z4Nb7Yz8uWlwAYOt+tLknoY3bhSBJyOlXZJWyinawegUfbAnApoC4371sOmZlegiBd3frhaJZZRQLSGktwciVipHQQlZB0Ku1mA+BsySVSM85gtc2yUA50o9PK20LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nw4UQdV8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nw4UQdV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A961F000C4;
	Sat, 17 Oct 2026 16:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254495;
	bh=3T5vRD1JMnWrQ6gQauSD3SIbiBfUa97n6oI1bND6J88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nw4UQdV8OZ//98Owl36CVyPW0z8+Pw9ruz3XnxCzCZk26rNqnJZXwA2TNuEvUTAgr
	 ro4ObWCfvyl5siClzUa2bR+qqAb01yc48uEX9uCqnMaMvMdzAqWEx3tkDls1Okib/T
	 zoUeP/m0GwCfAAI+Wwh4YtHDs9t35RTj+HJK2l+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 464/869] ALSA: seq: Clean up fifo locking with guard
Date: Sat, 17 Oct 2026 17:55:05 +0200
Message-ID: <20261017160049.026249284@linuxfoundation.org>
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
index 35f099e02ca70..86316cf027aed 100644
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



