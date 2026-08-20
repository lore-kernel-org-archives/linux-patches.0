Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B76E46D0BD;
	Thu, 20 Aug 2026 16:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243642; cv=none; b=vDkNnwkqa8iZqu0V4Dwjw65vbejbXls5R9e561djc7PCrisUGGN+R66wxA2ipHMUNChYi82UgBDqR3kL3Dlnr8QhJWUjF9sm7YxyviyNaAHx5Qz+Dxfe7LkQHT4CNCXsQ5L4cIPzPC51HFOv5DFG5UhztZpweKH2u2kihbYtoqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243642; c=relaxed/simple;
	bh=alQrO56a3xU2mJGVWUI/cYVXuqT8HRV5xZRv54VSJY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzgNyM57GFlq4d4osXZbNypnIB2bW2aznSej0AK7IB/mEAauKSz83a5ynmLuYpgOyXcptagjwbE8NVrZPobjBTb+KJvFitYF/jUiL2lvm4m8lZpXHOEstlAx6SUPEBrE2RQBeftXeLGPaBBbLcZv++FdOoLk5rLu4Dat78UZbtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGoLKdNT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGoLKdNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016881F000E9;
	Thu, 20 Aug 2026 16:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243641;
	bh=qR0rVQlEW3G+zf5/Unl0Ak1Za6aTQIEtOjmSLt41ULE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGoLKdNTzU2Ib7XwVHXpDZtGUPOYRCk9uuuok57c/HiDctxV/l1qqEOdvCXiPpeSd
	 KQk9Ssm3hpKhVfYWsgIVJbkl/gvLlhJrBYA/AeNTySqbxJWwrrhpGI67iKBwn/eEbg
	 D7Z+mOh2rrcMbI9ljvLJUsDhXsTesuCX09JsXWBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Matlack <dmatlack@google.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/272] KVM: x86/mmu: Split out TDP MMU page fault handling
Date: Thu, 20 Aug 2026 16:55:50 +0200
Message-ID: <20260820145236.337094743@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   84 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 64 insertions(+), 20 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3997,7 +3997,6 @@ out_retry:
 static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			     bool prefault, int max_level, bool is_tdp)
 {
-	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
 	bool write = error_code & PFERR_WRITE_MASK;
 	bool map_writable;
 
@@ -4029,31 +4028,20 @@ static int direct_page_fault(struct kvm_
 		return r;
 
 	r = RET_PF_RETRY;
-
-	if (is_tdp_mmu_fault)
-		read_lock(&vcpu->kvm->mmu_lock);
-	else
-		write_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 
 	if (!is_noslot_pfn(pfn) && mmu_invalidate_retry_hva(vcpu->kvm, mmu_seq, hva))
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
@@ -4101,6 +4089,56 @@ int kvm_handle_page_fault(struct kvm_vcp
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
+	if (!is_noslot_pfn(pfn) && mmu_invalidate_retry_hva(vcpu->kvm, mmu_seq, hva))
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
@@ -4116,6 +4154,12 @@ int kvm_tdp_page_fault(struct kvm_vcpu *
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


