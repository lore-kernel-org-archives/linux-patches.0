Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7665C2DEA6F;
	Fri,  9 Jan 2026 11:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959854; cv=none; b=KQvZ5ZR7znQiLfpuZPmlOiVUqD5LP+78FP4tHNcRYk1Sryvg/umfQkqUM5Slf2lVLw0c4TKaNINXxU79O7RIRl5bgqqpABrHA8Zc2mkgdYNxtercFRVMVR/utuPc4aIMEMiajwWSBBN2p0KiNDCzGt4d5yjLVrqYu7T+u2vFjTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959854; c=relaxed/simple;
	bh=3evLya4cKo4h6xZ+zNak4g3IAK3xjEAN4nXdb9k8Tqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdP44+OroxY3naBsntD6miWOSFfwBdDDAShhySvSs04JSYctL3Z8W9XCEh92yLEjmMNJcU5Vcf+8vJEA6Oo56bkfE0BG72lnRWv/PSh5ZJ8tinJNguJLqObnP0lb0/iRTigmCpdcNk3J0t0MSu986TXXlq4fZumNlKm3KHlHHHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8+Hm2e+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8+Hm2e+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1299C4CEF1;
	Fri,  9 Jan 2026 11:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959854;
	bh=3evLya4cKo4h6xZ+zNak4g3IAK3xjEAN4nXdb9k8Tqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8+Hm2e+bx9JLMR0Y5qgFHTvfnzv5xdOpHQ94cCmIBQyX30Vc3m7+EMb1nQuz9MCN
	 Zl83Ks+8mQvK7jMR9NemQxiN6DCdpfqcz0JLNSjkRwk8xiTohOgQHe2cIokJsXRUGI
	 S1DEqWIPmmfvDCw4KxBmI92xy6OO4LQF9gGlInzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 198/737] RISC-V: KVM: Fix guest page fault within HLV* instructions
Date: Fri,  9 Jan 2026 12:35:37 +0100
Message-ID: <20260109112141.450867005@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

[ Upstream commit 974555d6e417974e63444266e495a06d06c23af5 ]

When executing HLV* instructions at the HS mode, a guest page fault
may occur when a g-stage page table migration between triggering the
virtual instruction exception and executing the HLV* instruction.

This may be a corner case, and one simpler way to handle this is to
re-execute the instruction where the virtual  instruction exception
occurred, and the guest page fault will be automatically handled.

Fixes: b91f0e4cb8a3 ("RISC-V: KVM: Factor-out instruction emulation into separate sources")
Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20251121133543.46822-1-fangyu.yu@linux.alibaba.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_insn.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 7a6abed41bc17..703d1e0fce774 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -396,6 +396,22 @@ static int system_opcode_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	return (rc <= 0) ? rc : 1;
 }
 
+static bool is_load_guest_page_fault(unsigned long scause)
+{
+	/**
+	 * If a g-stage page fault occurs, the direct approach
+	 * is to let the g-stage page fault handler handle it
+	 * naturally, however, calling the g-stage page fault
+	 * handler here seems rather strange.
+	 * Considering this is a corner case, we can directly
+	 * return to the guest and re-execute the same PC, this
+	 * will trigger a g-stage page fault again and then the
+	 * regular g-stage page fault handler will populate
+	 * g-stage page table.
+	 */
+	return (scause == EXC_LOAD_GUEST_PAGE_FAULT);
+}
+
 /**
  * kvm_riscv_vcpu_virtual_insn -- Handle virtual instruction trap
  *
@@ -421,6 +437,8 @@ int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 							  ct->sepc,
 							  &utrap);
 			if (utrap.scause) {
+				if (is_load_guest_page_fault(utrap.scause))
+					return 1;
 				utrap.sepc = ct->sepc;
 				kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
 				return 1;
@@ -476,6 +494,8 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
 						  &utrap);
 		if (utrap.scause) {
+			if (is_load_guest_page_fault(utrap.scause))
+				return 1;
 			/* Redirect trap if we failed to read instruction */
 			utrap.sepc = ct->sepc;
 			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
@@ -602,6 +622,8 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
 						  &utrap);
 		if (utrap.scause) {
+			if (is_load_guest_page_fault(utrap.scause))
+				return 1;
 			/* Redirect trap if we failed to read instruction */
 			utrap.sepc = ct->sepc;
 			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
-- 
2.51.0



