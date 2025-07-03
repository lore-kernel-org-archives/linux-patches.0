Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BFD2D23A8;
	Thu,  3 Jul 2025 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554873; cv=none; b=d5rHA3eaxJJS+AQADWSzR8EeUQIzsFBv2COwlbsa7GkdtSDLjWIUfGcsI2TstXUE4pJFr8e6ZSFiw/O+FZAt5yBZruS8s1Vczwpg4RAuKsNNaZHb5/zboEJHiZT+BG3sKCl3iDtIsgE6R6KmRytD5jefSGVFlBHsLP0loCHlm24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554873; c=relaxed/simple;
	bh=Raj6O8X0p8J1MqbqC1vuMSIeT8vl9euOPk/64QA5hXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnhGNvKOubi1AS8Suk8SpxZ8APPpulDxWnYFpLvZjNHIlnhy4rCcA+eADRK+mh3GQF2VL9Ry8MOZH5rCqLmNTrKDD8hyrWveG1a2o1hk7xPrCes0XI1JCoX4HpLgResM3dojUl3Br4g84Q2D/Hjk5nEO7gFYFWe2D14QGOaAzqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZnIqvvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZnIqvvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4635C4CEE3;
	Thu,  3 Jul 2025 15:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554873;
	bh=Raj6O8X0p8J1MqbqC1vuMSIeT8vl9euOPk/64QA5hXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZnIqvvFp8RrDE45ftLoEmchpia0EGh+p3Dza3imscG2+pIT/zYx6OkUsr89Rhgom
	 N/Yo6DR6jN7sGG4qyhAt/tomR4hDT0zLa1SLiWX2vl+2eyixMW4LEf/wdT5clyELmF
	 fx10dMAzB2MOguH5RLzVoQGty6K5J2YM13tZa/Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.15 106/263] LoongArch: KVM: Check interrupt route from physical CPU
Date: Thu,  3 Jul 2025 16:40:26 +0200
Message-ID: <20250703144008.574768083@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 45515c643d0abb75c2cc760a6bc6b235eadafd66 upstream.

With EIOINTC interrupt controller, physical CPU ID is set for irq route.
However the function kvm_get_vcpu() is used to get destination vCPU when
delivering irq. With API kvm_get_vcpu(), the logical CPU ID is used.

With API kvm_get_vcpu_by_cpuid(), vCPU ID can be searched from physical
CPU ID.

Cc: stable@vger.kernel.org
Fixes: 3956a52bc05b ("LoongArch: KVM: Add EIOINTC read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/eiointc.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 8d3f48e2a7f0..644fb7785c07 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -9,7 +9,8 @@
 
 static void eiointc_set_sw_coreisr(struct loongarch_eiointc *s)
 {
-	int ipnum, cpu, irq_index, irq_mask, irq;
+	int ipnum, cpu, cpuid, irq_index, irq_mask, irq;
+	struct kvm_vcpu *vcpu;
 
 	for (irq = 0; irq < EIOINTC_IRQS; irq++) {
 		ipnum = s->ipmap.reg_u8[irq / 32];
@@ -20,7 +21,12 @@ static void eiointc_set_sw_coreisr(struct loongarch_eiointc *s)
 		irq_index = irq / 32;
 		irq_mask = BIT(irq & 0x1f);
 
-		cpu = s->coremap.reg_u8[irq];
+		cpuid = s->coremap.reg_u8[irq];
+		vcpu = kvm_get_vcpu_by_cpuid(s->kvm, cpuid);
+		if (!vcpu)
+			continue;
+
+		cpu = vcpu->vcpu_id;
 		if (!!(s->coreisr.reg_u32[cpu][irq_index] & irq_mask))
 			set_bit(irq, s->sw_coreisr[cpu][ipnum]);
 		else
@@ -68,17 +74,23 @@ static void eiointc_update_irq(struct loongarch_eiointc *s, int irq, int level)
 static inline void eiointc_update_sw_coremap(struct loongarch_eiointc *s,
 					int irq, u64 val, u32 len, bool notify)
 {
-	int i, cpu;
+	int i, cpu, cpuid;
+	struct kvm_vcpu *vcpu;
 
 	for (i = 0; i < len; i++) {
-		cpu = val & 0xff;
+		cpuid = val & 0xff;
 		val = val >> 8;
 
 		if (!(s->status & BIT(EIOINTC_ENABLE_CPU_ENCODE))) {
-			cpu = ffs(cpu) - 1;
-			cpu = (cpu >= 4) ? 0 : cpu;
+			cpuid = ffs(cpuid) - 1;
+			cpuid = (cpuid >= 4) ? 0 : cpuid;
 		}
 
+		vcpu = kvm_get_vcpu_by_cpuid(s->kvm, cpuid);
+		if (!vcpu)
+			continue;
+
+		cpu = vcpu->vcpu_id;
 		if (s->sw_coremap[irq + i] == cpu)
 			continue;
 
-- 
2.50.0



