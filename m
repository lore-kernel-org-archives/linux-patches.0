Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215549;
	b=4RW5MixNUQLtmapdseEc5txSrBzbG/0tsVKMxEJsCpOGQ7Z7FCoZ5ZKUE39SxXXCgYEu
	 V9h7zjaYOWW5kE/Le89cPqU6feqFK6XpOSSIc6ZwpVBeMuJR2hB60RgK55O2ByZT65hfm
	 ftCqXGArRZtCIl+pt8/BZfyjkKo7tg2aSpESbVVrNORPPSZ5QjAvgAPS5lW+AFvHQvtXw
	 IJ39WjORg9/BGfCD0Uc0NlohUWCYrdWAFIY6cHoe0r9XZcj4jI+OIxRDmxrpSmw43DjUe
	 DyWX/lMaY3FcofH4zCAsybz3QGBPxE+5HVzUStzcwSs5uGldFiBkCS1CIlEw1K4egwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1PZA0Es+JSl6WcKVtfxg1eTLdet4oPxZ17gZO8dO1cg=;
	b=etydbfUJlqUw6ap90L3Rt7JHhcmDWzO+1yv8+bi0iPOYNTTQyezQRzlG2wpvReaE7Taf
	 WhPDJI1WJuQignY7RAReFv00dAfoEkcx7MQ00282F/IH4YAbZHSoyuRDccjrIM222dHSE
	 phSCe769O+m0NPUtVqBoSNXyiJejNIndVHd7b7wSLBWdM4u//PDZTL6C3HbTOsgTxtzfD
	 lDdeLjGysLy7CcEUZXkrezj6jAku/PhNgwvhj7nspDeIoEYOPlvADqbPVrMdPg9GkDXI4
	 q7E3wVATpAzF0hlz5r454iCxbgYbdK8q579B3E6DWeARo9zJtd5sZSfGM1MgEvV7aag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0b9Ag3RZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F46606A31A;
	Wed, 28 Oct 2026 19:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0b9Ag3RZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E483A1F01825;
	Wed, 28 Oct 2026 19:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215549;
	bh=1PZA0Es+JSl6WcKVtfxg1eTLdet4oPxZ17gZO8dO1cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0b9Ag3RZrdmkV/m6tBf8KY3V4UqR4Qx+l27cALkGW6C/Nv4L3X0Yb/BrZWAu6MGgf
	 dvujbRkMPAxXRKZY6i/bXzLaUKhZNE1ZP776ouUuPWWarM1122eQ/mIUZxnaK0Tll5
	 B5Ri51EMWRYpe8WXQGKPB4RUl1BR38u763zVD3a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1249/1887] ALSA: seq: Clean up fifo locking with guard
Date: Wed, 28 Oct 2026 17:55:45 +0100
Message-ID: <20261028170527.846683247@linuxfoundation.org>
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
index 37930d74e3947..0b0a2f7c07879 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -439,7 +439,7 @@ static ssize_t snd_seq_read(struct file *file, char __user *buf, size_t count,
 
 	cell = NULL;
 	err = 0;
-	snd_seq_fifo_lock(fifo);
+	guard(snd_seq_fifo)(fifo);
 
 	if (IS_ENABLED(CONFIG_SND_SEQ_UMP) && client->midi_version > 0)
 		aligned_size = sizeof(struct snd_seq_ump_event);
@@ -498,7 +498,6 @@ static ssize_t snd_seq_read(struct file *file, char __user *buf, size_t count,
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



