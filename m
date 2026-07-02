Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7821D31E853;
	Thu,  2 Jul 2026 16:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009936; cv=none; b=rsy6CYbkuoMM6paBlEEPQsoBS9MFsxZxlyWpj3jhVKgzWm+NNp3SX1PGVhhe2yBelKYChrFZ3qMdfqcx16xJoQpfoJnuSuxc5HnNkJSKDT1ihMCckGaXmWMFURG6ghT+qDohTvuLxUa9MqxeR9oH+gwxIRZYA87e8wPusgFU/EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009936; c=relaxed/simple;
	bh=rhv7BiVr6CLENsSZSm2at3K7jO7PiBcmSXSMDWqiC/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2x1nU7oeSUJSDMU8KaUqio3iaWjCjfBr23y/TDYzDNsKy8JY8um5wXZpoyCIERz1PSWamOREKy1QgiORFk3jcB+Pq5Nkr19Z+bCZlfQAf+0YjRN+u9aQaRXnwPoTSeaoFdQ+Aop+L8bcHXTbarminr8IwB8uWPcv4eSLXesVO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9k57pmw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9k57pmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63AF1F000E9;
	Thu,  2 Jul 2026 16:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009935;
	bh=NGg1NK66hDwt9Ap8d/qtFvXcNKVm2PRSDv2+iLmG6OI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p9k57pmwiJOZQqq5ccQZ0gTASqlua9RxaNi4PsLUKkzsxhHGuwjcX9QN8uErAsCc9
	 tgTeAlOGFcnJEcmAgWsTgbKSxUSFMUOj4UNaV05NGLYwwUvnpE2ymiKWpOg/5WgKOq
	 PFOl8tQrFIBq9GDD/tkJpWLuOpiTOqxLW+Q+92Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Matlack <dmatlack@google.com>,
	James Houghton <jthoughton@google.com>,
	Alexander Bulekov <bkov@amazon.com>,
	Fred Griffoul <fgriffo@amazon.co.uk>,
	Alexander Graf <graf@amazon.de>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Filippo Sironi <sironi@amazon.de>,
	Ivan Orlov <iorlov@amazon.co.uk>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/129] KVM: x86/mmu: Ensure hugepage is in by slot before checking max mapping level
Date: Thu,  2 Jul 2026 18:19:26 +0200
Message-ID: <20260702155113.122719195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit ef057cbf825e03b63f6edf5980f96abf3c53089d upstream.

When recovering hugepages in the shadow MMU, verify that the base gfn of
the shadow page is actually contained within the target memslot, *before*
querying the max mapping level given the shadow page's gfn.  Failure to
pre-check the validity of the gfn can lead to an out-of-bounds access to
the slot's lpage_info (which typically manifests as a host #PF because the
lpage_info is vmalloc'd) if the guest creates a hugepage mapping (in its
PTEs) that extends "below" the bounds of a memslot.

When faulting in memory for a guest, and the size of the guest mapping is
greater than KVM's (current) max mapping, then KVM will create a "direct"
shadow page (direct in that there are no gPTEs to shadow, and so the target
gfn is a direct calculation given the base gfn of the shadow page).  The
hugepage recovery flow looks for such direct shadow pages, as forcing 4KiB
mappings when dirty logging generates the guest > host mapping size case.
When the 4KiB restriction is lifted, then KVM can replace the shadow page
with a hugepage.

But if KVM originally used a smaller mapping than the guest because the
range of memory covered by the guest hugepage exceeds the bounds of a
memslot, then KVM will link a direct shadow page with a gfn that is outside
the bounds of the memslot being used to fault in memory.  The rmap entry
added for the leaf mapping is correct and within bounds, but the gfn of the
leaf SPTE's parent shadow page will be out of bounds.

  BUG: unable to handle page fault for address: ffffc90000806ffc
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 100000067 P4D 100000067 PUD 1002a7067 PMD 10612f067 PTE 0
  Oops: Oops: 0000 [#1] SMP
  CPU: 13 UID: 1000 PID: 757 Comm: mmu_stress_test Not tainted 7.1.0-rc1-48ce1e26eace-x86_pir_to_irr_comments-vm #341 PREEMPT
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:kvm_mmu_max_mapping_level+0x79/0x2b0 [kvm]
  Call Trace:
   <TASK>
   kvm_mmu_recover_huge_pages+0x21b/0x320 [kvm]
   kvm_set_memslot+0x1ee/0x590 [kvm]
   kvm_set_memory_region.part.0+0x3a1/0x4d0 [kvm]
   kvm_vm_ioctl+0x9bf/0x15d0 [kvm]
   __x64_sys_ioctl+0x8a/0xd0
   do_syscall_64+0xb7/0xbb0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7f21c0f1a9bf
   </TASK>

Don't bother pre-checking the bounds of the potential hugepage, i.e. don't
check that e.g. sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level + 1) is also
within the memslot, as the checks performed by kvm_mmu_max_mapping_level()
are a superset of the basic bounds checks.  I.e. pre-checking the full
range would be a dubious micro-optimization.

Fixes: 9eba50f8d7fc ("KVM: x86/mmu: Consult max mapping level when zapping collapsible SPTEs")
Cc: stable@vger.kernel.org
Cc: David Matlack <dmatlack@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Alexander Bulekov <bkov@amazon.com>
Cc: Fred Griffoul <fgriffo@amazon.co.uk>
Cc: Alexander Graf <graf@amazon.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Filippo Sironi <sironi@amazon.de>
Cc: Ivan Orlov <iorlov@amazon.co.uk>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c   | 18 ++++++++++++------
 include/linux/kvm_host.h |  7 ++++++-
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9edfc812423766..7785da8f0ad339 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6417,13 +6417,19 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		sp = sptep_to_sp(sptep);
 
 		/*
-		 * We cannot do huge page mapping for indirect shadow pages,
-		 * which are found on the last rmap (level = 1) when not using
-		 * tdp; such shadow pages are synced with the page table in
-		 * the guest, and the guest page table is using 4K page size
-		 * mapping if the indirect sp has level = 1.
+		 * Direct shadow page can be replaced by a hugepage if the host
+		 * mapping level allows it and the memslot maps all of the host
+		 * hugepage.  Note!  If the memslot maps only part of the
+		 * hugepage, sp->gfn may be below slot->base_gfn, and querying
+		 * the max mapping level would cause an out-of-bounds lpage_info
+		 * access.  So the gfn bounds check *must* be done first.
+		 *
+		 * Indirect shadow pages are created when the guest page tables
+		 * are using 4K pages.  Since the host mapping is always
+		 * constrained by the page size in the guest, indirect shadow
+		 * pages are never collapsible.
 		 */
-		if (sp->role.direct &&
+		if (sp->role.direct && is_gfn_in_memslot(slot, sp->gfn) &&
 		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
 							       PG_LEVEL_NUM)) {
 			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 04fac4cdcfbcef..624380c4fef809 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1621,6 +1621,11 @@ int kvm_request_irq_source_id(struct kvm *kvm);
 void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
 
+static inline bool is_gfn_in_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	return gfn >= slot->base_gfn && gfn < slot->base_gfn + slot->npages;
+}
+
 /*
  * Returns a pointer to the memslot if it contains gfn.
  * Otherwise returns NULL.
@@ -1631,7 +1636,7 @@ try_get_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 	if (!slot)
 		return NULL;
 
-	if (gfn >= slot->base_gfn && gfn < slot->base_gfn + slot->npages)
+	if (is_gfn_in_memslot(slot, gfn))
 		return slot;
 	else
 		return NULL;
-- 
2.53.0



