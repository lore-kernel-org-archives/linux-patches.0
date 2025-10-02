Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA80C1D554;
	Thu,  2 Oct 2025 15:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759419041; cv=none; b=hXPRTs9EFNqpYi27ar5fh5/8q7hOirLrw9YfeQJzMmIgdAdM+78ufRPDU3z3GC7lS11Jmm0iBxrmSO0oW8m+NBLQk8n3a/u8+jxfBpXlcfbvehhrpZPVWtmXkhtp1WubUMoxbU2KZW/qeHfTd2OhhuyI8Mh3ZbqEa8PNRmc8pfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759419041; c=relaxed/simple;
	bh=6pG7b6kdNvu2x4osmYuTKXNOjx2NpAADrJmcVozw7/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zlzc6govNhvjtPD1GdFVaIgdr3QFMPhm/evCo13myOEsMvz0LTgjX7TlxmCeqPR27e5IRJ9iJtopUPzhzgSYCQ6mmUWBrRM6eTh14W2APH87fHcPWV/IAkpK/KmN/T7snZNCic0vJl8T+k7eLrSBlH62dW4P0jio+/XCD/reIcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iyBfqBTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iyBfqBTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E1CC4CEF9;
	Thu,  2 Oct 2025 15:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759419041;
	bh=6pG7b6kdNvu2x4osmYuTKXNOjx2NpAADrJmcVozw7/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iyBfqBTmBZJa4TTikI7GsG9rodDN6j3nWoufJ1ydxTMSdIcb7tJrLdsrlVz5uQJ81
	 9NZCAv/kTSZld59vpwjvLSWgZ45VoAXGwAfgHJz+Iz6ZrB4VlMI6oLEipDQmBepRem
	 8DcDtw/Xa8Qh+jEZdadCAnJRu606ZvVz041+5nM95Lq8HBAdF5uKeQUDpk4UQuMcLR
	 c2mopGUlgHDSQuvYeLznVB1SwVfb5HkpQNWzNO+ozdlMyQ9FL0tPUjzki+A6EyogpI
	 mN2Bsa5p3idZo5CX5Idhc9Gr/b2B6LKcBoUhnhfi0R3OgQExBSHaBug7BXawo+l2ul
	 YThzRPiyI4RQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-6.12] s390/mm: Use __GFP_ACCOUNT for user page table allocations
Date: Thu,  2 Oct 2025 11:29:59 -0400
Message-ID: <20251002153025.2209281-12-sashal@kernel.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 5671ce2a1fc6b4a16cff962423bc416b92cac3c8 ]

Add missing kmemcg accounting of user page table allocations.

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Analysis Complete

**Backport Status: YES**

### Extensive Analysis

#### 1. Code Changes Analysis

The commit makes three specific changes to `arch/s390/mm/pgalloc.c`:

**Change 1 - `crst_table_alloc()` (lines 17-27):**
- Switches from `GFP_KERNEL` to `GFP_KERNEL_ACCOUNT`
- Adds check: if `mm == &init_mm`, removes `__GFP_ACCOUNT` flag
- This ensures kernel page tables for init_mm are NOT accounted (correct
  behavior)

**Change 2 - `page_table_alloc_pgste()` (line 120):**
- Under `CONFIG_PGSTE` (KVM guest support)
- Changes `GFP_KERNEL` to `GFP_KERNEL_ACCOUNT`
- No init_mm check here (pgste tables are always for user processes)

**Change 3 - `page_table_alloc()` (lines 137-148):**
- Similar to Change 1: uses `GFP_KERNEL_ACCOUNT` with init_mm exception
- This is the main user page table allocation path

#### 2. Historical Context

Through extensive kernel repository investigation, I found:

- **x86 got this in v4.10 (July 2016)** via commit 3e79ec7ddc33e by
  Vladimir Davydov
- **powerpc got this in v4.13 (May 2017)** via commits abd667be1502f and
  de3b87611dd1f
- **s390 is getting it NOW (September 2025)** - **9 years after x86!**

The original x86 commit message explains the rationale clearly:
> "Page tables can bite a relatively big chunk off system memory and
their allocations are easy to trigger from userspace, so they should be
accounted to kmemcg."

The pattern established in commit 3e79ec7ddc33e is identical to what
s390 implements: use `GFP_KERNEL_ACCOUNT` but clear `__GFP_ACCOUNT` for
init_mm because kernel page tables can be shared across cgroups.

#### 3. Impact of Missing Accounting

**Without this patch:**
- s390 systems running with memory cgroups cannot properly account page
  table memory
- Users can bypass memory limits by creating many page tables (fork
  bombs, etc.)
- OOM killer may make incorrect decisions due to unaccounted memory
- Memory accounting is incomplete and incorrect for containerized
  workloads

**With this patch:**
- Page tables are properly charged to the cgroup that allocates them
- Memory limits are enforced correctly
- OOM decisions are based on complete memory usage information

#### 4. Risk Assessment

**Regression Risk: VERY LOW**

- Change is architecture-specific (s390 only)
- Only modifies GFP flags in 3 functions
- Pattern proven by 9 years of use on x86 (since v4.10)
- Pattern proven by 8 years of use on powerpc (since v4.13)
- Code is straightforward and follows established kernel patterns

**Potential Side Effect:**
Workloads that were previously hitting high page table usage without
hitting memory limits might now hit those limits. However, this is
**correct behavior** - the accounting was missing before, and limits
were being bypassed incorrectly.

#### 5. Backport Evidence

**Critical finding:** This commit has ALREADY been selected for backport
to stable 6.17:
- Found as commit dc70c002dd2df in linux-autosel-6.17-2 tree
- Contains "[ Upstream commit 5671ce2a1fc6b... ]" tag
- Signed-off-by: Sasha Levin <sashal@kernel.org>
- This indicates the AUTOSEL process identified it as backport-worthy

#### 6. Why This Should Be Backported

**Meets all stable tree criteria:**

1. ✅ **Fixes a bug:** Missing kmemcg accounting is a correctness bug
2. ✅ **Important for users:** Affects anyone using memory cgroups on
   s390 (containers, systemd, cloud)
3. ✅ **Small and contained:** Only 3 functions changed, all in one file
4. ✅ **Low regression risk:** Pattern proven for 9 years on other
   architectures
5. ✅ **No architectural changes:** Just GFP flag modifications
6. ✅ **Brings s390 to parity:** Other architectures have had this for
   years

**Comparison with similar backports:**
Neither the x86 (3e79ec7ddc33e) nor powerpc (abd667be1502f) commits had
explicit `Cc: stable` tags, yet this represents a clear correctness
issue that affects real workloads using cgroups.

#### 7. Specific Code Path Analysis

Looking at the modified functions:

- `crst_table_alloc()`: Called during page table upgrades (66:73,
  expanding address space)
- `page_table_alloc_pgste()`: KVM guest page tables (CONFIG_PGSTE)
- `page_table_alloc()`: Main PTE allocation path (called for every new
  page mapping)

All three are in the hot path for memory allocation and MUST account to
cgroups for proper resource control.

### Conclusion

**YES, this commit should be backported** because:

1. It fixes missing functionality that has been standard on other
   architectures since 2016-2017
2. It affects correctness of memory accounting in production systems
   using cgroups
3. The change is minimal, well-understood, and low-risk
4. It has already been identified by AUTOSEL as worthy of backporting to
   6.17
5. s390 users running containers or using systemd (which uses cgroups
   extensively) need accurate memory accounting

The 9-year delay in adding this to s390 makes it even more important to
backport, as it brings s390 to parity with other architectures for a
fundamental memory management feature.

 arch/s390/mm/pgalloc.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/s390/mm/pgalloc.c b/arch/s390/mm/pgalloc.c
index d2f6f1f6d2fcb..ad3e0f7f7fc1f 100644
--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -16,9 +16,13 @@
 
 unsigned long *crst_table_alloc(struct mm_struct *mm)
 {
-	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL, CRST_ALLOC_ORDER);
+	gfp_t gfp = GFP_KERNEL_ACCOUNT;
+	struct ptdesc *ptdesc;
 	unsigned long *table;
 
+	if (mm == &init_mm)
+		gfp &= ~__GFP_ACCOUNT;
+	ptdesc = pagetable_alloc(gfp, CRST_ALLOC_ORDER);
 	if (!ptdesc)
 		return NULL;
 	table = ptdesc_to_virt(ptdesc);
@@ -117,7 +121,7 @@ struct ptdesc *page_table_alloc_pgste(struct mm_struct *mm)
 	struct ptdesc *ptdesc;
 	u64 *table;
 
-	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	ptdesc = pagetable_alloc(GFP_KERNEL_ACCOUNT, 0);
 	if (ptdesc) {
 		table = (u64 *)ptdesc_to_virt(ptdesc);
 		__arch_set_page_dat(table, 1);
@@ -136,10 +140,13 @@ void page_table_free_pgste(struct ptdesc *ptdesc)
 
 unsigned long *page_table_alloc(struct mm_struct *mm)
 {
+	gfp_t gfp = GFP_KERNEL_ACCOUNT;
 	struct ptdesc *ptdesc;
 	unsigned long *table;
 
-	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	if (mm == &init_mm)
+		gfp &= ~__GFP_ACCOUNT;
+	ptdesc = pagetable_alloc(gfp, 0);
 	if (!ptdesc)
 		return NULL;
 	if (!pagetable_pte_ctor(mm, ptdesc)) {
-- 
2.51.0

