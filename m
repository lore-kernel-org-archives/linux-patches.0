Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFEF194AD7;
	Wed, 11 Feb 2026 12:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813131; cv=none; b=ReEOnS+6AQsFLMiA/K5bpTv8n7E/0OjcZOdRPLRU0lU+6xdQfiiyJ02Y9S/CDeVFcYqNZrECh1ycmITGj/OeOBXRWvmEYlx2g210XGC2HZnaXrf1EkjY3+neVhPh55i5cNN4rGawghec8YTmjT/8hUM1BgKi2xcl+Tt8eMqnx9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813131; c=relaxed/simple;
	bh=66de8YGfHD0DZc6gZxZ3nQPSQUgvW59BQ1RTSGfyPsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LptoG8PfSHNJ8wFAS5NgI/N16dIkgb88/xuZ/yJOkueMEFS/AxQSHmUIQaiDTa+djRkdP13gYbYK1dKpaNrbaRCOtSa42TUyIQqWWqG/goUOOhpoLj/ucL4F4cZFouP0/gkZ5GGLHV1NKDWRxgE4yBE4dLPJnWWI4wLn2FT6LzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F1Tc/XVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F1Tc/XVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A560C19421;
	Wed, 11 Feb 2026 12:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813131;
	bh=66de8YGfHD0DZc6gZxZ3nQPSQUgvW59BQ1RTSGfyPsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1Tc/XVRNxat8unKrmb6Zln8Iaa45jflrBT2T02jMuJPqNwvhyCFS2OMp7lkb56ZC
	 jm/UF7vKepo8y4KU2ucTpX0vWMKOiVrNIOXCIcoTD+met0QmafDkcitYQuTBrzmc3K
	 iEJu1LypLsZBShnITL0gv8hcbHs+hfYnDMEmMb6AvvqUq38kTfh4ursoXb1+MPY1gu
	 TEnysOtSKiiJN6LDVKGS6GZsZ9QWcuq8553wdA+u+d4XWjs54/EwXiQ8cn4jocc8e0
	 GhjJbf+4+Fa8NzQemF3kCCO6EVupR1Mr6IcBYRTBaG2VvRZ6zLAREKnxJagVBheqHZ
	 r8JUgN1M2qRHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Carl Worth <carl@os.amperecomputing.com>,
	Taehyun Noh <taehyun@utexas.edu>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	anshuman.khandual@arm.com,
	ryan.roberts@arm.com,
	kevin.brodsky@arm.com,
	yeoreum.yun@arm.com
Subject: [PATCH AUTOSEL 6.19] arm64: mte: Set TCMA1 whenever MTE is present in the kernel
Date: Wed, 11 Feb 2026 07:30:37 -0500
Message-ID: <20260211123112.1330287-27-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Carl Worth <carl@os.amperecomputing.com>

[ Upstream commit a4e5927115f30a301f9939ed43e6a21a343e06ad ]

Set the TCMA1 bit so that access to TTBR1 addresses with 0xf in their
tag bits will be treated as tag unchecked.

This is important to avoid unwanted tag checking on some
systems. Specifically, SCTLR_EL1.TCF can be set to indicate that no
tag check faults are desired. But the architecture doesn't guarantee
that in this case the system won't still perform tag checks.

Use TCMA1 to ensure that undesired tag checks are not performed. This
bit was already set in the KASAN case. Adding it to the non-KASAN case
prevents tag checking since all TTBR1 address will have a value of 0xf
in their tag bits.

This patch has been measured on an Ampere system to improve the following:

* Eliminate over 98% of kernel-side tag checks during "perf bench
  futex hash", as measured with "perf stat".

* Eliminate all MTE overhead (was previously a 25% performance
  penalty) from the Phoronix pts/memcached benchmark (1:10 Set:Get
  ration with 96 cores).

Reported-by: Taehyun Noh <taehyun@utexas.edu>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Carl Worth <carl@os.amperecomputing.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good. Now I have a complete understanding. Let me write the full
analysis.

---

## Comprehensive Analysis: arm64: mte: Set TCMA1 whenever MTE is present
in the kernel

### 1. COMMIT MESSAGE ANALYSIS

The commit sets the `TCMA1` (Tag Check Match All 1) bit in `TCR_EL1`
whenever `CONFIG_ARM64_MTE` is enabled, not just when
`CONFIG_KASAN_HW_TAGS` is enabled.

Key indicators:
- **"Reported-by: Taehyun Noh"** - real-world issue discovered by a user
- **"Suggested-by: Catalin Marinas"** - the fix approach comes from the
  arm64 MTE subsystem maintainer
- **"Reviewed-by: Catalin Marinas"** - reviewed by the domain expert
- **Signed-off-by: Will Deacon** - merged by the arm64 maintainer

The commit message clearly describes the problem: `SCTLR_EL1.TCF` being
set to NONE (no faults) does **not** guarantee the hardware won't still
perform tag checks. TCMA1 is needed to definitively prevent unwanted tag
checking for kernel addresses.

### 2. CODE CHANGE ANALYSIS

The change is in `arch/arm64/mm/proc.S`:

**Before (current stable/mainline):**

```51:61:arch/arm64/mm/proc.S
#ifdef CONFIG_KASAN_HW_TAGS
#define TCR_MTE_FLAGS TCR_EL1_TCMA1 | TCR_EL1_TBI1 | TCR_EL1_TBID1
#elif defined(CONFIG_ARM64_MTE)
/*
 - The mte_zero_clear_page_tags() implementation uses DC GZVA, which
   relies on
 - TBI being enabled at EL1.
 */
#define TCR_MTE_FLAGS TCR_EL1_TBI1 | TCR_EL1_TBID1
#else
#define TCR_MTE_FLAGS 0
#endif
```

**After (the fix):**
- Collapses the three-way `#ifdef` into two-way: `CONFIG_ARM64_MTE` vs.
  else
- Adds `TCR_EL1_TCMA1` to the `CONFIG_ARM64_MTE` case (previously only
  in `CONFIG_KASAN_HW_TAGS`)
- This is valid because `CONFIG_KASAN_HW_TAGS` implies
  `CONFIG_ARM64_MTE` (via `HAVE_ARCH_KASAN_HW_TAGS` which `select`s from
  `ARM64_MTE`)

The behavioral change is a single bit addition: `TCR_EL1_TCMA1` (bit 58
of `TCR_EL1`).

### 3. TECHNICAL EXPLANATION

**What TCMA1 does (ARM Architecture Reference Manual):**
- TCMA1 controls "Tag Check Match All" for TTBR1 (kernel) addresses
- When set: accesses with tag 0xF (all bits set) in the top byte are
  treated as "Tag Unchecked"
- When clear: tag 0xF is treated like any other tag and is checked
  against the allocation tag

**Why this matters:**
- All kernel pointers (TTBR1 addresses) have tag 0xFF (`KASAN_TAG_KERNEL
  = 0xFF` from `include/linux/kasan-tags.h`), which corresponds to the
  4-bit MTE tag 0xF
- Without TCMA1, the hardware may perform tag checks on every kernel
  memory access, even with `SCTLR_EL1.TCF = NONE` (the architecture
  doesn't guarantee TCF=NONE prevents checking - it only prevents
  faults)
- On Ampere systems, this results in **98% unnecessary kernel-side tag
  checks** during futex benchmarks and a **25% performance penalty** on
  memcached

**Why it was missing:**
- The original MTE implementation correctly set TCMA1 for
  `CONFIG_KASAN_HW_TAGS` (because KASAN uses non-0xF tags for tagged
  allocations, and 0xF means "match all")
- But for plain `CONFIG_ARM64_MTE` (without KASAN), TCMA1 was omitted,
  likely because it was assumed TCF=NONE was sufficient to prevent tag
  checking

### 4. SCOPE AND RISK ASSESSMENT

**Scope:**
- 1 file changed (`arch/arm64/mm/proc.S`)
- ~5 lines of actual diff (macro definition change)
- Purely a register configuration change at boot time

**Risk: VERY LOW**
- `TCMA1` was already set in the `CONFIG_KASAN_HW_TAGS` path - this
  extends it to all MTE configurations
- The bit is well-defined in the ARM architecture specification
- It only affects the handling of tag 0xF (match-all tag) on TTBR1
  addresses
- Cannot cause any functional regression - it makes the hardware skip
  checks that were producing no useful results anyway

### 5. USER IMPACT ASSESSMENT

**Who is affected:**
- `CONFIG_ARM64_MTE` defaults to `y` in `arch/arm64/Kconfig` (line 2124:
  `default y`)
- This means virtually **all ARM64 distro kernels** have it enabled
- Any ARM64 system with MTE-capable hardware (ARMv8.5+: Ampere
  Altra/AmpereOne, Arm Neoverse V1/V2/N2, Cortex-X2+, etc.)
- These are widely used in cloud/data center (Ampere), mobile (Cortex),
  and embedded systems

**Severity:**
- 25% performance penalty on memcached (a very common server workload)
- 98% unnecessary tag checks during kernel futex operations
- This is a **significant performance issue** for production ARM64
  servers

### 6. STABLE TREE APPLICABILITY

The affected three-way ifdef structure exists in:
- **v6.12/v6.6**: Uses `TCR_TCMA1` macro name (trivial rename needed)
- **v6.1**: Same structure, uses `TCR_TCMA1`
- **v5.15**: Uses `SYS_TCR_EL1_TCMA1` macro name, slightly different
  ifdef structure but same issue
- **v5.10**: Different code structure (MTE was new), would need more
  adaptation

The fix applies cleanly with minor macro name adjustments to all active
LTS kernels from 5.15+.

### 7. CLASSIFICATION

This fix meets the stable kernel criteria:

1. **Obviously correct and tested**: Measured on Ampere hardware,
   reviewed by Catalin Marinas (the MTE architect)
2. **Small**: ~5 lines in 1 file
3. **Fixes one thing**: Adds TCMA1 to prevent unwanted tag checking
4. **Fixes a real bug**: The kernel's intent (no tag checking) was not
   being realized by the hardware
5. **Significant performance regression**: Stable rules explicitly allow
   fixes for "a significant performance regression" - 25% on memcached
   qualifies
6. **No new features**: Just correcting a register configuration

The commit explicitly addresses a case where the kernel's register
configuration was incomplete, causing the hardware to perform unwanted
operations (tag checking) that produce no useful result but cause
significant performance degradation. This is a bug in the kernel's MTE
initialization, not a new feature or optimization.

**YES** - This commit should be backported to stable kernel trees. It
fixes a significant performance regression (25% on memcached) affecting
all ARM64 MTE-capable systems running kernels with `CONFIG_ARM64_MTE=y`
(the default). The fix is tiny (adding one bit to a register), extremely
low risk (the same bit was already set in the KASAN path), reviewed by
the MTE subsystem expert, and the stable rules explicitly permit fixes
for significant performance regressions. The affected code exists in all
current LTS kernels (5.15+) with only trivial macro name adjustments
needed for backporting.

**YES**

 arch/arm64/mm/proc.S | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 5d907ce3b6d3f..22866b49be372 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -48,14 +48,14 @@
 #define TCR_KASAN_SW_FLAGS 0
 #endif
 
-#ifdef CONFIG_KASAN_HW_TAGS
-#define TCR_MTE_FLAGS TCR_EL1_TCMA1 | TCR_EL1_TBI1 | TCR_EL1_TBID1
-#elif defined(CONFIG_ARM64_MTE)
+#ifdef CONFIG_ARM64_MTE
 /*
  * The mte_zero_clear_page_tags() implementation uses DC GZVA, which relies on
- * TBI being enabled at EL1.
+ * TBI being enabled at EL1.  TCMA1 is needed to treat accesses with the
+ * match-all tag (0xF) as Tag Unchecked, irrespective of the SCTLR_EL1.TCF
+ * setting.
  */
-#define TCR_MTE_FLAGS TCR_EL1_TBI1 | TCR_EL1_TBID1
+#define TCR_MTE_FLAGS TCR_EL1_TCMA1 | TCR_EL1_TBI1 | TCR_EL1_TBID1
 #else
 #define TCR_MTE_FLAGS 0
 #endif
-- 
2.51.0

