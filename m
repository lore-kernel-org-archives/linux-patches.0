Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CFE515889;
	Wed, 30 Sep 2026 17:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788101; cv=none; b=lsROrnjWyRzci3X69+LNGfu4RCuVT+xZ/Hxzd2MVgwRuppwhscD2wt6Ad7bvaruL8nLmXzVlb57EWm4PGzZZo3ZkuHlgO8xtJ7tWD7oejuIalBT+qcdcAFvV4/+BCXSLvd0v411kpoOpDrgwCOgoEzJsZnCVWZP/tXyLAZiJt4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788101; c=relaxed/simple;
	bh=8SFHqwc0/QJVn69QTBA7ZF5Y1plpopgbI9EarOi2oqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qq4ajZukPK0l3lhxz901555UhG6vxIsYfi92ZZXr+AVGHpa0SZfTk/Q7KjiU8jeQ/QHY05uTFoXAT+CXk+BPBbjuOHOzrcRPLuf4WfzFQyr0H8yce6oD3zU7SyUK8+4jllpQsogOSjuNYaYn5F6KxOQp7FMPwS/ANkigJw0giZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPo82Zl/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPo82Zl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144421F000FF;
	Wed, 30 Sep 2026 17:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788100;
	bh=I66ozHKU10JX7UHOxaMuBxisGm9eumyThtyfm2cfKwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GPo82Zl/akCtxKRD4taPjDtiamIxGSekksHPT2pQnRVR7yQZtq/yftAGTYG5FYawb
	 bB9e8TtYwR77PjyKArK0Q0jFQEDAwostvA3xeP1p9EHK5sW0J2C6iDFBVr98nq0A1L
	 BBakOOQcCkte0y5chumgYjIFqiDQSr57gfIEYMHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 451/457] KVM: x86/mmu: Move kvm_arch_async_page_ready() below kvm_tdp_page_fault()
Date: Wed, 30 Sep 2026 17:29:16 +0200
Message-ID: <20260930152355.738719537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 31a2cf735cc00c01526bcb676f111d5c0b711d17 ]

Move the implementation of kvm_arch_async_page_ready() "down" in mmu.c so
that it lives below kvm_tdp_page_fault().  This will allow moving
kvm_mmu_do_page_fault() into mmu.c without needing a forward declaration.

No functional change intended.

Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Message-ID: <20260613000329.732085-29-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 10180a277549 ("KVM: x86: Re-pend GET_NESTED_STATE_PAGES if getting said pages fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   62 ++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4600,37 +4600,6 @@ static bool kvm_arch_setup_async_pf(stru
 				  kvm_vcpu_gfn_to_hva(vcpu, fault->gfn), &arch);
 }
 
-void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
-{
-	int r;
-
-	if (WARN_ON_ONCE(work->arch.error_code & PFERR_PRIVATE_ACCESS))
-		return;
-
-	if ((vcpu->arch.mmu->root_role.direct != work->arch.direct_map) ||
-	      work->wakeup_all)
-		return;
-
-	r = kvm_mmu_reload(vcpu);
-	if (unlikely(r))
-		return;
-
-	if (!vcpu->arch.mmu->root_role.direct &&
-	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
-		return;
-
-	r = kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, work->arch.error_code,
-				  true, NULL, NULL);
-
-	/*
-	 * Account fixed page faults, otherwise they'll never be counted, but
-	 * ignore stats for all other return times.  Page-ready "faults" aren't
-	 * truly spurious and never trigger emulation
-	 */
-	if (r == RET_PF_FIXED)
-		vcpu->stat.pf_fixed++;
-}
-
 static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 				      struct kvm_page_fault *fault, int r)
 {
@@ -5088,6 +5057,37 @@ long kvm_arch_vcpu_pre_fault_memory(stru
 	return min(range->size, end - range->gpa);
 }
 
+void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
+{
+	int r;
+
+	if (WARN_ON_ONCE(work->arch.error_code & PFERR_PRIVATE_ACCESS))
+		return;
+
+	if ((vcpu->arch.mmu->root_role.direct != work->arch.direct_map) ||
+	      work->wakeup_all)
+		return;
+
+	r = kvm_mmu_reload(vcpu);
+	if (unlikely(r))
+		return;
+
+	if (!vcpu->arch.mmu->root_role.direct &&
+	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
+		return;
+
+	r = kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, work->arch.error_code,
+				  true, NULL, NULL);
+
+	/*
+	 * Account fixed page faults, otherwise they'll never be counted, but
+	 * ignore stats for all other return times.  Page-ready "faults" aren't
+	 * truly spurious and never trigger emulation
+	 */
+	if (r == RET_PF_FIXED)
+		vcpu->stat.pf_fixed++;
+}
+
 #ifdef CONFIG_KVM_GUEST_MEMFD
 static void kvm_assert_gmem_invalidate_lock_held(struct kvm_memory_slot *slot)
 {


