Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F27F6D1A9;
	Mon,  8 Apr 2024 13:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582480; cv=none; b=dxcKnMIKC7Qyr8hkbztz4Tzd5dhxQuh9qVJclhVCR8PJjdcvqdjeR7tFodCjXu8ahVjSqYH3QILsy0NPX6VRoflf/wd4QcwRdANzQ/BGptDVUxEkebb/z1FjXhaXjkaH2Kz2BAqakNc+fBngnenOtX/nDx2GFEgo0ULmv1b0VDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582480; c=relaxed/simple;
	bh=Ga9+nyPt5XarbxAiZFUPMUYRIqcz8ePVq9VgbvmljMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYbUFy6rMsLEIGIl004hLgwa/0I6GFhr7602kzBKWpEKQNJcD1FJexLHpuiBpvzW4EzJ+NHB6+WJd6L/AlnlXw7t0zpSdKgtMAmWLWjJcum0ROohdsjVJ7x3+CTkF21jmH0L8iME/H9aNPnwV2E0mMow59PjYdyT5hRwII6VkZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQQY8d+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQQY8d+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061C1C433C7;
	Mon,  8 Apr 2024 13:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582480;
	bh=Ga9+nyPt5XarbxAiZFUPMUYRIqcz8ePVq9VgbvmljMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQQY8d+7yPqauvU3CpgGsJmomt5OQwMGryJnXy0GROx5bdVs/TgSibCtgnXR48RxL
	 Ux0YkUAEft3oMAVxEQK5QZJV5RWUpugHf2k/de5KnohXbobydk/4coJ8lZGtP60Zn/
	 aI1adzqvdpwDx8sTzutuVUXfaJjFwMS3YIipBT0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Krister Johansen <kjlx@templeofstupid.com>
Subject: [PATCH 5.15 149/690] KVM: arm64: Limit stage2_apply_range() batch size to largest block
Date: Mon,  8 Apr 2024 14:50:15 +0200
Message-ID: <20240408125404.908882944@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Upton <oliver.upton@linux.dev>

commit 5994bc9e05c2f8811f233aa434e391cd2783f0f5 upstream.

Presently stage2_apply_range() works on a batch of memory addressed by a
stage 2 root table entry for the VM. Depending on the IPA limit of the
VM and PAGE_SIZE of the host, this could address a massive range of
memory. Some examples:

  4 level, 4K paging -> 512 GB batch size

  3 level, 64K paging -> 4TB batch size

Unsurprisingly, working on such a large range of memory can lead to soft
lockups. When running dirty_log_perf_test:

  ./dirty_log_perf_test -m -2 -s anonymous_thp -b 4G -v 48

  watchdog: BUG: soft lockup - CPU#0 stuck for 45s! [dirty_log_perf_:16703]
  Modules linked in: vfat fat cdc_ether usbnet mii xhci_pci xhci_hcd sha3_generic gq(O)
  CPU: 0 PID: 16703 Comm: dirty_log_perf_ Tainted: G           O       6.0.0-smp-DEV #1
  pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : dcache_clean_inval_poc+0x24/0x38
  lr : clean_dcache_guest_page+0x28/0x4c
  sp : ffff800021763990
  pmr_save: 000000e0
  x29: ffff800021763990 x28: 0000000000000005 x27: 0000000000000de0
  x26: 0000000000000001 x25: 00400830b13bc77f x24: ffffad4f91ead9c0
  x23: 0000000000000000 x22: ffff8000082ad9c8 x21: 0000fffafa7bc000
  x20: ffffad4f9066ce50 x19: 0000000000000003 x18: ffffad4f92402000
  x17: 000000000000011b x16: 000000000000011b x15: 0000000000000124
  x14: ffff07ff8301d280 x13: 0000000000000000 x12: 00000000ffffffff
  x11: 0000000000010001 x10: fffffc0000000000 x9 : ffffad4f9069e580
  x8 : 000000000000000c x7 : 0000000000000000 x6 : 000000000000003f
  x5 : ffff07ffa2076980 x4 : 0000000000000001 x3 : 000000000000003f
  x2 : 0000000000000040 x1 : ffff0830313bd000 x0 : ffff0830313bcc40
  Call trace:
   dcache_clean_inval_poc+0x24/0x38
   stage2_unmap_walker+0x138/0x1ec
   __kvm_pgtable_walk+0x130/0x1d4
   __kvm_pgtable_walk+0x170/0x1d4
   __kvm_pgtable_walk+0x170/0x1d4
   __kvm_pgtable_walk+0x170/0x1d4
   kvm_pgtable_stage2_unmap+0xc4/0xf8
   kvm_arch_flush_shadow_memslot+0xa4/0x10c
   kvm_set_memslot+0xb8/0x454
   __kvm_set_memory_region+0x194/0x244
   kvm_vm_ioctl_set_memory_region+0x58/0x7c
   kvm_vm_ioctl+0x49c/0x560
   __arm64_sys_ioctl+0x9c/0xd4
   invoke_syscall+0x4c/0x124
   el0_svc_common+0xc8/0x194
   do_el0_svc+0x38/0xc0
   el0_svc+0x2c/0xa4
   el0t_64_sync_handler+0x84/0xf0
   el0t_64_sync+0x1a0/0x1a4

Use the largest supported block mapping for the configured page size as
the batch granularity. In so doing the walker is guaranteed to visit a
leaf only once.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221007234151.461779-3-oliver.upton@linux.dev
Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/stage2_pgtable.h |   20 --------------------
 arch/arm64/kvm/mmu.c                    |    9 ++++++++-
 2 files changed, 8 insertions(+), 21 deletions(-)

--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -11,13 +11,6 @@
 #include <linux/pgtable.h>
 
 /*
- * PGDIR_SHIFT determines the size a top-level page table entry can map
- * and depends on the number of levels in the page table. Compute the
- * PGDIR_SHIFT for a given number of levels.
- */
-#define pt_levels_pgdir_shift(lvls)	ARM64_HW_PGTABLE_LEVEL_SHIFT(4 - (lvls))
-
-/*
  * The hardware supports concatenation of up to 16 tables at stage2 entry
  * level and we use the feature whenever possible, which means we resolve 4
  * additional bits of address at the entry level.
@@ -30,11 +23,6 @@
 #define stage2_pgtable_levels(ipa)	ARM64_HW_PGTABLE_LEVELS((ipa) - 4)
 #define kvm_stage2_levels(kvm)		VTCR_EL2_LVLS(kvm->arch.vtcr)
 
-/* stage2_pgdir_shift() is the size mapped by top-level stage2 entry for the VM */
-#define stage2_pgdir_shift(kvm)		pt_levels_pgdir_shift(kvm_stage2_levels(kvm))
-#define stage2_pgdir_size(kvm)		(1ULL << stage2_pgdir_shift(kvm))
-#define stage2_pgdir_mask(kvm)		~(stage2_pgdir_size(kvm) - 1)
-
 /*
  * kvm_mmmu_cache_min_pages() is the number of pages required to install
  * a stage-2 translation. We pre-allocate the entry level page table at
@@ -42,12 +30,4 @@
  */
 #define kvm_mmu_cache_min_pages(kvm)	(kvm_stage2_levels(kvm) - 1)
 
-static inline phys_addr_t
-stage2_pgd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
-{
-	phys_addr_t boundary = (addr + stage2_pgdir_size(kvm)) & stage2_pgdir_mask(kvm);
-
-	return (boundary - 1 < end - 1) ? boundary : end;
-}
-
 #endif	/* __ARM64_S2_PGTABLE_H_ */
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -31,6 +31,13 @@ static phys_addr_t hyp_idmap_vector;
 
 static unsigned long io_map_base;
 
+static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
+{
+	phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
+	phys_addr_t boundary = ALIGN_DOWN(addr + size, size);
+
+	return (boundary - 1 < end - 1) ? boundary : end;
+}
 
 /*
  * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
@@ -52,7 +59,7 @@ static int stage2_apply_range(struct kvm
 		if (!pgt)
 			return -EINVAL;
 
-		next = stage2_pgd_addr_end(kvm, addr, end);
+		next = stage2_range_addr_end(addr, end);
 		ret = fn(pgt, addr, next - addr);
 		if (ret)
 			break;


