Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A23B3F7867;
	Tue, 31 Mar 2026 16:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976233; cv=none; b=UBmHrkR6iDw+eDsM20v70XRG+SPzEImRqPnUGkSs26SIc6SDYJtbRjZzH+F5nJZs+X8pDuJ5wMhnnMQmUKJ8plhkSRs+uqAl0VFrZVcW67X8bzOtopUvvTTsvcb4pbuQAbcN6ZyL2dq2gA31P+hMyulAzd2BnAX4TlXe2Rs+eAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976233; c=relaxed/simple;
	bh=lgFxzh0j/JACTc79lJy5oTds47hnH3cXb8JEhjx+//Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRaFZrDPlFTgg99kpA+WKWtLe4KQ5N4Idzad4XG88KWk14avX46CvLuLMMDk0yQxgxfxfUPPGYXFg683lN1klh7BEQZXcmtD8kzjTtdUnm1/530YOychKENCQwPX+OlyF9Bzk0Tymuzo1kElC0IhyhDFfU5d8IIeBk1OF+EdZXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPG1x58W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPG1x58W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC26BC19423;
	Tue, 31 Mar 2026 16:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976233;
	bh=lgFxzh0j/JACTc79lJy5oTds47hnH3cXb8JEhjx+//Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPG1x58WJhKdEFrk5EReYwOEQ7mfANSKO1pPyFkESGr6FPKQ8KjXTZV7L7Ig3vryU
	 Kiw4oELPT47AnzqODUJA9rv1i+X2J5GkfnRUejjp+NEivEdCdvd8xbnTtHua3XbHuu
	 YZHxi7Vth5M7b/jKSXyrjoecqHp+J+NIuZMIUew8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/309] bpf: Fix exception exit lock checking for subprogs
Date: Tue, 31 Mar 2026 18:18:37 +0200
Message-ID: <20260331161754.003165847@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
 kernel/bpf/verifier.c                               | 3 ++-
 tools/testing/selftests/bpf/progs/exceptions_fail.c | 9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1280ee4c81c33..af87530450ec2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -19955,7 +19955,8 @@ static int process_bpf_exit_full(struct bpf_verifier_env *env,
 	 * state when it exits.
 	 */
 	int err = check_resource_leak(env, exception_exit,
-				      !env->cur_state->curframe,
+				      exception_exit || !env->cur_state->curframe,
+				      exception_exit ? "bpf_throw" :
 				      "BPF_EXIT instruction in main prog");
 	if (err)
 		return err;
diff --git a/tools/testing/selftests/bpf/progs/exceptions_fail.c b/tools/testing/selftests/bpf/progs/exceptions_fail.c
index 8a0fdff899271..d7f1c492e3dd3 100644
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
-__failure __msg("BPF_EXIT instruction in main prog cannot be used inside bpf_rcu_read_lock-ed region")
+__failure __msg("bpf_throw cannot be used inside bpf_rcu_read_lock-ed region")
 int reject_with_rcu_read_lock(void *ctx)
 {
 	bpf_rcu_read_lock();
@@ -147,11 +148,13 @@ __noinline static int throwing_subprog(struct __sk_buff *ctx)
 }
 
 SEC("?tc")
-__failure __msg("BPF_EXIT instruction in main prog cannot be used inside bpf_rcu_read_lock-ed region")
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
2.51.0



