Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358DF1974F4;
	Wed,  2 Oct 2024 14:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879139; cv=none; b=h4qiuYfLvhqliAkiavEN9QmEtF1vDGwagNrnEj2y+SWIh6ptQy8DLNZkUUzTJPLYLiIZAgedq6W1wCOhNmaMnqqPShhlFiw7TCskx9+8kUcCR/eOVAyQDCluKOdzp9hVR7WTEw96QeZYis0joSYTTSUUwV3DY7k3Uwjg3lch0q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879139; c=relaxed/simple;
	bh=gi6WZXR5qlRUNqwWxijwY6scloadbk6T69lGAQOnF6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S41Bt4BhLtSb1dWv9qijfU1mK13aXkLg65/2Tdopmi9RKT95n4vUAkn7kVNlc9sdg3/Y8KGsHIZqLzFHrQkqnKMj4lcV7kmYbJPEeYE3T4TokmmnNy9Y5H1BQBcvfEgGVsbUEWUa7HYMlkOV0yIcYY0AboSwH/wLUZChWC0FdP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Flbfgz8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Flbfgz8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50EFC4CEC2;
	Wed,  2 Oct 2024 14:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879139;
	bh=gi6WZXR5qlRUNqwWxijwY6scloadbk6T69lGAQOnF6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Flbfgz8YHDhgW9WLOZULIpTEx+5hFtjZ5ZAfJC3w50LfwhibAXZTNqJ11J2luYnqW
	 ce4Y97RBT5O7hSk/APOhm0tfk6UvqTB3sOkcNliimXuX90qk3ugyF7wC99wsQLzi2r
	 DqZ14LEvqMbKmd+RsHyArKRARz66xVOAFPnclvk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/538] RISC-V: KVM: Fix to allow hpmcounter31 from the guest
Date: Wed,  2 Oct 2024 14:54:16 +0200
Message-ID: <20241002125752.684939736@linuxfoundation.org>
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
index 6823271bce322..a50a1d23523fe 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -58,11 +58,11 @@ struct kvm_pmu {
 
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



