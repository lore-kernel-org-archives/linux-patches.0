Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A917316F84F;
	Wed,  2 Oct 2024 13:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875211; cv=none; b=Ajn/b5zho/9sAC/099/JlkejWSh/dmGg9s/LqTPQU4zJ9bLwZk8vof44R3KFSPsRWIAH1GDqBkEuFnEpRgddsM+CEXkWdaLLCKMtX+13j8+DJaZ/Z19cSk0MazsjZge5RRKQheWo8EZAslkU3aRLFiRdBCvWfVIBSC01ChRTBWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875211; c=relaxed/simple;
	bh=/8Ohzzro/0VVnkku4ix9S8i6BrQszWFa/5QgKGGVSUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgSeg0y9vbRa6u+q5VM4XJjA6QqJwKLtf/J90RywAikuoyGho3gM1p4WeSG6pHitc/AeGYmIewwxMhOI4MN2090mhaCqIqGnTKB3Nw7r8LAE9Uzz7egwpMEJeegGB5hvkzvwZHTtjl4iXdnwd5fhd7zaFWeteJz7FknM3fBUTAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L01+f4TO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L01+f4TO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3058AC4CECE;
	Wed,  2 Oct 2024 13:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875211;
	bh=/8Ohzzro/0VVnkku4ix9S8i6BrQszWFa/5QgKGGVSUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L01+f4TOz+EZd8IQGxpBM7DvMTRLbUyUYeaSPNVuDK3PPJonxzt+9tDuwwXPxg18P
	 gWTzfoBH/p5y64Wnih7kZSLupxx5ek2S/bH1jSSb182YWvMc3EtmI+rOAo42XDaJD1
	 as51Iv4DnW1rp1aEr9wRsjK78F8GaifNOOSpgB04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 029/695] RISC-V: KVM: Fix to allow hpmcounter31 from the guest
Date: Wed,  2 Oct 2024 14:50:27 +0200
Message-ID: <20241002125823.656601009@linuxfoundation.org>
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

[ Upstream commit 5aa09297a3dcc798d038bd7436f8c90f664045a6 ]

The csr_fun defines a count parameter which defines the total number
CSRs emulated in KVM starting from the base. This value should be
equal to total number of counters possible for trap/emulation (32).

Fixes: a9ac6c37521f ("RISC-V: KVM: Implement trap & emulate for hpmcounters")
Signed-off-by: Atish Patra <atishp@rivosinc.com>
Link: https://lore.kernel.org/r/20240816-kvm_pmu_fixes-v1-2-cdfce386dd93@rivosinc.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/kvm_vcpu_pmu.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
index c309daa2d75a8..1d85b66175088 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -65,11 +65,11 @@ struct kvm_pmu {
 
 #if defined(CONFIG_32BIT)
 #define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
-{.base = CSR_CYCLEH,	.count = 31,	.func = kvm_riscv_vcpu_pmu_read_hpm }, \
-{.base = CSR_CYCLE,	.count = 31,	.func = kvm_riscv_vcpu_pmu_read_hpm },
+{.base = CSR_CYCLEH,	.count = 32,	.func = kvm_riscv_vcpu_pmu_read_hpm }, \
+{.base = CSR_CYCLE,	.count = 32,	.func = kvm_riscv_vcpu_pmu_read_hpm },
 #else
 #define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
-{.base = CSR_CYCLE,	.count = 31,	.func = kvm_riscv_vcpu_pmu_read_hpm },
+{.base = CSR_CYCLE,	.count = 32,	.func = kvm_riscv_vcpu_pmu_read_hpm },
 #endif
 
 int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned long fid);
-- 
2.43.0



