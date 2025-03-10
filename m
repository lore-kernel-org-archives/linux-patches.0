Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE58223702;
	Mon, 10 Mar 2025 17:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628607; cv=none; b=aI3XMZDoUz/JK6tuTEQVXGUepkgmwkNJzA95v8bFgrDv+lhgm1dgwNyVQ+O6P6p2mq63HYTqCP2nttUXLZqWv38kjvCz2bJRHBtuTbw9QaABxXF2Hnu3dcpJ8dX5z4mTBaaguAhTNzx1pusQ1cYpLO90upU6uxjHCKhdyHFJLsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628607; c=relaxed/simple;
	bh=yGxJf+hS7vcnnTUrwwFDoPug7wL4mu1ibVVzS86jGc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoeJ1AQJ8uizg6/YsA5SG5EWEyvBdgdKhPr5uh66s29HNfDxL53UR5ZQAbChj5EYMweoC6JHC/UyDAb88DDIqzSGjOdghU8US5qgVEeY8kVRLWB24hP+670Q2YN6fwm+iqPbqmfEqflx7xBCIBWUf8O3YdiLTJkh20amXlBC4U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QgJvyicQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QgJvyicQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A698FC4CEE5;
	Mon, 10 Mar 2025 17:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628607;
	bh=yGxJf+hS7vcnnTUrwwFDoPug7wL4mu1ibVVzS86jGc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgJvyicQfBxNh8ZohJzeUpNej/ueG0A2XLa4F7fC2ZtMWtULQRYGtzbbADOJKHyxL
	 jwduVyxW40ErLkSif6pgcP0M9OFMIZM1hvV8JITlqHRbkxfZYoYlA3B0yiekNz4NDQ
	 hW5YEAjeZ5ALeBhu2GFq+NfSiFfX9yzDlW12YwcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 094/109] Revert "KVM: PPC: e500: Use __kvm_faultin_pfn() to handle page faults"
Date: Mon, 10 Mar 2025 18:07:18 +0100
Message-ID: <20250310170431.301830214@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit deead14da7478b40a18cc439064c9c1a933e1b4b which is
commit 419cfb983ca93e75e905794521afefcfa07988bb upstream.

It should not have been applied.

Link: https://lore.kernel.org/r/CABgObfb5U9zwTQBPkPB=mKu-vMrRspPCm4wfxoQpB+SyAnb5WQ@mail.gmail.com
Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/e500_mmu_host.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -322,7 +322,6 @@ static inline int kvmppc_e500_shadow_map
 {
 	struct kvm_memory_slot *slot;
 	unsigned long pfn = 0; /* silence GCC warning */
-	struct page *page = NULL;
 	unsigned long hva;
 	int pfnmap = 0;
 	int tsize = BOOK3E_PAGESZ_4K;
@@ -444,7 +443,7 @@ static inline int kvmppc_e500_shadow_map
 
 	if (likely(!pfnmap)) {
 		tsize_pages = 1UL << (tsize + 10 - PAGE_SHIFT);
-		pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, NULL, &page);
+		pfn = gfn_to_pfn_memslot(slot, gfn);
 		if (is_error_noslot_pfn(pfn)) {
 			if (printk_ratelimit())
 				pr_err("%s: real page not found for gfn %lx\n",
@@ -489,6 +488,8 @@ static inline int kvmppc_e500_shadow_map
 		}
 	}
 	writable = kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
+	if (writable)
+		kvm_set_pfn_dirty(pfn);
 
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
@@ -497,7 +498,8 @@ static inline int kvmppc_e500_shadow_map
 	kvmppc_mmu_flush_icache(pfn);
 
 out:
-	kvm_release_faultin_page(kvm, page, !!ret, writable);
+	/* Drop refcount on page, so that mmu notifiers can clear it */
+	kvm_release_pfn_clean(pfn);
 	spin_unlock(&kvm->mmu_lock);
 	return ret;
 }


