Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB3037CD59;
	Thu, 30 Jul 2026 15:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426219; cv=none; b=pEqYaWfCEUB38Vqr6MuMGYkeZCkJTpRBBV39RvcwqzPdENfjpanIgQ0LLOLDKA1J5xa1jpMUxkE5shbBqF6BlgSct35T2Wtvn+94793AhuAhiP0DqBNT1B7oKOxAwRWc6SMZdkPoEMZVWYpaHbjuw8zhMLLFKK0v5iRRuSS0sIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426219; c=relaxed/simple;
	bh=6Qi3oXESWEYndv5kZnTpPIJWuTJ9slIMUFh1zSEb6Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pA1gTuRUrmNhjAz8s8llmwq32hJ/FceTV8pThbrFocVAAEOGEiQaKMnHmQboYESSDtcsyWQo+4J4EP+XZAsav0L5FWOScsDst/1i6aTp/KxMNEc9OTt2bqBRQzAy9rp9tXYGQAcUmerUA2n5ltq07W3BfyJ9JdCRDHOyCa8d+HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8r//wmn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8r//wmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4551F000E9;
	Thu, 30 Jul 2026 15:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426218;
	bh=cpgpukrGrlPqlSHO+e4Ik4UI3z2bcfNExKigcVewIDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8r//wmnmdaZODkMCC8okOCgRncndLLh0TUdEUFskPVSPxb/fcw4Wd9UiWjC5d6jU
	 Zjepp2CDj8PPuNHUyMTu0zofwM1tanuAAhVB7esDv8xHZ+VwXZpmzaW8Ao/vUhemap
	 HEsH7yVHhg5ZjzZVqq8f/f/4/qXixNcebtR4tuXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 343/602] ALSA: seq: close a re-opened queue timer in the destructor
Date: Thu, 30 Jul 2026 16:12:15 +0200
Message-ID: <20260730141443.168601860@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Norbert Szetei <norbert@doyensec.com>

commit 2c4dc0ed50b05cd847a4b34b8cebf0775f19aeb9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_timer.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/sound/core/seq/seq_timer.c
+++ b/sound/core/seq/seq_timer.c
@@ -61,12 +61,23 @@ struct snd_seq_timer *snd_seq_timer_new(
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
+	scoped_guard(spinlock_irq, &t->lock) {
+		ti = t->timeri;
+		t->timeri = NULL;
+	}
+	if (ti) {
+		snd_timer_close(ti);
+		snd_timer_instance_free(ti);
+	}
+
+	*tmr = NULL;
 	t->running = 0;
 
 	/* reset time */


