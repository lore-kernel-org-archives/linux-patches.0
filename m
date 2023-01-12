Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AB279C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62968C433D2;
	Thu, 12 Jan 2023 14:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534219;
	bh=ZyZS115hb3PeZD+QWWIAkyD6eQxEvCphqh1RE6TrmAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eiSDwexcHKgq2ZP/N2W0e+UBoQjAOfiFBdTPI0/MUtfTOVgOP2NukpoIMGzbhmSLx
	 awi964D6SM6pa2XEt7A2H5AtKa3TAsfqrVolNXmk2710aT7h6mLDp/fX2K4eKVn+nB
	 hyLS50XpBEKy+T0q/0/k2tUzp6DNKGgvAKVQzLt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Huang <chenhuang5@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 705/783] riscv/stacktrace: Fix stack output without ra on the stack top
Date: Thu, 12 Jan 2023 14:57:01 +0100
Message-Id: <20230112135557.037549900@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Huang <chenhuang5@huawei.com>

[ Upstream commit f766f77a74f5784d8d4d3c36b1900731f97d08d0 ]

When a function doesn't have a callee, then it will not
push ra into the stack, such as lkdtm_BUG() function,

addi	sp,sp,-16
sd	s0,8(sp)
addi	s0,sp,16
ebreak

The struct stackframe use {fp,ra} to get information from
stack, if walk_stackframe() with pr_regs, we will obtain
wrong value and bad stacktrace,

[<ffffffe00066c56c>] lkdtm_BUG+0x6/0x8
---[ end trace 18da3fbdf08e25d5 ]---

Correct the next fp and pc, after that, full stacktrace
shown as expects,

[<ffffffe00066c56c>] lkdtm_BUG+0x6/0x8
[<ffffffe0008b24a4>] lkdtm_do_action+0x14/0x1c
[<ffffffe00066c372>] direct_entry+0xc0/0x10a
[<ffffffe000439f86>] full_proxy_write+0x42/0x6a
[<ffffffe000309626>] vfs_write+0x7e/0x214
[<ffffffe00030992a>] ksys_write+0x98/0xc0
[<ffffffe000309960>] sys_write+0xe/0x16
[<ffffffe0002014bc>] ret_from_syscall+0x0/0x2
---[ end trace 61917f3d9a9fadcd ]---

Signed-off-by: Chen Huang <chenhuang5@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Stable-dep-of: 5c3022e4a616 ("riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/stacktrace.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 595342910c3f..6cbde6b43fd2 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -57,9 +57,15 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 		/* Unwind stack frame */
 		frame = (struct stackframe *)fp - 1;
 		sp = fp;
-		fp = frame->fp;
-		pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
-					   (unsigned long *)(fp - 8));
+		if (regs && (regs->epc == pc) && (frame->fp & 0x7)) {
+			fp = frame->ra;
+			pc = regs->ra;
+		} else {
+			fp = frame->fp;
+			pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
+						   (unsigned long *)(fp - 8));
+		}
+
 	}
 }
 
-- 
2.35.1



