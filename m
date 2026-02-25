Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1429D248886;
	Wed, 25 Feb 2026 01:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983816; cv=none; b=Zr1SqevPh5YjFf4Le61rLKTPALdyX5MHGmDRovvOnNc9i/LdtRN2nG1hUVLF972fZiwrOp4LhdECIY7e3TOtbLSk0H7qRTPJuuZb2+CugZaDTB6f8ic8Li18Uulhmelff5ZJusevbwqpxLwP9kSO/K3AVFNhCEM7VtMuZT3yxbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983816; c=relaxed/simple;
	bh=RsHUKEU53SrzMv2nSlJZS/u8b+DCpGHQqceaXkFUtwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SZOAANCC+FjMH8pAVQ8WBLn2GTt53zK3KZ66h6ZHuNhdDJ5ttDugJerrqOK5k5eCd/JLyCslokqfsUgLims+ujuYWn8yVCRNLfQ6ch0ByOQXCXFCcq1YHsl0Tt7fdbVCd6aK1wyrowNfd9jX0XVDyNInZLZLVJeEAyDWdunMcpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SViXd0Ez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SViXd0Ez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB269C116D0;
	Wed, 25 Feb 2026 01:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983816;
	bh=RsHUKEU53SrzMv2nSlJZS/u8b+DCpGHQqceaXkFUtwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SViXd0EziM7UXpnAcuV+UC0AlwAo0m5TJ/iaPYr9NxgSeIyeKEKnjVpk+YWLjfepC
	 J4EoYwQH3iEyWCl3aHQIfmo87BBJW3gYGmw1J7lsIGql8lqDayk1GFjtUeVNn1dVr1
	 UwcGbNjZpdPS3agYCaiQt5gE5wH1PiihUVPnmYTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahe Tardy <mahe.tardy@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 100/641] x86/fgraph,bpf: Switch kprobe_multi program stack unwind to hw_regs path
Date: Tue, 24 Feb 2026 17:17:06 -0800
Message-ID: <20260225012351.531072561@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index b08c95872eed9..c56e1e63b8932 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -57,7 +57,7 @@ arch_ftrace_get_regs(struct ftrace_regs *fregs)
 }
 
 #define arch_ftrace_partial_regs(regs) do {	\
-	regs->flags &= ~X86_EFLAGS_FIXED;	\
+	regs->flags |= X86_EFLAGS_FIXED;	\
 	regs->cs = __KERNEL_CS;			\
 } while (0)
 
-- 
2.51.0



