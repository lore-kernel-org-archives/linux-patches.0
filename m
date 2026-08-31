Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A8B43F4A6;
	Mon, 31 Aug 2026 14:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185014; cv=none; b=aGsH/QxBaAdaC1NsxT+OE6cyBxIOzjiyvhGMTQvozPAFGQht+k61rM9vOumymg8OvVj3CBxWakQCFRbmmJB6eSjVUlwTBoQILd7JnX1q7yymhvq0rQi0d0QUlWg8mSszzsDXW9NfpvW2i6Mxt1eZyY12i6+cvUdu64Afd/CV7EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185014; c=relaxed/simple;
	bh=jSjiVDU8/CHCSNDdOzzVxAIj0PFXG7whD+Xps0eGN0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/xafo5mIRMKZkc5fXxNFfRi2HBZITYWEOw/X5DXohFh5YF8DxxWw+viVzbzO+jiAPaCw2/FTiEN9sSBnBFMyZErHhIYBr39yYb8GP2FEC7MVdcyKid7nO9pW27ujFFp9KrVfg1TiW60Nwyy/gWc2SKiRB8E2ndfB3tJcaqG9rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+CQ1Y+0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+CQ1Y+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15D21F000E9;
	Mon, 31 Aug 2026 14:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185013;
	bh=lhP8yIOSpCAo+kYXcgBJHY8e+8q9DvGIEAixyylrlh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+CQ1Y+00zOGs9QZheGIYJoLK/60saqu9jNDaciFE/9TxHl1aYIctrNeDrN4NgTB2
	 Pdu0hCvJajbCT7lFy6z5zgQa2CRrlJh815xQV5BXfMpYl0/yD4ztuGwem7P59yfHl3
	 zNj11EmwEj+t8zeyEvEejW4ac9EYLT/plNaXPC9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Williams <williams@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Dmitry Vyukov <dvyukov@google.com>,
	Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 23/69] kcov: replace local_irq_save() with a local_lock_t
Date: Mon, 31 Aug 2026 15:34:56 +0200
Message-ID: <20260831133359.591784518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit d5d2c51f1e5f56ed01d2c773974630c007e5e5f5 ]

The kcov code mixes local_irq_save() and spin_lock() in
kcov_remote_{start|end}().  This creates a warning on PREEMPT_RT because
local_irq_save() disables interrupts and spin_lock_t is turned into a
sleeping lock which can not be acquired in a section with disabled
interrupts.

The kcov_remote_lock is used to synchronize the access to the hash-list
kcov_remote_map.  The local_irq_save() block protects access to the
per-CPU data kcov_percpu_data.

There is no compelling reason to change the lock type to raw_spin_lock_t
to make it work with local_irq_save().  Changing it would require to
move memory allocation (in kcov_remote_add()) and deallocation outside
of the locked section.

Adding an unlimited amount of entries to the hashlist will increase the
IRQ-off time during lookup.  It could be argued that this is debug code
and the latency does not matter.  There is however no need to do so and
it would allow to use this facility in an RT enabled build.

Using a local_lock_t instead of local_irq_save() has the befit of adding
a protection scope within the source which makes it obvious what is
protected.  On a !PREEMPT_RT && !LOCKDEP build the local_lock_irqsave()
maps directly to local_irq_save() so there is overhead at runtime.

Replace the local_irq_save() section with a local_lock_t.

Link: https://lkml.kernel.org/r/20210923164741.1859522-6-bigeasy@linutronix.de
Link: https://lore.kernel.org/r/20210830172627.267989-6-bigeasy@linutronix.de
Reported-by: Clark Williams <williams@redhat.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 2eed77fdcb0c ("kcov: fix data corruption and race conditions on PREEMPT_RT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kcov.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -88,6 +88,7 @@ static struct list_head kcov_remote_area
 
 struct kcov_percpu_data {
 	void			*irq_area;
+	local_lock_t		lock;
 
 	unsigned int		saved_mode;
 	unsigned int		saved_size;
@@ -96,7 +97,9 @@ struct kcov_percpu_data {
 	int			saved_sequence;
 };
 
-static DEFINE_PER_CPU(struct kcov_percpu_data, kcov_percpu_data);
+static DEFINE_PER_CPU(struct kcov_percpu_data, kcov_percpu_data) = {
+	.lock = INIT_LOCAL_LOCK(lock),
+};
 
 /* Must be called with kcov_remote_lock locked. */
 static struct kcov_remote *kcov_remote_find(u64 handle)
@@ -834,7 +837,7 @@ void kcov_remote_start(u64 handle)
 	if (!in_task() && !in_softirq_really())
 		return;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&kcov_percpu_data.lock, flags);
 
 	/*
 	 * Check that kcov_remote_start() is not called twice in background
@@ -842,7 +845,7 @@ void kcov_remote_start(u64 handle)
 	 */
 	mode = READ_ONCE(t->kcov_mode);
 	if (WARN_ON(in_task() && kcov_mode_enabled(mode))) {
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 		return;
 	}
 	/*
@@ -851,14 +854,15 @@ void kcov_remote_start(u64 handle)
 	 * happened while collecting coverage from a background thread.
 	 */
 	if (WARN_ON(in_serving_softirq() && t->kcov_softirq)) {
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 		return;
 	}
 
 	spin_lock(&kcov_remote_lock);
 	remote = kcov_remote_find(handle);
 	if (!remote) {
-		spin_unlock_irqrestore(&kcov_remote_lock, flags);
+		spin_unlock(&kcov_remote_lock);
+		local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 		return;
 	}
 	kcov_debug("handle = %llx, context: %s\n", handle,
@@ -879,19 +883,19 @@ void kcov_remote_start(u64 handle)
 		size = CONFIG_KCOV_IRQ_AREA_SIZE;
 		area = this_cpu_ptr(&kcov_percpu_data)->irq_area;
 	}
-	spin_unlock_irqrestore(&kcov_remote_lock, flags);
+	spin_unlock(&kcov_remote_lock);
 
 	/* Can only happen when in_task(). */
 	if (!area) {
+		local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 		area = vmalloc(size * sizeof(unsigned long));
 		if (!area) {
 			kcov_put(kcov);
 			return;
 		}
+		local_lock_irqsave(&kcov_percpu_data.lock, flags);
 	}
 
-	local_irq_save(flags);
-
 	/* Reset coverage size. */
 	*(u64 *)area = 0;
 
@@ -901,7 +905,7 @@ void kcov_remote_start(u64 handle)
 	}
 	kcov_start(t, kcov, size, area, mode, sequence);
 
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 
 }
 EXPORT_SYMBOL(kcov_remote_start);
@@ -975,12 +979,12 @@ void kcov_remote_stop(void)
 	if (!in_task() && !in_softirq_really())
 		return;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&kcov_percpu_data.lock, flags);
 
 	mode = READ_ONCE(t->kcov_mode);
 	barrier();
 	if (!kcov_mode_enabled(mode)) {
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 		return;
 	}
 	/*
@@ -988,12 +992,12 @@ void kcov_remote_stop(void)
 	 * actually found the remote handle and started collecting coverage.
 	 */
 	if (in_serving_softirq() && !t->kcov_softirq) {
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 		return;
 	}
 	/* Make sure that kcov_softirq is only set when in softirq. */
 	if (WARN_ON(!in_serving_softirq() && t->kcov_softirq)) {
-		local_irq_restore(flags);
+		local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 		return;
 	}
 
@@ -1023,7 +1027,7 @@ void kcov_remote_stop(void)
 		spin_unlock(&kcov_remote_lock);
 	}
 
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
 
 	/* Get in kcov_remote_start(). */
 	kcov_put(kcov);


