Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE58D1F1534;
	Sat, 12 Sep 2026 08:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201424; cv=none; b=g4IRcZDiIpSj0TkrqtDTu7gqByFYNxmEMAGTrnAbZVR0+BEPkNOMmsQF80c7rchQAnbZMktWsM3GcVmDTEEuZINDWYWX/3Gbu0qlldY1tENKcEcxVzMUmPhYrUCRTplnCO2d+Zz3SysTJgTronyyyISFqIeU+ZiJiWRH9gIC8Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201424; c=relaxed/simple;
	bh=6ecDvvMnk2fOZMzE2nMJ7PXWYlXqH5tm67hTBbhpgeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u4zM2f9am/TYjpdw28r7OoRQBJ1Mc6oYgz20teP5J6WwfjTZo0vYgwXfevvVRc1r6sbTNy12l8EZfe+60O5R2qOac8KS+9ZVOAOoJOYKwYBFVQPVm70NByCUssAftJCRoizygohQ/MJA5GlzewmphYjOROUpDkdA56r/RnnF6XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpgID+IU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpgID+IU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9632B1F000FF;
	Sat, 12 Sep 2026 08:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201422;
	bh=rETHKYm8yOkOowCAS2mx7gtXu4e3rSapkp70Nfv74z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JpgID+IUlQGO4eUT29Jlu7nPy1Y7lzejBH1o7VZCXQxLEi2pU4Yi0bYMY9zPfVAxN
	 eASot2YFtsNVBLgvzg1Da7M7xKt5CIprF7dgQYWP75QfbugKIzvdfso/ftXENaAzRc
	 Do83rJrUmQAj2EBDFJj1SyvhRSoUZMR1pbJxMPkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@oss.qualcomm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0992/1815] MIPS: ptrace: Fix syscall skipping via PTRACE_SYSCALL
Date: Sat, 12 Sep 2026 08:45:42 +0200
Message-ID: <20260912065712.284178718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



