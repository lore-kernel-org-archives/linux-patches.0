Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DD5207E14;
	Tue,  8 Apr 2025 12:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114113; cv=none; b=sRfpjldoXPBsHJ0lZmncZfwixVORQi5gl475+37C+dYSE9JMEeqMK/of3Ogz8AnCtRTysX7pZmY3EaaSS7Bt28JfQByQFyYtK+6FOyYuZyII+nrEi+R9jQ6CB3AeUfo+rCYWWXYtPa+G5+8dil4fDM/m55nKc9h3y8nGHxvpvwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114113; c=relaxed/simple;
	bh=+L9+1ggGQKHCkIsdt8pmr5qIgcSxq7aCgfk5JQ+rvSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMjLEspO/SwLh3w6P31C8LPiabkyyUZ51osDPIZtLtaFxTa8Gr4tTrAEbGF3bWfHaKeYYA8xfU2EDrIIJ1/8dxfF/ejKMBkG0Ssdx353i9z4WjFKOwRnqP6qyvsYZPH4tz4bIXyLKoaMYrcuMuCqnqKCmC/qyigxeiBAuQYq5zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X3MxHWAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3MxHWAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD960C4CEE5;
	Tue,  8 Apr 2025 12:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114113;
	bh=+L9+1ggGQKHCkIsdt8pmr5qIgcSxq7aCgfk5JQ+rvSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3MxHWAd7Y6kP+pPbLk/cl4S/dIgUKs4YtaTB8QhNZoPYViQDajZmVyGyK1g2jUrN
	 FZrm3MWN8EIoOqvr1So2O/+k7sWUYBv88URfgBkPLNsq9xDzMda95A73o+O8X5hhqq
	 tyHDRccfjFoCCVsXr6FFvoilYRz4fveCsT11qK54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/154] x86/dumpstack: Fix inaccurate unwinding from exception stacks due to misplaced assignment
Date: Tue,  8 Apr 2025 12:50:55 +0200
Message-ID: <20250408104818.984657908@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9b2bbb66d0c87..caf14c49539ba 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -171,6 +171,7 @@ void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	printk("%sCall Trace:\n", log_lvl);
 
 	unwind_start(&state, task, regs, stack);
+	stack = stack ?: get_stack_pointer(task, regs);
 	regs = unwind_get_entry_regs(&state, &partial);
 
 	/*
@@ -189,9 +190,7 @@ void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
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



