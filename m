Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE6922333B;
	Mon, 23 Jun 2025 22:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716979; cv=none; b=Y3cm+15Ksd32ahSmY+4cLvfktfnuxgVXyzyU5RLe8e7S1kNg1CuEPL+15rY9IsrDo0HjFE1iQR7TVw/ieYTYr38Mv+DqNGgcQJ/otSwPO4nolYqTBRNpXcFiLrs1U2tySJscEvQSVS8XW+Z5c8f0N/T1h7tZ5D0PhZk6hv145GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716979; c=relaxed/simple;
	bh=uRdcyUwbrBnNhaW/akOHPGEcfiU8nHNNbcsKshQ68O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naH9NForRw+KJjvLbV6z/d0OyRaj5ZaL+FXbBb0q5k2A0kjOe3f+9qAu56gf1yQU4pcqX0dEDpBnTl0qVKmBkZkSabR5KF9dqtDTDp+IR4ePSke6DyPvXpUAUB6O3sWkO/hhE+IfyDU6IW11JrYt2liv2xLXww4rAyh2aBeeKWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbDpi553; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbDpi553"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44609C4CEED;
	Mon, 23 Jun 2025 22:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716979;
	bh=uRdcyUwbrBnNhaW/akOHPGEcfiU8nHNNbcsKshQ68O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbDpi5535ttzocDRF2wiP7GX9deWNxZwONgHpxOFV19KdoODBmFcZ4NS9zbSGEiue
	 0deB+CdUHPq7ewVSNwG/pzQnzl2xHka4CMHOd6VGAV1CdrmYBU4phPjkeX8TSI+Yo4
	 FXWnCnPjcvPnw1KJG2ULvJD5m/N+0e0bbqDDCI8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 574/592] arm64/ptrace: Fix stack-out-of-bounds read in regs_get_kernel_stack_nth()
Date: Mon, 23 Jun 2025 15:08:52 +0200
Message-ID: <20250623130714.092206983@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tengda Wu <wutengda@huaweicloud.com>

[ Upstream commit 39dfc971e42d886e7df01371cd1bef505076d84c ]

KASAN reports a stack-out-of-bounds read in regs_get_kernel_stack_nth().

Call Trace:
[   97.283505] BUG: KASAN: stack-out-of-bounds in regs_get_kernel_stack_nth+0xa8/0xc8
[   97.284677] Read of size 8 at addr ffff800089277c10 by task 1.sh/2550
[   97.285732]
[   97.286067] CPU: 7 PID: 2550 Comm: 1.sh Not tainted 6.6.0+ #11
[   97.287032] Hardware name: linux,dummy-virt (DT)
[   97.287815] Call trace:
[   97.288279]  dump_backtrace+0xa0/0x128
[   97.288946]  show_stack+0x20/0x38
[   97.289551]  dump_stack_lvl+0x78/0xc8
[   97.290203]  print_address_description.constprop.0+0x84/0x3c8
[   97.291159]  print_report+0xb0/0x280
[   97.291792]  kasan_report+0x84/0xd0
[   97.292421]  __asan_load8+0x9c/0xc0
[   97.293042]  regs_get_kernel_stack_nth+0xa8/0xc8
[   97.293835]  process_fetch_insn+0x770/0xa30
[   97.294562]  kprobe_trace_func+0x254/0x3b0
[   97.295271]  kprobe_dispatcher+0x98/0xe0
[   97.295955]  kprobe_breakpoint_handler+0x1b0/0x210
[   97.296774]  call_break_hook+0xc4/0x100
[   97.297451]  brk_handler+0x24/0x78
[   97.298073]  do_debug_exception+0xac/0x178
[   97.298785]  el1_dbg+0x70/0x90
[   97.299344]  el1h_64_sync_handler+0xcc/0xe8
[   97.300066]  el1h_64_sync+0x78/0x80
[   97.300699]  kernel_clone+0x0/0x500
[   97.301331]  __arm64_sys_clone+0x70/0x90
[   97.302084]  invoke_syscall+0x68/0x198
[   97.302746]  el0_svc_common.constprop.0+0x11c/0x150
[   97.303569]  do_el0_svc+0x38/0x50
[   97.304164]  el0_svc+0x44/0x1d8
[   97.304749]  el0t_64_sync_handler+0x100/0x130
[   97.305500]  el0t_64_sync+0x188/0x190
[   97.306151]
[   97.306475] The buggy address belongs to stack of task 1.sh/2550
[   97.307461]  and is located at offset 0 in frame:
[   97.308257]  __se_sys_clone+0x0/0x138
[   97.308910]
[   97.309241] This frame has 1 object:
[   97.309873]  [48, 184) 'args'
[   97.309876]
[   97.310749] The buggy address belongs to the virtual mapping at
[   97.310749]  [ffff800089270000, ffff800089279000) created by:
[   97.310749]  dup_task_struct+0xc0/0x2e8
[   97.313347]
[   97.313674] The buggy address belongs to the physical page:
[   97.314604] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x14f69a
[   97.315885] flags: 0x15ffffe00000000(node=1|zone=2|lastcpupid=0xfffff)
[   97.316957] raw: 015ffffe00000000 0000000000000000 dead000000000122 0000000000000000
[   97.318207] raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
[   97.319445] page dumped because: kasan: bad access detected
[   97.320371]
[   97.320694] Memory state around the buggy address:
[   97.321511]  ffff800089277b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   97.322681]  ffff800089277b80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   97.323846] >ffff800089277c00: 00 00 f1 f1 f1 f1 f1 f1 00 00 00 00 00 00 00 00
[   97.325023]                          ^
[   97.325683]  ffff800089277c80: 00 00 00 00 00 00 00 00 00 f3 f3 f3 f3 f3 f3 f3
[   97.326856]  ffff800089277d00: f3 f3 00 00 00 00 00 00 00 00 00 00 00 00 00 00

This issue seems to be related to the behavior of some gcc compilers and
was also fixed on the s390 architecture before:

 commit d93a855c31b7 ("s390/ptrace: Avoid KASAN false positives in regs_get_kernel_stack_nth()")

As described in that commit, regs_get_kernel_stack_nth() has confirmed that
`addr` is on the stack, so reading the value at `*addr` should be allowed.
Use READ_ONCE_NOCHECK() helper to silence the KASAN check for this case.

Fixes: 0a8ea52c3eb1 ("arm64: Add HAVE_REGS_AND_STACK_ACCESS_API feature")
Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Link: https://lore.kernel.org/r/20250604005533.1278992-1-wutengda@huaweicloud.com
[will: Use '*addr' as the argument to READ_ONCE_NOCHECK()]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index f79b0d5f71ac9..f8345c39c7054 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -141,7 +141,7 @@ unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs, unsigned int n)
 
 	addr += n;
 	if (regs_within_kernel_stack(regs, (unsigned long)addr))
-		return *addr;
+		return READ_ONCE_NOCHECK(*addr);
 	else
 		return 0;
 }
-- 
2.39.5



