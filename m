Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC9C6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA8CC433EF;
	Mon, 16 Jan 2023 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888253;
	bh=RRc6PxZrNb/9zlN9jtET/UgnYqZNtrE53j4/sJZEqvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1jg4lQCmd1hNlJRrVEE1vk57DFm3o3v5o38Q7Ryws3he7kp6fBvWh3GVCcSS6E/3
	 ZNDyBu3xG/kE+LzRMAGl4SbgBrghJJrwBoHMjY7nEDGA5d9yoQ2ji4CE9aoe6/ciSo
	 SNYsRR8CzQgcLqTNgctyT3yiE0MhCQ0QSQEZp+2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Huang <chenhuang5@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Palmer Dabbelt <palmerdabbelt@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 429/521] riscv/stacktrace: Fix stack output without ra on the stack top
Date: Mon, 16 Jan 2023 16:51:31 +0100
Message-Id: <20230116154906.321065506@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index 39cd3cf9f06b..3d1e184e39e9 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -63,9 +63,15 @@ static void notrace walk_stackframe(struct task_struct *task,
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



