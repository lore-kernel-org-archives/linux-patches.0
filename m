Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AD4D526
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA4AC433C8;
	Mon, 26 Jun 2023 18:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804710;
	bh=YtoAU3eukpvvJErUwR5tBtOrs/6b3TjJ2QBaUkB+uMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zb3msFWL/bIrLoB6yu5g7MsWYSC1i68Dy+QI7v/tLYD9neh0EsFOLhyxhq18lpD8a
	 8o8MGrwkN9tVgFasTLfO/WoueHhuUQaYy/HNgYNWizHJEsPhRgDkUJsvUAk9/9k0Md
	 0C+nxCodxYQKHHTJsj+Vf5RT0sFA3Lm/g6COBYsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Hu <hshuai@redhat.com>,
	Zhenyu Zhang <zhenyzha@redhat.com>,
	Gavin Shan <gshan@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 16/96] KVM: Avoid illegal stage2 mapping on invalid memory slot
Date: Mon, 26 Jun 2023 20:11:31 +0200
Message-ID: <20230626180747.600081893@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gavin Shan <gshan@redhat.com>

commit 2230f9e1171a2e9731422a14d1bbc313c0b719d1 upstream.

We run into guest hang in edk2 firmware when KSM is kept as running on
the host. The edk2 firmware is waiting for status 0x80 from QEMU's pflash
device (TYPE_PFLASH_CFI01) during the operation of sector erasing or
buffered write. The status is returned by reading the memory region of
the pflash device and the read request should have been forwarded to QEMU
and emulated by it. Unfortunately, the read request is covered by an
illegal stage2 mapping when the guest hang issue occurs. The read request
is completed with QEMU bypassed and wrong status is fetched. The edk2
firmware runs into an infinite loop with the wrong status.

The illegal stage2 mapping is populated due to same page sharing by KSM
at (C) even the associated memory slot has been marked as invalid at (B)
when the memory slot is requested to be deleted. It's notable that the
active and inactive memory slots can't be swapped when we're in the middle
of kvm_mmu_notifier_change_pte() because kvm->mn_active_invalidate_count
is elevated, and kvm_swap_active_memslots() will busy loop until it reaches
to zero again. Besides, the swapping from the active to the inactive memory
slots is also avoided by holding &kvm->srcu in __kvm_handle_hva_range(),
corresponding to synchronize_srcu_expedited() in kvm_swap_active_memslots().

  CPU-A                    CPU-B
  -----                    -----
                           ioctl(kvm_fd, KVM_SET_USER_MEMORY_REGION)
                           kvm_vm_ioctl_set_memory_region
                           kvm_set_memory_region
                           __kvm_set_memory_region
                           kvm_set_memslot(kvm, old, NULL, KVM_MR_DELETE)
                             kvm_invalidate_memslot
                               kvm_copy_memslot
                               kvm_replace_memslot
                               kvm_swap_active_memslots        (A)
                               kvm_arch_flush_shadow_memslot   (B)
  same page sharing by KSM
  kvm_mmu_notifier_invalidate_range_start
        :
  kvm_mmu_notifier_change_pte
    kvm_handle_hva_range
    __kvm_handle_hva_range
    kvm_set_spte_gfn            (C)
        :
  kvm_mmu_notifier_invalidate_range_end

Fix the issue by skipping the invalid memory slot at (C) to avoid the
illegal stage2 mapping so that the read request for the pflash's status
is forwarded to QEMU and emulated by it. In this way, the correct pflash's
status can be returned from QEMU to break the infinite loop in the edk2
firmware.

We tried a git-bisect and the first problematic commit is cd4c71835228 ("
KVM: arm64: Convert to the gfn-based MMU notifier callbacks"). With this,
clean_dcache_guest_page() is called after the memory slots are iterated
in kvm_mmu_notifier_change_pte(). clean_dcache_guest_page() is called
before the iteration on the memory slots before this commit. This change
literally enlarges the racy window between kvm_mmu_notifier_change_pte()
and memory slot removal so that we're able to reproduce the issue in a
practical test case. However, the issue exists since commit d5d8184d35c9
("KVM: ARM: Memory virtualization setup").

Cc: stable@vger.kernel.org # v3.9+
Fixes: d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")
Reported-by: Shuai Hu <hshuai@redhat.com>
Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Message-Id: <20230615054259.14911-1-gshan@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -636,6 +636,24 @@ static __always_inline int kvm_handle_hv
 
 	return __kvm_handle_hva_range(kvm, &range);
 }
+
+static bool kvm_change_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	/*
+	 * Skipping invalid memslots is correct if and only change_pte() is
+	 * surrounded by invalidate_range_{start,end}(), which is currently
+	 * guaranteed by the primary MMU.  If that ever changes, KVM needs to
+	 * unmap the memslot instead of skipping the memslot to ensure that KVM
+	 * doesn't hold references to the old PFN.
+	 */
+	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
+
+	if (range->slot->flags & KVM_MEMSLOT_INVALID)
+		return false;
+
+	return kvm_set_spte_gfn(kvm, range);
+}
+
 static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 					struct mm_struct *mm,
 					unsigned long address,
@@ -656,7 +674,7 @@ static void kvm_mmu_notifier_change_pte(
 	if (!READ_ONCE(kvm->mmu_notifier_count))
 		return;
 
-	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
+	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_change_spte_gfn);
 }
 
 void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,


