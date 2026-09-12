Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14688274B46;
	Sat, 12 Sep 2026 18:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237465; cv=none; b=ccp0tH0htjUdyMdq4PtcMFq6EKGrPqKa1mVoS4Wz5NJliLO20n6KZRHbZGE0cwZE1++vgAwjsx+Nn1TPzBp5/vfxhB5FWX+7xepGHMsXJBdTkGOW79KYXNl2kOTGbcTxIY3hZzSLZmtwpJkOWW5Dg3uoFDDFT8tldI/F9SEwS4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237465; c=relaxed/simple;
	bh=x/skUAwloU/jH+F/QRPXnLMspGuRwFHRVY9cdXVTJ3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBuEggne93LEeNGZ/9pnu31w/7roRSLl67xbULhAwhlq+XF28JZfiB8aHPGnyq8OZD18hwZVh43ZWPSSsWWbhMYUsGXTcTXtiG2p/9Cf7q7Veb1fi0YeFHkS4K/d1xlJVLgGfiE1paeOsIkFt0QPhtPbRrGOwtO76UJtrWpWdpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZrowOnG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZrowOnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682311F000FF;
	Sat, 12 Sep 2026 18:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237463;
	bh=fqgPLrjanJmaqBnYzFFd8g9LE7FI0eBkzxE1FA3ed6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZrowOnGCnZJ8duVCGpx1ECRvl5lQCgd9/Gza2WOHTRnBGCW2d3C9bcsBsiLytvjf
	 IyCCsYXnBNhXuzy66W/7ATrTGqgPVN4Cqwp8yl7BactAMVUdrFgzPvFLueDRQfhboD
	 ce3Wo9TybAxUXTyTZDV915RJcbvUzoIRi222Gib4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 222/935] entry: Fix seccomp bypass after ptrace with TSYNC
Date: Sat, 12 Sep 2026 08:54:12 +0200
Message-ID: <20260912065531.914186842@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d11d4047a0ca8..67ee2f276e7ea 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -61,6 +61,9 @@ static long syscall_trace_enter(struct pt_regs *regs, long syscall,
 		ret = arch_syscall_enter_tracehook(regs);
 		if (ret || (work & SYSCALL_WORK_SYSCALL_EMU))
 			return -1L;
+
+		/* ptrace might have changed work flags */
+		work = READ_ONCE(current_thread_info()->syscall_work);
 	}
 
 	/* Do seccomp after ptrace, to catch any tracer changes. */
-- 
2.53.0



