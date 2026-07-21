Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D29395D8E;
	Tue, 21 Jul 2026 20:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664421; cv=none; b=aw211y1gAxdbeqD6ZUVGHPFr69GEgcRBa9MXLVUOZTEaU3WkXWqDxFs1x/O4Bd0R9c4gDVC3OE3LseJ5WVD9u66NDedfgjQ6egZsezARUyrq68xXSin+qmWQq0CXDpKBGatgbNt75aYC1kxnmIbzyxLjVvMvHxWJMkpaOs9ScU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664421; c=relaxed/simple;
	bh=kERECc3vjN6WM6kG2BuIwTY4/nKGHygk8fKvKmdsc1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjdIA6PNZND9NWzYeoVcOo9VjNpqzXUYAn5dRk3kJafL3BoQfMdGgujuKUs0UN3a4OV5uCQMeG51QN124TH0VtZHt4KQSPWTyKyTFfHmQ4gIp3MuEKrAHXFQxAWPqSz0CH2xyiMUJfW81CuUvP+umaqfBWZRx2pkno+f6Sy+2Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oyWF20yo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oyWF20yo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CFA1F000E9;
	Tue, 21 Jul 2026 20:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664416;
	bh=BSRagHXhAQwzbvFoERCKzwoSutj1LxFZg1yFgAyhYQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oyWF20yoAuUMptxy8TI1WTpJBC5ZRRZx9tlbNTDsWvPzreBclLNFcWIKQZNK0jCLj
	 GG+TW0nYn9oDa5dm9yVf+9a9sb7FCg4FF93KGtEt5tE4BVchBFaqjHXRldLF1P3fbA
	 qaFbwWYvBlIdbn59O8E7p8do3OWxbjw3EysGl3w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 6.12 1191/1276] seqlock: Introduce scoped_seqlock_read()
Date: Tue, 21 Jul 2026 17:27:14 +0200
Message-ID: <20260721152512.700864652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit cc39f3872c0865bef992b713338df369554fa9e0 ]

The read_seqbegin/need_seqretry/done_seqretry API is cumbersome and
error prone. With the new helper the "typical" code like

	int seq, nextseq;
	unsigned long flags;

	nextseq = 0;
	do {
		seq = nextseq;
		flags = read_seqbegin_or_lock_irqsave(&seqlock, &seq);

		// read-side critical section

		nextseq = 1;
	} while (need_seqretry(&seqlock, seq));
	done_seqretry_irqrestore(&seqlock, seq, flags);

can be rewritten as

	scoped_seqlock_read (&seqlock, ss_lock_irqsave) {
		// read-side critical section
	}

Original idea by Oleg Nesterov; with contributions from Linus.

Originally-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Stable-dep-of: 6650527444da ("proc: protect ptrace_may_access() with exec_update_lock (part 1)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/seqlock.h |  111 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 111 insertions(+)

--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -1186,4 +1186,115 @@ done_seqretry_irqrestore(seqlock_t *lock
 	if (seq & 1)
 		read_sequnlock_excl_irqrestore(lock, flags);
 }
+
+enum ss_state {
+	ss_done = 0,
+	ss_lock,
+	ss_lock_irqsave,
+	ss_lockless,
+};
+
+struct ss_tmp {
+	enum ss_state	state;
+	unsigned long	data;
+	spinlock_t	*lock;
+	spinlock_t	*lock_irqsave;
+};
+
+static inline void __scoped_seqlock_cleanup(struct ss_tmp *sst)
+{
+	if (sst->lock)
+		spin_unlock(sst->lock);
+	if (sst->lock_irqsave)
+		spin_unlock_irqrestore(sst->lock_irqsave, sst->data);
+}
+
+extern void __scoped_seqlock_invalid_target(void);
+
+#if defined(CONFIG_CC_IS_GCC) && CONFIG_GCC_VERSION < 90000
+/*
+ * For some reason some GCC-8 architectures (nios2, alpha) have trouble
+ * determining that the ss_done state is impossible in __scoped_seqlock_next()
+ * below.
+ */
+static inline void __scoped_seqlock_bug(void) { }
+#else
+/*
+ * Canary for compiler optimization -- if the compiler doesn't realize this is
+ * an impossible state, it very likely generates sub-optimal code here.
+ */
+extern void __scoped_seqlock_bug(void);
+#endif
+
+static inline void
+__scoped_seqlock_next(struct ss_tmp *sst, seqlock_t *lock, enum ss_state target)
+{
+	switch (sst->state) {
+	case ss_done:
+		__scoped_seqlock_bug();
+		return;
+
+	case ss_lock:
+	case ss_lock_irqsave:
+		sst->state = ss_done;
+		return;
+
+	case ss_lockless:
+		if (!read_seqretry(lock, sst->data)) {
+			sst->state = ss_done;
+			return;
+		}
+		break;
+	}
+
+	switch (target) {
+	case ss_done:
+		__scoped_seqlock_invalid_target();
+		return;
+
+	case ss_lock:
+		sst->lock = &lock->lock;
+		spin_lock(sst->lock);
+		sst->state = ss_lock;
+		return;
+
+	case ss_lock_irqsave:
+		sst->lock_irqsave = &lock->lock;
+		spin_lock_irqsave(sst->lock_irqsave, sst->data);
+		sst->state = ss_lock_irqsave;
+		return;
+
+	case ss_lockless:
+		sst->data = read_seqbegin(lock);
+		return;
+	}
+}
+
+#define __scoped_seqlock_read(_seqlock, _target, _s)			\
+	for (struct ss_tmp _s __cleanup(__scoped_seqlock_cleanup) =	\
+	     { .state = ss_lockless, .data = read_seqbegin(_seqlock) };	\
+	     _s.state != ss_done;					\
+	     __scoped_seqlock_next(&_s, _seqlock, _target))
+
+/**
+ * scoped_seqlock_read (lock, ss_state) - execute the read side critical
+ *                                        section without manual sequence
+ *                                        counter handling or calls to other
+ *                                        helpers
+ * @lock: pointer to seqlock_t protecting the data
+ * @ss_state: one of {ss_lock, ss_lock_irqsave, ss_lockless} indicating
+ *            the type of critical read section
+ *
+ * Example:
+ *
+ *     scoped_seqlock_read (&lock, ss_lock) {
+ *         // read-side critical section
+ *     }
+ *
+ * Starts with a lockess pass first. If it fails, restarts the critical
+ * section with the lock held.
+ */
+#define scoped_seqlock_read(_seqlock, _target)				\
+	__scoped_seqlock_read(_seqlock, _target, __UNIQUE_ID(seqlock))
+
 #endif /* __LINUX_SEQLOCK_H */


