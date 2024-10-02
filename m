Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF2D1D0796;
	Wed,  2 Oct 2024 13:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877256; cv=none; b=SNFmplOTKwcl6GXTYcA5WwddooJQz738F4Wk+RphaTwAQckZUoD94bNZfthR1RkO8uLVxVcBVm95yvnsSHTtpyppA71urWZYL2kiD7ck53SkoRkBtRNGiIRBHgtwF2wA3t6+Atagya0En6OcpZTpHNW0S8pbIEzR62UauFQdoX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877256; c=relaxed/simple;
	bh=99+Yn5cUzku5+re8qnJ6mrtKpLgD4YtGb5TmSxb4VJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNPnrfIaGUWbbF8kbs2Dhx5v/Em3ar7vc1L1WMEADwtrdMuamRwzM3YtnfMR7T7CSHVX8QcCfgOOzugaf8LHyDGJp4Zl1iCpH+U/fNK1Y/tOD0B2R9Btl1KhkOlHuuuW5R9QUFhaJAKumxUuOxn/MyLk9XcpI8TgCNJkeSDIcT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHyQ9b9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHyQ9b9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4711DC4CEE2;
	Wed,  2 Oct 2024 13:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877256;
	bh=99+Yn5cUzku5+re8qnJ6mrtKpLgD4YtGb5TmSxb4VJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHyQ9b9eLvTczmfrM6qZZhgZrI1mnlwbGrpdTtBEcaS7iQ5P6ojtUPBiL7VK2LS4b
	 /Vn/3H3yYDB8aK+cHQl+fHxSNa+oiN3Sb3qpIwDmJvgmeT2WS+S4S5zLqdCKiufI6T
	 m7TOigLkbBwS9vY8jJKUHXUsspZubJrr7n6sfjyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 021/634] RISC-V: KVM: Allow legacy PMU access from guest
Date: Wed,  2 Oct 2024 14:52:01 +0200
Message-ID: <20241002125811.931242122@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atish Patra <atishp@rivosinc.com>

[ Upstream commit 7d1ffc8b087e97dbe1985912c7a2d00e53cea169 ]

Currently, KVM traps & emulates PMU counter access only if SBI PMU
is available as the guest can only configure/read PMU counters via
SBI only. However, if SBI PMU is not enabled in the host, the
guest will fallback to the legacy PMU which will try to access
cycle/instret and result in an illegal instruction trap which
is not desired.

KVM can allow dummy emulation of cycle/instret only for the guest
if SBI PMU is not enabled in the host. The dummy emulation will
still return zero as we don't to expose the host counter values
from a guest using legacy PMU.

Fixes: a9ac6c37521f ("RISC-V: KVM: Implement trap & emulate for hpmcounters")
Signed-off-by: Atish Patra <atishp@rivosinc.com>
Link: https://lore.kernel.org/r/20240816-kvm_pmu_fixes-v1-1-cdfce386dd93@rivosinc.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/kvm_vcpu_pmu.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
index fa0f535bbbf02..c309daa2d75a8 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -10,6 +10,7 @@
 #define __KVM_VCPU_RISCV_PMU_H
 
 #include <linux/perf/riscv_pmu.h>
+#include <asm/kvm_vcpu_insn.h>
 #include <asm/sbi.h>
 
 #ifdef CONFIG_RISCV_PMU_SBI
@@ -104,8 +105,20 @@ void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
 struct kvm_pmu {
 };
 
+static inline int kvm_riscv_vcpu_pmu_read_legacy(struct kvm_vcpu *vcpu, unsigned int csr_num,
+						 unsigned long *val, unsigned long new_val,
+						 unsigned long wr_mask)
+{
+	if (csr_num == CSR_CYCLE || csr_num == CSR_INSTRET) {
+		*val = 0;
+		return KVM_INSN_CONTINUE_NEXT_SEPC;
+	} else {
+		return KVM_INSN_ILLEGAL_TRAP;
+	}
+}
+
 #define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
-{.base = 0,	.count = 0,	.func = NULL },
+{.base = CSR_CYCLE,	.count = 3,	.func = kvm_riscv_vcpu_pmu_read_legacy },
 
 static inline void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu) {}
 static inline int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned long fid)
-- 
2.43.0



