Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625416;
	b=jn2D7nb59UgPZfLUur8fwRIhCCQ012Wtvz1X9kesw/JOe6VimajzHIWZORlxUHeVOm9Z
	 NOhwkkxHLzWWwcrS9DR4rlTxi2xV5NWyKc/6Ynq+NL/K11NTA7Q3z9gPiZyMqkl0dch6L
	 PaPLonolxTvhTHlmV7c8G3qn04bBHLaGbGxK2vhQDu5Bjr+En7A/4tSHVzbv0kfuzXMQ8
	 LOTxxccukyMMJ85idkfX/VGyrDRKoP+uuWza4XWNllTNdAn+scRTFfjupXeth7Tl2Ig4y
	 rWH4/00mqvq2sjRrLB2Wz2K8LkXbLH5ieG4TJ34QV8ySBV77sQ7u9MZf3hP5WuHrCLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s4QXhlThYuAGuWZnKEAFWHNFBHce/6M2FzD97iXO790=;
	b=cZgztubNFLd36UlmGy5KdvmbhJ4HFrKowGHMdlCSQiavkI3TMyEYjvoRcXkRwLZYX6dR
	 Rs5lJ89Y4c4Up+h4paLUonshZTNGbOfvoUdBEx09OZjBC1VThnHjEjCewq0t0+bh+RfKA
	 +CueFnqd840QnkPpqZO0HiD0oZiMRU37WQzd81s0w+ZOND502DCU4Bdkn0+jRYCRI/Y6A
	 Om8NDUA3pPYs6K++LT6JSD8k4nYnNKEdXW6ftYVVfyxCZ/QsyljcmKRH0qELJn/8SYVIM
	 iYA68MtHVmqr9Jogb3Ru6RlAvWBp0IsJPksebwoMj+56aSMUPp7B/2YT5mi7jEjYt0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ClREacZn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD8A606A321;
	Wed, 25 Nov 2026 16:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ClREacZn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B161F000C4;
	Wed, 25 Nov 2026 16:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625416;
	bh=s4QXhlThYuAGuWZnKEAFWHNFBHce/6M2FzD97iXO790=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ClREacZnQ8Fql4ZjmDifrYaUa4jZ7NydYHuiFSYPTKZRyaD9Qkvc5Lq4eBDxxfJbH
	 YaEY9EV2TTBAG85xnQB9tR8sXuWYH94iATXRksMc1lh7JgVNs9kMfNwREUQS1dJv4r
	 Mtm83zmSJ9pdo+zaiq0gA+raYS2roCqsy5r+Ab5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 507/816] bpf: Keep a program until its bpf_wq callback has ended
Date: Wed, 25 Nov 2026 15:34:15 +0100
Message-ID: <20261125143900.922273167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced the nonexistent is_async_cb_sleepable() call with is_bpf_wq_set_callback_impl_kfunc(insn->imm), and dropped the tramp_linked and rcu_tasks free-path hunk that this tree lacks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h   | 10 ++++++++++
 kernel/bpf/helpers.c  |  9 ++++++---
 kernel/bpf/syscall.c  |  2 +-
 kernel/bpf/verifier.c |  2 ++
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 59661363d08f6..98f816a37d3be 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1508,6 +1508,7 @@ struct bpf_prog_aux {
 	bool offload_requested; /* Program is bound and offloaded to the netdev. */
 	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
 	bool attach_tracing_prog; /* true if tracing another tracing program */
+	bool sleepable_async_cb; /* has a bpf_wq or bpf_task_work callback */
 	bool func_proto_unreliable;
 	bool tail_call_reachable;
 	bool xdp_has_frags;
@@ -1619,6 +1620,15 @@ struct bpf_prog {
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
index bcb2770efac4d..7ae6acfc14d36 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1209,9 +1209,12 @@ static void bpf_wq_work(struct work_struct *work)
 
 	BTF_TYPE_EMIT(struct bpf_wq);
 
+	/* keeps the program that callback_fn belongs to */
+	rcu_read_lock_trace();
+
 	callback_fn = READ_ONCE(cb->callback_fn);
 	if (!callback_fn)
-		return;
+		goto out;
 
 	if (map->map_type == BPF_MAP_TYPE_ARRAY) {
 		struct bpf_array *array = container_of(map, struct bpf_array, map);
@@ -1223,12 +1226,12 @@ static void bpf_wq_work(struct work_struct *work)
 		key = value - round_up(map->key_size, 8);
 	}
 
-        rcu_read_lock_trace();
-        migrate_disable();
+	migrate_disable();
 
 	callback_fn((u64)(long)map, (u64)(long)key, (u64)(long)value, 0, 0);
 
 	migrate_enable();
+out:
 	rcu_read_unlock_trace();
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index cbdea70fd93a3..3e084cf77d134 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2212,7 +2212,7 @@ static void __bpf_prog_put_noref(struct bpf_prog *prog, bool deferred)
 		btf_put(prog->aux->attach_btf);
 
 	if (deferred) {
-		if (prog->sleepable)
+		if (bpf_prog_runs_sleepable(prog))
 			call_rcu_tasks_trace(&prog->aux->rcu, __bpf_prog_put_rcu);
 		else
 			call_rcu(&prog->aux->rcu, __bpf_prog_put_rcu);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ffd1f13925c29..d8317cef6e8ab 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10174,6 +10174,8 @@ static int push_callback_call(struct bpf_verifier_env *env, struct bpf_insn *ins
 					 is_bpf_wq_set_callback_impl_kfunc(insn->imm));
 		if (IS_ERR(async_cb))
 			return PTR_ERR(async_cb);
+		if (is_bpf_wq_set_callback_impl_kfunc(insn->imm))
+			env->prog->aux->sleepable_async_cb = true;
 		callee = async_cb->frame[0];
 		callee->async_entry_cnt = state->frame[0]->async_entry_cnt + 1;
 
-- 
2.53.0



