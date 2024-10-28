Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDDD18E37F;
	Mon, 28 Oct 2024 06:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097887; cv=none; b=A3YkNX2EpebDxqeGI5QuuapFPHVnmELT6znDY0K3W5E9o48P2HSp7tmZhLvtvUESmYRX5SMk7T/1A92EPVhgkshZK1DOhdwWTVbR4nsl66WVcJSjdGbHrkBfw9gfanDUEkpaBEPVQS0dXir9kB/QLwRBTJ45bV6XKUHqBznMzuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097887; c=relaxed/simple;
	bh=nGgv3Ufc221LknFO0CWKUruhXSD8hNQAanCFZPyyml0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJ2+N2rol+N9c5MzSxvae17UBI8rbljH4HR89/LCkqSyUM0Pgl/pkbMMTVHY2KQ+njBNBlmatW4n+csodC5GLiMmbHq0juJcTzVlxuUVkFLL0Eq53kJN4JsAHFEsBTVLLBJdnUHmaHXfcsCSpIYGNF3o1r9gKQy332uubfIoDJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfXNYpTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfXNYpTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DBCC4CEC3;
	Mon, 28 Oct 2024 06:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097886;
	bh=nGgv3Ufc221LknFO0CWKUruhXSD8hNQAanCFZPyyml0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfXNYpTgiBjRoWQO718LGbxyhf1F2REsYZDtMcQ+LFeZfQyYI1g91g2DrQARjN4i3
	 SLbfKLPRmQ2meqSkL/cO8yfneNTtHhoO6zli9rMSF0vsvHu4LaHASL2dOSASZHHIsp
	 74aCBByp86yx+DZdrCLD2KefvWbhofYjU91O7dfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 192/208] LoongArch: Enable IRQ if do_ale() triggered in irq-enabled context
Date: Mon, 28 Oct 2024 07:26:12 +0100
Message-ID: <20241028062311.360553137@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 69cc6fad5df4ce652d969be69acc60e269e5eea1 upstream.

Unaligned access exception can be triggered in irq-enabled context such
as user mode, in this case do_ale() may call get_user() which may cause
sleep. Then we will get:

 BUG: sleeping function called from invalid context at arch/loongarch/kernel/access-helper.h:7
 in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 129, name: modprobe
 preempt_count: 0, expected: 0
 RCU nest depth: 0, expected: 0
 CPU: 0 UID: 0 PID: 129 Comm: modprobe Tainted: G        W          6.12.0-rc1+ #1723
 Tainted: [W]=WARN
 Stack : 9000000105e0bd48 0000000000000000 9000000003803944 9000000105e08000
         9000000105e0bc70 9000000105e0bc78 0000000000000000 0000000000000000
         9000000105e0bc78 0000000000000001 9000000185e0ba07 9000000105e0b890
         ffffffffffffffff 9000000105e0bc78 73924b81763be05b 9000000100194500
         000000000000020c 000000000000000a 0000000000000000 0000000000000003
         00000000000023f0 00000000000e1401 00000000072f8000 0000007ffbb0e260
         0000000000000000 0000000000000000 9000000005437650 90000000055d5000
         0000000000000000 0000000000000003 0000007ffbb0e1f0 0000000000000000
         0000005567b00490 0000000000000000 9000000003803964 0000007ffbb0dfec
         00000000000000b0 0000000000000007 0000000000000003 0000000000071c1d
         ...
 Call Trace:
 [<9000000003803964>] show_stack+0x64/0x1a0
 [<9000000004c57464>] dump_stack_lvl+0x74/0xb0
 [<9000000003861ab4>] __might_resched+0x154/0x1a0
 [<900000000380c96c>] emulate_load_store_insn+0x6c/0xf60
 [<9000000004c58118>] do_ale+0x78/0x180
 [<9000000003801bc8>] handle_ale+0x128/0x1e0

So enable IRQ if unaligned access exception is triggered in irq-enabled
context to fix it.

Cc: stable@vger.kernel.org
Reported-by: Binbin Zhou <zhoubinbin@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/traps.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/loongarch/kernel/traps.c
+++ b/arch/loongarch/kernel/traps.c
@@ -529,6 +529,9 @@ asmlinkage void noinstr do_ale(struct pt
 #else
 	unsigned int *pc;
 
+	if (regs->csr_prmd & CSR_PRMD_PIE)
+		local_irq_enable();
+
 	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, regs->csr_badvaddr);
 
 	/*
@@ -553,6 +556,8 @@ sigbus:
 	die_if_kernel("Kernel ale access", regs);
 	force_sig_fault(SIGBUS, BUS_ADRALN, (void __user *)regs->csr_badvaddr);
 out:
+	if (regs->csr_prmd & CSR_PRMD_PIE)
+		local_irq_disable();
 #endif
 	irqentry_exit(regs, state);
 }


