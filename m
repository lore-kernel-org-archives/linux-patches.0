Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB4B2D0C94;
	Sat, 12 Sep 2026 19:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241963; cv=none; b=YZUF+EQsMqty0a87lDBBGWgQBvfhwP8RvtktgiDN8wLKIxN7bIo3PxvPzQo/Y1kK4AulRopPUDPInK05ELniBB3HbY+i8ALuTORsy9IDhUX9DN3OBbYHYOmUozyqJQxB3UN1XLuBOqDZ7IA/u+Zo8f6yukqL9PPMeQiEUtdMAkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241963; c=relaxed/simple;
	bh=qQulYNARz0rDeeUNfxpyZNIwXxL9CC6UKjtyAPJNqlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRNwWlOP7IxtBelVzwC2lCvrwyZKR9lgTSqd/8cZuYULng7QjbQcYuQKBI0WFX5x5J/COAwc0su4BmGGfStcY2YnkCwd4Zzzr7pV6XgG8Q+I6fuGFz4+86e5lGSEX74Vu4B+/r9SjI3mr/83R+/Ohvi+5ue4Y299XSMFsaDUonY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LcaDuxpL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LcaDuxpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BB21F000FF;
	Sat, 12 Sep 2026 19:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241962;
	bh=wrikNVS4xFs3iSmbGjoqbwkp9wq5kBx2qYPHQfC2Q3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcaDuxpLfE5UXeE0Cq/rgroEyXKzowwKHBnF1bwfz0VzSU5xgtfR5iUcQM3dfMvEi
	 p1O7svIcgeuZC6Pvx7W8UQIOFDx3JgJaOJNkmJYUPBlWnX/S/YVTNF6wQV4rTW+wc3
	 s+GRT0W1I2YE8stBCHbF6A4qqF8s5JUxESa9OMGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/798] entry: Fix seccomp bypass after ptrace with TSYNC
Date: Sat, 12 Sep 2026 08:57:09 +0200
Message-ID: <20260912065521.689740100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 09f58853f6927..0707937bb3c42 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -51,6 +51,9 @@ static long syscall_trace_enter(struct pt_regs *regs, long syscall,
 		ret = arch_syscall_enter_tracehook(regs);
 		if (ret || (ti_work & _TIF_SYSCALL_EMU))
 			return -1L;
+
+		/* ptrace might have changed work flags */
+		ti_work = READ_ONCE(current_thread_info()->flags);
 	}
 
 	/* Do seccomp after ptrace, to catch any tracer changes. */
-- 
2.53.0



