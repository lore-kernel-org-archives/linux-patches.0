Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA805B5AB;
	Sat, 17 Oct 2026 16:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253660; cv=none; b=j3bpyVRFIPr+Ykay4pZYnT/SbaV0CTnYHFnEQqFOk96or/u4sxSp2vpseLmF7+S2d+ZE53s3VfAr2YU01YjHmtW2x9juJ/qpr2ZAdCW86k9+ELPC8QdkfI/h+Dbsptlu+S7zVMNRnTjpK7lTfVplCYBcNlK9FncZ+cMLAui70VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253660; c=relaxed/simple;
	bh=9ZEyraDWiGW9f8M664q6jh2o8it3o4wH60ULt88tl4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApLQvL1TM7pGMk9PXwif48/zzJj4nNaejwaQIRu0yb1y6mHITZG8ierzMFOXtq2CuNrb+5Z+uUopLZC6qYV+hxAdasp/U18HDEiUrHl/NhwfPOYnuiMLEARxTzG8sBzaGGObpkOlNShdbQIXZNsC/MzQUFDhw67bQzL47rMy2M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SasKe4zF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SasKe4zF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803B41F000C4;
	Sat, 17 Oct 2026 16:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253659;
	bh=U9Prj6RUaXMLwYURiwFhWnVhQ+sKtiqFSm5hWM8TfPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SasKe4zF155mbCqvBW2JyM/oBKALoc38idQme3JOJyGbfFSJ3+ATKz8ePFAGVJTvR
	 ehVEGiAjfdwVa8N09trqVfcMXgti+VlQVhQ6wydPJRnZ7ktjoItrjifmbLX8FJDuDM
	 3NThjohIoGES7V9j1z3oaSHZOLLmupOsaaSYjMQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 190/869] bpf: Fix exception exit lock checking for subprogs
Date: Sat, 17 Oct 2026 17:50:31 +0200
Message-ID: <20261017160041.926230396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Ihor Solodrai <ihor.solodrai@linux.dev>

[ Upstream commit 6c2128505f61b504c79a20b89596feba61388112 ]

process_bpf_exit_full() passes check_lock = !curframe to
check_resource_leak(), which is false in cases when bpf_throw() is
called from a static subprog. This makes check_resource_leak() to skip
validation of active_rcu_locks, active_preempt_locks, and
active_irq_id on exception exits from subprogs.

At runtime bpf_throw() unwinds the stack via ORC without releasing any
user-acquired locks, which may cause various issues as the result.

Fix by setting check_lock = true for exception exits regardless of
curframe, since exceptions bypass all intermediate frame
cleanup. Update the error message prefix to "bpf_throw" for exception
exits to distinguish them from normal BPF_EXIT.

Fix reject_subprog_with_rcu_read_lock test which was previously
passing for the wrong reason. Test program returned directly from the
subprog call without closing the RCU section, so the error was
triggered by the unclosed RCU lock on normal exit, not by
bpf_throw. Update __msg annotations for affected tests to match the
new "bpf_throw" error prefix.

The spin_lock case is not affected because they are already checked [1]
at the call site in do_check_insn() before bpf_throw can run.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/bpf/verifier.c?h=v7.0-rc4#n21098

Assisted-by: Claude:claude-opus-4-6
Fixes: f18b03fabaa9 ("bpf: Implement BPF exceptions")
Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260320000809.643798-1-ihor.solodrai@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c                         | 26 +++++++++++++------
 .../selftests/bpf/progs/exceptions_fail.c     |  9 ++++---
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2bcd098f774ba..4978c1d68bd98 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -19024,20 +19024,30 @@ static int do_check(struct bpf_verifier_env *env)
 					return -EINVAL;
 				}
 process_bpf_exit_full:
-				if (env->cur_state->active_lock.ptr && !env->cur_state->curframe) {
-					verbose(env, "bpf_spin_unlock is missing\n");
+				if (env->cur_state->active_lock.ptr &&
+				    (exception_exit || !env->cur_state->curframe)) {
+					verbose(env, exception_exit ?
+						"bpf_throw cannot be used inside bpf_spin_lock-ed region\n" :
+						"bpf_spin_unlock is missing\n");
 					return -EINVAL;
 				}
 
-				if (env->cur_state->active_rcu_lock && !env->cur_state->curframe) {
-					verbose(env, "bpf_rcu_read_unlock is missing\n");
+				if (env->cur_state->active_rcu_lock &&
+				    (exception_exit || !env->cur_state->curframe)) {
+					verbose(env, exception_exit ?
+						"bpf_throw cannot be used inside bpf_rcu_read_lock-ed region\n" :
+						"bpf_rcu_read_unlock is missing\n");
 					return -EINVAL;
 				}
 
-				if (env->cur_state->active_preempt_lock && !env->cur_state->curframe) {
-					verbose(env, "%d bpf_preempt_enable%s missing\n",
-						env->cur_state->active_preempt_lock,
-						env->cur_state->active_preempt_lock == 1 ? " is" : "(s) are");
+				if (env->cur_state->active_preempt_lock &&
+				    (exception_exit || !env->cur_state->curframe)) {
+					if (exception_exit)
+						verbose(env, "bpf_throw cannot be used inside bpf_preempt_disable-ed region\n");
+					else
+						verbose(env, "%d bpf_preempt_enable%s missing\n",
+							env->cur_state->active_preempt_lock,
+							env->cur_state->active_preempt_lock == 1 ? " is" : "(s) are");
 					return -EINVAL;
 				}
 
diff --git a/tools/testing/selftests/bpf/progs/exceptions_fail.c b/tools/testing/selftests/bpf/progs/exceptions_fail.c
index 9cceb65211433..d7f1c492e3dd3 100644
--- a/tools/testing/selftests/bpf/progs/exceptions_fail.c
+++ b/tools/testing/selftests/bpf/progs/exceptions_fail.c
@@ -8,6 +8,7 @@
 #include "bpf_experimental.h"
 
 extern void bpf_rcu_read_lock(void) __ksym;
+extern void bpf_rcu_read_unlock(void) __ksym;
 
 #define private(name) SEC(".bss." #name) __hidden __attribute__((aligned(8)))
 
@@ -131,7 +132,7 @@ int reject_subprog_with_lock(void *ctx)
 }
 
 SEC("?tc")
-__failure __msg("bpf_rcu_read_unlock is missing")
+__failure __msg("bpf_throw cannot be used inside bpf_rcu_read_lock-ed region")
 int reject_with_rcu_read_lock(void *ctx)
 {
 	bpf_rcu_read_lock();
@@ -147,11 +148,13 @@ __noinline static int throwing_subprog(struct __sk_buff *ctx)
 }
 
 SEC("?tc")
-__failure __msg("bpf_rcu_read_unlock is missing")
+__failure __msg("bpf_throw cannot be used inside bpf_rcu_read_lock-ed region")
 int reject_subprog_with_rcu_read_lock(void *ctx)
 {
 	bpf_rcu_read_lock();
-	return throwing_subprog(ctx);
+	throwing_subprog(ctx);
+	bpf_rcu_read_unlock();
+	return 0;
 }
 
 static bool rbless(struct bpf_rb_node *n1, const struct bpf_rb_node *n2)
-- 
2.53.0



