Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37244F85DE;
	Thu, 17 Sep 2026 16:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664364; cv=none; b=Jdqbthrgo31rZfJBCZlcDq2oI+qDEqxUw+BPusR9nAI3UBP6HKWTAxHMAYmgABxiroOMs4QiLcMiTmKyGp6w6yaIig5WWGdjlaCWCQU4nCojBsy17wC47IsV68Uqf/191J9iDdDjvy83RtfLFh12uyYEgdHt5hu9winYjFQW/n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664364; c=relaxed/simple;
	bh=cmD3mg4KlknYJTa9uPrTI488LtK39FbrVpNYQtVTyTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Usg98AFBltwBITjEJdDCg9PwPm1YBEy53Ujp+duWPXXXRH+3eqdpcCxcP6lPWqOzw/MDuy/zlwj9uT2K0wx9qKphqTbPZKefOJ4JehTp/Q301Qonuwz1lyvUOn6nr+2XPUoH46WSbnljC0AHOLuTuYq4NZZvMSpvg1sF0goc/6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCbJfZ4R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCbJfZ4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0F31F000FF;
	Thu, 17 Sep 2026 16:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664362;
	bh=LRJUmCZNjHPQGfXXmNxVKJzM/ZNfKGQTpuf5Nw5QRlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rCbJfZ4RYayTPWyeMDIBeRVb3bksRxgiRNUEQvuG/FqKn8jBsognSoX6V5oNuuyfa
	 XV4Nki8fDO4QWqjoBbFVPK5pPpjk9L3dFdaJ+v3pwaeJ0WIdXdwFEo7Tb8Gh+pKOKm
	 5cpuLIcKQqIbY2TIWBC64hxINIhJaysl0bRQ0DBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0348/1250] riscv: panic if IRQ handler stacks cannot be allocated
Date: Thu, 17 Sep 2026 16:02:23 +0100
Message-ID: <20260917151601.503313341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Osama Abdelkader <osama.abdelkader@gmail.com>

[ Upstream commit 2abd0dba562551d5c27f97ce560684f534c0cf3a ]

init_irq_stacks() and init_irq_scs() may fail when arch_alloc_vmap_stack
or scs_alloc return NULL, call panic() in this case.

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Link: https://patch.msgid.link/20260404185522.21767-1-osama.abdelkader@gmail.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/irq.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kernel/irq.c b/arch/riscv/kernel/irq.c
index b6af20bc300f5..017d42e778be6 100644
--- a/arch/riscv/kernel/irq.c
+++ b/arch/riscv/kernel/irq.c
@@ -75,28 +75,34 @@ DECLARE_PER_CPU(ulong *, irq_shadow_call_stack_ptr);
 DEFINE_PER_CPU(ulong *, irq_shadow_call_stack_ptr);
 #endif
 
-static void init_irq_scs(void)
+static void __init init_irq_scs(void)
 {
 	int cpu;
+	void *s;
 
 	if (!scs_is_enabled())
 		return;
 
-	for_each_possible_cpu(cpu)
-		per_cpu(irq_shadow_call_stack_ptr, cpu) =
-			scs_alloc(cpu_to_node(cpu));
+	for_each_possible_cpu(cpu) {
+		s = scs_alloc(cpu_to_node(cpu));
+		if (!s)
+			panic("Failed to allocate IRQ shadow call stack resources\n");
+		per_cpu(irq_shadow_call_stack_ptr, cpu) = s;
+	}
 }
 
 DEFINE_PER_CPU(ulong *, irq_stack_ptr);
 
 #ifdef CONFIG_VMAP_STACK
-static void init_irq_stacks(void)
+static void __init init_irq_stacks(void)
 {
 	int cpu;
 	ulong *p;
 
 	for_each_possible_cpu(cpu) {
 		p = arch_alloc_vmap_stack(IRQ_STACK_SIZE, cpu_to_node(cpu));
+		if (!p)
+			panic("Failed to allocate IRQ stack resources\n");
 		per_cpu(irq_stack_ptr, cpu) = p;
 	}
 }
@@ -104,7 +110,7 @@ static void init_irq_stacks(void)
 /* irq stack only needs to be 16 byte aligned - not IRQ_STACK_SIZE aligned. */
 DEFINE_PER_CPU_ALIGNED(ulong [IRQ_STACK_SIZE/sizeof(ulong)], irq_stack);
 
-static void init_irq_stacks(void)
+static void __init init_irq_stacks(void)
 {
 	int cpu;
 
@@ -129,8 +135,8 @@ void do_softirq_own_stack(void)
 #endif /* CONFIG_SOFTIRQ_ON_OWN_STACK */
 
 #else
-static void init_irq_scs(void) {}
-static void init_irq_stacks(void) {}
+static void __init init_irq_scs(void) {}
+static void __init init_irq_stacks(void) {}
 #endif /* CONFIG_IRQ_STACKS */
 
 int arch_show_interrupts(struct seq_file *p, int prec)
-- 
2.53.0



