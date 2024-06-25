Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74B012EBEA;
	Tue, 25 Jun 2024 09:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308642; cv=none; b=E6z04+DJJ97zDgmPTQgux1T4Kl5kO3DR+dgYek1td2HqVfskkJoMQU2EpHuSASUz9oepiWy+EKVEg8jXYJ12bujGQjS5OPKFEfs5kDi/ZRcp6/KkEBVmXySKM5CI3vPB8SHnoT71tBo7xBHIbpc2g/BssGo6GtKGCWdxRGmRl7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308642; c=relaxed/simple;
	bh=m3/s2avDvp0q3XzSTb0qnodbWAhSTfuBp34xePG1omA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUFWLpOIyic7EX70YPxuRaAVniIkyIyLfEX5C4NzjLbkoePAwCh8IaSqb1IxVYYziv1DVESNpUVv+VCLIZYQwyh1YRV0yWcezR/faSHn5r3GHqEHzsj58U/uDCnd839PSkGZ6QEvcBNW3WYlzkJy8YNRz1KuZFbNXxPOuCeAzCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o63A2EvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o63A2EvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F845C32781;
	Tue, 25 Jun 2024 09:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308641;
	bh=m3/s2avDvp0q3XzSTb0qnodbWAhSTfuBp34xePG1omA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o63A2EvXfzSVnzCT7HpWFvH98UvKbv5V6NjHGs49KvuJ7WUNbIFxJaCjKBqtPVAcN
	 bHxyh3IsfRC62OkcJ3UE8A+odwOkTwGISL/cVqRvtZCxBAPYNVKCiSVjJGY6BDExWp
	 PPQHQtU5MgGyakEN/UJIaPb/xcCRJMlxtj9pPWyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Li <lihui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.9 190/250] LoongArch: Fix multiple hardware watchpoint issues
Date: Tue, 25 Jun 2024 11:32:28 +0200
Message-ID: <20240625085555.345862235@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Li <lihui@loongson.cn>

commit 3eb2a8b23598e90fda43abb0f23cb267bd5018ba upstream.

In the current code, if multiple hardware breakpoints/watchpoints in
a user-space thread, some of them will not be triggered.

When debugging the following code using gdb.

lihui@bogon:~$ cat test.c
  #include <stdio.h>
  int a = 0;
  int main()
  {
    printf("start test\n");
    a = 1;
    printf("a = %d\n", a);
    printf("end test\n");
    return 0;
  }
lihui@bogon:~$ gcc -g test.c -o test
lihui@bogon:~$ gdb test
...
(gdb) start
...
Temporary breakpoint 1, main () at test.c:5
5        printf("start test\n");
(gdb) watch a
Hardware watchpoint 2: a
(gdb) hbreak 8
Hardware assisted breakpoint 3 at 0x1200006ec: file test.c, line 8.
(gdb) c
Continuing.
start test
a = 1

Breakpoint 3, main () at test.c:8
8        printf("end test\n");
...

The first hardware watchpoint is not triggered, the root causes are:

1. In hw_breakpoint_control(), The FWPnCFG1.2.4/MWPnCFG1.2.4 register
   settings are not distinguished. They should be set based on hardware
   watchpoint functions (fetch or load/store operations).

2. In breakpoint_handler() and watchpoint_handler(), it doesn't identify
   which watchpoint is triggered. So, all watchpoint-related perf_event
   callbacks are called and siginfo is sent to the user space. This will
   cause user-space unable to determine which watchpoint is triggered.
   The kernel need to identity which watchpoint is triggered via MWPS/
   FWPS registers, and then call the corresponding perf event callbacks
   to report siginfo to the user-space.

Modify the relevant code to solve above issues.

All changes according to the LoongArch Reference Manual:
https://loongson.github.io/LoongArch-Documentation/LoongArch-Vol1-EN.html#control-and-status-registers-related-to-watchpoints

With this patch:

lihui@bogon:~$ gdb test
...
(gdb) start
...
Temporary breakpoint 1, main () at test.c:5
5        printf("start test\n");
(gdb) watch a
Hardware watchpoint 2: a
(gdb) hbreak 8
Hardware assisted breakpoint 3 at 0x1200006ec: file test.c, line 8.
(gdb) c
Continuing.
start test

Hardware watchpoint 2: a

Old value = 0
New value = 1
main () at test.c:7
7        printf("a = %d\n", a);
(gdb) c
Continuing.
a = 1

Breakpoint 3, main () at test.c:8
8        printf("end test\n");
(gdb) c
Continuing.
end test
[Inferior 1 (process 778) exited normally]

Cc: stable@vger.kernel.org
Signed-off-by: Hui Li <lihui@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/hw_breakpoint.c |   57 +++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 24 deletions(-)

--- a/arch/loongarch/kernel/hw_breakpoint.c
+++ b/arch/loongarch/kernel/hw_breakpoint.c
@@ -207,15 +207,15 @@ static int hw_breakpoint_control(struct
 	switch (ops) {
 	case HW_BREAKPOINT_INSTALL:
 		/* Set the FWPnCFG/MWPnCFG 1~4 register. */
-		write_wb_reg(CSR_CFG_ADDR, i, 0, info->address);
-		write_wb_reg(CSR_CFG_ADDR, i, 1, info->address);
-		write_wb_reg(CSR_CFG_MASK, i, 0, info->mask);
-		write_wb_reg(CSR_CFG_MASK, i, 1, info->mask);
-		write_wb_reg(CSR_CFG_ASID, i, 0, 0);
-		write_wb_reg(CSR_CFG_ASID, i, 1, 0);
 		if (info->ctrl.type == LOONGARCH_BREAKPOINT_EXECUTE) {
+			write_wb_reg(CSR_CFG_ADDR, i, 0, info->address);
+			write_wb_reg(CSR_CFG_MASK, i, 0, info->mask);
+			write_wb_reg(CSR_CFG_ASID, i, 0, 0);
 			write_wb_reg(CSR_CFG_CTRL, i, 0, privilege);
 		} else {
+			write_wb_reg(CSR_CFG_ADDR, i, 1, info->address);
+			write_wb_reg(CSR_CFG_MASK, i, 1, info->mask);
+			write_wb_reg(CSR_CFG_ASID, i, 1, 0);
 			ctrl = encode_ctrl_reg(info->ctrl);
 			write_wb_reg(CSR_CFG_CTRL, i, 1, ctrl | privilege);
 		}
@@ -226,14 +226,17 @@ static int hw_breakpoint_control(struct
 		break;
 	case HW_BREAKPOINT_UNINSTALL:
 		/* Reset the FWPnCFG/MWPnCFG 1~4 register. */
-		write_wb_reg(CSR_CFG_ADDR, i, 0, 0);
-		write_wb_reg(CSR_CFG_ADDR, i, 1, 0);
-		write_wb_reg(CSR_CFG_MASK, i, 0, 0);
-		write_wb_reg(CSR_CFG_MASK, i, 1, 0);
-		write_wb_reg(CSR_CFG_CTRL, i, 0, 0);
-		write_wb_reg(CSR_CFG_CTRL, i, 1, 0);
-		write_wb_reg(CSR_CFG_ASID, i, 0, 0);
-		write_wb_reg(CSR_CFG_ASID, i, 1, 0);
+		if (info->ctrl.type == LOONGARCH_BREAKPOINT_EXECUTE) {
+			write_wb_reg(CSR_CFG_ADDR, i, 0, 0);
+			write_wb_reg(CSR_CFG_MASK, i, 0, 0);
+			write_wb_reg(CSR_CFG_CTRL, i, 0, 0);
+			write_wb_reg(CSR_CFG_ASID, i, 0, 0);
+		} else {
+			write_wb_reg(CSR_CFG_ADDR, i, 1, 0);
+			write_wb_reg(CSR_CFG_MASK, i, 1, 0);
+			write_wb_reg(CSR_CFG_CTRL, i, 1, 0);
+			write_wb_reg(CSR_CFG_ASID, i, 1, 0);
+		}
 		if (bp->hw.target)
 			regs->csr_prmd &= ~CSR_PRMD_PWE;
 		break;
@@ -476,12 +479,15 @@ void breakpoint_handler(struct pt_regs *
 	slots = this_cpu_ptr(bp_on_reg);
 
 	for (i = 0; i < boot_cpu_data.watch_ireg_count; ++i) {
-		bp = slots[i];
-		if (bp == NULL)
-			continue;
-		perf_bp_event(bp, regs);
+		if ((csr_read32(LOONGARCH_CSR_FWPS) & (0x1 << i))) {
+			bp = slots[i];
+			if (bp == NULL)
+				continue;
+			perf_bp_event(bp, regs);
+			csr_write32(0x1 << i, LOONGARCH_CSR_FWPS);
+			update_bp_registers(regs, 0, 0);
+		}
 	}
-	update_bp_registers(regs, 0, 0);
 }
 NOKPROBE_SYMBOL(breakpoint_handler);
 
@@ -493,12 +499,15 @@ void watchpoint_handler(struct pt_regs *
 	slots = this_cpu_ptr(wp_on_reg);
 
 	for (i = 0; i < boot_cpu_data.watch_dreg_count; ++i) {
-		wp = slots[i];
-		if (wp == NULL)
-			continue;
-		perf_bp_event(wp, regs);
+		if ((csr_read32(LOONGARCH_CSR_MWPS) & (0x1 << i))) {
+			wp = slots[i];
+			if (wp == NULL)
+				continue;
+			perf_bp_event(wp, regs);
+			csr_write32(0x1 << i, LOONGARCH_CSR_MWPS);
+			update_bp_registers(regs, 0, 1);
+		}
 	}
-	update_bp_registers(regs, 0, 1);
 }
 NOKPROBE_SYMBOL(watchpoint_handler);
 


