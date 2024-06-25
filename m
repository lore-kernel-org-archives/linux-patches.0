Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC548149DF4;
	Tue, 25 Jun 2024 09:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309233; cv=none; b=BJce4FgC1GoL21/qcx0DUPTm6mBuqot1MnkiylXuMkKQF8Jg1sOzEMAiNijFY4tG/hReVqco4QaJeiB81nk9ci/3hjOJ7R7MT2A7n0xSqSpAzgg+PLfqMxOQa5i42++Z1BzWmyICgIYE/hC+adpt2SNVO+Lq3Ek6TvhQs7mYwc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309233; c=relaxed/simple;
	bh=YTTVPYknhhVmyeoAvuRm2bIZ2aL/Vq2ZKS204oWlNn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIVukzvc1dQCBymLp9b5t80/zZxILutRipmZbtXy8z8YRT0Q70t91Ww5uvDZOFJzMI2hj6Pw2BvvsP9VHoCQO9kpDjQaF07wVcjQKVN4nSd4ky/Ekau3nd1whnLrBViwLlyFywiKi8Ugah4n7nRVLHgf48kDbHe92y7aP+zbgOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Am2jfW3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Am2jfW3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB34BC32781;
	Tue, 25 Jun 2024 09:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309233;
	bh=YTTVPYknhhVmyeoAvuRm2bIZ2aL/Vq2ZKS204oWlNn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Am2jfW3HTDkRK2sIOHVPrZhbHraZPW1r9m/sVj2b6Im8JoG8WulVUKfuwR2B3cV7I
	 5ItjjRH3nlaRJpFQLCMP91jyV3bMC8SAJFhnyw3Xy2f6MS5e+tsjaMEijSTiAFNyHD
	 ULZIkYUnD9Qs8mJZ9mFE5OIzU4bpUCBAQkAnamFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Li <lihui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 140/192] LoongArch: Trigger user-space watchpoints correctly
Date: Tue, 25 Jun 2024 11:33:32 +0200
Message-ID: <20240625085542.533504925@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Li <lihui@loongson.cn>

commit c8e57ab0995c5b443d3c81c8a36b588776dcd0c3 upstream.

In the current code, gdb can set the watchpoint successfully through
ptrace interface, but watchpoint will not be triggered.

When debugging the following code using gdb.

lihui@bogon:~$ cat test.c
  #include <stdio.h>
  int a = 0;
  int main()
  {
	a = 1;
	printf("a = %d\n", a);
	return 0;
  }
lihui@bogon:~$ gcc -g test.c -o test
lihui@bogon:~$ gdb test
...
(gdb) watch a
...
(gdb) r
...
a = 1
[Inferior 1 (process 4650) exited normally]

No watchpoints were triggered, the root causes are:

1. Kernel uses perf_event and hw_breakpoint framework to control
   watchpoint, but the perf_event corresponding to watchpoint is
   not enabled. So it needs to be enabled according to MWPnCFG3
   or FWPnCFG3 PLV bit field in ptrace_hbp_set_ctrl(), and privilege
   is set according to the monitored addr in hw_breakpoint_control().
   Furthermore, add a judgment in ptrace_hbp_set_addr() to ensure
   kernel-space addr cannot be monitored in user mode.

2. The global enable control for all watchpoints is the WE bit of
   CSR.CRMD, and hardware sets the value to 0 when an exception is
   triggered. When the ERTN instruction is executed to return, the
   hardware restores the value of the PWE field of CSR.PRMD here.
   So, before a thread containing watchpoints be scheduled, the PWE
   field of CSR.PRMD needs to be set to 1. Add this modification in
   hw_breakpoint_control().

All changes according to the LoongArch Reference Manual:
https://loongson.github.io/LoongArch-Documentation/LoongArch-Vol1-EN.html#control-and-status-registers-related-to-watchpoints
https://loongson.github.io/LoongArch-Documentation/LoongArch-Vol1-EN.html#basic-control-and-status-registers

With this patch:

lihui@bogon:~$ gdb test
...
(gdb) watch a
Hardware watchpoint 1: a
(gdb) r
...
Hardware watchpoint 1: a

Old value = 0
New value = 1
main () at test.c:6
6		printf("a = %d\n", a);
(gdb) c
Continuing.
a = 1
[Inferior 1 (process 775) exited normally]

Cc: stable@vger.kernel.org
Signed-off-by: Hui Li <lihui@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/hw_breakpoint.h |    2 ++
 arch/loongarch/kernel/hw_breakpoint.c      |   20 +++++++++++++++++---
 arch/loongarch/kernel/ptrace.c             |   15 ++++++++++++---
 3 files changed, 31 insertions(+), 6 deletions(-)

--- a/arch/loongarch/include/asm/hw_breakpoint.h
+++ b/arch/loongarch/include/asm/hw_breakpoint.h
@@ -75,6 +75,8 @@ do {								\
 #define CSR_MWPC_NUM		0x3f
 
 #define CTRL_PLV_ENABLE		0x1e
+#define CTRL_PLV0_ENABLE	0x02
+#define CTRL_PLV3_ENABLE	0x10
 
 #define MWPnCFG3_LoadEn		8
 #define MWPnCFG3_StoreEn	9
--- a/arch/loongarch/kernel/hw_breakpoint.c
+++ b/arch/loongarch/kernel/hw_breakpoint.c
@@ -174,11 +174,21 @@ void flush_ptrace_hw_breakpoint(struct t
 static int hw_breakpoint_control(struct perf_event *bp,
 				 enum hw_breakpoint_ops ops)
 {
-	u32 ctrl;
+	u32 ctrl, privilege;
 	int i, max_slots, enable;
+	struct pt_regs *regs;
 	struct perf_event **slots;
 	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
 
+	if (arch_check_bp_in_kernelspace(info))
+		privilege = CTRL_PLV0_ENABLE;
+	else
+		privilege = CTRL_PLV3_ENABLE;
+
+	/*  Whether bp belongs to a task. */
+	if (bp->hw.target)
+		regs = task_pt_regs(bp->hw.target);
+
 	if (info->ctrl.type == LOONGARCH_BREAKPOINT_EXECUTE) {
 		/* Breakpoint */
 		slots = this_cpu_ptr(bp_on_reg);
@@ -204,13 +214,15 @@ static int hw_breakpoint_control(struct
 		write_wb_reg(CSR_CFG_ASID, i, 0, 0);
 		write_wb_reg(CSR_CFG_ASID, i, 1, 0);
 		if (info->ctrl.type == LOONGARCH_BREAKPOINT_EXECUTE) {
-			write_wb_reg(CSR_CFG_CTRL, i, 0, CTRL_PLV_ENABLE);
+			write_wb_reg(CSR_CFG_CTRL, i, 0, privilege);
 		} else {
 			ctrl = encode_ctrl_reg(info->ctrl);
-			write_wb_reg(CSR_CFG_CTRL, i, 1, ctrl | CTRL_PLV_ENABLE);
+			write_wb_reg(CSR_CFG_CTRL, i, 1, ctrl | privilege);
 		}
 		enable = csr_read64(LOONGARCH_CSR_CRMD);
 		csr_write64(CSR_CRMD_WE | enable, LOONGARCH_CSR_CRMD);
+		if (bp->hw.target)
+			regs->csr_prmd |= CSR_PRMD_PWE;
 		break;
 	case HW_BREAKPOINT_UNINSTALL:
 		/* Reset the FWPnCFG/MWPnCFG 1~4 register. */
@@ -222,6 +234,8 @@ static int hw_breakpoint_control(struct
 		write_wb_reg(CSR_CFG_CTRL, i, 1, 0);
 		write_wb_reg(CSR_CFG_ASID, i, 0, 0);
 		write_wb_reg(CSR_CFG_ASID, i, 1, 0);
+		if (bp->hw.target)
+			regs->csr_prmd &= ~CSR_PRMD_PWE;
 		break;
 	}
 
--- a/arch/loongarch/kernel/ptrace.c
+++ b/arch/loongarch/kernel/ptrace.c
@@ -608,9 +608,14 @@ static int ptrace_hbp_set_ctrl(unsigned
 		return -EINVAL;
 	}
 
-	err = ptrace_hbp_fill_attr_ctrl(note_type, ctrl, &attr);
-	if (err)
-		return err;
+	if (uctrl & CTRL_PLV_ENABLE) {
+		err = ptrace_hbp_fill_attr_ctrl(note_type, ctrl, &attr);
+		if (err)
+			return err;
+		attr.disabled = 0;
+	} else {
+		attr.disabled = 1;
+	}
 
 	return modify_user_hw_breakpoint(bp, &attr);
 }
@@ -641,6 +646,10 @@ static int ptrace_hbp_set_addr(unsigned
 	struct perf_event *bp;
 	struct perf_event_attr attr;
 
+	/* Kernel-space address cannot be monitored by user-space */
+	if ((unsigned long)addr >= XKPRANGE)
+		return -EINVAL;
+
 	bp = ptrace_hbp_get_initialised_bp(note_type, tsk, idx);
 	if (IS_ERR(bp))
 		return PTR_ERR(bp);


