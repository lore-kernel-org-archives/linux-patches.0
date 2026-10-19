Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6C756F591;
	Mon, 19 Oct 2026 13:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418290; cv=none; b=LlzCq65K7MwQkj9lyhsnCWVQo4KL4GA+PrSrvHKq7YEtzoFiZrLN3QwSc/hUjs80KJOvdSIPVAE35r3ujP40df6+/cvUwHCnTqDlV8pB/DxJXkXjP0fwO+HwSxdRQJbYbfGwdW15pyoZ28qFKeqPmrxeGDZW66/GzHOOn3JzUuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418290; c=relaxed/simple;
	bh=iBg+oZBMe0ZVl4r9/ARDaUlsxqYdZf1/rQ9ZuV04FJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o0ffyQkXTnG4NxCUPIuDm34f7C7h60UwbNKOFNUPivde4iMrbeC94a3TLiNyATdCLT5mtQRGhI9rgGyw1+pwDi7CVVbTkl/n5rSrugcjGIAr3v1jG5f0G0g7BCwnZoB+R/Zb0l4bkgS7dAB52DIaktJ2Jh607Kggq6QIfnwJMM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h0GO22ur; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h0GO22ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFE01F000C8;
	Mon, 19 Oct 2026 13:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418287;
	bh=Ff21cRgZ8MvA5CDC/2+VpN0VjGBg1z2VwpeEj2orLlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0GO22urMcdHOGNafsxfp1ycROIVdVoinJlMg17ucDY07dF+RZBGQ/tEmKrTWCQsu
	 EpkXE/mq0PGGDEAfXRdUJgOWmtKKuu2Znbx7PCK/k1NUqvvTpgWukgRGkq/xEqM0e7
	 OihqhirPT3mprGCS2VQSq3vngaUsUiLlj61DkUu9s2hy7LmhU73DNlAZyooDEU1DTk
	 iiCDXLPs6aLVM9yRzl1zmHOV0eT8nWtw5khI8GarroHXbr+01erpADYIRqZZuiDJgE
	 kdCrUxDjIS7dgJ8wq76E0xQGr8Gv/+wUSwiDTPhfuarQ5dveVR2pDDJEU+SaHHYw+n
	 bPNRwHW5be4cw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	thierry.reding@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] gpu: host1x: Wait for timeout worker completion on channel free
Date: Mon, 19 Oct 2026 09:47:11 -0400
Message-ID: <20261019135441.1420968-140-sashal@kernel.org>
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

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 7a39b9856acccc8e9b05845ca2bf62494fcd3dfa ]

cdma_timeout_destroy() used cancel_delayed_work() to cancel pending
timeout work when destroying the CDMA. Usually this is fine, but
there is a narrow race condition where the timeout handler has started
execution but has not taken cdma->lock; the channel is freed causing
cdma_stop to take cdma->lock and flush the channel; host1x_cdma_deinit
then proceeds with deinitializing cdma while the handler is waiting to
take cdma->lock.

Therefore change cdma_timeout_destroy to use cancel_delayed_work_sync
instead to ensure any pending timeout work completes before proceeding.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260609-b4-host1x-small-fixes-a-v1-1-7c1131c0b3ad@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (`7.3.0-rc4`). The host1x CDMA timeout
path is present, and this is a one-line `cancel_delayed_work` →
`cancel_delayed_work_sync` race/UAF fix that is standalone and meets
stable criteria.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[gpu/host1x] [Wait / ensure completion] [Wait for timeout
worker completion on channel free]**
Subsystem prefix `gpu: host1x:`. The verb is “Wait … on channel free”,
i.e. synchronize teardown with a running work item. That is a teardown-
race fix, not a feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected for this review path)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none on the commit itself
- **Acked-by:** none
- **Link:** `https://patch.msgid.link/20260609-b4-host1x-small-fixes-
  a-v1-1-7c1131c0b3ad@nvidia.com`
- **Cc: stable:** none (expected)
- **Signed-off-by:** Mikko Perttunen `<mperttunen@nvidia.com>` (author);
  Thierry Reding `<treding@nvidia.com>` (Tegra/host1x maintainer).
  Ignored any Sasha Levin SOB (none on this commit).
- Series marker in the msgid: **patch 1/6** of `host1x-small-fixes-a`.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `cdma_timeout_destroy()` used `cancel_delayed_work()`, which
  does not wait if the timeout work is already running.
- **Mechanism:** timeout handler has started but has not yet taken
  `cdma->lock`; channel free runs `cdma_stop` (takes the lock, flushes),
  then `host1x_cdma_deinit()` tears CDMA down while the handler is still
  waiting for that lock.
- **Symptom/failure mode:** use-after-free / use of a destroyed mutex
  and CDMA state from the timeout worker. That is a kernel crash /
  memory-safety bug, not a cosmetic issue.
- **Version info:** none in the message. The call has existed since
  host1x channel support.
- **Author’s root cause:** async cancel vs running work vs lock/deinit
  order.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. It is an explicit race/UAF fix. Cover letter (see
Phase 4) calls patches 1–4 “logic issues that are unlikely to happen but
technically possible.” Unlikely trigger does not make a UAF inapplicable
to stable.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/gpu/host1x/hw/cdma_hw.c` — **1 insertion, 1 deletion**
- Function: `cdma_timeout_destroy()`
- Scope: **single-file surgical fix** (one call-site change)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** if `cdma->timeout.initialized`,
  `cancel_delayed_work(&cdma->timeout.wq)` then `initialized = false`.
  Pending work is cancelled; **running** work is not waited for.
- **After:** `cancel_delayed_work_sync()` — cancel pending work **and
  wait** if the handler is executing.
- **Path:** channel teardown / CDMA destroy, not the submit hot path.

Verified teardown order in this tree:

```102:113:drivers/gpu/host1x/channel.c
static void release_channel(struct kref *kref)
{
        ...
        host1x_hw_cdma_stop(host, &channel->cdma);
        host1x_cdma_deinit(&channel->cdma);
        clear_bit(channel->id, chlist->allocated_channels);
}
```

```528:541:drivers/gpu/host1x/cdma.c
int host1x_cdma_deinit(struct host1x_cdma *cdma)
{
        ...
        host1x_pushbuffer_destroy(pb);
        host1x_hw_cdma_timeout_destroy(host1x, cdma);
        return 0;
}
```

`cdma_stop()` takes `cdma->lock`, may wait for an empty sync queue, then
unlocks. `host1x_cdma_deinit()` then runs **without** `cdma->lock`. That
matches the commit’s race: stop can finish and deinit can proceed while
`cdma_timeout_handler()` is between start and `mutex_lock(&cdma->lock)`.

The window is larger than “a few instructions.” The handler dumps debug
state **before** taking the lock:

```291:305:drivers/gpu/host1x/hw/cdma_hw.c
static void cdma_timeout_handler(struct work_struct *work)
{
        ...
        host1x_debug_dump(cdma_to_host1x(cdma));
        mutex_lock(&cdma->lock);
```

`host1x_debug_dump()` walks every channel and dumps FIFOs
(`show_all(..., true)`). A GPU timeout is also when userspace/driver
often closes the channel. That is a realistic overlap, not only a one-
instruction race.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** race + use-after-free / use of destroyed CDMA (mutex,
  push buffer, channel).
- **Mechanism:** non-synchronous delayed-work cancel on destroy. Fix is
  the standard `cancel_*_sync` teardown pattern.
- **Not** a leak, NULL check, or new API.

Related code that correctly stays **non-sync** (would deadlock if
changed, because it runs under `cdma->lock`, which the handler also
takes):

```293:297:drivers/gpu/host1x/cdma.c
static void stop_cdma_timer_locked(struct host1x_cdma *cdma)
{
        cancel_delayed_work(&cdma->timeout.wq);
        cdma->timeout.client = NULL;
}
```

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Quality:** obviously correct for the stated race.
  `cancel_delayed_work_sync()` is the documented way to wait for delayed
  work before freeing the object that work touches.
- **Minimal:** one identifier change.
- **Regression risk:**
  - `_sync` can sleep. Callers of `host1x_channel_put()` →
    `release_channel()` are process-context (DRM ioctls/file close,
    client `exit`/unbind, debugfs). Sleeping is valid there.
  - `_sync` is **not** called while holding `cdma->lock` (`cdma_stop`
    drops it first). No lock-vs-work deadlock on the free path described
    in the commit.
  - Residual risk: if the timeout handler’s `host1x_debug_dump()` →
    `host1x_channel_put()` dropped the **last** channel ref,
    `release_channel()` would run on the same work and `_sync` could
    wait on itself. That path was already unsafe with async cancel (UAF
    after dump returns). No mailing-list NAK of this patch; maintainer
    applied it.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Buggy `cancel_delayed_work()` in `cdma_timeout_destroy()` comes from
  **`6579324a41cc41`** (“gpu: host1x: Add channel support”, Terje
  Bergstrom, 2013-03-22).
- First contained in **`v3.10-rc1`**. This is old, long-lived driver
  code, not a last-month addition.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The introducing commit is identified by blame,
not by the message. `git merge-base --is-ancestor 6579324a41cc41 HEAD`
succeeds — the introducing commit is in this checkout.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record (recent `drivers/gpu/host1x/hw/cdma_hw.c`):
- `7a39b9856accc` — this fix
- `60bca008dd789` — Tegra264 support (does not revert the `_sync`
  change; current file still has `cancel_delayed_work_sync`)
No prerequisite refactor. Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Mikko Perttunen is a regular NVIDIA host1x contributor (UAF,
refcount, iommu, MLOCK, etc.). Same-series follow-ups are independent
(double `device_add`, trace offset, debug stack over-read, `pin_job`
return type, syncpoint wrap annotation). This patch does not depend on
them.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. It only needs `cdma_timeout_destroy()` +
`cancel_delayed_work()` / `_sync`, present since 2013. **Can apply
standalone.**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 7a39b9856accc` matched **v1 only** (no v2/v3).
- Lore: https://patch.msgid.link/20260609-b4-host1x-small-fixes-
  a-v1-1-7c1131c0b3ad@nvidia.com
- Cover letter: https://patch.msgid.link/20260609-b4-host1x-small-fixes-
  a-v1-0-7c1131c0b3ad@nvidia.com — “Miscellaneous fixes”; patches 1–4
  “unlikely to happen but technically possible.”
- Thierry Reding, 2026-07-16: **“Applied to drm-misc-next, thanks.”** No
  NAK, no stable discussion, no request for a different approach.
- `sashiko-bot` replied with **pre-existing** issues (`update_work` not
  cancelled in deinit; non-sync cancel in `stop_cdma_timer_locked()`).
  It did **not** reject this change. Those are separate bugs, not
  regressions of this one-liner.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included Thierry Reding, David Airlie,
Simona Vetter, `dri-devel`, `linux-tegra`, `linux-kernel`. Subsystem
maintainer applied the series. No extra Reviewed-by on the commit.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot, bugzilla, or user crash report. Author-found race
from code inspection. Severity still UAF if it hits.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Series is 6 independent small fixes. This is patch 1/6 and does
not need 2–6.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: WebFetch to `lore.kernel.org/stable/` returned 403.
**UNVERIFIED** whether stable@ already discussed this specific commit.
No `Cc: stable` on the patch.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: KEY FUNCTIONS**
Record: `cdma_timeout_destroy` (changed). Related:
`cdma_timeout_handler`, `cdma_timeout_init`, `host1x_cdma_deinit`,
`release_channel`, `cdma_stop`.

**Step 5.2: TRACE CALLERS**
Record:
- `cdma_timeout_destroy` via `host1x_cdma_ops.timeout_destroy` →
  `host1x_hw_cdma_timeout_destroy()` → **`host1x_cdma_deinit()`** only.
- `host1x_cdma_deinit()` from **`release_channel()`** (last
  `host1x_channel_put()`).
- `host1x_channel_put()` call sites (all process context):
  - `drivers/gpu/drm/tegra/uapi.c` — channel close / ioctl error
  - `drm/tegra` gr2d/gr3d/vic/nvdec — client exit / context close
  - `drivers/crypto/tegra/tegra-se-main.c` — SE driver
  - `drivers/gpu/host1x/debug.c` — debugfs dump

**Step 5.3: TRACE CALLEES**
Record: `cancel_delayed_work_sync()` only. Can sleep; flushes the
delayed work.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace on Tegra DRM can trigger it: submit a job with a
timeout → timeout work queued → close channel (`DRM_TEGRA` channel close
/ process exit) while the handler runs. Unprivileged on devices that
expose tegra DRM. **Reachable from userspace.**

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `stop_cdma_timer_locked()` still uses unsynchronized cancel
**under the lock** (correct). `cdma->update_work` is still not cancelled
in deinit (pre-existing, called out by sashiko-bot; **not** this patch).

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD` = **v7.3-rc4-27-gf0100363d8c37**; `make
  kernelversion` = **7.3.0-rc4**.
- Commit **`7a39b9856acccc8e9b05845ca2bf62494fcd3dfa` is already an
  ancestor of HEAD** (`git merge-base --is-ancestor` succeeded). Current
  `cdma_timeout_destroy()` already calls `cancel_delayed_work_sync()`.
- The **bug** existed here until that commit: same function, same
  `cancel_delayed_work()`, since **v3.10**. This is mainline, so the fix
  is already applied; the question is whether the same change belongs on
  this tree’s stable-style policy given the code is the host1x driver
  this tree ships.
- Introducing commit **is** in this tree. This is not “bug added after
  this tree branched.”

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Surrounding function is still the 2013
structure plus later whitespace. One-line identifier swap; no data-
structure or API change.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This exact fix is already in HEAD (mainline). No alternate fix,
no revert. No other commit on this file addresses the same cancel-vs-
running-work race.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **drivers/gpu/host1x** (NVIDIA Tegra host1x DMA/sync engine).
**IMPORTANT** for Tegra (Android, Jetson, embedded), **PERIPHERAL** for
generic x86. `CONFIG_TEGRA_HOST1X` depends on `ARCH_TEGRA ||
COMPILE_TEST`.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Actively maintained (Tegra264, context devices, multiple 2026
fixes). Author is a core contributor; Thierry Reding applied the series.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: WHO IS AFFECTED**
Record: **Driver-specific / platform-specific** — Tegra SoCs using
host1x (DRM 2D/3D/VIC/NVDEC, Tegra SE crypto). Not universal mm/net.

**Step 8.2: TRIGGER CONDITIONS**
Record:
- Job timeout work is running (or sitting in `host1x_debug_dump` before
  the lock).
- Concurrent last `host1x_channel_put()` (channel close, client unbind,
  process exit).
- Timing-dependent. Author: “narrow” / cover letter “unlikely” — but
  timeout + channel teardown is a real recovery path.
- Unprivileged userspace on Tegra DRM can close a channel; timeout is a
  driver-internal delayed work.

**Step 8.3: FAILURE MODE SEVERITY**
Record: Timeout handler runs against CDMA/channel that
`host1x_cdma_deinit()` already tore down: destroyed mutex, freed push
buffer, stale channel. **UAF / kernel oops.** Severity: **HIGH** (crash;
possible memory-safety issue). Not a log-only bug.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** High for Tegra users — prevents UAF on channel free vs
  timeout. Low for everyone else (config-gated).
- **Risk:** Very low — 1 line, standard API, no lock held, process
  context.
- **Ratio:** Benefit outweighs risk for any tree that still has the
  unsynchronized cancel.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real race: running timeout work vs CDMA/channel destroy.
- Failure mode is UAF / oops, not style.
- One-line, obviously correct `cancel_delayed_work_sync`.
- Bug in code since **v3.10**; no missing helpers.
- Standalone; series mates not required.
- Maintainer (Thierry Reding) applied v1 with no objections.
- Teardown is reachable from userspace channel close on Tegra.
- `debug_dump` before the lock makes the window practical during GPU
  timeout recovery.

**AGAINST:**
- No `Reported-by` / syzbot / production stack trace.
- Author called it unlikely.
- Tegra-only.
- Cover letter grouped it with “miscellaneous” logic issues.
- sashiko-bot noted other incomplete teardown (`update_work`); this
  patch does not fix that (and does not need to).
- This checkout already contains the commit (it is mainline 7.3-rc4).
  That is not a reason the **fix** is wrong for trees that still have
  async cancel.

**UNRESOLVED:**
- Stable@ archive search via WebFetch: 403.
- No empirical reproduction here.
- Self-flush if last kref is dropped from inside `debug_dump`: analyzed
  from code, not discussed on list.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — standard workqueue teardown;
   maintainer applied; in mainline since 2026-07.
2. Fixes a real bug that affects users? **PASS** — UAF on channel free
   vs timeout handler.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   UAF/oops; **HIGH**.
4. Small and contained? **PASS** — 1 line, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — host1x CDMA timeout code is
   here; the change is trivial. (HEAD already has the post-image because
   this is the originating mainline tree.)

**Step 9.3: EXCEPTION CATEGORIES**
Record: None (not a device ID, quirk, DT, build, or docs exception). It
qualifies as a normal small crash-class fix.

**Step 9.4: DECISION**
This tree has host1x and the historical bug. The fix is a textbook
cancel-vs-running-work UAF close, one line, no prerequisites, no new
API. Stable rules are satisfied. Unlikely trigger does not outweigh an
oops/UAF on a path userspace can hit after a GPU timeout.

### What the commit solves
`cdma_timeout_destroy()` cancelled timeout work asynchronously. If
`cdma_timeout_handler()` was already running (especially in
`host1x_debug_dump()` before `cdma->lock`), `release_channel()` could
`cdma_stop` + `host1x_cdma_deinit()` and free CDMA while the handler
still used it. `cancel_delayed_work_sync()` waits for that worker first.

### Stable rules / risk
Meets all six stable criteria. Risk is a possible extra wait on channel
free (correct). Benefit is avoiding a kernel UAF on Tegra host1x.

### Concerns
No user report; Tegra-only; leftover `update_work` teardown is a
separate bug. None of those block this one-liner.

### Verification
- **[Phase 1]** Parsed subject/tags/body from `git log -1` + `git show
  7a39b9856accc`; no Fixes/Reported-by/Cc-stable; Link msgid present.
- **[Phase 2]** Diff is one token in `cdma_timeout_destroy`; read
  handler, `cdma_stop`, `host1x_cdma_deinit`, `release_channel`.
- **[Phase 2]** Confirmed handler calls `host1x_debug_dump()` before
  `mutex_lock`; dump uses `show_all(..., true)`.
- **[Phase 3]** `git blame` on parent: `6579324a41cc41` (2013); `git
  describe --contains` → `v3.10-rc1`.
- **[Phase 3]** `git merge-base --is-ancestor 6579324a41cc41 HEAD` and
  `7a39b9856accc HEAD` both true.
- **[Phase 3]** `git log --oneline` on `drivers/gpu/host1x/` for author
  and series; patch is standalone.
- **[Phase 4]** `b4 dig -c/-a/-w/-m`: v1 only; recipients include
  Thierry; mbox cover letter + “Applied to drm-misc-next”.
- **[Phase 4]** WebFetch lore/stable: 403 — listed UNVERIFIED.
- **[Phase 5]** `git grep host1x_channel_put` — DRM/crypto/debugfs,
  process context.
- **[Phase 6]** `git describe HEAD` / `make kernelversion` → v7.3-rc4;
  current file already has `_sync`.
- **[Phase 7]** `drivers/gpu/host1x/Kconfig` → `CONFIG_TEGRA_HOST1X`.
- **[Phase 8]** Failure mode from code: handler vs deinit = UAF; trigger
  = timeout work + last channel put.

**YES**

 drivers/gpu/host1x/hw/cdma_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/host1x/hw/cdma_hw.c b/drivers/gpu/host1x/hw/cdma_hw.c
index 3f3f0018eee0d..ab714d221120c 100644
--- a/drivers/gpu/host1x/hw/cdma_hw.c
+++ b/drivers/gpu/host1x/hw/cdma_hw.c
@@ -355,7 +355,7 @@ static int cdma_timeout_init(struct host1x_cdma *cdma)
 static void cdma_timeout_destroy(struct host1x_cdma *cdma)
 {
 	if (cdma->timeout.initialized)
-		cancel_delayed_work(&cdma->timeout.wq);
+		cancel_delayed_work_sync(&cdma->timeout.wq);
 
 	cdma->timeout.initialized = false;
 }
-- 
2.53.0

