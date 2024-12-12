Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662FD2054EF;
	Thu, 12 Dec 2024 16:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021461; cv=none; b=SHs4rTMc/NIvYvgQkKPigZPgawP4GOJHApZbi21HaNItP7vceVkWs7X/FN9LlYxU2ttFJyVepTktxQJzlAXBumNj9UYEnfvOLuBwyey7A+mwHds9iYn36wQKkvvzYqz8HJyxQ5ffjAKIBLyr/WdP+DOGpur6RmaMG6VXy4m7vwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021461; c=relaxed/simple;
	bh=oDz54dkru8uxY8MigODuxHkeXkhi2CPJoADuUP3ECp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d34R0BKag9k+icJWGNF9ky2r6mksgU/0sWJEd4hwXyV2poztQ1DAgrAUboB6TljH6CfhmjtUdgIno1CjKz0wBxqt5tcMS9TLCe7vFmufkBaL5Cp6foJRrJigr6qOzy2w6uJzeaVynI1Dv+Sa8vkyKr13pSPZGYWHmtWDsSS9WC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hfl8ZZAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hfl8ZZAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1704C4CECE;
	Thu, 12 Dec 2024 16:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021461;
	bh=oDz54dkru8uxY8MigODuxHkeXkhi2CPJoADuUP3ECp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hfl8ZZAA5AUAgXFmimx0Oeb8mlUr61YFJyxGt3LTAqqUpCO3xU9nPn2NUw92jDdzJ
	 bafmRqrbqQ2o7TJwT6c01rZQnZ51naHV4Gna3zRftShn/llWEJL6vFsnHMv7t0Yd1t
	 U7C1/0/4+Ejx/SXjJXe2gg1BJ7cmdZGJ/P6YMJMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Nikolay Kuratov <kniv@yandex-team.ru>
Subject: [PATCH 6.1 742/772] KVM: x86/mmu: Ensure that kvm_release_pfn_clean() takes exact pfn from kvm_faultin_pfn()
Date: Thu, 12 Dec 2024 16:01:27 +0100
Message-ID: <20241212144420.595677651@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nikolay Kuratov <kniv@yandex-team.ru>

Since 5.16 and prior to 6.13 KVM can't be used with FSDAX
guest memory (PMD pages). To reproduce the issue you need to reserve
guest memory with `memmap=` cmdline, create and mount FS in DAX mode
(tested both XFS and ext4), see doc link below. ndctl command for test:
ndctl create-namespace -v -e namespace1.0 --map=dev --mode=fsdax -a 2M
Then pass memory object to qemu like:
-m 8G -object memory-backend-file,id=ram0,size=8G,\
mem-path=/mnt/pmem/guestmem,share=on,prealloc=on,dump=off,align=2097152 \
-numa node,memdev=ram0,cpus=0-1
QEMU fails to run guest with error: kvm run failed Bad address
and there are two warnings in dmesg:
WARN_ON_ONCE(!page_count(page)) in kvm_is_zone_device_page() and
WARN_ON_ONCE(folio_ref_count(folio) <= 0) in try_grab_folio() (v6.6.63)

It looks like in the past assumption was made that pfn won't change from
faultin_pfn() to release_pfn_clean(), e.g. see
commit 4cd071d13c5c ("KVM: x86/mmu: Move calls to thp_adjust() down a level")
But kvm_page_fault structure made pfn part of mutable state, so
now release_pfn_clean() can take hugepage-adjusted pfn.
And it works for all cases (/dev/shm, hugetlb, devdax) except fsdax.
Apparently in fsdax mode faultin-pfn and adjusted-pfn may refer to
different folios, so we're getting get_page/put_page imbalance.

To solve this preserve faultin pfn in separate local variable
and pass it in kvm_release_pfn_clean().

Patch tested for all mentioned guest memory backends with tdp_mmu={0,1}.

No bug in upstream as it was solved fundamentally by
commit 8dd861cc07e2 ("KVM: x86/mmu: Put refcounted pages instead of blindly releasing pfns")
and related patch series.

Link: https://nvdimm.docs.kernel.org/2mib_fs_dax.html
Fixes: 2f6305dd5676 ("KVM: MMU: change kvm_tdp_mmu_map() arguments to kvm_page_fault")
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c         |    5 ++++-
 arch/x86/kvm/mmu/paging_tmpl.h |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4245,6 +4245,7 @@ static int direct_page_fault(struct kvm_
 	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
 
 	unsigned long mmu_seq;
+	kvm_pfn_t orig_pfn;
 	int r;
 
 	fault->gfn = fault->addr >> PAGE_SHIFT;
@@ -4272,6 +4273,8 @@ static int direct_page_fault(struct kvm_
 	if (r != RET_PF_CONTINUE)
 		return r;
 
+	orig_pfn = fault->pfn;
+
 	r = RET_PF_RETRY;
 
 	if (is_tdp_mmu_fault)
@@ -4296,7 +4299,7 @@ out_unlock:
 		read_unlock(&vcpu->kvm->mmu_lock);
 	else
 		write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
+	kvm_release_pfn_clean(orig_pfn);
 	return r;
 }
 
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -790,6 +790,7 @@ FNAME(is_self_change_mapping)(struct kvm
 static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct guest_walker walker;
+	kvm_pfn_t orig_pfn;
 	int r;
 	unsigned long mmu_seq;
 	bool is_self_change_mapping;
@@ -868,6 +869,8 @@ static int FNAME(page_fault)(struct kvm_
 			walker.pte_access &= ~ACC_EXEC_MASK;
 	}
 
+	orig_pfn = fault->pfn;
+
 	r = RET_PF_RETRY;
 	write_lock(&vcpu->kvm->mmu_lock);
 
@@ -881,7 +884,7 @@ static int FNAME(page_fault)(struct kvm_
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
+	kvm_release_pfn_clean(orig_pfn);
 	return r;
 }
 


