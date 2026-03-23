Received: from mail114-241.sinamail.sina.com.cn (mail114-241.sinamail.sina.com.cn [218.30.114.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7603203A0
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 06:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=218.30.114.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774247498; cv=none; b=RV80uSsWBFgTaPT6CoWAz75lu33/DMyv+HoI2zbO7CGJ3EQE9PNLZQPdHYJSpqwpwxeZ6LXS+XURCT6OJ+iMCLdd1W0xVXKKcZrzttLsOxSZFXQI0HGvjPNWlX1Z7W2hhtAU3FL5oKn14dpiKKp9Y87I7fhSXpuCkna5zbCWki0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774247498; c=relaxed/simple;
	bh=Rs2neo4FxLnmJGr6Qjf/JC9WoglZcU1W5DKFZwrmMtY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=l6z7Ir+LUdLWnFjDfJuNTd/BukBeA87FQ7nCPC5GxHWd1FvzmbY/YBRXht354hF6lM0WWKLqkHbBYUPFrj+MuNCfYjI42CjibVLVR1bzt5LPLo+P5Dk91Um3fOT+zI/SviAHnQrITHnK0q2ZNVg0fykRtw9H/liv5Mp+nzphiTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn; spf=pass smtp.mailfrom=sina.cn; dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b=tqjSrGGh; arc=none smtp.client-ip=218.30.114.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b="tqjSrGGh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.cn; s=201208; t=1774247492;
	bh=w/6QTn2RrWbgNuU6QaGGcFWM01G6XO+tMUvHhd4TYjY=;
	h=From:Subject:Date:Message-Id;
	b=tqjSrGGh5Dbk9pot1fi3EYg8DkQ3hgaFB3g1HRKCpMq8oX2K/C4rZwQKSFngfzvRz
	 UhyhdSe4cSae65L4hAYLvDAPw6JXGK4tMsY+zPIdKz7J1h8yFOxF+RE7EQXVfY1iS9
	 /xdfDULjrZmRiymIVT9yFJ3K/HhoA6nfcEQnBu+M=
X-SMAIL-HELO: NTT-kernel-dev
Received: from unknown (HELO NTT-kernel-dev)([60.247.85.88])
	by sina.cn (10.185.250.23) with ESMTP
	id 69C0DE330000165C; Mon, 23 Mar 2026 14:31:19 +0800 (CST)
X-Sender: jianqkang@sina.cn
X-Auth-ID: jianqkang@sina.cn
Authentication-Results: sina.cn;
	 spf=none smtp.mailfrom=jianqkang@sina.cn;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=jianqkang@sina.cn
X-SMAIL-MID: 6027208913430
X-SMAIL-UIID: F608F980582B4633BEBF41786CA6AB3D-20260323-143119-1
From: Jianqiang kang <jianqkang@sina.cn>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	zhangchunyan@iscas.ac.cn
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	xujiakai2025@iscas.ac.cn,
	linux-riscv@lists.infradead.org,
	pjw@kernel.org
Subject: [PATCH 6.1.y] riscv: stacktrace: Disable KASAN checks for non-current tasks
Date: Mon, 23 Mar 2026 14:31:14 +0800
Message-Id: <20260323063115.3555043-1-jianqkang@sina.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 arch/riscv/kernel/stacktrace.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 10e311b2759d..4f78b7962651 100644
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
@@ -68,8 +84,9 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
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
-- 
2.34.1

