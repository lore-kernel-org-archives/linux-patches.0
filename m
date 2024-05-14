Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1B047A6C;
	Tue, 14 May 2024 11:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686582; cv=none; b=uzpZccsmGtwS4LXZR3iQMZTlIrzBnMYh74bQ6G/6DfxxHuiHmG+NZAw/P2pNgYbrJXWH47qN8HDVNU7GAJUbtWlIGPZvGxua0PLIUffw3uSYYCSvk1UK4r86xg7cYYg5JiGRRfEUAQU1RV1HShBhHTgJ3mfTJQ7+4FxUy7pMULo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686582; c=relaxed/simple;
	bh=5Psr6iaAa4vZPHaN8dI9GZU+Hc0g5dScw/xYTxumaRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hD/mpl04d6gQD0QgNXWgzVDGIGeV0A6dheUzHa3gynNBi/BT7oA2dlGXlmXkrbqAHYNrxAweKqggh/UjXgn4GNkSsYDUBjYWsMWyKtKSZ5eJ0mqJNmm2KRDUb/kncuTCGI72xBvowcNyj5MvmNfoh7BGTKlkkmqjndEDmxF7pj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xaGLLDGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xaGLLDGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B502C2BD10;
	Tue, 14 May 2024 11:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686581;
	bh=5Psr6iaAa4vZPHaN8dI9GZU+Hc0g5dScw/xYTxumaRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xaGLLDGN2/Vt/jlKqSBPFEZsgsbBaamsSNxnzs4aRuDJPd+aZRo/hLomdo4gpTM2k
	 wpoEygVh4d2J3OXHw98zzy/GQV1MoBc8iHNv3rVQO7g6pZz1iHC94Jkk3Dlv4dWMSJ
	 1su32cLRvbxJljM+AoOJRWSspyshg2jyO66bJWYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boy Wu <boy.wu@mediatek.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/236] ARM: 9381/1: kasan: clear stale stack poison
Date: Tue, 14 May 2024 12:18:28 +0200
Message-ID: <20240514101025.911103565@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boy.Wu <boy.wu@mediatek.com>

[ Upstream commit c4238686f9093b98bd6245a348bcf059cdce23af ]

We found below OOB crash:

[   33.452494] ==================================================================
[   33.453513] BUG: KASAN: stack-out-of-bounds in refresh_cpu_vm_stats.constprop.0+0xcc/0x2ec
[   33.454660] Write of size 164 at addr c1d03d30 by task swapper/0/0
[   33.455515]
[   33.455767] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           O       6.1.25-mainline #1
[   33.456880] Hardware name: Generic DT based system
[   33.457555]  unwind_backtrace from show_stack+0x18/0x1c
[   33.458326]  show_stack from dump_stack_lvl+0x40/0x4c
[   33.459072]  dump_stack_lvl from print_report+0x158/0x4a4
[   33.459863]  print_report from kasan_report+0x9c/0x148
[   33.460616]  kasan_report from kasan_check_range+0x94/0x1a0
[   33.461424]  kasan_check_range from memset+0x20/0x3c
[   33.462157]  memset from refresh_cpu_vm_stats.constprop.0+0xcc/0x2ec
[   33.463064]  refresh_cpu_vm_stats.constprop.0 from tick_nohz_idle_stop_tick+0x180/0x53c
[   33.464181]  tick_nohz_idle_stop_tick from do_idle+0x264/0x354
[   33.465029]  do_idle from cpu_startup_entry+0x20/0x24
[   33.465769]  cpu_startup_entry from rest_init+0xf0/0xf4
[   33.466528]  rest_init from arch_post_acpi_subsys_init+0x0/0x18
[   33.467397]
[   33.467644] The buggy address belongs to stack of task swapper/0/0
[   33.468493]  and is located at offset 112 in frame:
[   33.469172]  refresh_cpu_vm_stats.constprop.0+0x0/0x2ec
[   33.469917]
[   33.470165] This frame has 2 objects:
[   33.470696]  [32, 76) 'global_zone_diff'
[   33.470729]  [112, 276) 'global_node_diff'
[   33.471294]
[   33.472095] The buggy address belongs to the physical page:
[   33.472862] page:3cd72da8 refcount:1 mapcount:0 mapping:00000000 index:0x0 pfn:0x41d03
[   33.473944] flags: 0x1000(reserved|zone=0)
[   33.474565] raw: 00001000 ed741470 ed741470 00000000 00000000 00000000 ffffffff 00000001
[   33.475656] raw: 00000000
[   33.476050] page dumped because: kasan: bad access detected
[   33.476816]
[   33.477061] Memory state around the buggy address:
[   33.477732]  c1d03c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   33.478630]  c1d03c80: 00 00 00 00 00 00 00 00 f1 f1 f1 f1 00 00 00 00
[   33.479526] >c1d03d00: 00 04 f2 f2 f2 f2 00 00 00 00 00 00 f1 f1 f1 f1
[   33.480415]                                                ^
[   33.481195]  c1d03d80: 00 00 00 00 00 00 00 00 00 00 04 f3 f3 f3 f3 f3
[   33.482088]  c1d03e00: f3 f3 f3 f3 00 00 00 00 00 00 00 00 00 00 00 00
[   33.482978] ==================================================================

We find the root cause of this OOB is that arm does not clear stale stack
poison in the case of cpuidle.

This patch refer to arch/arm64/kernel/sleep.S to resolve this issue.

>From cited commit [1] that explain the problem

Functions which the compiler has instrumented for KASAN place poison on
the stack shadow upon entry and remove this poison prior to returning.

In the case of cpuidle, CPUs exit the kernel a number of levels deep in
C code.  Any instrumented functions on this critical path will leave
portions of the stack shadow poisoned.

If CPUs lose context and return to the kernel via a cold path, we
restore a prior context saved in __cpu_suspend_enter are forgotten, and
we never remove the poison they placed in the stack shadow area by
functions calls between this and the actual exit of the kernel.

Thus, (depending on stackframe layout) subsequent calls to instrumented
functions may hit this stale poison, resulting in (spurious) KASAN
splats to the console.

To avoid this, clear any stale poison from the idle thread for a CPU
prior to bringing a CPU online.

>From cited commit [2]

Extend to check for CONFIG_KASAN_STACK

[1] commit 0d97e6d8024c ("arm64: kasan: clear stale stack poison")
[2] commit d56a9ef84bd0 ("kasan, arm64: unpoison stack only with CONFIG_KASAN_STACK")

Signed-off-by: Boy Wu <boy.wu@mediatek.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Fixes: 5615f69bc209 ("ARM: 9016/2: Initialize the mapping of KASan shadow memory")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/sleep.S | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/kernel/sleep.S b/arch/arm/kernel/sleep.S
index a86a1d4f34618..93afd1005b43c 100644
--- a/arch/arm/kernel/sleep.S
+++ b/arch/arm/kernel/sleep.S
@@ -127,6 +127,10 @@ cpu_resume_after_mmu:
 	instr_sync
 #endif
 	bl	cpu_init		@ restore the und/abt/irq banked regs
+#if defined(CONFIG_KASAN) && defined(CONFIG_KASAN_STACK)
+	mov	r0, sp
+	bl	kasan_unpoison_task_stack_below
+#endif
 	mov	r0, #0			@ return zero on success
 	ldmfd	sp!, {r4 - r11, pc}
 ENDPROC(cpu_resume_after_mmu)
-- 
2.43.0



