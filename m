Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020817;
	b=wwM3q5h1JGb8mnGvGxiHBHoaOeUtxffb4fPWSIkvN1kd+YprlD+SOfEFs3JULRXE9AxA
	 1vGrctLV0Qpa9+B7JUpoVYf6WU9+PzyjJMcCP78T4noe29k3OGrSz4pwqLmbqNP0OmdbC
	 aXUw5/v1eRnlI1tHRZC3oPQep/PfPGbsc7hyTIL3hzL1aKG8BM3D+7U//29tMfnJb/l2/
	 D8heRMRySOhjv2rYWK6i4vj4xqoFUGVkMtZodOU77KAC0iC16GpjJUs6qLX2k8YPn6Dcg
	 BTTZpfFkjY04GNGGTm3AkyzjG7g2TNRjCUx3Z6CoNfN1f+veS5YcjXwYCPgaUkNN14w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4HivWwvaufbi58eMp3a7wF8K5YUJoDWxv2KHolo1uTc=;
	b=i5OPyzlmaWikg22XIWYR55Vow9Ej6fjTxBa9RCYDR6H1BGGr58Z5i7PETkQ05RC+eidx
	 TOHoSfB+dLBGeZ8MIfBDSsrWIWMajFy2YK3gpDPQEcceawp/kKZM9vrRYLnTNW+neEmNV
	 DgK6zPstUsC20YWRZdHsK06xwcETfRsry5FfYfbWo8eyHq5a7wpb2uT1vdFy8jrbbpG38
	 2CcbB2C+NtWn48DKf+WBpT05APW/xb8ayA8Zm7/alC8txnvmKd4K99STtFCZRY8i2iIaE
	 RePuXf6FeVpq1eK8UGe3Crwc1Q6CTMK9tJwCnk3AhANdXXmAYynZZZyDLhriF6TqRRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QscYg9nm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6E6606A333;
	Wed, 18 Nov 2026 16:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QscYg9nm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4A81F000C4;
	Wed, 18 Nov 2026 16:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020816;
	bh=4HivWwvaufbi58eMp3a7wF8K5YUJoDWxv2KHolo1uTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QscYg9nmFF/h6kmWUKmaqWSon+jbKVKAFpiyY/HfHUP7liDqtyc5jW4DmZ7r5fOS4
	 ihOc2YENB6LE06BklKteT9sBv/r/9ypbD9GIEJ2OO8DsdIecsOvqokAdd6BWo0pzE5
	 jFRFgRQipyMwq1XVjlgw/6mw7ydHfawkC3AiKEkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2085/2651] sched_ext: Fix a bypassed task stalling on a cpu its scheduler has no caps on
Date: Wed, 18 Nov 2026 15:55:25 +0100
Message-ID: <20261118150401.078607987@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 5809f749fbdbaf9c6b34ecbe6d2b413e56eec6e3 ]

A bypassing sub-scheduler's tasks are run by its nearest ancestor that isn't
bypassing. The ancestor puts them on the local DSQ under its own caps.
Whether such a task may stay on the cpu and whether a cap revoke reenqueues
it are still checked against the caps of the task's own scheduler.

The bypass load balancer moves tasks between cpus without looking at caps,
so a bypassed task can run on a cpu where its own scheduler holds none. Once
its slice runs out, it can't stay. It goes to the ancestor's bypass DSQ
without a kick, and the cpu can go idle with it queued until something else
reschedules the cpu.

Make both checks against the caps of the scheduler running the task. When
bypass lifts, the running task keeps its slice without a cap check, so evict
it then if it can't stay on the cpu.

Fixes: 75a8c8202c91 ("sched_ext: Add reject DSQ for cap-rejected dispatches")
Fixes: 46a85ae6fe5b ("sched_ext: Tie cpu occupancy to SCX_CAP_BASE through the task slice")
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c      | 21 ++++++++++++---------
 kernel/sched/ext/internal.h | 17 +++++++++++++++++
 kernel/sched/ext/sub.c      |  7 +++++--
 kernel/sched/ext/sub.h      |  6 +++++-
 4 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index df445fdaeb6d6..30198a4db2b9d 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -322,7 +322,6 @@ static const struct sched_class *scx_setscheduler_class(struct task_struct *p)
 
 static struct scx_dispatch_q *bypass_enq_target_dsq(struct scx_sched *sch, s32 cpu)
 {
-#ifdef CONFIG_EXT_SUB_SCHED
 	/*
 	 * If @sch is a sub-sched which is bypassing, its tasks should go into
 	 * the bypass DSQs of the nearest ancestor which is not bypassing. The
@@ -334,11 +333,7 @@ static struct scx_dispatch_q *bypass_enq_target_dsq(struct scx_sched *sch, s32 c
 	 * are re-enqueued after scx_bypassing() is turned on, guaranteeing that
 	 * all tasks are transferred to the right DSQs.
 	 */
-	while (scx_parent(sch) && scx_bypassing(sch, cpu))
-		sch = scx_parent(sch);
-#endif	/* CONFIG_EXT_SUB_SCHED */
-
-	return scx_bypass_dsq(sch, cpu);
+	return scx_bypass_dsq(scx_exec_sched(sch, cpu), cpu);
 }
 
 /**
@@ -6364,11 +6359,19 @@ void scx_bypass(struct scx_sched *sch, bool bypass)
 		 * Bypass trumps protection. Cycling the queued tasks below
 		 * clears theirs. The current task isn't on the runnable list,
 		 * so strip its protection here.
+		 *
+		 * When bypass lifts, the current task keeps running on its
+		 * slice without a cap check. Evict it if it can't stay on the
+		 * cpu.
 		 */
 		p = rq->curr;
-		if (bypass && p->sched_class == &ext_sched_class &&
-		    scx_is_descendant(scx_task_sched(p), sch))
-			scx_task_slice_ended(rq, p);
+		if (p->sched_class == &ext_sched_class &&
+		    scx_is_descendant(scx_task_sched(p), sch)) {
+			if (bypass)
+				scx_task_slice_ended(rq, p);
+			else if (!scx_task_can_stay_on_cpu(rq, p))
+				scx_set_task_slice(p, 0);
+		}
 
 		/*
 		 * The use of list_for_each_entry_safe_reverse() is required
diff --git a/kernel/sched/ext/internal.h b/kernel/sched/ext/internal.h
index b9658b35bf966..a0619c941e91b 100644
--- a/kernel/sched/ext/internal.h
+++ b/kernel/sched/ext/internal.h
@@ -2546,4 +2546,21 @@ static inline struct scx_sched *scx_parent(struct scx_sched *sch) { return NULL;
 
 #endif	/* CONFIG_EXT_SUB_SCHED */
 
+/**
+ * scx_exec_sched - Find the sched running @sch's tasks on @cpu
+ * @sch: sched owning the tasks
+ * @cpu: cpu of interest
+ *
+ * A bypassing sched's tasks are run by its nearest ancestor that isn't
+ * bypassing. Return @sch if it isn't bypassing on @cpu, otherwise that
+ * ancestor, or the root if every ancestor is bypassing. Hold @cpu's rq lock for
+ * a stable answer.
+ */
+static inline struct scx_sched *scx_exec_sched(struct scx_sched *sch, s32 cpu)
+{
+	while (scx_parent(sch) && scx_bypassing(sch, cpu))
+		sch = scx_parent(sch);
+	return sch;
+}
+
 #endif /* _KERNEL_SCHED_EXT_INTERNAL_H */
diff --git a/kernel/sched/ext/sub.c b/kernel/sched/ext/sub.c
index a75b43296dc92..eb345df340f59 100644
--- a/kernel/sched/ext/sub.c
+++ b/kernel/sched/ext/sub.c
@@ -755,18 +755,21 @@ struct scx_dispatch_q *scx_resolve_local_dsq(struct scx_sched *sch, struct rq *r
 /* @p lost the caps needed to stay on @rq's local DSQ? Record reason if so. */
 bool scx_task_reenq_on_cap_revoke(struct rq *rq, struct task_struct *p)
 {
+	s32 cpu = cpu_of(rq);
 	u64 missing;
 
 	/* migration-disabled tasks and the rescuee are admitted capless */
 	if (is_migration_disabled(p) || p == scx_rescuee(rq))
 		return false;
 
-	missing = scx_missing_caps(scx_task_sched(p), cpu_of(rq), scx_caps_for_task(p));
+	/* check caps against the sched running a bypassed task */
+	missing = scx_missing_caps(scx_exec_sched(scx_task_sched(p), cpu), cpu,
+				   scx_caps_for_task(p));
 	if (likely(!missing))
 		return false;
 
 	p->scx.reenq_reason_caps = missing;
-	p->scx.reenq_reason_cid = __scx_cpu_to_cid(cpu_of(rq));
+	p->scx.reenq_reason_cid = __scx_cpu_to_cid(cpu);
 	return true;
 }
 
diff --git a/kernel/sched/ext/sub.h b/kernel/sched/ext/sub.h
index f7bcdfda8dd85..0ac7b8e592050 100644
--- a/kernel/sched/ext/sub.h
+++ b/kernel/sched/ext/sub.h
@@ -199,6 +199,8 @@ static inline u64 scx_caps_implied(u64 cap)
 /* may @p keep running on @rq's cpu? requires baseline cpu access */
 static inline bool scx_task_can_stay_on_cpu(struct rq *rq, struct task_struct *p)
 {
+	s32 cpu = cpu_of(rq);
+
 	if (!scx_has_subs())
 		return true;
 
@@ -206,7 +208,9 @@ static inline bool scx_task_can_stay_on_cpu(struct rq *rq, struct task_struct *p
 	if (unlikely(is_migration_disabled(p)))
 		return true;
 
-	return likely(!scx_missing_caps(scx_task_sched(p), cpu_of(rq), SCX_CAP_BASE));
+	/* check caps against the sched running a bypassed task */
+	return likely(!scx_missing_caps(scx_exec_sched(scx_task_sched(p), cpu), cpu,
+					SCX_CAP_BASE));
 }
 
 /* the task admitted for rescue on @rq, NULL if none */
-- 
2.53.0



