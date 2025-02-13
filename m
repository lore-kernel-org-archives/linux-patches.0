Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5B626B0BD;
	Thu, 13 Feb 2025 15:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460244; cv=none; b=X4iG1hIrbvXxIOMb563yYXjPBjtByGq4hM1wJvecED3yZoMzVZ6vAqIUjC4zY4QbNIn8RFUhR0m5emncM7X+0hSB2nNm1WO6UdiEKLKUeHUlUFayApDW04GFkTmiRhJraQGlf4QEpm0joGSvLX2SauliHHs6lRfZGtQDRo4uifc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460244; c=relaxed/simple;
	bh=ALt+U3OufzL3s0fh4V8DhIz7uwCrDKs2vCNl173MffY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feTz+Vfbj8ucYvJ+ja/R0oXWcBUkFmR++fWzAC5uajO77d8/YJQTYXXE/BEaWTTU7bMGoRlJu7AOFA8KabqjMAL12bt5pOiBaCcMzQLlJ+CxsNtf4/KnmjdFOB6wytTnFy/Dwcf2Fsu0d0Dl8X7ZHxpJaOhJJzL5ALFecty5qII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iY/1FdNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iY/1FdNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B114CC4CEE7;
	Thu, 13 Feb 2025 15:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460244;
	bh=ALt+U3OufzL3s0fh4V8DhIz7uwCrDKs2vCNl173MffY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iY/1FdNmv5fd494XAH8gRMzI5nSTFoLLi1TvkoGNWIyk0stgasJu6a9XoBu6ZfqYd
	 sF4xQa4nLQtYO6bVM+ZlGQAB+eMO/5PJ9B+T0VraBRjx0HQFuEtMtEKSC015z4OIfV
	 ZHf/nR2OQHCxn+S5Zg2O8tvMEYVO7hhp64FkKaRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/273] KVM: PPC: e500: Use __kvm_faultin_pfn() to handle page faults
Date: Thu, 13 Feb 2025 15:27:08 +0100
Message-ID: <20250213142409.566936828@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 419cfb983ca93e75e905794521afefcfa07988bb ]

Convert PPC e500 to use __kvm_faultin_pfn()+kvm_release_faultin_page(),
and continue the inexorable march towards the demise of
kvm_pfn_to_refcounted_page().

Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20241010182427.1434605-55-seanjc@google.com>
Stable-dep-of: 87ecfdbc699c ("KVM: e500: always restore irqs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/e500_mmu_host.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index dc75f025dfe27..1910a48679e52 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -322,6 +322,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 {
 	struct kvm_memory_slot *slot;
 	unsigned long pfn = 0; /* silence GCC warning */
+	struct page *page = NULL;
 	unsigned long hva;
 	int pfnmap = 0;
 	int tsize = BOOK3E_PAGESZ_4K;
@@ -443,7 +444,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 
 	if (likely(!pfnmap)) {
 		tsize_pages = 1UL << (tsize + 10 - PAGE_SHIFT);
-		pfn = gfn_to_pfn_memslot(slot, gfn);
+		pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, NULL, &page);
 		if (is_error_noslot_pfn(pfn)) {
 			if (printk_ratelimit())
 				pr_err("%s: real page not found for gfn %lx\n",
@@ -488,8 +489,6 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 		}
 	}
 	writable = kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
-	if (writable)
-		kvm_set_pfn_dirty(pfn);
 
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
@@ -498,8 +497,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	kvmppc_mmu_flush_icache(pfn);
 
 out:
-	/* Drop refcount on page, so that mmu notifiers can clear it */
-	kvm_release_pfn_clean(pfn);
+	kvm_release_faultin_page(kvm, page, !!ret, writable);
 	spin_unlock(&kvm->mmu_lock);
 	return ret;
 }
-- 
2.39.5



