Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE392192F2;
	Tue,  8 Apr 2025 11:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111412; cv=none; b=E98pBhbig/7rBeFtcZZ6lByuCeJEy0Du4tXmcOEWGDaN4ORydGeon6Te3F5K6AH8thR5UX+iDxJ6jHn6Y8RWgJgj1WpSaZRPqOJfyJyLJitdtcLEzW5n5wcbqgRNxyhHxb1zC6O/O7iUYg99QjHi63yHJHh8OrbJ6r4UimNbGz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111412; c=relaxed/simple;
	bh=DFPz4aNbQSMljHKZ39DJ46Vn0nrEUunHu3MWOZe/z6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pl6PmabXvmr+QR4+hj0ZOBLl1CligF8Xb/zeYOZ2XTB2+AFXLP824WcFqSv4o7ANxeBIi2jQe/NVlxGBS27iIGR4wjap1ZMN6R+sjXv95R9VLYJ+OZynSOPFFNpY7oQfxQ4J+k8Z+5TIyVF9J+jm+OQYMXm0avbZm4fTs1MvLmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzOWB0sQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzOWB0sQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73222C4CEE7;
	Tue,  8 Apr 2025 11:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111412;
	bh=DFPz4aNbQSMljHKZ39DJ46Vn0nrEUunHu3MWOZe/z6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzOWB0sQt9ORdsvEKQYuUmUfqDkGCfuG+u5d1wfxwIhe5K95RrC5i1kSq3dHcEiQc
	 qpwyLQ+1QDqr+/bYuWvln5UI/o47wxYT8bRefi20S2mdLt9JQVpxk7Eo5BiHFwXJfD
	 XYmbNy0WHerChDjhfbKUHxHXPSuKqiA5mCl44HyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d2a2c639d03ac200a4f1@syzkaller.appspotmail.com,
	Jiayuan Chen <mrpre@163.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 421/731] bpf: Fix array bounds error with may_goto
Date: Tue,  8 Apr 2025 12:45:18 +0200
Message-ID: <20250408104924.065662189@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <mrpre@163.com>

[ Upstream commit 6ebc5030e0c5a698f1dd9a6684cddf6ccaed64a0 ]

may_goto uses an additional 8 bytes on the stack, which causes the
interpreters[] array to go out of bounds when calculating index by
stack_size.

1. If a BPF program is rewritten, re-evaluate the stack size. For non-JIT
cases, reject loading directly.

2. For non-JIT cases, calculating interpreters[idx] may still cause
out-of-bounds array access, and just warn about it.

3. For jit_requested cases, the execution of bpf_func also needs to be
warned. So move the definition of function __bpf_prog_ret0_warn out of
the macro definition CONFIG_BPF_JIT_ALWAYS_ON.

Reported-by: syzbot+d2a2c639d03ac200a4f1@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/bpf/0000000000000f823606139faa5d@google.com/
Fixes: 011832b97b311 ("bpf: Introduce may_goto instruction")
Signed-off-by: Jiayuan Chen <mrpre@163.com>
Link: https://lore.kernel.org/r/20250214091823.46042-2-mrpre@163.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c     | 19 +++++++++++++++----
 kernel/bpf/verifier.c |  7 +++++++
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index da729cbbaeb90..a0200fbbace99 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2290,17 +2290,18 @@ void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth)
 	insn->code = BPF_JMP | BPF_CALL_ARGS;
 }
 #endif
-#else
+#endif
+
 static unsigned int __bpf_prog_ret0_warn(const void *ctx,
 					 const struct bpf_insn *insn)
 {
 	/* If this handler ever gets executed, then BPF_JIT_ALWAYS_ON
-	 * is not working properly, so warn about it!
+	 * is not working properly, or interpreter is being used when
+	 * prog->jit_requested is not 0, so warn about it!
 	 */
 	WARN_ON_ONCE(1);
 	return 0;
 }
-#endif
 
 bool bpf_prog_map_compatible(struct bpf_map *map,
 			     const struct bpf_prog *fp)
@@ -2380,8 +2381,18 @@ static void bpf_prog_select_func(struct bpf_prog *fp)
 {
 #ifndef CONFIG_BPF_JIT_ALWAYS_ON
 	u32 stack_depth = max_t(u32, fp->aux->stack_depth, 1);
+	u32 idx = (round_up(stack_depth, 32) / 32) - 1;
 
-	fp->bpf_func = interpreters[(round_up(stack_depth, 32) / 32) - 1];
+	/* may_goto may cause stack size > 512, leading to idx out-of-bounds.
+	 * But for non-JITed programs, we don't need bpf_func, so no bounds
+	 * check needed.
+	 */
+	if (!fp->jit_requested &&
+	    !WARN_ON_ONCE(idx >= ARRAY_SIZE(interpreters))) {
+		fp->bpf_func = interpreters[idx];
+	} else {
+		fp->bpf_func = __bpf_prog_ret0_warn;
+	}
 #else
 	fp->bpf_func = __bpf_prog_ret0_warn;
 #endif
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 60611df77957a..c6f3b5f4ff2be 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -21897,6 +21897,13 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 		if (subprogs[cur_subprog + 1].start == i + delta + 1) {
 			subprogs[cur_subprog].stack_depth += stack_depth_extra;
 			subprogs[cur_subprog].stack_extra = stack_depth_extra;
+
+			stack_depth = subprogs[cur_subprog].stack_depth;
+			if (stack_depth > MAX_BPF_STACK && !prog->jit_requested) {
+				verbose(env, "stack size %d(extra %d) is too large\n",
+					stack_depth, stack_depth_extra);
+				return -EINVAL;
+			}
 			cur_subprog++;
 			stack_depth = subprogs[cur_subprog].stack_depth;
 			stack_depth_extra = 0;
-- 
2.39.5



