Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B2950CBAD;
	Mon, 19 Oct 2026 14:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418767; cv=none; b=oFBzzEcz0+opFDzd0Ivsssl5jItK9RaycQeGVt9mr+J/aKHRqJ9bOOsGLJ4Pojqky6PzM1PVekDfTQa25fh42NC/0bTL0MRoExdn9WWLzh7JuqoTAUgCNawJRWC1r49wRK37OknhNm8aqQmF1iUK1BZvexdVY9QdSjhLYnW6sgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418767; c=relaxed/simple;
	bh=2aYhuB3ch6Chcbz/+eZVcHH0zc17p8d45x2FZoFEKJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qu94PmAeoIp7J5PIRa0JdJP9qBVtPiNSoOL6F4gozNO6J0c1rrknT0HM1yKhEPhZ0aqc3f33nPQm7DNMt7T8Gpy2ajaX1Jb387n4IY6sLPklLMBxyC8pics/lAe8qaK4Xy6xmuJyKwB7n0lvY0vdKYsiisc9MqT4W9C4UdQWNb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZtNRq5b0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZtNRq5b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF291F000C5;
	Mon, 19 Oct 2026 14:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418764;
	bh=jCOPUy2tnqSPArWEJALWgabmsBHXvgMJ7Aj40Y0vGhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZtNRq5b0A59qxb3YeJcnL1SWdQPHTAUB+qMuP+SX/4dx5JgoEEh9i99PYDW6JYs6m
	 W+yVu0Q/NOSTZE1M4Li4/h0MbDws1miVy3q/lex9AJaK4e7d3BM6W6LlQl5t2CupMR
	 ZDdi0xWIjgtWW4ob4P0Z0ChH2jBriTvYLedcScbgIBQwweQDhm3jRewTUmVYErUIrj
	 7kkV7VkL7rK0hjDPLFEmD0+2HYxChul8crbfxO0XPahSO+0TTNUMwbZKXnPknvVEWZ
	 vx9IZ6dEY/xECxmMgrYroxxuAROOVCx5wEa8HqzD41ov1zsjB9bldIpIjvGfynxqDu
	 gKLLQVdXAQ4Qw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] nvmem: brcm_nvram: fix out-of-bounds access on malformed flash data
Date: Mon, 19 Oct 2026 09:52:50 -0400
Message-ID: <20261019135441.1420968-479-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit a67e2c323a47a2254ed3472b5e4c53abac20f116 ]

The length check in brcm_nvram_parse() validated header->len against
priv->nvmem_size (the full partition size) instead of priv->data_len
(the actual allocated data buffer). A malformed flash partition with
header->len between the two would pass the check, causing
brcm_nvram_add_cells() to read and write priv->data[len - 1] beyond
the heap allocation.

Also add a minimum bound: len < sizeof(*header) could underflow the
data[len - 1] access.

Fix both bounds by rejecting len outside [sizeof(*header), priv->data_len].

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260729094647.111468-14-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES for this 6.6.y tree.** This is a small heap out-of-bounds fix in
`brcm_nvram_parse()`, and the buggy check is present in this checkout.

Local tree: `pending-6.6`, `6.6.157` (`p-6.6-3-g04810563abb71`).
Upstream commit `a67e2c323a47a` is **not** an ancestor of HEAD.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[nvmem / brcm_nvram] [fix] [OOB access when NVRAM header length
is malformed]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Assisted-by: opencode:big-pickle` (AI-assisted)
- `Signed-off-by: Rosen Penev <rosenp@gmail.com>` (author)
- `Signed-off-by: Srinivas Kandagatla <srini@kernel.org>` (nvmem
  maintainer)
- `Link:
  https://patch.msgid.link/20260729094647.111468-14-srini@kernel.org`
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>`
  (char-misc merge)
- No `Fixes:`, no `Reported-by:`, no `Tested-by:`, no `Reviewed-by:` on
  this patch itself, no `Cc: stable` (absence is expected)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: `brcm_nvram_parse()` checks `header->len` against
  `priv->nvmem_size` (full mapped partition) instead of `priv->data_len`
  (heap copy).
- Symptom: malformed flash with `data_len < header->len <= nvmem_size`
  passes the check; `brcm_nvram_add_cells()` then reads/writes
  `priv->data[len - 1]` past the allocation.
- Second bug: `len < sizeof(*header)` can underflow that `data[len - 1]`
  index.
- Root cause: wrong upper bound after the driver started caching a
  trimmed copy of NVRAM.
- Version info in the message: none. Locally the mismatch was introduced
  by `09283d60bc332` (“store a copy of NVRAM content”), present since
  **v6.6.9**.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Subject and body describe a real OOB. The 13/14
numbering is the nvmem 7.3 pull, not a hidden refactor.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/nvmem/brcm_nvram.c` (+7 / −3, net +4)
- Function: `brcm_nvram_parse()` only
- Scope: single-file surgical bounds check

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: after magic check, `len = le32_to_cpu(header->len)`; reject
  only if `len > priv->nvmem_size`; then `brcm_nvram_add_cells(priv,
  priv->data, len)`.
- After: reject if `len < sizeof(*header)` or `len > priv->data_len`.
- Path: probe/parse only (init), not a hot path.

Verified in this tree:

```126:127:drivers/nvmem/brcm_nvram.c
        tmp = priv->data[len - 1];
        priv->data[len - 1] = '\0';
```

```87:91:drivers/nvmem/brcm_nvram.c
        priv->data = devm_kzalloc(priv->dev, priv->data_len,
GFP_KERNEL);
        if (!priv->data)
                return -ENOMEM;

        memcpy_fromio(priv->data, base, priv->data_len);
```

```189:194:drivers/nvmem/brcm_nvram.c
        len = le32_to_cpu(header->len);
        if (len > priv->nvmem_size) {
                dev_err(dev, "NVRAM length (%zd) exceeds mapped size
(%zd)\n", len,
                        priv->nvmem_size);
                return -EINVAL;
```

`data` is allocated to `data_len`, which is the partition with trailing
padding stripped, so `data_len` is typically much smaller than
`nvmem_size` (NAND NVRAM partitions are often 1MiB+; content is usually
16–32KiB). The loops in `brcm_nvram_add_cells()` also walk `data + len`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: **buffer overflow / out-of-bounds** (heap read + write),
  plus underflow if `len == 0`.
- Mechanism: wrong upper bound vs allocated buffer; missing lower bound
  before `data[len - 1]`.
- Fix: reject `len` outside `[sizeof(*header), priv->data_len]`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: the index used is `priv->data[len - 1]` on a
  `data_len`-sized buffer.
- Minimal: one function, one check.
- Regression risk: low. Probe fails with `-EINVAL` instead of heap OOB.
  A theoretical case is well-formed NVRAM whose trailing bytes match
  `padding_byte`, so `data_len < header->len`; those images already OOB
  today. No revert/follow-up on `origin/master` after `a67e2c323a47a`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: The `len > priv->nvmem_size` check was added in `09283d60bc332`
(Rafał Miłecki, 2023-12-15), backported here as of **v6.6.9**. That
commit allocated `priv->data` of size `data_len` but left the length
check against `nvmem_size`.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The introducing commit is `09283d60bc332` /
upstream `1e37bf84afacd` (“store a copy of NVRAM content”). `git merge-
base --is-ancestor 09283d60bc332 HEAD` → **yes**. That commit itself had
`Cc: stable` and `Fixes: 3fef9ed0627a`.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record (this tree, `drivers/nvmem/brcm_nvram.c`): last functional change
is the store-copy commit. No later local fix for this OOB.
Sibling on mainline (not required for this diff): `fde46579cf887`
“reject empty NVRAM partition” (ZERO_SIZE_PTR / empty partition). It
touches `brcm_nvram_copy_data()`, not `brcm_nvram_parse()`. Independent.
Also **not** in HEAD.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Rosen Penev has no other `drivers/nvmem/` commits in this 6.6
tree. On `origin/master` the two brcm_nvram fixes are this OOB and the
empty-partition sibling. Srinivas (nvmem maintainer) SOB’d and sent it
in the 7.3 pull.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Standalone. Needs `priv->data` / `priv->data_len` /
`priv->nvmem_size`, all present. 13/14 is pull numbering only. Applies
without 12/14.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c a67e2c323a47a`:
  https://patch.msgid.link/20260729094647.111468-14-srini@kernel.org
- `b4 dig -a`: v1 standalone 2026-07-03
  (`20260703222852.410370-1-rosenp@gmail.com`); then unchanged as 13/14
  in Srinivas’s `[PATCH 00/14] nvmem: updates for 7.3` (2026-07-29).
  Diff did not change.
- No NAK in the saved thread. Cover letter explicitly calls out this
  OOB.
- No reviewer `Cc: stable` on this patch.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc were srini, gregkh, linux-kernel, Rosen.
Original v1 also CCd rafal@milecki.pl. Maintainer SOB is the review
signal; no extra `Reviewed-by` on this patch. Other `Reviewed-by` tags
in the mbox belong to other series patches (e.g. Krzysztof on 14/14
qfprom bindings).

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla/`Reported-by`. Bug is from code inspection of
the length vs allocation mismatch. Still a reachable probe-time OOB on
real DT platforms.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Same author/series: empty-partition reject (12/14). Independent
bug (erased partition → `kzalloc(0)` → fault on `header->magic`). Not a
prerequisite. Pengpeng Hou’s “validate cached NVRAM length” (2026-07-15)
was not merged; this patch was.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No useful stable-list discussion found for this subject. Lore
search was noisy/unrelated; no evidence it was rejected for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `brcm_nvram_parse()` changed; it calls `brcm_nvram_add_cells()`,
which performs the OOB.

**Step 5.2: TRACE CALLERS**
Record: `brcm_nvram_probe()` → `brcm_nvram_copy_data()` then
`brcm_nvram_parse()`. Probe of `compatible = "brcm,nvram"`. Boot/device-
init, not syscall hot path.

**Step 5.3: TRACE CALLEES**
Record: `memcmp` (magic), `le32_to_cpu`, `dev_err`,
`brcm_nvram_add_cells()` (NUL-terminates `data[len-1]`, walks key=value
cells).

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Platform probe on BCM5301X boards. Userspace cannot call this
directly; corrupted/malformed flash at boot can. Some routers expose
NVRAM to userspace, but that was not verified as a write path into this
partition. Reachable at boot on those devices: **yes**.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Sibling empty-partition fix is the other bounds hole in the same
driver. No duplicate of this exact check in this tree (`len >
priv->data_len` is absent).

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `drivers/nvmem/brcm_nvram.c` `brcm_nvram_parse()` still
uses `priv->nvmem_size`. Introduced in `09283d60bc332` (in tree since
v6.6.9). `git merge-base --is-ancestor a67e2c323a47a HEAD` → **not in
HEAD**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** (offset only: ~189 vs ~192). Pre-image context
matches exactly. `data_len` / `nvmem_size` / `add_cells` `data[len-1]`
all present. No conflicting local edits.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No. `git log --grep=out-of-bounds/--grep=malformed --
drivers/nvmem/` is empty. Empty-partition sibling also absent (not
required).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/nvmem/` Broadcom NVRAM. **PERIPHERAL / platform-
specific**, but production hardware: `CONFIG_NVMEM_BRCM_NVRAM` depends
on `ARCH_BCM_5301X || COMPILE_TEST`. Kconfig: BCM470X/BCM5301X Northstar
home routers and APs. This tree has **16** `compatible = "brcm,nvram"`
DTS files (Linksys, ASUS, D-Link, Luxul, etc.).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: File is mature in 6.6; last local functional change is the 2024
store-copy backport. The OOB is a leftover from that stable backport,
not new mainline-only code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver/platform-specific: BCM5301X routers/APs using
`brcm,nvram`. Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Device probe when the flash header has magic `FLSH` and
`header->len` in `(data_len, nvmem_size]` or `len < sizeof(header)`.
Common on NAND where the partition is much larger than content.
Unprivileged trigger: not a generic syscall; possible with corrupted
NAND or a crafted image. Timing: every boot of an affected board with
bad header.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Heap OOB **read and write** (`data[len-1]` plus parse loops).
Crash, memory corruption, or worse. Severity: **HIGH** (platform-limited
**CRITICAL** memory safety).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: **high** for BCM5301X 6.6 users (stops heap OOB on probe).
- Risk: **very low** (7 lines, reject-only, no locking/API change).
- Ratio: strongly in favor of backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real heap OOB read/write in this tree
- Bug came in with a commit already backported to 6.6.9
  (`09283d60bc332`)
- Small, obviously correct bounds fix
- Applies cleanly
- Maintainer SOB + merged to mainline
- Shipping Northstar router hardware
- No follow-up revert

AGAINST:
- No `Reported-by` / syzbot
- Platform-specific (`ARCH_BCM_5301X`)
- AI-assisted commit message
- 13/14 of a larger pull (other patches are unrelated refactors)

UNRESOLVED:
- No public tester beyond maintainer merge
- Could not fetch lore.kernel.org directly (403); used `b4 dig`,
  openwall/lkml mirrors, and a saved mbox
- Unverified whether userspace on these routers can plant a malicious
  header; boot-time malformed flash is enough

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — bound matches allocation; in
   mainline since 2026-07-31 with no revert
2. Fixes a real bug that affects users? **PASS** — OOB on probe with
   bad/corrupt NVRAM
3. Important issue? **PASS** — heap OOB write / memory corruption /
   crash
4. Small and contained? **PASS** — 7 insertions / 3 deletions, one
   function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — context present, clean apply
   with offset

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not an ID/quirk/DT/docs exception. Ordinary memory-safety bug
fix.

**Step 9.4: MAKE YOUR DECISION**
Backport. This is the missing bound from the store-copy change already
in 6.6.y. Sibling empty-partition patch is a separate crash and is not
required for this one.

---

## What the commit solves for stable users

On Broadcom Northstar boards, NVRAM is copied into a heap buffer of size
`data_len` (padding stripped). The parser still trusted `header->len` up
to the **full partition** size. A header whose length sits between those
values makes `brcm_nvram_add_cells()` write past the allocation. The
extra `len < sizeof(*header)` check stops `data[len - 1]` from wrapping.
For 6.6.y this closes a hole left by the v6.6.9 store-copy backport.

Risk vs benefit: a 4-line check vs heap corruption at boot. Benefit
wins.

---

## Verification

- **[Phase 1]** Parsed tags from `git log -1 a67e2c323a47a`: SOB
  Rosen/Srinivas/Greg; Link msgid; no Fixes/Reported-by/Cc:stable
- **[Phase 2]** Diff: 10-line change in `brcm_nvram_parse()`; local
  `add_cells` uses `priv->data[len - 1]`; `devm_kzalloc(...,
  priv->data_len)`
- **[Phase 2]** Local `brcm_nvram_parse()` still has `if (len >
  priv->nvmem_size)`
- **[Phase 3]** `git blame -L 175,200`: check from `09283d60bc332`; `git
  merge-base --is-ancestor 09283d60bc332 HEAD` → yes; `git describe
  --contains 09283d60bc332` → `v6.6.9~19`
- **[Phase 3]** `git merge-base --is-ancestor a67e2c323a47a HEAD` →
  **not in this tree**
- **[Phase 3]** Sibling `fde46579cf887` also not in HEAD; different
  function
- **[Phase 4]** `b4 dig -c a67e2c323a47a`: lore URL for 13/14; `-a`: v1
  2026-07-03 then pull 2026-07-29, same diff; `-w`:
  srini/gregkh/lkml/Rosen; `-m`: no NAK on this patch
- **[Phase 4]** Cover letter “nvmem: updates for 7.3” names this OOB;
  Pengpeng Hou alternative not merged
- **[Phase 4]** lore.kernel.org WebFetch 403; used b4/openwall/lkml
  instead
- **[Phase 5]** Callers: `brcm_nvram_probe` only (`git grep`)
- **[Phase 6]** `git describe HEAD` → `p-6.6-3-g04810563abb71`; `make
  kernelversion` → `6.6.157`
- **[Phase 6]** Exact pre-image string present in local file (Python
  check)
- **[Phase 7]** Kconfig `depends on ARCH_BCM_5301X`; 16 DTS files with
  `brcm,nvram`
- **[Phase 8]** Failure mode: heap OOB write in `brcm_nvram_add_cells`,
  severity HIGH
- **UNVERIFIED**: userspace-controlled flash header; live tester for
  this exact patch

The fix is small, surgical, already in mainline, and matches the code in
this 6.6 tree.

**YES**

 drivers/nvmem/brcm_nvram.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/nvmem/brcm_nvram.c b/drivers/nvmem/brcm_nvram.c
index 4b3781a70222a..5ec2ceefb77f6 100644
--- a/drivers/nvmem/brcm_nvram.c
+++ b/drivers/nvmem/brcm_nvram.c
@@ -192,9 +192,13 @@ static int brcm_nvram_parse(struct brcm_nvram *priv)
 	}
 
 	len = le32_to_cpu(header->len);
-	if (len > priv->nvmem_size) {
-		dev_err(dev, "NVRAM length (%zd) exceeds mapped size (%zd)\n", len,
-			priv->nvmem_size);
+	if (len < sizeof(*header)) {
+		dev_err(dev, "NVRAM length (%zd) too small\n", len);
+		return -EINVAL;
+	}
+	if (len > priv->data_len) {
+		dev_err(dev, "NVRAM length (%zd) exceeds data size (%zd)\n", len,
+			priv->data_len);
 		return -EINVAL;
 	}
 
-- 
2.53.0

