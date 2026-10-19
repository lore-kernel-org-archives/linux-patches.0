Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA7462042F;
	Mon, 19 Oct 2026 14:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418678; cv=none; b=AedBxPSGUQ7xbC83BuUZFvzm32MeyHEI3e5ExqZutwQ3ADtufWk81+p7DM7cv6VjgkuimlOSoajsnA4ddS7KqrGwvAdwdh2emVJaWPQ6ZXXoVxnPpiooAbtVe83fiTi17tyK5hdQnCMMGWuYTTt4G0uBjkvT4xugQbUBK1+MJ0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418678; c=relaxed/simple;
	bh=01jQsl5s5NGCioH9ktkgP9GYyuhLfYerO70GNx0KSPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r0brwSB/NQayk8GwX1nS65QeBC4sKKTldqiap6jn8etti9h2v6cJC+URia/WjMlkqXVZisI3jdB9KC5icjysTb+d1nofn41HN9Snab/ruRQWJBJCdZWKlpO6SAHTnXYp20G+W1CbhGVwUTTvSnhZkxFa6a2DDWLW70PY58+fVF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LNElqLUk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LNElqLUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394531F000C7;
	Mon, 19 Oct 2026 14:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418675;
	bh=mQFR6VNpPVMG9Bl1oVKSuT55S8cITyDq9+C87dkVlDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LNElqLUkPV5pc6WT/iRnEAzxQq9j2CVrZ4SNBHyMim9L8ZMMCm6HoaQiRUKF8AzES
	 9SuAL0EX0mzbgAZfPjlnA5+6Tk1kGxVpeO5m8YMGsKQ+2ML31wXb/FZQ/WBkKVhvBs
	 PkcT01zrCr1M7iDXeCiEnn7lyiGb3CXbXtpvbYkrHV2uAiFNGKWZv1YcC9M6LiyqkU
	 FRPbRilT1qZMz038PflHtDXEpdS0xfxfNyq5JVVHdHUr3Q014/axKYuR7LbdnOkckK
	 /8FK3x8HwpKaOpUo7vQV/hnAqluyFZRdAQ8c+N7H0O0zjklkIsjhHzKRKhxz6aMOO0
	 oAaUeDFKgy8Aw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ryosuke Yasuoka <ryasuoka@redhat.com>,
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
Subject: [PATCH AUTOSEL 6.18] drm/virtio: abort virtqueue wait on device removal to avoid hung task
Date: Mon, 19 Oct 2026 09:51:48 -0400
Message-ID: <20261019135441.1420968-417-sashal@kernel.org>
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

From: Ryosuke Yasuoka <ryasuoka@redhat.com>

[ Upstream commit a46991b334f663fa0e0e9c051e50587ef977ac8b ]

virtio_gpu_queue_ctrl_sgs() and virtio_gpu_queue_cursor() use
wait_event() without any abort condition when waiting for virtqueue
space. If the host device stops processing commands, these waits block
indefinitely inside a drm_dev_enter/exit() critical section. Since
drm_dev_unplug(), which is called in device removal and system shutdown
call path, blocks on synchronize_srcu() until all critical sections
complete, device removal and system shutdown also hang.

Add a vqs_released flag to virtio_gpu_device and include it in the
wait_event() condition. Set the flag and wake up both queues in a new
virtio_gpu_release_vqs() helper, called before drm_dev_unplug() in both
virtio_gpu_remove() and virtio_gpu_shutdown(). When the flag is set, the
wait returns immediately and the command is aborted, following the same
cleanup path as drm_dev_enter() failure.

Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/20260601-virtio-gpu_wait_event-v3-1-89530517a98a@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: `[drm/virtio] [abort] abort virtqueue wait on device removal to
avoid hung task`

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>` (author)
- `Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>`
  (virtio-gpu maintainer)
- `Link: https://patch.msgid.link/20260601-virtio-
  gpu_wait_event-v3-1-89530517a98a@redhat.com`
- No `Fixes:`, `Reported-by:`, `Cc: stable` on the committed v3 (absence
  is expected here)

v2 originally had two syzbot `Reported-by`/`Closes` tags. v3 changelog:
*“Remove Reported-by and Closes tag from commit msg because they are not
related to this fix.”* Those syzbot hung-task reports are a different
probe-time deadlock, already fixed in this tree by `89890a5fcefad`.

**Step 1.3 — Body**
Record:
- **Bug:** `wait_event()` on ctrl/cursor virtqueue space has no abort.
  If the host stops processing commands, the waiter stays in D-state
  inside `drm_dev_enter()`/`drm_dev_exit()`.
- **Symptom:** `drm_dev_unplug()` (remove and shutdown) blocks forever
  on `synchronize_srcu()`, so device removal and system shutdown hang
  (`INFO: task hung`).
- **Root cause:** uninterruptible wait holds an SRCU critical section
  that unplug must drain.
- **Fix:** `vqs_released` flag + `wake_up_all()` before unplug; abort
  with the same cleanup as `drm_dev_enter()` failure (`-ENODEV` / free
  vbuf).
- **Versions:** none named in the message. The wait + `drm_dev_enter`
  wrapping has been in this driver since 2020.

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. Subject and body describe a hang/deadlock. It is a
real teardown hang, not cleanup-as-style.

---

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- `virtgpu_drv.c`: +15 — new `virtio_gpu_release_vqs()`, called from
  `virtio_gpu_remove()` and `virtio_gpu_shutdown()`
- `virtgpu_drv.h`: +1 — `bool vqs_released` on `struct
  virtio_gpu_device`
- `virtgpu_vq.c`: +21/−2 — abort conditions in
  `virtio_gpu_queue_ctrl_sgs()` and `virtio_gpu_queue_cursor()`
- Scope: ~37 insertions, 2 deletions, three files, one driver. Surgical.

**Step 2.2 — Flow**
Record:
- **Before:** if `vq->num_free` is short, unlock, notify host,
  `wait_event(ack_queue, num_free >= needed)` with no timeout/abort,
  still inside `drm_dev_enter()`.
- **After:** wait also succeeds when `vqs_released`. Then unlock resv if
  needed, `free_vbuf()`, `drm_dev_exit()`, return `-ENODEV` (ctrl) or
  return (cursor). Same path as `drm_dev_enter()` failure.
- **Teardown:** set flag, wake both ack queues, *then*
  `drm_dev_unplug()`.
- Path affected: virtqueue-full wait during remove/shutdown, not the
  happy path.

**Step 2.3 — Bug mechanism**
Record: **Deadlock / hung-task (uninterruptible wait blocking SRCU
unplug).** `wait_event()` is `TASK_UNINTERRUPTIBLE`. `drm_dev_unplug()`
→ `drm_dev_synchronize_unplug()` → `synchronize_srcu(&drm_unplug_srcu)`
cannot finish while that section is held. Flag + `wake_up_all()` is a
standard abort.

**Step 2.4 — Fix quality**
Record: Obviously correct and minimal. Abort cleanup matches existing
`drm_dev_enter()` failure. Fence emit happens *after* the wait, so abort
does not leak an emitted fence. `vgdev` is `drmm_kzalloc()`’d so
`vqs_released` starts false. Flag is set only on remove/shutdown.
Regression risk is low: happy-path wait is unchanged; abort only when
tearing down. Remaining `wait_event(resp_wq)` in prime/vram is a
separate issue (author and maintainer agreed to leave it).

---

## Phase 3: Git history

**Step 3.1 — Blame (v6.18.53)**
Record:
- Ctrl `wait_event`: `6ebe8661ebf27a` (2020, Gerd/Chia-I) — `drm/virtio:
  move locking into virtio_gpu_queue_ctrl_sgs`
- Wrapped in `drm_dev_enter`: `b1df3a2b24a917` (2020) — `drm/virtio: add
  drm_driver.release callback`
- Cursor `wait_event`: `d02d270014f70d` (2018) / original queue from
  `dc5698e80cf724` (2013)
- Bug has been in this driver for years; it is in 6.18.y.

**Step 3.2 — Fixes: tag**
Record: None. Introducing commits above exist in this tree.

**Step 3.3 — File history**
Record: Related in-tree: `89890a5fcefad` (probe deadlock / syzbot hung
task — different bug, already in v6.18.53). `2507789a724d6` implements
`virtio_gpu_shutdown` (in v6.18.53). Later candidate `3cdc509eb471e`
reclaims leftover vbufs on teardown — complementary, not a prerequisite
for this abort.

**Step 3.4 — Author**
Record: Ryosuke Yasuoka is a regular virtio-gpu contributor
(`drm_panic`, the display_info deadlock fix). Signed off by maintainer
Dmitry Osipenko.

**Step 3.5 — Dependencies**
Record: Standalone. Needs `drm_dev_enter` around queueing,
`virtio_gpu_remove`/`virtio_gpu_shutdown` calling `drm_dev_unplug`, and
`ctrlq`/`cursorq` ack waitqueues — all present at v6.18.53. No new APIs.

---

## Phase 4: Mailing list / external

**Step 4.1 — b4 dig**
Record:
- v2: https://patch.msgid.link/20260521-virtio-
  gpu_wait_event-v2-1-5796b3a71d03@redhat.com
- v3 (applied): https://patch.msgid.link/20260601-virtio-
  gpu_wait_event-v3-1-89530517a98a@redhat.com
- v1 used `wait_event_timeout()` (5s). v2/v3 switched to an explicit
  `vqs_released` flag (no arbitrary timeout). Applied version is v3.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: David Airlie, Gerd Hoffmann, Dmitry Osipenko, Gurchetan Singh,
Chia-I Wu, drm-misc maintainers, `dri-devel`,
`virtualization@lists.linux.dev`. Right people.

**Step 4.3 — Review**
Record (from saved v2 mbox):
- Dmitry: “What about other `wait_event`?” Author: those are `resp_wq`,
  not inside `drm_dev_enter`, different bug. Dmitry: leave for later.
- Dmitry could not reproduce on normal systemd shutdown and noted the
  syzbot stacks were not remove/shutdown. Later: *“the patch looks okay,
  but I'm not convinced that it fixes the reported issue.”*
- Author agreed syzbot was a probe deadlock (`clientlist_mutex` vs
  dequeue worker), dropped those tags, and described the real trigger:
  host stops processing → guest waits in D-state inside `drm_dev_enter`
  → unplug’s `synchronize_srcu` never completes. systemd cannot kill
  D-state tasks.
- v3 dropped the unrelated tags; Dmitry still signed off.

**Step 4.4 — Series**
Record: Single-patch series. `resp_wq` abort and interruptible waits
were explicitly deferred.

**Step 4.5 — stable@**
Record: lore.kernel.org/stable returned HTTP 403. UNVERIFIED whether it
was already discussed on stable@.

Syzbot URLs from v2: hung in `virtio_gpu_queue_fenced_ctrl_buffer`
during **probe** (`virtio_gpu_probe` → fbcon), not removal. Those are
the deadlock already closed by `89890a5fcefad` in this tree. They do
**not** prove this particular hang, and they are not used as a YES
signal for this commit.

---

## Phase 5: Semantic / call graph

**Step 5.1 — Functions**
Record: `virtio_gpu_release_vqs` (new), `virtio_gpu_remove`,
`virtio_gpu_shutdown`, `virtio_gpu_queue_ctrl_sgs`,
`virtio_gpu_queue_cursor`.

**Step 5.2 — Callers**
Record:
- `virtio_gpu_queue_ctrl_sgs` ← `virtio_gpu_queue_fenced_ctrl_buffer` ←
  nearly every `virtio_gpu_cmd_*` (ioctls, plane update/flush, GEM,
  etc.). Userspace and KMS both reach it.
- `virtio_gpu_queue_cursor` ← cursor plane updates.
- `virtio_gpu_remove` / `virtio_gpu_shutdown` are virtio `.remove` /
  `.shutdown`.

**Step 5.3 — Callees**
Record: `drm_dev_enter`/`exit`, `wait_event`, `wake_up_all`,
`free_vbuf`, `virtio_gpu_array_unlock_resv`, `virtio_gpu_notify`. No new
helpers outside this driver.

**Step 5.4 — Reachability**
Record: Yes. Any guest GPU submit that fills the virtqueue waits here.
Unplug/shutdown is virtio remove or poweroff. Host-side virtio-gpu/virgl
stall is the trigger.

**Step 5.5 — Similar patterns**
Record: `wait_event(vgdev->resp_wq)` in `virtgpu_prime.c` and
`virtgpu_vram.c` still unbounded; not inside `drm_dev_enter`, so they do
not block unplug. Same author deferred that.

---

## Phase 6: This tree (6.18.y)

**Step 6.1 — Buggy code present?**
Record: **Yes at v6.18.53.**
```
v6.18.53:virtgpu_vq.c:398: wait_event(vgdev->ctrlq.ack_queue,
vq->num_free >= elemcnt);
v6.18.53:virtgpu_vq.c:568: wait_event(vgdev->cursorq.ack_queue,
vq->num_free >= outcnt);
```
`vqs_released` is **not** in v6.18.53. `virtio_gpu_remove`/`shutdown`
call `drm_dev_unplug()` with no prior wake.
`drm_dev_synchronize_unplug()` does `synchronize_srcu`. Bug introduced
~2020; 6.18 branched 2025-11-30.

Local tree: `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`;
Makefile `6.18.53`. Verdict is for **this 6.18.y tree only**.

**Step 6.2 — Backport difficulty**
Record: `git apply --check` of this patch onto v6.18.53 virtio files:
**clean apply**. Context differs slightly (`DRIVER_ATOMIC` guard around
`drm_atomic_helper_shutdown` from `19a6a00ff50c2`, already in v6.18.53);
insertion is still immediately before `drm_dev_unplug()`.

**Step 6.3 — Related fix already here?**
Record: Probe deadlock `89890a5fcefad` is in v6.18.53 and does **not**
abort virtqueue waits on removal. No equivalent abort exists. This is
not a duplicate.

---

## Phase 7: Subsystem

**Step 7.1**
Record: `drivers/gpu/drm/virtio` — virtio-gpu DRM. **IMPORTANT** for VMs
(QEMU/KVM, cloud, CrosVM), not core mm/VFS.

**Step 7.2**
Record: Mature driver, still getting targeted fixes. Not staging.

---

## Phase 8: Impact and risk

**Step 8.1 — Who**
Record: virtio-gpu guests (`CONFIG_DRM_VIRTIO_GPU`). Common in VMs, not
every bare-metal box.

**Step 8.2 — Trigger**
Record: Host stops completing virtqueue commands (host renderer crash,
hung device, hypervisor bug) **and** a guest command waits for ring
space **and** then remove/shutdown. Not every boot. Cannot be signal-
killed (`TASK_UNINTERRUPTIBLE`). Module unload, virtio reset, and
poweroff all hit `drm_dev_unplug()`.

**Step 8.3 — Failure mode**
Record: **Hung task / shutdown or unplug deadlock.** Severity: **HIGH**
(system cannot finish shutdown/remove; D-state). Not a UAF or silent
corruption.

**Step 8.4 — Risk vs benefit**
Record:
- Benefit: HIGH for virtio-gpu VMs that lose the host GPU and then
  reboot/unplug.
- Risk: LOW — ~35 lines, teardown-only flag, abort path copies existing
  `-ENODEV` cleanup.
- Ratio: favorable.

---

## Phase 9: Synthesis

**Step 9.1 — Evidence**

**For:**
- Real hang: uninterruptible wait inside `drm_dev_enter` blocks
  `drm_dev_unplug()`/`synchronize_srcu`.
- Confirmed in v6.18.53 source (`wait_event` without abort; unplug with
  no wake).
- Small, contained, no new API.
- Abort cleanup matches existing `drm_dev_enter()` failure.
- Maintainer signed off after review (v1 timeout → v3 flag).
- Applies cleanly to this tree’s virtio files.
- virtio-gpu is widely used; host GPU process failure is a realistic VM
  event.

**Against:**
- Trigger needs a stuck host plus a full virtqueue plus teardown — not a
  hot path.
- Syzbot tags were wrongly attached in v2 and correctly dropped; do not
  treat this as a syzbot backport.
- Incomplete vs all `wait_event`s; `resp_wq` still unbounded
  (intentionally separate).
- Maintainer initially could not reproduce on a normal systemd shutdown.

**Unresolved:** stable@ archive 403; whether this hang has a public user
report besides the author’s analysis.

**Step 9.2 — Stable rules**
1. Obviously correct and tested — **PASS** (standard wait/wake abort;
   maintainer SOB; v3 after review).
2. Real user-visible bug — **PASS** (remove/shutdown hang when host
   stops the vq).
3. Important (hang/deadlock) — **PASS** (HIGH: D-state blocks
   unplug/shutdown).
4. Small and contained — **PASS** (~37 lines, one driver).
5. No new features/APIs — **PASS**.
6. Applies to this tree — **PASS** (clean apply to v6.18.53 virtio
   files; all helpers present).

**Step 9.3 — Exceptions**
Record: None (not a device ID/quirk/DT/build/doc exception). Qualifies
as a normal hang fix.

**Step 9.4 — Decision**
This belongs on 6.18.y. The bug is in this tree, the fix is surgical,
and a stuck virtqueue otherwise makes guest unplug/shutdown hang
forever.

---

## What the commit solves for this tree

On 6.18.y, virtio-gpu waits for virtqueue space with `wait_event()`
inside `drm_dev_enter()`. If the host stops processing, that wait never
ends, `drm_dev_unplug()` never gets past `synchronize_srcu()`, and
remove/shutdown hang in D-state. The patch sets `vqs_released`, wakes
both queues before unplug, and aborts the command like a failed
`drm_dev_enter()`.

That is a real hang, not a feature. Risk is low; the only extra behavior
is on teardown.

---

## Verification
- **[Phase 1]** Parsed v3 message/tags; no Fixes/Reported-by on
  committed v3; v3 changelog documents dropping unrelated syzbot tags.
- **[Phase 2]** Diff: +37/−2 across three virtio-gpu files; abort copies
  `drm_dev_enter()` failure cleanup; fence emit is after the wait.
- **[Phase 3]** `git blame` on v6.18.53: wait from `6ebe8661ebf27a`
  (2020) / cursor from 2013–2018; `drm_dev_enter` from `b1df3a2b24a917`
  (2020).
- **[Phase 3]** `git merge-base --is-ancestor 0ffdc5889ef64 v6.18.53` →
  **not** in v6.18.53; buggy wait **is** in v6.18.53.
- **[Phase 3]** Probe deadlock `89890a5fcefad` **is** in v6.18.53 and
  closes the syzbot hung-task IDs; it does not abort vq waits on
  removal.
- **[Phase 3]** `virtio_gpu_shutdown` (`2507789a724d6`) **is** in
  v6.18.53.
- **[Phase 3]** `vgdev` allocated with `drmm_kzalloc` in `virtgpu_kms.c`
  — `vqs_released` starts false.
- **[Phase 4]** `b4 dig -c a46991b334f663fa0e0e9c051e50587ef977ac8b`
  matched v2/v3 lore; `b4 dig -a` showed v2 then v3; `b4 dig -w` listed
  virtio-gpu maintainers.
- **[Phase 4]** Mbox: Dmitry review; author explained syzbot mismatch
  and the real remove/shutdown hang; v3 dropped tags; Dmitry SOB on the
  commit.
- **[Phase 4]** WebFetch syzbot bugs `d6dd6f86…` / `908bd910…`: hung
  during **probe/fbcon**, not unplug — not this bug.
- **[Phase 4]** lore.kernel.org and lore.kernel.org/stable: HTTP 403.
  UNVERIFIED for stable@ discussion. Used gitlab.freedesktop.org +
  openwall + mbox instead.
- **[Phase 5]** `git grep`: `virtio_gpu_queue_ctrl_sgs` is on
  ioctl/plane/GEM paths; dequeue `wake_up(&ctrlq.ack_queue)` only after
  host responses — if host is dead, waiters never wake without this
  patch.
- **[Phase 6]** `git describe HEAD` / Makefile: **6.18.53**. `git apply
  --check` of this patch onto archived v6.18.53 virtio files: **APPLY
  CLEAN**.
- **[Phase 6]** `drm_dev_unplug` at v6.18.53 calls
  `drm_dev_synchronize_unplug()` → `synchronize_srcu`.
- **[Phase 6]** `wait_event()` in `include/linux/wait.h` uses
  `TASK_UNINTERRUPTIBLE`.
- **[Phase 8]** Failure mode from code + commit: hung unplug/shutdown,
  severity HIGH.
- **UNVERIFIED:** public non-syzbot user report of this exact remove
  hang; stable@ archive (403).

The hang is in this 6.18.y tree, the patch is small and correct, and it
should be backported.

**YES**

 drivers/gpu/drm/virtio/virtgpu_drv.c | 15 +++++++++++++++
 drivers/gpu/drm/virtio/virtgpu_drv.h |  1 +
 drivers/gpu/drm/virtio/virtgpu_vq.c  | 23 +++++++++++++++++++++--
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.c b/drivers/gpu/drm/virtio/virtgpu_drv.c
index d9556e1b67b10..78cc388b434d9 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.c
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.c
@@ -118,10 +118,24 @@ static int virtio_gpu_probe(struct virtio_device *vdev)
 	return ret;
 }
 
+/*
+ * Release pending virtqueue waits so the drm_dev_enter/exit() critical
+ * sections complete before drm_dev_unplug() blocks on synchronize_srcu().
+ */
+static void virtio_gpu_release_vqs(struct drm_device *dev)
+{
+	struct virtio_gpu_device *vgdev = dev->dev_private;
+
+	vgdev->vqs_released = true;
+	wake_up_all(&vgdev->ctrlq.ack_queue);
+	wake_up_all(&vgdev->cursorq.ack_queue);
+}
+
 static void virtio_gpu_remove(struct virtio_device *vdev)
 {
 	struct drm_device *dev = vdev->priv;
 
+	virtio_gpu_release_vqs(dev);
 	drm_dev_unplug(dev);
 
 	if (drm_core_check_feature(dev, DRIVER_ATOMIC))
@@ -135,6 +149,7 @@ static void virtio_gpu_shutdown(struct virtio_device *vdev)
 {
 	struct drm_device *dev = vdev->priv;
 
+	virtio_gpu_release_vqs(dev);
 	/* stop talking to the device */
 	drm_dev_unplug(dev);
 }
diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.h b/drivers/gpu/drm/virtio/virtgpu_drv.h
index 8575c7787fc36..51b78f8a8aa2e 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.h
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.h
@@ -260,6 +260,7 @@ struct virtio_gpu_device {
 
 	struct virtio_gpu_queue ctrlq;
 	struct virtio_gpu_queue cursorq;
+	bool vqs_released;
 	struct kmem_cache *vbufs;
 
 	atomic_t pending_commands;
diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 592ad4f9b100d..244a791ab915e 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -422,7 +422,19 @@ static int virtio_gpu_queue_ctrl_sgs(struct virtio_gpu_device *vgdev,
 	if (vq->num_free < elemcnt) {
 		spin_unlock(&vgdev->ctrlq.qlock);
 		virtio_gpu_notify(vgdev);
-		wait_event(vgdev->ctrlq.ack_queue, vq->num_free >= elemcnt);
+		wait_event(vgdev->ctrlq.ack_queue,
+			   vq->num_free >= elemcnt || vgdev->vqs_released);
+		/*
+		 * Set by virtio_gpu_release_vqs() to unblock
+		 * synchronize_srcu() wait in drm_dev_unplug().
+		 */
+		if (vgdev->vqs_released) {
+			if (fence && vbuf->objs)
+				virtio_gpu_array_unlock_resv(vbuf->objs);
+			free_vbuf(vgdev, vbuf);
+			drm_dev_exit(idx);
+			return -ENODEV;
+		}
 		goto again;
 	}
 
@@ -592,7 +604,14 @@ static void virtio_gpu_queue_cursor(struct virtio_gpu_device *vgdev,
 	ret = virtqueue_add_sgs(vq, sgs, outcnt, 0, vbuf, GFP_ATOMIC);
 	if (ret == -ENOSPC) {
 		spin_unlock(&vgdev->cursorq.qlock);
-		wait_event(vgdev->cursorq.ack_queue, vq->num_free >= outcnt);
+		wait_event(vgdev->cursorq.ack_queue,
+			   vq->num_free >= outcnt || vgdev->vqs_released);
+		/* See comment in virtio_gpu_queue_ctrl_sgs(). */
+		if (vgdev->vqs_released) {
+			free_vbuf(vgdev, vbuf);
+			drm_dev_exit(idx);
+			return;
+		}
 		spin_lock(&vgdev->cursorq.qlock);
 		goto retry;
 	} else {
-- 
2.53.0

