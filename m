Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A2E8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC64DC433C8;
	Sun, 16 Jul 2023 20:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540333;
	bh=6aA1n+PwuxV39DByCKJBPk8LXhWjNlUOrF11QTq1ccc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkPrHZqRXU5NRyTPUzYkqxYMJCghau6wDrc37xRHc1Dp0LGVvNaPeVtrY0oReKa7p
	 fiHNcPaXdC6fqEy74y0R4WQwuXIu27VlGICaeIlDIht1rCYXBPdoYB5SJfSAsaymJ1
	 0sf3T/Xe9YuPjN7JfqAYkEnPDXTUcauWCvopPItk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Oleg Nesterov <oleg@redhat.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 326/591] riscv: uprobes: Restore thread.bad_cause
Date: Sun, 16 Jul 2023 21:47:45 +0200
Message-ID: <20230716194932.324637680@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 58b1294dd1d65bb62f08dddbf418f954210c2057 ]

thread.bad_cause is saved in arch_uprobe_pre_xol(), it should be restored
in arch_uprobe_{post,abort}_xol() accordingly, otherwise the save operation
is meaningless, this change is similar with x86 and powerpc.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
Fixes: 74784081aac8 ("riscv: Add uprobes supported")
Link: https://lore.kernel.org/r/1682214146-3756-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/probes/uprobes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kernel/probes/uprobes.c b/arch/riscv/kernel/probes/uprobes.c
index c976a21cd4bd5..194f166b2cc40 100644
--- a/arch/riscv/kernel/probes/uprobes.c
+++ b/arch/riscv/kernel/probes/uprobes.c
@@ -67,6 +67,7 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	struct uprobe_task *utask = current->utask;
 
 	WARN_ON_ONCE(current->thread.bad_cause != UPROBE_TRAP_NR);
+	current->thread.bad_cause = utask->autask.saved_cause;
 
 	instruction_pointer_set(regs, utask->vaddr + auprobe->insn_size);
 
@@ -102,6 +103,7 @@ void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
 {
 	struct uprobe_task *utask = current->utask;
 
+	current->thread.bad_cause = utask->autask.saved_cause;
 	/*
 	 * Task has received a fatal signal, so reset back to probbed
 	 * address.
-- 
2.39.2



