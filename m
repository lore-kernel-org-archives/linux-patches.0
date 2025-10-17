Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA33D2745E;
	Fri, 17 Oct 2025 15:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714998; cv=none; b=O16z+F9TkXyL3pU7bLtlS3RxAW22GLvL06hFwaLHrJoQz1tMEHcel3e8h4Svqe9NrjpomlrLeqkFROEnbe+cPVEAhxqQDqPBHd1Eg2zunqp/DaoatjcDV3KIyP0XSi6zmVpx2MZzFHtih+AKZwd6XRCcYdJF7ekc7nAG8Tt5xlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714998; c=relaxed/simple;
	bh=1+X/4wPr1aTZe9ePH3KHjwxxwc73LJWOVF4LNvsIi5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WU01RLZjbqxvrMIvHRGjEYPhjqhneZxSRliAe7x5cFUbDi6/syYqpzFYiwdGEDadq3icN/UR69jgXz6JBgr+Kp8LXJgAOcbE/gLb/bxTOHHNNkrScGC7k5LdhNcnmsgNiv6qZOQXPEg2nokMaG3XvcUtX/kZRNLottlVljNcoe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrT6gFCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrT6gFCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED24C4CEE7;
	Fri, 17 Oct 2025 15:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714998;
	bh=1+X/4wPr1aTZe9ePH3KHjwxxwc73LJWOVF4LNvsIi5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrT6gFCciJ2gTqCQ/s6kIA9AIhXQ/cP3GRN3NanUNCPq69BCtlJBZKmpO6AF+6lvh
	 TJ6dFgXrWxXsDQ/Qw5aBpQGWcCG71bUd7I+hwQjEUR8QjJHZOiDBbYxdUE80mynvJ7
	 7ufB7GJguTzWftPQbxQAuavKGHpuMiqTDHxXCM4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Jiri Olsa <jolsa@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 063/371] tracing: Fix the bug where bpf_get_stackid returns -EFAULT on the ARM64
Date: Fri, 17 Oct 2025 16:50:38 +0200
Message-ID: <20251017145204.080079181@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Yang <yangfeng@kylinos.cn>

[ Upstream commit fd2f74f8f3d3c1a524637caf5bead9757fae4332 ]

When using bpf_program__attach_kprobe_multi_opts on ARM64 to hook a BPF program
that contains the bpf_get_stackid function, the BPF program fails
to obtain the stack trace and returns -EFAULT.

This is because ftrace_partial_regs omits the configuration of the pstate register,
leaving pstate at the default value of 0. When get_perf_callchain executes,
it uses user_mode(regs) to determine whether it is in kernel mode.
This leads to a misjudgment that the code is in user mode,
so perf_callchain_kernel is not executed and the function returns directly.
As a result, trace->nr becomes 0, and finally -EFAULT is returned.

Therefore, the assignment of the pstate register is added here.

Fixes: b9b55c8912ce ("tracing: Add ftrace_partial_regs() for converting ftrace_regs to pt_regs")
Closes: https://lore.kernel.org/bpf/20250919071902.554223-1-yangfeng59949@163.com/
Signed-off-by: Feng Yang <yangfeng@kylinos.cn>
Tested-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/ftrace.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
index bfe3ce9df1978..ba7cf7fec5e97 100644
--- a/arch/arm64/include/asm/ftrace.h
+++ b/arch/arm64/include/asm/ftrace.h
@@ -153,6 +153,7 @@ ftrace_partial_regs(const struct ftrace_regs *fregs, struct pt_regs *regs)
 	regs->pc = afregs->pc;
 	regs->regs[29] = afregs->fp;
 	regs->regs[30] = afregs->lr;
+	regs->pstate = PSR_MODE_EL1h;
 	return regs;
 }
 
-- 
2.51.0



