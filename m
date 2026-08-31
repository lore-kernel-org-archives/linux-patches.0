Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA6157D20F;
	Mon, 31 Aug 2026 13:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184174; cv=none; b=jPIFohdjRbBA1+GDgw3dHUTrS26OLc0ij7ysIACDKq3qCfn4VzqOKRzFnpn8kS94kmE3WtflnLw5wuPuaUJZ96OG2m3gIWJfYaehxhTc4A+Fw8MJBscrc3DpbHzRoTZRv3RZL7cJ6RdWRLuoVTsaaMh97lwnOdoKWSXn6Gt+qTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184174; c=relaxed/simple;
	bh=6RtPStU5jN0itZ9YiHwnhITWHtgU5Y9I/B3l3kDmN7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kpW11uZCB2XJ4jh8nsr+XckoS0ex8u234PkC6BCVjSIBhmNdYDdwNXpMajV/7qVtrEws+rsmslUM1PDIVVBDA68pTYR+Rad4ZVLhJxx6YVmCfJi9fiYxoLbj6CE232G+tn5se8OjGo0UtMFeZRb6gf3KBYm8J5fhZ/uP3xObJPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NnmoUQMp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NnmoUQMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9188C1F00ACA;
	Mon, 31 Aug 2026 13:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184172;
	bh=ca+0xzSygstzOkzBHNE9FXzmokfjrnGBVeQ88zmKoiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NnmoUQMptegz9vfkoDszxmtreKt6m9q025Om8gYntNCGJ2D26kD5sRn3EAv8plHKj
	 AUfjnIeBz5NrfV4EGkwkefZoaBqx0D/nXtfljN5d8LCEvYB7JhlgJyzyoRRlMScecR
	 D2C93dz2PNo3U/+4/TcgPgXMnvg7g8VUDDQNDCL6VnTOe7sv/TtCed0Qs8PJD/yWyZ
	 5yBDWYSjAXpkvLNP5Zn/zZxU+P/KzZbI5COWoFOeU4+gtlGgCrQSY0L6tIOHHoRc/p
	 bRL2FDaA17sheuTQsNDBRAbuqco2ITWWaznq1CGnzS0TlCKy/QphxlGakH067HtTo7
	 kuGx6bowgOy1A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] PCI/sysfs: Use kstrtobool() to parse the ROM attribute input
Date: Mon, 31 Aug 2026 09:29:22 -0400
Message-ID: <20260831133314.4125787-534-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

[ Upstream commit 92742802ecbf215a2b60dcfd326d2213595010f1 ]

pci_write_rom() controls access to the ROM content through the
corresponding sysfs attribute, and treats the input as a request to
disable only when it matches the string "0\n" exactly:

  if ((off ==  0) && (*buf == '0') && (count == 2))

The count == 2 condition encodes the trailing newline that echo(1) appends.
This was found when userspace wrote "0" without a trailing newline aiming
to disable access, which failed to match the condition above and enabled
access instead.  For example:

  $ echo 0 > rom       # "0\n", count 2, access disabled
  $ echo -n 0 > rom    # "0", count 1, access enabled
  $ echo > rom         # "", count 1, access enabled (likely not desirable)

Parse the input with kstrtobool(), which handles common boolean inputs such
as "0", "1", "n", "y" or "off", "on", with or without a trailing newline,
so both of the above disable access, and update the now stale comment.

As a side effect, input that does not parse as a boolean is rejected with
-EINVAL rather than enabling access.  The documented "0" and "1" continue
to work as before, and rejecting malformed input brings the attribute in
line with how sysfs attributes typically handle it.

Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260612182448.552406-1-kwilczynski@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[PCI/sysfs] [use] Use kstrtobool() to parse the ROM
attribute input` — sysfs input-parsing fix in the PCI ROM bin_attribute
write path.

### Step 1.2: Tags
**Record:**
- **Link:** `https://patch.msgid.link/20260612182448.552406-1-
  kwilczynski@kernel.org`
- **Signed-off-by:** Krzysztof Wilczyński, Bjorn Helgaas (PCI
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable

Notable: maintainer sign-off (Bjorn Helgaas), no fuzzer/user bug report
tags.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `pci_write_rom()` only disables ROM sysfs access when input
  is exactly `"0\n"` (`count == 2`). `"0"` without newline (`count ==
  1`) is treated as enable.
- **Symptom:** `echo -n 0 > rom` enables access instead of disabling;
  empty write also enables.
- **Root cause:** Manual parsing tied disable to `count == 2` (echo’s
  trailing newline), not to boolean `"0"`.
- **Fix:** Use `kstrtobool()`; reject invalid input with `-EINVAL`.

### Step 1.4: Hidden bug fix?
**Record:** Yes — described as parsing improvement, but it fixes
inverted enable/disable semantics and undocumented dependence on a
trailing newline.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/pci/pci-sysfs.c` (~+4/-3 net)
- **Function:** `pci_write_rom()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow
**Record:**
- **Before:** Disable only if `off==0 && *buf=='0' && count==2`;
  everything else enables.
- **After:** Parse with `kstrtobool()`; on failure return `-EINVAL`;
  otherwise set `pdev->rom_attr_enabled = enable`.
- **Path:** sysfs write to PCI `rom` bin_attribute (root-only, mode
  0600).

### Step 2.3: Bug mechanism
**Record:** **Logic/correctness fix** — fragile string/count check
instead of boolean parsing; violates documented “write 0 to disable”
semantics for writes without `\n`.

### Step 2.4: Fix quality
**Record:** Obviously correct, minimal, matches PCI sysfs patterns
(author’s 2021 kstrtobool series for other attrs). Low regression risk;
`kstrtobool()` only inspects `s[0]` (and `s[1]` for `on`/`off`), so it
is safe on sysfs buffers that may lack a trailing `NUL`.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Buggy `count == 2` logic dates to `1da177e4c3f41` (2005,
Linux 2.6.12-rc2). Present in this tree at lines 1319–1322.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related history
**Record:** Related PCI sysfs work by same author merged earlier
(`36f354ec7bf92` EINVAL consistency, `95e83e219d689` CAP_SYS_ADMIN
checks). A 2021 series ([spinics
msg110641](https://www.spinics.net/lists/linux-pci/msg110641.html))
included this `pci_write_rom()` change but the ROM hunk was not merged
then; this 2026 commit is standalone.

### Step 3.4: Author context
**Record:** Krzysztof Wilczyński is an active PCI sysfs contributor;
Bjorn Helgaas signed off.

### Step 3.5: Dependencies
**Record:** None. `kstrtobool()` exists in `lib/kstrtox.c`; `bool` and
`rom_attr_enabled` exist in this tree. Applies standalone.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:** `b4 dig -c <sha>` failed (commit not in this checkout).
WebFetch of patch.msgid.link blocked (bot protection). Spinics 2021
series confirms intent and prior ROM fix that was not merged. No stable
nomination found in available threads.

### Step 4.2: Reviewers
**Record:** Bjorn Helgaas sign-off verified from commit message; 2021
series CC’d `linux-pci@`.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link; author discovered via
`echo -n 0` testing.

### Step 4.4: Series context
**Record:** Standalone 2026 commit; not part of an unmerged multi-patch
dependency chain.

### Step 4.5: Stable list
**Record:** No stable-list discussion found (WebSearch + blocked lore
fetch).

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `pci_write_rom()`, `pci_read_rom()` (read path checks
`rom_attr_enabled`).

### Step 5.2: Callers
**Record:** `pci_write_rom` registered via `BIN_ATTR(rom, 0600,
pci_read_rom, pci_write_rom, 0)`; invoked from `sysfs_kf_bin_write()` on
root write to `/sys/bus/pci/devices/.../rom`.

### Step 5.3: Callees
**Record:** `kstrtobool()`, `to_pci_dev()`, sets
`pdev->rom_attr_enabled`.

### Step 5.4: Reachability
**Record:** Reachable by root (CAP_SYS_ADMIN) writing sysfs; documented
workflow: write `1` to enable ROM read, `0` to disable ([PCI sysfs
docs](https://www.kernel.org/doc/html/latest/PCI/sysfs-pci.html)).

### Step 5.5: Similar patterns
**Record:** `kstrtobool(buf, ...)` is standard in sysfs store handlers
across the tree; PCI sysfs already uses it elsewhere after the 2021
series.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy code present?
**Record:** **Yes.** Local tree is **6.18.44** (`git describe`:
`v6.18.44-1-g2736c32da98b9`). Buggy code at `drivers/pci/pci-
sysfs.c:1319-1322`. Fix not present (`git log -S 'kstrtobool(buf,
&enable)' -- drivers/pci/pci-sysfs.c` returned nothing).

### Step 6.2: Backport complications
**Record:** Clean apply expected — small hunk, no structural conflicts
observed.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix in this tree; EINVAL consistency work
exists but not for `pci_write_rom()`.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem
**Record:** `drivers/pci` sysfs — **IMPORTANT** (core hardware
enumeration; affects all PCI platforms).

### Step 7.2: Activity
**Record:** Actively maintained; recent PCI sysfs commits in file
history.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Root/admin or tools writing to PCI `rom` sysfs without a
trailing newline (e.g. `echo -n 0`, `write(fd, "0", 1)`).

### Step 8.2: Trigger conditions
**Record:** Uncommon vs plain `echo 0`, but valid per kernel docs and
normal for programmatic sysfs clients. Root-only.

### Step 8.3: Failure mode severity
**Record:** **MEDIUM** — no crash/corruption, but inverted access-
control semantics: disable request enables ROM reads. Documented API
behavior is wrong for `"0"` without `\n`.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Correct boolean parsing; aligns with docs and other PCI
  sysfs attrs; rejects garbage with `-EINVAL`.
- **Risk:** Very low (~5 lines, established API).
- **Ratio:** Favorable for stable despite modest severity.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR:**
- Real, reproducible logic bug (`echo -n 0` inverts intent)
- Violates documented “write 0 to disable” semantics
- Present since 2005 in this tree
- Tiny, maintainer-reviewed fix
- `kstrtobool()` already in tree
- Consistent with prior PCI sysfs input-validation work

**AGAINST:**
- No crash, deadlock, or data corruption
- Root-only sysfs (0600)
- Common `echo 0` path works
- No syzbot/user reports
- Borderline on stable “important issue” bar

**Unresolved:** Full lore thread for 20260612 patch (fetch blocked); no
explicit stable nomination found.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — straightforward; maintainer
   SOB; no Tested-by.
2. Fixes a real bug? **PASS** — inverted enable/disable on valid input.
3. Important issue? **PASS (borderline)** — access-control semantics +
   documented API violation; not a crash fix.
4. Small and contained? **PASS**
5. No new features/APIs? **PASS** — behavior extension to
   `y`/`n`/`on`/`off` is minor and consistent with `kstrtobool()`
   elsewhere.
6. Can apply to local tree? **PASS**

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs-only).

### Step 9.4: Decision rationale
For **Linux 6.18.y**, the buggy code exists and the fix is absent. The
bug causes the opposite of the documented disable operation when `"0"`
is written without a newline — a longstanding sysfs correctness issue
with very low backport risk. That meets stable criteria, albeit at
modest severity.

---

## Verification

- [Phase 1] Parsed subject, tags, body from user-provided commit message
- [Phase 2] Read diff and current `pci_write_rom()` at `drivers/pci/pci-
  sysfs.c:1313-1325`
- [Phase 2] Read `pci_read_rom()` gate at lines 1347-1348
- [Phase 3] `git describe HEAD` → `v6.18.44-1-g2736c32da98b9`; Makefile
  → 6.18.44
- [Phase 3] `git blame -L 1302,1325 drivers/pci/pci-sysfs.c` → buggy
  logic from `1da177e4c3f41` (2005)
- [Phase 3] `git show 1da177e4c3f41:...` confirmed original `count == 2`
  logic
- [Phase 3] `git log -S 'kstrtobool(buf, &enable)' -- drivers/pci/pci-
  sysfs.c` → empty (fix not in tree)
- [Phase 3] `git log --author='Krzysztof Wilczyński' -- drivers/pci/pci-
  sysfs.c` → related EINVAL/CAP_SYS_ADMIN commits
- [Phase 4] `b4 dig` by commit hash → failed (commit not in checkout)
- [Phase 4] WebFetch patch.msgid.link → blocked by bot protection
- [Phase 4] WebFetch spinics msg110641 → 2021 series with same ROM fix
  (not merged then)
- [Phase 4] WebSearch → confirmed commit subject and merge context
- [Phase 5] Traced sysfs path via `fs/sysfs/file.c:150-168`
  (`sysfs_kf_bin_write`)
- [Phase 5] Read `kstrtobool()` at `lib/kstrtox.c:348-392` — only reads
  first 1–2 bytes
- [Phase 5] `grep kstrtobool(buf` in drivers → widespread sysfs pattern
- [Phase 6] Confirmed buggy code present, fix absent in 6.18.44 checkout
- [Phase 6] `grep rom_attr_enabled` → only `pci-sysfs.c` and
  `include/linux/pci.h`
- [Phase 8] Kernel PCI sysfs docs confirm write `"0"` to disable ROM
  access
- [Phase 8] `BIN_ATTR(rom, 0600, ...)` at line 1366 → root read/write
  only

**YES****Result:** For the checked-out **6.18.44** tree, this commit
should be backported.

`pci_write_rom()` only disables ROM sysfs access when the write is
exactly `"0\n"` (`count == 2`). Writing `"0"` without a newline (e.g.
`echo -n 0`) incorrectly **enables** access instead of disabling it,
which contradicts the documented “write 0 to disable” behavior. The fix
is small (switch to `kstrtobool()`), low risk, and the buggy code is
still present in this tree — the fix is not merged here yet.

 drivers/pci/pci-sysfs.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 990994db752ab..39e4a5b3e5739 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1308,18 +1308,19 @@ void __weak pci_remove_resource_files(struct pci_dev *dev) { return; }
  * @off: file offset
  * @count: number of byte in input
  *
- * writing anything except 0 enables it
+ * Writing a boolean value enables or disables the ROM display.
  */
 static ssize_t pci_write_rom(struct file *filp, struct kobject *kobj,
 			     const struct bin_attribute *bin_attr, char *buf,
 			     loff_t off, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(kobj_to_dev(kobj));
+	bool enable;
 
-	if ((off ==  0) && (*buf == '0') && (count == 2))
-		pdev->rom_attr_enabled = 0;
-	else
-		pdev->rom_attr_enabled = 1;
+	if (kstrtobool(buf, &enable))
+		return -EINVAL;
+
+	pdev->rom_attr_enabled = enable;
 
 	return count;
 }
-- 
2.53.0

