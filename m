Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215547;
	b=V0KQfMaURbBDPBzAHNICg6GjQMu+bFMPr+iyHDGool2tWBrS/WvMTmPp2ZR+sO+PUCK0
	 NIkqC39bVqw4/9RsPP1jEmhTCZ3Fl3+FYjARYT5H8HKNNHJErtQwvOhi+yHkN6t6rR15f
	 Jkt580pjfs6kxY3/C+eOSpZbtxBuCASSJMDZhDtbhTPPmilzKUAB5bsbZudbSq6YsHody
	 9DH1ILjGtgK3vlh68+4PbF7M+Tw+dGtWDOldYWXriWG1wrzV8QQSrxRr1HaQhh0Khll+g
	 QvZ164yj6kqK5B7lCRZ5FISTXUjhtMMJdQlS1MxAergpyTkOmbOaWk7aLIewztGmcYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BZOfr0V4qTMJXK9z+9bma39BvvUuNmDkvqmE4SeBrkA=;
	b=mXu/zPmX6ldsnQ0VPUXH8hHq2eUdOnmhJOKTrnjCOBY0qg+qHgUCO9q/P3gF05as90On
	 uyjuDQVEjkkjZ5JmhEKcIqHfUneDCnQ+6GB1TIVH18JOYn27IT53uMjYPqrfxO1Ai3BHj
	 4tyvtUsE59x75+VmY2CzdnAQqL04FiZFK15YZEo7cC1jnvfSG83ebiBdd/zbl65tv7w3h
	 bXXBDfjvIPWqP5cpnXGNdDjVROCxUilKZKo9fZYfWSTcgYkzbbIy27EY/ui5rqYVNgCKL
	 IY42GEcYTsBGYql6vcPnP+u+p0msdEUcdHTdtzVCHt0qcD2VpQdNwRzceBLg8s52Z9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LshEWpA+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD88F606A31A;
	Wed, 28 Oct 2026 19:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LshEWpA+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173041F01825;
	Wed, 28 Oct 2026 19:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215546;
	bh=BZOfr0V4qTMJXK9z+9bma39BvvUuNmDkvqmE4SeBrkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LshEWpA+MZsNQeik0kn025DGi9NIMySyuBdYawhDrY9pkDydPvkPiO+Zv7gJDzcl+
	 Re9+fckCLeBMeFeDJBN08jCerxGYi1MG86Im1bicncUWl/G2GhCDFnq09FMe0DYGCw
	 6bpyynHMl4vMJexz+VUvhyGYNhvBhZPdoXWEqWQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1248/1887] ALSA: seq: fifo: Use guard() for locking
Date: Wed, 28 Oct 2026 17:55:44 +0100
Message-ID: <20261028170527.823996926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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



