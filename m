Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A4B4D90A6;
	Mon, 31 Aug 2026 13:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183557; cv=none; b=UZjwAU8L3gtbI4ly5s9CozGKrdHYqIGbMH+FF5BiFmiH0dOWnav9rCioFWKGA0JcnrPCnyRFfNzKDgvCZIp0tXECz7RsjmUJbc9rD9C5hLgAnVUN7sYaY4kZoZ/9ic0bp7sJ8piSK/FwUQ2fYG4C1o79iGKHpozCoTJTfudgQwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183557; c=relaxed/simple;
	bh=zXSEC+PScyHpIcyKNxQf7u+rMee1LdsYgIq7m0w8Dos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U/OL4aWgAQM08bhUYZqs2gfd5GH3ZzpPiJxtd5tIk3DMasN+Hdyb3T0Wy035j/Mxa8ptOhTGksGMf2mq1d7q4alRx4TGoIOwYWqGzOOPixHKdSJtReH/KRZMrgenltAz8Mw945h2gzNvAwJYF8kmknanXb4mxfagYTYVC5tnpYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A2jh3rVm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A2jh3rVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4B61F000E9;
	Mon, 31 Aug 2026 13:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183554;
	bh=rBbaTnPP66E6NVrCPUIGYm100iaFgrQu/I6rBFxujmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A2jh3rVmUidxYIGGQqd+LPYGWYVB6eJQHzGODv2NEvMYkZ5qr/Srz8Wla9hNP8BqD
	 vd1UWsy2PZaQ2HXX0e2hd//eibRjeezadMlPEerz79A7jDca1HIrXNL3yr/anXTF6z
	 H/FQQLArCqylazcWG1I6hhrcZWrmxjVDmqhJw1wgBtkyQRyOTnrqMHO9hV2HJHmKDb
	 jjoj2i6tbQJk/Ma5cfoZPY2gzHCAdK3ofqO4CjO+U5R8Od10nyFu3Niov6MTfmO+w5
	 iHeeCX8QqeA8nb9ylMOQpTFcTH/sNR1WltLg4VW194Yt/nsNVludP1Hxh/ViFPxfsY
	 kwZ6QT3ns2IrA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: liyouhong <liyouhong@kylinos.cn>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ata: ahci: fail probe if BAR too small for claimed ports
Date: Mon, 31 Aug 2026 09:23:14 -0400
Message-ID: <20260831133314.4125787-166-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: liyouhong <liyouhong@kylinos.cn>

[ Upstream commit c4086c6e1af757e1ff26fa2d2926b3ec0195de79 ]

When an AHCI controller is disabled in BIOS, its HOST_CAP register may
contain a bogus value, e.g. 0xFFFFFFFF.

Since CAP.NP (Number of Ports) is a zeroes based 5-bit register field,
a value of 0x1f means 32 ports. If CAP.NP claims more ports than can
physically fit within the mapped BAR region, accessing port registers
beyond the BAR boundary causes a kernel panic.

Add validation in ahci_init_one() to check that the BAR size is
sufficient for the number of ports claimed in CAP.NP. The check
calculates the required MMIO size as:

  required_size = 0x100 (global registers) + max_ports * 0x80

If required_size exceeds the actual BAR size, the probe fails with
-ENODEV, preventing the panic and providing a clear error message.

Reported-by: liyouhong <liyouhong@kylinos.cn>
Closes: https://lore.kernel.org/all/20260422080322.1006592-1-dayou5941@163.com/
Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Suggested-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: liyouhong <liyouhong@kylinos.cn>
[cassel: commit log]
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ata: ahci: fail probe if BAR too small for
claimed ports`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ata: ahci]` `[fail]` — Fail AHCI PCI probe when the mapped
BAR is smaller than the MMIO space required by the port count claimed in
`HOST_CAP.NP`.

### Step 1.2: Tags
**Record:**
- **Reported-by:** liyouhong \<liyouhong@kylinos.cn\> — real-world
  reporter (Kylin OS)
- **Closes:** https://lore.kernel.org/all/20260422080322.1006592-1-
  dayou5941@163.com/ — original bug report thread
- **Suggested-by:** Damien Le Moal \<dlemoal@kernel.org\>, Niklas Cassel
  \<cassel@kernel.org\>
- **Reviewed-by:** Damien Le Moal \<dlemoal@kernel.org\> — libata
  maintainer review
- **Signed-off-by:** liyouhong, Niklas Cassel
- No `Fixes:`, no `Cc: stable@vger.kernel.org` (expected for manual
  review)
- No syzbot / sanitizer tags

### Step 1.3: Body analysis
**Record:**
- **Bug:** When an AHCI controller is disabled in BIOS, `HOST_CAP` can
  read as `0xFFFFFFFF`. `CAP.NP` (5-bit, zero-based) then reports 32
  ports. The driver later accesses per-port MMIO at `0x100 + port *
  0x80`, which can extend past the actual BAR → **kernel panic**.
- **Symptom:** Kernel panic during AHCI probe (boot-time PCI
  enumeration).
- **Root cause:** No validation that BAR size can accommodate all ports
  implied by `CAP.NP`.
- **Fix:** In `ahci_init_one()`, after `pcim_iomap()`, compute
  `required_size = 0x100 + max_ports * 0x80`; if it exceeds
  `pci_resource_len()`, return `-ENODEV` with a warning.

### Step 1.4: Hidden bug fix?
**Record:** Not disguised — this is an explicit crash-prevention fix,
not cleanup or optimization.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/ata/ahci.c` only (+22 / -0)
- **Functions:** New `ahci_validate_bar_size()`; call added in
  `ahci_init_one()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (new function):** After MMIO mapping, read `HOST_CAP`, derive
  `max_ports` via `ahci_nr_ports()`, compute `last_port_end = 0x100 +
  max_ports * 0x80`, compare to `pci_resource_len()`. Return `-ENODEV`
  if BAR is too small.
- **Hunk 2 (`ahci_init_one`):** Call validation immediately after
  `pcim_iomap()`, before `ahci_remap_check()` and
  `ahci_pci_save_initial_config()`.
- **Path affected:** PCI probe initialization path (normal boot, not
  error recovery).

### Step 2.3: Bug mechanism
**Record:** **Buffer overflow / out-of-bounds MMIO access.** Bogus
`CAP.NP` causes the driver to touch port register space beyond the
mapped BAR. Downstream accessors like `__ahci_port_base()` and
`readl(port_mmio + PORT_CMD)` in `ahci_save_initial_config()` and
`ahci_mark_external_port()` can panic.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Matches AHCI register layout (`0x100` global +
  `0x80` per port); uses existing `ahci_nr_ports()` helper.
- **Minimal:** 22 lines, no unrelated changes.
- **Regression risk:** Very low. Legitimate controllers have BARs sized
  for their port count; only broken/disabled configurations are
  rejected.
- **False negative risk:** A controller with bogus `CAP` but a large
  enough BAR could still probe; that is not worse than today and is
  outside this patch’s scope.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `pcim_iomap()` at lines 1987–1989 last touched by
`bdcddd0cdc39d` (Oct 2024, PCI deprecation cleanup). The missing
validation has been present since `ahci_init_one()` existed; the
vulnerability is long-standing, not a recent regression.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:**
- Related but distinct: `62ced8e065787` — “Do not read the per port area
  for unimplemented ports” (PI-register compliance; does not address
  bogus `CAP.NP` vs BAR size).
- No other “BAR too small” fix in this tree.
- Patch series: v2 → v5 (Apr 25–28, 2026); committed version is v5.

### Step 3.4: Author context
**Record:** liyouhong is the reporter/fix author. Niklas Cassel
(AHCI/libata maintainer) applied the patch. Damien Le Moal (libata
maintainer) reviewed it.

### Step 3.5: Dependencies
**Record:** **Standalone.** Uses `ahci_nr_ports()` (inline in `ahci.h`
since `365cfa1ed5a36`), `readl()`, `pci_resource_len()`, `HOST_CAP` —
all present in 6.18.44. No series prerequisites.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **b4 dig -c c4086c6:**
  https://patch.msgid.link/20260428020935.2049617-1-dayou5941@163.com
- **b4 dig -a:** v2 (Apr 25), v3/v4 (Apr 27), v5 (Apr 28, 2026) —
  committed version is latest
- **Key feedback:** Niklas Cassel applied to libata `for-7.2`, corrected
  commit-log wording about `CAP.NP` range (1–32 is valid per spec; the
  issue is BAR mismatch, not “impossible” port count). No NAKs.

### Step 4.2: Reviewers
**Record:** **b4 dig -w** CC’d: `linux-ide@vger.kernel.org`,
`dlemoal@kernel.org`, `cassel@kernel.org`, `liyouhong@kylinos.cn`.
Appropriate maintainers were involved.

### Step 4.3: Bug report
**Record:** Reported-by from Kylin OS. Commit Closes original report at
lore `20260422080322`. Panic mechanism described in patch and maintainer
reply. No stack trace in the retrieved mbox thread, but the OOB MMIO
path is verifiable in code.

### Step 4.4: Series context
**Record:** Standalone 1/1 patch. Five revision rounds addressed review
feedback; no companion patches required.

### Step 4.5: Stable list history
**Record:** No `Cc: stable` nomination found in the retrieved thread.
Absence is not a negative signal per review instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ahci_validate_bar_size()` (new), `ahci_init_one()`,
`ahci_nr_ports()`, `ahci_pci_save_initial_config()` →
`ahci_save_initial_config()`, `__ahci_port_base()`.

### Step 5.2: Callers
**Record:** `ahci_init_one()` is the `.probe` handler for
`ahci_pci_driver` (line 673), registered via `module_pci_driver()`.
Called during PCI device enumeration at boot or module load.

### Step 5.3: Callees
**Record:** `readl(hpriv->mmio + HOST_CAP)` (offset 0, always within
BAR), `ahci_nr_ports()`, `pci_resource_len()`.

### Step 5.4: Reachability
**Record:** **Userspace-triggerable indirectly** via PCI hotplug/module
load, but primary scenario is **boot** when the AHCI controller is
present in PCI space but disabled/misconfigured in BIOS. Any system with
`CONFIG_SATA_AHCI` and such hardware is affected.

### Step 5.5: Similar patterns
**Record:** `__ahci_port_base()` at `mmio + 0x100 + port_no * 0x80` is
the canonical layout used throughout AHCI. The validation formula
matches this exactly. No duplicate fix elsewhere in `drivers/ata/`.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current `ahci_init_one()` maps MMIO at line 1987
and proceeds directly to `ahci_remap_check()` /
`ahci_pci_save_initial_config()` with no BAR-size check.
`ahci_validate_bar_size()` is **absent**. Upstream commit `c4086c6` is
**not** an ancestor of HEAD (`merge-base --is-ancestor` exit 1).

### Step 6.2: Backport complications
**Record:** **Clean apply.** `git format-patch -1 c4086c6 --stdout | git
apply --check` succeeded on HEAD. Line context around `pcim_iomap()`
matches the patch.

### Step 6.3: Related fixes already present?
**Record:** `62ced8e065787` (skip unimplemented ports in
`ahci_mark_external_port`) is present but does not address this
BAR/CAP.NP mismatch. No duplicate BAR validation found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/ata/ahci** — IMPORTANT. AHCI is the standard SATA
driver on most x86/ARM desktops, laptops, and servers.

### Step 7.2: Activity
**Record:** Actively maintained in 6.18.y (recent commits: LPM quirks,
JMicron DMA, unimplemented-port fix). The underlying probe path is
mature; this bug has existed without validation for years.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Systems with an AHCI PCI device present but disabled or
misconfigured in BIOS (bogus `HOST_CAP`). Common on dual-controller or
unused-SATA configurations. Affects anyone building `CONFIG_SATA_AHCI`
(default on most distros).

### Step 8.2: Trigger conditions
**Record:** Boot or `modprobe ahci` when PCI enumerates a disabled AHCI
controller reporting `HOST_CAP = 0xFFFFFFFF` (or any `CAP.NP` value
whose port space exceeds BAR size). Not a race; deterministic on
affected hardware.

### Step 8.3: Failure mode severity
**Record:** **Kernel panic** from OOB MMIO access → **CRITICAL** (boot
failure, no graceful recovery).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents boot-time panic on real hardware; clear
  `-ENODEV` + warning instead.
- **Risk:** VERY LOW — 22-line defensive check, reviewed by maintainer,
  applies cleanly.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real kernel panic on probe (user-reported, Kylin OS)
- Reviewed by libata maintainer; applied by AHCI maintainer
- Small, self-contained, no dependencies
- Buggy code exists in 6.18.44; fix not yet present
- Applies cleanly
- Fails probe gracefully (`-ENODEV`) instead of panicking

**AGAINST backport:**
- None significant. Disabled-controller scenario is somewhat niche, but
  panic severity outweighs rarity.

**Unresolved:**
- Full stack trace from original bug report not retrieved (lore Anubis
  blocked direct fetch; mbox thread contained patch discussion, not the
  original oops log). Panic mechanism is confirmed by code path
  analysis.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — simple arithmetic;
   maintainer-reviewed; v5 after four revision rounds.
2. Fixes a real bug affecting users? **PASS** — Reported-by from
   production distro user.
3. Important issue? **PASS** — kernel panic (CRITICAL).
4. Small and contained? **PASS** — 22 lines, one file.
5. No new features or APIs? **PASS** — probe-time validation only.
6. Can apply to local tree? **PASS** — `git apply --check` clean on
   6.18.44.

### Step 9.3: Exception categories
**Record:** N/A (not a device ID, quirk, DT, build, or docs fix).
Qualifies on crash-fix merits alone.

### Step 9.4: Decision rationale
For Linux **6.18.44**, systems with a BIOS-disabled AHCI controller can
hit OOB MMIO during `ahci_init_one()` probe and panic the kernel. The
fix adds an early, spec-aligned BAR size check and fails probe safely.
It is small, maintainer-reviewed, standalone, and applies cleanly to
this tree. This is appropriate stable material.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; identified panic-on-probe
  bug with BIOS-disabled AHCI scenario.
- **[Phase 2]** Diff: +22 lines in `drivers/ata/ahci.c`; new
  `ahci_validate_bar_size()`, call in `ahci_init_one()`; OOB MMIO bug
  class.
- **[Phase 3]** `git blame -L 1987,1992 drivers/ata/ahci.c`: iomap area
  from `bdcddd0cdc39d` (2024); no `Fixes:` tag; related commit
  `62ced8e065787` is distinct; `ahci_nr_ports()` present since
  `365cfa1ed5a36`.
- **[Phase 3]** `git merge-base --is-ancestor c4086c6 HEAD` → exit 1
  (fix **not** in 6.18.44).
- **[Phase 4]** `b4 dig -c c4086c6`: lore URL found; `b4 dig -a`: v2–v5
  series; `b4 dig -w`: maintainers CC’d; mbox: Damien Le Moal Reviewed-
  by, Niklas applied, no NAKs, no stable Cc.
- **[Phase 5]** `ahci_init_one` is `.probe` for `ahci_pci_driver` (line
  673); panic path via `ahci_save_initial_config()` `readl(port_mmio +
  PORT_CMD)` at `libahci.c:590-592` and `__ahci_port_base()` at
  `ahci.h:453-458`.
- **[Phase 6]** `git describe HEAD` → v6.18.44; `make kernelversion`
  equivalent → 6.18.44; `ahci_validate_bar_size` absent; `git apply
  --check` clean.
- **[Phase 8]** Failure mode: OOB MMIO → kernel panic; severity
  CRITICAL; trigger: BIOS-disabled AHCI with bogus `HOST_CAP`.

**YES****Verdict: YES** — backport to this tree (Linux 6.18.44).

The patch adds a small check in `ahci_init_one()` so probe fails with
`-ENODEV` when `HOST_CAP.NP` claims more ports than the BAR can hold.
That avoids out-of-bounds MMIO access and a kernel panic when an AHCI
controller is disabled in BIOS but still shows up on PCI with bogus
registers (e.g. `HOST_CAP = 0xFFFFFFFF`).

It’s a 22-line, single-file fix, maintainer-reviewed, applies cleanly to
6.18.44, and the bug is still present there.

 drivers/ata/ahci.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 1d73a53370cf3..b4e5d347151a9 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1888,6 +1888,24 @@ static ssize_t remapped_nvme_show(struct device *dev,
 
 static DEVICE_ATTR_RO(remapped_nvme);
 
+static int ahci_validate_bar_size(struct pci_dev *pdev, int bar,
+				  struct ahci_host_priv *hpriv)
+{
+	u32 cap = readl(hpriv->mmio + HOST_CAP);
+	unsigned int max_ports = ahci_nr_ports(cap);
+	u32 last_port_end = 0x100 + (max_ports * 0x80);
+	resource_size_t bar_size = pci_resource_len(pdev, bar);
+
+	if (last_port_end > bar_size) {
+		dev_warn(&pdev->dev,
+			 "BAR%d too small for %u ports (last port ends at %#x, BAR %pa)\n",
+			 bar, max_ports, last_port_end, &bar_size);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	unsigned int board_id = ent->driver_data;
@@ -1988,6 +2006,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!hpriv->mmio)
 		return -ENOMEM;
 
+	rc = ahci_validate_bar_size(pdev, ahci_pci_bar, hpriv);
+	if (rc)
+		return rc;
+
 	/* detect remapped nvme devices */
 	ahci_remap_check(pdev, ahci_pci_bar, hpriv);
 
-- 
2.53.0

