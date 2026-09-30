Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88194513551;
	Wed, 30 Sep 2026 16:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786303; cv=none; b=TqSVlwpuH4+lIvrf0s+4OzIZjXi4JmjvGQck/8XfdKGmgTlCReOPZAeas6iXxKHZiBTZ8I/SUEvHO+ZH5OeuW5ruYQa5towGeTik7y95Kt9pHjtUnLexvmvgmq0sZjsw8Sub+Ns8cGnpzXMiaNKv0gD7WczVH+CuYlsR5e5fJlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786303; c=relaxed/simple;
	bh=q7o1974G+rJGOYCkmA4EERVEqnF6IySywU2YHAm5BoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqgIx4SyoaCont8GDwdEkAE0qYAfJNbmTXa6ZzVVQCerhXmojtwDUjPqH4OvKygZ8GhQxy/7QzJ4EI2819sRl3+g1se44CeVU+Nw6IdUMAQcfoEYt1ruj7YytR5omWbIyz9E91XrVETs8Mj/0KGfxNZI9nSpSa6MxbwoKSNzc7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVlaKYx6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVlaKYx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A224B1F000FF;
	Wed, 30 Sep 2026 16:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786302;
	bh=kVqEG4yZCwy+pTMHMjgkrF3Zdz+QuNIxGCx7BC4NQ7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVlaKYx6D7kBkJpAGgAjUJq9ntLcdPD5W0UjDWXl4hW51cqz7yPKsGQFZP0ShTSpT
	 qAJEy9wfSdEuLeL5GTTQyIxPqV74VVvrSzXfmNWEg1VcyTO+n/ru0lWBCeByWldLno
	 j+ykGzWc9aGLBWQogV98Nq1OoQqyVm8zvlA4ldFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 813/982] bpf: Avoid soft lockup in __htab_map_lookup_and_delete_batch()
Date: Wed, 30 Sep 2026 17:25:49 +0200
Message-ID: <20260930152434.222352709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>

[ Upstream commit 85136bf22404474a815fc0ed26ec0d1cbc1bc3f9 ]

__htab_map_lookup_and_delete_batch() has no rescheduling point. The
batch count bounds how many entries are copied out, not how many
buckets are visited, so one BPF_MAP_LOOKUP_BATCH call can walk the
map end to end. The empty-bucket fast path is worse: it stays inside
a single rcu_read_lock() / bpf_disable_instrumentation() section for
any run of consecutive empty buckets.

That holds up on small maps, but it falls apart at scale. On a
144-CPU arm64 host running a CONFIG_PREEMPT_NONE kernel, periodic
BPF_MAP_LOOKUP_BATCH calls against an LRU hash map with 16,777,216
buckets held a CPU inside the batch op for 77+ seconds and triggered
the soft lockup watchdog.

Commit 75134f16e7dd ("bpf: Add schedule points in batch ops") fixed this
same problem in the generic batch ops, but not in this htab-native path,
which every htab-based hash map variant uses for its lookup[_and_delete]
batch ops.

Complete that fix here. Leave the critical section after 64 consecutive
empty buckets, call cond_resched_tasks_rcu_qs(), and resume at the saved
bucket cursor. No locks are held at that point, and resuming from the
cursor is already the function's behavior for non-empty buckets. Add the
same call to the per-bucket loop after copy_to_user(), where every lock
has been dropped. cond_resched_rcu() is not enough here: sleeping with
bpf_prog_active elevated makes tracing programs on that CPU silently
skip their invocations.

Plain cond_resched() is not enough either. It is a no-op under PREEMPT
and PREEMPT_LAZY, the only models arm64 and x86 have offered since
commit 7dadeaa6e851 ("sched: Further restrict the preemption modes").
It is also never a Tasks RCU quiescent state, in any model: the
reschedule counts as a preemption. The walking task stays a holdout and
stalls every synchronize_rcu_tasks() caller, ftrace and BPF trampoline
teardown included, until the syscall returns [1].
cond_resched_tasks_rcu_qs() is the usual tool for that [2]. It reports
the quiescent state at each yield and still reschedules as
cond_resched() does on PREEMPT_NONE and PREEMPT_VOLUNTARY kernels.

Fixes: 057996380a42 ("bpf: Add batch ops to all htab bpf map")
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Link: https://lore.kernel.org/bpf/20260715215314.44423f47@fangorn/ [1]
Link: https://lore.kernel.org/bpf/9d444098-7c03-4163-af12-bd0a79a51443@paulmck-laptop/ [2]
Assisted-by: LLM
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Link: https://lore.kernel.org/r/20260909-b4-htab-batch-resched-v2-1-0cb529d8f95a@toxicpanda.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index b2f207a5dd4fd..291c2befa120d 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1653,6 +1653,12 @@ static int htab_lru_percpu_map_lookup_and_delete_elem(struct bpf_map *map,
 						 flags);
 }
 
+/*
+ * Max consecutive empty buckets to walk in one RCU +
+ * instrumentation-disabled section before rescheduling.
+ */
+#define HTAB_BATCH_EMPTY_RESCHED 64
+
 static int
 __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 				   const union bpf_attr *attr,
@@ -1674,6 +1680,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 	unsigned long flags = 0;
 	bool locked = false;
 	struct htab_elem *l;
+	u32 empty_cnt = 0;
 	struct bucket *b;
 	int ret = 0;
 
@@ -1839,12 +1846,21 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 	}
 
 next_batch:
-	/* If we are not copying data, we can go to next bucket and avoid
-	 * unlocking the rcu.
+	/*
+	 * If we are not copying data, we can go to next bucket and avoid
+	 * unlocking the rcu. Bound the walk though: after
+	 * HTAB_BATCH_EMPTY_RESCHED consecutive empty buckets, fully exit
+	 * the critical section (no locks are held here) and reschedule.
 	 */
 	if (!bucket_cnt && (batch + 1 < htab->n_buckets)) {
 		batch++;
-		goto again_nocopy;
+		if (++empty_cnt < HTAB_BATCH_EMPTY_RESCHED)
+			goto again_nocopy;
+		empty_cnt = 0;
+		rcu_read_unlock();
+		bpf_enable_instrumentation();
+		cond_resched_tasks_rcu_qs();
+		goto again;
 	}
 
 	rcu_read_unlock();
@@ -1858,11 +1874,13 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 	}
 
 	total += bucket_cnt;
+	empty_cnt = 0;
 	batch++;
 	if (batch >= htab->n_buckets) {
 		ret = -ENOENT;
 		goto after_loop;
 	}
+	cond_resched_tasks_rcu_qs();
 	goto again;
 
 after_loop:
-- 
2.53.0



