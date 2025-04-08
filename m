Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC8926AA9D;
	Tue,  8 Apr 2025 11:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111535; cv=none; b=NVeIoQPyD1y057B4eF2uQeEaYM7ZHT2sKAjFfwM5XYIuLkaOpN+ep6ZfXzvBeXF683tqi6meCvx4n6VWULsZKEtrVHmHMc3p0JSCJVD/Tv4Fl/+w70XIUb6lc2zUk53XHWtdam1wvLjVlsRjO/DbzC7zHARBWEbdUD20jvP53w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111535; c=relaxed/simple;
	bh=H2eKwQjP7/sJ6sgqfNqaLpk0ogUzaH72OEPk5Jn+Rb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqx/yvxcPCZNm8a6kLZ9W7FvxxlKqMqPKyvToD1r0TbBFp5myuWHMUAXhCeCUYRsiuvk7MxiUYUM8DzT17gplyaRhd0gjl26x5pfju9ltvOsmmOJUMUt1uvQIu3M1fwn5XDqkkudmpIvuWgGWwFLYCjDP9+PXnKFEcH9FbC0FZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGVvzMp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGVvzMp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3BBC4CEE7;
	Tue,  8 Apr 2025 11:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111535;
	bh=H2eKwQjP7/sJ6sgqfNqaLpk0ogUzaH72OEPk5Jn+Rb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGVvzMp0yVaC33CJhScBWDjVfVTNAGjYf01ZlehWmiYbe/pf0Wk0qoSOvQstuijzN
	 NgzNVcJik7eLmczZKYOmU2W2K8WhlKi7J1Wryghy690spKEFDJr2UCTlMSac3Pf0ei
	 +Pl7qYoc/gv3pWbFzIAaSB/qnb63ZvtPlg15VBLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 427/731] x86/dumpstack: Fix inaccurate unwinding from exception stacks due to misplaced assignment
Date: Tue,  8 Apr 2025 12:45:24 +0200
Message-ID: <20250408104924.206369832@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

[ Upstream commit 2c118f50d7fd4d9aefc4533a26f83338b2906b7a ]

Commit:

  2e4be0d011f2 ("x86/show_trace_log_lvl: Ensure stack pointer is aligned, again")

was intended to ensure alignment of the stack pointer; but it also moved
the initialization of the "stack" variable down into the loop header.

This was likely intended as a no-op cleanup, since the commit
message does not mention it; however, this caused a behavioral change
because the value of "regs" is different between the two places.

Originally, get_stack_pointer() used the regs provided by the caller; after
that commit, get_stack_pointer() instead uses the regs at the top of the
stack frame the unwinder is looking at. Often, there are no such regs at
all, and "regs" is NULL, causing get_stack_pointer() to fall back to the
task's current stack pointer, which is not what we want here, but probably
happens to mostly work. Other times, the original regs will point to
another regs frame - in that case, the linear guess unwind logic in
show_trace_log_lvl() will start unwinding too far up the stack, causing the
first frame found by the proper unwinder to never be visited, resulting in
a stack trace consisting purely of guess lines.

Fix it by moving the "stack = " assignment back where it belongs.

Fixes: 2e4be0d011f2 ("x86/show_trace_log_lvl: Ensure stack pointer is aligned, again")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20250325-2025-03-unwind-fixes-v1-2-acd774364768@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/dumpstack.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index a7d562697e50e..b2b118a8c09be 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -195,6 +195,7 @@ static void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	printk("%sCall Trace:\n", log_lvl);
 
 	unwind_start(&state, task, regs, stack);
+	stack = stack ?: get_stack_pointer(task, regs);
 	regs = unwind_get_entry_regs(&state, &partial);
 
 	/*
@@ -213,9 +214,7 @@ static void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	 * - hardirq stack
 	 * - entry stack
 	 */
-	for (stack = stack ?: get_stack_pointer(task, regs);
-	     stack;
-	     stack = stack_info.next_sp) {
+	for (; stack; stack = stack_info.next_sp) {
 		const char *stack_name;
 
 		stack = PTR_ALIGN(stack, sizeof(long));
-- 
2.39.5



