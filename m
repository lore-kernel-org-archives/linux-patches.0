Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4937442E414;
	Sat, 12 Sep 2026 10:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209719; cv=none; b=utD4ROelmBqGjEXRZHHWo2UAxoihcANXV1hWGjnfIrJ9CZgarUyfgCjIkxTAJyNcp83bGiuUlTLaetVAI+ARZf9jcQZ0yYTn+0QbA7DONdx824RmqXQYlWwUhxsUi8JafKd5a9/x4GIFixRrcE7WM/ovQjsh0II25WZiIqC0ruw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209719; c=relaxed/simple;
	bh=2J+HbCbcWbkP//U0k4WfsKh2krD9hEpoNQtYhEo3h4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=plmAhsIXsX3r+uIQp1eHDW8+HLgtpQdUCg4rpiMVoEakLXbVPHdS6tGvqdPEiYTUL+3IHcL1Y82GZjiQdm11aqZ2n2/dLexx0QRQS85hqEwN6smnLjtLdc2I6oIX3eP3JMso7z/+v8cjp8APYAogs8sRkbTrLrCq/EWycG/sZHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+1h3/0M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+1h3/0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DE31F000FF;
	Sat, 12 Sep 2026 10:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209710;
	bh=gSa4wwXTOFG7+lXvUXNQ45pu+bD7AZimDorymEZNiBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+1h3/0MWCVO0QovtP+OQUpKuPdtxexuGK439GpMEJ/iIqEGHluhZ0vD6GkIdSEDv
	 pBIZR+VszaPoCI6ib1mnUEctUATdVGbck1b7sZy/HLJcQo8cieRJHuI/THp8jq2sE8
	 chBU2fSKuQySD+mJoIhh+ZyGi3d0esjP0W4FaNu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@oss.qualcomm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0834/1518] MIPS: ptrace: Fix syscall skipping via PTRACE_SYSCALL
Date: Sat, 12 Sep 2026 08:50:03 +0200
Message-ID: <20260912065642.306389197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 3f4c94c881241..87102a03b6eaf 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -1321,8 +1321,12 @@ long arch_ptrace(struct task_struct *child, long request,
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
@@ -1342,7 +1346,7 @@ asmlinkage long syscall_trace_enter(struct pt_regs *regs)
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



