Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A12415F15;
	Tue, 21 Jul 2026 19:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663590; cv=none; b=XAHBNMAbJ3hggW54ZTx+sDFJH8M7XfCdTYNRN2dFfB6v2RENgih2V9MybYbnhsIqFnm5IfDeDmVpXplqT7G455JUh736NJZqsUrxW8aYdO1EFZPx0C36kHOibIamaehzuachrQwdGkgUR8yp1vD/dKiP5qD7VceYwehpDePvmHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663590; c=relaxed/simple;
	bh=b+BDqJxpLOpvguOa4CPfrbnMAnxWLYo3Kdd20Ib8wb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsCVIdL3gm1tQEkAboNZdb3jU8IiT2O1EfLBAPn2NRPeOM1b4rZJw9ZueRaOTy0SOqZ2SjFV3Hkk1iH9cUCq87x8U6rjE07bdmX9+6370JRiGRqSBr5cm6OkCDuMEUvLR4rkxKyKMT+ANcNu1clUWXWbMu22pwjx1t11Ym+N/RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hsXUfKYo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hsXUfKYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6BB1F000E9;
	Tue, 21 Jul 2026 19:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663589;
	bh=5h1u455t7uF6IG+fp5/+2AkCE0XdeaZJDUs0AksUWoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hsXUfKYo5WV0FEeZhRejyEXSRdt21lgMO/uFyu4aDVNh0r1oDdaiHYj0sR7FHdYs1
	 5VrnhyPTtygli7OcHAx7fUbJjYfmnGFpBbY2yGKlb9UiEtIYFV9TqXrkJA0M7aGRA/
	 0zzviozbPJ12PpwG+XQeZaF+8PbcmdoC0WH7G2b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhong Wang <wangzhong.c0ss4ck@bytedance.com>,
	Xuanqing Shi <shixuanqing.11@bytedance.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.12 0837/1276] KVM: arm64: nv: Fix SPSR_EL2 restore in kvm_hyp_handle_mops()
Date: Tue, 21 Jul 2026 17:21:20 +0200
Message-ID: <20260721152504.788143533@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit ff1022c3de46753eb7eba2f6efd990569e66ff95 upstream.

kvm_hyp_handle_mops() resets the single-step state machine as part of
rewinding state for a MOPS exception by modifying vcpu_cpsr() and
writing the result directly into hardware.

In the case of nested virtualization, vcpu_cpsr() is a synthetic value
such that the rest of KVM can deal with vEL2 cleanly. That means the
value requires translation before being written into hardware, which is
unfortunately missing from the MOPS handler.

Fix it by directly modifying SPSR_EL2 and avoiding the synthetic state
altogether, which will be resynchronized on the next 'full' exit back
to KVM.

Fixes: 2de451a329cf ("KVM: arm64: Add handler for MOPS exceptions")
Reported-by: Zhong Wang <wangzhong.c0ss4ck@bytedance.com>
Reported-by: Xuanqing Shi <shixuanqing.11@bytedance.com>
Link: https://lore.kernel.org/all/ajE4lHQevXNHpl1M@Air.local/
Cc: stable@vger.kernel.org
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260617040820.2194831-2-bestswngs@gmail.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -297,16 +297,19 @@ static inline bool __populate_fault_info
 
 static inline bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	u64 spsr;
+
 	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
 	arm64_mops_reset_regs(vcpu_gp_regs(vcpu), vcpu->arch.fault.esr_el2);
 	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
 
 	/*
 	 * Finish potential single step before executing the prologue
-	 * instruction.
+	 * instruction. Modify the hardware SPSR_EL2 directly, as vcpu_cpsr()
+	 * may hold a synthetic (vEL2) value for a guest hypervisor.
 	 */
-	*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
-	write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
+	spsr = read_sysreg_el2(SYS_SPSR);
+	write_sysreg_el2(spsr & ~DBG_SPSR_SS, SYS_SPSR);
 
 	return true;
 }


