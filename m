Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A715538757A;
	Sat, 12 Sep 2026 15:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227819; cv=none; b=gZ8+g2njc6wLdlVz1V9ZLme1M4wqrMlrCF55wZDtCGurnHTMWOGgCvTDntOdTDgDwfHae35XOl7O0hE5uaoZGFciHsL6SwkPIXLFnaNmzOK/GxKy21G9VLKs5eD+wqSnZ7cnjw9qbVRIBKrvHaABrS3q8dLEGhbB8G0YSfxCPLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227819; c=relaxed/simple;
	bh=0lVOy+rveazTviUa6UlUwFFXLWOrlN4MGxlebPjUEek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTL9JY2/Fq1obmQUQXk6vKt4tAQql3IMAjKUsgfAcdztMkXzr1pfYUF7wBQRqzgPD4L166/SpksmdibRlgPTasbl1Gm1WkiYMkGsNf9LydYwssh7LXJnhz3JdXn8d8BXMOaKYF6s1ZwmI/pOu2pPmMLG682cAAikBuhh5YaHKe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hKkwatE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hKkwatE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1382E1F000FF;
	Sat, 12 Sep 2026 15:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227817;
	bh=ekxuf4cPRevHbhX30yiZ5In0X/1skwAYBfrDdtRdlSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2hKkwatErXFR7rHwSk4Dy/Dq+BaqJ2P0k1trYaNCvwHNB1EI5RdaPENtKLut0+Spo
	 Xb1OLhsU2p808MPGUVl4bFHKSs4tbWJh6Cz7gVj2G7kd9JDeb6J0zGVxSj+tWJDcZ5
	 xtrU0NbBDOmfrJ0Iwu51GcVBN60DY8zWF/QDbEF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0259/1191] entry: Fix seccomp bypass after ptrace with TSYNC
Date: Sat, 12 Sep 2026 08:49:47 +0200
Message-ID: <20260912065554.037088681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ccf2b1e1b40be..abf94d753bbca 100644
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



