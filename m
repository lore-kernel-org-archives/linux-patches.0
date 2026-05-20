Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3973A3833;
	Wed, 20 May 2026 16:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294773; cv=none; b=l5vP43XP+XhCMYvACJLS0MqgF8o3cBYt8w1y+aw2CYdeAed6KVCLV2GxQDEbKfLhTDyIQo6GwadPGKZVbp1O39ERM+ycDoung6wMr0htG2FuOnmQgu7Z/tsF2yd9Yqk2P9KEtTtizDRQZsHjLSBKmk91m6ycr66wXOY/oHc9KJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294773; c=relaxed/simple;
	bh=8JF4la62F/cQmUC6jkzsBbiIX+X2sRA0fi+6p1BPOm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMKB2KYgga07SiBB9M2N02QLN/BV5rpMdfJzFYitUGqi1GvhHMVDU9qj4STaSpSeJa8aOI4rGJEi2t/Il+OJoCYKnuGk5eHXCXj3Gu82rjrCaZ5gQcPxWyVYUqMOTpQF1yi6HFnAWs4akzv0aTXfb1VDuU6vkI4qWPoRo8SveMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDw25ALW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDw25ALW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4245B1F000E9;
	Wed, 20 May 2026 16:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294771;
	bh=Wg2bF5FO2l2thSR+k3PnYKEVvnKUPff9WrmmM7UO9JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDw25ALWBwieedJYoD7cmxr26FrZTrenibgMp0rBLTlWx9SNei/+YJl6nerfBHxGy
	 1ujA93ACrN7S7zIKi4n0A430uZ7FRqjx/RCp/0xDBlVyN7OhD3Z/uJFy7mV5Sh7n8R
	 XOBT7PXYlyjPTBLEpj6lITV7KftQm3XcBh2+p6ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Andy Lutomirski <luto@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0164/1146] arm64: entry: Dont preempt with SError or Debug masked
Date: Wed, 20 May 2026 18:06:54 +0200
Message-ID: <20260520162152.003964201@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 2371bd83b3df9d833191fe58dadb0e69a794a1cd ]

On arm64, involuntary kernel preemption has been subtly broken since the
move to the generic irqentry code. When preemption occurs, the new task
may run with SError and Debug exceptions masked unexpectedly, leading to
a loss of RAS events, breakpoints, watchpoints, and single-step
exceptions.

Prior to moving to the generic irqentry code, involuntary preemption of
kernel mode would only occur when returning from regular interrupts, in
a state where interrupts were masked and all other arm64-specific
exceptions (SError, Debug, and pseudo-NMI) were unmasked. This is the
only state in which it is valid to switch tasks.

As part of moving to the generic irqentry code, the involuntary
preemption logic was moved such that involuntary preemption could occur
when returning from any (non-NMI) exception. As most exception handlers
mask all arm64-specific exceptions before this point, preemption could
occur in a state where arm64-specific exceptions were masked. This is
not a valid state to switch tasks, and resulted in the loss of
exceptions described above.

As a temporary bodge, avoid the loss of exceptions by avoiding
involuntary preemption when SError and/or Debug exceptions are masked.
Practically speaking this means that involuntary preemption will only
occur when returning from regular interrupts, as was the case before
moving to the generic irqentry code.

Fixes: 99eb057ccd67 ("arm64: entry: Move arm64_preempt_schedule_irq() into __exit_to_kernel_mode()")
Reported-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reported-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/entry-common.h | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/entry-common.h b/arch/arm64/include/asm/entry-common.h
index cab8cd78f6938..20f0a7c7bde15 100644
--- a/arch/arm64/include/asm/entry-common.h
+++ b/arch/arm64/include/asm/entry-common.h
@@ -29,14 +29,19 @@ static __always_inline void arch_exit_to_user_mode_work(struct pt_regs *regs,
 
 static inline bool arch_irqentry_exit_need_resched(void)
 {
-	/*
-	 * DAIF.DA are cleared at the start of IRQ/FIQ handling, and when GIC
-	 * priority masking is used the GIC irqchip driver will clear DAIF.IF
-	 * using gic_arch_enable_irqs() for normal IRQs. If anything is set in
-	 * DAIF we must have handled an NMI, so skip preemption.
-	 */
-	if (system_uses_irq_prio_masking() && read_sysreg(daif))
-		return false;
+	if (system_uses_irq_prio_masking()) {
+		/*
+		 * DAIF.DA are cleared at the start of IRQ/FIQ handling, and when GIC
+		 * priority masking is used the GIC irqchip driver will clear DAIF.IF
+		 * using gic_arch_enable_irqs() for normal IRQs. If anything is set in
+		 * DAIF we must have handled an NMI, so skip preemption.
+		 */
+		if (read_sysreg(daif))
+			return false;
+	} else {
+		if (read_sysreg(daif) & (PSR_D_BIT | PSR_A_BIT))
+			return false;
+	}
 
 	/*
 	 * Preempting a task from an IRQ means we leave copies of PSTATE
-- 
2.53.0



