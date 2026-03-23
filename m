Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FD8395DB5;
	Mon, 23 Mar 2026 16:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283342; cv=none; b=FCco30KkWcfca322iVUtWL1545c/WQvTd8LcdMtGf22aQZ1qHjVN+zvbLtN/OxZKVt2lhVLPEJITMV98bkiJ5DGsfJO0x6P1fH07AJv9GchYfHxpTWqeV0JN7mVbPkNl7/MHoFTVZ5CxMAwyWBspiy29nWNVk4IGHA5u3dLamko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283342; c=relaxed/simple;
	bh=a+lHdsBImeJBCpI3God7Eso43qDuQmwpZtE3rQqneUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWTTakj6NIVzlxIdxzE6+TsQGzwNNC2wXQ76tnVPAaAvX4BHYgeo6p3GFAgdRi6t5VjJy+JNWKVe1UQRbjIiFqTq9a2NFOoPmlbqbR/UILQRZVUkv/P1u7vykIteCNaXcL05ORuD4u/eUnbs9oZAp12dWTvI1Q4dsCtsbL5b0tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R16wdR3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R16wdR3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65AFC2BC9E;
	Mon, 23 Mar 2026 16:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283342;
	bh=a+lHdsBImeJBCpI3God7Eso43qDuQmwpZtE3rQqneUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R16wdR3wKHCJB8gZc0uulrjNGnn9hb1xPRYtgh4XYE2M3WNhsT3JMOcXQBG9LjRvK
	 BwiVedIy03xKgVGgZNmNP53nvZmGu963xpingnjT7gH0ODEK0o+f8mtpDKN0/khUyS
	 pBGKMn0FLPD+2dgjv9LI7xgErMTukCx/jpvXqCCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>,
	Jianqiang kang <jianqkang@sina.cn>
Subject: [PATCH 6.1 476/481] riscv: stacktrace: Disable KASAN checks for non-current tasks
Date: Mon, 23 Mar 2026 14:47:38 +0100
Message-ID: <20260323134536.818979578@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ Minor conflict resolved. ]
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/stacktrace.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

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
 extern asmlinkage void ret_from_exception(void);
 
 static inline int fp_is_valid(unsigned long fp, unsigned long sp)
@@ -68,8 +84,9 @@ void notrace walk_stackframe(struct task
 			fp = frame->ra;
 			pc = regs->ra;
 		} else {
-			fp = frame->fp;
-			pc = ftrace_graph_ret_addr(current, &graph_idx, frame->ra,
+			fp = READ_ONCE_TASK_STACK(task, frame->fp);
+			pc = READ_ONCE_TASK_STACK(task, frame->ra);
+			pc = ftrace_graph_ret_addr(current, &graph_idx, pc,
 						   &frame->ra);
 			if (pc == (unsigned long)ret_from_exception) {
 				if (unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))


