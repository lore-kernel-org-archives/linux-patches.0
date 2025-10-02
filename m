Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224D91D554;
	Thu,  2 Oct 2025 15:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759419033; cv=none; b=OxZN4MJvSm9X9aJai99BgOgu0bFwBB41FdLUHDo6MoBY9Jkwa7TSEy8GQniGvMs19i0jy1zuy23Fgm8WZWrJMjO2xm3YJLTAbu4CGM/KzJokemhlxbsPgvujI6uV012f6zg/mmrdqvg9oignxW4jqrrrP3I1RJ9nOJFXFN166Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759419033; c=relaxed/simple;
	bh=upnWHDZ9XEAQMJ+CB6M8ILyapcszeOIyzGUsytDgMPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dH1PnLiW9Y9ZZx50Cg2E6vJQ0aOBus6IIgY6/U/fMoIOqgAV4ts0KpRzWVT4Uz/lN5ZWQsdE4OUhboOhMCEDerk74HUJ39wJ1SymOwlHOsRxtJZlCbckXi72OXDS8mSlqI1gAw1VEqHdgNB/NO+B3Z12foVRap2IRzLG8mgTXXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=csfYMDHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="csfYMDHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B159FC4CEFB;
	Thu,  2 Oct 2025 15:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759419032;
	bh=upnWHDZ9XEAQMJ+CB6M8ILyapcszeOIyzGUsytDgMPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csfYMDHCXD0tVBWnddPJ4VHz9z7LTpqAAVGGfSz5F1jMGt3C3r1difwwirwqax4Wy
	 rvRTXSSHSVoU8ma8Wt4XNPJ4Y56XMghWgk8mTa8yYNLByXw9gS1iOCVBE5lGG1bcww
	 kVckZCOf7Pldo6J2q0m9MVtONAr4N+dvdiW1DdRx0LLhELfs1B+Poj9+vvDT2HbvmX
	 qmHfZ05RJCBLzFKgEQDheFf0fCrW8+uj9VXw3wsrxhagXdHknQvQ/DsbSm4CFzzqaF
	 q5+gBbN8YGXLSZpXqgbzJYDu14/LLHLCT5gDMiFPy/jN1gN3NJngFYUZnJMK3D3OYO
	 2vwnrMLg4RSzA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	Erhard Furtner <erhard_f@mailbox.org>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-6.1] powerpc/32: Remove PAGE_KERNEL_TEXT to fix startup failure
Date: Thu,  2 Oct 2025 11:29:52 -0400
Message-ID: <20251002153025.2209281-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002153025.2209281-1-sashal@kernel.org>
References: <20251002153025.2209281-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 9316512b717f6f25c4649b3fdb0a905b6a318e9f ]

PAGE_KERNEL_TEXT is an old macro that is used to tell kernel whether
kernel text has to be mapped read-only or read-write based on build
time options.

But nowadays, with functionnalities like jump_labels, static links,
etc ... more only less all kernels need to be read-write at some
point, and some combinations of configs failed to work due to
innacurate setting of PAGE_KERNEL_TEXT. On the other hand, today
we have CONFIG_STRICT_KERNEL_RWX which implements a more controlled
access to kernel modifications.

Instead of trying to keep PAGE_KERNEL_TEXT accurate with all
possible options that may imply kernel text modification, always
set kernel text read-write at startup and rely on
CONFIG_STRICT_KERNEL_RWX to provide accurate protection.

Do this by passing PAGE_KERNEL_X to map_kernel_page() in
__maping_ram_chunk() instead of passing PAGE_KERNEL_TEXT. Once
this is done, the only remaining user of PAGE_KERNEL_TEXT is
mmu_mark_initmem_nx() which uses it in a call to setibat().
As setibat() ignores the RW/RO, we can seamlessly replace
PAGE_KERNEL_TEXT by PAGE_KERNEL_X here as well and get rid of
PAGE_KERNEL_TEXT completely.

Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://lore.kernel.org/all/342b4120-911c-4723-82ec-d8c9b03a8aef@mailbox.org/
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/8e2d793abf87ae3efb8f6dce10f974ac0eda61b8.1757412205.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis, here is my assessment:

## **YES** - This commit should be backported to stable kernel trees.

### **Detailed Analysis:**

#### **Critical Bug Being Fixed:**
The commit fixes a **startup failure** on PowerMac G4 Dual Processor
systems with certain kernel configurations (specifically
`CONFIG_STATIC_CALL_SELFTEST=y`). According to the bug report from
Erhard Furtner, affected systems fail to boot completely, displaying
only partial OpenFirmware output:
```
done
found display   : /pci@f0000000/ATY,AlteracParent@10/ATY,Alterac_B@1,
opening...
```

This is a **complete boot failure** - the system cannot start at all.

#### **Root Cause Analysis:**
The `PAGE_KERNEL_TEXT` macro in **arch/powerpc/include/asm/pgtable.h**
(lines 23-33) attempted to determine at compile-time whether kernel text
should be mapped read-only (`PAGE_KERNEL_ROX`) or read-write
(`PAGE_KERNEL_X`) based on CONFIG options:
```c
#if defined(CONFIG_KGDB) || defined(CONFIG_XMON) ||
defined(CONFIG_BDI_SWITCH) || \
    defined(CONFIG_KPROBES) || defined(CONFIG_DYNAMIC_FTRACE)
#define PAGE_KERNEL_TEXT    PAGE_KERNEL_X
#else
#define PAGE_KERNEL_TEXT    PAGE_KERNEL_ROX
#endif
```

However, this list became **incomplete and inaccurate** with modern
kernel features:
- **jump_labels** - requires runtime code patching
- **static_call** - requires runtime code modification
- **static keys** - requires runtime patching
- Other runtime code modification features

When `PAGE_KERNEL_TEXT` incorrectly resolved to `PAGE_KERNEL_ROX` (read-
only), code patching operations during boot would fail, causing startup
failures.

#### **The Fix - Code Changes:**

1. **arch/powerpc/include/asm/pgtable.h**: Removes the entire
   `PAGE_KERNEL_TEXT` macro definition (12 lines deleted)

2. **arch/powerpc/mm/pgtable_32.c** (line 107):
  ```c
   - ktext = core_kernel_text(v);
   - map_kernel_page(v, p, ktext ? PAGE_KERNEL_TEXT : PAGE_KERNEL);
   + map_kernel_page(v, p, ktext ? PAGE_KERNEL_X : PAGE_KERNEL);
   ```
   Always maps kernel text as read-write-execute at startup.

3. **arch/powerpc/mm/book3s32/mmu.c** (lines 207, 218):
  ```c
   - setibat(i++, PAGE_OFFSET + base, base, size, PAGE_KERNEL_TEXT);
   + setibat(i++, PAGE_OFFSET + base, base, size, PAGE_KERNEL_X);
   ```
   Note: The commit message explicitly states "setibat() ignores the
RW/RO" bits, so this change is functionally equivalent but maintains
consistency.

#### **Security Implications - THOROUGHLY ANALYZED:**

**This change does NOT weaken kernel security.** Here's why:

1. **CONFIG_STRICT_KERNEL_RWX provides proper protection**: The kernel
   text is mapped as RWX initially, but `mmu_mark_rodata_ro()` (in
   **arch/powerpc/mm/pgtable_32.c:162**, **book3s32/mmu.c:238**) is
   called later during boot to convert text sections from RWX to RX
   (read-execute only). This function:
   - Modifies BAT (Block Address Translation) entries to set `BPP_RX`
     (read-execute, not write)
   - Is controlled by `CONFIG_STRICT_KERNEL_RWX` which has been
     available since ~2017
   - Is called from `mark_rodata_ro()` in **init/main.c:1443** after
     kernel initialization

2. **Modern kernel security model**: This approach aligns with how
   modern kernels handle code patching across architectures:
   - Early boot: Text is writable to allow necessary code patching (jump
     labels, static calls, ftrace, etc.)
   - Post-init: Text is locked down via STRICT_KERNEL_RWX

3. **The window of vulnerability is minimal**: Text is only writable
   during early boot when code patching is necessary, then immediately
   locked down.

4. **Extensive code patching infrastructure exists**: The PowerPC
   architecture has sophisticated code-patching infrastructure
   (**arch/powerpc/lib/code-patching.c**) with many recent commits
   ensuring safe text modification.

#### **Backport Suitability Assessment:**

**✅ STRONG YES - Excellent backport candidate:**

1. **Fixes critical bug**: Complete boot failure on real hardware
2. **User-reported**: Erhard Furtner reported the issue with specific
   hardware (PowerMac G4 DP)
3. **Tested**: Andrew Donnellan provided `Tested-by` tag
4. **Small and contained**: 3 files changed, 3 insertions(+), 15
   deletions(-)
5. **No regressions**: No follow-up fixes or reverts found
6. **Simplifies code**: Removes problematic conditional logic
7. **Architecture-isolated**: Only affects PowerPC 32-bit (book3s32,
   nohash/8xx)
8. **Low regression risk**: Change is well-understood and tested
9. **No dependencies**: `PAGE_KERNEL_X` and `CONFIG_STRICT_KERNEL_RWX`
   exist in all modern stable kernels
10. **Already backported**: Commit 27e9cfa74706c shows this was already
    picked for stable by Sasha Levin with `[ Upstream commit
    9316512b717f6 ]`

#### **Stable Kernel Rules Compliance:**

- ✅ Fixes important bug (boot failure)
- ✅ Does not introduce new features
- ✅ Does not make architectural changes (actually simplifies
  architecture)
- ✅ Minimal risk of regression
- ✅ Confined to PowerPC subsystem
- ✅ Clear, well-documented change

**Recommendation**: This commit is an ideal candidate for stable
backporting and addresses the exact type of critical bug that stable
trees are meant to fix.

 arch/powerpc/include/asm/pgtable.h | 12 ------------
 arch/powerpc/mm/book3s32/mmu.c     |  4 ++--
 arch/powerpc/mm/pgtable_32.c       |  2 +-
 3 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index 93d77ad5a92fa..d8f944a5a0378 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -20,18 +20,6 @@ struct mm_struct;
 #include <asm/nohash/pgtable.h>
 #endif /* !CONFIG_PPC_BOOK3S */
 
-/*
- * Protection used for kernel text. We want the debuggers to be able to
- * set breakpoints anywhere, so don't write protect the kernel text
- * on platforms where such control is possible.
- */
-#if defined(CONFIG_KGDB) || defined(CONFIG_XMON) || defined(CONFIG_BDI_SWITCH) || \
-	defined(CONFIG_KPROBES) || defined(CONFIG_DYNAMIC_FTRACE)
-#define PAGE_KERNEL_TEXT	PAGE_KERNEL_X
-#else
-#define PAGE_KERNEL_TEXT	PAGE_KERNEL_ROX
-#endif
-
 /* Make modules code happy. We don't set RO yet */
 #define PAGE_KERNEL_EXEC	PAGE_KERNEL_X
 
diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index be9c4106e22f0..c42ecdf94e48c 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -204,7 +204,7 @@ int mmu_mark_initmem_nx(void)
 
 	for (i = 0; i < nb - 1 && base < top;) {
 		size = bat_block_size(base, top);
-		setibat(i++, PAGE_OFFSET + base, base, size, PAGE_KERNEL_TEXT);
+		setibat(i++, PAGE_OFFSET + base, base, size, PAGE_KERNEL_X);
 		base += size;
 	}
 	if (base < top) {
@@ -215,7 +215,7 @@ int mmu_mark_initmem_nx(void)
 				pr_warn("Some RW data is getting mapped X. "
 					"Adjust CONFIG_DATA_SHIFT to avoid that.\n");
 		}
-		setibat(i++, PAGE_OFFSET + base, base, size, PAGE_KERNEL_TEXT);
+		setibat(i++, PAGE_OFFSET + base, base, size, PAGE_KERNEL_X);
 		base += size;
 	}
 	for (; i < nb; i++)
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index 15276068f657d..0c9ef705803e9 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -104,7 +104,7 @@ static void __init __mapin_ram_chunk(unsigned long offset, unsigned long top)
 	p = memstart_addr + s;
 	for (; s < top; s += PAGE_SIZE) {
 		ktext = core_kernel_text(v);
-		map_kernel_page(v, p, ktext ? PAGE_KERNEL_TEXT : PAGE_KERNEL);
+		map_kernel_page(v, p, ktext ? PAGE_KERNEL_X : PAGE_KERNEL);
 		v += PAGE_SIZE;
 		p += PAGE_SIZE;
 	}
-- 
2.51.0

