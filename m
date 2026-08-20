Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B681C380FD6;
	Thu, 20 Aug 2026 15:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239169; cv=none; b=VlUO37Cb4e1Cto3p+UeLhoC47v+NprHxbNuOqjdt7RdKAQWTzkGV6csTUjHFeW64e8pClS2ZRofVI6WUaPumME5h7tvgjrlWsOtgCHEWeRIKNczwai+Jds9SQ6JMyCtd1i9nHIPKld7bsyUgeXkPJBS1sstKT06uu1IHBDLA92Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239169; c=relaxed/simple;
	bh=9QYeubG/RfzTK//J1n0okhom7sy7DVq9zCDcKEhL/wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMYDlyKny4Ef2WLZtdTAeGhGL/kVRlWbIJtHjjahDIwl2oyeuTnW2CEh/eVJ664HBwpHkWUpWDfWvEZavM/dIlr74iVoccuC+3WUEPhteg0mA+62/KzPYddc9hJW+S6B6+BkjTsqzjMH863aPhd25vgYBWsbmZuHoDyw+TK6KzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0ruXNmX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0ruXNmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089C11F00A3A;
	Thu, 20 Aug 2026 15:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239167;
	bh=mPXKGmSiV5L0uovdHGel/n4+y3kuoDGeMDpN9U3QTcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y0ruXNmXMvvqRUKFEctYlDuoWP08MIJkbkpH3H2zK/0tLlE/cwiA/tdIu5p08lTx8
	 cWh5R8836rvWP+kxDiUrWqoUHi/EoeedXWInQuYnuAJFgPS7EfN3GfVuOeKBEmXA/i
	 x9YnqHh+4rasfiNtDPYaXNSNgzxlvBXiOQQewTMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 174/217] riscv: ftrace: Fix ftrace_modify_call failure on kprobed functions
Date: Thu, 20 Aug 2026 16:55:42 +0200
Message-ID: <20260820145242.973850691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 2820d227ad4ee70805d693d698437cc3e88d6c3d ]

We are frequently hitting the following splat during the riscv bpf
selftests:

00000000026dc75a: expected (7c3ff297) but got (00100073)
------------[ ftrace bug ]------------
ftrace failed to modify
[<ffffffff03c44c1c>] bpf_kfunc_common_test+0x4/0x20 [bpf_testmod]
 actual:   e7:82:c2:ce
Updating ftrace call site to call a different ftrace function
ftrace record flags: 80100002
 (2)
 expected tramp: ffffffff80043904
------------[ cut here ]------------
WARNING: kernel/trace/ftrace.c:2278 at ftrace_bug+0x46e/0x4b0, CPU#1: test_progs/98
...
[<ffffffff80008f4e>] ftrace_bug+0x46e/0x4b0
[<ffffffff803d3e86>] ftrace_replace_code+0x16e/0x170
[<ffffffff803d42b6>] ftrace_modify_all_code+0x12e/0x1b8
[<ffffffff800430f4>] arch_ftrace_update_code+0x14/0x28
[<ffffffff803e0324>] ftrace_startup+0x14c/0x2a0
[<ffffffff803e133c>] ftrace_startup_subops+0x584/0x1050
[<ffffffff804500e6>] register_ftrace_graph+0x4e6/0x1018
[<ffffffff804cf9f6>] register_fprobe_ips+0xc66/0x12f8
[<ffffffff8049abe8>] bpf_kprobe_multi_link_attach+0x5d8/0xe68
[<ffffffff8050fcaa>] __sys_bpf+0x3d5a/0x47f0
[<ffffffff805107ee>] __riscv_sys_bpf+0xae/0x168
[<ffffffff80034d78>] syscall_handler+0x60/0x100
[<ffffffff8228b4f4>] do_trap_ecall_u+0x174/0x208
[<ffffffff822b69c4>] handle_exception+0x16c/0x178

After debugging, it can be triggered by similar commands below:
```
echo do_nanosleep > set_ftrace_filter
echo function > current_tracer
echo 'p do_nanosleep' > kprobe_events
echo 1 > events/kprobes/enable
echo 'f do_nanosleep' > dynamic_events
echo 1 > events/fprobes/enable
```

The reason is that attaching a kprobe to an ftrace-traced function entry
replaces its initial auipc insn with ebreak. When ftrace_modify_call
later runs, it expects auipc insn, so verification fails and triggers
ftrace_bug.

The expected auipc logic remains conceptually unchanged, and kprobe
single-stepping ensures normal execution. Therefore, if the first insn
is ebreak, bypassing the check to continue patching the jalr insn is
safe and avoids ftrace failures.

Fixes: b2137c3b6d7a ("riscv: ftrace: prepare ftrace for atomic code patching")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Link: https://patch.msgid.link/20260802094929.3978390-1-pulehui@huaweicloud.com
[pjw@kernel.org: fixed reproducer in commit message]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/ftrace.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/ftrace.c b/arch/riscv/kernel/ftrace.c
index 8d18d6727f0fc..c201c6bac1dda 100644
--- a/arch/riscv/kernel/ftrace.c
+++ b/arch/riscv/kernel/ftrace.c
@@ -12,6 +12,7 @@
 #include <linux/stop_machine.h>
 #include <asm/cacheflush.h>
 #include <asm/text-patching.h>
+#include <asm/insn.h>
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 void ftrace_arch_code_modify_prepare(void)
@@ -63,7 +64,9 @@ static int __ftrace_modify_call(unsigned long source, unsigned long target, bool
 		if (copy_from_kernel_nofault(replaced, (void *)source, 2 * MCOUNT_INSN_SIZE))
 			return -EFAULT;
 
-		if (replaced[0] != call[0]) {
+		/* Bypass the check if the auipc insn is a kprobe breakpoint */
+		if (replaced[0] != call[0] &&
+		    !(riscv_insn_is_ebreak(replaced[0]) || riscv_insn_is_c_ebreak(replaced[0]))) {
 			pr_err("%p: expected (%08x) but got (%08x)\n",
 			       (void *)source, call[0], replaced[0]);
 			return -EINVAL;
-- 
2.53.0



