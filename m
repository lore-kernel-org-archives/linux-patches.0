Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ED726B76A;
	Tue, 11 Nov 2025 01:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824733; cv=none; b=RkiFG5HRvz5ApWg3EPT5/2ich3Y3UWhlWwezo5h0qs6YUxSfNfsr+SkVbD1Hxq+EkE/nfw1I9vC4UJ1RGaE6RnFq3Q+3MO3jxe0Q7F9vROHpLvBtZiCj5zMQZfDyTm4uDJKxH+ttNxAmvHqkzxEurmbrkuqW3uNzWzzGGGxTWxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824733; c=relaxed/simple;
	bh=pt0/cspQLNc/Ls6QWX90vpBHd+tlIREkrjtrCi6SMfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyYBkZfxSWdH4flJq9+Y9lFtN+Iv3ZaTxhHDv9VpUQQdhFDP2zuk9G2RVIrZEArd+K4FVBjdEtR7dND0bjIWsY0j5INyzVC5/vs82p4ccCHCSLV1bZgDQbeEMpQBwK6WcABd06LhovqptmqFmqQVFG5Dcrx1mGqB8YvUpYTm/6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRaoQPNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRaoQPNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D579FC4CEFB;
	Tue, 11 Nov 2025 01:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824733;
	bh=pt0/cspQLNc/Ls6QWX90vpBHd+tlIREkrjtrCi6SMfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRaoQPNuBGzVLAOXdch5PVYOi05hk+CQEq0rx/6Fd8B81thYNB9AG31jdmv8vU6kQ
	 wuX0d6Iw6kleaVqmPOVJl5bWqDtTlXEfZSqkKBlv7K1EYMYApvKwXQMn/yExysWsBZ
	 8QsHDAYwtag3M9/Y9ROvvnZ3YeceNgMOBsN9mLqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 507/565] riscv: stacktrace: Disable KASAN checks for non-current tasks
Date: Tue, 11 Nov 2025 09:46:03 +0900
Message-ID: <20251111004538.351877475@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>

[ Upstream commit 060ea84a484e852b52b938f234bf9b5503a6c910 ]

Unwinding the stack of a task other than current, KASAN would report
"BUG: KASAN: out-of-bounds in walk_stackframe+0x41c/0x460"

There is a same issue on x86 and has been resolved by the commit
84936118bdf3 ("x86/unwind: Disable KASAN checks for non-current tasks")
The solution could be applied to RISC-V too.

This patch also can solve the issue:
https://seclists.org/oss-sec/2025/q4/23

Fixes: 5d8544e2d007 ("RISC-V: Generic library routines and assembly")
Co-developed-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Link: https://lore.kernel.org/r/20251022072608.743484-1-zhangchunyan@iscas.ac.cn
[pjw@kernel.org: clean up checkpatch issues]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/stacktrace.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index d4355c770c36a..5a0c0d5b449ed 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -16,6 +16,22 @@
 
 #ifdef CONFIG_FRAME_POINTER
 
+/*
+ * This disables KASAN checking when reading a value from another task's stack,
+ * since the other task could be running on another CPU and could have poisoned
+ * the stack in the meantime.
+ */
+#define READ_ONCE_TASK_STACK(task, x)			\
+({							\
+	unsigned long val;				\
+	unsigned long addr = x;				\
+	if ((task) == current)				\
+		val = READ_ONCE(addr);			\
+	else						\
+		val = READ_ONCE_NOCHECK(addr);		\
+	val;						\
+})
+
 extern asmlinkage void handle_exception(void);
 extern unsigned long ret_from_exception_end;
 
@@ -69,8 +85,9 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 			fp = frame->ra;
 			pc = regs->ra;
 		} else {
-			fp = frame->fp;
-			pc = ftrace_graph_ret_addr(current, &graph_idx, frame->ra,
+			fp = READ_ONCE_TASK_STACK(task, frame->fp);
+			pc = READ_ONCE_TASK_STACK(task, frame->ra);
+			pc = ftrace_graph_ret_addr(current, &graph_idx, pc,
 						   &frame->ra);
 			if (pc >= (unsigned long)handle_exception &&
 			    pc < (unsigned long)&ret_from_exception_end) {
-- 
2.51.0



