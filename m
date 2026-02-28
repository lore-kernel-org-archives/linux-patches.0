Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68783375AC8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301683; cv=none; b=Pq9YbVHAf4YuK704o4c6nQv0xoVQ/QqwZNy3jF+OYb7VyLJfAs8aSzc4XuSUE+J3W1bvkkjTzNu2VFG5RSqwwTrdO2P29shJXKDRDbizWoBYScqGcb56YFNGfga7Q6FNbb87mPjTW2WvO36OZZqyBGgP0cxUJxqchHG0kAbZZU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301683; c=relaxed/simple;
	bh=HOuOEZo1yFt0F4erpwidDZCdPZpfV0ulvHOFBRE7dEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atv/UMuJEAPH00WTqJOwsOaSK2uKkSqF7WAGK/g9GBiDrqQUkgMEAIIrkfuOaSPN6Jq+QzuEQOM7JofgT5HnMOtllWAl3iU2atY204XE1cniYFVtZv37BrK1qS1CIEFMZbwchx//uV1nUwiYEfBqsYLubMUtGNzStHi8pns+Q/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nTm/N/og; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nTm/N/og"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985D8C19423;
	Sat, 28 Feb 2026 18:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301683;
	bh=HOuOEZo1yFt0F4erpwidDZCdPZpfV0ulvHOFBRE7dEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTm/N/ogcszT6cTN5E+YeoNaNGavx2UdRVkhD0OGJtgtQCjK7G165uHkPOTuFjcRn
	 ooJouxcmhDrTEKRPb+6H9SX5jFv65T2P0rSjqBd7lqLb+xpsIqf7+B5KkkGVdxHLZO
	 o1MuKrR7XXFMKI3rqZBDogORVCIday1owJG/WAxE2hC5Icat5WH8JdJhS2kbES3YoB
	 MjizUsq48Ft/PLwrgYyiPeZ5Go+/3ybxjdSXaYhMUBd3jBqafST75VCA3+kTdALie/
	 jfC1SHvIcnktrNWgolnq2r9NoYD93HrPmt+W5xG5peB/nKpRN6/P+2w4RwwRMkokfE
	 4SFjwZ8eMZYDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiri Olsa <jolsa@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/385] x86/fgraph,bpf: Fix stack ORC unwind from kprobe_multi return probe
Date: Sat, 28 Feb 2026 12:54:54 -0500
Message-ID: <20260228180011.1568201-72-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 20a0bc10272fa17a44fc857c31574a8306f60d20 ]

Currently we don't get stack trace via ORC unwinder on top of fgraph exit
handler. We can see that when generating stacktrace from kretprobe_multi
bpf program which is based on fprobe/fgraph.

The reason is that the ORC unwind code won't get pass the return_to_handler
callback installed by fgraph return probe machinery.

Solving this by creating stack frame in return_to_handler expected by
ftrace_graph_ret_addr function to recover original return address and
continue with the unwind.

Also updating the pt_regs data with cs/flags/rsp which are needed for
successful stack retrieval from ebpf bpf_get_stackid helper.
 - in get_perf_callchain we check user_mode(regs) so CS has to be set
 - in perf_callchain_kernel we call perf_hw_regs(regs), so EFLAGS/FIXED
    has to be unset

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20251104215405.168643-3-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: aea251799998 ("x86/fgraph,bpf: Switch kprobe_multi program stack unwind to hw_regs path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/ftrace.h |  5 +++++
 arch/x86/kernel/ftrace_64.S   |  8 +++++++-
 include/linux/ftrace.h        | 10 +++++++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 7e06f8c7937aa..bb72bf879aed6 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -47,6 +47,11 @@ arch_ftrace_get_regs(struct ftrace_regs *fregs)
 	return &arch_ftrace_regs(fregs)->regs;
 }
 
+#define arch_ftrace_partial_regs(regs) do {	\
+	regs->flags &= ~X86_EFLAGS_FIXED;	\
+	regs->cs = __KERNEL_CS;			\
+} while (0)
+
 #define arch_ftrace_fill_perf_regs(fregs, _regs) do {	\
 		(_regs)->ip = arch_ftrace_regs(fregs)->regs.ip;		\
 		(_regs)->sp = arch_ftrace_regs(fregs)->regs.sp;		\
diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index d516472285967..8a3cff618692c 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -349,12 +349,17 @@ SYM_CODE_START(return_to_handler)
 	UNWIND_HINT_UNDEFINED
 	ANNOTATE_NOENDBR
 
+	/* Restore return_to_handler value that got eaten by previous ret instruction. */
+	subq $8, %rsp
+	UNWIND_HINT_FUNC
+
 	/* Save ftrace_regs for function exit context  */
 	subq $(FRAME_SIZE), %rsp
 
 	movq %rax, RAX(%rsp)
 	movq %rdx, RDX(%rsp)
 	movq %rbp, RBP(%rsp)
+	movq %rsp, RSP(%rsp)
 	movq %rsp, %rdi
 
 	call ftrace_return_to_handler
@@ -363,7 +368,8 @@ SYM_CODE_START(return_to_handler)
 	movq RDX(%rsp), %rdx
 	movq RAX(%rsp), %rax
 
-	addq $(FRAME_SIZE), %rsp
+	addq $(FRAME_SIZE) + 8, %rsp
+
 	/*
 	 * Jump back to the old return address. This cannot be JMP_NOSPEC rdi
 	 * since IBT would demand that contain ENDBR, which simply isn't so for
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 4c47fe1e8d113..079a8152855b2 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -187,6 +187,10 @@ static __always_inline struct pt_regs *ftrace_get_regs(struct ftrace_regs *fregs
 #if !defined(CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS) || \
 	defined(CONFIG_HAVE_FTRACE_REGS_HAVING_PT_REGS)
 
+#ifndef arch_ftrace_partial_regs
+#define arch_ftrace_partial_regs(regs) do {} while (0)
+#endif
+
 static __always_inline struct pt_regs *
 ftrace_partial_regs(struct ftrace_regs *fregs, struct pt_regs *regs)
 {
@@ -196,7 +200,11 @@ ftrace_partial_regs(struct ftrace_regs *fregs, struct pt_regs *regs)
 	 * Since arch_ftrace_get_regs() will check some members and may return
 	 * NULL, we can not use it.
 	 */
-	return &arch_ftrace_regs(fregs)->regs;
+	regs = &arch_ftrace_regs(fregs)->regs;
+
+	/* Allow arch specific updates to regs. */
+	arch_ftrace_partial_regs(regs);
+	return regs;
 }
 
 #endif /* !CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS || CONFIG_HAVE_FTRACE_REGS_HAVING_PT_REGS */
-- 
2.51.0

