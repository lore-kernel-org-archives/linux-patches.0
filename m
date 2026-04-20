Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39993AB28C;
	Mon, 20 Apr 2026 13:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691953; cv=none; b=nFmAETtKMSxPe1bUErA99EC/ygzDb42MxTViIkJatQeIoI8tNGsLXGhZ8gL82x5tLb1pl6dmhZzKVHW7kCYaEIXST0f0d/C+CD/Y+hIn5axrQ+vlA61qPcBlVg2Hue97BFR3rMQDxcXIVFIwoE3Os2/ohKTY6pz5OwW/5IFjNTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691953; c=relaxed/simple;
	bh=SxAhPlJl50t6Cqe24P0zzjs1/5e1F/Oz+usuCupB2zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VPvW8zjpU6vmP8GlFxnx6V7sohMGNrwYsnc2lVDdZtd2oKiWCcm8wLZP/5+p9327OY0GmsgyQ00FpLaOU2XERMipReDUI72KBeq767dHQfRvsXHwchimE3hlmJGnZr127K0TH2XsVMJVujg4HqohAcpxsbQopX+Th3DDOEVOY8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mCWqNubd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mCWqNubd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F21C2BCB4;
	Mon, 20 Apr 2026 13:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691953;
	bh=SxAhPlJl50t6Cqe24P0zzjs1/5e1F/Oz+usuCupB2zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCWqNubdWzV7xF9T4sSaAF8VkewQKmPxKa1yVGgWufijYFU+fz4bk9uHueUd8O+WL
	 rhfB8wxCTP1eOilG/qSEX2Ocs7RX3A3CDzNBei2xdevOLxnhbi/gvVDENgOibsY2Vb
	 xna0hGIFP7kH+Bq9VxXd/8NQskro35ex/oN+F69d8MN9zc2+AHCUn6MnWlG+C9PX/I
	 Zm9ym8N10H4ZOYvb/bbhtmS5C3OEoCefva0pOnf5pHmrHmiwDBTD4OM1ujBwNCb+Jy
	 oKzvjIsixsYU+XM0hMdNbULwrecJc8b4+d0t8DLPz0iEU1vaRZVRrnpVE+NSbVKrrD
	 IAUyfyTrOw7xQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] ALSA: pcm: Use pcm_lib_apply_appl_ptr() in x32 sync_ptr
Date: Mon, 20 Apr 2026 09:21:22 -0400
Message-ID: <20260420132314.1023554-288-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 1e512ac1254c8e370dd18efe9da4dfc92492cdc5 ]

snd_pcm_ioctl_sync_ptr_x32() still handles incoming appl_ptr updates
differently from the other SYNC_PTR paths. The native handler and the
32-bit compat handler both pass appl_ptr through pcm_lib_apply_appl_ptr(),
but the x32 handler still writes control->appl_ptr directly.

That direct assignment skips the common appl_ptr validation against
runtime->boundary and also bypasses the substream ack() callback.
This makes the x32 ioctl path behave differently from the native and
compat32 cases, and it can miss the driver notification that explicit
appl_ptr synchronization relies on.

Use pcm_lib_apply_appl_ptr() for x32 too, so appl_ptr updates are
validated consistently and drivers relying on ack() notifications
see the same behavior.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260321-alsa-pcm-x32-sync-ptr-v1-1-02ce655657c6@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information I need. Let me compile my complete
analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `ALSA: pcm` (sound/core PCM subsystem)
- Action verb: "Use" — indicates replacing incorrect implementation with
  the correct one
- Summary: Make x32 sync_ptr use `pcm_lib_apply_appl_ptr()` instead of
  direct assignment
Record: [ALSA: pcm] [Use] [Apply correct appl_ptr update function in x32
ioctl path]

**Step 1.2: Tags**
- `Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>` —
  author
- `Link: https://patch.msgid.link/20260321-alsa-pcm-x32-sync-
  ptr-v1-1-02ce655657c6@gmail.com` — v1, patch 1/1 (standalone)
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` — ALSA subsystem
  maintainer accepted the patch
- No Fixes: tag (expected for review candidates)
- No Reported-by: (found by code inspection)
Record: Patch accepted by subsystem maintainer (Takashi Iwai). Single
standalone patch.

**Step 1.3: Commit Body Analysis**
- Bug described: x32 sync_ptr handler directly writes
  `control->appl_ptr` instead of using `pcm_lib_apply_appl_ptr()`
- Consequence 1: Skips appl_ptr validation against `runtime->boundary`
- Consequence 2: Bypasses the `substream->ops->ack()` callback
- Symptom: Inconsistent behavior between x32 and native/compat32 paths;
  drivers relying on ack() won't get notifications
- The commit explicitly notes the FIXME comment that previously flagged
  this issue
Record: Missing boundary validation + missing ack() callback in x32
path. Drivers using explicit appl_ptr sync see wrong behavior.

**Step 1.4: Hidden Bug Fix Detection**
This IS a bug fix despite not using "fix" in the subject. "Use
pcm_lib_apply_appl_ptr()" means "stop skipping validation and driver
callbacks." The existing FIXME comment in the old code explicitly
acknowledged missing boundary handling.
Record: Yes, this is a real bug fix — restores missing validation and
driver notification.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files: `sound/core/pcm_compat.c` (+4, -3 net change)
- Function modified: `snd_pcm_ioctl_sync_ptr_x32()`
- Scope: Single-file, single-function surgical fix
Record: 1 file, ~7 lines changed, single function, minimal scope.

**Step 2.2: Code Flow Change**
Before: Inside `scoped_guard(pcm_stream_lock_irq)`:
```c
/* FIXME: we should consider the boundary for the sync from app */
if (!(sflags & SNDRV_PCM_SYNC_PTR_APPL))
    control->appl_ptr = scontrol.appl_ptr;
else
    scontrol.appl_ptr = control->appl_ptr % boundary;
```

After:
```c
if (!(sflags & SNDRV_PCM_SYNC_PTR_APPL)) {
    err = pcm_lib_apply_appl_ptr(substream, scontrol.appl_ptr);
    if (err < 0)
        return err;
} else {
    scontrol.appl_ptr = control->appl_ptr % boundary;
}
```

The direct assignment is replaced with `pcm_lib_apply_appl_ptr()` which:
1. Validates `appl_ptr >= runtime->boundary` → returns `-EINVAL`
2. Checks NO_REWINDS constraint
3. Assigns `runtime->control->appl_ptr = appl_ptr`
4. Calls `substream->ops->ack()` and rolls back on failure
5. Emits `trace_applptr()` tracepoint
Record: Before = raw assignment without validation. After = validated,
with ack callback and error handling.

**Step 2.3: Bug Mechanism**
Category: Logic/correctness fix — missing validation and missing
callback invocation.
- Boundary validation bypass could allow setting appl_ptr to invalid
  value
- Missing ack() means audio drivers relying on explicit sync won't
  receive DMA buffer notifications
Record: Correctness bug — missing validation + missing driver
notification on x32 ioctl path.

**Step 2.4: Fix Quality**
- Obviously correct: makes x32 match the native handler
  (pcm_native.c:3140), compat32 handler (pcm_native.c:3242), and buggy
  compat handler (pcm_compat.c:504) — all already use
  `pcm_lib_apply_appl_ptr()`
- Minimal and surgical: replaces 2 lines with 4 lines in one function
- Regression risk: Very low — the error return path is new but is the
  same pattern used by all other sync_ptr paths
Record: Fix is obviously correct by comparison with 3 other identical
code paths. Minimal. Very low regression risk.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- The x32 handler was introduced by commit `513ace79b657e2` (Takashi
  Iwai, 2016-02-28): "ALSA: pcm: Fix ioctls for X32 ABI"
- The `scoped_guard` refactor was applied in `650224fe8d5f6d` (Takashi
  Iwai, 2024-02-27)
- The buggy direct assignment has been present since 2016
Record: Buggy code introduced in 2016 (v4.6 era). Present in all active
stable trees.

**Step 3.2: Related Fixes**
Commit `9027c4639ef1` (2017-05-25): "ALSA: pcm: Call ack() whenever
appl_ptr is updated" — introduced `pcm_lib_apply_appl_ptr()` and added
it to the native sync_ptr handler, but did NOT update the x32 handler.

Commit `2e2832562c877` (2021-07-12): "ALSA: pcm: Call substream ack()
method upon compat mmap commit" — fixed the same bug for the compat32
path. **This commit had `Fixes: 9027c4639ef1` and `Cc:
<stable@vger.kernel.org>`**, establishing precedent that this class of
bug is stable-worthy.
Record: Identical bug in compat32 was fixed (2e2832562c877) with
explicit stable nomination. x32 was missed.

**Step 3.3: File History**
Recent changes to pcm_compat.c are mostly refactoring (scoped_guard,
sync_ptr_get_user macros, kfree cleanup). No other pending fixes.
Record: Standalone fix, no dependencies on uncommitted work.

**Step 3.4: Author**
Author (Cássio Gabriel) has one other commit in the sound subsystem (SOF
topology parser). Patch was accepted by Takashi Iwai, the ALSA subsystem
maintainer.
Record: Patch reviewed and accepted by subsystem maintainer.

**Step 3.5: Dependencies**
This patch depends on the `scoped_guard` refactor (`650224fe8d5f6`, in
v6.12+) and the `snd_pcm_sync_ptr_get_user` macro refactor
(`2acd83beb4d3f`, not in any current stable). For older stable trees,
context adaptation would be needed but the core change is the same.
Record: Clean apply on v7.0. Minor context adaptation needed for older
stable trees due to locking and macro differences.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Patch Discussion**
- `b4 dig` could not find the patch by commit hash (this is a 7.0
  autosel candidate). The patch link uses msgid `20260321-alsa-
  pcm-x32-sync-ptr-v1-1-02ce655657c6@gmail.com`.
- lore.kernel.org was blocked by anti-bot protection.
- The patch is v1, patch 1/1 — a single standalone fix.
Record: Single standalone patch, v1. Could not access lore due to anti-
bot protection.

**Step 4.2: Reviewers**
- Signed-off-by Takashi Iwai (ALSA maintainer) — the most authoritative
  reviewer for this code.
Record: Subsystem maintainer reviewed and merged.

**Step 4.3: Bug Report**
No explicit bug report — found by code inspection (comparing x32 path to
native/compat32).
Record: Found by code audit comparing inconsistent ioctl paths.

**Step 4.4: Related Patches**
The earlier compat32 fix (`2e2832562c877`) explicitly requested stable
backport. This x32 fix addresses the exact same gap.
Record: Prior compat32 fix was explicitly Cc: stable.

**Step 4.5: Stable History**
The compat32 variant of this fix was backported to stable. The x32
variant was not previously submitted.
Record: Identical bug class was previously deemed stable-worthy.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
- `snd_pcm_ioctl_sync_ptr_x32()` — the only function changed
Record: Single function modified.

**Step 5.2: Callers**
`snd_pcm_ioctl_sync_ptr_x32()` is called from `snd_pcm_ioctl_compat()`
(line 594) when `in_x32_syscall()` is true and the ioctl is
`__SNDRV_PCM_IOCTL_SYNC_PTR64`. This is reachable from userspace via the
compat ioctl syscall from any x32 process using PCM.
Record: Reachable from userspace ioctl on x32 ABI.

**Step 5.3-5.4: Call Chain**
Userspace → compat_ioctl syscall → `snd_pcm_ioctl_compat()` →
`snd_pcm_ioctl_sync_ptr_x32()` → (now) `pcm_lib_apply_appl_ptr()` →
`substream->ops->ack()`.
Record: Directly reachable from userspace syscalls.

**Step 5.5: Similar Patterns**
All 3 other sync_ptr paths (native, compat32, buggy-compat) already use
`pcm_lib_apply_appl_ptr()`. The x32 path was the only outlier.
Record: 3 out of 4 sync_ptr paths already correct; this fixes the 4th.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable Trees**
- `9027c4639ef1` (introduced pcm_lib_apply_appl_ptr) is in v5.10, v5.15,
  v6.1, v6.6, and all newer trees
- `513ace79b657e2` (x32 handler) is in all stable trees since v4.6
- Therefore the bug exists in ALL active stable trees
Record: Bug present in v5.10, v5.15, v6.1, v6.6, v6.12, v6.14.

**Step 6.2: Backport Complications**
- v6.12+: `scoped_guard` present, but `snd_pcm_sync_ptr_get_user` macro
  absent → minor context conflict
- v6.6 and older: neither `scoped_guard` nor the get_user macro present
  → needs adaptation of surrounding context, but core fix is identical
Record: Minor context adaptation needed. Core semantic change is
version-independent.

**Step 6.3: Related Fixes in Stable**
The compat32 fix (`2e2832562c877`) is already in stable trees. The x32
fix is not.
Record: Compat32 variant already in stable. X32 variant missing.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem Criticality**
- ALSA PCM core — IMPORTANT. Audio is widely used; PCM is the
  fundamental audio interface.
- X32 ABI narrows the affected users but is still a supported kernel
  feature.
Record: IMPORTANT subsystem, platform-specific (x86_64 with X32 ABI).

**Step 7.2: Activity**
The sound/core/pcm_compat.c file has moderate activity with refactoring
and bug fixes.
Record: Active, maintained subsystem.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who Is Affected**
X32 ABI users on x86-64 who use PCM audio with drivers that implement
the ack() callback. While X32 is niche, the bug causes real misbehavior.
Record: Platform-specific (X86_X32_ABI), affects audio applications
using mmap/sync_ptr.

**Step 8.2: Trigger Conditions**
Any x32 application calling `SNDRV_PCM_IOCTL_SYNC_PTR` with
`!SNDRV_PCM_SYNC_PTR_APPL` (i.e., updating appl_ptr). This is a normal
PCM operation.
Record: Normal PCM operation on x32 applications. Common trigger.

**Step 8.3: Failure Mode Severity**
- Missing ack() → audio driver doesn't know about pointer update →
  potentially incorrect DMA behavior, audio glitches, or silent audio
  failure. MEDIUM-HIGH.
- Missing boundary validation → appl_ptr could be set to invalid value →
  potential for incorrect pointer arithmetic. MEDIUM.
Record: Severity MEDIUM-HIGH — audio misbehavior/corruption for x32
users.

**Step 8.4: Risk-Benefit**
- Benefit: Makes x32 path correct and consistent. Prevents real audio
  issues for x32 users. Precedent: compat32 fix was Cc: stable.
- Risk: Very low. 4 net lines changed. Replaces direct assignment with a
  well-tested function used by all other code paths. Same pattern as 3
  existing call sites.
Record: HIGH benefit (correctness fix with stable precedent), VERY LOW
risk.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Compilation**

FOR backporting:
- Fixes a real consistency bug: x32 path skips validation and ack()
  callback
- Identical bug in compat32 was fixed with explicit `Cc:
  stable@vger.kernel.org` (commit `2e2832562c877`)
- Small, surgical fix: ~7 lines in one function
- Obviously correct: makes x32 match 3 other sync_ptr paths
- Accepted by ALSA maintainer (Takashi Iwai)
- Bug has existed since 2017 (when ack was introduced) — all stable
  trees affected
- Removes a FIXME comment that explicitly flagged the issue

AGAINST backporting:
- X32 ABI is niche (smaller user base)
- Needs minor context adaptation for older stable trees
- No explicit user report of the bug being triggered

**Step 9.2: Stable Rules Checklist**
1. Obviously correct? **YES** — identical pattern to 3 existing call
   sites
2. Fixes a real bug? **YES** — missing validation + missing driver
   callback
3. Important issue? **YES** — audio misbehavior, potential data
   corruption
4. Small and contained? **YES** — 7 lines in one function
5. No new features? **YES** — correctness fix only
6. Can apply to stable? **YES** with minor context adaptation

**Step 9.3: Exception Categories**
Not applicable — this is a standard correctness bug fix.

**Step 9.4: Decision**
The evidence strongly supports backporting. The identical bug class was
previously backported for compat32 with explicit stable nomination. The
fix is small, obviously correct, and makes the x32 path consistent with
all other sync_ptr paths.

## Verification

- [Phase 1] Parsed tags: Link with v1-1 confirms standalone patch. SOB
  from Takashi Iwai confirms maintainer acceptance.
- [Phase 2] Diff analysis: Replaces `control->appl_ptr =
  scontrol.appl_ptr` with `pcm_lib_apply_appl_ptr(substream,
  scontrol.appl_ptr)` + error check. Net +4/-3 lines.
- [Phase 3] git blame: Buggy code introduced in 513ace79b657e2 (2016).
  pcm_lib_apply_appl_ptr introduced in 9027c4639ef1 (2017).
- [Phase 3] git show 2e2832562c877: Confirmed identical compat32 fix
  with Fixes: 9027c4639ef1 and Cc: stable@vger.kernel.org.
- [Phase 3] git merge-base: 9027c4639ef1 is in v5.10, v5.15, v6.6.
  513ace79b657e2 is in v6.6. Bug exists in all active stable trees.
- [Phase 4] b4 dig -c 2e2832562c877: Found compat32 fix thread
  confirming stable intent.
- [Phase 4] Could not fetch lore for this patch (anti-bot protection).
  UNVERIFIED: specific reviewer comments.
- [Phase 5] Grep: snd_pcm_ioctl_sync_ptr_x32() called from
  snd_pcm_ioctl_compat() at line 594, reachable via compat ioctl
  syscall.
- [Phase 5] Confirmed 3 other sync_ptr paths already use
  pcm_lib_apply_appl_ptr: pcm_native.c:3140, pcm_native.c:3242,
  pcm_compat.c:504.
- [Phase 6] scoped_guard in v6.12+. sync_ptr_get_user not in any stable.
  Minor adaptation needed for backport.
- [Phase 6] Read pcm_lib_apply_appl_ptr (pcm_lib.c:2227-2268): validates
  boundary, checks NO_REWINDS, calls ack(), rolls back on failure.
- [Phase 8] Failure mode: missing ack() → audio driver not notified of
  pointer update → MEDIUM-HIGH severity.

**YES**

 sound/core/pcm_compat.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/core/pcm_compat.c b/sound/core/pcm_compat.c
index e71f393d3b018..5313f50f17da5 100644
--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -430,11 +430,13 @@ static int snd_pcm_ioctl_sync_ptr_x32(struct snd_pcm_substream *substream,
 	if (!boundary)
 		boundary = 0x7fffffff;
 	scoped_guard(pcm_stream_lock_irq, substream) {
-		/* FIXME: we should consider the boundary for the sync from app */
-		if (!(sflags & SNDRV_PCM_SYNC_PTR_APPL))
-			control->appl_ptr = scontrol.appl_ptr;
-		else
+		if (!(sflags & SNDRV_PCM_SYNC_PTR_APPL)) {
+			err = pcm_lib_apply_appl_ptr(substream, scontrol.appl_ptr);
+			if (err < 0)
+				return err;
+		} else {
 			scontrol.appl_ptr = control->appl_ptr % boundary;
+		}
 		if (!(sflags & SNDRV_PCM_SYNC_PTR_AVAIL_MIN))
 			control->avail_min = scontrol.avail_min;
 		else
-- 
2.53.0

