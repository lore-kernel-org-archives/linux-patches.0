Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BD747F767;
	Mon, 31 Aug 2026 13:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183463; cv=none; b=XGC0TbXk15IhESekhiyZ/HmFhAPp/HNqIcQeflwWSiUakR8gQK3NF1wy84n4PtW6mdLAhKJmV2S3OQuutJ1CxGripU+b6dxTpDgF6YTDetiD7DP8JVpREq0O/XnIJ7graWJlnZjGWl0b1ZMrVb7y/zTOcMfMiBM5CtoHCtFZy/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183463; c=relaxed/simple;
	bh=FyEW3Bc0Fu/jxu5SwqR5Zk3whVIte3iD6X8zjAnNEZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PNsDfNG7Laj/EZsfePjzwHSrpMTbZReDDXd5/1rKraaodT1p8Nbla/8Kovm03sNmZF20mq2XmQurjtwZWKCeHmS/EgaFrWL+2Z0UrOclC7UJbAjiP6rOof+2JIzFW33fNxmBxapFiEceXAGeEmJxapBVNXLMIvCZoCeRCTqJCyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZGqM9OK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZGqM9OK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AA01F000E9;
	Mon, 31 Aug 2026 13:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183461;
	bh=zRllzes4Brg+KzK9UoYcX5ou4h2m/6LiczELqbs0h0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZGqM9OKLpsu6N0sauKVK0Nkt6JMUWWRnzN2DX6YWI5jYwlA9cH2SDtMtieybpZHI
	 65fLx9SjXs5VbPqdpAxtGXouwzLFdKLNfQLOVWHbFA01XKpo6VFNAIwmimUNFkbMQ6
	 3EHBS2eEgfaPn42GPIZS3yGORk7qzdafbxNfobq+tTv2QlZU5DifuCVib/PVmVXl5F
	 AX3NFzaeBARInYlryKBaAAHHDGSzEFpM+fC0HDSaHt5LUOoR0CXvlo4eQ+yZuPr0p4
	 jLgRkr8jF/xTJk3sr0vuaguNFpSPegVKtABrSzbv4q1tC40QNfrkqSKrX3BBTEoeTM
	 JHjFojkaXJldA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	liam.r.girdwood@linux.intel.com,
	peter.ujfalusi@linux.intel.com,
	yung-chuan.liao@linux.intel.com,
	kai.vehmanen@linux.intel.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ASoC: Intel: catpt: Complete coredump handling
Date: Mon, 31 Aug 2026 09:22:18 -0400
Message-ID: <20260831133314.4125787-110-sashal@kernel.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 7e5d59f407bc39d43b350cc45f7880647429eb5d ]

An exception may occur during the firmware booting procedure.  In such
case the firmware sends COREDUMP_REQUESTS and expects the driver to dump
relevant information and finish with the COREDUMP_RELEASE write.

To distinguish such situation from generic timeout, always signal
fw_ready completion when a coredump request is received and translate
it to -EREMOTEIO in catpt_boot_firmware().

The "FW READY" print makes the success clearly visible even when
the event-traces are not enabled.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260528083444.1439233-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ASoC: Intel: catpt: Complete coredump
handling

**Local tree:** `v6.18.44` (6.18.44 stable)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ASoC: Intel: catpt]` `[Complete]` — finish incomplete
firmware coredump protocol handling during firmware boot failure.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Cezary Rojewski `<cezary.rojewski@intel.com>`
  (author)
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (ASoC maintainer
  merge)
- **Link:** `https://patch.msgid.link/20260528083444.1439233-2-
  cezary.rojewski@intel.com` (patch 2 of a series, per Message-ID)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or `Reviewed-by:` tags
- Notable: maintainer merge sign-off; no fuzzer/user bug report

### Step 1.3: Body analysis
**Record:**
- **Bug:** On firmware boot exception, firmware sends `COREDUMP_REQUEST`
  and expects the driver to dump state then write `COREDUMP_RELEASE`.
  Current code dumps but never releases or signals boot completion.
- **Symptom:** Boot thread waits the full `FW_READY_TIMEOUT_MS` (250
  ms), returns `-ETIMEDOUT` instead of a firmware-failure error;
  coredump protocol is incomplete.
- **Root cause:** `CATPT_GLB_REQUEST_CORE_DUMP` handler calls
  `catpt_coredump()` but does not write `COREDUMP_RELEASE` or
  `complete(&cdev->fw_ready)`.
- **Fix approach:** Release firmware from coredump state, complete
  `fw_ready`, and return `-EREMOTEIO` from `catpt_boot_firmware()` when
  woken but `ipc->ready` is false.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Subject says "Complete" rather than "fix", but this is
incomplete error-path/protocol handling: missing firmware handshake step
and incorrect boot error classification.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- `sound/soc/intel/catpt/ipc.c` (+10 lines): coredump path completion,
  debug print on FW ready
- `sound/soc/intel/catpt/loader.c` (+3 lines): distinguish coredump
  wakeup from success
- `sound/soc/intel/catpt/registers.h` (+12 lines): coredump register
  constants and DRAM I/O helpers
- **Functions modified:** `catpt_dsp_process_response()`,
  `catpt_boot_firmware()`
- **Scope:** Single-driver, 3 files, ~25 net lines — surgical fix

### Step 2.2: Code flow changes
**Record:**
- **Hunk 1 (`ipc.c` fw_ready path):** Adds `dev_dbg("FW READY ...")`
  before arming IPC — diagnostic only.
- **Hunk 2 (`ipc.c` coredump path):** After `catpt_coredump()`, reads
  DRAM coredump register; if `CATPT_COREDUMP_REQUEST`, writes
  `CATPT_COREDUMP_RELEASE`; then `complete(&cdev->fw_ready)`.
- **Hunk 3 (`loader.c`):** After successful
  `wait_for_completion_timeout`, if `!cdev->ipc.ready`, return
  `-EREMOTEIO` instead of continuing boot.
- **Hunk 4 (`registers.h`):** Adds `CATPT_DRAM_COREDUMP`,
  request/release values, `catpt_dram_addr`,
  `catpt_readl_dram`/`catpt_writel_dram` macros.

### Step 2.3: Bug mechanism
**Record:** **Category:** Logic/correctness fix on firmware error path +
incomplete protocol handshake.
- **Before:** Coredump during boot → dump created, `ipc->ready = false`,
  no completion, no RELEASE → 250 ms timeout → `-ETIMEDOUT`.
- **After:** Coredump during boot → dump + conditional RELEASE +
  `fw_ready` completion → immediate wakeup → `-EREMOTEIO`.
- **Runtime path:** Same coredump handler is used for non-boot
  exceptions; RELEASE is also missing today on that path.

### Step 2.4: Fix quality
**Record:** Obviously correct and minimal. RELEASE is guarded by a
register read. Boot cannot proceed on failure because `ipc->ready`
remains false. Low regression risk; no API changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Coredump case in `ipc.c` introduced in `64b9b1b005743` (Sep
2020, "Add IPC message handlers"). Boot wait logic in `a9aa6fb3eb6c7`
(Sep 2020, "Firmware loading and context restore"). Bug present since
initial coredump support (~5.9 era).

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:** Recent catpt commits in this tree include init and hw_params
fixes (`7af2d06ec25b5`, `a2f79598c6c1f`). No prior coredump-completion
fix. This commit is **not** yet in the local tree (buggy code still
present).

### Step 3.4: Author context
**Record:** Cezary Rojewski is the original catpt author (2020). Recent
catpt work in-tree is maintenance/fixes. Mark Brown merged.

### Step 3.5: Dependencies
**Record:** Message-ID suffix `-2` suggests a 2-patch series; patch 1
not found in workspace mbox files. The diff is self-contained (adds its
own register definitions and helpers). **UNVERIFIED:** whether patch 1
of the series is required; nothing in the diff references symbols from
an unseen prerequisite.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** **UNVERIFIED** — `b4 dig` requires a commit hash (not
available; commit not in tree). Lore and patch.msgid.link returned
403/bot protection. Could not read review thread.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** — `b4 dig -w` not run (no commitish).

### Step 4.3: Bug report
**Record:** N/A — no `Reported-by:` or syzbot link.

### Step 4.4: Series context
**Record:** Message-ID indicates patch 2/2. Coredump infrastructure
(`catpt_coredump()`, `CATPT_GLB_REQUEST_CORE_DUMP`) already exists in
this tree from 2020; this patch completes protocol handling rather than
introducing coredump support.

### Step 4.5: Stable list discussion
**Record:** **UNVERIFIED** — lore stable search inaccessible.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `catpt_dsp_process_response()`, `catpt_boot_firmware()`,
`catpt_coredump()` (called, not modified).

### Step 5.2: Callers
**Record:**
- `catpt_dsp_process_response()` ← `catpt_dsp_irq_thread()` (IRQ thread,
  interrupt bottom half)
- `catpt_boot_firmware()` ← `catpt_first_boot_firmware()` (probe) and
  `catpt_resume()` (resume after suspend)
- Probe failure path: `catpt_probe_components()` →
  `catpt_first_boot_firmware()` → on error, `catpt_dsp_power_down()`

### Step 5.3: Callees
**Record:** Coredump path uses `catpt_coredump()` → `dev_coredumpv()`;
new path uses `readl`/`writel` on DRAM via `host_dram_offset` (present
in `core.h` and device specs).

### Step 5.4: Reachability
**Record:** Triggered when ADSP firmware crashes/exceptions during boot
or runtime. Boot path is hit on every driver probe and resume.
Unprivileged users cannot directly trigger it, but normal suspend/resume
and module load are common.

### Step 5.5: Similar patterns
**Record:** No other coredump RELEASE handling exists in catpt today.
`grep` shows no `CATPT_COREDUMP` symbols in the tree before this patch.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (v6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current `ipc.c` lines 214–218 handle coredump
without RELEASE or `complete()`. Current `loader.c` returns only
`-ETIMEDOUT` on timeout with no `ipc->ready` check. Driver present since
2020; `CONFIG_SND_SOC_INTEL_CATPT` targets Haswell/Broadwell.

### Step 6.2: Backport difficulty
**Record:** Clean apply expected — no conflicting recent changes in
these hunks. New macros use existing `host_dram_offset` field.

### Step 6.3: Related fixes already present?
**Record:** No — `git log --grep=coredump -- sound/soc/intel/catpt/`
returns empty.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `sound/soc/intel/catpt` — **IMPORTANT** (audio driver), but
hardware-specific (older Intel Haswell/Broadwell platforms). Not core
kernel.

### Step 7.2: Activity
**Record:** Moderate maintenance activity; recent stable backports
include init and hw_params fixes.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users with `CONFIG_SND_SOC_INTEL_CATPT` on Haswell/Broadwell
systems when ADSP firmware fails during boot or at runtime.

### Step 8.2: Trigger conditions
**Record:** Firmware exception during boot (probe/resume) or operation.
Uncommon but real; not timing-dependent race.

### Step 8.3: Failure severity
**Record:**
- **Without fix:** Incomplete firmware handshake (no
  `COREDUMP_RELEASE`); boot waits 250 ms then reports misleading
  `-ETIMEDOUT`; firmware may remain in coredump state; audio non-
  functional.
- **With fix:** Immediate failure detection, correct `-EREMOTEIO`,
  protocol completed.
- **Severity:** **MEDIUM-HIGH** for affected hardware — device
  recovery/protocol correctness, not kernel oops/UAF. Audio is already
  broken when triggered, but firmware can be left in a bad state without
  RELEASE.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — completes mandatory firmware protocol,
  faster/correct boot failure handling, better runtime coredump cleanup
- **Risk:** LOW — ~25 lines, guarded RELEASE write, explicit
  `ipc->ready` check prevents false-success boot
- **Ratio:** Favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug since 2020: incomplete coredump protocol (missing
  `COREDUMP_RELEASE`)
- Boot path misreports failure as timeout instead of remote I/O error
- Unnecessary 250 ms wait on known firmware failure
- Small, self-contained, maintainer-authored fix
- Buggy code confirmed present in v6.18.44
- Applies to both probe and resume boot paths

**AGAINST backport:**
- No kernel crash, UAF, security issue, or data corruption
- Trigger requires firmware failure (uncommon)
- Niche older hardware
- Device is already non-functional when bug triggers
- Probe failure calls `catpt_dsp_power_down()` (DSP reset), which may
  mitigate stuck state
- Mailing list review/stable nomination not verified
- Possible patch 1/2 series dependency unverified

**Unresolved:** Lore review thread; whether patch 1 is required;
explicit stable nomination.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is clear; no `Tested-
   by` but maintainer merged
2. Fixes a real bug affecting users? **PASS** — incomplete firmware
   protocol on error path
3. Important issue? **PASS (MEDIUM)** — firmware stuck in coredump
   state, misleading errors, delayed failure detection on probe/resume;
   not kernel crash级别
4. Small and contained? **PASS** — 3 files, ~25 lines
5. No new features/APIs? **PASS** — completes existing coredump handling
6. Can apply to local tree? **PASS** — driver and buggy code present;
   clean apply expected

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs fix).

### Step 9.4: Decision rationale
This is a genuine, long-standing protocol bug in the Intel catpt driver.
When firmware exceptions occur, the driver partially handles coredump
but never completes the handshake the firmware expects
(`COREDUMP_RELEASE`), and the boot path misinterprets the situation as a
generic timeout. While the device is already broken when this triggers,
leaving firmware in coredump state without release is a real correctness
defect that can impede recovery, and the fix is minimal with very low
regression risk. It meets stable criteria for a contained driver bug fix
on an error path affecting probe and resume.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 1] Confirmed Message-ID indicates patch 2 of series
  (`1439233-2`)
- [Phase 2] Read current `ipc.c`, `loader.c`, `registers.h` — buggy code
  present, matches pre-patch state
- [Phase 2] Confirmed `FW_READY_TIMEOUT_MS` is 250 ms in `loader.c`
- [Phase 3] `git describe HEAD` → `v6.18.44`; `make kernelversion` →
  `6.18.44`
- [Phase 3] `git blame` on coredump case → `64b9b1b005743` (Sep 2020)
- [Phase 3] `git blame` on boot wait → `a9aa6fb3eb6c7` (Sep 2020)
- [Phase 3] `git log --oneline -20 -- sound/soc/intel/catpt/` — no
  coredump fix present
- [Phase 3] `git merge-base --is-ancestor 4fac9b31d0b9d HEAD` → catpt
  driver in tree
- [Phase 4] `b4 dig` — requires commitish; not available (commit not in
  tree)
- [Phase 4] WebFetch lore/patch.msgid.link — blocked (403/bot
  protection)
- [Phase 4] Grep workspace `*.mbx` for series — no match
- [Phase 5] Traced callers: `catpt_boot_firmware` from probe/resume;
  `catpt_dsp_process_response` from IRQ thread
- [Phase 5] Read `catpt_coredump()` in `dsp.c` — dumps via
  `dev_coredumpv()`
- [Phase 5] Read `catpt_ipc_arm()` — sets `ipc->ready = true` only on
  successful FW ready
- [Phase 5] Confirmed `host_dram_offset` exists in `core.h` and device
  specs
- [Phase 6] Grep `CATPT_COREDUMP` — not present (fix not applied)
- [Phase 6] Read probe error path in `device.c` —
  `catpt_dsp_power_down()` on boot failure
- [Phase 7] Read `Kconfig` — `SND_SOC_INTEL_CATPT` for Haswell/Broadwell
- [Phase 8] Assessed failure modes from code flow analysis
- **UNVERIFIED:** Mailing list review feedback and stable nominations
- **UNVERIFIED:** Whether patch 1 of the series is a prerequisite

**YES**

 sound/soc/intel/catpt/ipc.c       |  8 ++++++++
 sound/soc/intel/catpt/loader.c    |  3 +++
 sound/soc/intel/catpt/registers.h | 12 ++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/sound/soc/intel/catpt/ipc.c b/sound/soc/intel/catpt/ipc.c
index d26863249097f..952c26e5d0e6c 100644
--- a/sound/soc/intel/catpt/ipc.c
+++ b/sound/soc/intel/catpt/ipc.c
@@ -205,6 +205,7 @@ static void catpt_dsp_process_response(struct catpt_dev *cdev, u32 header)
 		memcpy_fromio(&config, cdev->lpe_ba + off, sizeof(config));
 		trace_catpt_ipc_payload((u8 *)&config, sizeof(config));
 
+		dev_dbg(cdev->dev, "FW READY 0x%08x\n", header);
 		catpt_ipc_arm(ipc, &config);
 		complete(&cdev->fw_ready);
 		return;
@@ -215,6 +216,13 @@ static void catpt_dsp_process_response(struct catpt_dev *cdev, u32 header)
 		dev_err(cdev->dev, "ADSP device coredump received\n");
 		ipc->ready = false;
 		catpt_coredump(cdev);
+
+		if (catpt_readl_dram(cdev, COREDUMP) == CATPT_COREDUMP_REQUEST) {
+			dev_dbg(cdev->dev, "releasing firmware from the coredump state\n");
+			catpt_writel_dram(cdev, COREDUMP, CATPT_COREDUMP_RELEASE);
+		}
+
+		complete(&cdev->fw_ready);
 		/* TODO: attempt recovery */
 		break;
 
diff --git a/sound/soc/intel/catpt/loader.c b/sound/soc/intel/catpt/loader.c
index 696d84314eeb5..680efad5f458d 100644
--- a/sound/soc/intel/catpt/loader.c
+++ b/sound/soc/intel/catpt/loader.c
@@ -626,6 +626,9 @@ int catpt_boot_firmware(struct catpt_dev *cdev, bool restore)
 	if (!ret) {
 		dev_err(cdev->dev, "firmware ready timeout\n");
 		return -ETIMEDOUT;
+	/* Wake up does not mean FW is ready, an exception could occur. */
+	} else if (!cdev->ipc.ready) {
+		return -EREMOTEIO;
 	}
 
 	/* update sram pg & clock once done booting */
diff --git a/sound/soc/intel/catpt/registers.h b/sound/soc/intel/catpt/registers.h
index 6c1ad28c6d692..64bd534a76ff4 100644
--- a/sound/soc/intel/catpt/registers.h
+++ b/sound/soc/intel/catpt/registers.h
@@ -124,6 +124,11 @@
 #define CATPT_SSCR2_DEFAULT		0x0
 #define CATPT_SSPSP2_DEFAULT		0x0
 
+/* Coredump register and its states */
+#define CATPT_DRAM_COREDUMP		0x1F4
+#define CATPT_COREDUMP_REQUEST		UINT_MAX
+#define CATPT_COREDUMP_RELEASE		0
+
 /* Physically the same block, access address differs between host and dsp */
 #define CATPT_DSP_DRAM_OFFSET		0x400000
 #define catpt_to_host_offset(offset)	((offset) & ~(CATPT_DSP_DRAM_OFFSET))
@@ -137,6 +142,8 @@
 
 /* registry I/O helpers */
 
+#define catpt_dram_addr(cdev) \
+	((cdev)->lpe_ba + (cdev)->spec->host_dram_offset)
 #define catpt_shim_addr(cdev) \
 	((cdev)->lpe_ba + (cdev)->spec->host_shim_offset)
 #define catpt_dma_addr(cdev, dma) \
@@ -151,6 +158,11 @@
 #define catpt_writel_ssp(cdev, ssp, reg, val) \
 	writel(val, catpt_ssp_addr(cdev, ssp) + (reg))
 
+#define catpt_readl_dram(cdev, reg) \
+	readl(catpt_dram_addr(cdev) + CATPT_DRAM_##reg)
+#define catpt_writel_dram(cdev, reg, val) \
+	writel(val, catpt_dram_addr(cdev) + CATPT_DRAM_##reg)
+
 #define catpt_readl_shim(cdev, reg) \
 	readl(catpt_shim_addr(cdev) + CATPT_SHIM_##reg)
 #define catpt_writel_shim(cdev, reg, val) \
-- 
2.53.0

