Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020878;
	b=lHqV9qKvSloUCKGVGAA0IrzT7RxtMCRqYpfTEloPLWGHYPT/IvxNYK03zau0FfXS7mnP
	 S3m4WM7nbnjMxF2pu6UsdailtyhW2pkPfF/PsPUKakNd1DKrsBHUR+9TuO/BUMXbk4DXk
	 ssTsszupQI/rdbfz7Ijk4mVYcW5noFrFh33q+KkGMt4aXIbGl+DPLK1/CvnWzrcBtALVD
	 lPkR3Q8ghXNsjRGBEUCxos3IHF+TI+C4EoKqbhmUV/7Uvh5Z3CXH4Hrtw9SyR8ew1/FLq
	 +c8Cq4QOrErYr3+ZvstBtTQeyXADAmC7tsfdxXulZwsdBanz5bJ7wWQQ3WFjOYkVFkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2/gzfpMRTLFeqEm2DdJ4XulK4iXXqO5mi9CC4Lik2os=;
	b=XA9LEvM7yGFs6hWgWUN6v5Hty73SnC4Vlewhy1A5T9Y9HR/bwPxgy0wELfvpOECp4iOk
	 LMZYjlBKlstN+S6toXJ8oJWwiqgdQzz0z2/TG22yWKver+mwwyCefeUihVjlfkxZWCadQ
	 tXHlIrrv5Kyeih4zmffCSdohgtXGs3LV6F2GXNgut0t9o+lT/NCuD9+CxE/Hsd+yCuhwP
	 9GBElKNOhla2D3ekQFQPkP/LhD0RqBag/dxER8E/vqmVc02KJKFapksQjkJeCzuaCd+W1
	 1CyPsbdwYwwifalh0I4NwzzcJ0K95FiXUgcvnrpXFT3qM86SpFmEFaWfr9wU6hWWkUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hUIvwWCA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FC6606A332;
	Wed, 18 Nov 2026 16:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hUIvwWCA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFCF1F000C9;
	Wed, 18 Nov 2026 16:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020878;
	bh=2/gzfpMRTLFeqEm2DdJ4XulK4iXXqO5mi9CC4Lik2os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hUIvwWCAKo6PFIgvi7EYEsmSH5+UTAV1z/fBtzbkJRoDiGqb6RcdmEhS9KoAdVjQJ
	 DNKi8tgGNec9x1Y2A88ctAvQ4ngukAhdyrGn03+vuuFIBZ7cGidC/P2+4U+/nJSOsT
	 uA3pXxoTa+0CQSw7oC8pzdb2mQ30MJB/zhnVRryk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2109/2651] bpf: Keep a program until its bpf_wq callback has ended
Date: Wed, 18 Nov 2026 15:55:49 +0100
Message-ID: <20261118150401.885705285@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 1e28a5e52d32b7d3f4c9fb24898774f941166d2b ]

bpf_wq_work() runs the callback under rcu_read_lock_trace() only, since
the callback may sleep.  The program it belongs to need not be sleepable,
and such a program is freed behind a plain RCU grace period.  The
reference that the bpf_wq holds is dropped when the map element goes, or
when another callback is set, no matter whether the work is running.

If that was the last reference the program is freed under the running
callback, and the worker goes on in the freed JIT image:

  Oops: int3: 0000 [#1] SMP NOPTI
  RIP: 0010:0xffffffffc0600947

All it takes is to close the map and the program while the callback runs.

Note in the program that it has a callback that runs sleepable, and wait
for an RCU Tasks Trace grace period, which implies a plain one, before
such a program is freed.  Let bpf_wq_work() enter its read side critical
section before it reads callback_fn.

bpf_task_work holds a reference to the program until the callback is done.

Fixes: 8e83da9732d9 ("bpf: add bpf_wq_start")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-23-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h   | 10 ++++++++++
 kernel/bpf/helpers.c  |  9 ++++++---
 kernel/bpf/syscall.c  |  4 ++--
 kernel/bpf/verifier.c |  2 ++
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b13b751d9a4f2..0876bc8461784 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1807,6 +1807,7 @@ struct bpf_prog_aux {
 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
 	bool attach_tracing_prog; /* true if tracing another tracing program */
 	bool tramp_linked; /* true if it was ever linked to a trampoline */
+	bool sleepable_async_cb; /* has a bpf_wq or bpf_task_work callback */
 	bool func_proto_unreliable;
 	bool tail_call_reachable;
 	bool xdp_has_frags;
@@ -1940,6 +1941,15 @@ struct bpf_prog {
 	};
 };
 
+/*
+ * Does the program, or a callback of it, run under RCU Tasks Trace protection
+ * only, outside of any RCU read side critical section?
+ */
+static inline bool bpf_prog_runs_sleepable(const struct bpf_prog *prog)
+{
+	return prog->sleepable || prog->aux->sleepable_async_cb;
+}
+
 struct bpf_array_aux {
 	/* Programs with direct jumps into programs part of this array. */
 	struct list_head poke_progs;
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 2a5af794968b1..44dce0730476d 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1224,18 +1224,21 @@ static void bpf_wq_work(struct work_struct *work)
 
 	BTF_TYPE_EMIT(struct bpf_wq);
 
+	/* keeps the program that callback_fn belongs to */
+	rcu_read_lock_trace();
+
 	callback_fn = READ_ONCE(cb->callback_fn);
 	if (!callback_fn)
-		return;
+		goto out;
 
 	key = map_key_from_value(map, value, &idx);
 
-        rcu_read_lock_trace();
-        migrate_disable();
+	migrate_disable();
 
 	callback_fn((u64)(long)map, (u64)(long)key, (u64)(long)value, 0, 0);
 
 	migrate_enable();
+out:
 	rcu_read_unlock_trace();
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 83648077c9673..3a11d7233a3e4 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2465,7 +2465,7 @@ static void __bpf_prog_put_rcu_tasks(struct rcu_head *rcu)
 {
 	struct bpf_prog *prog = container_of(rcu, struct bpf_prog_aux, rcu)->prog;
 
-	if (prog->sleepable)
+	if (bpf_prog_runs_sleepable(prog))
 		call_rcu_tasks_trace(rcu, __bpf_prog_put_rcu);
 	else
 		call_rcu(rcu, __bpf_prog_put_rcu);
@@ -2485,7 +2485,7 @@ static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
 	if (deferred) {
 		if (IS_ENABLED(CONFIG_TASKS_RCU) && prog->aux->tramp_linked)
 			call_rcu_tasks(&prog->aux->rcu, __bpf_prog_put_rcu_tasks);
-		else if (prog->sleepable)
+		else if (bpf_prog_runs_sleepable(prog))
 			call_rcu_tasks_trace(&prog->aux->rcu, __bpf_prog_put_rcu);
 		else
 			call_rcu(&prog->aux->rcu, __bpf_prog_put_rcu);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9b2f20392d075..327b6d5025a43 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9953,6 +9953,8 @@ static int push_callback_call(struct bpf_verifier_env *env, struct bpf_insn *ins
 					 is_async_cb_sleepable(env, insn));
 		if (IS_ERR(async_cb))
 			return PTR_ERR(async_cb);
+		if (is_async_cb_sleepable(env, insn))
+			env->prog->aux->sleepable_async_cb = true;
 		callee = async_cb->frame[0];
 		callee->async_entry_cnt = state->frame[0]->async_entry_cnt + 1;
 
-- 
2.53.0



