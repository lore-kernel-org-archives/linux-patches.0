Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A944C8492;
	Mon, 19 Oct 2026 13:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418144; cv=none; b=cv5wmZPWt1Apn2CEM3UBbPb/y4XYrpCbQvr5vaI2dc3zW3Yv0+D22vktFTz/SHglVWHMG1p7ljzRHRHonkH25vO/t8TkznCcm+P1XgCUXCFDDGrYGsntQ99zfmWWgPlyOTApZ5rGTnRwfLNsZwOgrgT5PL5DXybqlbmHa4i5r5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418144; c=relaxed/simple;
	bh=KoCqBh4ZMbVOaPb383b2yMYthlaUGhUA6/S0Z5PuA0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jgkj1LCSQL+avwVZ042e2RkRkslMPpTmq/jBTnDPWfEtUI49i8LS4dj/tgK+SX+RXmc0bnp4qdLNnio3RBT2S6aYSjmqoE4zTBXkUAChUJw3qWEfXrES5DPWMj1JgYiYonaMj3oGJfUaErQwfov4B8qz/UtBt/For1DqOzi11N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pp5HnVg8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pp5HnVg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9174B1F000C4;
	Mon, 19 Oct 2026 13:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418142;
	bh=Tc20pTL7q6jmIQhtxrQ1Hu90HiPPdMpquY7s3JWz3Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pp5HnVg8QDme211qE8Ypdl86W34/OyQmnGnmLxfS7YWvg+zZ5nP2fiMd7XL0ZBctK
	 S8b+XKZT3aeU7M9Ikxvp8eH4wzjErxTNwJyVqQETmm/UZPnqJZr7zZWpaSu4GVSGp8
	 H/Jvx4vRQnTLPWrtr4KpCTo2WoX6+al3cTHYbwwooIZKoX7VjkC4w92Kk5xkjxbU9M
	 SzQRMsyb/CVpBBI+38zEXN+CXUmVreMJDgeRLBIbsSVMJWYYuNua3bFbkK/724v21y
	 j5aXjbccLlNzUPXO5+oZBMIUECjYTbTFaNz7igwiTaG5ssQ2UCgzkMOETr2wgCm8Vr
	 iX8SFkfw1ThfA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mathieu.poirier@linaro.org,
	linux-remoteproc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] remoteproc: qcom: Check subdev start status in rproc_stop()
Date: Mon, 19 Oct 2026 09:45:33 -0400
Message-ID: <20261019135441.1420968-42-sashal@kernel.org>
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

From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>

[ Upstream commit f44ae8ce156a387b07d40e2d6a0ef979a2748aa1 ]

For rproc that doing attach, rproc_start_subdevices() is called only when
attach successfully. If rproc_report_crash() is called in the attach
function, rproc_boot_recovery()->rproc_stop()->rproc_stop_subdevices()->
glink_subdev_stop() could be called and cause NULL pointer dereference:

 Unable to handle kernel NULL pointer dereference at virtual address 0000000000000300
 Mem abort info:
 ...
 pc : qcom_glink_smem_unregister+0x14/0x48 [qcom_glink_smem]
 lr : glink_subdev_stop+0x1c/0x30 [qcom_common]
 ...
 Call trace:
  qcom_glink_smem_unregister+0x14/0x48 [qcom_glink_smem] (P)
  glink_subdev_stop+0x1c/0x30 [qcom_common]
  rproc_stop+0x58/0x17c
  rproc_trigger_recovery+0xb0/0x150
  rproc_crash_handler_work+0xa4/0xc4
  process_scheduled_works+0x18c/0x2d8
  worker_thread+0x144/0x280
  kthread+0x124/0x138
  ret_from_fork+0x10/0x20
 Code: a9be7bfd 910003fd a90153f3 aa0003f3 (b9430000)
 ---[ end trace 0000000000000000 ]---

Introduce "subdevs_started" flag to indicate rproc_start_subdevices() has
been called successfully. Ensure subdevices are only stopped if they have
been started.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260623-rproc-attach-issue-v3-2-8e24310707ce@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **v7.3-rc4** (`7.3.0-rc4`). The change is a real NULL-deref
fix on the remoteproc attach/recovery path, and the triggering code is
present here.

## Phase 1: Commit message forensics

**Step 1.1: Subject**
Record: `[remoteproc/qcom] [Check] Check subdev start status in
rproc_stop()` — despite the `qcom:` prefix, the diff is in remoteproc
core, not a Qualcomm-only file.

**Step 1.2: Tags**
Record:
- `Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>` (author)
- `Link: https://lore.kernel.org/r/20260623-rproc-attach-
  issue-v3-2-8e24310707ce@oss.qualcomm.com`
- `Signed-off-by: Bjorn Andersson <andersson@kernel.org>` (subsystem
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable` (absence is expected for this review)
- Ignore any pipeline `Signed-off-by: Sasha Levin` — none present on
  this commit

**Step 1.3: Body**
Record:
- **Bug:** On attach, `rproc_start_subdevices()` runs only after attach
  succeeds. If `rproc_report_crash()` fires during attach, recovery
  calls `rproc_stop()` → `rproc_stop_subdevices()` →
  `glink_subdev_stop()` while GLINK was never started.
- **Symptom:** kernel NULL deref / oops (`qcom_glink_smem_unregister` at
  `pc` offset into a NULL `smem` pointer). Full stack in the message.
- **Root cause:** stop is not paired with a successful start.
- **Fix:** `subdevs_started` flag; skip stop unless start completed.
- **Version info:** none in the message. Link id `v3-2` = patch 2 of a
  3-patch series.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. Explicit crash + stack trace. Cover letter: “Failure
in rproc_attach() path can cause issues like NULL pointer dereference
when doing recovery.”

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- `drivers/remoteproc/remoteproc_core.c`: +7 (set flag on successful
  start; bail/clear on stop)
- `include/linux/remoteproc.h`: +2 (doc + `bool subdevs_started` in
  `struct rproc`)
- Functions: `rproc_start_subdevices()`, `rproc_stop_subdevices()`
- Scope: single-subsystem, surgical, 9 insertions

**Step 2.2: Code flow**
Record:
- **Before:** `rproc_stop_subdevices()` always walked `rproc->subdevs`
  and called `stop()`. `glink_subdev_stop()` always called
  `qcom_glink_smem_unregister(glink->edge)` with `edge` still NULL if
  start never ran.
- **After:** flag set only after a full successful start loop; stop is a
  no-op until then; flag cleared after stop.
- Path: attach failure + crash recovery (not the normal successful boot
  path).

**Step 2.3: Bug mechanism**
Record: **NULL pointer dereference (memory safety).**
Verified in this tree: `qcom_glink_smem_unregister()` does `smem->glink`
with no NULL check. Crash VA `0x300` matches a field access through
NULL. Same pattern in `smd_subdev_stop()`
(`qcom_smd_unregister_edge(smd->edge)`).

**Step 2.4: Fix quality**
Record: Obviously correct. `rproc_alloc()` uses `kzalloc`, so the flag
starts false. Partial start failure already unrolls via
`unroll_registration` and does not set the flag. Start/stop run under
`rproc->lock` (`rproc_boot`, `rproc_trigger_recovery`,
`__rproc_shutdown`). Regression risk is low; the flag is not a new UAPI.

## Phase 3: Git history

**Step 3.1: Blame**
Record: Subdevice start/stop dates to `7bdc9650f03604` (2016, “Introduce
subdevices”). The missing start-vs-stop pairing is old. This commit only
adds the flag.

**Step 3.2: Fixes tag**
Record: No `Fixes:` tag. Concrete trigger in this tree is
`qcom_pas_attach()` from `16472c99f4699` (“Add late attach support”,
2026-07-01), which calls `rproc_report_crash()` when the coprocessor
already crashed. That commit is an ancestor of HEAD.

**Step 3.3: Related file history**
Record: Same series, same author:
- `026a3fada4326` — [PATCH v3 1/3] async attach via `schedule_work()`
  (immediate parent)
- `f44ae8ce156a3` — this commit, 2/3
- `0ec167625b4fe` — [PATCH v3 3/3] cancel `crash_handler` on
  `rproc_add()` error

This patch does not use `attach_work`; it stands alone. Patch 1 makes
failed attach keep the rproc registered so recovery actually runs; patch
2 stops that recovery from oopsing.

**Step 3.4: Author**
Record: Jingyi Wang (Qualcomm). Subsystem maintainers Bjorn Andersson
and Mathieu Poirier were To:’d; Bjorn applied the series.

**Step 3.5: Dependencies**
Record: No new helpers. Needs existing `rproc_start_subdevices` /
`rproc_stop_subdevices` / `struct rproc` — all present. Can apply
without patch 1. This tree already has patch 1 and late-attach, so the
crash path is live here.

## Phase 4: Mailing list

**Step 4.1: Original discussion**
Record:
- `b4 dig -c f44ae8ce156a3` → https://patch.msgid.link/20260623-rproc-
  attach-issue-v3-2-8e24310707ce@oss.qualcomm.com
- Series: `[PATCH v3 0/3] remoteproc: improve robustness for
  rproc_attach fail cases`
- v1 used a NULL check; v2 introduced `subdevs_started`; v3 moved the
  flag into start/stop. Applied version is v3.
- No NAK in the saved thread. Bjorn: “Applied, thanks!”

**Step 4.2: Recipients**
Record: To Bjorn Andersson and Mathieu Poirier (REMOTEPROC maintainers);
Cc linux-remoteproc. Right people.

**Step 4.3: Bug report**
Record: No syzbot/bugzilla. Evidence is the oops in the commit (Qualcomm
attach/crash). Trigger is also in-tree: `qcom_pas_attach()` reports
crash if fatal IRQ is already high.

**Step 4.4: Series**
Record: 2/3. 1/3 is robustness (async attach). 3/3 is a UAF-style cancel
of crash work on `rproc_add()` failure. This patch is self-contained.

**Step 4.5: Stable list**
Record: lore.kernel.org/stable was blocked (Anubis). UNVERIFIED whether
anyone nominated this on stable@. No `Cc: stable` on the patch itself.

## Phase 5: Semantic / call graph

**Step 5.1: Functions**
Record: `rproc_start_subdevices`, `rproc_stop_subdevices`.

**Step 5.2: Callers**
Record:
- `rproc_start_subdevices`: `rproc_start()` (firmware boot),
  `__rproc_attach()` (attach)
- `rproc_stop_subdevices`: `rproc_stop()` (recovery/`__rproc_shutdown`),
  `__rproc_detach()` (attach recovery)

**Step 5.3: Callees**
Record: `subdev->start` / `subdev->stop` (GLINK, SMD, SSR, virtio).

**Step 5.4: Reachability**
Record: Yes. Qualcomm PAS attach: `rproc_add` → auto-boot attach work →
`rproc_boot` → `rproc_attach` → `qcom_pas_attach` → `rproc_report_crash`
→ `rproc_crash_handler_work` → `rproc_trigger_recovery` →
`rproc_boot_recovery` → `rproc_stop`. Matches the posted stack.
Coprocessor already crashed at probe is a real boot-time case.

**Step 5.5: Similar patterns**
Record: `smd_subdev_stop()` has the same NULL-edge unregister. Core flag
covers all subdevs, which is why v2 dropped a GLINK-only NULL check.

## Phase 6: This tree

**Step 6.1: Buggy code here?**
Record: Yes. `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
kernelversion` = `7.3.0-rc4`. Attach, late-attach crash report, GLINK
stop-without-NULL-check, and recovery all exist. The fix is already an
ancestor of HEAD (`git merge-base --is-ancestor f44ae8ce156a3 HEAD`
succeeded); that is apply-evidence, not the reason to accept it.

**Step 6.2: Backport difficulty**
Record: Clean apply on this tree (already applied). No conflicting
refactor of those two functions.

**Step 6.3: Alternate fix already here?**
Record: No other start/stop guard. Later commits (`0ec167625b4fe`,
`74ee3b2f57674`) address crash-work vs teardown, not this pairing.

## Phase 7: Subsystem

**Step 7.1:** Record: `drivers/remoteproc` — **IMPORTANT** (Qualcomm
DSP/modem/WiFi remoteprocs; not core mm/vfs, but widely used on
phones/embedded).

**Step 7.2:** Record: Actively developed (late attach, async attach,
crash-handler races in 2026).

## Phase 8: Impact and risk

**Step 8.1:** Record: Qualcomm (and any rproc) users who attach to an
already-running remoteproc. Config: `CONFIG_REMOTEPROC` plus QCOM
PAS/GLINK. Not universal, but a large device population.

**Step 8.2:** Record: Trigger = attach while the remote CPU already
crashed (fatal IRQ high) or crash during attach. Seen in the field (oops
dump). Not a pure theoretical race; crash work vs `rproc->lock` is
ordered, then stop runs on unstarted subdevs.

**Step 8.3:** Record: Kernel oops / NULL deref. **HIGH/CRITICAL**.

**Step 8.4:** Record: Benefit high (avoids oops during subsystem
recovery). Risk very low (9 lines, internal bool, kzalloc-zeroed, lock-
held).

## Phase 9: Synthesis

**Step 9.1: Evidence**
**For:**
- Real oops with stack; `qcom_glink_smem_unregister(NULL)` is visible in
  code
- In-tree trigger: `qcom_pas_attach()` + recovery
- This tree has late attach and async attach, so the path is reachable
- Small, obviously correct, maintainer-applied (v3)
- No new UAPI

**Against:**
- Part of a 3-patch series (1/3 is behavioral); this hunk does not need
  1/3
- No `Fixes:` / `Cc: stable` (not a negative per rules)
- Adds a `struct rproc` field (in-tree only; kzalloc-safe)

**Unresolved:** Stable mailing-list discussion (lore/stable fetch
blocked).

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — pairing is clear; oops is
   the test evidence; maintainer applied v3
2. Real user-visible bug? **PASS** — NULL deref oops
3. Important (crash/security/corruption/deadlock)? **PASS** — oops on
   attach/recovery
4. Small and contained? **PASS** — 9 lines, two functions + one bool
5. No new features/APIs? **PASS** — internal flag
6. Applies to this tree? **PASS** — files and call paths exist; would
   apply cleanly

**Step 9.3: Exception category**
Record: None. Ordinary crash fix.

**Step 9.4: Decision**
This tree needs the fix: attach can report a crash before subdevices
start, and `rproc_stop_subdevices()` would then oops. The change is
minimal and correct.

### What it solves for this tree
If a Qualcomm remoteproc is already crashed when Linux attaches (or
crashes during attach), recovery calls `rproc_stop()` while GLINK/SMD
were never started. That is a kernel oops, not a soft failure. The flag
makes stop a no-op until start has succeeded.

### Risk vs benefit
Benefit: prevent a boot/recovery oops on common Qualcomm attach
hardware. Risk: negligible; flag is zero-initialized and only mutated
under `rproc->lock`.

### Concerns
Patch 1/3 is not required for this hunk. Patch 3/3 is a separate
teardown UAF. Neither blocks applying this commit here. No `Fixes:` tag;
the late-attach crash report (`16472c99f4699`) is in this tree and is
the practical introducer of the reported path.

## Verification
- [Phase 1] Parsed tags: author SOB, maintainer SOB, lore Link v3-2; no
  Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +7 core, +2 header; flag on successful start; early
  return in stop
- [Phase 2] `qcom_glink_smem_unregister()`: `smem->glink` with no NULL
  check — matches oops at VA `0x300`
- [Phase 3] `git describe HEAD`: `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion`: `7.3.0-rc4`
- [Phase 3] `git merge-base --is-ancestor f44ae8ce156a3 HEAD`: yes
  (applies/is present)
- [Phase 3] Parent `026a3fada4326` is series 1/3 (async attach); 3/3 is
  `0ec167625b4fe`
- [Phase 3] Blame: start/stop from 2016; flag from this commit
- [Phase 3] Trigger `qcom_pas_attach` crash report from `16472c99f4699`
  (in this tree, before this fix)
- [Phase 4] `b4 dig -c f44ae8ce156a3`: lore thread; v1→v3; Bjorn
  applied; no NAK
- [Phase 4] `b4 dig -w`: To Andersson + Poirier
- [Phase 4] Cover letter v2: flag replaced a GLINK-only NULL check
- [Phase 4] UNVERIFIED: stable@ discussion (lore/stable Anubis 403)
- [Phase 5] Call chain verified: `qcom_pas_attach` →
  `rproc_report_crash` → `rproc_crash_handler_work` →
  `rproc_trigger_recovery` → `rproc_stop` → `rproc_stop_subdevices`
- [Phase 5] `rproc_alloc()` uses `kzalloc` — flag starts false
- [Phase 5] `rproc_boot` / `rproc_trigger_recovery` / `__rproc_shutdown`
  hold `rproc->lock` around start/stop
- [Phase 6] Buggy stop-without-start exists conceptually; this tree has
  attach + late-attach trigger
- [Phase 8] Failure mode: NULL deref oops, severity HIGH/CRITICAL

**YES**

 drivers/remoteproc/remoteproc_core.c | 7 +++++++
 include/linux/remoteproc.h           | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 2336c55eb021d..068a3ef467f78 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1104,6 +1104,8 @@ static int rproc_start_subdevices(struct rproc *rproc)
 		}
 	}
 
+	rproc->subdevs_started = true;
+
 	return 0;
 
 unroll_registration:
@@ -1119,10 +1121,15 @@ static void rproc_stop_subdevices(struct rproc *rproc, bool crashed)
 {
 	struct rproc_subdev *subdev;
 
+	if (!rproc->subdevs_started)
+		return;
+
 	list_for_each_entry_reverse(subdev, &rproc->subdevs, node) {
 		if (subdev->stop)
 			subdev->stop(subdev, crashed);
 	}
+
+	rproc->subdevs_started = false;
 }
 
 static void rproc_unprepare_subdevices(struct rproc *rproc)
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index de98462d58889..ef711a5b1a7f2 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -273,6 +273,7 @@ enum rproc_features {
  * @has_iommu: flag to indicate if remote processor is behind an MMU
  * @auto_boot: flag to indicate if remote processor should be auto-started
  * @sysfs_read_only: flag to make remoteproc sysfs files read only
+ * @subdevs_started: flag to indicate if subdevs have started
  * @dump_segments: list of segments in the firmware
  * @nb_vdev: number of vdev currently handled by rproc
  * @elf_class: firmware ELF class
@@ -317,6 +318,7 @@ struct rproc {
 	bool has_iommu;
 	bool auto_boot;
 	bool sysfs_read_only;
+	bool subdevs_started;
 	struct list_head dump_segments;
 	int nb_vdev;
 	u8 elf_class;
-- 
2.53.0

