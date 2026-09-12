Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CCC478E47;
	Sat, 12 Sep 2026 11:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212900; cv=none; b=hDbOTZ6cfjm9ecO0+dHMaCG63cMm7BgiWb+Da/Pwxj8ONuX+v8mFunPd8q6e5JQ650w12r7KRBoNclSzq+slL8RDfB4beSq2UOcDJEJfz3/LBECs1nZFMjP3ZgVTaRVZfyqErR0BW8J9s6SCsmvgr9NKCWah6ZpKdclI9L4Y4qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212900; c=relaxed/simple;
	bh=CX4cp5go6LOWiZMXRuAtQUkeH+iJUfMeHmd9XSSPGvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPHV/d9S+Z1XXtSSM2KHpahzTyX4JPZKAB3Cc7i/MhYDErIgbPBAlypVNP8S5yeoQUpePuUSE6EyoEa2oC5TkA4YNhg6vaieaOCFNtKYq1JBzMhO5A2yL2TVt5n4xI7ZcGRSPokUjsgh2ejJCcjU+8j0p0WTq8rVT1qLN/0HrhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JIo3BjYx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JIo3BjYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCA31F00893;
	Sat, 12 Sep 2026 11:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212896;
	bh=zT5HoLeg8Nyn4ayuQWKhJ7BmEj9QzbLFseH4/DlswZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIo3BjYxgIHMniqdgITKH+M6YlK28DE9FiM8weTFheXC1TslE0/N2PXrM6sDpmudl
	 N27GyqIgJP64pd1tPjI4Iiec/yvml+UqvycIMW1Zao/30TVb4ea5D37VwimQSFYfVc
	 0lODVaDAE9osTrnYSsEyWHEB1Cs6exHzselj5oyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0012/1376] entry: Fix seccomp bypass after ptrace with TSYNC
Date: Sat, 12 Sep 2026 08:40:38 +0200
Message-ID: <20260912065607.825047473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 5b6934e23c21d..fc6552d065cc1 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -45,6 +45,9 @@ long syscall_trace_enter(struct pt_regs *regs, long syscall,
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



