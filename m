Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E0A3A7F4C;
	Fri,  4 Sep 2026 05:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499042; cv=none; b=kOcPn/Q8K48uouLmm0FdzR4I5F08HgTpPaXaJ1MGyTd5ezGpRx/7utfKLcMOZUvXJ0vK2ehUDit9ecDoTKjkdNK7JrYqfu4VavTzsELs7kuWFFjhjqa1PatNjyKOGhcwTBNjl7nfk9RhlVCye2dLikhT11zuud8+h+uVu0y2Evo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499042; c=relaxed/simple;
	bh=rrRZmaIHuUJhZbM+3ugJ4YTgZ5tSp0GGxq1VZC5d8MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kx4aNxJD/iTpiVYb/WvRYdU4Rlk9v7JpWty4Ilh/nX57BKgAL1c8Nc3fRZYnm6HYpFy51KOKd7phAVPaXrUs2EwLunIOAoTuXN4GKBbcusW1g5D4hRhyYs0D6gD3wAbYaCUbTCbvIEe7rkBbWlgP1fsYWlsSLH18jcNwX+XOtIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iobIkpx7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iobIkpx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9551E1F00A3D;
	Fri,  4 Sep 2026 05:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499041;
	bh=3CrzMUZvdAQPSjQezlazJ+mw2IMhqcs9FH+u7vfSBYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iobIkpx73fdiasFIokQNOWafWbhH1zUOWQySZpUgM0dMHthi1wWQoYHaqW641FD97
	 Us5xDNE6jArcipJB3G/BdC8QjPGZ2ddbsgblHr+iM5g69bzVLf3yZkvaYvaOZiPNfK
	 bfvq2YoyBhOyBHJPei+/+/7cQf8zhF5gpbeKrazk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.2 278/713] entry: Fix seccomp bypass after ptrace with TSYNC
Date: Fri,  4 Sep 2026 06:54:06 +0200
Message-ID: <20260904045810.071679079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/entry-common.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/entry-common.h
+++ b/include/linux/entry-common.h
@@ -96,6 +96,9 @@ static __always_inline long syscall_trac
 		ret = arch_ptrace_report_syscall_entry(regs);
 		if (ret || (work & SYSCALL_WORK_SYSCALL_EMU))
 			return -1L;
+
+		/* ptrace might have changed work flags */
+		work = READ_ONCE(current_thread_info()->syscall_work);
 	}
 
 	/* Do seccomp after ptrace, to catch any tracer changes. */


