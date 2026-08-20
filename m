Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0996446D091;
	Thu, 20 Aug 2026 16:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243720; cv=none; b=u+JSjDT3aySmVVji9LQ6YyqDY0np3ZPYzoMqMulfpcSc+U/LlM0wp4TXMAOzAP+vuvvF28/ES4n44X0rtTXohvKvO+UROU2LDMq4av4MuqobOln3kgvSa89mHxmrUriXmyix82fbjFwNPTTFzz3+cmf6hRjia1tDhKxiyWvrXsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243720; c=relaxed/simple;
	bh=11IySmMy25ny/kDJ6xxw9I6QHQA2i6T9GJCZhQMWT98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FS4VATFfncKH4jwwNtlbYUDXIelb0o24PTW+9Rsw1B7tCR0coXbBJuC6dDFsrLKhbIWiOsRlZ/ILdv7OYBuqNzSh187bh20nIncxZaSL5lXBwMxwhX9zPUk5p0JgZGXJBQ++FKfdxSX3eWVXQbqJaOqm806mUa4t1xsj51GnspM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmXL/O39; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmXL/O39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139321F00A3A;
	Thu, 20 Aug 2026 16:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243718;
	bh=BS9QTL0qNkVFlwLZCJIw4OJv3HFHOsX9pnvU7/leUDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HmXL/O39rM9JKIPgtRK5U6t/BJXBTklX7Xsw8HthbyCxwKFhdiMoXedojG2NtHSFz
	 ooQvyfp0Eg6qllnlpPz0wrsY4JOLWFmvrPfxIdYRblYySzVRvKvdab22a4NkfW/y8u
	 sxchCygpaD8v+791eVcM2OBgZDPc4ra/y8wgRJjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 191/272] ALSA: seq: close a re-opened queue timer in the destructor
Date: Thu, 20 Aug 2026 16:56:15 +0200
Message-ID: <20260820145237.205903723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

[ Upstream commit 2c4dc0ed50b05cd847a4b34b8cebf0775f19aeb9 ]

queue_delete() closes the queue timer, then frees it. snd_seq_timer_close()
clears q->timer->timeri. snd_use_lock_sync() then drains borrowers, and
snd_seq_timer_delete() frees q->timer.

A borrower can re-open the timer inside that window. A SET_QUEUE_CLIENT
that took a queueptr() use_lock reference before the queue was unlinked
runs snd_seq_timer_open() after the close. Open refuses re-open only while
timeri is set, and the close just cleared it, so it re-opens timeri.

snd_seq_timer_delete() does not close that instance. Its snd_seq_timer_stop()
is a no-op, because running was cleared first. So it frees q->timer with the
instance still live. The queue is freed next.

The instance stays on the global timer with callback_data pointing at the
freed queue. A non-owner START on the unlocked queue arms it. The next tick
derefs the freed queue in snd_seq_timer_interrupt().

Reachable by an unprivileged user with access to /dev/snd/seq. No CAP and
no queue ownership required.

Close any lingering instance in the destructor. There, ->timeri can no
longer change: the queue is unlinked and all use_lock borrowers have
drained, so no snd_seq_queue_use() can re-open it. Close it before clearing
q->timer. snd_timer_close() waits for any in-flight snd_seq_timer_interrupt()
to finish, and that callback still reads q->timer (via snd_seq_check_queue()),
so q->timer must stay valid until it drains.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Link: https://patch.msgid.link/422FDB81-2A68-47C7-A22D-2D3301E2E86D@doyensec.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ replaced scoped_guard(spinlock_irq, &t->lock) with explicit spin_lock_irq()/spin_unlock_irq() pair since gnu89-compiled 5.15 rejects the macro's for-loop declarations ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_timer.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/sound/core/seq/seq_timer.c
+++ b/sound/core/seq/seq_timer.c
@@ -58,12 +58,23 @@ struct snd_seq_timer *snd_seq_timer_new(
 void snd_seq_timer_delete(struct snd_seq_timer **tmr)
 {
 	struct snd_seq_timer *t = *tmr;
-	*tmr = NULL;
+	struct snd_timer_instance *ti;
 
 	if (t == NULL) {
 		pr_debug("ALSA: seq: snd_seq_timer_delete() called with NULL timer\n");
 		return;
 	}
+
+	spin_lock_irq(&t->lock);
+	ti = t->timeri;
+	t->timeri = NULL;
+	spin_unlock_irq(&t->lock);
+	if (ti) {
+		snd_timer_close(ti);
+		snd_timer_instance_free(ti);
+	}
+
+	*tmr = NULL;
 	t->running = 0;
 
 	/* reset time */


