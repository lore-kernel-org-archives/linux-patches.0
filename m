Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793D2566C6C;
	Wed,  9 Sep 2026 14:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964664; cv=none; b=MIGN/46/4mWh3f2sv+Mgbvr/ks4GY4hkoQ6Pmr6uS7R76J2Xc4YrW2O56xv9HQKrnMnaBsVAFYMKCNRULdM7F4iH9CkWuYwisq7PyzpARzQ5pnPa4/ca6A75gkViunrJQHO3uPPkhVXeBpTDiGuyUY1HYvLOl45t6ZaxL4sP4IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964664; c=relaxed/simple;
	bh=NZp83Kv4WJGp1qvqo7EuS+Od7lXlNWpGERfWKwWiYc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuF2Ss+88bcSi1CzUcby1hk7+Fn4ydagZ4OJYT9nrD7FPQnpuCEUfsvkMfFcWhCHFD0RNTZwKIodHAv+hvtTGYlRQzN34iqWOxxjEzHMwCyNWCJL/7elTwvSpzmjPU4c6slvsqHaOykRddJWv9H+fqv0Uxp7j74RNKxlORe4+qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vd/nI/2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vd/nI/2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D013D1F00A3A;
	Wed,  9 Sep 2026 14:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964663;
	bh=zlvGU/AQs/NfOOmampxwcmbegFuUNmkZKXlzxv/UZ/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vd/nI/2ykEO0TCux1501xnYjDbezHbNPR1dt1hM91QWpyHpmo/y7LaELpR43MQ9Lx
	 Kk95kvQd6eXroLR41itc7aF54aJJM5ug/BlFVoc2+nNVeUpu6CbXiwNTzRQyqVYE9X
	 cvoko3UvnNwNt2DkGm+4z3YT2SSn3qQfsdvo83KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	John Stultz <jstultz@google.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 501/583] sched: Add assert_balance_callbacks_empty helper
Date: Wed,  9 Sep 2026 15:43:06 +0200
Message-ID: <20260909134255.124149710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <jstultz@google.com>

[ Upstream commit f9530b3183358bbf945f7c20d4a6e2048061ec50 ]

With proxy-exec utilizing pick-again logic, we can end up having
balance callbacks set by the preivous pick_next_task() call left
on the list.

So pull the warning out into a helper function, and make sure we
check it when we pick again.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://patch.msgid.link/20260324191337.1841376-8-jstultz@google.com
Stable-dep-of: f3629c63a4af ("sched/core: Make core-sched flips wait for in-flight selections")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c  |    1 +
 kernel/sched/sched.h |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6880,6 +6880,7 @@ static void __sched notrace __schedule(i
 	}
 
 pick_again:
+	assert_balance_callbacks_empty(rq);
 	next = pick_next_task(rq, rq->donor, &rf);
 	rq_set_donor(rq, next);
 	if (unlikely(task_is_blocked(next))) {
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1787,6 +1787,13 @@ static inline void scx_rq_clock_update(s
 static inline void scx_rq_clock_invalidate(struct rq *rq) {}
 #endif /* !CONFIG_SCHED_CLASS_EXT */
 
+static inline void assert_balance_callbacks_empty(struct rq *rq)
+{
+	WARN_ON_ONCE(IS_ENABLED(CONFIG_PROVE_LOCKING) &&
+		     rq->balance_callback &&
+		     rq->balance_callback != &balance_push_callback);
+}
+
 /*
  * Lockdep annotation that avoids accidental unlocks; it's like a
  * sticky/continuous lockdep_assert_held().
@@ -1803,7 +1810,7 @@ static inline void rq_pin_lock(struct rq
 
 	rq->clock_update_flags &= (RQCF_REQ_SKIP|RQCF_ACT_SKIP);
 	rf->clock_update_flags = 0;
-	WARN_ON_ONCE(rq->balance_callback && rq->balance_callback != &balance_push_callback);
+	assert_balance_callbacks_empty(rq);
 }
 
 static inline void rq_unpin_lock(struct rq *rq, struct rq_flags *rf)


