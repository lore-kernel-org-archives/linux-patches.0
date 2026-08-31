Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC714A49A1;
	Mon, 31 Aug 2026 13:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183814; cv=none; b=hxpfpa3dMG0Pm7XdIQKX4r2w+hxtZ7Wx+8PzdmZl9bHThDebioujbHl+Iejo0cmSyNVnYwlg/5O9iBhpuKRc2l+PUdMgCyV3kEcx7prlIbPChF5q5hZBusAwWQgOOiitc55A+nxMPniiIivh0+iK8PAx+i5kWI4R9BOVNqoR/2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183814; c=relaxed/simple;
	bh=sVyr8foC6HYCvrx8Cque7mZDWQkB3fi3pNelniF0yfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GhNZpXgT1hx/gtqQ6Iv+YDuyaZSys0SkjlRg6QIg+7+gKPbRZmW7Ggx8fTRUF0xEJyzFAq2oLh9k42qlbgz52l8fcoOp2A2BDXU0XSvDPfpF2jVGQqqGNQruRZhh8R6nNyeuYjQpmr7pyuhepEP6wdEtQHcHyh/uTuoFy1eW3N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cHcWbP2R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cHcWbP2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174D51F000E9;
	Mon, 31 Aug 2026 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183810;
	bh=rOKKgiKls+fMCU+mwXra6P3qUafxkT02LD6xOduHgow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cHcWbP2RKD4r7kOfLHXlktKuMg6JH09cvIXd7/Ln0Asnlne4gwRO0fFdFi5JMOkLB
	 Z0WD1V99wN2aaJNNiTQAgP783YYqPrNSDL4A2U+Cnp9mUJstJJl+I/Q3fwwGWt3YZV
	 4Sgk6+ei9o19ndq5JzLbAuhJe9cfN4RGna0uq7IGfeLPq8freCSufJ2OU1Py4DU6Ya
	 KB+plFussJl0xcS2P8x8JZwXlVpDzgQUX7VxqW+FbAKvkq15NwPKZBlUbKCbpYCGMp
	 tAr8u27/x/Eb5/TntWjuLroAIn5+ZlCl0XFIvm+qfhb4iE7dBYuCNAs8TsRrKRbRE6
	 zN1lujZx4fPXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: usb-audio: qcom: Free QMI handle
Date: Mon, 31 Aug 2026 09:25:46 -0400
Message-ID: <20260831133314.4125787-318-sashal@kernel.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit b8ff1f3578f83dedf5feb796d97a3f67c1bea58f ]

qc_usb_audio_probe() allocates svc->uaudio_svc_hdl separately from the
uaudio_qmi_svc object.

qmi_handle_release() releases the resources owned by an initialized QMI
handle, but does not free the memory containing the struct qmi_handle
itself. The probe error path and the remove path currently release the
handle and then free svc, losing the last pointer to the separately
allocated handle.

This leaks one struct qmi_handle on each affected probe unwind and on
each successful probe/remove cycle.

Free the handle after qmi_handle_release() in both paths.

Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/9108EC860F3F87DF+20260623071308.2549182-1-raoxu@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA: usb-audio: qcom: Free QMI handle

**Local tree:** `v6.18.44` (Linux 6.18.y stable)
**Upstream fix:** `b8ff1f3578f83` (on `master`, not yet in this tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ALSA: usb-audio: qcom]` `[Free]` — free a separately
allocated QMI handle that was leaked on probe error and remove paths.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Xu Rao `<raoxu@uniontech.com>` (author)
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA maintainer,
  committer)
- **Link:** https://patch.msgid.link/9108EC860F3F87DF+20260623071308.254
  9182-1-raoxu@uniontech.com
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`
- Notable: maintainer (Takashi Iwai) applied and committed the patch

### Step 1.3: Body analysis
**Record:**
- **Bug:** `svc->uaudio_svc_hdl` is `kzalloc()`'d separately from
  `struct uaudio_qmi_svc`. `qmi_handle_release()` tears down handle
  resources but does not free the `struct qmi_handle` memory. After
  `kfree(svc)`, the handle allocation is orphaned.
- **Symptom:** One `struct qmi_handle` leaked per probe unwind (error
  path) and per successful probe/remove cycle.
- **Root cause:** Mismatch between separate allocation and release API
  semantics (`qmi_handle_release()` vs. `kfree()`).
- **Version info:** None stated; bug present since driver introduction.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit, straightforward memory-leak fix,
not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `sound/usb/qcom/qc_audio_offload.c` (+2 / -0)
- **Functions:** `qc_usb_audio_probe()`, `qc_usb_audio_remove()`
- **Scope:** Single-file, surgical fix (2 lines)

### Step 2.2: Code flow per hunk

**Hunk 1 — `release_qmi` error path in `qc_usb_audio_probe()`:**
- **Before:** `qmi_handle_release(svc->uaudio_svc_hdl);` → `kfree(svc);`
  — handle struct leaked
- **After:** `qmi_handle_release()` then `kfree(svc->uaudio_svc_hdl)`
  then `kfree(svc)`

**Hunk 2 — `qc_usb_audio_remove()`:**
- **Before:** Same leak on every module remove
- **After:** `kfree(svc->uaudio_svc_hdl)` added after
  `qmi_handle_release()`

### Step 2.3: Bug mechanism
**Record:** **Category:** Error-path / resource leak (missing `kfree` on
separately allocated object).
**Mechanism:** `uaudio_svc_hdl` is a pointer field in `struct
uaudio_qmi_svc` pointing to a separately `kzalloc()`'d `struct
qmi_handle`. `qmi_handle_release()` (documented and implemented in
`drivers/soc/qcom/qmi_interface.c`) frees internal resources
(`recv_buf`, service list entries, etc.) but explicitly does not free
the handle struct itself — callers must do that, as
`drivers/slimbus/qcom-ngd-ctrl.c` does with `devm_kfree()` after
`qmi_handle_release()`.

### Step 2.4: Fix quality
**Record:** Obviously correct; mirrors established QMI caller pattern.
Minimal, no API changes. No meaningful regression risk — `kfree()` is
called after full `qmi_handle_release()` and before `kfree(svc)`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy allocation introduced in `326bbc348298a` ("ALSA: usb-
audio: qcom: Introduce QC USB SND offloading support", 2025-04-11).
Driver is an ancestor of `v6.18` — bug has been present since the driver
landed in this release series.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag present.

### Step 3.3: Related file history
**Record:** Recent related fixes in this file from the same
author/subsystem:
- `1467ca02ddac4` — "Free sideband sg_table objects" (same leak pattern,
  already in this 6.18.y tree)
- `e7144a2b3ac8d` — error-path cleanup in `qc_usb_audio_probe()`
- `5c7ef5001292d` — xfer_buf leak fix

Standalone fix; original submission was `[PATCH 1/3]` but v2 was applied
as a single patch by Takashi Iwai with no series dependencies.

### Step 3.4: Author context
**Record:** Xu Rao (Uniontech) — active contributor to Qualcomm USB
audio offload leak fixes. Takashi Iwai (ALSA maintainer) committed the
fix.

### Step 3.5: Dependencies
**Record:** None. Applies standalone; no prerequisite commits or
structural assumptions beyond code already in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:** https://lists.openwall.net/linux-kernel/2026/06/23/512
- **Series:** Originally `[PATCH 1/3]`; v2 submitted as single patch
- **Maintainer response:** Takashi Iwai: "Applied now. Thanks."
  (https://lists.openwall.net/linux-kernel/2026/06/25/1001)
- No NAKs, no stable nomination in thread
- `b4 dig -c` could not be used (commit not in current HEAD); lore found
  via openwall mirror

### Step 4.2: Reviewers
**Record:** CC'd: Jaroslav Kysela, Takashi Iwai, Greg Kroah-Hartman,
Kees Cook, linux-sound, linux-kernel. Appropriate subsystem maintainers
included.

### Step 4.3: Bug report
**Record:** No syzbot, kmemleak, or user bug report. Found via code
review.

### Step 4.4: Related patches
**Record:** Patches 2/3 of the original series were not committed with
this fix; the applied upstream commit is self-contained.

### Step 4.5: Stable list
**Record:** No stable-specific discussion found for this exact patch.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `qc_usb_audio_probe()`, `qc_usb_audio_remove()`

### Step 5.2: Callers
**Record:** Registered as `.probe`/`.remove` in
`qc_usb_audio_offload_drv` auxiliary driver table. Invoked during
auxiliary device probe/remove on Qualcomm platforms with
`CONFIG_SND_USB_AUDIO_QMI`.

### Step 5.3: Callees
**Record:** `kzalloc()`, `qmi_handle_init()`, `qmi_add_server()`,
`qmi_handle_release()`, `kfree()`, `qc_usb_audio_cleanup_qmi_dev()`,
`snd_usb_register_platform_ops()`

### Step 5.4: Reachability
**Record:** Triggered at module/auxiliary-device load and unload on
systems with Qualcomm USB audio offload enabled
(`CONFIG_SND_USB_AUDIO_QMI=y/m`, requires `QCOM_QMI_HELPERS`,
`USB_XHCI_SIDEBAND`). Not userspace-triggerable directly, but hits every
probe error and every clean module remove.

### Step 5.5: Similar patterns
**Record:** `drivers/slimbus/qcom-ngd-ctrl.c` correctly calls
`qfree`/`devm_kfree` after `qmi_handle_release()`. Same author's
`1467ca02ddac4` fixed an analogous separate-allocation leak in this same
driver.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree at
`sound/usb/qcom/qc_audio_offload.c`:
- Line 1968: separate `kzalloc(sizeof(*svc->uaudio_svc_hdl))`
- Lines 1996–1998: `release_qmi` path missing
  `kfree(svc->uaudio_svc_hdl)`
- Lines 2020–2021: `remove` path missing `kfree(svc->uaudio_svc_hdl)`
- Upstream fix `b8ff1f3578f83` is **not** an ancestor of HEAD (`git
  merge-base --is-ancestor` exit 1)

### Step 6.2: Backport difficulty
**Record:** Clean apply expected — the `release_qmi` and `remove` paths
match upstream context exactly.

### Step 6.3: Related fixes already present?
**Record:** `1467ca02ddac4` (sg_table leak, same driver/author) is
already in this tree — strong precedent that this class of leak fix is
accepted for 6.18.y.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **IMPORTANT** — ALSA USB audio driver, Qualcomm-specific
offload path. Not core kernel, but affects real hardware (Snapdragon
laptops/tablets with USB XHCI sideband audio offload).

### Step 7.2: Activity
**Record:** Actively maintained; multiple bug fixes in 2025–2026
including several leak fixes backported to stable.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with `CONFIG_SND_USB_AUDIO_QMI` on Qualcomm platforms
using USB audio offload. Config-specific, platform-specific — not
universal.

### Step 8.2: Trigger conditions
**Record:**
- Every successful driver remove (module unload, device unbind)
- Probe error after QMI init when `snd_usb_register_platform_ops()`
  fails
- Unprivileged users cannot directly trigger; requires platform hardware
  and driver loaded
- **Likelihood:** Once per boot cycle on affected systems (remove path);
  probe error path is rarer

### Step 8.3: Failure mode severity
**Record:** **LOW** — small memory leak (~one `struct qmi_handle` per
cycle, roughly a few hundred bytes including embedded lists already
freed by `qmi_handle_release()`). No crash, corruption, deadlock, or
security exposure. Would require repeated load/unload to accumulate
meaningfully.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Eliminates a real, confirmed leak on an established code
  path; aligns with prior stable backports in this exact driver
- **Risk:** Very low — 2-line addition, established QMI pattern, no
  behavior change beyond freeing leaked memory
- **Ratio:** Moderate benefit for niche users, very low risk; precedent
  in this tree tips toward inclusion

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verified memory leak in code present since driver introduction
- Obviously correct 2-line fix matching QMI subsystem conventions
- Driver exists in v6.18; bug affects this tree
- Same author fixed an analogous leak (`1467ca02ddac4`) already
  backported to this 6.18.y tree by Greg Kroah-Hartman
- ALSA maintainer reviewed and applied upstream
- Clean apply, no dependencies

**AGAINST backport:**
- Low severity (small leak, not crash/corruption/security)
- Niche hardware/config (`CONFIG_SND_USB_AUDIO_QMI`)
- No fuzzer or user reports
- Strict reading of "important issue" criterion is borderline for pure
  leaks

**Unresolved:** Whether patches 2/3 of the original `[PATCH 1/3]` series
were ever needed — upstream committed only this standalone fix.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — correct by inspection;
   maintainer-applied upstream
2. Fixes a real bug? **PASS** — confirmed memory leak
3. Important issue? **PASS (borderline)** — not crash/security, but real
   leak on remove path; same class already accepted in this tree
4. Small and contained? **PASS** — 2 lines, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code present, clean apply
   expected

### Step 9.3: Exception categories
**Record:** None directly (not device ID, quirk, DT, build, or docs).
Standard resource-leak fix.

### Step 9.4: Decision rationale

This is a genuine memory leak on the driver remove path and probe error
path in `sound/usb/qcom/qc_audio_offload.c`, present in Linux 6.18 since
the Qualcomm USB audio offload driver was introduced. The fix is
minimal, obviously correct, and follows the established QMI handle
lifecycle pattern used elsewhere in the Qualcomm subsystem.

While the leak severity is low (one small allocation per module cycle on
niche hardware), this 6.18.y tree has already accepted a nearly
identical class of fix from the same author in the same file
(`1467ca02ddac4` — "Free sideband sg_table objects"). That establishes
clear precedent that resource-leak fixes in this driver are appropriate
for 6.18.y stable. The fix is not yet in the local tree (`b8ff1f3578f83`
is on `master` only) and should be backported.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 1]** Confirmed no syzbot/Reported-by; Takashi Iwai Signed-
  off-by present
- **[Phase 2]** Read current `qc_audio_offload.c` lines 1957–2023: leak
  confirmed on both paths
- **[Phase 2]** Read `qmi_handle_release()` at
  `drivers/soc/qcom/qmi_interface.c:687-719`: does not free `struct
  qmi_handle` itself
- **[Phase 2]** Read `drivers/slimbus/qcom-ngd-ctrl.c:496-508`:
  precedent for caller freeing handle after release
- **[Phase 3]** `git describe HEAD`: `v6.18.44`
- **[Phase 3]** `git blame` lines 1968–2021: introduced in
  `326bbc348298a` (2025-04-11)
- **[Phase 3]** `git merge-base --is-ancestor 326bbc348298ab v6.18`:
  driver in v6.18 release
- **[Phase 3]** `git merge-base --is-ancestor b8ff1f3578f83 HEAD`: exit
  1 — fix NOT in current tree
- **[Phase 3]** `git show 1467ca02ddac4`: analogous leak fix already in
  this tree (committed by Greg K-H)
- **[Phase 4]** Fetched https://lists.openwall.net/linux-
  kernel/2026/06/23/512: original patch submission
- **[Phase 4]** Fetched https://lists.openwall.net/linux-
  kernel/2026/06/25/1001: Takashi Iwai "Applied now"
- **[Phase 4]** `b4 dig -c HEAD`: not applicable (commit not in HEAD);
  lore accessed via openwall
- **[Phase 5]** `grep qc_usb_audio_probe`: only auxiliary driver probe
  entry
- **[Phase 5]** Read `include/linux/soc/qcom/qmi.h:216-238`: `struct
  qmi_handle` definition
- **[Phase 6]** Confirmed buggy code at lines 1996–1998 and 2020–2021 in
  local tree
- **[Phase 6]** `grep kfree.*uaudio_svc_hdl` in tree: no matches — fix
  absent
- **[Phase 6]** Read `sound/usb/Kconfig:191-197`:
  `CONFIG_SND_USB_AUDIO_QMI` dependencies
- **[Phase 8]** Assessed severity as LOW leak, not crash/security

**YES**The background checks finished and match the earlier analysis:

- **Fix location:** `b8ff1f3578f83` ("ALSA: usb-audio: qcom: Free QMI
  handle") is on `master` but **not** in the current `v6.18.44` tree —
  so the leak is still present locally.
- **Author context:** Xu Rao has several similar QMI/resource-leak fixes
  in this area, including `1467ca02ddac4` (sideband `sg_table` leak),
  which is already in this 6.18.y tree.

That supports the **YES** backport recommendation: real leak, trivial
fix, and precedent for the same driver in this stable series.

 sound/usb/qcom/qc_audio_offload.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/qcom/qc_audio_offload.c b/sound/usb/qcom/qc_audio_offload.c
index da2759f2ee866..62a57b8d171b8 100644
--- a/sound/usb/qcom/qc_audio_offload.c
+++ b/sound/usb/qcom/qc_audio_offload.c
@@ -1994,6 +1994,7 @@ static int qc_usb_audio_probe(struct auxiliary_device *auxdev,
 release_qmi:
 	qc_usb_audio_cleanup_qmi_dev();
 	qmi_handle_release(svc->uaudio_svc_hdl);
+	kfree(svc->uaudio_svc_hdl);
 free_svc:
 	kfree(svc);
 
@@ -2018,6 +2019,7 @@ static void qc_usb_audio_remove(struct auxiliary_device *auxdev)
 	qc_usb_audio_cleanup_qmi_dev();
 
 	qmi_handle_release(svc->uaudio_svc_hdl);
+	kfree(svc->uaudio_svc_hdl);
 	kfree(svc);
 	uaudio_svc = NULL;
 }
-- 
2.53.0

