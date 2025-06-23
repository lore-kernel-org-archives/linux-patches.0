Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0201B17BD9;
	Mon, 23 Jun 2025 22:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717003; cv=none; b=NhttUnCejYLCWqHppW36yXP9auLj7913pQArewra5FKqSTK0sNZsIGis7y7diEHIIKaCd5EFKoyyvcXTBFkxxVGic5r8J0ZRkAfn1CD4mIxCXVqym+d7qVLKFsEKmPashQfn6b5l5KOTgPtxIk11Ayh+7JeXMqtga2QyYDBEGo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717003; c=relaxed/simple;
	bh=0Tw5rJth4unKe0D0aB4uQSFDkS+pCWGx/cgBEg8HT5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqK2YmHthHlQvkczHnAZ3cgDcWs45G1nBfxhKoDxOrBhvG6UtP+vlNTdpDfxuNFVAt4R+aljG0nLBRk4GppvCUTqdQSAFw8JiCGk9r/8zjFLkTonRHdTAlaoRm0VWoQtpiPSEh7jDsDOt3JjBqbym3fRpYWjNHT/jjNhk4V84NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFjlUZ31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFjlUZ31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACFFC4CEF1;
	Mon, 23 Jun 2025 22:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717001;
	bh=0Tw5rJth4unKe0D0aB4uQSFDkS+pCWGx/cgBEg8HT5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFjlUZ31vE673Wwz8NezvReeOAyZnlFyJdEGh8JxuNB4PVod7Rfjo7kKtKq334zYa
	 BgpLla/L89t4bHQ+UwxnWutpLEZeYIX6v/pAtww2iSatoM/jjHmmvPFi/tcoAlLFn2
	 Zu6F+9X+ydVwXMy7t/3rt5a449Kd73weojYm073Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 576/592] RISC-V: KVM: Fix the size parameter check in SBI SFENCE calls
Date: Mon, 23 Jun 2025 15:08:54 +0200
Message-ID: <20250623130714.139197562@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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
index 5fbf3f94f1e85..9752d2ffff683 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -103,7 +103,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_SENT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
-		if (cp->a2 == 0 && cp->a3 == 0)
+		if ((cp->a2 == 0 && cp->a3 == 0) || cp->a3 == -1UL)
 			kvm_riscv_hfence_vvma_all(vcpu->kvm, hbase, hmask);
 		else
 			kvm_riscv_hfence_vvma_gva(vcpu->kvm, hbase, hmask,
@@ -111,7 +111,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_SENT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
-		if (cp->a2 == 0 && cp->a3 == 0)
+		if ((cp->a2 == 0 && cp->a3 == 0) || cp->a3 == -1UL)
 			kvm_riscv_hfence_vvma_asid_all(vcpu->kvm,
 						       hbase, hmask, cp->a4);
 		else
-- 
2.39.5



