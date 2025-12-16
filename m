Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E763935C191;
	Tue, 16 Dec 2025 12:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886741; cv=none; b=Hi32T6KgCBg8aJE/fn1WRfMqG3UlefpnpJlKXNnuP+Cns10TT2+JUw5luyBQlM2Xy7N5uzijO4XP4eZHWoEK3YUpG6Ae2fz6zPhJSZeJwPddn9Pri1LkyhluQmQdvdoMLNjwkveIaDkCONHWiv1vlBaYIVreclcPg6lIUY3VLnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886741; c=relaxed/simple;
	bh=7C6MZHZqFKXCMqOpXdpPhH18QlEp2HRJfhRQVRWk8q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSmiwm9JsvoaQ9UcIYjcmOIUFBwQQegeAsj4DL2EJBvAUIZ/KhMtl6SKdhPAj+fLi0q6fsvA+zPI9lRZyyW9MQRv/Pt4ZcOvsmcgAzRqvyikKEEDdQhLgv/sp+7hHPv9s6jAD6QRmCARZA7oorP0HV7+EB/jBu1uYZ7qcUHgQgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCuJiihQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCuJiihQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08698C4CEF1;
	Tue, 16 Dec 2025 12:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886740;
	bh=7C6MZHZqFKXCMqOpXdpPhH18QlEp2HRJfhRQVRWk8q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCuJiihQq48yYC6/12VYeQV/zEh3To0MY1rDzgfBb2Dt6bvXAPmr+WinkyTAtr6fT
	 1DK8KoO8xv9RaYAIj2pWLJaHCRHPuFyifGolq3gpigWOYTWf6vZ1INguz/6yYojK/E
	 eeYUkss6t79kAtfzCzzdAQ6HKataNe6hxsaeUmsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/614] bpf: Fix sleepable context for async callbacks
Date: Tue, 16 Dec 2025 12:06:26 +0100
Message-ID: <20251216111402.000186331@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 469d638d1520a9332cd0d034690e75e845610a51 ]

Fix the BPF verifier to correctly determine the sleepable context of
async callbacks based on the async primitive type rather than the arming
program's context.

The bug is in in_sleepable() which uses OR logic to check if the current
execution context is sleepable. When a sleepable program arms a timer
callback, the callback's state correctly has in_sleepable=false, but
in_sleepable() would still return true due to env->prog->sleepable being
true. This incorrectly allows sleepable helpers like
bpf_copy_from_user() inside timer callbacks when armed from sleepable
programs, even though timer callbacks always execute in non-sleepable
context.

Fix in_sleepable() to rely solely on env->cur_state->in_sleepable, and
initialize state->in_sleepable to env->prog->sleepable in
do_check_common() for the main program entry. This ensures the sleepable
context is properly tracked per verification state rather than being
overridden by the program's sleepability.

The env->cur_state NULL check in in_sleepable() was only needed for
do_misc_fixups() which runs after verification when env->cur_state is
set to NULL. Update do_misc_fixups() to use env->prog->sleepable
directly for the storage_get_function check, and remove the redundant
NULL check from in_sleepable().

Introduce is_async_cb_sleepable() helper to explicitly determine async
callback sleepability based on the primitive type:
  - bpf_timer callbacks are never sleepable
  - bpf_wq and bpf_task_work callbacks are always sleepable

Add verifier_bug() check to catch unhandled async callback types,
ensuring future additions cannot be silently mishandled. Move the
is_task_work_add_kfunc() forward declaration to the top alongside other
callback-related helpers. We update push_async_cb() to adjust to the new
changes.

At the same time, while simplifying in_sleepable(), we notice a problem
in do_misc_fixups. Fix storage_get helpers to use GFP_ATOMIC when called
from non-sleepable contexts within sleepable programs, such as bpf_timer
callbacks.

Currently, the check in do_misc_fixups assumes that env->prog->sleepable,
previously in_sleepable(env) which only resolved to this check before
last commit, holds across the program's execution, but that is not true.
Instead, the func_atomic bit must be set whenever we see the function
being called in an atomic context. Previously, this is being done when
the helper is invoked in atomic contexts in sleepable programs, we can
simply just set the value to true without doing an in_sleepable() check.

We must also do a standalone in_sleepable() check to handle cases where
the async callback itself is armed from a sleepable program, but is
itself non-sleepable (e.g., timer callback) and invokes such a helper,
thus needing the func_atomic bit to be true for the said call.

Adjust do_misc_fixups() to drop any checks regarding sleepable nature of
the program, and just depend on the func_atomic bit to decide which GFP
flag to pass.

Fixes: 81f1d7a583fa ("bpf: wq: add bpf_wq_set_callback_impl")
Fixes: b00fa38a9c1c ("bpf: Enable non-atomic allocations in local storage")
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20251007220349.3852807-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index fbe4bb91c564a..460107b0449fe 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -515,6 +515,7 @@ static bool is_callback_calling_kfunc(u32 btf_id);
 static bool is_bpf_throw_kfunc(struct bpf_insn *insn);
 
 static bool is_bpf_wq_set_callback_impl_kfunc(u32 btf_id);
+static bool is_task_work_add_kfunc(u32 func_id);
 
 static bool is_sync_callback_calling_function(enum bpf_func_id func_id)
 {
@@ -547,6 +548,21 @@ static bool is_async_callback_calling_insn(struct bpf_insn *insn)
 	       (bpf_pseudo_kfunc_call(insn) && is_async_callback_calling_kfunc(insn->imm));
 }
 
+static bool is_async_cb_sleepable(struct bpf_verifier_env *env, struct bpf_insn *insn)
+{
+	/* bpf_timer callbacks are never sleepable. */
+	if (bpf_helper_call(insn) && insn->imm == BPF_FUNC_timer_set_callback)
+		return false;
+
+	/* bpf_wq and bpf_task_work callbacks are always sleepable. */
+	if (bpf_pseudo_kfunc_call(insn) && insn->off == 0 &&
+	    (is_bpf_wq_set_callback_impl_kfunc(insn->imm) || is_task_work_add_kfunc(insn->imm)))
+		return true;
+
+	verifier_bug(env, "unhandled async callback in is_async_cb_sleepable");
+	return false;
+}
+
 static bool is_may_goto_insn(struct bpf_insn *insn)
 {
 	return insn->code == (BPF_JMP | BPF_JCOND) && insn->src_reg == BPF_MAY_GOTO;
@@ -5826,8 +5842,7 @@ static int map_kptr_match_type(struct bpf_verifier_env *env,
 
 static bool in_sleepable(struct bpf_verifier_env *env)
 {
-	return env->prog->sleepable ||
-	       (env->cur_state && env->cur_state->in_sleepable);
+	return env->cur_state->in_sleepable;
 }
 
 /* The non-sleepable programs and sleepable programs with explicit bpf_rcu_read_lock()
@@ -10368,8 +10383,6 @@ typedef int (*set_callee_state_fn)(struct bpf_verifier_env *env,
 				   struct bpf_func_state *callee,
 				   int insn_idx);
 
-static bool is_task_work_add_kfunc(u32 func_id);
-
 static int set_callee_state(struct bpf_verifier_env *env,
 			    struct bpf_func_state *caller,
 			    struct bpf_func_state *callee, int insn_idx);
@@ -10588,8 +10601,7 @@ static int push_callback_call(struct bpf_verifier_env *env, struct bpf_insn *ins
 		env->subprog_info[subprog].is_async_cb = true;
 		async_cb = push_async_cb(env, env->subprog_info[subprog].start,
 					 insn_idx, subprog,
-					 is_bpf_wq_set_callback_impl_kfunc(insn->imm) ||
-					 is_task_work_add_kfunc(insn->imm));
+					 is_async_cb_sleepable(env, insn));
 		if (!async_cb)
 			return -EFAULT;
 		callee = async_cb->frame[0];
@@ -11428,7 +11440,7 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			return -EINVAL;
 		}
 
-		if (in_sleepable(env) && is_storage_get_function(func_id))
+		if (is_storage_get_function(func_id))
 			env->insn_aux_data[insn_idx].storage_get_func_atomic = true;
 	}
 
@@ -11439,7 +11451,7 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			return -EINVAL;
 		}
 
-		if (in_sleepable(env) && is_storage_get_function(func_id))
+		if (is_storage_get_function(func_id))
 			env->insn_aux_data[insn_idx].storage_get_func_atomic = true;
 	}
 
@@ -11450,10 +11462,17 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 			return -EINVAL;
 		}
 
-		if (in_sleepable(env) && is_storage_get_function(func_id))
+		if (is_storage_get_function(func_id))
 			env->insn_aux_data[insn_idx].storage_get_func_atomic = true;
 	}
 
+	/*
+	 * Non-sleepable contexts in sleepable programs (e.g., timer callbacks)
+	 * are atomic and must use GFP_ATOMIC for storage_get helpers.
+	 */
+	if (!in_sleepable(env) && is_storage_get_function(func_id))
+		env->insn_aux_data[insn_idx].storage_get_func_atomic = true;
+
 	meta.func_id = func_id;
 	/* check args */
 	for (i = 0; i < MAX_BPF_FUNC_REG_ARGS; i++) {
@@ -22485,8 +22504,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 		}
 
 		if (is_storage_get_function(insn->imm)) {
-			if (!in_sleepable(env) ||
-			    env->insn_aux_data[i + delta].storage_get_func_atomic)
+			if (env->insn_aux_data[i + delta].storage_get_func_atomic)
 				insn_buf[0] = BPF_MOV64_IMM(BPF_REG_5, (__force __s32)GFP_ATOMIC);
 			else
 				insn_buf[0] = BPF_MOV64_IMM(BPF_REG_5, (__force __s32)GFP_KERNEL);
@@ -23156,6 +23174,7 @@ static int do_check_common(struct bpf_verifier_env *env, int subprog)
 	state->curframe = 0;
 	state->speculative = false;
 	state->branches = 1;
+	state->in_sleepable = env->prog->sleepable;
 	state->frame[0] = kzalloc(sizeof(struct bpf_func_state), GFP_KERNEL_ACCOUNT);
 	if (!state->frame[0]) {
 		kfree(state);
-- 
2.51.0



