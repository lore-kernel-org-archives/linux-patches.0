Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73A61B6D1A;
	Wed, 11 Feb 2026 12:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813127; cv=none; b=HsGc4G04arwJuuPdxUVtYQ52ifWrHwn7n8jX94OJf/PnhZzep/YtHbou4wuOhQAGPNfzBCriacg1kaI/xSK9YtH0wCOt1FNasvkSfM0LOjrgDmi6rL4ku74G0briq008yr1rAmjwmly6ukHxW/GaHpSOM4m4PF3Beeuc+5UiWhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813127; c=relaxed/simple;
	bh=B/N3j3h/oryfYUmFNxVfoPmzaZaxlJmTwjGuH87ezzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iRyG3zBm0vuumwuRDWv5pmNIvRNEHToOMS+7Ne8i0U+IIiS5Sq7c4VAz6PXqhDvqUxBGKM3cr66h1QYstWpxI4y6B+CY/6X/k/e3445JQ7Om1AMlPyyfPTEIY7jTkwKnaIMB2UO1Vu+nEGA3V4DwTpOSpX/UlguGZLmigNT3004=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UbJrNpFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UbJrNpFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC3BC4CEF7;
	Wed, 11 Feb 2026 12:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813127;
	bh=B/N3j3h/oryfYUmFNxVfoPmzaZaxlJmTwjGuH87ezzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbJrNpFfjDTUzQwcYNI9sc5p8LL9QTbjEAyB4qMiv9adpTSpdwVVzh00oPVZGVcca
	 FFiqvJWKA0b/Xtw7im9yLAOJRIZ089wI3IgsC1rt9DmmHt/P0Ds0uXU1xvVitl67tw
	 3V21YBLajbYZltKPzQAUP6W4tH3DhjbaruU0lHWourhuQ+hEE28EBWXKUj5IC0j8Dl
	 9Ln0KjKQGNnn6n37uJ8sIHRNZP7SM59C8fL3pM4lJ1ntcrwAdLPegmeqzczxBERPDL
	 +xCnZuG8iM0sypNMPxsG3vlPHg1RvgojkmmObC7iNpiQ/DWZ89PG0AIUld9CtnviKZ
	 G4kb0M95MzLKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Magnus Lindholm <linmag7@gmail.com>,
	Ivan Kokshaysky <ink@unseen.parts>,
	Matoro Mahri <matoro_mailinglist_kernel@matoro.tk>,
	Michael Cree <mcree@orcon.net.nz>,
	Sasha Levin <sashal@kernel.org>,
	viro@zeniv.linux.org.uk,
	geert@linux-m68k.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	willy@infradead.org
Subject: [PATCH AUTOSEL 6.19-6.12] alpha: fix user-space corruption during memory compaction
Date: Wed, 11 Feb 2026 07:30:35 -0500
Message-ID: <20260211123112.1330287-25-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211123112.1330287-1-sashal@kernel.org>
References: <20260211123112.1330287-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit dd5712f3379cfe760267cdd28ff957d9ab4e51c7 ]

Alpha systems can suffer sporadic user-space crashes and heap
corruption when memory compaction is enabled.

Symptoms include SIGSEGV, glibc allocator failures (e.g. "unaligned
tcache chunk"), and compiler internal errors. The failures disappear
when compaction is disabled or when using global TLB invalidation.

The root cause is insufficient TLB shootdown during page migration.
Alpha relies on ASN-based MM context rollover for instruction cache
coherency, but this alone is not sufficient to prevent stale data or
instruction translations from surviving migration.

Fix this by introducing a migration-specific helper that combines:
  - MM context invalidation (ASN rollover),
  - immediate per-CPU TLB invalidation (TBI),
  - synchronous cross-CPU shootdown when required.

The helper is used only by migration/compaction paths to avoid changing
global TLB semantics.

Additionally, update flush_tlb_other(), pte_clear(), to use
READ_ONCE()/WRITE_ONCE() for correct SMP memory ordering.

This fixes observed crashes on both UP and SMP Alpha systems.

Reviewed-by: Ivan Kokshaysky <ink@unseen.parts>
Tested-by: Matoro Mahri <matoro_mailinglist_kernel@matoro.tk>
Tested-by: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20260102173603.18247-2-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Complete Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit is titled **"alpha: fix user-space corruption during memory
compaction"**. Key facts from the message:

- **Concrete symptoms**: SIGSEGV, glibc allocator failures ("unaligned
  tcache chunk"), compiler internal errors on Alpha systems
- **Reproducibility**: Failures disappear when compaction is disabled or
  when using global TLB invalidation (confirming the diagnosis)
- **Root cause clearly identified**: Insufficient TLB shootdown during
  page migration. Alpha's ASN-based MM context rollover alone doesn't
  prevent stale data/instruction translations from surviving migration
- **Review/Test tags**: Reviewed-by: Ivan Kokshaysky (Alpha subsystem
  expert), Tested-by: Matoro Mahri and Michael Cree (both active Alpha
  testers/maintainers)

### 2. CODE CHANGE ANALYSIS

The patch makes changes across 4 files:

#### a) `arch/alpha/mm/tlbflush.c` (new file, 112 lines)

This is the core of the fix. It introduces `migrate_flush_tlb_page()`
with separate UP and SMP implementations:

**UP version** (lines 30-55):
- Performs MM context handling first: if current MM, calls
  `flush_tlb_current(mm)` (full ASN reload); otherwise
  `flush_tlb_other(mm)` (context zeroing)
- Then performs an immediate per-VA TBI: `tbi(tbi_type, addr)` where
  `tbi_type=3` for VM_EXEC pages (invalidates both ITB+DTB) and
  `tbi_type=2` for data-only pages

**SMP version** (lines 57-108):
- Defines `ipi_flush_mm_and_page()` that runs on each CPU, combining:
  (1) ASN reload (`__load_new_mm_context`) or context zeroing
  (`flush_tlb_other`), and (2) immediate per-VA `tbi()` invalidation
- Uses `on_each_cpu()` for synchronous cross-CPU execution
- Includes the same `mm_users <= 1` optimization as existing
  `flush_tlb_mm`/`flush_tlb_page`

**Why the existing code was broken**: The generic `ptep_clear_flush`
calls `ptep_get_and_clear` then `flush_tlb_page`. On Alpha:
- For non-exec pages: `flush_tlb_current_page` →
  `ev5_flush_tlb_current_page` → just `tbi(2, addr)` (data TLB only). No
  ASN rollover.
- For exec pages: `flush_tlb_current_page` → `__load_new_mm_context(mm)`
  (ASN rollover only, no per-page TBI).
- Neither case combines both operations. During migration, the
  **combination** is required because: the physical page moves, so ALL
  old translations (data AND instruction) to the old physical address
  must be completely eliminated. A stale DTB entry could cause reads
  from the old (now recycled) physical page. A stale ITB entry on an
  exec mapping could execute old instructions from the wrong physical
  page.

The new `migrate_flush_tlb_page` does **both** ASN context invalidation
AND immediate per-VA TBI, closing the race window.

#### b) `arch/alpha/include/asm/pgtable.h` (additions)

- Adds `#include <linux/page_table_check.h>` (needed for the
  `page_table_check_pte_clear()` call)
- Declares `migrate_flush_tlb_page()` prototype
- Defines `__HAVE_ARCH_PTEP_GET_AND_CLEAR` and `ptep_get_and_clear()`
  using `READ_ONCE()` for proper SMP ordering
- Defines `__HAVE_ARCH_PTEP_CLEAR_FLUSH` and `ptep_clear_flush()` that
  calls `page_table_check_pte_clear()` and then
  `migrate_flush_tlb_page()`
- Both are guarded by `#ifdef CONFIG_COMPACTION`, so they only take
  effect when compaction is enabled

The `pte_clear()` function is changed from `pte_val(*ptep) = 0` to
`WRITE_ONCE(pte_val(*ptep), 0)` to ensure proper SMP memory ordering.

#### c) `arch/alpha/include/asm/tlbflush.h` (minor change)

`flush_tlb_other()` is changed to use `READ_ONCE()`/`WRITE_ONCE()`
instead of plain accesses to `mm->context[cpu]`. This fixes a data race
on SMP where multiple CPUs might read/write the context concurrently.

#### d) `arch/alpha/mm/Makefile` (1 line)

Adds `tlbflush.o` to the build.

### 3. CLASSIFICATION

This is a **critical bug fix** for user-space data corruption. It fits
squarely in the "data corruption" and "system crash" categories:
- Users see SIGSEGV (crashes)
- Users see heap corruption (data corruption)
- Users see compiler ICEs (which are process crashes due to corrupted
  memory)

### 4. SCOPE AND RISK ASSESSMENT

- **Files changed**: 4 (all within `arch/alpha/`)
- **Lines added**: ~150 (mostly the new tlbflush.c)
- **Lines changed**: ~5 (WRITE_ONCE/READ_ONCE updates)
- **Subsystem**: Alpha architecture only - zero impact on any other
  architecture
- **Conditional**: The `ptep_clear_flush`/`ptep_get_and_clear` overrides
  are only active when `CONFIG_COMPACTION` is enabled
- **Risk**: LOW. Changes are entirely within `arch/alpha/`, so there's
  zero chance of regression on any other architecture. The new
  `migrate_flush_tlb_page` follows the exact same patterns as the
  existing `flush_tlb_page` and `flush_tlb_mm` SMP implementations in
  `smp.c`, just combining both operations.

### 5. USER IMPACT

Alpha is a niche architecture, but it has active users (proven by
multiple Tested-by tags). Users running Alpha with memory compaction
enabled (which is the default in many configs) experience:
- Random SIGSEGV in user space
- glibc heap corruption ("unaligned tcache chunk")
- GCC internal compiler errors
- Effectively, the system is unreliable for any workload

These are severe symptoms that prevent normal use of the system.

### 6. STABILITY INDICATORS

- **Reviewed-by: Ivan Kokshaysky** - this is a recognized Alpha
  architecture expert
- **Tested-by: Matoro Mahri** and **Tested-by: Michael Cree** - both are
  active Alpha testers in the Linux kernel community
- The fix follows established patterns from the existing SMP code in
  `smp.c`
- The `#ifdef CONFIG_COMPACTION` guard limits the scope of the change

### 7. DEPENDENCY CHECK

The main dependency is `#include <linux/page_table_check.h>` which was
introduced in v5.17. For stable trees older than v5.17, this include
would need adjustment. However, for modern stable trees (6.1.y, 6.6.y,
6.12.y), this header exists.

The code also uses `on_each_cpu()`, `READ_ONCE()`/`WRITE_ONCE()`, and
`page_table_check_pte_clear()` - all of which exist in current stable
trees.

The patch does create a new file (`tlbflush.c`), which slightly
increases complexity for backporting but is not a blocking issue. The
change is self-contained.

### 8. SUMMARY

**Pros for backporting:**
- Fixes real, user-visible data corruption (SIGSEGV, heap corruption)
- Confirmed by multiple testers on real Alpha hardware
- Reviewed by Alpha architecture expert
- Changes are entirely arch-specific (alpha only) - zero regression risk
  for other architectures
- Root cause is clearly understood and well-explained
- Fix follows established patterns from existing Alpha SMP code
- Guarded by `#ifdef CONFIG_COMPACTION` to minimize blast radius
- The READ_ONCE/WRITE_ONCE additions also fix data races

**Cons/Concerns:**
- Creates a new file (slightly more complex backport)
- Moderate size (~150 new lines) but all concentrated in one subsystem
- Alpha is a niche architecture (fewer users affected, but those who are
  affected are severely impacted)
- Depends on `page_table_check.h` (available since v5.17)

The fix addresses a critical data corruption bug that makes Alpha
systems unreliable when memory compaction is enabled. The changes are
self-contained, architecture-specific, well-reviewed, and well-tested.
Despite creating a new file, the code is straightforward and follows
established patterns. The risk of regression is minimal since the
changes only affect Alpha.

**YES**

 arch/alpha/include/asm/pgtable.h  |  33 ++++++++-
 arch/alpha/include/asm/tlbflush.h |   4 +-
 arch/alpha/mm/Makefile            |   2 +-
 arch/alpha/mm/tlbflush.c          | 112 ++++++++++++++++++++++++++++++
 4 files changed, 148 insertions(+), 3 deletions(-)
 create mode 100644 arch/alpha/mm/tlbflush.c

diff --git a/arch/alpha/include/asm/pgtable.h b/arch/alpha/include/asm/pgtable.h
index 90e7a95391022..c9508ec37efc4 100644
--- a/arch/alpha/include/asm/pgtable.h
+++ b/arch/alpha/include/asm/pgtable.h
@@ -17,6 +17,7 @@
 #include <asm/processor.h>	/* For TASK_SIZE */
 #include <asm/machvec.h>
 #include <asm/setup.h>
+#include <linux/page_table_check.h>
 
 struct mm_struct;
 struct vm_area_struct;
@@ -183,6 +184,9 @@ extern inline void pud_set(pud_t * pudp, pmd_t * pmdp)
 { pud_val(*pudp) = _PAGE_TABLE | ((((unsigned long) pmdp) - PAGE_OFFSET) << (32-PAGE_SHIFT)); }
 
 
+extern void migrate_flush_tlb_page(struct vm_area_struct *vma,
+					unsigned long addr);
+
 extern inline unsigned long
 pmd_page_vaddr(pmd_t pmd)
 {
@@ -202,7 +206,7 @@ extern inline int pte_none(pte_t pte)		{ return !pte_val(pte); }
 extern inline int pte_present(pte_t pte)	{ return pte_val(pte) & _PAGE_VALID; }
 extern inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	pte_val(*ptep) = 0;
+	WRITE_ONCE(pte_val(*ptep), 0);
 }
 
 extern inline int pmd_none(pmd_t pmd)		{ return !pmd_val(pmd); }
@@ -264,6 +268,33 @@ extern inline pte_t * pte_offset_kernel(pmd_t * dir, unsigned long address)
 
 extern pgd_t swapper_pg_dir[1024];
 
+#ifdef CONFIG_COMPACTION
+#define __HAVE_ARCH_PTEP_GET_AND_CLEAR
+
+static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
+					unsigned long address,
+					pte_t *ptep)
+{
+	pte_t pte = READ_ONCE(*ptep);
+
+	pte_clear(mm, address, ptep);
+	return pte;
+}
+
+#define __HAVE_ARCH_PTEP_CLEAR_FLUSH
+
+static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
+				unsigned long addr, pte_t *ptep)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	pte_t pte = ptep_get_and_clear(mm, addr, ptep);
+
+	page_table_check_pte_clear(mm, pte);
+	migrate_flush_tlb_page(vma, addr);
+	return pte;
+}
+
+#endif
 /*
  * The Alpha doesn't have any external MMU info:  the kernel page
  * tables contain all the necessary information.
diff --git a/arch/alpha/include/asm/tlbflush.h b/arch/alpha/include/asm/tlbflush.h
index ba4b359d6c395..0c8529997f54e 100644
--- a/arch/alpha/include/asm/tlbflush.h
+++ b/arch/alpha/include/asm/tlbflush.h
@@ -58,7 +58,9 @@ flush_tlb_other(struct mm_struct *mm)
 	unsigned long *mmc = &mm->context[smp_processor_id()];
 	/* Check it's not zero first to avoid cacheline ping pong
 	   when possible.  */
-	if (*mmc) *mmc = 0;
+
+	if (READ_ONCE(*mmc))
+		WRITE_ONCE(*mmc, 0);
 }
 
 #ifndef CONFIG_SMP
diff --git a/arch/alpha/mm/Makefile b/arch/alpha/mm/Makefile
index 101dbd06b4ceb..2d05664058f64 100644
--- a/arch/alpha/mm/Makefile
+++ b/arch/alpha/mm/Makefile
@@ -3,4 +3,4 @@
 # Makefile for the linux alpha-specific parts of the memory manager.
 #
 
-obj-y	:= init.o fault.o
+obj-y	:= init.o fault.o tlbflush.o
diff --git a/arch/alpha/mm/tlbflush.c b/arch/alpha/mm/tlbflush.c
new file mode 100644
index 0000000000000..ccbc317b9a348
--- /dev/null
+++ b/arch/alpha/mm/tlbflush.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Alpha TLB shootdown helpers
+ *
+ * Copyright (C) 2025 Magnus Lindholm <linmag7@gmail.com>
+ *
+ * Alpha-specific TLB flush helpers that cannot be expressed purely
+ * as inline functions.
+ *
+ * These helpers provide combined MM context handling (ASN rollover)
+ * and immediate TLB invalidation for page migration and memory
+ * compaction paths, where lazy shootdowns are insufficient.
+ */
+
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/sched.h>
+#include <asm/tlbflush.h>
+#include <asm/pal.h>
+#include <asm/mmu_context.h>
+
+#define asn_locked() (cpu_data[smp_processor_id()].asn_lock)
+
+/*
+ * Migration/compaction helper: combine mm context (ASN) handling with an
+ * immediate per-page TLB invalidate and (for exec) an instruction barrier.
+ *
+ * This mirrors the SMP combined IPI handler semantics, but runs locally on UP.
+ */
+#ifndef CONFIG_SMP
+void migrate_flush_tlb_page(struct vm_area_struct *vma,
+					   unsigned long addr)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	int tbi_type = (vma->vm_flags & VM_EXEC) ? 3 : 2;
+
+	/*
+	 * First do the mm-context side:
+	 * If we're currently running this mm, reload a fresh context ASN.
+	 * Otherwise, mark context invalid.
+	 *
+	 * On UP, this is mostly about matching the SMP semantics and ensuring
+	 * exec/i-cache tagging assumptions hold when compaction migrates pages.
+	 */
+	if (mm == current->active_mm)
+		flush_tlb_current(mm);
+	else
+		flush_tlb_other(mm);
+
+	/*
+	 * Then do the immediate translation kill for this VA.
+	 * For exec mappings, order instruction fetch after invalidation.
+	 */
+	tbi(tbi_type, addr);
+}
+
+#else
+struct tlb_mm_and_addr {
+	struct mm_struct *mm;
+	unsigned long addr;
+	int tbi_type;	/* 2 = DTB, 3 = ITB+DTB */
+};
+
+static void ipi_flush_mm_and_page(void *x)
+{
+	struct tlb_mm_and_addr *d = x;
+
+	/* Part 1: mm context side (Alpha uses ASN/context as a key mechanism). */
+	if (d->mm == current->active_mm && !asn_locked())
+		__load_new_mm_context(d->mm);
+	else
+		flush_tlb_other(d->mm);
+
+	/* Part 2: immediate per-VA invalidation on this CPU. */
+	tbi(d->tbi_type, d->addr);
+}
+
+void migrate_flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct tlb_mm_and_addr d = {
+		.mm = mm,
+		.addr = addr,
+		.tbi_type = (vma->vm_flags & VM_EXEC) ? 3 : 2,
+	};
+
+	/*
+	 * One synchronous rendezvous: every CPU runs ipi_flush_mm_and_page().
+	 * This is the "combined" version of flush_tlb_mm + per-page invalidate.
+	 */
+	preempt_disable();
+	on_each_cpu(ipi_flush_mm_and_page, &d, 1);
+
+	/*
+	 * mimic flush_tlb_mm()'s mm_users<=1 optimization.
+	 */
+	if (atomic_read(&mm->mm_users) <= 1) {
+
+		int cpu, this_cpu;
+		this_cpu = smp_processor_id();
+
+		for (cpu = 0; cpu < NR_CPUS; cpu++) {
+			if (!cpu_online(cpu) || cpu == this_cpu)
+				continue;
+			if (READ_ONCE(mm->context[cpu]))
+				WRITE_ONCE(mm->context[cpu], 0);
+		}
+	}
+	preempt_enable();
+}
+
+#endif
-- 
2.51.0

