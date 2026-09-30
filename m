Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CF4530E1A;
	Wed, 30 Sep 2026 17:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789957; cv=none; b=YjkpOi7k4TFRPyPsdMV9BBoAhiO0NnW74w7xueCPDTKLT4UgHjrOc7RNcLR6rUNzx42HkQGKP/eDdBIukPvLdkN1XYr52DWXiAMUqLnLq/nQT9HYegpnPSv7QoJTjQ6yPEWF5YzTjtZUCTLoPJ3vGWLIo+IXW/BZ5gtWfZUclY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789957; c=relaxed/simple;
	bh=eGS0BuKOde8ZqeQ9XG34NCVHrMqCRomN2FOj+xve+f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7glwrFWJ8V2yqxGZ0TG5fE/8Plt8Yfz3q8xrpBwTTLaBidkV+529TfenJWUA5yRvm3D72EehG+20QHYy1ga9nAUbUQyWGYrK/R0sY0RYoHxKpBssz20bvVoxkRr+4jI6eebsBRGLeiaHHzdgoHPO7LqKnRmR7cxa1RDXyBtSxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4j0W0pc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4j0W0pc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D1E1F000FF;
	Wed, 30 Sep 2026 17:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789956;
	bh=1w1hqT2SoKNRK0QaZwv6G4codhRUg9ulsuySJWvLUks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B4j0W0pcw/4nM4sM8HDYTRgP1oFKMczAQgGcc1OE7ZAx3m7ECoHW9P2EkrjhZcS7R
	 Zn3fmTmzBXdjm2rjnqMimnyl861fQ61ICxe1J8liqdw6MUwUpu/aVpcyUoH2jzZMFr
	 PBdOwRB+TiwSySoAVnkMdiFy1r2KMehtOlQFlSPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vipin Sharma <vipinsh@google.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 660/877] KVM: x86/mmu: Dynamically allocate shadow MMUs hashed page list
Date: Wed, 30 Sep 2026 17:26:11 +0200
Message-ID: <20260930152428.905722697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 039ef33e2f9346258fe2bd344f212c645942575e ]

Dynamically allocate the (massive) array of hashed lists used to track
shadow pages, as the array itself is 32KiB, i.e. is an order-3 allocation
all on its own, and is *exactly* an order-3 allocation.  Dynamically
allocating the array will allow allocating "struct kvm" using kvmalloc(),
and will also allow deferring allocation of the array until it's actually
needed, i.e. until the first shadow root is allocated.

Opportunistically use kvmalloc() for the hashed lists, as an order-3
allocation is (stating the obvious) less likely to fail than an order-4
allocation, and the overhead of vmalloc() is undesirable given that the
size of the allocation is fixed.

Cc: Vipin Sharma <vipinsh@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://lore.kernel.org/r/20250523001138.3182794-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: b27622c4eeb1 ("KVM: x86/mmu: Split kvm_mmu_zap_all_fast() into "front" and "back" halves")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    4 ++--
 arch/x86/kvm/mmu/mmu.c          |   23 ++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |    5 ++++-
 3 files changed, 28 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1307,7 +1307,7 @@ struct kvm_arch {
 	bool has_private_mem;
 	bool has_protected_state;
 	bool pre_fault_allowed;
-	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
+	struct hlist_head *mmu_page_hash;
 	struct list_head active_mmu_pages;
 	struct list_head zapped_obsolete_pages;
 	/*
@@ -1954,7 +1954,7 @@ void kvm_mmu_vendor_module_exit(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
-void kvm_mmu_init_vm(struct kvm *kvm);
+int kvm_mmu_init_vm(struct kvm *kvm);
 void kvm_mmu_uninit_vm(struct kvm *kvm);
 
 void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3772,6 +3772,18 @@ out_unlock:
 	return r;
 }
 
+static int kvm_mmu_alloc_page_hash(struct kvm *kvm)
+{
+	struct hlist_head *h;
+
+	h = kvcalloc(KVM_NUM_MMU_PAGES, sizeof(*h), GFP_KERNEL_ACCOUNT);
+	if (!h)
+		return -ENOMEM;
+
+	kvm->arch.mmu_page_hash = h;
+	return 0;
+}
+
 static int mmu_first_shadow_root_alloc(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
@@ -6542,14 +6554,20 @@ static bool kvm_has_zapped_obsolete_page
 	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
 }
 
-void kvm_mmu_init_vm(struct kvm *kvm)
+int kvm_mmu_init_vm(struct kvm *kvm)
 {
+	int r;
+
 	kvm->arch.shadow_mmio_value = shadow_mmio_value;
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
 	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
 	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
 
+	r = kvm_mmu_alloc_page_hash(kvm);
+	if (r)
+		return r;
+
 	if (tdp_mmu_enabled)
 		kvm_mmu_init_tdp_mmu(kvm);
 
@@ -6560,6 +6578,7 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 
 	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
 	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
+	return 0;
 }
 
 static void mmu_free_vm_memory_caches(struct kvm *kvm)
@@ -6571,6 +6590,8 @@ static void mmu_free_vm_memory_caches(st
 
 void kvm_mmu_uninit_vm(struct kvm *kvm)
 {
+	kvfree(kvm->arch.mmu_page_hash);
+
 	if (tdp_mmu_enabled)
 		kvm_mmu_uninit_tdp_mmu(kvm);
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12827,7 +12827,9 @@ int kvm_arch_init_vm(struct kvm *kvm, un
 	if (ret)
 		goto out;
 
-	kvm_mmu_init_vm(kvm);
+	ret = kvm_mmu_init_vm(kvm);
+	if (ret)
+		goto out_cleanup_page_track;
 
 	ret = kvm_x86_call(vm_init)(kvm);
 	if (ret)
@@ -12872,6 +12874,7 @@ int kvm_arch_init_vm(struct kvm *kvm, un
 
 out_uninit_mmu:
 	kvm_mmu_uninit_vm(kvm);
+out_cleanup_page_track:
 	kvm_page_track_cleanup(kvm);
 out:
 	return ret;


