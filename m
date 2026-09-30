Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43064FDE56;
	Wed, 30 Sep 2026 16:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786886; cv=none; b=nB8g3CY5kZhWLuYJAo5Z6IPzLJqH73yyo6gezNg7VO27EOOyz4xBo2duKFwqhSpb4JxLTIURZZdGWSDTm65hKgn4c7RTMy3RECviJF5hyCM978MAQSfkUEMrGgKoQHzlOoKF6evFeY4FeVokN4RV6K6Emjn/Ll5pjW4BrJ0MAPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786886; c=relaxed/simple;
	bh=A8vd1iT16BjOuYF1+8wmvRJk8wcePt7VRjf6uUi9fM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HiggJU61NhRLeoS/Y3Bru/xSGxYJpkmUuOocQ4CZALiLHCmlBP0Gk7rAupOfTV4ESDFtrJZYMo07mkR5kdCli1r+bqzmRdbRrsG4kddDhtx+A9WXJgGwgqz4GQ+9QrTXdTHjZC50eQWfJ4qam2+BcPdNcxGiYM8y0zhThhPkggA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9x1iNCl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9x1iNCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4442F1F000FF;
	Wed, 30 Sep 2026 16:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786884;
	bh=M0FrIr+Ublaf9S6i3I1+Wz+KAQmHOzUeHY+EH4ShTrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M9x1iNClYXD0XRIYsxQH+NBfWXHS1MVeDA0Aasn8ctFVqni+q/yeXbRWYn10rJf33
	 oe/Wvao7o/mr0BhUYwYM96WqIOfpixEuD0i4tS9rSqOdtCNozBQ6hT4FNInpkQd3MT
	 eV7PSxwjgZfQr2xzsWg1/OjrcMdWD8AfMWygy6s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yang.yicong@picoheart.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 036/457] RISC-V: KVM: Fix the conversion between vsip and hvip
Date: Wed, 30 Sep 2026 17:22:21 +0200
Message-ID: <20260930152346.815642038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Yicong Yang <yang.yicong@picoheart.com>

[ Upstream commit 52c6b7d20d3e791a9e75aa2be2a467990154c7cd ]

Per AIA spec 1.0 Section 6.3.2, the interrupt numbers 13-63
shares same bit position between related VS shadow CSRs and
hypervisor CSRs. So there's a shift only for SSI, STI and
SEI interrupt.

Currently the KVM always does a shift for all the interrupts
(include LCOFI with number 13) when doing the conversion
between vsip and hvip. Fix this by only doing shift the SSI,
STI and SEI. Add wrappers for doing the conversion between
vsip and hvip.

Fixes: 16b0bde9a37c ("RISC-V: KVM: Add perf sampling support for guests")
Signed-off-by: Yicong Yang <yang.yicong@picoheart.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260804134018.85497-1-yang.yicong@picoheart.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/csr.h       | 20 ++++++++++++++++----
 arch/riscv/kvm/vcpu.c              |  3 +--
 arch/riscv/kvm/vcpu_onereg.c       |  8 +++-----
 tools/arch/riscv/include/asm/csr.h | 20 ++++++++++++++++----
 4 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 31b8988f4488d..72ff259154e9b 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -183,12 +183,24 @@
 #define HGATP_MODE_SHIFT	HGATP32_MODE_SHIFT
 #endif
 
-/* VSIP & HVIP relation */
+/*
+ * VSIP & HVIP relation
+ *
+ * The bit positions are same between VSIP and HVIP for interrupt
+ * numbers 13-63, where there's a shift for the SSI, STI and SEI.
+ */
 #define VSIP_TO_HVIP_SHIFT	(IRQ_VS_SOFT - IRQ_S_SOFT)
-#define VSIP_VALID_MASK		((_AC(1, UL) << IRQ_S_SOFT) | \
+#define VSIP_BIAS_MASK		((_AC(1, UL) << IRQ_S_SOFT) | \
 				 (_AC(1, UL) << IRQ_S_TIMER) | \
-				 (_AC(1, UL) << IRQ_S_EXT) | \
-				 (_AC(1, UL) << IRQ_PMU_OVF))
+				 (_AC(1, UL) << IRQ_S_EXT))
+#define VSIP_NO_BIAS_MASK	(_AC(1, UL) << IRQ_PMU_OVF)
+#define VSIP_VALID_MASK		(VSIP_BIAS_MASK | VSIP_NO_BIAS_MASK)
+#define vsip_to_hvip(_vsip)	((((_vsip) & VSIP_BIAS_MASK) << \
+				  VSIP_TO_HVIP_SHIFT) | \
+				 ((_vsip) & VSIP_NO_BIAS_MASK))
+#define hvip_to_vsip(_hvip)	((((_hvip) >> VSIP_TO_HVIP_SHIFT) & \
+				  VSIP_BIAS_MASK) | \
+				 ((_hvip) & VSIP_NO_BIAS_MASK))
 
 /* AIA CSR bits */
 #define TOPI_IID_SHIFT		16
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 977e36ab83d3f..468918309dff3 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -475,8 +475,7 @@ bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
 	bool ret;
 
 	raw_spin_lock_irqsave(&vcpu->arch.irqs_pending_lock, flags);
-	ie = ((vcpu->arch.guest_csr.vsie & VSIP_VALID_MASK)
-		<< VSIP_TO_HVIP_SHIFT) & (unsigned long)mask;
+	ie = vsip_to_hvip(vcpu->arch.guest_csr.vsie) & (unsigned long)mask;
 	ie |= vcpu->arch.guest_csr.vsie & ~IRQ_LOCAL_MASK &
 		(unsigned long)mask;
 	ret = vcpu->arch.irqs_pending[0] & ie;
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 99b9107b1ac18..9fe829eed1781 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -272,7 +272,7 @@ static int kvm_riscv_vcpu_general_get_csr(struct kvm_vcpu *vcpu,
 
 	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
 		kvm_riscv_vcpu_flush_interrupts(vcpu);
-		*out_val = (csr->hvip >> VSIP_TO_HVIP_SHIFT) & VSIP_VALID_MASK;
+		*out_val = hvip_to_vsip(csr->hvip);
 		*out_val |= csr->hvip & ~IRQ_LOCAL_MASK;
 	} else
 		*out_val = ((unsigned long *)csr)[reg_num];
@@ -293,10 +293,8 @@ static int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu,
 
 	reg_num = array_index_nospec(reg_num, regs_max);
 
-	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
-		reg_val &= VSIP_VALID_MASK;
-		reg_val <<= VSIP_TO_HVIP_SHIFT;
-	}
+	if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
+		reg_val = vsip_to_hvip(reg_val);
 
 	((unsigned long *)csr)[reg_num] = reg_val;
 
diff --git a/tools/arch/riscv/include/asm/csr.h b/tools/arch/riscv/include/asm/csr.h
index 21d8cee046383..8df64314d6131 100644
--- a/tools/arch/riscv/include/asm/csr.h
+++ b/tools/arch/riscv/include/asm/csr.h
@@ -163,12 +163,24 @@
 #define HGATP_MODE_SHIFT	HGATP32_MODE_SHIFT
 #endif
 
-/* VSIP & HVIP relation */
+/*
+ * VSIP & HVIP relation
+ *
+ * The bit positions are same between VSIP and HVIP for interrupt
+ * numbers 13-63, where there's a shift for the SSI, STI and SEI.
+ */
 #define VSIP_TO_HVIP_SHIFT	(IRQ_VS_SOFT - IRQ_S_SOFT)
-#define VSIP_VALID_MASK		((_AC(1, UL) << IRQ_S_SOFT) | \
+#define VSIP_BIAS_MASK		((_AC(1, UL) << IRQ_S_SOFT) | \
 				 (_AC(1, UL) << IRQ_S_TIMER) | \
-				 (_AC(1, UL) << IRQ_S_EXT) | \
-				 (_AC(1, UL) << IRQ_PMU_OVF))
+				 (_AC(1, UL) << IRQ_S_EXT))
+#define VSIP_NO_BIAS_MASK	(_AC(1, UL) << IRQ_PMU_OVF)
+#define VSIP_VALID_MASK		(VSIP_BIAS_MASK | VSIP_NO_BIAS_MASK)
+#define vsip_to_hvip(_vsip)	((((_vsip) & VSIP_BIAS_MASK) << \
+				  VSIP_TO_HVIP_SHIFT) | \
+				 ((_vsip) & VSIP_NO_BIAS_MASK))
+#define hvip_to_vsip(_hvip)	((((_hvip) >> VSIP_TO_HVIP_SHIFT) & \
+				  VSIP_BIAS_MASK) | \
+				 ((_hvip) & VSIP_NO_BIAS_MASK))
 
 /* AIA CSR bits */
 #define TOPI_IID_SHIFT		16
-- 
2.53.0



