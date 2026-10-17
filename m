Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9401738C2C0;
	Sat, 17 Oct 2026 17:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259260; cv=none; b=ZDaj3QTOV2nEl6E6ebwUB0WRfYJALhY77pn1k+vtx+DDJOazUVkAvXTho3rM1n1Nht2Ut4oYTSD55NrrHAobsSPqf6ixh0EeSWWURhL/H356TXVSsX/o2DsRCReWEYjpR2k215WrsJfmhSMKvPJXTRV035WkrbEwC0oV8y2hlYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259260; c=relaxed/simple;
	bh=3YWetYVqc7l42bss4NrJSpmecZXY1adA04EbkQxhJGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGbUMCl6bSYWMJokjbdO5FU3wyGDVSlGX5ThBuXlrY+l2l90QQVwUWVW9ityxD78TXYe3D9T//PLXKC4WBrtwjTLfyVEVruz0ZO9U6SrU1z48H1mipF3q/k2meTxyBzEtGlJKcUeJNV54jPozYwG/HAqzwVXAlPcwgCFrwZv5iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k79G46TW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k79G46TW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E376F1F000C4;
	Sat, 17 Oct 2026 17:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259259;
	bh=a0hS1GMLFayajL5LL/Rpk/2N/Kupj8QMfTq6XQABS4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k79G46TWCBQwGvMs93YKXoUAta+ZK1g0FSLscv+U3zARW7QOI4lxrvgBHK9JVOFG0
	 wEqPuTGIfUHICrCNXlTsybjH5bhoxNez7Co4JolUqJkJXdGsWYLCFe7jFSfOrEo7tP
	 f/SQsxBD413M4ulWHw/BY14V7vNNqBn7oEXtp9o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1155/1674] ALSA: seq: avoid stale FIFO cells during resize
Date: Sat, 17 Oct 2026 17:57:07 +0200
Message-ID: <20261017160500.798378367@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit e546128291f8d688dcb931827e2efd2aa6c0734d ]

snd_seq_fifo_resize() still needs to publish the replacement pool
before it waits for FIFO users. A blocking snd_seq_read() holds
f->use_lock while it sleeps, so concurrent senders must be able to
queue to the new pool and wake that reader instead of failing against a
closing old pool.

However, snd_seq_fifo_event_in() duplicates an event before it takes
f->lock, and snd_seq_read() can dequeue a cell and later call
snd_seq_fifo_cell_putback() if copy_to_user() or
snd_seq_expand_var_event() fails. If resize swaps f->pool and detaches
oldhead in between, either path can relink an old-pool cell after the
snapshot. That stale cell sits outside the drained oldhead list, keeps
oldpool->counter elevated, and can leave snd_seq_pool_delete() waiting
for the retired pool to drain.

Keep the existing swap-before-wait ordering in snd_seq_fifo_resize(),
but reject stale cells before any FIFO relink. Revalidate event-in cells
under f->lock and retry them against the published replacement pool, and
free stale putback cells instead of linking them back into the FIFO.

The buggy scenario involves two paths, with each column showing the
order within that path:

resize path:                    relink path:
1. Allocate newpool.             1. Take f->use_lock.
2. Swap f->pool to newpool and   2. Duplicate or dequeue an old-pool
   detach oldhead.                  cell before oldpool closes.
3. Mark oldpool closing and      3. Reach a later relink point after
   wait for FIFO users.             resize published newpool.
4. Free oldhead and delete       4. Relink the old-pool cell after
   oldpool.                         resize detached oldhead.
                                 5. Drop f->use_lock.

The reproducer reports a resize ioctl blocked in the expected pool
teardown path:

signal: resize iteration=98 target_pool=4 exceeded 250ms
        (elapsed=251ms)
diagnostic: resize_tid=651 wchan=snd_seq_pool_done
diagnostic: resize_tid=651 stack=
  snd_seq_pool_done+0x5b/0x140
  snd_seq_pool_delete+0x7a/0x90
  snd_seq_fifo_resize+0x193/0x1e0
  snd_seq_ioctl_set_client_pool+0x214/0x260
  snd_seq_ioctl+0x119/0x540
  __x64_sys_ioctl+0xd1/0x120
  do_syscall_64+0xbb/0x2f0
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

A second run with larger pools hit the same target path:

signal: resize iteration=32 target_pool=64 exceeded 250ms
        (elapsed=251ms)
diagnostic: resize_tid=663 wchan=snd_seq_pool_done
diagnostic: resize_tid=663 stack=
  snd_seq_pool_done+0x5b/0x140
  snd_seq_pool_delete+0x7a/0x90
  snd_seq_fifo_resize+0x193/0x1e0
  snd_seq_ioctl_set_client_pool+0x214/0x260
  snd_seq_ioctl+0x119/0x540
  __x64_sys_ioctl+0xd1/0x120
  do_syscall_64+0xbb/0x2f0
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 2d7d54002e39 ("ALSA: seq: Fix race during FIFO resize")

Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/20260614004801.3507773-2-zzzccc427@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_fifo.c | 52 ++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 15 deletions(-)

diff --git a/sound/core/seq/seq_fifo.c b/sound/core/seq/seq_fifo.c
index f23c6b7ae2403..c3dfe04c3883d 100644
--- a/sound/core/seq/seq_fifo.c
+++ b/sound/core/seq/seq_fifo.c
@@ -101,13 +101,17 @@ int snd_seq_fifo_event_in(struct snd_seq_fifo *f,
 			  struct snd_seq_event *event)
 {
 	struct snd_seq_event_cell *cell;
+	struct snd_seq_pool *pool;
+	bool linked;
 	int err;
 
 	if (snd_BUG_ON(!f))
 		return -EINVAL;
 
 	guard(snd_seq_fifo)(f);
-	err = snd_seq_event_dup(f->pool, event, &cell, 1, NULL, NULL); /* always non-blocking */
+retry:
+	pool = READ_ONCE(f->pool);
+	err = snd_seq_event_dup(pool, event, &cell, 1, NULL, NULL); /* always non-blocking */
 	if (err < 0) {
 		if ((err == -ENOMEM) || (err == -EAGAIN))
 			atomic_inc(&f->overflow);
@@ -115,14 +119,24 @@ int snd_seq_fifo_event_in(struct snd_seq_fifo *f,
 	}
 		
 	/* append new cells to fifo */
+	linked = false;
 	scoped_guard(spinlock_irqsave, &f->lock) {
-		if (f->tail != NULL)
-			f->tail->next = cell;
-		f->tail = cell;
-		if (f->head == NULL)
-			f->head = cell;
-		cell->next = NULL;
-		f->cells++;
+		if (cell->pool == f->pool) {
+			if (f->tail)
+				f->tail->next = cell;
+			f->tail = cell;
+			if (!f->head)
+				f->head = cell;
+			cell->next = NULL;
+			f->cells++;
+			linked = true;
+		}
+	}
+
+	if (!linked) {
+		/* Retry against the replacement pool after resize publishes it. */
+		snd_seq_cell_free(cell);
+		goto retry;
 	}
 
 	/* wakeup client */
@@ -194,13 +208,21 @@ int snd_seq_fifo_cell_out(struct snd_seq_fifo *f,
 void snd_seq_fifo_cell_putback(struct snd_seq_fifo *f,
 			       struct snd_seq_event_cell *cell)
 {
+	bool linked = false;
+
 	if (cell) {
-		guard(spinlock_irqsave)(&f->lock);
-		cell->next = f->head;
-		f->head = cell;
-		if (!f->tail)
-			f->tail = cell;
-		f->cells++;
+		scoped_guard(spinlock_irqsave, &f->lock) {
+			if (cell->pool == f->pool) {
+				cell->next = f->head;
+				f->head = cell;
+				if (!f->tail)
+					f->tail = cell;
+				f->cells++;
+				linked = true;
+			}
+		}
+		if (!linked)
+			snd_seq_cell_free(cell);
 	}
 }
 
@@ -236,7 +258,7 @@ int snd_seq_fifo_resize(struct snd_seq_fifo *f, int poolsize)
 		oldpool = f->pool;
 		oldhead = f->head;
 		/* exchange pools */
-		f->pool = newpool;
+		WRITE_ONCE(f->pool, newpool);
 		f->head = NULL;
 		f->tail = NULL;
 		f->cells = 0;
-- 
2.53.0



