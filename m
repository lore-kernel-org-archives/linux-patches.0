Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDDD325726;
	Sat, 12 Sep 2026 13:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221106; cv=none; b=NbYWoPT8yMWItIJFIG+Q/AX4+KmmxEXLLuALPPa3kPSzOswThOD/JkMha2kvzpG+j9MEFtzDrllGGed/DrcLYn3Gp3CSLokE4MSXm8KoL5EX/fjrqI4zl/eL+1MS/FFDYnWBg4OFRRk+tiCR9WO6L8r8i6JO18LPGbRJawhsmIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221106; c=relaxed/simple;
	bh=7ngcOavyW3jdM92c2Ao14TmfGIQLbhuU+S8qfc22EUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkqJJoKfrFOux9m03jeBd899y/3yCPWI6uhOoW2LPVlrqwNeuuTrmMwNYsFvBCrnk3Jg5CGKz8fjSIIazSi1rYr9mb0T25r4/FwtyvRSM7K8AdSLpqLBViWGDsE30K1oFrKqg8wnuJEicAvrWoJ6ObvRUTY6VKJFYn90Rb/mmJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jl9ppW9Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jl9ppW9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083981F000FF;
	Sat, 12 Sep 2026 13:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221105;
	bh=DQkBP4BDlGQ2nH/gtBvm9GrDbynlTmEAvKi6/xs3puw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jl9ppW9Qn4ubguqn1JBoe3QGi1J+vVcVLB9ZS8938B/QxCuiKE1MbqChq3IrNQx9H
	 UU0FfUKPvNjuGW89EgCenhVD7axnkiCQD1djeWOa+F0H8zsOoSZBi4jK9N1ViqIyBW
	 xGkZ6kfC1jiCbsIW+kOmgZr8vsVrtht0ZjAY0xx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0316/1424] entry: Fix seccomp bypass after ptrace with TSYNC
Date: Sat, 12 Sep 2026 08:45:48 +0200
Message-ID: <20260912065614.360725833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 4a3591287fb7f808e209b4974ed337f609a2006b upstream.

Sashiko review pointed out the following issue.

If a thread is stopped in syscall_trace_enter() for ptrace, another
thread can install a seccomp filter with SECCOMP_FILTER_FLAG_TSYNC
(e.g., via seccomp_attach_filter()). This will successfully set
SYSCALL_WORK_SECCOMP on the stopped thread, but syscall_trace_enter()
evaluates a cached 'work' variable sampled on entry. Consequently,
the subsequent check for SYSCALL_WORK_SECCOMP misses the newly
assigned flag, and the filter is silently bypassed.

This race condition could allow an unprivileged process to execute
a prohibited system call (e.g., execve) that the newly installed filter
was intended to block, especially since the tracer might have modified
the system call number during the ptrace stop.

Fix this by re-reading the syscall_work flags after ptrace handling,
so that any new SYSCALL_WORK_SECCOMP flag set by another thread via
TSYNC during the ptrace stop is observed before the subsequent
seccomp check.

Fixes: 142781e108b1 ("entry: Provide generic syscall entry functionality")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260629132914.1135C1F000E9@smtp.kernel.org/
Link: https://patch.msgid.link/20260713025712.416366-1-ruanjinjie@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/entry/common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index 5ff4f1cd36445..19923bc5ab776 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -65,6 +65,9 @@ static long syscall_trace_enter(struct pt_regs *regs, long syscall,
 		ret = ptrace_report_syscall_entry(regs);
 		if (ret || (work & SYSCALL_WORK_SYSCALL_EMU))
 			return -1L;
+
+		/* ptrace might have changed work flags */
+		work = READ_ONCE(current_thread_info()->syscall_work);
 	}
 
 	/* Do seccomp after ptrace, to catch any tracer changes. */
-- 
2.53.0



