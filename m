Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10A41D1E7C;
	Wed,  2 Oct 2024 14:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879136; cv=none; b=oJJNOn+t5OU2hOKm1ZNM+kD9giwZgpv5Ann3S/w8S9pGx5RfOeIsQjKr+bfeBMHM6KFGYbKoyjjKT9j2Fygnxg/f6uJr/OcymEGARkR2c2J6+4Ab7WZvmm0XEazKUEYg094VM4lBsxLDeS9Bt8w1C1yJl2TDJd0d9Ldpsi2/wU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879136; c=relaxed/simple;
	bh=Lj84eClynEUPah0pGTPkFUhcvqNaSNFva8fnMmryzKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPlJETmFBQuwmpx5+eOdnR4MUuSDydCa2Iqi7lC3QYL8IOKfbMgsS+mFmJYzzu5IEpWW8aIfOXbM4nVJl4Ffk7npThn4JsBEOxUqcFQLYs9ywvzDPHXqxhiRyx3K6xEZW/vrvL9uTKASYeNgaeaSgjzsEqgDy4bFuX1uD4fuA4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciW/SPuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciW/SPuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9C6C4CECD;
	Wed,  2 Oct 2024 14:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879136;
	bh=Lj84eClynEUPah0pGTPkFUhcvqNaSNFva8fnMmryzKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciW/SPuLwX3Vu56JPZiM8/Twh5K3tCAkZT865iQZ2RJ5Y9LCbH6h8VcrXetjgb1G3
	 r3IvFrPE64gWMYFHMiJEAySKt0TmDjpa7Y4Pw8+M7fF1UYrIPp7Axd1Um0KGhI+eIg
	 d43LlnWH/AsGlAHo7btZLO7IsxIrVzA/q2gHK9Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/538] RISC-V: KVM: Allow legacy PMU access from guest
Date: Wed,  2 Oct 2024 14:54:15 +0200
Message-ID: <20241002125752.644651555@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 395518a1664e0..6823271bce322 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -10,6 +10,7 @@
 #define __KVM_VCPU_RISCV_PMU_H
 
 #include <linux/perf/riscv_pmu.h>
+#include <asm/kvm_vcpu_insn.h>
 #include <asm/sbi.h>
 
 #ifdef CONFIG_RISCV_PMU_SBI
@@ -92,8 +93,20 @@ void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
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



