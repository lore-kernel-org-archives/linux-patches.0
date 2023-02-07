Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB14D3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552A7C433EF;
	Tue,  7 Feb 2023 13:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774917;
	bh=mqoe6X3YD2RvOwfUAxMUoPGoqHAMVDhoX0MODqiqh3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dH4k88wKgFnVh8yMCHQBWMMuKL7Y3cfnhlPOlcQpjrkeCJdQqUQ1oSxSfryvUefH1
	 PZ0pnhwnjaepAVQE1FdT6KqyCP0a39XSrfoP/4a0hVbCWErwjRWmxcDEEQnlDVaLE/
	 TF1JU3mtABtkYamACIOYHBzpo+fEMLNiqoIa+cuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@linux.alibaba.com>,
	Guo Ren <guoren@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/208] riscv: kprobe: Fixup kernel panic when probing an illegal position
Date: Tue,  7 Feb 2023 13:55:30 +0100
Message-Id: <20230207125637.768316666@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit 87f48c7ccc73afc78630530d9af51f458f58cab8 ]

The kernel would panic when probed for an illegal position. eg:

(CONFIG_RISCV_ISA_C=n)

echo 'p:hello kernel_clone+0x16 a0=%a0' >> kprobe_events
echo 1 > events/kprobes/hello/enable
cat trace

Kernel panic - not syncing: stack-protector: Kernel stack
is corrupted in: __do_sys_newfstatat+0xb8/0xb8
CPU: 0 PID: 111 Comm: sh Not tainted
6.2.0-rc1-00027-g2d398fe49a4d #490
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff80007268>] dump_backtrace+0x38/0x48
[<ffffffff80c5e83c>] show_stack+0x50/0x68
[<ffffffff80c6da28>] dump_stack_lvl+0x60/0x84
[<ffffffff80c6da6c>] dump_stack+0x20/0x30
[<ffffffff80c5ecf4>] panic+0x160/0x374
[<ffffffff80c6db94>] generic_handle_arch_irq+0x0/0xa8
[<ffffffff802deeb0>] sys_newstat+0x0/0x30
[<ffffffff800158c0>] sys_clone+0x20/0x30
[<ffffffff800039e8>] ret_from_syscall+0x0/0x4
---[ end Kernel panic - not syncing: stack-protector:
Kernel stack is corrupted in: __do_sys_newfstatat+0xb8/0xb8 ]---

That is because the kprobe's ebreak instruction broke the kernel's
original code. The user should guarantee the correction of the probe
position, but it couldn't make the kernel panic.

This patch adds arch_check_kprobe in arch_prepare_kprobe to prevent an
illegal position (Such as the middle of an instruction).

Fixes: c22b0bcb1dd0 ("riscv: Add kprobes supported")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/r/20230201040604.3390509-1-guoren@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/probes/kprobes.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/riscv/kernel/probes/kprobes.c b/arch/riscv/kernel/probes/kprobes.c
index e6e950b7cf32..388ecada500c 100644
--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -48,6 +48,21 @@ static void __kprobes arch_simulate_insn(struct kprobe *p, struct pt_regs *regs)
 	post_kprobe_handler(p, kcb, regs);
 }
 
+static bool __kprobes arch_check_kprobe(struct kprobe *p)
+{
+	unsigned long tmp  = (unsigned long)p->addr - p->offset;
+	unsigned long addr = (unsigned long)p->addr;
+
+	while (tmp <= addr) {
+		if (tmp == addr)
+			return true;
+
+		tmp += GET_INSN_LENGTH(*(u16 *)tmp);
+	}
+
+	return false;
+}
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	unsigned long probe_addr = (unsigned long)p->addr;
@@ -55,6 +70,9 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	if (probe_addr & 0x1)
 		return -EILSEQ;
 
+	if (!arch_check_kprobe(p))
+		return -EILSEQ;
+
 	/* copy instruction */
 	p->opcode = *p->addr;
 
-- 
2.39.0



