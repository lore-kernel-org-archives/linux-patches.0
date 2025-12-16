Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB66C338F25;
	Tue, 16 Dec 2025 11:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884602; cv=none; b=tfailWPU15Bi3f7mbYc/rE/pb6BDoCK4zwQQ1Y/2bR5jyeRQhvQVBvY1qUFhWXRkTbAMAuGDS3aopff+ZfEnAkXnzkV8uICR929oYBF9wgJW1ncqEB6cbcIRrbcGktcHiVSNI7rrKtS31FjnzeZMHTyMMNZzKu82obqdGG8QA4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884602; c=relaxed/simple;
	bh=LR6Fa1qXonfRtGCmLjKG5yv8LvURE/qDDUTGSirIVSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsMfBwG76K+0N2BuGwjqkNLNKIwl9nfLaIQzqGSjOcjVbHUxTitkBVqCYv+o6pGESy6vMTN0RVfnmmWmFrmWx5FmlWFYIa2RGRWVm0hJPo+Pub3dDRznoCRKh6KhfsgwwU4NZvxHIxenOSQXpmycjxdqEE5hQ7XB/PTZs5i7zWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCRO6h66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCRO6h66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443ACC4CEF1;
	Tue, 16 Dec 2025 11:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884602;
	bh=LR6Fa1qXonfRtGCmLjKG5yv8LvURE/qDDUTGSirIVSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCRO6h66buHz7t1TG/lNrqpnL8JZTvD7nCNNbs9uLPXaCU86CwglFDFdQo1kFW6yb
	 IVu9yrBsk4p8EYVt22aakuNdnD94qPMmqbCa1ost46Rcczz815pnk+UbBxkT/iPuyO
	 rIpAxhLvn+LLIZOV9OfD1YnVhSXZjs6U9jjFBxSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 211/354] RISC-V: KVM: Fix guest page fault within HLV* instructions
Date: Tue, 16 Dec 2025 12:12:58 +0100
Message-ID: <20251216111328.565181547@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 97dec18e69892..3dbd6a09d4825 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -424,6 +424,22 @@ static int system_opcode_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
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
@@ -449,6 +465,8 @@ int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 							  ct->sepc,
 							  &utrap);
 			if (utrap.scause) {
+				if (is_load_guest_page_fault(utrap.scause))
+					return 1;
 				utrap.sepc = ct->sepc;
 				kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
 				return 1;
@@ -504,6 +522,8 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
 						  &utrap);
 		if (utrap.scause) {
+			if (is_load_guest_page_fault(utrap.scause))
+				return 1;
 			/* Redirect trap if we failed to read instruction */
 			utrap.sepc = ct->sepc;
 			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
@@ -630,6 +650,8 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
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



