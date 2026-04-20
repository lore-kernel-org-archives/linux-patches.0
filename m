Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88093D9DA6;
	Mon, 20 Apr 2026 13:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691439; cv=none; b=l96HWn/+yf0PWIXHgQkuibc5akWpB+YnTOfN/IrU6zJsiPxjeeb1skZE4f1MHqaGYJ3PFmqA5jEnRm99LA8Ay07bddNFJ96byTAVhTR0pl+PKHtTCES0+QOEdMegAOhfE10AjbQ1lypc4mGtOU66rk1XyTKLgdyZqGfpAEefOTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691439; c=relaxed/simple;
	bh=1igANYwOjFPNj7Lw7WtB+Ul5mELciDGyTlwt3dskh0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feCpSaw+JrMFwUNPtCN/2cBod/uN/trrTJ/eWlITDc+4wlnp7qbMxah7wWc0NOgUx8DKMS3OilLiEDElp7EQnRG6bM9UyFwmkW4hOS6cDdRGmKiY0C5LvwHzRb3r+PgyjpO4Uft0/qQE8BW/M63CQLSI8gu1PwnwG70yhl+m2bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ii6xnI4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ii6xnI4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDCEC2BCB4;
	Mon, 20 Apr 2026 13:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691439;
	bh=1igANYwOjFPNj7Lw7WtB+Ul5mELciDGyTlwt3dskh0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ii6xnI4dUwpL0UH1Jk3q0RR32zalfacsLGnq+1hurN3G8Uoa91iYIY63Os2c2dbv0
	 Z3letXlQviS4+Zj8Vx0nwCZeiN9Xh/sN4fZcI8OVdo8Zj3kuLZP3j9x5MN5WjXKO01
	 Fz8PJIboy9s9xdoWmYvaYkPiQo0WLAjyQ0UaP/PjtNQgNxYSopkRD3j0y/01tN1q9H
	 m4F/QHQxJFU/kmG83FBzTUYDvlFKcnu8w+OHlb961V5LUwHwLMATLgZiUUBZowNivw
	 YqAi3w5+CTcqg1o+YEqiz9TLpYWquRUtnaDun8dbH+6er1xdm1bFmEG+Ag3ir5R7Vq
	 7B9Jt96t7W2TA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	joro@8bytes.org,
	will@kernel.org,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] iommu/amd: Fix illegal device-id access in IOMMU debugfs
Date: Mon, 20 Apr 2026 09:17:02 -0400
Message-ID: <20260420132314.1023554-28-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Guanghui Feng <guanghuifeng@linux.alibaba.com>

[ Upstream commit e4172c5b53fba04fa48b13bc3afde809d0087a7f ]

In the current AMD IOMMU debugFS, when multiple processes use the IOMMU
debugFS process simultaneously, illegal access issues can occur in the
following execution flow:

1. CPU1: Sets a valid sbdf via devid_write, then checks the sbdf's
validity in execution flows such as devid_show, iommu_devtbl_show,
and iommu_irqtbl_show.

2. CPU2: Sets an invalid sbdf via devid_write, at which point the sbdf
value is -1.

3. CPU1: accesses the IOMMU device table, IRQ table, based on the
invalid SBDF value of -1, resulting in illegal access.

This is especially problematic in monitoring scripts, where multiple
scripts may access debugFS simultaneously, and some scripts may
unexpectedly set invalid values, which triggers illegal access in
debugfs.

This patch modifies the execution flow of devid_show,
iommu_devtbl_show, and iommu_irqtbl_show to ensure that these
processes determine the validity and access based on the
same device-id, thus guaranteeing correctness and robustness.

Signed-off-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** iommu/amd
- **Action verb:** "Fix" (explicit bug fix)
- **Summary:** Fixes illegal device-id access in IOMMU debugfs caused by
  a race condition on the global `sbdf` variable

### Step 1.2: Tags
- **Signed-off-by:** Guanghui Feng <guanghuifeng@linux.alibaba.com>
  (author)
- **Signed-off-by:** Joerg Roedel <joerg.roedel@amd.com> (AMD IOMMU
  maintainer, applied the patch)
- No Fixes: tag, no Reported-by, no Cc: stable -- all expected for
  candidate review
- No syzbot involvement

### Step 1.3: Commit Body Analysis
The commit message clearly describes a TOCTOU race condition:
1. CPU1 checks `sbdf >= 0` (valid), then proceeds to use `sbdf` as an
   index
2. CPU2 concurrently calls `devid_write()` which sets `sbdf = -1`
3. CPU1 reads `sbdf` again to extract `devid`, now gets -1, causing
   illegal access

The commit mentions this is triggered by monitoring scripts accessing
debugfs simultaneously. The failure mode is **illegal memory access**
(out-of-bounds array indexing).

Record: Race condition on global `sbdf` variable. TOCTOU bug. Illegal
access when `sbdf` changes between validity check and use. Triggered by
concurrent debugfs access.

### Step 1.4: Hidden Bug Fix Detection
This is explicitly labeled as a fix and clearly IS a fix. No hiding.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed:** 1 (`drivers/iommu/amd/debugfs.c`)
- **Lines:** +12/-9 (net +3 lines)
- **Functions modified:** `devid_show`, `iommu_devtbl_show`,
  `iommu_irqtbl_show`
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Change
In each of the three functions, the pattern is identical:

**Before:** The global `sbdf` is read multiple times -- once for
validity check, then again for extracting segment and device ID. Between
reads, another thread can change the value.

**After:** A local `sbdf_shadow = sbdf` snapshot is taken at function
entry. All subsequent operations use `sbdf_shadow`, ensuring the
validity check and the actual access operate on the same value.

### Step 2.3: Bug Mechanism
**Category:** Race condition / TOCTOU (Time-of-Check-Time-of-Use)

When `sbdf` becomes -1 between check and use:
- `PCI_SBDF_TO_DEVID(-1)` = `(-1) & 0xffff` = `0xFFFF` = 65535
- This value is then used to index into `rlookup_table[devid]`,
  `dev_table[devid]`, and `irq_lookup_table[devid]`
- These arrays are allocated with `last_bdf + 1` entries. If `last_bdf <
  0xFFFF`, this is an **out-of-bounds access**

### Step 2.4: Fix Quality
- **Obviously correct:** Yes -- standard pattern of snapshotting a
  shared variable into a local
- **Minimal/surgical:** Yes -- only adds 3 local variables and
  substitutes references
- **Regression risk:** Essentially zero. Local variable shadowing does
  not change any semantics when there is no concurrent modification
- **No red flags**

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy code was introduced by three commits, all by Dheeraj Kumar
Srivastava on July 2, 2025:
- `2e98940f123d9` - "Add support for device id user input" (introduced
  `devid_show` and the global `sbdf`)
- `b484577824452` - "Add debugfs support to dump device table"
  (introduced `iommu_devtbl_show`)
- `349ad6d5263a6` - "Add debugfs support to dump IRT Table" (introduced
  `iommu_irqtbl_show`)

All three commits exist in the 7.0 stable tree.

### Step 3.2: Fixes Tag
No Fixes: tag present (expected for candidate review).

### Step 3.3: File History
The file has had 9 total commits, with the most recent being
`a0c7005333f9a` (a separate OOB fix for the mmio_show function -- same
class of bug). The file is relatively new and the buggy code has been
present since its introduction.

### Step 3.4: Author Context
Guanghui Feng has 4 commits in this tree, all fixing real bugs (UAF,
softlockup, incorrect checks, and this race). They are not the subsystem
maintainer but the fix was reviewed by Vasant Hegde (AMD IOMMU co-
maintainer).

### Step 3.5: Dependencies
This is patch 1/2 of a series but is fully standalone. Patch 2/2 fixes
the same class of bug in `iommu_mmio_show` and `iommu_capability_show`
(different functions). Each patch is independent.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Original Discussion
Found at: https://yhbt.net/lore/lkml/20260319073754.651998-1-
guanghuifeng@linux.alibaba.com/T/

Key findings:
- **Joerg Roedel** (AMD IOMMU maintainer) applied it and explicitly
  said: **"this patch-set fixes pretty serious issues"**
- He asked Vasant Hegde to further review AMD IOMMU debugfs for
  robustness/security
- Only v1 was submitted; no revisions needed

### Step 4.2: Reviewers
- **Vasant Hegde** (AMD, IOMMU co-maintainer): Reviewed-by: for both
  patches
- **Joerg Roedel** (AMD, IOMMU maintainer): Applied the series
- Appropriate maintainers and mailing lists (iommu, linux-kernel) were
  CC'd

### Step 4.3: Bug Report
No external bug report linked; the author discovered this through
analysis of monitoring scripts accessing debugfs concurrently.

### Step 4.4: Series Context
2-patch series. Patch 1/2 is self-contained. Patch 2/2 fixes same
pattern in mmio/capability functions (would also be beneficial but is
independent).

### Step 4.5: Stable Discussion
No explicit stable nomination found on the mailing list. No known reason
it was excluded.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
- `devid_show()` -- called when reading
  `/sys/kernel/debug/iommu/amd/devid`
- `iommu_devtbl_show()` -- called when reading
  `/sys/kernel/debug/iommu/amd/devtbl`
- `iommu_irqtbl_show()` -- called when reading
  `/sys/kernel/debug/iommu/amd/irqtbl`

### Step 5.2: Callers
All three are seq_file show functions, invoked via the VFS `read` path
when userspace reads the debugfs files. They are reachable from any
root-level process (debugfs default permissions).

### Step 5.3-5.4: Call Chain
`open(debugfs_file)` -> `seq_open` -> `read()` -> `seq_read_iter()` ->
`devid_show()` / `iommu_devtbl_show()` / `iommu_irqtbl_show()` ->
accesses `rlookup_table[devid]`, `dev_table[devid]`,
`irq_lookup_table[devid]`

The buggy path is reachable from userspace (root or debugfs-accessible
user).

### Step 5.5: Similar Patterns
The same TOCTOU pattern exists in `iommu_mmio_show` and
`iommu_capability_show` (fixed by patch 2/2 of the series, not this
commit).

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Does the Buggy Code Exist?
Yes. Verified via `git blame`: the three buggy functions were all
introduced in commits from July 2025, well before the 7.0 release. The
code is identical in HEAD and v7.0-rc7 with no diff.

### Step 6.2: Backport Complications
The fix should apply **cleanly** to the 7.0 stable tree. The file
content at HEAD matches exactly what the patch expects to modify.

### Step 6.3: Related Fixes Already in Stable
Only `a0c7005333f9a` (mmio OOB fix) is in the tree, which fixes a
different function. No fix for this specific race has been applied.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem and Criticality
- **Subsystem:** IOMMU (drivers/iommu/amd/) -- IMPORTANT
- AMD IOMMU is used on all AMD server and desktop platforms
- debugfs is a debugging interface, but an OOB access can crash the
  kernel regardless of the interface

### Step 7.2: Activity
Moderately active -- 9 commits total to this file, all relatively recent
(2025-2026).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is Affected
Users with AMD IOMMU hardware who access the IOMMU debugfs. This
includes monitoring scripts and debugging tools running on AMD
platforms.

### Step 8.2: Trigger Conditions
- Two or more processes concurrently accessing IOMMU debugfs files
- One process writes an invalid device ID while another reads
  devtbl/irqtbl
- **Realistic trigger:** Monitoring scripts that poll debugfs, or
  simultaneous debugging sessions
- Requires root access (debugfs), so not directly a privilege escalation
  vector

### Step 8.3: Failure Mode Severity
- **Out-of-bounds array access:** Using index 0xFFFF on arrays sized to
  `last_bdf + 1`
- Result: **kernel crash (oops/panic)** or potential **information
  disclosure** from reading arbitrary kernel memory
- Severity: **HIGH** (kernel crash from root-triggerable path)

### Step 8.4: Risk-Benefit Ratio
- **Benefit:** HIGH -- prevents kernel crash from a realistic concurrent
  access pattern; maintainer called it "pretty serious"
- **Risk:** VERY LOW -- 12 lines added, 9 removed; trivially correct
  local variable shadowing; zero regression risk
- **Ratio:** Strongly favorable for backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence
**FOR backporting:**
- Fixes a real TOCTOU race leading to out-of-bounds array access
  (potential kernel crash)
- AMD IOMMU maintainer (Joerg Roedel) called it "pretty serious"
- Reviewed-by from Vasant Hegde (AMD IOMMU co-maintainer)
- Tiny, surgical fix (12 insertions, 9 deletions, single file)
- Obviously correct -- standard local variable snapshot pattern
- Buggy code exists in 7.0 stable tree
- Applies cleanly with no modifications needed
- Self-contained (no dependencies on other patches)

**AGAINST backporting:**
- debugfs is root-only, limiting exposure
- No syzbot/reproducer report
- No Fixes: tag (expected for candidates)

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES -- reviewed by AMD maintainer,
   applied by subsystem maintainer
2. **Fixes a real bug?** YES -- race condition leading to out-of-bounds
   access
3. **Important issue?** YES -- kernel crash (HIGH severity per
   maintainer assessment)
4. **Small and contained?** YES -- 3 lines of logic change across 3
   functions in 1 file
5. **No new features or APIs?** Correct -- no new features
6. **Can apply to stable trees?** YES -- applies cleanly

### Step 9.3: Exception Categories
Not applicable -- this is a standard bug fix, not an exception category.

### Step 9.4: Decision
The fix is small, surgical, obviously correct, reviewed and approved by
the subsystem maintainers, and fixes a real race condition that can
cause out-of-bounds memory access (kernel crash). It meets all stable
kernel criteria.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by from author (Guanghui Feng) and
  maintainer (Joerg Roedel). No Fixes: or Cc: stable (expected).
- [Phase 2] Diff analysis: 3 functions each get `int sbdf_shadow =
  sbdf;` local snapshot. All subsequent sbdf uses replaced with
  sbdf_shadow. +12/-9 lines.
- [Phase 2] Verified `PCI_SBDF_TO_DEVID(-1)` = `0xFFFF` via macro
  definition in `amd_iommu_types.h:443`
- [Phase 2] Verified arrays are sized to `last_bdf + 1`
  (init.c:662-663), so devid=0xFFFF can be OOB
- [Phase 3] git blame: buggy code introduced by `2e98940f123d9`,
  `b484577824452`, `349ad6d5263a6` (all July 2025)
- [Phase 3] git show for all three introducing commits confirmed they
  are in the 7.0 tree
- [Phase 3] git log confirms no prior fix for this specific race in the
  tree
- [Phase 4] Lore thread found at yhbt.net mirror. Joerg Roedel said
  "fixes pretty serious issues". Vasant Hegde gave Reviewed-by.
- [Phase 4] Only v1 submitted, no revisions needed. Series is 2 patches,
  this is patch 1 (standalone).
- [Phase 5] Functions are debugfs seq_file show callbacks, reachable
  from userspace read() on debugfs files
- [Phase 6] `git diff v7.0-rc7 HEAD -- drivers/iommu/amd/debugfs.c` is
  empty -- file is identical to current HEAD, patch applies cleanly
- [Phase 8] OOB array access -> kernel oops/crash, severity HIGH.
  Maintainer confirmed seriousness.

**YES**

 drivers/iommu/amd/debugfs.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd/debugfs.c b/drivers/iommu/amd/debugfs.c
index 20b04996441d6..0b03e0622f67e 100644
--- a/drivers/iommu/amd/debugfs.c
+++ b/drivers/iommu/amd/debugfs.c
@@ -197,10 +197,11 @@ static ssize_t devid_write(struct file *filp, const char __user *ubuf,
 static int devid_show(struct seq_file *m, void *unused)
 {
 	u16 devid;
+	int sbdf_shadow = sbdf;
 
-	if (sbdf >= 0) {
-		devid = PCI_SBDF_TO_DEVID(sbdf);
-		seq_printf(m, "%04x:%02x:%02x.%x\n", PCI_SBDF_TO_SEGID(sbdf),
+	if (sbdf_shadow >= 0) {
+		devid = PCI_SBDF_TO_DEVID(sbdf_shadow);
+		seq_printf(m, "%04x:%02x:%02x.%x\n", PCI_SBDF_TO_SEGID(sbdf_shadow),
 			   PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid));
 	} else
 		seq_puts(m, "No or Invalid input provided\n");
@@ -237,13 +238,14 @@ static int iommu_devtbl_show(struct seq_file *m, void *unused)
 {
 	struct amd_iommu_pci_seg *pci_seg;
 	u16 seg, devid;
+	int sbdf_shadow = sbdf;
 
-	if (sbdf < 0) {
+	if (sbdf_shadow < 0) {
 		seq_puts(m, "Enter a valid device ID to 'devid' file\n");
 		return 0;
 	}
-	seg = PCI_SBDF_TO_SEGID(sbdf);
-	devid = PCI_SBDF_TO_DEVID(sbdf);
+	seg = PCI_SBDF_TO_SEGID(sbdf_shadow);
+	devid = PCI_SBDF_TO_DEVID(sbdf_shadow);
 
 	for_each_pci_segment(pci_seg) {
 		if (pci_seg->id != seg)
@@ -336,19 +338,20 @@ static int iommu_irqtbl_show(struct seq_file *m, void *unused)
 {
 	struct amd_iommu_pci_seg *pci_seg;
 	u16 devid, seg;
+	int sbdf_shadow = sbdf;
 
 	if (!irq_remapping_enabled) {
 		seq_puts(m, "Interrupt remapping is disabled\n");
 		return 0;
 	}
 
-	if (sbdf < 0) {
+	if (sbdf_shadow < 0) {
 		seq_puts(m, "Enter a valid device ID to 'devid' file\n");
 		return 0;
 	}
 
-	seg = PCI_SBDF_TO_SEGID(sbdf);
-	devid = PCI_SBDF_TO_DEVID(sbdf);
+	seg = PCI_SBDF_TO_SEGID(sbdf_shadow);
+	devid = PCI_SBDF_TO_DEVID(sbdf_shadow);
 
 	for_each_pci_segment(pci_seg) {
 		if (pci_seg->id != seg)
-- 
2.53.0

