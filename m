Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3CC481244;
	Tue, 25 Aug 2026 13:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666251; cv=none; b=Llvb1pGN0H1KxueePYI3z9oIpax1nS/LVEDRXqahn2XXF31W+wk1Yo7HxNNMoLNwlncZ93st4YgnlaVUx0SqGQD5hUtfKnV/4Iz52seU2tyq6GsrQV/wsnPuL4uRmqO6yETxGhSI6CUH9AdQ9yDN4vP8uVkhE0uwbkIsnWVOfGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666251; c=relaxed/simple;
	bh=LGrSDUs52GDzQua2NPIqcssHuYoRD1QgcALRmbDqj1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tv8lIN1wKL0XZdlp8wl/+YChwWzOKYBPslrJNvbseMnRA61FJhw9JRaqlIasT4PJyapIIId7E58+bhefygtHDMjyjYfM2s0uuZiqWUkSJNs4i0hBc6ArKYeGQpxN6wilhABgLmGw+Z5yaDlXZXfE4xnoe+hLyAPXYLROjzf27qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KfOjXLdm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KfOjXLdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CA21F000E9;
	Tue, 25 Aug 2026 13:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666250;
	bh=X8KSc8u2Y6ndPMsCg8c63qeRyiJyExhDA53vjLVItUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KfOjXLdmaoO4LqRdPR83Xn0HuRqZDlXOPRZIPxdxnFp+Mhv5uDMl9KzAIwiayaNIw
	 07m9BuvpR4kZ0WzpZutb+Z7dm0I6jlrk84nDmN1ElBC8LVE7uynHSXe+p3Df4brtgu
	 oO4HzcS8gEv+Yw6y6vnL/guzZobogvPxWtJni95c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Matlack <dmatlack@google.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Kenta Akagi <k@mgml.me>
Subject: [PATCH 5.15 56/76] KVM: x86/mmu: Split out TDP MMU page fault handling
Date: Tue, 25 Aug 2026 15:26:49 +0200
Message-ID: <20260825132543.771950648@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

From: David Matlack <dmatlack@google.com>

[ Upstream commit 9aa8ab43b38146029de807a8ff2696f51e15b226 ]

Split out the page fault handling for the TDP MMU to a separate
function.  This creates some duplicate code, but makes the TDP MMU fault
handler simpler to read by eliminating branches and will enable future
cleanups by allowing the TDP MMU and non-TDP MMU fault paths to diverge.

Only compile in the TDP MMU fault handler for 64-bit builds since
kvm_tdp_mmu_map() does not exist in 32-bit builds.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20220921173546.2674386-9-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 2abd5287f083 ("KVM: x86: Check for invalid/obsolete root *after* making MMU pages available")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Kenta Akagi <k@mgml.me>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   84 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 64 insertions(+), 20 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4015,7 +4015,6 @@ static bool is_page_fault_stale(struct k
 static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			     bool prefault, int max_level, bool is_tdp)
 {
-	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
 	bool write = error_code & PFERR_WRITE_MASK;
 	bool map_writable;
 
@@ -4047,31 +4046,20 @@ static int direct_page_fault(struct kvm_
 		return r;
 
 	r = RET_PF_RETRY;
-
-	if (is_tdp_mmu_fault)
-		read_lock(&vcpu->kvm->mmu_lock);
-	else
-		write_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 
 	if (is_page_fault_stale(vcpu, pfn, mmu_seq, hva))
 		goto out_unlock;
 
-	if (is_tdp_mmu_fault) {
-		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
-				    pfn, prefault);
-	} else {
-		r = make_mmu_pages_available(vcpu);
-		if (r)
-			goto out_unlock;
-		r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
-				 prefault, is_tdp);
-	}
+	r = make_mmu_pages_available(vcpu);
+	if (r)
+		goto out_unlock;
+
+	r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
+			 prefault, is_tdp);
 
 out_unlock:
-	if (is_tdp_mmu_fault)
-		read_unlock(&vcpu->kvm->mmu_lock);
-	else
-		write_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
 	return r;
 }
@@ -4119,6 +4107,56 @@ int kvm_handle_page_fault(struct kvm_vcp
 }
 EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
 
+#ifdef CONFIG_X86_64
+static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
+				  u32 error_code, bool prefault, int max_level)
+{
+	bool write = error_code & PFERR_WRITE_MASK;
+	bool map_writable;
+
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	unsigned long mmu_seq;
+	kvm_pfn_t pfn;
+	hva_t hva;
+	int r;
+
+	if (page_fault_handle_page_track(vcpu, error_code, gfn))
+		return RET_PF_EMULATE;
+
+	r = fast_page_fault(vcpu, gpa, error_code);
+	if (r != RET_PF_INVALID)
+		return r;
+
+	r = mmu_topup_memory_caches(vcpu, false);
+	if (r)
+		return r;
+
+	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+	smp_rmb();
+
+	if (kvm_faultin_pfn(vcpu, prefault, gfn, gpa, &pfn, &hva,
+			 write, &map_writable, &r))
+		return r;
+
+	if (handle_abnormal_pfn(vcpu, 0, gfn, pfn, ACC_ALL, &r))
+		return r;
+
+	r = RET_PF_RETRY;
+	read_lock(&vcpu->kvm->mmu_lock);
+
+	if (is_page_fault_stale(vcpu, pfn, mmu_seq, hva))
+		goto out_unlock;
+
+	r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
+			    pfn, prefault);
+
+out_unlock:
+	read_unlock(&vcpu->kvm->mmu_lock);
+	kvm_release_pfn_clean(pfn);
+	return r;
+}
+#endif
+
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		       bool prefault)
 {
@@ -4134,6 +4172,12 @@ int kvm_tdp_page_fault(struct kvm_vcpu *
 			break;
 	}
 
+#ifdef CONFIG_X86_64
+	if (is_tdp_mmu(vcpu->arch.mmu))
+		return kvm_tdp_mmu_page_fault(vcpu, gpa, error_code, prefault,
+					      max_level);
+#endif
+
 	return direct_page_fault(vcpu, gpa, error_code, prefault,
 				 max_level, true);
 }


