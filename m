Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258F32D8364;
	Mon, 13 Apr 2026 16:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098515; cv=none; b=cJkfoCAJQfh+E6O9+QkbrBIeG6wxqh9boKHNskAnG7NaPPWtkCGyyTLEsUuKLJaSkSWz04Vm8L2u0p53ZrRq1wzWEXl4i7/drei1WnaDgXzKKIDysxJvEsQ1tJ9Y9bKGI2hBMnx+knrmG3wkOPI0EOqn2+IQ+VbA44dvRR6LuYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098515; c=relaxed/simple;
	bh=HUnjOceagIbtdd/qghBbyv+nUdlcD9c86Vxq8af23JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFn1ZpPRNhpRbUHToBQ9tEGu8otQhviXcQqRA9ItSWkn962b6bMbe8geo9W4T6qgJCTk2nuLOwMRXHfCW0gP8whbyxgRbpSl/owNWFUtZCF55rBhL6khTUJ7W4XVS2avFS7AESvGYlJkHrhxrDIBczx4/tKcOy56VwoTnqV7cVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frsFoP4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frsFoP4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5D6C2BCAF;
	Mon, 13 Apr 2026 16:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098515;
	bh=HUnjOceagIbtdd/qghBbyv+nUdlcD9c86Vxq8af23JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frsFoP4MJxjE2DSqDloeDb+kyijuTC8W8LyOrJJTy3vXfxrLZseKKx6gt+Lg9dvEo
	 uAfxZGQ9TsThPtII9xKSdv+fQhPw2EpRmymYHjopAOXaSIHUVVLQJN2kPXvoP9VgUD
	 qv6i+nORx951sFkHKMu62zjMrm6PAdeB3sYt6Avw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Bulekov <bkov@amazon.com>,
	Fred Griffoul <fgriffo@amazon.co.uk>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 555/570] KVM: x86/mmu: Drop/zap existing present SPTE even when creating an MMIO SPTE
Date: Mon, 13 Apr 2026 18:01:26 +0200
Message-ID: <20260413155851.253718287@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit aad885e774966e97b675dfe928da164214a71605 ]

When installing an emulated MMIO SPTE, do so *after* dropping/zapping the
existing SPTE (if it's shadow-present).  While commit a54aa15c6bda3 was
right about it being impossible to convert a shadow-present SPTE to an
MMIO SPTE due to a _guest_ write, it failed to account for writes to guest
memory that are outside the scope of KVM.

E.g. if host userspace modifies a shadowed gPTE to switch from a memslot
to emulted MMIO and then the guest hits a relevant page fault, KVM will
install the MMIO SPTE without first zapping the shadow-present SPTE.

  ------------[ cut here ]------------
  is_shadow_present_pte(*sptep)
  WARNING: arch/x86/kvm/mmu/mmu.c:484 at mark_mmio_spte+0xb2/0xc0 [kvm], CPU#0: vmx_ept_stale_r/4292
  Modules linked in: kvm_intel kvm irqbypass
  CPU: 0 UID: 1000 PID: 4292 Comm: vmx_ept_stale_r Not tainted 7.0.0-rc2-eafebd2d2ab0-sink-vm #319 PREEMPT
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:mark_mmio_spte+0xb2/0xc0 [kvm]
  Call Trace:
   <TASK>
   mmu_set_spte+0x237/0x440 [kvm]
   ept_page_fault+0x535/0x7f0 [kvm]
   kvm_mmu_do_page_fault+0xee/0x1f0 [kvm]
   kvm_mmu_page_fault+0x8d/0x620 [kvm]
   vmx_handle_exit+0x18c/0x5a0 [kvm_intel]
   kvm_arch_vcpu_ioctl_run+0xc55/0x1c20 [kvm]
   kvm_vcpu_ioctl+0x2d5/0x980 [kvm]
   __x64_sys_ioctl+0x8a/0xd0
   do_syscall_64+0xb5/0x730
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x47fa3f
   </TASK>
  ---[ end trace 0000000000000000 ]---

Reported-by: Alexander Bulekov <bkov@amazon.com>
Debugged-by: Alexander Bulekov <bkov@amazon.com>
Suggested-by: Fred Griffoul <fgriffo@amazon.co.uk>
Fixes: a54aa15c6bda3 ("KVM: x86/mmu: Handle MMIO SPTEs directly in mmu_set_spte()")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ replaced `kvm_flush_remote_tlbs_gfn()` with `kvm_flush_remote_tlbs_with_address()` and omitted `pf_mmio_spte_created` stat counter ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2717,11 +2717,6 @@ static int mmu_set_spte(struct kvm_vcpu
 	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
 		 *sptep, write_fault, gfn);
 
-	if (unlikely(is_noslot_pfn(pfn))) {
-		mark_mmio_spte(vcpu, sptep, gfn, pte_access);
-		return RET_PF_EMULATE;
-	}
-
 	if (is_shadow_present_pte(*sptep)) {
 		/*
 		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
@@ -2743,6 +2738,14 @@ static int mmu_set_spte(struct kvm_vcpu
 			was_rmapped = 1;
 	}
 
+	if (unlikely(is_noslot_pfn(pfn))) {
+		mark_mmio_spte(vcpu, sptep, gfn, pte_access);
+		if (flush)
+			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn,
+					KVM_PAGES_PER_HPAGE(level));
+		return RET_PF_EMULATE;
+	}
+
 	set_spte_ret = set_spte(vcpu, sptep, pte_access, level, gfn, pfn,
 				speculative, true, host_writable);
 	if (set_spte_ret & SET_SPTE_WRITE_PROTECTED_PT) {


