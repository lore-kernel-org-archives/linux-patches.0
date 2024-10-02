Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8911D040E;
	Wed,  2 Oct 2024 13:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875208; cv=none; b=dEN06YGj0m2Q8KqsfBBfHZXMmuT7Znj6lsnhUSnbRBbWDQU/kA6efDg++K3UTpP5cW0WAWu32lkfr3ZBxnsmv9QTLJvmbrBeqJoec2dPnwB3dlGP5vyYnvfKv9KgaG9rN0N9R+ehmr1GslrzMyhcCj+wwSdmbIB0K87KIByW96Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875208; c=relaxed/simple;
	bh=RYZsxYfptpifgVsUNIi7bJGUjSIH4sexl+nuF6eqnGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wi7glg91aqekHHvXnzbTCfWJMtgJ6S3jQxJHM203kSZfQmBdNrinhZ9s2RKiyY8J2LIcA3bfdUeZ2b1BE5coPClzsJJapdCFoadji9iGZfOty7HduSD5A6VE8N00SqKJ24Z5HKIKLkXP3qAxy2FzJI1ZpSHcN3XKatVZW+I/LAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRH70c1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRH70c1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421B6C4CEC5;
	Wed,  2 Oct 2024 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875208;
	bh=RYZsxYfptpifgVsUNIi7bJGUjSIH4sexl+nuF6eqnGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRH70c1q+rl+PEEZVxNxWuX0eZbBIKeeR6L1kmDYb/GH99STgiwwfAYquYYXzezKv
	 DJx/oqxTnqsjxREHwj6zx6FLjr0oYjJFqMF2WzkCkXS5JahAWkqzt0DxND4Q8GnsAg
	 /9JkYPLMCegtZAwO+t2Jnsf3Tl0zhzA/mP7l2keY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 028/695] RISC-V: KVM: Allow legacy PMU access from guest
Date: Wed,  2 Oct 2024 14:50:26 +0200
Message-ID: <20241002125823.617220842@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



