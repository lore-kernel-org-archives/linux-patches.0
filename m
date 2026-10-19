Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64DE5960B2;
	Mon, 19 Oct 2026 13:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418344; cv=none; b=gCHr7kDAA+cIWwsdsYPgA3isXxk+Z6jrqRnwNSyfpZmXc756UwJhEy0S6V8pqUMiEsprJ97W1gLvPESHFHQoSg+AcCo86xbVsN93e20suVYo0T49z32/HtxCQm92KW6seYYopyEg++p+AS0NaQ9P9b3JFW4RAmozgKibIM80b8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418344; c=relaxed/simple;
	bh=Em+p1aCLuTydphUsb895XKAldfpdFX15ZxcAfUunYFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t7jcULnu2OYoKijfFOf6ZxocWiV/DS5tNHU/aK9CuWDU51c9V3mi8WXvB1OybKralex7R58xzTmxqXphgCW5DuRfGTNFfjPbXPsZPAhA5OEZuHT4quBDOYp1ziCec2E542hzuxLXmgctFC7iLEUucLPY+3tzqw1JZSN8vlyMVGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LOln+WWR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LOln+WWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1AE1F000C4;
	Mon, 19 Oct 2026 13:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418342;
	bh=sumvp7u+FhaLjUIiSX0AB5EXKDXdwxL7Gk14bIE++bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOln+WWRaMfbvHmBkqe5kUc1zQz28ZiFDQofkNoPBCMrVQCmA5jXTxcYv1J4nTeHb
	 yEv6MjPSgfmTKDGOYXjSe0H+q2+21l9uJKpjvbwxblRpSC+OLyii0QneY92F+sVNCv
	 bgkCIooFK1AkOO4IHmvGG8nvbcLRGDlyBD+TK0CBF4xiCtO/mNBhrmwto6E9MQXR4n
	 Hb9kuML5VhRAkXkOw8i1xbnC4NYbUeIoPV295DCmsZtKTYickiRmFqnBKDmt6VpRPF
	 nMmDrYl9jTNO1PQrL5OxtDrjBAVvbOnb+5D5Ikr5ddkN21fuGVOn9eQROwmoG0HRR1
	 CwyZlHW4UxqOg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Anuj Bolewar <bolewara@gmail.com>,
	syzbot+06f9b2a53ba4a5a47644@syzkaller.appspotmail.com,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>,
	airlied@redhat.com,
	kraxel@redhat.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] drm/virtio: reclaim pending vbufs before tearing down vqs
Date: Mon, 19 Oct 2026 09:47:50 -0400
Message-ID: <20261019135441.1420968-179-sashal@kernel.org>
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

From: Anuj Bolewar <bolewara@gmail.com>

[ Upstream commit 61d85f99b5a55d4f717c4bb2f4c4acabf22ee3fc ]

virtio_gpu_free_vbufs() destroys the vbufs kmem_cache after the virtqueues
have already been released. Commands that were queued but never completed
by the device leave their vbuffers stranded in the virtqueue, so the cache
still holds live objects when virtio_gpu_deinit() tears everything down.
This triggers a WARNING in virtio_gpu_free_vbufs:

    BUG virtio-gpu-vbufs (Not tainted): Objects remaining in cache
    on __kmem_cache_shutdown()

Drain any buffers still sitting in the control and cursor virtqueues in
virtio_gpu_deinit() after the device has been reset and before the
virtqueues are deleted, following the same pattern used by virtio_console's
remove_vqs(). Each reclaimed buffer is released with free_vbuf(), dropping
the reference on any GEM objects it holds. Pending RESOURCE_UNREF
commands are handled as well: their resp_cb_data still references a GEM
object, so it is cleaned up with virtio_gpu_cleanup_object() to avoid
leaking it on teardown.

Reported-by: syzbot+06f9b2a53ba4a5a47644@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=06f9b2a53ba4a5a47644
Signed-off-by: Anuj Bolewar <bolewara@gmail.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/20260802-virtio-gpu-reclaim-vbufs-v2-1-5767fb860691@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable backport analysis: `drm/virtio: reclaim pending vbufs before
tearing down vqs`

Local tree: **6.12.111** (`p-6.12-3-gc504cf0baa3d8`). Verdict is for
this checkout only.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[drm/virtio] [reclaim] [drain leftover virtqueue buffers before
destroying vbufs cache]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Reported-by: syzbot+06f9b2a53ba4a5a47644@syzkaller.appspotmail.com` —
  fuzzer-found, reproducible
- `Closes: https://syzkaller.appspot.com/bug?extid=06f9b2a53ba4a5a47644`
- `Signed-off-by: Anuj Bolewar <bolewara@gmail.com>` (author)
- `Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>`
  (virtio-gpu maintainer)
- `Link: https://patch.msgid.link/20260802-virtio-gpu-reclaim-
  vbufs-v2-1-5767fb860691@gmail.com`
- No `Fixes:` tag (expected for this review pipeline)
- Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`
  if present

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `virtio_gpu_free_vbufs()` calls `kmem_cache_destroy()` after
  VQs are already deleted. In-flight commands stay attached to the
  virtqueue, so the `virtio-gpu-vbufs` cache still has live objects.
- **Symptom:** SLUB `BUG virtio-gpu-vbufs: Objects remaining on
  __kmem_cache_shutdown()` plus `WARNING` in `virtio_gpu_free_vbufs` /
  `kmem_cache_destroy`, on device removal.
- **Root cause:** `virtio_gpu_deinit()` does `virtio_reset_device()`
  then `del_vqs()` without draining unused buffers.
- **Fix:** After reset, before `del_vqs()`, detach leftover buffers
  (same idea as `virtio_console` `remove_vqs()`), `free_vbuf()` them,
  drop GEM arrays, and `virtio_gpu_cleanup_object()` pending
  `RESOURCE_UNREF` GEM objects.
- **Version info:** none in the message; code has been this way for
  years.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not hidden. Explicit leak/WARNING fix on teardown. v2 also
closes a GEM leak for stranded `RESOURCE_UNREF` commands.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- `drivers/gpu/drm/virtio/virtgpu_drv.h`: +1 declaration
- `drivers/gpu/drm/virtio/virtgpu_kms.c`: +1 call in
  `virtio_gpu_deinit()`
- `drivers/gpu/drm/virtio/virtgpu_vq.c`: +15, new
  `virtio_gpu_reclaim_vbufs()`
- **Total: +17 / −0.** Single-subsystem surgical fix.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `virtio_gpu_deinit()` flushes work, resets the device,
  deletes VQs. Later `virtio_gpu_release()` → `virtio_gpu_free_vbufs()`
  → `kmem_cache_destroy(vgdev->vbufs)` with any still-queued `vbuffer`s
  live.
- **After:** Same sequence, plus `virtio_gpu_reclaim_vbufs()` between
  reset and `del_vqs()`. Control queue: detach unused bufs, put GEM
  arrays, cleanup `resp_cb_data`, `free_vbuf()`. Cursor queue: detach
  and `free_vbuf()`.
- Path: device removal / unbind / probe-fail after successful
  `virtio_gpu_init()`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** resource leak + teardown WARNING (stranded slab objects;
  GEM refs left held).
- **Mechanism:** `virtqueue_detach_unused_buf()` after reset, then
  existing `free_vbuf()` / `virtio_gpu_array_put_free()` /
  `virtio_gpu_cleanup_object()`.
- In this tree `resp_cb_data` is only set in
  `virtio_gpu_cmd_unref_resource()` to a `struct virtio_gpu_object *`,
  so the extra cleanup is specific and correct here.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: documented virtio shutdown helper; same pattern as
  `virtio_console`.
- Minimal; no API/feature additions.
- Regression risk is low. After `drm_dev_unplug()`, `drm_dev_enter()`
  fails, so `array_put_free()` → last GEM put →
  `virtio_gpu_cmd_unref_resource()` takes the existing `-ENODEV` path
  (`free_vbuf` + `virtio_gpu_cleanup_object`) instead of re-queuing.
  Both VQs are always created in `virtio_gpu_init()`
  (`vqs[0]`/`vqs[1]`), so no NULL `cursorq.vq` on the deinit path.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- `virtio_gpu_free_vbufs()` / `kmem_cache_destroy`: `f5985bf9cadd4e`
  (Gerd Hoffmann, 2017-03-01, “drm: virtio: use kmem_cache”) — ancestor
  of this HEAD.
- `virtio_gpu_deinit()` body: `dc5698e80cf724` (Dave Airlie, 2013) plus
  later `virtio_reset_device()` (`d9679d0013a668`, 2021).
- Bug is old; present throughout 6.12.y.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Not applicable. Buggy teardown is in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent virtio GPU work here is unrelated (EDID bounds, deadlock,
fence, KMS removal). No reclaim helper already present. `cec7f1774605a`
is a different probe double-free. Standalone patch, not “X/Y” of a
larger series (cover said “Patch 1” of a 1-patch series).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Anuj Bolewar has no virtio GPU commits in this tree. Dmitry
Osipenko is the virtio-gpu maintainer (SOB + “Applied to drm-misc-
fixes”).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Uses `virtqueue_detach_unused_buf`, `free_vbuf`,
`virtio_gpu_array_put_free`, `virtio_gpu_cleanup_object` — all present.
No panic-path helpers required. Can apply standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c <sha>` cannot match: commit is not in this tree (candidate
  only).
- Lore search via lore.kernel.org returned 403.
- Recovered from Openwall/LKML:
  - v1: drain only (`objs` + `free_vbuf`)
  - v2: also `virtio_gpu_cleanup_object(resp_cb_data)`
  - Applied version is v2
- Dmitry Osipenko, 2026-08-14: **“Applied to drm-misc-fixes, thanks!”**
  — no NAK.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: Recipients included Airlie, Hoffmann, Osipenko, Gurchetan Singh,
Chia-I Wu, dri-devel, virtualization, syzkaller-bugs. Maintainer applied
it. No NAK found.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record (syzkaller, extid `06f9b2a53ba4a5a47644`):
- Title: `WARNING in virtio_gpu_free_vbufs`
- Labels: `prio:high`
- Assessment: DenialOfService exploitable; VM guest and host trigger;
  not unprivileged
- Stack: `kmem_cache_destroy` → `virtio_gpu_free_vbufs` →
  `virtio_gpu_release` → `drm_dev_put` → `virtio_dev_remove` → PCI
  `remove_store`
- 13 crashes; first ~2026-07-29
- Syzbot lists upstream fix `61d85f99b5a5` (that SHA is not in this
  tree; `git merge-base --is-ancestor` was not used on an unknown remote
  SHA)

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: 1-patch series. v2 is the applied leak-complete version.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search 403. **UNVERIFIED** whether
stable@ already discussed it. Not used as a NO reason.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `virtio_gpu_reclaim_vbufs` (new), `virtio_gpu_deinit` (call
site), `free_vbuf`, `virtio_gpu_array_put_free`,
`virtio_gpu_cleanup_object`.

**Step 5.2: TRACE CALLERS**

Record:
- `virtio_gpu_deinit()` from `virtio_gpu_probe` error path after
  `virtio_gpu_init()` (`err_deinit`) and from `virtio_gpu_remove()`
  after `drm_dev_unplug()`.
- Teardown/unbind, not a hot path.

**Step 5.3: TRACE CALLEES**

Record: `virtqueue_detach_unused_buf` (documented for shutdown/reset),
GEM put, object cleanup, `kmem_cache_free`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Userspace/sysfs PCI remove (privileged) or guest virtio-gpu
unplug. Syzbot hit it from `remove_store`. Reachable on any system that
unbinds/unplugs virtio-gpu with commands still in the VQ (unresponsive
device, hot-unplug, fuzz).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same drain exists in `virtio_console.c` `remove_vqs()`,
`virtio_net`, `virtio_crypto`, vsock, etc. virtio-gpu was missing it.

semcode: not available; used `git grep` / file reads.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.**

```283:293:drivers/gpu/drm/virtio/virtgpu_kms.c
void virtio_gpu_deinit(struct drm_device *dev)
{
        ...
        virtio_reset_device(vgdev->vdev);
        vgdev->vdev->config->del_vqs(vgdev->vdev);
}
```

```83:87:drivers/gpu/drm/virtio/virtgpu_vq.c
void virtio_gpu_free_vbufs(struct virtio_gpu_device *vgdev)
{
        kmem_cache_destroy(vgdev->vbufs);
        vgdev->vbufs = NULL;
}
```

`virtio_gpu_reclaim_vbufs` is **not** in this tree. `git log
--grep='reclaim pending vbufs'` on those files: empty.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply expected.** Actual v2 context matches 6.12 (no
panic helpers required). Line numbers differ slightly; 3-line context
around reset/`del_vqs` and `free_vbuf`/`reclaim_vbufs` is the same.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No equivalent drain. KMS-disabled removal fix `38a5f891cda6d` is
unrelated (atomic shutdown).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: `drivers/gpu/drm/virtio` — **IMPORTANT** for VMs/QEMU guests
(common virtio-gpu), not core mm/VFS. Not staging.

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: Mature driver (2013+), still receiving 6.12 stable fixes. Bug is
long-standing, not a brand-new subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: virtio-gpu users (`CONFIG_DRM_VIRTIO_GPU`) — QEMU/KVM/cloud VMs,
driver unbind, PCI remove, module unload.

**Step 8.2: TRIGGER CONDITIONS**

Record: Device teardown with commands still on the control/cursor VQ.
Syzbot: PCI `remove`. Privileged on the host; a VM guest can trigger it.
Not every boot, but a realistic hot-unplug/reset path.

**Step 8.3: FAILURE MODE SEVERITY**

Record:
- `kmem_cache_destroy()` **always** `WARN`s if objects remain
  (`mm/slab_common.c` ~547), not only `CONFIG_SLUB_DEBUG`.
- With SLUB_DEBUG, additional `slab_bug` / `__slab_err`.
- If shutdown fails, the cache is **not** released (`if (err) return`) →
  cache leak plus leaked vbufs/GEM.
- Syzbot: DoS, `prio:high`.
- Severity: **HIGH** (kernel WARNING/taint, resource leak on remove;
  panic if `panic_on_warn`).

**Step 8.4: RISK-BENEFIT RATIO**

Record: **Benefit high** (stops WARNING + leak on a common VM GPU
driver). **Risk low** (17 lines, existing helpers, maintainer-acked).
Ratio favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

**FOR:**
- Real, syzbot-reproduced teardown bug
- Unconditional `WARN` + slab/GEM leak
- virtio-gpu is widely used in VMs on 6.12 LTS
- Small, obviously correct drain matching other virtio drivers
- All callees exist here; bug exists here
- Maintainer applied v2 to drm-misc-fixes

**AGAINST:**
- Trigger is device removal, not a hot path
- Needs privilege / VM unplug (not a local unprivileged syscall crash)
- No `Fixes:` / stable Cc in the original (not a negative under these
  rules)

**UNRESOLVED:**
- lore.kernel.org 403; stable@ discussion not fetched
- `b4 dig` could not resolve a SHA that is not in this tree

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — v2, syzbot, maintainer
   applied
2. Real user-visible bug? **PASS** — WARNING + leak on virtio-gpu remove
3. Important (crash/leak/DoS)? **PASS** — HIGH; syzbot prio:high / DoS
4. Small and contained? **PASS** — +17 lines, 3 files, one driver
5. No new features/APIs? **PASS** — internal helper only
6. Applies to local tree? **PASS** — buggy code present; helpers present

**Step 9.3: EXCEPTION CATEGORIES**

Record: Not ID/quirk/DT/docs. Ordinary important bugfix.

**Step 9.4: DECISION**

This tree has the bug and the dependencies. The fix is small, matches
established virtio teardown, and stops a syzbot-confirmed WARNING plus
object leak on virtio-gpu teardown. It should be backported to this 6.12
tree.

---

## What the commit solves for stable users

On virtio-gpu unbind/unplug, in-flight command buffers stay in the
virtqueues. Destroying the `virtio-gpu-vbufs` cache then WARNs and leaks
those buffers and any GEM objects they hold (including pending
`RESOURCE_UNREF`). 6.12 guests using virtio-gpu hit this on device
removal.

## Risk vs benefit

Benefit: no WARN/taint and no leaked GEM/vbufs on a common VM driver.
Risk: low; one drain after reset, before `del_vqs()`, using APIs already
in 6.12.

## Concerns

None that block backport. Header context in some expanded diffs mentions
later panic helpers; the real v2 hunk does not need them. Apply as the
17-line v2.

---

## Verification

- **[Phase 1]** Tags: syzbot Reported-by, Closes syzkaller URL, Osipenko
  SOB
- **[Phase 2]** Diff: +17 across 3 virtio GPU files; drain after reset
- **[Phase 2]** `resp_cb_data` only assigned in
  `virtio_gpu_cmd_unref_resource()` in this tree
- **[Phase 3]** `git describe HEAD` / Makefile: 6.12.111;
  `p-6.12-3-gc504cf0baa3d8`
- **[Phase 3]** blame: `kmem_cache_destroy` in `virtio_gpu_free_vbufs`
  since `f5985bf9cadd4e` (2017); deinit without drain since original
  driver
- **[Phase 3]** `git log --grep='reclaim pending vbufs' --
  drivers/gpu/drm/virtio/`: not present
- **[Phase 4]** Openwall v2 + LKML: Osipenko “Applied to drm-misc-fixes”
- **[Phase 4]** syzbot: WARNING in `virtio_gpu_free_vbufs`, prio:high,
  PCI remove stack, 13 crashes
- **[Phase 4]** lore.kernel.org 403; `b4 dig` no local commit —
  UNVERIFIED beyond Openwall/LKML/syzbot
- **[Phase 5]** Callers: `virtio_gpu_drv.c` probe fail +
  `virtio_gpu_remove`
- **[Phase 5]** Both VQs assigned in `virtio_gpu_init()` lines 217–218
- **[Phase 6]** Local `virtio_gpu_deinit` / `virtio_gpu_free_vbufs`
  match the buggy sequence
- **[Phase 6]** `virtqueue_detach_unused_buf`,
  `virtio_gpu_array_put_free`, `virtio_gpu_cleanup_object` exist
- **[Phase 8]** `kmem_cache_destroy` WARNs if `__kmem_cache_shutdown`
  returns nonzero (`mm/slab_common.c`); cache not released on error
- **UNVERIFIED:** whether this SHA is already in some other stable
  series (irrelevant; not in this tree)

**YES**

 drivers/gpu/drm/virtio/virtgpu_drv.h |  1 +
 drivers/gpu/drm/virtio/virtgpu_kms.c |  1 +
 drivers/gpu/drm/virtio/virtgpu_vq.c  | 15 +++++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.h b/drivers/gpu/drm/virtio/virtgpu_drv.h
index 51b78f8a8aa2e..d52f35a09a1b0 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.h
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.h
@@ -355,6 +355,7 @@ void virtio_gpu_array_put_free_work(struct work_struct *work);
 /* virtgpu_vq.c */
 int virtio_gpu_alloc_vbufs(struct virtio_gpu_device *vgdev);
 void virtio_gpu_free_vbufs(struct virtio_gpu_device *vgdev);
+void virtio_gpu_reclaim_vbufs(struct virtio_gpu_device *vgdev);
 void virtio_gpu_cmd_create_resource(struct virtio_gpu_device *vgdev,
 				    struct virtio_gpu_object *bo,
 				    struct virtio_gpu_object_params *params,
diff --git a/drivers/gpu/drm/virtio/virtgpu_kms.c b/drivers/gpu/drm/virtio/virtgpu_kms.c
index 4a25347734fda..01ea5cd5ea7f1 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -289,6 +289,7 @@ void virtio_gpu_deinit(struct drm_device *dev)
 	flush_work(&vgdev->cursorq.dequeue_work);
 	flush_work(&vgdev->config_changed_work);
 	virtio_reset_device(vgdev->vdev);
+	virtio_gpu_reclaim_vbufs(vgdev);
 	vgdev->vdev->config->del_vqs(vgdev->vdev);
 }
 
diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 244a791ab915e..f7e7d212fc67c 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -207,6 +207,21 @@ static void free_vbuf(struct virtio_gpu_device *vgdev,
 	kmem_cache_free(vgdev->vbufs, vbuf);
 }
 
+void virtio_gpu_reclaim_vbufs(struct virtio_gpu_device *vgdev)
+{
+	struct virtio_gpu_vbuffer *vbuf;
+
+	while ((vbuf = virtqueue_detach_unused_buf(vgdev->ctrlq.vq))) {
+		if (vbuf->objs)
+			virtio_gpu_array_put_free(vbuf->objs);
+		if (vbuf->resp_cb_data)
+			virtio_gpu_cleanup_object(vbuf->resp_cb_data);
+		free_vbuf(vgdev, vbuf);
+	}
+	while ((vbuf = virtqueue_detach_unused_buf(vgdev->cursorq.vq)))
+		free_vbuf(vgdev, vbuf);
+}
+
 static void reclaim_vbufs(struct virtqueue *vq, struct list_head *reclaim_list)
 {
 	struct virtio_gpu_vbuffer *vbuf;
-- 
2.53.0

