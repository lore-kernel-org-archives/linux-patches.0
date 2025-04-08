Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCC8269AF4;
	Tue,  8 Apr 2025 11:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110082; cv=none; b=O4Fo5GFWVM83d3jp33j5FU7M0N/wpO/K4a7xPDtFp1wW+kkfuER0S8HlvPxA7nPfW8ewx/pAs/ArYnqTOAFBhMYzhZb3A0KvWZattbVQ1LGG5hPyvi9JXnhqu8o/MtRLyKcl7cS/xB4T6/dqwwdOz5YVq/uoulKByjYR+9PeyfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110082; c=relaxed/simple;
	bh=T3/ao8NjAmbCabzCNvBT/dsJtlMhbBvVcuvihNvrN3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgpils//MdZuP/M7mFUNhbzlmmMgCkJNtU/MpjJzFk2MCyHHQgIbCg0LQ++gI3e+x/mX71eV6N7OVkbcFVYEYpcK7hBCuaYX6J1RzaDVm1f3wEIhG8476rxY1YAXO901Gv1x8DQ9gKAOhyRZGb5MsWeAzJUagFyqw4j/VbIDeVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0Y+GWSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0Y+GWSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9AAC4CEE7;
	Tue,  8 Apr 2025 11:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110081;
	bh=T3/ao8NjAmbCabzCNvBT/dsJtlMhbBvVcuvihNvrN3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0Y+GWSmHY6RvVBxzcdP829fySNLTbKFGe4ELAJKi/LB1ZJ9+l6EULEiMweJObDH8
	 dYUcs9eMo8/RLEF8+d1ePvJGp96R3EiIi84m9yzAmoRlVgEl0pbHvGoU35qL5ev3zS
	 1UmlT9rF9C9KA1ayl8t5HB+7lOUSRutUci0saB9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/227] x86/dumpstack: Fix inaccurate unwinding from exception stacks due to misplaced assignment
Date: Tue,  8 Apr 2025 12:48:58 +0200
Message-ID: <20250408104825.115120956@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b9736aac20eef..cf92191de2b2a 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -195,6 +195,7 @@ void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	printk("%sCall Trace:\n", log_lvl);
 
 	unwind_start(&state, task, regs, stack);
+	stack = stack ?: get_stack_pointer(task, regs);
 	regs = unwind_get_entry_regs(&state, &partial);
 
 	/*
@@ -213,9 +214,7 @@ void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
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



