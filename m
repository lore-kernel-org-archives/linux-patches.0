Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAD335292A;
	Tue, 16 Jun 2026 18:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633997; cv=none; b=Kc0NHR05634moBsidO9Fv0N+Bipe7Xl4CvtIpxkueqs7EzEFr7lvcN9zzKZ6SISYPK+U6UH0o7VZodOT/OW8j6jmy0RXQA6mNV37gpjzItT0Yy8IAg8dIPT+TP+1k7CKTtbzf8PLymUVACUkhWEx+NGdGsw5jJnyAT+m4Av00M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633997; c=relaxed/simple;
	bh=Wjigji+ezK1fJlkQwvZkPceFjFy2Vb6w2C5in7iN5IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8U0yqt+yLQJV5ZsFJDfvSrDW6TY9/bglb0B6n/NYC/6s64aW0iGAQKl2qo8K9ww9F9Io44ZfNHlweaagv03K6u5mzQgpCQXMVU/a+emQoXfQlDchcxJrOquP31ch3dOsSHEoOlDd15gQYiKFmh3O6vhvZ5E/TiEU8TaGbv7tcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXiYKOsZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXiYKOsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEF91F000E9;
	Tue, 16 Jun 2026 18:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633996;
	bh=LkBEKS8Gk8kJDRCGW+B+hhKhOCMd+GjJA13nq5EpGG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXiYKOsZjJGYSmo9I2BCERjMbAImeGzL5mLuAf6g4+bAx48FC2AximrOxKvUiFKQy
	 XSomuChHL1byjhZjFhkJIx8i4lRl2NlHLG6sC1f1NaJ25MMtXDW6izgqMHxzq4N6c3
	 vakhGDlMbzNwRt2Eb27YeaZKs5pAtFQRptovKNOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/411] arm64: tlb: Optimize ARM64_WORKAROUND_REPEAT_TLBI
Date: Tue, 16 Jun 2026 20:26:59 +0530
Message-ID: <20260616145110.312121918@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

commit a8f78680ee6bf795086384e8aea159a52814f827 upstream.

The ARM64_WORKAROUND_REPEAT_TLBI workaround is used to mitigate several
errata where broadcast TLBI;DSB sequences don't provide all the
architecturally required synchronization. The workaround performs more
work than necessary, and can have significant overhead. This patch
optimizes the workaround, as explained below.

The workaround was originally added for Qualcomm Falkor erratum 1009 in
commit:

  d9ff80f83ecb ("arm64: Work around Falkor erratum 1009")

As noted in the message for that commit, the workaround is applied even
in cases where it is not strictly necessary.

The workaround was later reused without changes for:

* Arm Cortex-A76 erratum #1286807
  SDEN v33: https://developer.arm.com/documentation/SDEN-885749/33-0/

* Arm Cortex-A55 erratum #2441007
  SDEN v16: https://developer.arm.com/documentation/SDEN-859338/1600/

* Arm Cortex-A510 erratum #2441009
  SDEN v19: https://developer.arm.com/documentation/SDEN-1873351/1900/

The important details to note are as follows:

1. All relevant errata only affect the ordering and/or completion of
   memory accesses which have been translated by an invalidated TLB
   entry. The actual invalidation of TLB entries is unaffected.

2. The existing workaround is applied to both broadcast and local TLB
   invalidation, whereas for all relevant errata it is only necessary to
   apply a workaround for broadcast invalidation.

3. The existing workaround replaces every TLBI with a TLBI;DSB;TLBI
   sequence, whereas for all relevant errata it is only necessary to
   execute a single additional TLBI;DSB sequence after any number of
   TLBIs are completed by a DSB.

   For example, for a sequence of batched TLBIs:

       TLBI <op1>[, <arg1>]
       TLBI <op2>[, <arg2>]
       TLBI <op3>[, <arg3>]
       DSB ISH

   ... the existing workaround will expand this to:

       TLBI <op1>[, <arg1>]
       DSB ISH                  // additional
       TLBI <op1>[, <arg1>]     // additional
       TLBI <op2>[, <arg2>]
       DSB ISH                  // additional
       TLBI <op2>[, <arg2>]     // additional
       TLBI <op3>[, <arg3>]
       DSB ISH                  // additional
       TLBI <op3>[, <arg3>]     // additional
       DSB ISH

   ... whereas it is sufficient to have:

       TLBI <op1>[, <arg1>]
       TLBI <op2>[, <arg2>]
       TLBI <op3>[, <arg3>]
       DSB ISH
       TLBI <opX>[, <argX>]     // additional
       DSB ISH                  // additional

   Using a single additional TBLI and DSB at the end of the sequence can
   have significantly lower overhead as each DSB which completes a TLBI
   must synchronize with other PEs in the system, with potential
   performance effects both locally and system-wide.

4. The existing workaround repeats each specific TLBI operation, whereas
   for all relevant errata it is sufficient for the additional TLBI to
   use *any* operation which will be broadcast, regardless of which
   translation regime or stage of translation the operation applies to.

   For example, for a single TLBI:

       TLBI ALLE2IS
       DSB ISH

   ... the existing workaround will expand this to:

       TLBI ALLE2IS
       DSB ISH
       TLBI ALLE2IS             // additional
       DSB ISH                  // additional

   ... whereas it is sufficient to have:

       TLBI ALLE2IS
       DSB ISH
       TLBI VALE1IS, XZR        // additional
       DSB ISH                  // additional

   As the additional TLBI doesn't have to match a specific earlier TLBI,
   the additional TLBI can be implemented in separate code, with no
   memory of the earlier TLBIs. The additional TLBI can also use a
   cheaper TLBI operation.

5. The existing workaround is applied to both Stage-1 and Stage-2 TLB
   invalidation, whereas for all relevant errata it is only necessary to
   apply a workaround for Stage-1 invalidation.

   Architecturally, TLBI operations which invalidate only Stage-2
   information (e.g. IPAS2E1IS) are not required to invalidate TLB
   entries which combine information from Stage-1 and Stage-2
   translation table entries, and consequently may not complete memory
   accesses translated by those combined entries. In these cases,
   completion of memory accesses is only guaranteed after subsequent
   invalidation of Stage-1 information (e.g. VMALLE1IS).

Taking the above points into account, this patch reworks the workaround
logic to reduce overhead:

* New __tlbi_sync_s1ish() and __tlbi_sync_s1ish_hyp() functions are
  added and used in place of any dsb(ish) which is used to complete
  broadcast Stage-1 TLB maintenance. When the
  ARM64_WORKAROUND_REPEAT_TLBI workaround is enabled, these helpers will
  execute an additional TLBI;DSB sequence.

  For consistency, it might make sense to add __tlbi_sync_*() helpers
  for local and stage 2 maintenance. For now I've left those with
  open-coded dsb() to keep the diff small.

* The duplication of TLBIs in __TLBI_0() and __TLBI_1() is removed. This
  is no longer needed as the necessary synchronization will happen in
  __tlbi_sync_s1ish() or __tlbi_sync_s1ish_hyp().

* The additional TLBI operation is chosen to have minimal impact:

  - __tlbi_sync_s1ish() uses "TLBI VALE1IS, XZR". This is only used at
    EL1 or at EL2 with {E2H,TGE}=={1,1}, where it will target an unused
    entry for the reserved ASID in the kernel's own translation regime,
    and have no adverse affect.

  - __tlbi_sync_s1ish_hyp() uses "TLBI VALE2IS, XZR". This is only used
    in hyp code, where it will target an unused entry in the hyp code's
    TTBR0 mapping, and should have no adverse effect.

* As __TLBI_0() and __TLBI_1() no longer replace each TLBI with a
  TLBI;DSB;TLBI sequence, batching TLBIs is worthwhile, and there's no
  need for arch_tlbbatch_should_defer() to consider
  ARM64_WORKAROUND_REPEAT_TLBI.

When building defconfig with GCC 15.1.0, compared to v6.19-rc1, this
patch saves ~1KiB of text, makes the vmlinux ~42KiB smaller, and makes
the resulting Image 64KiB smaller:

| [mark@lakrids:~/src/linux]% size vmlinux-*
|    text    data     bss     dec     hex filename
| 21179831        19660919         708216 41548966        279fca6 vmlinux-after
| 21181075        19660903         708216 41550194        27a0172 vmlinux-before
| [mark@lakrids:~/src/linux]% ls -l vmlinux-*
| -rwxr-xr-x 1 mark mark 157771472 Feb  4 12:05 vmlinux-after
| -rwxr-xr-x 1 mark mark 157815432 Feb  4 12:05 vmlinux-before
| [mark@lakrids:~/src/linux]% ls -l Image-*
| -rw-r--r-- 1 mark mark 41007616 Feb  4 12:05 Image-after
| -rw-r--r-- 1 mark mark 41073152 Feb  4 12:05 Image-before

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Mark: Backport to v5.15.y; use inline ALTERNATIVE() sequence]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/tlbflush.h | 51 ++++++++++++++++++++++---------
 arch/arm64/kernel/sys_compat.c    |  2 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c     |  6 ++--
 arch/arm64/kvm/hyp/vhe/tlb.c      |  6 ++--
 4 files changed, 44 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 2626a45849c241..cc6e47172f8fa7 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -30,18 +30,10 @@
  */
 #define __TLBI_0(op, arg) asm (ARM64_ASM_PREAMBLE			       \
 			       "tlbi " #op "\n"				       \
-		   ALTERNATIVE("nop\n			nop",		       \
-			       "dsb ish\n		tlbi " #op,	       \
-			       ARM64_WORKAROUND_REPEAT_TLBI,		       \
-			       CONFIG_ARM64_WORKAROUND_REPEAT_TLBI)	       \
 			    : : )
 
 #define __TLBI_1(op, arg) asm (ARM64_ASM_PREAMBLE			       \
 			       "tlbi " #op ", %x0\n"			       \
-		   ALTERNATIVE("nop\n			nop",		       \
-			       "dsb ish\n		tlbi " #op ", %x0",    \
-			       ARM64_WORKAROUND_REPEAT_TLBI,		       \
-			       CONFIG_ARM64_WORKAROUND_REPEAT_TLBI)	       \
 			    : : "rZ" (arg))
 
 #define __TLBI_N(op, arg, n, ...) __TLBI_##n(op, arg)
@@ -158,6 +150,37 @@ static inline unsigned long get_trans_granule(void)
 #define __TLBI_RANGE_NUM(pages, scale)	\
 	((((pages) >> (5 * (scale) + 1)) & TLBI_RANGE_MASK) - 1)
 
+#define __repeat_tlbi_sync(op, arg)						\
+do {										\
+	asm volatile(								\
+	ALTERNATIVE("nop\n			nop",				\
+		    "tlbi " #op ", %x0\n	dsb ish",			\
+		    ARM64_WORKAROUND_REPEAT_TLBI,				\
+		    CONFIG_ARM64_WORKAROUND_REPEAT_TLBI)			\
+	:									\
+	: "rZ" (arg));								\
+} while (0)
+
+/*
+ * Complete broadcast TLB maintenance issued by the host which invalidates
+ * stage 1 information in the host's own translation regime.
+ */
+static inline void __tlbi_sync_s1ish(void)
+{
+	dsb(ish);
+	__repeat_tlbi_sync(vale1is, 0);
+}
+
+/*
+ * Complete broadcast TLB maintenance issued by hyp code which invalidates
+ * stage 1 translation information in any translation regime.
+ */
+static inline void __tlbi_sync_s1ish_hyp(void)
+{
+	dsb(ish);
+	__repeat_tlbi_sync(vale2is, 0);
+}
+
 /*
  *	TLB Invalidation
  *	================
@@ -239,7 +262,7 @@ static inline void flush_tlb_all(void)
 {
 	dsb(ishst);
 	__tlbi(vmalle1is);
-	dsb(ish);
+	__tlbi_sync_s1ish();
 	isb();
 }
 
@@ -251,7 +274,7 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
 	asid = __TLBI_VADDR(0, ASID(mm));
 	__tlbi(aside1is, asid);
 	__tlbi_user(aside1is, asid);
-	dsb(ish);
+	__tlbi_sync_s1ish();
 }
 
 static inline void flush_tlb_page_nosync(struct vm_area_struct *vma,
@@ -269,7 +292,7 @@ static inline void flush_tlb_page(struct vm_area_struct *vma,
 				  unsigned long uaddr)
 {
 	flush_tlb_page_nosync(vma, uaddr);
-	dsb(ish);
+	__tlbi_sync_s1ish();
 }
 
 /*
@@ -357,7 +380,7 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 		}
 		scale++;
 	}
-	dsb(ish);
+	__tlbi_sync_s1ish();
 }
 
 static inline void flush_tlb_range(struct vm_area_struct *vma,
@@ -386,7 +409,7 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
 	dsb(ishst);
 	for (addr = start; addr < end; addr += 1 << (PAGE_SHIFT - 12))
 		__tlbi(vaale1is, addr);
-	dsb(ish);
+	__tlbi_sync_s1ish();
 	isb();
 }
 
@@ -400,7 +423,7 @@ static inline void __flush_tlb_kernel_pgtable(unsigned long kaddr)
 
 	dsb(ishst);
 	__tlbi(vaae1is, addr);
-	dsb(ish);
+	__tlbi_sync_s1ish();
 	isb();
 }
 #endif
diff --git a/arch/arm64/kernel/sys_compat.c b/arch/arm64/kernel/sys_compat.c
index b88a52f7188fcc..416195f376816b 100644
--- a/arch/arm64/kernel/sys_compat.c
+++ b/arch/arm64/kernel/sys_compat.c
@@ -38,7 +38,7 @@ __do_compat_cache_op(unsigned long start, unsigned long end)
 			 * We pick the reserved-ASID to minimise the impact.
 			 */
 			__tlbi(aside1is, __TLBI_VADDR(0, 0));
-			dsb(ish);
+			__tlbi_sync_s1ish();
 		}
 
 		ret = caches_clean_inval_user_pou(start, start + chunk);
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index 291789df24e3ee..76973e3b48a076 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -81,7 +81,7 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	 */
 	dsb(ish);
 	__tlbi(vmalle1is);
-	dsb(ish);
+	__tlbi_sync_s1ish_hyp();
 	isb();
 
 	__tlb_switch_to_host(&cxt);
@@ -97,7 +97,7 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 	__tlb_switch_to_guest(mmu, &cxt);
 
 	__tlbi(vmalls12e1is);
-	dsb(ish);
+	__tlbi_sync_s1ish_hyp();
 	isb();
 
 	__tlb_switch_to_host(&cxt);
@@ -122,5 +122,5 @@ void __kvm_flush_vm_context(void)
 {
 	dsb(ishst);
 	__tlbi(alle1is);
-	dsb(ish);
+	__tlbi_sync_s1ish_hyp();
 }
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index fc3fcd29ccc306..59aa22b48e9538 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -105,7 +105,7 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	 */
 	dsb(ish);
 	__tlbi(vmalle1is);
-	dsb(ish);
+	__tlbi_sync_s1ish_hyp();
 	isb();
 
 	__tlb_switch_to_host(&cxt);
@@ -121,7 +121,7 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 	__tlb_switch_to_guest(mmu, &cxt);
 
 	__tlbi(vmalls12e1is);
-	dsb(ish);
+	__tlbi_sync_s1ish_hyp();
 	isb();
 
 	__tlb_switch_to_host(&cxt);
@@ -146,5 +146,5 @@ void __kvm_flush_vm_context(void)
 {
 	dsb(ishst);
 	__tlbi(alle1is);
-	dsb(ish);
+	__tlbi_sync_s1ish_hyp();
 }
-- 
2.53.0



