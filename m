Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E585737A858;
	Thu, 20 Aug 2026 16:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244437; cv=none; b=VASiKJIdcycLqq1E3Hlb78GyjG8suUa13DNTHnryK3pMrcAjg3rALtuZQHIRfjfKZZqqOFQXS2PCADwR82AoydV3B0TdBeNHZydPN5BDR7IthWBSlFnlO9CX6VOZJsiXL0EoqtgxlA08R6A/JYFFoDSHw7b56DCGIfLGkn0oUZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244437; c=relaxed/simple;
	bh=9mwSJye/I/68b4HF1w9S9DEmZgAGiN2MaLoJfA+1fmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOJQC5RwDUSoRq9b+QRZUY2lQI7DTnyoj9goRgz411irj7TMeDk0rnZmG/9tIMgYY1Fj+04cJSfweV+cQuuPgHigNhKzVIFbQTIvN5FsKGxRgu/B745Qhl2e0NoyR1pVPCwsLbcASA3M7W2LDimlDKVB7qyXYeOVwm82HuL5pHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjHQBZBU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjHQBZBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B58D1F000E9;
	Thu, 20 Aug 2026 16:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244435;
	bh=gd0LssmuEz3JUI+D8HkEuHIxK0OG4pjynkYiQGz4qyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RjHQBZBUykMuPL4YkIFfHP4tP2fbFnMUmQVn2BzDX0VE/031vA6jdCipiAmHnipO6
	 3nRyie4/oRc9Q+XEaav7QwS0QWwqCSl9XZULI1l3wupHspZqZ8eVf1+L6XUO0LvSk7
	 QDDXiHFXZbrchOxSzP6XHzIUTtt/hZ/IaAaxtAF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/235] ALSA: seq: close a re-opened queue timer in the destructor
Date: Thu, 20 Aug 2026 16:56:43 +0200
Message-ID: <20260820145221.566104730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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


