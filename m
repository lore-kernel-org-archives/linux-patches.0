Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E1B490BEE;
	Mon, 31 Aug 2026 13:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183519; cv=none; b=hImEopt8oaFoRzSRe0Cqafszh2P0RiZ1LVsjlx4PfZrqSQCjc1LnqBRWQvlBhc7B8f13YiKY7p61P+wtH5blUEINQN4xjfteb6jlcFnB4VZn3CIO8ScmNsbrNJKBfGiu653ECo/v7wEPQNFRsfIOVZbsNOf1im7gf4sKOYkeKP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183519; c=relaxed/simple;
	bh=PQl+2EVsvgICC18dXT3Bn6fY9nFx9i22nzg72qQDowU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VrcUIoh/yetgaelxmFoPBuwdiuyKUNrwvY3BBn91gBmNXnIMbcnepQ0lex4yq8arjE9Tum5vop98rd90eILVEELqn4XSjBIvmQIOv43725uyqiIp4z6ld+Mrj/QUFxWYZg0XRb/OQvOKnnBdWOlt63ybch7Zj/KWkoQgo6YuMd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L6tTd4ry; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L6tTd4ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D731F00A3F;
	Mon, 31 Aug 2026 13:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183516;
	bh=8OCzv8gHHMhGPGUdxg7OrV/lIV9NbIlPcC62zD6xPjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6tTd4rysqk0kSXJZvp0n/2DyCykRL/Z7s37FZK0Iexa0vHrbtV16+rEPiNZ05I52
	 ZcAR8C7yTg7ndefI24GQsBWXyxt3pxR7leAD7Sdh/G/AyJIA3GUYYpS987zzXcAQhi
	 4di6ByZgGeLOT6Dg3iv/PSSKa2cprw6ei9fs8PwneCFZTbjs6VZhcZKq9PQ02w5kW2
	 iqXYg/XO1d7AK6ze1oE5SvfAEnqyhq2b8u8zXTcSLFZNPWeez1SHmn0odi6SevnUwm
	 Zg0kh80zZjXZ5zGpHdX1mjIoi2yq9VuFMVWDK7Hqh5UGQHPoWeJs6rUOXyHiX9dSgN
	 QdHZ4yECbHcyA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	peter.ujfalusi@linux.intel.com,
	yung-chuan.liao@linux.intel.com,
	daniel.baluta@nxp.com,
	perex@perex.cz,
	tiwai@suse.com,
	sound-open-firmware@alsa-project.org,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ASoC: SOF: validate probe info element counts
Date: Mon, 31 Aug 2026 09:22:51 -0400
Message-ID: <20260831133314.4125787-143-sashal@kernel.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 95edf2dbb492f3ea2420111e9c0044c7dec9113c ]

Probe information replies contain a firmware-provided element count. IPC3
uses that count to copy an array, then returns the unchecked count to its
caller. A short reply can therefore make the caller walk beyond the copied
array.

IPC4 similarly uses the count both to allocate the destination array and
to walk the reply. On 32-bit systems the allocation size can wrap, while on
all systems an excessive count reads beyond the reply payload.

Validate each count against the actual reply size before copying or
allocating the array, and use kcalloc() for the IPC4 allocation.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260628000329.18606-1-alhouseenyousef@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[ASoC: SOF]` `[validate]` — Validate firmware-provided
probe info element counts before use in IPC3/IPC4 probe handlers.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Yousef Alhouseen `<alhouseenyousef@gmail.com>`
  (author)
- **Link:** `https://patch.msgid.link/20260628000329.18606-1-
  alhouseenyousef@gmail.com`
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (ASoC maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or `Reviewed-by:` tags
- Notable: maintainer sign-off; no fuzzer/user bug report in message

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Probe info IPC replies include a firmware-provided
  `num_elems`. IPC3 uses it for `kmemdup()` and returns it to callers;
  IPC4 uses it for allocation and iteration. Neither path validates the
  count against the actual reply size.
- **Symptoms:** Short/malformed replies can cause out-of-bounds reads
  during copy/iteration; on 32-bit IPC4 paths, `num_elems *
  sizeof(desc)` can wrap in `kzalloc()`.
- **Root cause:** Missing bounds check on untrusted firmware IPC payload
  fields.
- **Version info:** None stated in the commit message.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes. Although the subject says "validate" rather than "fix",
this is a memory-safety bug fix: unchecked firmware metadata can cause
OOB access and allocation-size wrap.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- `sound/soc/sof/sof-client-probes-ipc3.c`: +19 / -4 lines
- `sound/soc/sof/sof-client-probes-ipc4.c`: +11 / -1 lines
- **Functions modified:** `ipc3_probes_info()`,
  `ipc4_probes_points_info()`
- **Scope:** Small, two-file, subsystem-local surgical fix

### Step 2.2: Code Flow Changes

**IPC3 (`ipc3_probes_info`):**
- **Before:** After IPC success, used `reply->num_elems` directly to
  compute `bytes *= num_elems`, `kmemdup()`, and `*num_params`.
- **After:** Reads `payload_size = reply->rhdr.hdr.size`, rejects
  undersized payloads, computes `elem_size`, validates `num_elems <=
  payload_size / elem_size`, then copies/returns count.

**IPC4 (`ipc4_probes_points_info`):**
- **Before:** Used `info->num_elems` directly for `kzalloc(*num_desc *
  sizeof(**desc))` and loop bound.
- **After:** Validates `info->num_elems` against `msg.data_size`,
  switches to `kcalloc()`, rejects invalid counts.

### Step 2.3: Bug Mechanism
**Record:** **Memory safety / bounds validation bug**
- **IPC3:** Unchecked `num_elems` can make `bytes = elem_size *
  num_elems` exceed actual reply payload; `kmemdup()` reads past valid
  IPC data. If multiplication wraps, a small allocation can be paired
  with a large returned count, and callers iterate past the allocation.
- **IPC4:** Unchecked `num_elems` allows loop reads past `msg.data_ptr`
  bounds; `kzalloc(n * size)` can wrap on 32-bit systems.

### Step 2.4: Fix Quality
**Record:** Fix is obviously correct and minimal. It mirrors the
existing SOF pattern in `debug.c` (`struct_size(reply, elems,
reply->num_elems) != reply->rhdr.hdr.size`). Regression risk is very
low: only rejects malformed firmware replies.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Buggy lines in both files trace to commit `5d324e5159d9e` in
this shallow checkout. The vulnerable logic is present in the current
tree at `sof-client-probes-ipc3.c:131-144` and `sof-client-probes-
ipc4.c:251-264`.

### Step 3.2: Fixes Tag
**Record:** N/A — no `Fixes:` tag in the commit message.

### Step 3.3: Related File History
**Record:** Repository is shallow (`git rev-parse --is-shallow-
repository` → `true`), limiting history depth. The probe client files
exist in this 6.18.44 tree. No duplicate fix found (`grep "invalid probe
info element count"` → no matches).

### Step 3.4: Author History
**Record:** No prior SOF commits from Yousef Alhouseen found in this
tree. Mark Brown is ASoC maintainer (sign-off).

### Step 3.5: Dependencies
**Record:** Standalone fix. Uses only existing headers (`offsetof`,
`kcalloc`). No series dependency indicated. The commit is not yet
present in this checkout.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** UNVERIFIED — `b4 dig` could not match the commit (not in
local repo). WebFetch to patch.msgid.link and lore.kernel.org returned
bot-protection pages (403/JS challenge). Could not read review thread.

### Step 4.2: Reviewers
**Record:** UNVERIFIED — `b4 dig -w` unavailable for this commit.

### Step 4.3: Bug Report
**Record:** No `Reported-by:` or syzbot link. Issue identified by code
inspection of firmware IPC parsing.

### Step 4.4: Related Patches
**Record:** UNVERIFIED — could not retrieve series revisions from lore.

### Step 4.5: Stable List History
**Record:** UNVERIFIED — lore stable search inaccessible.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `ipc3_probes_info()`, `ipc3_probes_points_info()` (wrapper),
`ipc4_probes_points_info()`

### Step 5.2: Callers
**Record:**
- `sof_probes_compr_shutdown()` in `sof-client-probes.c:78` —
  compressed-stream shutdown path
- `sof_probes_dfs_points_read()` in `sof-client-probes.c:227` — debugfs
  read path (root-accessible)

Both invoke `ipc->points_info()` from the IPC ops table.

### Step 5.3: Callees
**Record:** `sof_client_ipc_tx_message()`,
`sof_client_ipc_set_get_data()`, `kmemdup()`, `kzalloc()`/`kcalloc()`,
`sof_client_get_ipc_max_payload_size()`

### Step 5.4: Reachability
**Record:**
- Trigger requires `CONFIG_SND_SOC_SOF_DEBUG_PROBES`, auto-selected on
  Intel HDA (`SND_SOC_SOF_HDA_PROBES`) and AMD ACP
  (`SND_SOC_SOF_ACP_PROBES`) SOF platforms.
- Malformed `num_elems` must come from SOF firmware IPC replies during
  probe point enumeration.
- Not a direct unprivileged syscall path, but reachable during normal
  audio probe shutdown and root debugfs use when probes are active.
- Precedent: `sound/soc/sof/debug.c:227-231` already validates similar
  IPC `num_elems` against `rhdr.hdr.size`.

### Step 5.5: Similar Patterns
**Record:** `debug.c` already validates IPC element counts; probes code
was missing equivalent checks. `ipc3-control.c` uses overflow checks for
control data sizes.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Local tree is **v6.18.44** (`6.18.44`). Vulnerable
code is present; fix is **not** applied. Confirmed by reading current
sources and absent error string `invalid probe info element count`.

### Step 6.2: Backport Complications
**Record:** Expected **clean apply** — current file contents match the
patch base context exactly.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent validation found in probe IPC files. `debug.c`
has similar validation for a different IPC path only.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem
**Record:** `sound/soc/sof` — ASoC / SOF audio driver. **Criticality:
IMPORTANT** (not core kernel, but widely used on Intel/AMD
laptop/desktop SOF platforms).

### Step 7.2: Activity
**Record:** SOF client probe support is active in this tree (`sof-
client-probes*.c` present, Makefile builds with
`CONFIG_SND_SOC_SOF_DEBUG_PROBES`).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users on SOF platforms with probes enabled (Intel HDA SOF,
AMD ACP). Config-specific, not universal.

### Step 8.2: Trigger Conditions
**Record:** SOF firmware returns probe info with `num_elems`
inconsistent with reply size. Requires probes feature active and a
probe-info IPC exchange. Most likely with buggy firmware; defense-in-
depth against compromised firmware is also relevant. Root can trigger
via debugfs when extractor is running.

### Step 8.3: Failure Mode Severity
**Record:**
- **IPC3:** OOB read in `kmemdup()`; potential `size_t` multiply wrap
  leading to small allocation + large iteration count
- **IPC4:** OOB read in `info->points[i]` loop; `kzalloc()` size wrap on
  32-bit
- **Severity: HIGH** (kernel memory safety; possible oops/KASAN fault)

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Prevents kernel memory corruption/crash on malformed
  firmware IPC in an existing code path
- **Risk:** Very low — only rejects invalid replies; follows established
  SOF validation pattern
- **Ratio:** Strong benefit, minimal risk

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real memory-safety bug (OOB read, allocation-size wrap)
- Small, surgical, obviously correct fix
- Buggy code exists in this 6.18.44 tree; fix not yet present
- Matches existing validation in `debug.c`
- Maintainer-reviewed (Mark Brown)
- Callers iterate using returned count after undersized allocation/copy

**AGAINST backport:**
- Config-limited (`CONFIG_SND_SOC_SOF_DEBUG_PROBES`)
- Trigger requires malformed SOF firmware IPC, not direct userspace
  input
- No syzbot/user report in commit message
- Mailing list review details unavailable

**Unresolved:**
- Full lore review thread and any explicit stable nominations (web
  access blocked)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is straightforward;
   maintainer sign-off; pattern proven elsewhere in SOF
2. Fixes a real bug affecting users? **PASS** — malformed firmware IPC
   can crash/affect SOF probe users
3. Important issue? **PASS** — HIGH severity memory safety
4. Small and contained? **PASS** — ~30 lines, 2 files
5. No new features or APIs? **PASS** — validation only
6. Can apply to local tree? **PASS** — code exists; patch context
   matches

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug-fix exception applies.

### Step 9.4: Decision Rationale

For **this** tree (6.18.44), the vulnerable probe IPC parsing code is
present and lacks bounds checking on firmware-provided element counts.
The fix is minimal, follows an established SOF pattern, and closes a
real kernel memory-safety hole that can be triggered when SOF probes are
in use and firmware returns inconsistent IPC data. While the feature is
config-specific and firmware-mediated, stable trees routinely take such
IPC validation fixes because the failure mode is kernel OOB access, not
a benign error return.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 1] Confirmed no `Fixes:`, `Reported-by:`, or syzbot references
- [Phase 2] Read diff hunks for `ipc3_probes_info()` and
  `ipc4_probes_points_info()`
- [Phase 2] Classified bug as unchecked firmware `num_elems` → OOB /
  overflow
- [Phase 3] `git describe HEAD` → `v6.18.44-1-g2736c32da98b9`; Makefile
  → 6.18.44
- [Phase 3] `git blame` on vulnerable lines → `5d324e5159d9e`
- [Phase 3] `git rev-parse --is-shallow-repository` → `true`
- [Phase 3] `grep "invalid probe info element count"` → no matches (fix
  absent)
- [Phase 4] `b4 dig -c HEAD` on wrong commit; target commit not in repo
- [Phase 4] WebFetch patch.msgid.link and lore search → blocked by bot
  protection
- [Phase 4] curl lore raw → 403 Forbidden
- [Phase 5] `grep` callers → `sof-client-probes.c:78`, `sof-client-
  probes.c:227`
- [Phase 5] Read `debug.c:227-231` — existing `num_elems` vs `hdr.size`
  validation
- [Phase 5] Read Kconfig — `SND_SOC_SOF_DEBUG_PROBES` auto-selected by
  HDA/ACP probe options
- [Phase 6] Read current `sof-client-probes-ipc3.c:102-148` — vulnerable
  code confirmed
- [Phase 6] Read current `sof-client-probes-ipc4.c:207-267` — vulnerable
  code confirmed
- [Phase 6] Verified patch context matches current tree contents
- [Phase 7] Read `sound/soc/sof/Makefile` — probes built under
  `CONFIG_SND_SOC_SOF_DEBUG_PROBES`
- [Phase 8] Traced failure modes: OOB read, size wrap, caller over-
  iteration
- **UNVERIFIED:** Lore review thread, stable-list discussion, explicit
  reviewer stable nomination

**YES**

 sound/soc/sof/sof-client-probes-ipc3.c | 23 +++++++++++++++++++----
 sound/soc/sof/sof-client-probes-ipc4.c | 11 ++++++++++-
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/sound/soc/sof/sof-client-probes-ipc3.c b/sound/soc/sof/sof-client-probes-ipc3.c
index a78ec0954a618..a3e382d6161f1 100644
--- a/sound/soc/sof/sof-client-probes-ipc3.c
+++ b/sound/soc/sof/sof-client-probes-ipc3.c
@@ -107,7 +107,7 @@ static int ipc3_probes_info(struct sof_client_dev *cdev, unsigned int cmd,
 	struct device *dev = &cdev->auxdev.dev;
 	struct sof_ipc_probe_info_params msg = {{{0}}};
 	struct sof_ipc_probe_info_params *reply;
-	size_t bytes;
+	size_t bytes, elem_size, payload_size;
 	int ret;
 
 	*params = NULL;
@@ -128,14 +128,29 @@ static int ipc3_probes_info(struct sof_client_dev *cdev, unsigned int cmd,
 	if (ret < 0 || reply->rhdr.error < 0)
 		goto exit;
 
+	payload_size = reply->rhdr.hdr.size;
+	if (payload_size < offsetof(struct sof_ipc_probe_info_params, dma)) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
 	if (!reply->num_elems)
 		goto exit;
 
 	if (cmd == SOF_IPC_PROBE_DMA_INFO)
-		bytes = sizeof(reply->dma[0]);
+		elem_size = sizeof(reply->dma[0]);
 	else
-		bytes = sizeof(reply->desc[0]);
-	bytes *= reply->num_elems;
+		elem_size = sizeof(reply->desc[0]);
+
+	payload_size -= offsetof(struct sof_ipc_probe_info_params, dma);
+	if (reply->num_elems > payload_size / elem_size) {
+		dev_err(dev, "%s: invalid probe info element count %u\n",
+			__func__, reply->num_elems);
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	bytes = reply->num_elems * elem_size;
 	*params = kmemdup(&reply->dma[0], bytes, GFP_KERNEL);
 	if (!*params) {
 		ret = -ENOMEM;
diff --git a/sound/soc/sof/sof-client-probes-ipc4.c b/sound/soc/sof/sof-client-probes-ipc4.c
index 758a56d271d77..2c2ab85979b83 100644
--- a/sound/soc/sof/sof-client-probes-ipc4.c
+++ b/sound/soc/sof/sof-client-probes-ipc4.c
@@ -248,10 +248,19 @@ static int ipc4_probes_points_info(struct sof_client_dev *cdev,
 		return ret;
 	}
 	info = msg.data_ptr;
+	if (msg.data_size < sizeof(*info) ||
+	    info->num_elems > (msg.data_size - sizeof(*info)) /
+			      sizeof(info->points[0])) {
+		dev_err(dev, "%s: invalid probe info element count %u\n",
+			__func__, info->num_elems);
+		kfree(msg.data_ptr);
+		return -EINVAL;
+	}
+
 	*num_desc = info->num_elems;
 	dev_dbg(dev, "%s: got %zu probe points", __func__, *num_desc);
 
-	*desc = kzalloc(*num_desc * sizeof(**desc), GFP_KERNEL);
+	*desc = kcalloc(*num_desc, sizeof(**desc), GFP_KERNEL);
 	if (!*desc) {
 		kfree(msg.data_ptr);
 		return -ENOMEM;
-- 
2.53.0

