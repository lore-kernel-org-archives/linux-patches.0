Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E89D29D288;
	Sat, 12 Sep 2026 19:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242931; cv=none; b=a5leA5s4qaoQiDUiY0ZGutpzX7XsMHGHrNQbvsSTst1mMZSx4xC0J51lIQUFlMo9kyT3z2QKZ0J0GSo6MgITx5CYCpNwgTS46hMx9FAnzb2zzgi5EjNtAzYdA90BrFV5hCbgUYAUvwsHqbNZhtv8NzCSGu6hWbhBpQN92I9VMZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242931; c=relaxed/simple;
	bh=AeZ8lZPnD4d2j88Q7yghDS4ME3j/8goN36Bq4Hr2oyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rLIXQUH6ovdDqkBuT3X7XBsdP21d/XJGd9NBzEgmCEqhQ5Z4sCnBiITaXzPVp8oKuqKonA8/n38auQfbc42HdOzBdAscCTYQSyTvrrzRQIZ0pLQuf/nUFWlrPFJUXY5B274wVho33nPBtLS4HUi1ULG+349RphXzNQi2Wf0x3xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHeYHKtw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHeYHKtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C891F000FF;
	Sat, 12 Sep 2026 19:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242930;
	bh=ClbuJUklhgpys+SQ6fRorm1USDx1jAarisbl4cBMtPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WHeYHKtwsohtsGlYHqsf17oKSNIIY/KO2u0g7DHHpNstJWnWu5ElgFw1AvgaNl99Z
	 8JYHQ6dUDvwXxs+JOWJxjwwYc8np/ZEXZYMRL1HMIKIM9iPSrEBg1LUktXNAEqvMrd
	 x7Sh3IpF8aXaaYV/a4enJNRCY0PHd0bKCiymgLFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@oss.qualcomm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 577/798] MIPS: ptrace: Fix syscall skipping via PTRACE_SYSCALL
Date: Sat, 12 Sep 2026 09:03:25 +0200
Message-ID: <20260912065530.356164540@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

[ Upstream commit 5475c03fa25f31cfd5f8c7e552f8d10347bbaad9 ]

If tracer wanted to skip a syscall return value was always
overwritten with -ENOSYS. Fix this by checking against original
syscall number and only return -ENOSYS, if it is negative.

Fixes: b6318a903d06 ("MIPS/ptrace: Pick up ptrace/seccomp changed syscalls")
Reviewed-by: Philippe Mathieu-Daudé <philmd@oss.qualcomm.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/ptrace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index dd454b429ff73..d051d351e5a01 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -1312,8 +1312,12 @@ long arch_ptrace(struct task_struct *child, long request,
  */
 asmlinkage long syscall_trace_enter(struct pt_regs *regs)
 {
+	long syscall;
+
 	user_exit();
 
+	syscall = current_thread_info()->syscall;
+
 	if (test_thread_flag(TIF_SYSCALL_TRACE)) {
 		if (tracehook_report_syscall_entry(regs))
 			return -1;
@@ -1349,7 +1353,7 @@ asmlinkage long syscall_trace_enter(struct pt_regs *regs)
 	 * Negative syscall numbers are mistaken for rejected syscalls, but
 	 * won't have had the return value set appropriately, so we do so now.
 	 */
-	if (current_thread_info()->syscall < 0)
+	if (syscall < 0)
 		syscall_set_return_value(current, regs, -ENOSYS, 0);
 	return current_thread_info()->syscall;
 }
-- 
2.53.0



