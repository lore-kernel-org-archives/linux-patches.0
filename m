Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3917646D089;
	Tue, 21 Jul 2026 18:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658431; cv=none; b=X8i2AQDwusePgiZD+LpdfGKj5VWxcAeSpB3PkP109yZ3uuFRL43NaSzN1FnK3+ByQhGdYxXIGVIIfCrTc0i/IOWD0JLIqzlSLUuK/bYXnJrPQw49qbryO8q45fZ5tvp5I5Jnm1oA6xeovdHQmFU/z+DU+quW1TZtfeDQ+ZTE6x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658431; c=relaxed/simple;
	bh=bWafyGeUmaPeCXEtSRConIhK7msZIf+mGlsC/g4AG74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=js4xOAfgKfEGonwpmim2Je8rsn20nTEH1t1GDJa7cda8mTZkx/tXv/Higeerzi8ShCCBx78mrDXafnSEbQ8WCQ5w/Z+3WBa5IBlCxjd7Q85EhBxRhXmUCHsWo8AJZRcvROrhWPIYUlEFtMaU8QBjZtHFxFIaujJUPgmC4V9hRkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDKkNOTq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDKkNOTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DAB1F000E9;
	Tue, 21 Jul 2026 18:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658428;
	bh=SLPqzOVRI/qRPtECm1MvhxmQFVPtXyuY6pJqPTEa9FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDKkNOTqZhbocA10rmSxBNfVeMdn9kOpVq8eri8BHE7+jiGujBqPXHIqlLBjAuUxt
	 GGmO+uvDAzyMAoZhxSUUa+ZZmAZGkif+IEYxwtC+nTlHth+/KyGJ50/sOEmO1tFv1L
	 rlAkLnQulTllByoFKnVt476wVU+4RQHzdC+wkqf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhong Wang <wangzhong.c0ss4ck@bytedance.com>,
	Xuanqing Shi <shixuanqing.11@bytedance.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 1140/1611] KVM: arm64: nv: Fix SPSR_EL2 restore in kvm_hyp_handle_mops()
Date: Tue, 21 Jul 2026 17:20:56 +0200
Message-ID: <20260721152541.064650988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -419,16 +419,19 @@ static inline bool __populate_fault_info
 
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


