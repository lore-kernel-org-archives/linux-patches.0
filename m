Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020831;
	b=tQHPMza9F4FKiSajtSLKtJAKsIQiGzPe0NUZ8ML8uhs9FDu22G/1P3VZDDgokQAHW1nc
	 VcpV/YNQCKM+5ixaHoDjKvcdXYvNWVsnKlWV9yHkM9sBdroUOVJeFLFEetFzufJR7kZR+
	 4h4zqlV4DS8y24mnBh6ns0HKqJTM/99tEettJSvO3GaoMtV/UoHkyOSJ73lHQgpcxDOL3
	 9ERfFaMyg1wfQ9KHOetJzcnsU8W04XGhOknUY4Mo2R6UHT+a52N0VggEJyzi+iIMcwQFw
	 N9aRDyVzM25x7r0tZVsxe3POUU+ysg9uJgBd4y6ArqAh+0WvUY80ldgoJu/H0uj9Wdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CA4EXBPdDts8e3zE2sob0638sdqQ3LmUkaVxjW3eguM=;
	b=tmUln0Nn4CektuSmWj4yHmg7740RkZnDXvYOnxMVMIM7xlAvb/PpjN10B1L6LufkkpWo
	 nVnMJcEYEmg0/wHL7p1c+4pYSxrpe5Ll7oLVh5nfpnh92+R8sOOEc1e/DcwNkWFadTMXh
	 rx5ygLPCW/mEJtvE/Fb9ZUGEnYlBLN3Pf5VqEKRlId1ikgl9BUryKESR4ftRQ6TZKepfw
	 qj/eDy4pfre2Gu0/ZAUfHpFGDnhGICEKaglj+Nmg+sNlmtLt2/CARQ9BXVUqyj99+LH99
	 ulf6UiX0Z7fl5Z4TYj//6kkxk5gW883p+MM2l2LuidbXlUg0QLz69/xwd9L1lGJJnNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BJwdd1oY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5909860A2612;
	Wed, 18 Nov 2026 16:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BJwdd1oY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777D31F000C6;
	Wed, 18 Nov 2026 16:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020831;
	bh=CA4EXBPdDts8e3zE2sob0638sdqQ3LmUkaVxjW3eguM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BJwdd1oY4i8CoUkjGPAZHnARakD2uvo+yYUEitD7uP5YArFY0YOB5Mv3qEnTkF7/Q
	 CKxtaq//ub/O5TfRm+ZdJFNA7zbFAzDh9o09WjEy+IHaDvuvpT1d3Mnn1yMlH/SIVu
	 jqf+21DJexQVK8XWgwjIdToOlovFr6PMgW5OQOg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2090/2651] bpf: Forbid sleeping in hash map for_each callbacks
Date: Wed, 18 Nov 2026 15:55:30 +0100
Message-ID: <20261118150401.259199467@linuxfoundation.org>
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

[ Upstream commit 9bdd5e7f5d8313fa1f3a210621b4007bb5ad0ec6 ]

A sleepable program (e.g. SEC("syscall"), lsm.s, fentry.s) can pass a
callback to bpf_for_each_map_elem() on a hash map and call a sleepable
helper or kfunc such as bpf_copy_from_user() from it. The verifier
accepts this, but at run time the callback is invoked from inside an RCU
read-side critical section:

    bpf_for_each_hash_elem()
      rcu_read_lock();
      callback_fn(map, key, val, ctx, 0);
        bpf_copy_from_user()       <- may fault and sleep
      rcu_read_unlock();

bpf_each_rhash_elem() does the same for BPF_MAP_TYPE_RHASH. Sleeping
there triggers the "Voluntary context switch within RCU read-side
critical section!" warning, delays grace periods, and with
CONFIG_PREEMPT_RCU=n silently ends the read-side critical section that
the bucket walk relies on.

Synchronous callbacks are verified with the caller's state, so
kernel/bpf/verifier.c:in_sleepable_context() only looks at the program's
sleepability and the locks the program took itself, and does not know
that the helper holds rcu_read_lock() around the callback.

With a SEC("syscall") program whose callback reads a page that has to be
read from disk first:

  BUG: sleeping function called from invalid context at include/linux/uaccess.h:169
  RCU nest depth: 1, expected: 0
   __might_fault+0x29/0x80
   _copy_from_user+0x26/0x90
   bpf_copy_from_user+0x23/0x60
   bpf_prog_17d44fa39eebd6cc_cb+0x35/0x46
   bpf_for_each_hash_elem+0xdb/0x280

Fix by marking the callback frame of hash map iteration as running under
RCU and making in_sleepable_context() false while such a frame is on the
call stack, so sleepable helpers, kfuncs and global functions are
rejected there as inside bpf_rcu_read_lock(). The rules for trusting RCU
protected pointers are left alone, which is conservative and keeps
callbacks that verify today and do not sleep working. The flag is
compared in func_states_equal() so that pruning never mixes the two
contexts. Array map callbacks run without any lock and keep the caller's
context.

Fixes: 314ee05e2fc6 ("bpf: Add hashtab support for bpf_for_each_map_elem() helper")
Fixes: 818e00848227 ("bpf: Implement iteration ops for resizable hashtab")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-3-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h |  5 +++++
 kernel/bpf/states.c          |  3 +++
 kernel/bpf/verifier.c        | 28 +++++++++++++++++++++++++++-
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index fac29ea44b930..1446091539443 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -337,6 +337,11 @@ struct bpf_func_state {
 	bool in_async_callback_fn;
 	bool in_exception_callback_fn;
 	bool no_stack_arg_load;
+	/*
+	 * The helper invokes this callback under rcu_read_lock(), so the
+	 * callback and its callees run in an RCU read-side critical section.
+	 */
+	bool in_rcu_callback_fn;
 	/* For callback calling functions that limit number of possible
 	 * callback executions (e.g. bpf_loop) keeps track of current
 	 * simulated iteration number.
diff --git a/kernel/bpf/states.c b/kernel/bpf/states.c
index b7ca2e07a807d..f28b11c189085 100644
--- a/kernel/bpf/states.c
+++ b/kernel/bpf/states.c
@@ -952,6 +952,9 @@ static bool func_states_equal(struct bpf_verifier_env *env, struct bpf_func_stat
 	if (!old->no_stack_arg_load && cur->no_stack_arg_load)
 		return false;
 
+	if (old->in_rcu_callback_fn != cur->in_rcu_callback_fn)
+		return false;
+
 	for (i = 0; i < MAX_BPF_REG; i++)
 		if (((1 << i) & live_regs) &&
 		    !regsafe(env, &old->regs[i], &cur->regs[i],
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2ee66a02ac95d..2cb34276313cf 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10172,6 +10172,19 @@ static int set_map_elem_callback_state(struct bpf_verifier_env *env,
 	if (err)
 		return err;
 
+	switch (map->map_type) {
+	case BPF_MAP_TYPE_HASH:
+	case BPF_MAP_TYPE_PERCPU_HASH:
+	case BPF_MAP_TYPE_LRU_HASH:
+	case BPF_MAP_TYPE_LRU_PERCPU_HASH:
+	case BPF_MAP_TYPE_RHASH:
+		/* Hash tables run the callback under rcu_read_lock(). */
+		callee->in_rcu_callback_fn = true;
+		break;
+	default:
+		break;
+	}
+
 	callee->in_callback_fn = true;
 	callee->callback_ret_range = retval_range(0, 1);
 	return 0;
@@ -10869,10 +10882,22 @@ int bpf_get_helper_proto(struct bpf_verifier_env *env, int func_id,
 	return *ptr && (*ptr)->func ? 0 : -EINVAL;
 }
 
+/* Is any frame on the current path a callback that runs under RCU? */
+static bool in_rcu_callback(struct bpf_verifier_env *env)
+{
+	struct bpf_verifier_state *state = env->cur_state;
+	int i;
+
+	for (i = 0; i <= state->curframe; i++)
+		if (state->frame[i]->in_rcu_callback_fn)
+			return true;
+	return false;
+}
+
 /* Check if we're in a sleepable context. */
 static inline bool in_sleepable_context(struct bpf_verifier_env *env)
 {
-	return !in_rcu_cs(env);
+	return !in_rcu_cs(env) && !in_rcu_callback(env);
 }
 
 static const char *non_sleepable_context_description(struct bpf_verifier_env *env)
@@ -10886,6 +10911,7 @@ static const char *non_sleepable_context_description(struct bpf_verifier_env *en
 			return "IRQ-disabled region";
 		if (env->cur_state->active_locks)
 			return "lock region";
+		return "callback running under rcu_read_lock";
 	}
 	return "non-sleepable prog";
 }
-- 
2.53.0



