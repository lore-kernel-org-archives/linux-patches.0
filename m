Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB5DB676;
	Mon, 23 Jun 2025 22:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717698; cv=none; b=oDp+1Q1RyYqwQp8gsxRj9u13mSprHzzbUA0qwaHp/UXVuHL1hMbwTxiQMmMtZPtdyyJ0urKRr3lwjNoGx4eiEt/sdMsD9czxkWjXug2kVe4Tn0cNhgEze1sAQTXdmQPPuvhkDi4x4sgZZh7oOJ7CjriYBnP2UGsHhgaMQ4suQXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717698; c=relaxed/simple;
	bh=5ssqsL+je2SoxgnqnumiLzzJB9NgncOCSYsyW4LYf5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeUBrzc6wBoVs/jhAV+rkNtMk8d19vM3dJr2av4+KtQG18/hqIZjJPMSVEOFWcAG6D0Yje20F6HEe51n7SYvd00PLxHvb+2NaVWmzn+DVMYmrpztrRJkqesWnLkq1exI24TGOw7NzIpB6YE0vTE8UBTUXKH0mjUE+c3jfbKVmT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpE+snk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpE+snk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7055C4CEEA;
	Mon, 23 Jun 2025 22:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717698;
	bh=5ssqsL+je2SoxgnqnumiLzzJB9NgncOCSYsyW4LYf5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpE+snk4TL8waAkC9BX2F/47Bm4ggmq6bbMRk6GSHp9FQqkkpKlTXE9ZAYV3Kj2kJ
	 j+zdOTD4uL45PHjMqM1IhJ2Yq9IIH6BuacPHVrLlDHgU2+G21Vp+GyR5KTguJ6NP8x
	 LELCs2kA9oQ3zVNT62WnW/DTskiD/hnCP7jMUmWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 507/508] RISC-V: KVM: Fix the size parameter check in SBI SFENCE calls
Date: Mon, 23 Jun 2025 15:09:12 +0200
Message-ID: <20250623130657.468415305@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit 6aba0cb5bba6141158d5449f2cf53187b7f755f9 ]

As-per the SBI specification, an SBI remote fence operation applies
to the entire address space if either:
1) start_addr and size are both 0
2) size is equal to 2^XLEN-1

>From the above, only #1 is checked by SBI SFENCE calls so fix the
size parameter check in SBI SFENCE calls to cover #2 as well.

Fixes: 13acfec2dbcc ("RISC-V: KVM: Add remote HFENCE functions based on VCPU requests")
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Link: https://lore.kernel.org/r/20250605061458.196003-2-apatel@ventanamicro.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_sbi_replace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 4c034d8a606a1..304d29383e6c0 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -91,14 +91,14 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 		kvm_riscv_fence_i(vcpu->kvm, hbase, hmask);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
-		if (cp->a2 == 0 && cp->a3 == 0)
+		if ((cp->a2 == 0 && cp->a3 == 0) || cp->a3 == -1UL)
 			kvm_riscv_hfence_vvma_all(vcpu->kvm, hbase, hmask);
 		else
 			kvm_riscv_hfence_vvma_gva(vcpu->kvm, hbase, hmask,
 						  cp->a2, cp->a3, PAGE_SHIFT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
-		if (cp->a2 == 0 && cp->a3 == 0)
+		if ((cp->a2 == 0 && cp->a3 == 0) || cp->a3 == -1UL)
 			kvm_riscv_hfence_vvma_asid_all(vcpu->kvm,
 						       hbase, hmask, cp->a4);
 		else
-- 
2.39.5



