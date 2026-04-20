Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA544BC004;
	Mon, 20 Apr 2026 13:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691971; cv=none; b=RSFV1cOUkQUU+r5dr9ZEWqYWVYvivC0hJaWyzmFW7FxLfdtmLIciuB7VRTld+RY13Tb2dkoSf/dT/7E+NpVIjJwRkmyIabFjzgtKqFg15FjpdnOvMZTx6jhGVdHBjKk42/EugRIyH60rli0YGNf/HScaKw1SyFEIQN29t5vMxrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691971; c=relaxed/simple;
	bh=oDr1PIzwDp5YYugVwrLE/51FsDIcdPDkoDsKpEp8Ta4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UjTBexozMYqJMA8c6caJJOrDQqsp+e53mXFGhYRKLZpylxKgc08KyL+YQITYYkSidSda7CTnUxPgGLusalItvTcQLVO3xhdBIzQTReqNg8res4YzPowrD7Uv/vvkmOBm2CsGgiZVi1CBrPmoposvx837MOyjK+Nt4LrIs8WptdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKpBBMOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKpBBMOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AA1C19425;
	Mon, 20 Apr 2026 13:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691971;
	bh=oDr1PIzwDp5YYugVwrLE/51FsDIcdPDkoDsKpEp8Ta4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKpBBMOPJImsAMeMUCTgJcTXVGDZQLviDYeRodNgx27L7CEcpS2x/CJXlWHb8qyHX
	 3zPBGtsAlIHI1nLCYs1viln3CaMi8mxMjCKdnbaJWdu0gLmSJSe69c6NlRmwxTEljs
	 OGCn5pdhyZX5GxeovIkscaMnqitoXcBRH5NGELZOXEY5daiigF7PFfcwNwJ83EcIbp
	 Bp/N1tF/S2ujJojfHAHX3us1SnbhbxQoYI8Y5Ef1IVT5X3D+Vh/NSNe4OPij4KHgAm
	 kBZKXQXRkZbMl7GsvZDAISa8j/hKRjxLIbeoVDB57amNECR3Cv9aLiy8Kv1a6h1tJD
	 HzSWaAPVXCIxA==
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
Subject: [PATCH AUTOSEL 7.0-6.18] iommu/amd: Fix illegal cap/mmio access in IOMMU debugfs
Date: Mon, 20 Apr 2026 09:21:32 -0400
Message-ID: <20260420132314.1023554-298-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guanghui Feng <guanghuifeng@linux.alibaba.com>

[ Upstream commit 0e59645683b7b6fa20eceb21a6f420e4f7412943 ]

In the current AMD IOMMU debugfs, when multiple processes simultaneously
access the IOMMU mmio/cap registers using the IOMMU debugfs, illegal
access issues can occur in the following execution flow:

1. CPU1: Sets a valid access address using iommu_mmio/capability_write,
and verifies the access address's validity in iommu_mmio/capability_show

2. CPU2: Sets an invalid address using iommu_mmio/capability_write

3. CPU1: accesses the IOMMU mmio/cap registers based on the invalid
address, resulting in an illegal access.

This patch modifies the execution process to first verify the address's
validity and then access it based on the same address, ensuring
correctness and robustness.

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
- **Subsystem**: iommu/amd (AMD IOMMU driver, debugfs interface)
- **Action verb**: "Fix" — explicitly a bug fix
- **Summary**: Fixes illegal cap/mmio register access in IOMMU debugfs
  caused by a TOCTOU race condition

### Step 1.2: Tags
- `Signed-off-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>` —
  author
- `Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>` — IOMMU subsystem
  maintainer applied it
- No Fixes: tag (expected for autosel candidates)
- No Cc: stable (expected for autosel candidates)
- No Reported-by or syzbot tags

### Step 1.3: Commit Body
The commit describes a clear TOCTOU race condition between concurrent
processes:
1. CPU1 writes a valid offset and show function verifies it
2. CPU2 writes an invalid offset (overwriting shared state)
3. CPU1 reads MMIO/PCI config using the now-invalid offset → illegal
   access

**Bug description**: Concurrent debugfs access allows one process to
modify the shared `dbg_mmio_offset`/`dbg_cap_offset` between validation
and use in another process.
**Failure mode**: Out-of-bounds MMIO read or PCI config space read.

### Step 1.4: Hidden Bug Fix Assessment
Not hidden — this is explicitly described as a race condition fix.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 — `drivers/iommu/amd/debugfs.c`
- **Lines**: ~19 added, ~23 removed (net -4)
- **Functions modified**: `iommu_mmio_write`, `iommu_mmio_show`,
  `iommu_capability_write`, `iommu_capability_show`
- **Scope**: Small, single-file surgical fix

### Step 2.2: Code Flow Change

**Write functions (mmio + capability)**:
- **Before**: Parse user input directly into shared
  `iommu->dbg_mmio_offset`/`iommu->dbg_cap_offset`, then validate
- **After**: Parse into local variable, validate, then store to shared
  field only if valid

**Show functions (mmio + capability)**:
- **Before**: Check `iommu->dbg_*_offset < 0`, then use
  `iommu->dbg_*_offset` for MMIO/PCI access
- **After**: Snapshot shared field to local variable, validate both
  lower AND upper bounds on the local copy, then use local copy for
  access

### Step 2.3: Bug Mechanism
**Category**: Race condition / TOCTOU (Time-of-check-to-time-of-use)

The shared fields `dbg_mmio_offset` and `dbg_cap_offset` in the
`amd_iommu` structure are accessed without synchronization. Between the
validity check in `_show()` and the actual register access, another
process can call `_write()` which:
1. First sets the shared field to -1
2. Then parses user input directly into it (potentially invalid value)
3. Then validates — but the other CPU has already passed its check

The fix uses a standard local-variable-snapshot pattern to eliminate the
TOCTOU window.

### Step 2.4: Fix Quality
- **Obviously correct**: Yes — local variable snapshot is a well-
  established pattern
- **Minimal**: Yes — only changes the four affected functions
- **Regression risk**: Very low — the semantics are preserved, only the
  race window is eliminated
- **Additional defense**: Show functions now also validate the upper
  bound (previously only write validated upper bound), adding defense-
  in-depth

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy code was introduced by:
- `7a4ee419e8c14` ("iommu/amd: Add debugfs support to dump IOMMU MMIO
  registers") — authored 2025-07-02, first in v6.17-rc1
- `4d9c5d5a1dc94` ("iommu/amd: Add debugfs support to dump IOMMU
  Capability registers") — authored 2025-07-02, first in v6.17-rc1

### Step 3.2: Fixes tag
No Fixes: tag present. The bug was introduced by the two commits above.

### Step 3.3: File History
The file has had limited changes since the debugfs features were added
in v6.17. One intermediate fix exists: `a0c7005333f9a` (OOB fix changing
`-4` to `sizeof(u64)`), which is in v6.19-rc1+.

### Step 3.4: Author
Guanghui Feng (Alibaba) is not the subsystem maintainer but has multiple
iommu-related fixes in the tree. Joerg Roedel (IOMMU maintainer) applied
and signed off.

### Step 3.5: Dependencies
This is patch 2/2 in a series. Patch 1/2 fixes the same class of TOCTOU
race for `sbdf` (device-id) in different functions. The two patches
modify **non-overlapping functions** in the same file, so they are
functionally independent. The OOB fix `a0c7005333f9a` is a prerequisite
for clean context matching in v6.19+.

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Original Discussion
Found at: `https://yhbt.net/lore/lkml/20260319073754.651998-1-
guanghuifeng@linux.alibaba.com/T/`

Key findings:
- **Jörg Rödel (maintainer)**: "Applied, thanks. **this patch-set fixes
  pretty serious issues**. Can you please further review the AMD IOMMU
  debugfs code to make it more robust and secure?"
- **Vasant Hegde (AMD)**: "Looks good. Reviewed-by: Vasant Hegde"
- Only one version (v1) submitted, no revisions needed
- No NAKs or concerns raised

### Step 4.2: Reviewers
- Sent to: joro (Joerg Roedel), suravee.suthikulpanit, will (Will
  Deacon), robin.murphy
- CC: iommu list, linux-kernel
- Reviewed and applied by appropriate maintainers

### Step 4.3-4.5: Bug Reports / Stable Discussion
No specific bug report link, but the author mentions monitoring scripts
as a real-world trigger scenario. No prior stable discussion found.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
Modified: `iommu_mmio_write`, `iommu_mmio_show`,
`iommu_capability_write`, `iommu_capability_show`

### Step 5.2: Callers
These are debugfs file operation callbacks (via
`DEFINE_SHOW_STORE_ATTRIBUTE`). They're called when userspace
reads/writes `/sys/kernel/debug/iommu/amd/iommuXX/mmio` and
`.../capability`.

### Step 5.3-5.4: Call Chain
- Userspace `echo "0x18" > .../mmio` → VFS write → `iommu_mmio_write`
- Userspace `cat .../mmio` → VFS read → seq_file open →
  `iommu_mmio_show`
- Both reachable from userspace (root-only via debugfs)
- `readq(iommu->mmio_base + offset)` performs MMIO access — OOB offset
  can cause machine check
- `pci_read_config_dword(iommu->dev, cap_ptr + offset, ...)` performs
  PCI config space access

### Step 5.5: Similar Patterns
Patch 1/2 in the same series fixes the identical TOCTOU pattern for the
`sbdf` global variable in `devid_show`, `iommu_devtbl_show`, and
`iommu_irqtbl_show`.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code Existence
- **v6.12 LTS and earlier**: Code does NOT exist (debugfs was minimal)
- **v6.17.y**: Code exists (buggy code first introduced here, with
  `mmio_phys_end - 4`)
- **v6.18.y**: Code exists (same as v6.17 context)
- **v6.19.y**: Code exists (with `sizeof(u64)` from OOB fix)
- **v7.0**: Code exists (matches patch context exactly)

### Step 6.2: Backport Complications
- v6.19.y / v7.0.y: Should apply cleanly (context matches)
- v6.17.y / v6.18.y: Need minor adjustment (`mmio_phys_end - 4` vs
  `sizeof(u64)`)

### Step 6.3: Related Fixes Already in Stable
No. The race fix has not been applied anywhere yet.

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **Path**: `drivers/iommu/amd/` — AMD IOMMU driver
- **Criticality**: IMPORTANT — IOMMU is critical infrastructure for AMD
  systems, though debugfs is a debugging interface

### Step 7.2: Activity
Active subsystem with regular updates.

## PHASE 8: IMPACT AND RISK

### Step 8.1: Affected Users
Systems with AMD IOMMU hardware using debugfs for monitoring/debugging.
Monitoring scripts that concurrently access IOMMU debugfs are
specifically mentioned.

### Step 8.2: Trigger Conditions
- Requires root access (debugfs)
- Requires concurrent access to the same IOMMU's debugfs files
- Realistic in monitoring script scenarios
- Unprivileged users cannot trigger it

### Step 8.3: Failure Mode Severity
- **OOB MMIO read**: Can cause machine check exception → system crash
  (CRITICAL)
- **OOB PCI config read**: Undefined behavior, potentially reading
  adjacent config space (HIGH)
- Combined severity: **HIGH** (requires root + concurrency, but
  consequences are severe)

### Step 8.4: Risk-Benefit
- **Benefit**: Prevents system crash / machine check from concurrent
  debugfs access
- **Risk**: Very low — local variable snapshot is a trivial, well-
  understood pattern; 19 lines added
- **Ratio**: Favorable for backport

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a genuine TOCTOU race leading to OOB MMIO/PCI access
- IOMMU maintainer (Jörg Rödel) explicitly called it "pretty serious
  issues"
- Reviewed-by from AMD IOMMU developer (Vasant Hegde)
- Small, surgical fix (single file, ~19 lines added, well-understood
  pattern)
- No new features or API changes
- Realistic trigger scenario (monitoring scripts)

**AGAINST backporting:**
- Requires root access + concurrent debugfs access
- Buggy code is relatively new (v6.17+, not in LTS trees ≤6.12)
- Part of 2-patch series (but functionally independent)
- Needs minor adjustment for v6.17/v6.18 stable trees

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — standard TOCTOU fix pattern,
   reviewed by maintainer
2. Fixes a real bug? **YES** — race condition causing OOB hardware
   access
3. Important issue? **YES** — can cause machine check/system crash
4. Small and contained? **YES** — single file, ~19 lines
5. No new features? **YES** — purely fixes race condition
6. Can apply to stable? **YES** — clean apply to v6.19.y/v7.0.y; minor
   adjustment for v6.17/v6.18

### Step 9.3: Exception Categories
Not an exception category — this is a standard bug fix.

### Step 9.4: Decision
The fix is well-contained, obviously correct, addresses a real race
condition that can cause system crashes, and was explicitly
characterized as "pretty serious" by the IOMMU subsystem maintainer. The
risk of regression is negligible.

## Verification

- [Phase 1] Parsed tags: Signed-off-by from author and IOMMU maintainer
  Joerg Roedel
- [Phase 2] Diff analysis: 4 functions modified in single file, local
  variable snapshot pattern eliminates TOCTOU
- [Phase 3] git blame: buggy code introduced in `7a4ee419e8c14`
  (v6.17-rc1) and `4d9c5d5a1dc94` (v6.17-rc1), confirmed via `git
  describe --tags --contains`
- [Phase 3] git show: confirmed original commits added the vulnerable
  write/show pattern
- [Phase 3] Prerequisite `a0c7005333f9a` (OOB fix) confirmed in v6.19+
  via `git merge-base --is-ancestor`
- [Phase 4] Found original thread at yhbt.net lore mirror — Jörg Rödel
  said "Applied, thanks" and "fixes pretty serious issues"
- [Phase 4] Vasant Hegde gave Reviewed-by for both patches in the series
- [Phase 4] Only v1 submitted, no concerns or NAKs
- [Phase 5] Functions called via debugfs seq_file ops — reachable from
  root userspace; `readq()` on OOB offset can cause machine check
- [Phase 6] v6.12 LTS confirmed to NOT have the buggy code (verified via
  `git show v6.12:drivers/iommu/amd/debugfs.c`)
- [Phase 6] v6.17, v6.19 confirmed to have the buggy code
- [Phase 8] Failure mode: OOB MMIO read → potential machine check/crash;
  severity HIGH
- UNVERIFIED: Could not access lore.kernel.org directly (Anubis bot
  protection); used yhbt.net mirror instead

**YES**

 drivers/iommu/amd/debugfs.c | 42 +++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/iommu/amd/debugfs.c b/drivers/iommu/amd/debugfs.c
index 0b03e0622f67e..4e66473d7ceaf 100644
--- a/drivers/iommu/amd/debugfs.c
+++ b/drivers/iommu/amd/debugfs.c
@@ -26,22 +26,19 @@ static ssize_t iommu_mmio_write(struct file *filp, const char __user *ubuf,
 {
 	struct seq_file *m = filp->private_data;
 	struct amd_iommu *iommu = m->private;
-	int ret;
-
-	iommu->dbg_mmio_offset = -1;
+	int ret, dbg_mmio_offset = iommu->dbg_mmio_offset = -1;
 
 	if (cnt > OFS_IN_SZ)
 		return -EINVAL;
 
-	ret = kstrtou32_from_user(ubuf, cnt, 0, &iommu->dbg_mmio_offset);
+	ret = kstrtou32_from_user(ubuf, cnt, 0, &dbg_mmio_offset);
 	if (ret)
 		return ret;
 
-	if (iommu->dbg_mmio_offset > iommu->mmio_phys_end - sizeof(u64)) {
-		iommu->dbg_mmio_offset = -1;
-		return  -EINVAL;
-	}
+	if (dbg_mmio_offset > iommu->mmio_phys_end - sizeof(u64))
+		return -EINVAL;
 
+	iommu->dbg_mmio_offset = dbg_mmio_offset;
 	return cnt;
 }
 
@@ -49,14 +46,16 @@ static int iommu_mmio_show(struct seq_file *m, void *unused)
 {
 	struct amd_iommu *iommu = m->private;
 	u64 value;
+	int dbg_mmio_offset = iommu->dbg_mmio_offset;
 
-	if (iommu->dbg_mmio_offset < 0) {
+	if (dbg_mmio_offset < 0 || dbg_mmio_offset >
+			iommu->mmio_phys_end - sizeof(u64)) {
 		seq_puts(m, "Please provide mmio register's offset\n");
 		return 0;
 	}
 
-	value = readq(iommu->mmio_base + iommu->dbg_mmio_offset);
-	seq_printf(m, "Offset:0x%x Value:0x%016llx\n", iommu->dbg_mmio_offset, value);
+	value = readq(iommu->mmio_base + dbg_mmio_offset);
+	seq_printf(m, "Offset:0x%x Value:0x%016llx\n", dbg_mmio_offset, value);
 
 	return 0;
 }
@@ -67,23 +66,20 @@ static ssize_t iommu_capability_write(struct file *filp, const char __user *ubuf
 {
 	struct seq_file *m = filp->private_data;
 	struct amd_iommu *iommu = m->private;
-	int ret;
-
-	iommu->dbg_cap_offset = -1;
+	int ret, dbg_cap_offset = iommu->dbg_cap_offset = -1;
 
 	if (cnt > OFS_IN_SZ)
 		return -EINVAL;
 
-	ret = kstrtou32_from_user(ubuf, cnt, 0, &iommu->dbg_cap_offset);
+	ret = kstrtou32_from_user(ubuf, cnt, 0, &dbg_cap_offset);
 	if (ret)
 		return ret;
 
 	/* Capability register at offset 0x14 is the last IOMMU capability register. */
-	if (iommu->dbg_cap_offset > 0x14) {
-		iommu->dbg_cap_offset = -1;
+	if (dbg_cap_offset > 0x14)
 		return -EINVAL;
-	}
 
+	iommu->dbg_cap_offset = dbg_cap_offset;
 	return cnt;
 }
 
@@ -91,21 +87,21 @@ static int iommu_capability_show(struct seq_file *m, void *unused)
 {
 	struct amd_iommu *iommu = m->private;
 	u32 value;
-	int err;
+	int err, dbg_cap_offset = iommu->dbg_cap_offset;
 
-	if (iommu->dbg_cap_offset < 0) {
+	if (dbg_cap_offset < 0 || dbg_cap_offset > 0x14) {
 		seq_puts(m, "Please provide capability register's offset in the range [0x00 - 0x14]\n");
 		return 0;
 	}
 
-	err = pci_read_config_dword(iommu->dev, iommu->cap_ptr + iommu->dbg_cap_offset, &value);
+	err = pci_read_config_dword(iommu->dev, iommu->cap_ptr + dbg_cap_offset, &value);
 	if (err) {
 		seq_printf(m, "Not able to read capability register at 0x%x\n",
-			   iommu->dbg_cap_offset);
+			   dbg_cap_offset);
 		return 0;
 	}
 
-	seq_printf(m, "Offset:0x%x Value:0x%08x\n", iommu->dbg_cap_offset, value);
+	seq_printf(m, "Offset:0x%x Value:0x%08x\n", dbg_cap_offset, value);
 
 	return 0;
 }
-- 
2.53.0

