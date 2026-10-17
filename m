Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CD51DFDA1;
	Sat, 17 Oct 2026 17:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259380; cv=none; b=M67r3o5mM7BC9L5GmIOBd2KhHCGJzZJm4PvfEKqpCyLp0ROr1dZXwZ3Wg5XIlw6tC1hme4gyVZr5oGuBoQluy0hL00kEfYW+C9D4pc5nUluuCRxh69HIn5nIY2SZV84k3QgIdTs+Q/4QHk1xSRXCvTZ9tqXmEu8pBMYJ0Xazhi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259380; c=relaxed/simple;
	bh=eDvRINfnPQVw2BI2+ehKiAHnVwBWcHY+2E+fVP3byPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBPkOhwOkyIqWef3PoUjnt3qnSiPParRuL2I/v0EbHjFX+3z90SZV3tUO4J/VrC7u/xjverU6HZbtNg+Y8QF2jEIPNipI3lGlpzRbTtiznX5HeTwGRyaIYZY4cjTBR7Oh4xxBMFPcJyKuzDsmV9HbTZiIJt1oAxFRJBDC0a3blU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXDKNIBS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXDKNIBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC881F000C4;
	Sat, 17 Oct 2026 17:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259378;
	bh=HE+NBAIl24xDnivozoTgUUhd6JJdvNP/8ye4r2IEXcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXDKNIBSIizl3Dd4jttHR6nnnt8isRPGRpO66OMb7KW6YiTxtHLNyKl1tO1SsgXoT
	 WA7moraT/ZQ0iB1BGr9fA4QYF4gHM/0DdfvPKsPI8pvR7aECKxDc3ck9ZnI8V1U2Wl
	 EFDUgvZGZX0SJwbdLQT5YqCla1xq3FQ9ic1fukbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1153/1674] ALSA: seq: fifo: Use guard() for locking
Date: Sat, 17 Oct 2026 17:57:05 +0200
Message-ID: <20261017160500.743234315@linuxfoundation.org>
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

[ Upstream commit 68f014a58b6540847b0939a9a4023ed6eb834608 ]

We can simplify the code gracefully with new guard() macro and co for
automatic cleanup of locks.

Only the code refactoring, and no functional changes.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240227085306.9764-13-tiwai@suse.de
Stable-dep-of: e546128291f8 ("ALSA: seq: avoid stale FIFO cells during resize")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_fifo.c | 55 +++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 31 deletions(-)

diff --git a/sound/core/seq/seq_fifo.c b/sound/core/seq/seq_fifo.c
index f8e02e98709ab..3a10b081f129c 100644
--- a/sound/core/seq/seq_fifo.c
+++ b/sound/core/seq/seq_fifo.c
@@ -88,12 +88,11 @@ void snd_seq_fifo_clear(struct snd_seq_fifo *f)
 	atomic_set(&f->overflow, 0);
 
 	snd_use_lock_sync(&f->use_lock);
-	spin_lock_irq(&f->lock);
+	guard(spinlock_irq)(&f->lock);
 	/* drain the fifo */
 	while ((cell = fifo_cell_out(f)) != NULL) {
 		snd_seq_cell_free(cell);
 	}
-	spin_unlock_irq(&f->lock);
 }
 
 
@@ -102,7 +101,6 @@ int snd_seq_fifo_event_in(struct snd_seq_fifo *f,
 			  struct snd_seq_event *event)
 {
 	struct snd_seq_event_cell *cell;
-	unsigned long flags;
 	int err;
 
 	if (snd_BUG_ON(!f))
@@ -118,15 +116,15 @@ int snd_seq_fifo_event_in(struct snd_seq_fifo *f,
 	}
 		
 	/* append new cells to fifo */
-	spin_lock_irqsave(&f->lock, flags);
-	if (f->tail != NULL)
-		f->tail->next = cell;
-	f->tail = cell;
-	if (f->head == NULL)
-		f->head = cell;
-	cell->next = NULL;
-	f->cells++;
-	spin_unlock_irqrestore(&f->lock, flags);
+	scoped_guard(spinlock_irqsave, &f->lock) {
+		if (f->tail != NULL)
+			f->tail->next = cell;
+		f->tail = cell;
+		if (f->head == NULL)
+			f->head = cell;
+		cell->next = NULL;
+		f->cells++;
+	}
 
 	/* wakeup client */
 	if (waitqueue_active(&f->input_sleep))
@@ -199,16 +197,13 @@ int snd_seq_fifo_cell_out(struct snd_seq_fifo *f,
 void snd_seq_fifo_cell_putback(struct snd_seq_fifo *f,
 			       struct snd_seq_event_cell *cell)
 {
-	unsigned long flags;
-
 	if (cell) {
-		spin_lock_irqsave(&f->lock, flags);
+		guard(spinlock_irqsave)(&f->lock);
 		cell->next = f->head;
 		f->head = cell;
 		if (!f->tail)
 			f->tail = cell;
 		f->cells++;
-		spin_unlock_irqrestore(&f->lock, flags);
 	}
 }
 
@@ -239,17 +234,17 @@ int snd_seq_fifo_resize(struct snd_seq_fifo *f, int poolsize)
 		return -ENOMEM;
 	}
 
-	spin_lock_irq(&f->lock);
-	/* remember old pool */
-	oldpool = f->pool;
-	oldhead = f->head;
-	/* exchange pools */
-	f->pool = newpool;
-	f->head = NULL;
-	f->tail = NULL;
-	f->cells = 0;
-	/* NOTE: overflow flag is not cleared */
-	spin_unlock_irq(&f->lock);
+	scoped_guard(spinlock_irq, &f->lock) {
+		/* remember old pool */
+		oldpool = f->pool;
+		oldhead = f->head;
+		/* exchange pools */
+		f->pool = newpool;
+		f->head = NULL;
+		f->tail = NULL;
+		f->cells = 0;
+		/* NOTE: overflow flag is not cleared */
+	}
 
 	/* close the old pool and wait until all users are gone */
 	snd_seq_pool_mark_closing(oldpool);
@@ -268,16 +263,14 @@ int snd_seq_fifo_resize(struct snd_seq_fifo *f, int poolsize)
 /* get the number of unused cells safely */
 int snd_seq_fifo_unused_cells(struct snd_seq_fifo *f)
 {
-	unsigned long flags;
 	int cells;
 
 	if (!f)
 		return 0;
 
 	snd_use_lock_use(&f->use_lock);
-	spin_lock_irqsave(&f->lock, flags);
-	cells = snd_seq_unused_cells(f->pool);
-	spin_unlock_irqrestore(&f->lock, flags);
+	scoped_guard(spinlock_irqsave, &f->lock)
+		cells = snd_seq_unused_cells(f->pool);
 	snd_use_lock_free(&f->use_lock);
 	return cells;
 }
-- 
2.53.0



