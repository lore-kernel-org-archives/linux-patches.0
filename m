Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910F347CA89;
	Sat, 12 Sep 2026 12:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217031; cv=none; b=ITbnm6J4NmlRqiUkyYD8YYH0qyu6R5SQRftUcukgA2oOPL4KZK1i+2yccvU0e+VcZWfAF7QH+AkZvfjTdGtXSuYThujlSI0bKq48QuareiF4uUg5i5e6RNtEpQ6cwaaG81MI++SN6b0awckN3Zqc0nl6IozCkdGMvhi0dkDs0bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217031; c=relaxed/simple;
	bh=DQJkNLYh01PfG174bEzMKTWHLjYMv+aLgLYdtQxTOto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z/aKHrfTFWZIdY+oUNFC2h7MD/NeDRiLt5TiTN60l0GzsW5zeQAMdjdkILYDDHmZkxhUiSnrcSNxXGf8NIpRhs5xborEFBsnfR6UDKl4VbEKiDg6/PE0B0S1B9PAHnYcegiywM0lOQwO5pOWQv5HROqq5K8SKDJJ+w0ZlLbUZB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nf0+9jDa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nf0+9jDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD5F1F000FF;
	Sat, 12 Sep 2026 12:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217030;
	bh=lt5dujqCk5DbncFreFh69OprlhZ04HIKIFqEk35A3GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nf0+9jDaWe/l5fi0K8TbI1GQirxn4icyfUgRLFKuqqsSDE89t5d2dIyYoWq2RA7TW
	 Z7PmOrPOB8kpXhRjkFJ6s/ozUZCjZW9+l14KnKRFS8IRskAjnHY+Vit9RtrIUaq85G
	 V8bbtlEwUPpswffpP67rnlXyn/TN8SOShC+VlQaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@oss.qualcomm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0858/1376] MIPS: ptrace: Fix syscall skipping via PTRACE_SYSCALL
Date: Sat, 12 Sep 2026 08:54:44 +0200
Message-ID: <20260912065626.683366569@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 61503a36067e9..2016dd5e8fae0 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -1319,8 +1319,12 @@ long arch_ptrace(struct task_struct *child, long request,
  */
 asmlinkage long syscall_trace_enter(struct pt_regs *regs)
 {
+	long syscall;
+
 	user_exit();
 
+	syscall = current_thread_info()->syscall;
+
 	if (test_thread_flag(TIF_SYSCALL_TRACE)) {
 		if (ptrace_report_syscall_entry(regs))
 			return -1;
@@ -1356,7 +1360,7 @@ asmlinkage long syscall_trace_enter(struct pt_regs *regs)
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



