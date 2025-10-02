Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D257D1F19A;
	Thu,  2 Oct 2025 15:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759419040; cv=none; b=k6WYO4cdGCn8zTetSWQzEphuZ883ac1BHYB3hUGt/EAeUxt9wQwwB6d45mKP6+dKwrqBju0W5NDWDfF/ZNF4EL6dEUhdq8YtoOo6ZiKGfipJYlkR5tCH/F5NVsj4cdtzVZ7ZoH4qmty9hbUMBPG6yWpb4WE20gj70LqrOzb7jLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759419040; c=relaxed/simple;
	bh=jXFvqADOXhoMBxDmKNZjCgPHb2ho0Ydepvi1UXzuC+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKtLk07qEdC+lPowEUxDSA5VDJj2moBRHhlPyuk89ZsbMAch+D1CuTIr9HzkRhQoB2fncEdA2h0cOeLg1PRk1EHYal10dO7PbJvmmlWR9uG9rm5vpHyS+X9voJArNX5y5dc/wOlX2SqXeJF/prsL4kduk8IP7fH1C6v1arG9EMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=alJXUrmf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="alJXUrmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D4CC4CEF9;
	Thu,  2 Oct 2025 15:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759419040;
	bh=jXFvqADOXhoMBxDmKNZjCgPHb2ho0Ydepvi1UXzuC+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alJXUrmf95I8heIuO7zt8RADFO/5+6S4FJaPix5nefsjIzRshZ3AQFgx80NLV9DXk
	 9nR4RteOdoIjKmTnhzGCRQDtVeh/OrncPDzhMe3V3cs1w2HAn2VO3hsnyjw1+8HiRK
	 YzthvKQMWnpa7OFHyQ517kdb+b9fesHoqryoBiV6LAdbZsJ0QTN9rjjbcKt0OcW/2c
	 yEooYMqxGIymQd2uBfcwTZsM2x9T5lssRTpckdjjPIZqZ96vy1P3sopuaQkBuJPnAs
	 oGjW8yRQLvbQih2JxDjd6c3LTNQbGfB4tFACY/4xXaCH6E/02Sm2vPpb6LyA5P3866
	 dkmezmJzm6uEg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Simon Schuster <schuster.simon@siemens-energy.com>,
	Andreas Oetken <andreas.oetken@siemens-energy.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-5.15] nios2: ensure that memblock.current_limit is set when setting pfn limits
Date: Thu,  2 Oct 2025 11:29:58 -0400
Message-ID: <20251002153025.2209281-11-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Simon Schuster <schuster.simon@siemens-energy.com>

[ Upstream commit a20b83cf45be2057f3d073506779e52c7fa17f94 ]

On nios2, with CONFIG_FLATMEM set, the kernel relies on
memblock_get_current_limit() to determine the limits of mem_map, in
particular for max_low_pfn.
Unfortunately, memblock.current_limit is only default initialized to
MEMBLOCK_ALLOC_ANYWHERE at this point of the bootup, potentially leading
to situations where max_low_pfn can erroneously exceed the value of
max_pfn and, thus, the valid range of available DRAM.

This can in turn cause kernel-level paging failures, e.g.:

[   76.900000] Unable to handle kernel paging request at virtual address 20303000
[   76.900000] ea = c0080890, ra = c000462c, cause = 14
[   76.900000] Kernel panic - not syncing: Oops
[   76.900000] ---[ end Kernel panic - not syncing: Oops ]---

This patch fixes this by pre-calculating memblock.current_limit
based on the upper limits of the available memory ranges via
adjust_lowmem_bounds, a simplified version of the equivalent
implementation within the arm architecture.

Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
Signed-off-by: Andreas Oetken <andreas.oetken@siemens-energy.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis, here is my determination:

## Backport Recommendation: **YES**

### Analysis

**Bug Description:**
The commit fixes a critical memory initialization bug in nios2
architecture with CONFIG_FLATMEM. The `find_limits()` function
(introduced in 2021 via commit 7f7bc20bc41a4) uses
`memblock_get_current_limit()` to calculate `max_low_pfn` at
arch/nios2/kernel/setup.c:140:

```c
*max_low_pfn = PFN_DOWN(memblock_get_current_limit());
```

However, `memblock.current_limit` is only default-initialized to
`MEMBLOCK_ALLOC_ANYWHERE` (defined as `~(phys_addr_t)0` in
include/linux/memblock.h:408, essentially ULONG_MAX). This causes
`max_low_pfn` to be set to an enormous value that exceeds `max_pfn`,
violating the critical invariant `max_low_pfn <= max_pfn`.

**Impact:**
When the kernel attempts memory operations using the incorrect
`max_low_pfn`, it accesses memory beyond actual DRAM, resulting in
kernel paging failures:
```
Unable to handle kernel paging request at virtual address 20303000
Kernel panic - not syncing: Oops
```

**The Fix:**
The commit adds `adjust_lowmem_bounds()`
(arch/nios2/kernel/setup.c:145-157) which:
1. Iterates through all memory ranges using `for_each_mem_range()`
2. Finds the highest `block_end` address
3. Calls `memblock_set_current_limit(memblock_limit)` to set the actual
   memory limit

This function is called at line 174 before `find_limits()`, ensuring
correct initialization. The implementation follows the proven pattern
from ARM architecture (arch/arm/mm/mmu.c:1185).

**Backporting Justification:**

1. **Critical bug with clear user impact**: Causes kernel panics on
   affected systems
2. **Small and well-contained**: Only 15 lines of code added
3. **Minimal regression risk**:
   - Architecture-specific (nios2 only) - zero risk to other systems
   - Pattern proven in ARM for years (since commit 985626564eedc from
     2017)
   - Only affects boot-time initialization
4. **Follows stable tree rules**: Important bugfix, no new features, no
   architectural changes
5. **Similar issues in other architectures**: MIPS had a similar
   `max_low_pfn` bug fixed in commit 0f5cc249ff735 (2023)
6. **Long-lived bug**: Latent since 2021, affects all kernels with
   commit 7f7bc20bc41a4

**Historical Context:**
- Bug introduced: 2021-02-19 (commit 7f7bc20bc41a4)
- Bug fixed: 2025-08-21 (commit a20b83cf45be2)
- Same author (Andreas Oetken) involved in both commits

**Target Stable Trees:**
Should be backported to all stable trees containing commit 7f7bc20bc41a4
(February 2021 onwards).

 arch/nios2/kernel/setup.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/nios2/kernel/setup.c b/arch/nios2/kernel/setup.c
index 2a40150142c36..f43f01c4ab934 100644
--- a/arch/nios2/kernel/setup.c
+++ b/arch/nios2/kernel/setup.c
@@ -142,6 +142,20 @@ static void __init find_limits(unsigned long *min, unsigned long *max_low,
 	*max_high = PFN_DOWN(memblock_end_of_DRAM());
 }
 
+static void __init adjust_lowmem_bounds(void)
+{
+	phys_addr_t block_start, block_end;
+	u64 i;
+	phys_addr_t memblock_limit = 0;
+
+	for_each_mem_range(i, &block_start, &block_end) {
+		if (block_end > memblock_limit)
+			memblock_limit = block_end;
+	}
+
+	memblock_set_current_limit(memblock_limit);
+}
+
 void __init setup_arch(char **cmdline_p)
 {
 	console_verbose();
@@ -157,6 +171,7 @@ void __init setup_arch(char **cmdline_p)
 	/* Keep a copy of command line */
 	*cmdline_p = boot_command_line;
 
+	adjust_lowmem_bounds();
 	find_limits(&min_low_pfn, &max_low_pfn, &max_pfn);
 
 	memblock_reserve(__pa_symbol(_stext), _end - _stext);
-- 
2.51.0

