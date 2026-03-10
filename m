Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7F933A9C6;
	Tue, 10 Mar 2026 11:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142045; cv=none; b=XiGrcAc3RakUrtm3tbEANJyz+zlaIdRnCi94/uVNgXk1C8WzFatCNlZXNB5B5thKXajv1PexkOOiC+P2Gi6iFKMt8zo+dKtc8sS+6X7wb1FUEL6iwtyZPEr0rDh8e5vYzfxqq/8OH8+VXM4JXJsCylJr2S9/UMmq8EwjR0YOYLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142045; c=relaxed/simple;
	bh=0wUyIpgi+HqG6SiYkPeewkc7BQ8OprJK4dTLDf2lNyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkCWg+DTXgaze6cN3YZuccGrkDxOSPvlx8EMKWdzHE+YzXbfMsnseYvH3xEJ5ay1H/1Xj91ToNpRQbgVS9YTl+JDQY/FtOz5dAEWzaULpG+MA2mmTZLFSpKy354FtvaiHkVT+RNgmi+KEsaE9QZ/2r5oxTsdyjw0HDMhO24dMY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LOz1ngmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LOz1ngmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C26C2BC9E;
	Tue, 10 Mar 2026 11:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142045;
	bh=0wUyIpgi+HqG6SiYkPeewkc7BQ8OprJK4dTLDf2lNyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOz1ngmrRAueDw5tEqcs16ihGpvGcRUTHgQmamv2eWMYpbbUoSR4ElX30Z4PGCqjJ
	 o2hcboDpQL7AtjqW+ocKMbSoNtfhSdtyyeyVjeqXKL8SaiqwB1f7q4NGp8IHAaNOzi
	 oi7cUGlg5ntMT0BWc5C6ZjNxpYYe9K2YfrNd40poNSKLgSi4CpRhq3TIKVLb7uWaRS
	 xHdiIhrktNpp6WcQKFfKBmoiwHBkR09iIBoknhRJ4o2W7JMGqnJFdxbVr2+lWp+wRD
	 45VJVrhh+KO2GCOBiPpFvJr8tFj0wwj8PvQk0O5IcBmyCsWhO2h0eoUXanA327npMb
	 tRVtIdepajhBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Emanuele Rocca <emanuele.rocca@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 173/314] arm64: gcs: Do not set PTE_SHARED on GCS mappings if FEAT_LPA2 is enabled
Date: Tue, 10 Mar 2026 07:17:12 -0400
Message-ID: <3a29f70d66559c592fa29b756efaf1f0689ff534.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Catalin Marinas <catalin.marinas@arm.com>

commit 8a85b3131225a8c8143ba2ae29c0eef8c1f9117f upstream.

When FEAT_LPA2 is enabled, bits 8-9 of the PTE replace the
shareability attribute with bits 50-51 of the output address. The
_PAGE_GCS{,_RO} definitions include the PTE_SHARED bits as 0b11 (this
matches the other _PAGE_* definitions) but using this macro directly
leads to the following panic when enabling GCS on a system/model with
LPA2:

  Unable to handle kernel paging request at virtual address fffff1ffc32d8008
  Mem abort info:
    ESR = 0x0000000096000004
    EC = 0x25: DABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
    FSC = 0x04: level 0 translation fault
  Data abort info:
    ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
    CM = 0, WnR = 0, TnD = 0, TagAccess = 0
    GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
  swapper pgtable: 4k pages, 52-bit VAs, pgdp=0000000060f4d000
  [fffff1ffc32d8008] pgd=100000006184b003, p4d=0000000000000000
  Internal error: Oops: 0000000096000004 [#1]  SMP
  CPU: 0 UID: 0 PID: 513 Comm: gcs_write_fault Tainted: G   M                7.0.0-rc1 #1 PREEMPT
  Tainted: [M]=MACHINE_CHECK
  Hardware name: QEMU QEMU Virtual Machine, BIOS 2025.02-8+deb13u1 11/08/2025
  pstate: 03402005 (nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
  pc : zap_huge_pmd+0x168/0x468
  lr : zap_huge_pmd+0x2c/0x468
  sp : ffff800080beb660
  x29: ffff800080beb660 x28: fff00000c2058180 x27: ffff800080beb898
  x26: fff00000c2058180 x25: ffff800080beb820 x24: 00c800010b600f41
  x23: ffffc1ffc30af1a8 x22: fff00000c2058180 x21: 0000ffff8dc00000
  x20: fff00000c2bc6370 x19: ffff800080beb898 x18: ffff800080bebb60
  x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000007
  x14: 000000000000000a x13: 0000aaaacbbbffff x12: 0000000000000000
  x11: 0000ffff8ddfffff x10: 00000000000001fe x9 : 0000ffff8ddfffff
  x8 : 0000ffff8de00000 x7 : 0000ffff8da00000 x6 : fff00000c2bc6370
  x5 : 0000ffff8da00000 x4 : 000000010b600000 x3 : ffffc1ffc0000000
  x2 : fff00000c2058180 x1 : fffff1ffc32d8000 x0 : 000000c00010b600
  Call trace:
   zap_huge_pmd+0x168/0x468 (P)
   unmap_page_range+0xd70/0x1560
   unmap_single_vma+0x48/0x80
   unmap_vmas+0x90/0x180
   unmap_region+0x88/0xe4
   vms_complete_munmap_vmas+0xf8/0x1e0
   do_vmi_align_munmap+0x158/0x180
   do_vmi_munmap+0xac/0x160
   __vm_munmap+0xb0/0x138
   vm_munmap+0x14/0x20
   gcs_free+0x70/0x80
   mm_release+0x1c/0xc8
   exit_mm_release+0x28/0x38
   do_exit+0x190/0x8ec
   do_group_exit+0x34/0x90
   get_signal+0x794/0x858
   arch_do_signal_or_restart+0x11c/0x3e0
   exit_to_user_mode_loop+0x10c/0x17c
   el0_da+0x8c/0x9c
   el0t_64_sync_handler+0xd0/0xf0
   el0t_64_sync+0x198/0x19c
  Code: aa1603e2 d34cfc00 cb813001 8b011861 (f9400420)

Similarly to how the kernel handles protection_map[], use a
gcs_page_prot variable to store the protection bits and clear PTE_SHARED
if LPA2 is enabled.

Also remove the unused PAGE_GCS{,_RO} macros.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Fixes: 6497b66ba694 ("arm64/mm: Map pages for guarded control stack")
Reported-by: Emanuele Rocca <emanuele.rocca@arm.com>
Cc: stable@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/pgtable-prot.h | 3 ---
 arch/arm64/mm/mmap.c                  | 8 ++++++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 85dceb1c66f45..a64a26aaceba4 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -164,9 +164,6 @@ static inline bool __pure lpa2_is_enabled(void)
 #define _PAGE_GCS	(_PAGE_DEFAULT | PTE_NG | PTE_UXN | PTE_WRITE | PTE_USER)
 #define _PAGE_GCS_RO	(_PAGE_DEFAULT | PTE_NG | PTE_UXN | PTE_USER)
 
-#define PAGE_GCS	__pgprot(_PAGE_GCS)
-#define PAGE_GCS_RO	__pgprot(_PAGE_GCS_RO)
-
 #define PIE_E0	( \
 	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_GCS),           PIE_GCS)  | \
 	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_GCS_RO),        PIE_R)   | \
diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 08ee177432c2f..75f343009b4b1 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -34,6 +34,8 @@ static pgprot_t protection_map[16] __ro_after_init = {
 	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= PAGE_SHARED_EXEC
 };
 
+static ptdesc_t gcs_page_prot __ro_after_init = _PAGE_GCS_RO;
+
 /*
  * You really shouldn't be using read() or write() on /dev/mem.  This might go
  * away in the future.
@@ -73,9 +75,11 @@ static int __init adjust_protection_map(void)
 		protection_map[VM_EXEC | VM_SHARED] = PAGE_EXECONLY;
 	}
 
-	if (lpa2_is_enabled())
+	if (lpa2_is_enabled()) {
 		for (int i = 0; i < ARRAY_SIZE(protection_map); i++)
 			pgprot_val(protection_map[i]) &= ~PTE_SHARED;
+		gcs_page_prot &= ~PTE_SHARED;
+	}
 
 	return 0;
 }
@@ -87,7 +91,7 @@ pgprot_t vm_get_page_prot(vm_flags_t vm_flags)
 
 	/* Short circuit GCS to avoid bloating the table. */
 	if (system_supports_gcs() && (vm_flags & VM_SHADOW_STACK)) {
-		prot = _PAGE_GCS_RO;
+		prot = gcs_page_prot;
 	} else {
 		prot = pgprot_val(protection_map[vm_flags &
 				   (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]);
-- 
2.51.0

