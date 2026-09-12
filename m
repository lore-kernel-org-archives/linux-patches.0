Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEF735AC3E;
	Sat, 12 Sep 2026 08:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203080; cv=none; b=M79fe7MvUA3FhI9+mnmWtEsweNJ0IenIxcGGrwp3yiDr22YCEqG1YnZ9K8hUjH+CbDItwHsvFWETQ9l3qxa1r0stkytN3K7KyXeccG7gNOi2OuDfAM4bemXrYJbC576HfjcKenPTMZGhEhxGfjnI1F4OWH83KvQvXEkr6kQZ400=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203080; c=relaxed/simple;
	bh=P74Kr09vSG4FFrB2WH7181PErkyql8BJ0IaByiMTclw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSEHB78iLbi3iI6We5mbc/OZzKRwe5KHiBxbDiOojjzu795jx1wM9NWAMvxQ+DKBSEqxJmlJzTlAGisqO2xORLA3oxzzFU/ajkesqWBYji+FDUjyRZLfIknqhoJTF3M0DqrxEQLOEK9L/pk8X8b7LYDd30xmcgPGhEXBSCIq07I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YO9Ulptn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YO9Ulptn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36571F000FF;
	Sat, 12 Sep 2026 08:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203078;
	bh=N4O1fFGatgiflH55i3FxwCRwKDtttz8MzaPrrdwllU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YO9UlptnBdx+/EiOTULlIKi1NwMrwp4KkkK/BX+BJDBLytgToJou7cuLCsKLnQd2W
	 3vx6HSlu6lND0ta1kpky2iBbtPgzrP40Ee+/2Icb5U8vH5QbuQA20AiN13bQEkx+Ao
	 NAqe4rcBjwk3k3NHsA+b+inGYkdKsXoOlJYL+w64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1336/1815] arm64: entry: Avoid unnecessary local_irq_disable() on kernel exit
Date: Sat, 12 Sep 2026 08:51:26 +0200
Message-ID: <20260912065720.385829440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit 39aebe0e89469c2904e60b1e977e0d4dbf33326b ]

Currently, when exiting to kernel mode, we attempt involuntary
preemption. The preemption logic expects IRQs to be disabled, which is
why we call local_irq_disable() before attempting preemption.

However, depending on the context, local_irq_disable() may be
unnecessary:

- __el1_irq(), the non-NMI EL1 IRQ path, already has IRQs disabled, so
  local_irq_disable() is redundant.

- irqentry_exit_to_kernel_mode_preempt() immediately returns when
  exiting from an NMI-like context, so calling local_irq_disable()
  beforehand is unnecessary work.

Furthermore, it confuses the pNMI state tracking when we are in a
context with interrupts disabled and the GIC_PRIO_PSR_I_SET bit is set
in the PMR, leading to a warning when
CONFIG_ARM64_DEBUG_PRIORITY_MASKING=y:

     WARNING: ./arch/arm64/include/asm/irqflags.h:63 at arm64_exit_to_kernel_mode+0xb8/0xc0, CPU#40: retsnoop/31805
     CPU: 40 UID: 0 PID: 31805 Comm: retsnoop Not tainted 7.2.0-rc6-next-20260805 #7 PREEMPTLAZY
     pstate: 234013c9 (nzCv DAIF +PAN -UAO +TCO +DIT +SSBS BTYPE=--)
     pc : arm64_exit_to_kernel_mode (arch/arm64/kernel/entry-common.c:63)
     lr : el1_abort (arch/arm64/kernel/entry-common.c:323)
     pmr: 000000f0
     Call trace:
      arm64_exit_to_kernel_mode (arch/arm64/kernel/entry-common.c:63) (P)
      el1_abort (arch/arm64/kernel/entry-common.c:323)
      el1h_64_sync_handler (arch/arm64/kernel/entry-common.c:449)
      el1h_64_sync (arch/arm64/kernel/entry.S:589)
      [...]

Split arm64_exit_to_kernel_mode() into preempt, non-preempt, and
dispatch parts so that we can avoid this extra work where it is not
needed and avoid breaking the pNMI tracking logic.

Reported-by: Breno Leitao <leitao@debian.org>
Fixes: ae654112eac0 ("arm64: entry: Use split preemption logic")
Link: https://lore.kernel.org/all/20260807-arm64_fix-v1-1-d069ccf9d71b@debian.org/
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/entry-common.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index ceb4eb11232a6..bda824628a20e 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -52,16 +52,36 @@ static noinstr irqentry_state_t arm64_enter_from_kernel_mode(struct pt_regs *reg
  * After this function returns it is not safe to call regular kernel code,
  * instrumentable code, or any code which may trigger an exception.
  */
-static void noinstr arm64_exit_to_kernel_mode(struct pt_regs *regs,
-					      irqentry_state_t state)
+static void noinstr __arm64_exit_to_kernel_mode(struct pt_regs *regs,
+						irqentry_state_t state)
 {
-	local_irq_disable();
-	irqentry_exit_to_kernel_mode_preempt(regs, state);
 	local_daif_mask();
 	mte_check_tfsr_exit();
 	irqentry_exit_to_kernel_mode_after_preempt(regs, state);
 }
 
+/*
+ * We are returning from the context which allows involuntary kernel preemption
+ */
+static void noinstr arm64_exit_to_kernel_mode_preempt(struct pt_regs *regs,
+						      irqentry_state_t state)
+{
+	irqentry_exit_to_kernel_mode_preempt(regs, state);
+	__arm64_exit_to_kernel_mode(regs, state);
+}
+
+static void noinstr arm64_exit_to_kernel_mode(struct pt_regs *regs,
+					      irqentry_state_t state)
+{
+	if (!regs_irqs_disabled(regs)) {
+		local_irq_disable();
+		arm64_exit_to_kernel_mode_preempt(regs, state);
+		return;
+	}
+
+	__arm64_exit_to_kernel_mode(regs, state);
+}
+
 static __always_inline void arm64_syscall_enter_from_user_mode(struct pt_regs *regs)
 {
 	enter_from_user_mode(regs);
@@ -509,7 +529,7 @@ static __always_inline void __el1_irq(struct pt_regs *regs,
 	do_interrupt_handler(regs, handler);
 	irq_exit_rcu();
 
-	arm64_exit_to_kernel_mode(regs, state);
+	arm64_exit_to_kernel_mode_preempt(regs, state);
 }
 static void noinstr el1_interrupt(struct pt_regs *regs,
 				  void (*handler)(struct pt_regs *))
-- 
2.53.0



