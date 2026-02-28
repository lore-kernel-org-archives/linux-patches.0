Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9D7379EE2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301684; cv=none; b=q1DMq+cM1Cda5KHNpK4Fy44dZL2AMERI8xkizA4UOSAzZUxTlm//ME/g+CiLU30qq+HSzvX9G7GemHPSetkPItOy5Eo/zinnzV5GbdPDBFPY1plCbzoKP0dUdI6wXVPKxMPqkodPxeIXtGrKmmFnvJIRox1fy2xatAIa4NOmiJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301684; c=relaxed/simple;
	bh=7D1HdyWEJeFKDN+vBI5almh82nURBxEQ74vcxkKRM/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HdaxN7d07FJgeVk+wKkuqtmbuIDafxBqQvGXCqawEvq4G2TimRlLFrdhxxN55UxyC+v+5JaGpfRxUAI5tH5/3+97d5pJjhB/sy6ZWPyb9/z3ZROxj7wlRpTL15rP5Qn4oLA3FZXOYBQu8VoWu2V5izvk1I18flvJLQnsEtWH8NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i7Mb55jC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i7Mb55jC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B910C19423;
	Sat, 28 Feb 2026 18:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301684;
	bh=7D1HdyWEJeFKDN+vBI5almh82nURBxEQ74vcxkKRM/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7Mb55jCzoAXDr21wajVuELBWXqmDrSaMKxO5P6OnPYey/nU6ZVdttVNAN6V87gPo
	 RLtqkBaAid29n4qVDqJWmmXzt+LTCgyOgtJ2D6c10LFb5kwG8R/PZUIDUFH84luVmj
	 yLdu1Crz9Qs2+82cNHHgeZNizyH0hJz5I0fe9M1b/EIixrgsPcv6yVh2bpNjyCiRE2
	 KtV8K3xOfeM0I7IFmVXSB/AheP3+S1y5gHgqgFZUjCDLzXrdc38J27yMILc67ey8nE
	 TgyGSM/0Aa2iuqTetCURRDejKzrnJqayQTbyV/Pl4WhSwNANrJ8T+rXxG0pMtBdnUd
	 tLcn3TcFDTsNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiri Olsa <jolsa@kernel.org>,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/385] x86/fgraph,bpf: Switch kprobe_multi program stack unwind to hw_regs path
Date: Sat, 28 Feb 2026 12:54:55 -0500
Message-ID: <20260228180011.1568201-73-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit aea251799998aa1b78eacdfb308f18ea114ea5b3 ]

Mahe reported missing function from stack trace on top of kprobe
multi program. The missing function is the very first one in the
stacktrace, the one that the bpf program is attached to.

  # bpftrace -e 'kprobe:__x64_sys_newuname* { print(kstack)}'
  Attaching 1 probe...

        do_syscall_64+134
        entry_SYSCALL_64_after_hwframe+118

  ('*' is used for kprobe_multi attachment)

The reason is that the previous change (the Fixes commit) fixed
stack unwind for tracepoint, but removed attached function address
from the stack trace on top of kprobe multi programs, which I also
overlooked in the related test (check following patch).

The tracepoint and kprobe_multi have different stack setup, but use
same unwind path. I think it's better to keep the previous change,
which fixed tracepoint unwind and instead change the kprobe multi
unwind as explained below.

The bpf program stack unwind calls perf_callchain_kernel for kernel
portion and it follows two unwind paths based on X86_EFLAGS_FIXED
bit in pt_regs.flags.

When the bit set we unwind from stack represented by pt_regs argument,
otherwise we unwind currently executed stack up to 'first_frame'
boundary.

The 'first_frame' value is taken from regs.rsp value, but ftrace_caller
and ftrace_regs_caller (ftrace trampoline) functions set the regs.rsp
to the previous stack frame, so we skip the attached function entry.

If we switch kprobe_multi unwind to use the X86_EFLAGS_FIXED bit,
we set the start of the unwind to the attached function address.
As another benefit we also cut extra unwind cycles needed to reach
the 'first_frame' boundary.

The speedup can be measured with trigger bench for kprobe_multi
program and stacktrace support.

- trigger bench with stacktrace on current code:

        kprobe-multi   :     0.810 ± 0.001M/s
        kretprobe-multi:     0.808 ± 0.001M/s

- and with the fix:

        kprobe-multi   :     1.264 ± 0.001M/s
        kretprobe-multi:     1.401 ± 0.002M/s

With the fix, the entry probe stacktrace:

  # bpftrace -e 'kprobe:__x64_sys_newuname* { print(kstack)}'
  Attaching 1 probe...

        __x64_sys_newuname+9
        do_syscall_64+134
        entry_SYSCALL_64_after_hwframe+118

The return probe skips the attached function, because it's no longer
on the stack at the point of the unwind and this way is the same how
standard kretprobe works.

  # bpftrace -e 'kretprobe:__x64_sys_newuname* { print(kstack)}'
  Attaching 1 probe...

        do_syscall_64+134
        entry_SYSCALL_64_after_hwframe+118

Fixes: 6d08340d1e35 ("Revert "perf/x86: Always store regs->ip in perf_callchain_kernel()"")
Reported-by: Mahe Tardy <mahe.tardy@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://lore.kernel.org/bpf/20260126211837.472802-3-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/ftrace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index bb72bf879aed6..c42f7169fc1c0 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -48,7 +48,7 @@ arch_ftrace_get_regs(struct ftrace_regs *fregs)
 }
 
 #define arch_ftrace_partial_regs(regs) do {	\
-	regs->flags &= ~X86_EFLAGS_FIXED;	\
+	regs->flags |= X86_EFLAGS_FIXED;	\
 	regs->cs = __KERNEL_CS;			\
 } while (0)
 
-- 
2.51.0

