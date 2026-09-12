Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137D6288B9;
	Sat, 12 Sep 2026 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230839; cv=none; b=QFbYJlvIp3+k4Tlo8SKeRbCnQzBEUxULZ17srqjZnXU6nu+OOmlQ1bNnwTYlXT9fosRI3Ye3K4HyTVazrGht+be0Tnf0Iie5ycfmHinexJaBxynI9WK//61roGT8z59bbdkBXaPfmrN3uDFstuCYNlE3tDEp0ZXqZrsy5Eh4Akk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230839; c=relaxed/simple;
	bh=p83GcGobCjp3CEHrI4Twod8s3ySXaNgtazTPp2Nh8nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cWVXCx77B+9cIXbXV8R6g6Y9vU9ucid/xqAdIDqgWgvwM0B7Rzvv61CnmiKBcoPT/uQcoEcorcq2TUfnIUZLD4QTS0tAIBgu5wu5yc3spIVz+jb73ndxS9YNJrBllQsaSU/6eN5SnEgTCuZ53fJoi0jdGU4eYXDH7PJSBiORFPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=In/vXZEs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="In/vXZEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCD61F00893;
	Sat, 12 Sep 2026 16:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230838;
	bh=UBk1MLXU+aJzN2kZ3x0QrcrSeBhG8a5Hq4KJbkBqQr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=In/vXZEs91H+eaPI1S4irJnUFzCP6pZU99Ve+6jMWtzyYrDKJ6kA126jsPWI6MGC+
	 Sadh79IljhFsvE7oyfV3CC7Q2+A3N8KJwBKXVCdyAoPaDKVGVqWFPMvEbB8C42RW6y
	 AT2MywqWLX1LvcSUdy9Jd6/DrizKdtl8gdAjbP5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@oss.qualcomm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0833/1191] MIPS: ptrace: Fix syscall skipping via PTRACE_SYSCALL
Date: Sat, 12 Sep 2026 08:59:21 +0200
Message-ID: <20260912065606.971631064@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fdcaad9fba1dc..39dc17f456d5b 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -1318,8 +1318,12 @@ long arch_ptrace(struct task_struct *child, long request,
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
@@ -1355,7 +1359,7 @@ asmlinkage long syscall_trace_enter(struct pt_regs *regs)
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



