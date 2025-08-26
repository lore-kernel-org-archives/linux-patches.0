Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08203469EC;
	Tue, 26 Aug 2025 11:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208077; cv=none; b=lQeewBKsZnf59jGcHa8/+yko3HUB9GZpuIX/ZL2vPR1X0Le1rNblIZZZdQCPbhEooWpfmB0c4kginDyk9YEsObxLOYXsBV7UTCkr9CQmOGWZ41Sk01qK5C5l07SfDNeAHGFDaGh/UkuLBlfZRKc6R5pO6tyKgogOhsqHpQbDouk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208077; c=relaxed/simple;
	bh=ZkCHLqLNmEPcP5CBXfS4V/7iN/b8roTdUitXcYYJzqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLFEq7CgJFT09KL+JfTUKf1ikP9MMmygKCx5qItC9bx+Z5xVD0WqQ+alKODqS9+9saRAn5QOOHGLT0ZLf9mPJfaPrPsKWrJqIH5BZ1pZMP6BMeW54r0PDF7AIhG6CsHeRfDcOcyZgq6qUXh6etPCfMw34+dZuSCIl8jdmbrm4+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqBbbFML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqBbbFML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70108C4CEF4;
	Tue, 26 Aug 2025 11:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208076;
	bh=ZkCHLqLNmEPcP5CBXfS4V/7iN/b8roTdUitXcYYJzqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqBbbFMLG14msxNR8gGHDlfD9nLAuE2tmbDo4K88Mov6qFwjXA9GbgbuujjSYrp/b
	 Cb6HcWoMs+QQ4mc+PiWdmdGAZgw9SDH7nF+5TckFaZZ/vWJjgSxwYNSbUZhYy2pMob
	 jvvHwQmBgXVcenzHddoGxUjRkkRLohCYWGCOd5r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 429/457] LoongArch: KVM: Use standard bitops API with eiointc
Date: Tue, 26 Aug 2025 13:11:53 +0200
Message-ID: <20250826110947.891271964@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit d23bd878f6ea9cff93104159356e012a8b2bbfaf ]

Standard bitops APIs such test_bit() is used here, rather than manually
calculating the offset and mask. Also use non-atomic API __set_bit() and
__clear_bit() rather than set_bit() and clear_bit(), since the global
spinlock is held already.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Stable-dep-of: 0dfd9ea7bf80 ("LoongArch: KVM: Use kvm_get_vcpu_by_id() instead of kvm_get_vcpu()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/intc/eiointc.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index a75f865d6fb9..3cf9894999da 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -9,7 +9,7 @@
 
 static void eiointc_set_sw_coreisr(struct loongarch_eiointc *s)
 {
-	int ipnum, cpu, cpuid, irq_index, irq_mask, irq;
+	int ipnum, cpu, cpuid, irq;
 	struct kvm_vcpu *vcpu;
 
 	for (irq = 0; irq < EIOINTC_IRQS; irq++) {
@@ -18,8 +18,6 @@ static void eiointc_set_sw_coreisr(struct loongarch_eiointc *s)
 			ipnum = count_trailing_zeros(ipnum);
 			ipnum = (ipnum >= 0 && ipnum < 4) ? ipnum : 0;
 		}
-		irq_index = irq / 32;
-		irq_mask = BIT(irq & 0x1f);
 
 		cpuid = s->coremap.reg_u8[irq];
 		vcpu = kvm_get_vcpu_by_cpuid(s->kvm, cpuid);
@@ -27,16 +25,16 @@ static void eiointc_set_sw_coreisr(struct loongarch_eiointc *s)
 			continue;
 
 		cpu = vcpu->vcpu_id;
-		if (!!(s->coreisr.reg_u32[cpu][irq_index] & irq_mask))
-			set_bit(irq, s->sw_coreisr[cpu][ipnum]);
+		if (test_bit(irq, (unsigned long *)s->coreisr.reg_u32[cpu]))
+			__set_bit(irq, s->sw_coreisr[cpu][ipnum]);
 		else
-			clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
+			__clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
 	}
 }
 
 static void eiointc_update_irq(struct loongarch_eiointc *s, int irq, int level)
 {
-	int ipnum, cpu, found, irq_index, irq_mask;
+	int ipnum, cpu, found;
 	struct kvm_vcpu *vcpu;
 	struct kvm_interrupt vcpu_irq;
 
@@ -48,19 +46,16 @@ static void eiointc_update_irq(struct loongarch_eiointc *s, int irq, int level)
 
 	cpu = s->sw_coremap[irq];
 	vcpu = kvm_get_vcpu(s->kvm, cpu);
-	irq_index = irq / 32;
-	irq_mask = BIT(irq & 0x1f);
-
 	if (level) {
 		/* if not enable return false */
-		if (((s->enable.reg_u32[irq_index]) & irq_mask) == 0)
+		if (!test_bit(irq, (unsigned long *)s->enable.reg_u32))
 			return;
-		s->coreisr.reg_u32[cpu][irq_index] |= irq_mask;
+		__set_bit(irq, (unsigned long *)s->coreisr.reg_u32[cpu]);
 		found = find_first_bit(s->sw_coreisr[cpu][ipnum], EIOINTC_IRQS);
-		set_bit(irq, s->sw_coreisr[cpu][ipnum]);
+		__set_bit(irq, s->sw_coreisr[cpu][ipnum]);
 	} else {
-		s->coreisr.reg_u32[cpu][irq_index] &= ~irq_mask;
-		clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
+		__clear_bit(irq, (unsigned long *)s->coreisr.reg_u32[cpu]);
+		__clear_bit(irq, s->sw_coreisr[cpu][ipnum]);
 		found = find_first_bit(s->sw_coreisr[cpu][ipnum], EIOINTC_IRQS);
 	}
 
@@ -110,8 +105,8 @@ void eiointc_set_irq(struct loongarch_eiointc *s, int irq, int level)
 	unsigned long flags;
 	unsigned long *isr = (unsigned long *)s->isr.reg_u8;
 
-	level ? set_bit(irq, isr) : clear_bit(irq, isr);
 	spin_lock_irqsave(&s->lock, flags);
+	level ? __set_bit(irq, isr) : __clear_bit(irq, isr);
 	eiointc_update_irq(s, irq, level);
 	spin_unlock_irqrestore(&s->lock, flags);
 }
-- 
2.50.1



