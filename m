Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B8F60404E;
	Mon, 19 Oct 2026 14:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418593; cv=none; b=mUTzIv6ndMwGHWzZoV90z7lwl2IP7OJ3E7tUWa5IpWOAZzz0GOiH/4tK3drQput/WZs0fRsZNJJkqBzvoHWSFFqjwfFW8/avXYleyWxvrye/rnJONU6v4bmSa7nmnMkr9K8qwiAamTY+xjJ6PSppLxJw4mt5Y4T2wpRN8aRymko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418593; c=relaxed/simple;
	bh=7RRkTTBUoUaZD5ACbr4rifyzrB80AkCSWWYmajZR/qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fyW3N2ch7Z0+JlpvLf74FhOl1wEt6JyevnrDBfuO8/FqMQ9L67F2daoHkW5Pz5tRmIaihfioFIC6gItsXK3kUAY9b91hmN2/BhA0o35t7LR+Zb+6LkhrNhV/Z/5j971CjBBlnzl0XfuBgIb3HWJ4cgoQtA8dFYVw2y1FmAchGlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EPJeAcpJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EPJeAcpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19C31F000C7;
	Mon, 19 Oct 2026 14:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418590;
	bh=veXsoZLcTeYeaBs5kTWoyEnKoyG321VaA3pDN71aTdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPJeAcpJt/OL8+bAYTxUCJjDGEbCludHpLsdcW/ia640C1+4mgrxb8Y3khZrnA80J
	 5zWtCcv89WTD7Ys8VEt7/FGI/NLAdKNQAvgX5a7W+b9nIjNx6Ry0gFJB6hV/VDH0Po
	 gIyZ9Vj+Kc+Cf5lH9QW+9eVMdPop1Kbw4CwoLPoNr7u+iAEtXcDXE2a7pAUlO6Qm6I
	 ETTVGGHodsusXW5sZAq95KUkunE7GhctSQIFfX16rZ9+yV67ap/EipZLMgNHrg5xcx
	 3TaV29f56yiU9be4RkF4uGkkMbfZlbpj6yHEc5x1NnEnwZWS3ye4i3mBvZsXKvIUT+
	 ZKuumjjt81oqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Denis V. Lunev" <den@openvz.org>,
	David Hildenbrand <david@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] virtio_balloon: warn on failed buffer add in tell_host()
Date: Mon, 19 Oct 2026 09:50:47 -0400
Message-ID: <20261019135441.1420968-356-sashal@kernel.org>
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

From: "Denis V. Lunev" <den@openvz.org>

[ Upstream commit 198eda395067b56ee605de076f0519620f4e5d90 ]

tell_host() ignores the return value of virtqueue_add_outbuf() and goes
on to kick the queue and wait_event() for the host's ack. The comment
claims "We should always be able to add one buffer to an empty queue",
but that does not hold once the virtqueue has been broken (e.g. on
device shutdown): the add then fails with -EIO and the following
wait_event() would block forever on a buffer the host can never return.

Warn and bail out on failure, mirroring virtballoon_free_page_report().

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260624140846.2616797-5-den@openvz.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **6.12.111** (`pending-6.12`, `git describe`
`p-6.12-3-gc504cf0baa3d8`). The verdict is only for this checkout.

The candidate is `198eda395067b` (`virtio_balloon: warn on failed buffer
add in tell_host()`). It is **not** an ancestor of `HEAD`. The buggy
`tell_host()` is present and the patch applies cleanly.

---

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: **[virtio_balloon] [warn] Check `virtqueue_add_outbuf()` in
`tell_host()` and return instead of waiting forever**

**Step 1.2 — Tags**
Record:
- Suggested-by: David Hildenbrand `<david@kernel.org>`
- Signed-off-by: Denis V. Lunev `<den@openvz.org>` (author)
- Signed-off-by: Michael S. Tsirkin `<mst@redhat.com>` (virtio
  maintainer)
- Message-ID: `<20260624140846.2616797-5-den@openvz.org>` (v2 4/4)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Cc: stable, or
  Link: on the committed message (absence is expected)

**Step 1.3 — Body**
Record:
- **Bug:** `tell_host()` ignores `virtqueue_add_outbuf()`. The comment
  assumes an empty queue can always take one buffer.
- **Symptom:** After a broken virtqueue (`-EIO` on device shutdown /
  already-broken vq), `wait_event(vb->acked, virtqueue_get_buf(...))`
  waits forever because the host will never return a buffer that was
  never queued.
- **Root cause:** Broken-queue add failure is not treated as fatal; kick
  + wait still run.
- **Fix:** `WARN_ON_ONCE(err)` and return, same as
  `virtballoon_free_page_report()`.
- **Version note:** Message cites “device shutdown”. That specific
  trigger is `8bd2fa086a04` (2025-02-24), which is **not** in this 6.12
  tree. Other broken-queue triggers **are** in this tree (below).

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. It is an explicit hang fix. It also finishes the
2014 change that removed `BUG()` on add failure but left the wait.

---

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- File: `drivers/virtio/virtio_balloon.c` only (~+4 / −2)
- Function: `tell_host()`
- Scope: single-function surgical check

**Step 2.2 — Flow**
Record:
- **Before:** `virtqueue_add_outbuf()`; ignore result;
  `virtqueue_kick()`; `wait_event` until `virtqueue_get_buf()` is non-
  NULL.
- **After:** same, but if add returns non-zero, warn once and return (no
  kick, no wait).
- Path: inflate/deflate notify to host (normal and remove/leak paths).

**Step 2.3 — Mechanism**
Record:
- **Category:** logic / correctness — ignored error leading to infinite
  wait
- **Broken:** add on `vq->broken` returns `-EIO` (`virtqueue_add` in
  `virtio_ring.c`). `virtqueue_get_buf_*` returns NULL on broken.
  `wait_event` never completes.
- **Fix:** abort when add fails.

**Step 2.4 — Quality**
Record:
- Obviously correct; same pattern already in
  `virtballoon_free_page_report()` in this file.
- Regression risk is low. Early return from `fill_balloon()` can leave
  pages ballooned without a host ack if add failed for a reason other
  than a dead device; on a broken vq that is the intended abort.
  `leak_balloon()` still runs `release_pages_balloon()` after
  `tell_host()`, so surprise-remove still returns pages.
- `WARN_ON_ONCE` + `panic_on_warn` could panic instead of hang. That is
  the existing reporting-path policy. In **this** tree, shutdown does
  not break virtio devices, so this does not add reboot-time WARNs.

---

## Phase 3: Git history investigation

**Step 3.1 — Blame**
Record:
- `tell_host()`: `6b35e40767c6c1` (2008, original balloon driver)
- Ignored add return: `4951cc90831470` (2014, Rusty Russell, “don't
  crash if virtqueue is broken”) — replaced `if (add < 0) BUG()` with an
  unchecked add. That avoided a crash and left a hang.
- Reporting-path WARN: `b0c504f1547189` (2020)

**Step 3.2 — Fixes: tag**
Record: None. Natural parent is `4951cc90831470` (present in this tree).

**Step 3.3 — File history**
Record: Recent balloon work here is stats/wakeup/indirect-desc, not
`tell_host()`. No competing fix for this hang. Not already applied.

**Step 3.4 — Author**
Record: Denis V. Lunev is a long-time balloon contributor
(`997e120843e82`, etc.). Applied by MST. Suggested by David Hildenbrand.

**Step 3.5 — Dependencies**
Record: Standalone. v2 series is 4/4:
1. `virtio_device_shutdown()` helper — needs `virtio_dev_shutdown()`
   from `8bd2fa086a04` (not here)
2. `virtballoon_quiesce()` factor-out
3. `.shutdown` quiesce (Fixes: `8bd2fa086a04`)
4. **This patch** — no new helpers, applies to current `tell_host()`

This commit does not need 1–3.

---

## Phase 4: Mailing list and external research

**Step 4.1 — Original thread**
Record:
- Lore: https://patch.msgid.link/20260624140846.2616797-5-den@openvz.org
- Cover: `[PATCH v2 0/4] virtio_balloon: quiesce balloon work on device
  shutdown`
- Cover URL: https://lore-
  kernel.gnuweeb.org/lkml/20260624140846.2616797-1-den@openvz.org/
- v1 (2026-06-22) was 2 patches (quiesce only). v2 added this tell_host
  check (Hildenbrand) and kept it separate (Tsirkin).
- Field report in the cover: kexec/cluster upgrade + `panic_on_warn` on
  the **reporting** WARN after `8bd2fa086a04`. That trigger is **not**
  in 6.12. Cover also states inflate/deflate `wait_event` would block
  forever on a broken queue.

**Step 4.2 — Recipients (b4 dig -w)**
Record: `mst@redhat.com`, `david@kernel.org`,
`virtualization@lists.linux.dev`, `linux-kernel@vger.kernel.org`. Right
maintainers.

**Step 4.3 — Review**
Record: David Hildenbrand asked about `stats_handle_request()` (no
`wait_event`; sibling `d62fb5cc8a432`, not required). No NAK. No
reviewer `Cc: stable`.

**Step 4.4 — Series**
Record: This hunk is independent. 1–3 fix post-6.12 shutdown-break. They
cannot and need not go in with this one.

**Step 4.5 — Stable list**
Record: gnuweeb search for `virtio_balloon tell_host stable` found old
balloon stable backports, not this patch. lore.kernel.org/stable
returned 403.

---

## Phase 5: Code semantic analysis

**Step 5.1 — Functions**
Record: `tell_host()` only.

**Step 5.2 — Callers (this tree)**
Record:
- `fill_balloon()` → `update_balloon_size_func()` work; inflate
- `leak_balloon()` → size work, `virtio_balloon_oom_notify()`,
  **`remove_common()`**
- `virtballoon_migratepage()` (compaction)
- `remove_common()` ← `virtballoon_remove()`, `virtballoon_freeze()`

**Step 5.3 — Callees**
Record: `sg_init_one`, `virtqueue_add_outbuf` → `-EIO` if `vq->broken`,
`virtqueue_kick`, `wait_event` + `virtqueue_get_buf` (NULL if broken).

**Step 5.4 — Reachability**
Record: Userspace/hypervisor: balloon size change, OOM deflate,
compaction, unplug/freeze. Host/PCI/CCW can mark the device broken
**before** `remove_common()`:

```754:759:drivers/virtio/virtio_pci_common.c
  - Device is marked broken on surprise removal so that virtio upper
  - layers can abort any ongoing operation.
         */
        if (!pci_device_is_present(pci_dev))
                virtio_break_device(&vp_dev->vdev);
```

Same idea on s390: `virtio_ccw_remove` / `virtio_ccw_offline` call
`virtio_break_device()` when `device_lost` before
`unregister_virtio_device()`.

Then `remove_common()` → `leak_balloon()` → `tell_host()` on a broken
deflate vq → infinite wait without this patch.

**Step 5.5 — Similar patterns**
Record: `virtballoon_free_page_report()` already WARNs and returns.
`stats_handle_request()` still ignores add (no hang). 2014 commit
removed `BUG()` in both `tell_host` and stats.

---

## Phase 6: Cross-referencing this tree

**Step 6.1 — Buggy code here?**
Record: Yes. `tell_host()` at `drivers/virtio/virtio_balloon.c:184-198`
still ignores add and waits. Bug since 2008/2014. `8bd2fa086a04` is
**not** an ancestor of `HEAD` (`git merge-base --is-ancestor` = no).
`virtio_dev_shutdown` / `virtballoon_quiesce` are absent. Surprise-break
(`43bb40c5b92659`, 2021) **is** here.

**Step 6.2 — Backport difficulty**
Record: Clean apply. `tell_host()` matches the hunk.
`finish_wakeup_event` is already adjacent context.

**Step 6.3 — Related fixes already here?**
Record: No tell_host add-check. Reporting path already has the WARN. No
duplicate.

---

## Phase 7: Subsystem and maintainer context

**Step 7.1**
Record: **virtio balloon** (`drivers/virtio/`). **IMPORTANT** for VMs
(KVM/QEMU, s390 ccw), not core mm/vfs.

**Step 7.2**
Record: Mature driver; balloon core is old. Recent 6.12 backports are
stats/wakeup/indirect-desc, not a rewrite of `tell_host()`.

---

## Phase 8: Impact and risk

**Step 8.1 — Who**
Record: Guests with `CONFIG_VIRTIO_BALLOON` (very common). Triggered
when the vq is already broken, then inflate/deflate/`remove_common`
runs.

**Step 8.2 — Trigger**
Record:
- **In this 6.12 tree:** surprise PCI remove (`!pci_device_is_present`)
  or ccw `device_lost` → break → `leak_balloon`/`tell_host` hang. Also
  any prior `virtio_break_device()` / `vq->broken` before the next
  `tell_host()`.
- **Not in this tree:** `device_shutdown()` break/reset (`8bd2fa086a04`)
  — the series’ kexec/`panic_on_warn` story.
- Not a normal unprivileged syscall. Host/device loss or hot-unplug.

**Step 8.3 — Failure mode**
Record: Uninterruptible `wait_event` in balloon work or `remove_common`.
Device unbind / `unregister_virtio_device` / `cancel_work_sync` can
stick. **Severity: HIGH** (hang), not a UAF/corruption.

This patch does **not** unstick a wait that already started after a
successful add (notify then fail / break while waiting). It stops the
**next** `tell_host()` after the vq is already broken — the remove/leak
path after surprise-break.

**Step 8.4 — Risk vs benefit**
Record:
- Benefit: high for the hang path; medium overall (surprise-loss is less
  common than the post-6.13 shutdown path, but the hang is real and the
  driver is supposed to abort).
- Risk: very low (4 lines, established pattern).
- Ratio: favor backport.

---

## Phase 9: Final synthesis

**Step 9.1 — Evidence**

For:
- Real infinite `wait_event` if add fails (verified: add `-EIO`, get_buf
  NULL on broken).
- `remove_common()` always leaks remaining pages via `tell_host()` after
  surprise-break in this tree.
- Completes 2014 “don’t BUG” change that left a hang.
- Tiny, obviously correct, same as existing reporting helper.
- Applies cleanly; no series 1–3 needed.
- Maintainer-applied; suggested by balloon reviewer.

Against:
- Main series story (`8bd2fa086a04` kexec/`panic_on_warn`) is not in
  6.12.
- No Fixes:/Cc: stable (not a negative per rules).
- Surprise-remove is less common than graceful unplug.
- `WARN_ON_ONCE` + `panic_on_warn` trades hang for panic if add fails;
  same as reporting path; shutdown in 6.12 does not break vqs, so no new
  reboot WARNs.

Unresolved: lore.kernel.org/stable HTTP 403. gnuweeb search did not show
a prior rejection of this patch.

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — 4-line check; reviewed; MST
   applied; series tested for the later shutdown bug.
2. Real user-visible bug? **PASS** — hang on broken vq / surprise
   remove.
3. Important (hang/deadlock)? **PASS** — unbounded wait in
   remove/inflate/deflate.
4. Small and contained? **PASS**
5. No new features/APIs? **PASS**
6. Applies to this tree? **PASS**

**Step 9.3 — Exception category**
Record: None (not an ID/quirk/DT/build/doc exception). Qualifies as a
hang fix.

**Step 9.4 — Decision**
The missing `8bd2fa086a04` path does not make this a no-op here. The
unchecked add + `wait_event` is in this tree, and surprise PCI/CCW
break-then-remove is the designed “upper layer must abort” path.
Backporting this patch alone does not require the quiesce series and
does not introduce shutdown WARNs on 6.12.

---

## What it solves for 6.12 users

On a broken balloon virtqueue, `tell_host()` currently kicks and waits
for an ack that cannot arrive. After surprise PCI/CCW removal this tree
already marks the device broken, then `remove_common()` →
`leak_balloon()` → `tell_host()`, so unbind/remove can hang. The patch
warns and returns, matching the reporting helper.

It meets stable rules: real hang, small, no new API, clean apply, no
missing prerequisites in this tree.

Risk is low versus an unbounded wait.

---

## Verification

- **[Phase 1]** Parsed message/tags from the supplied commit and `git
  log -1` of `198eda395067b` on `all-next`.
- **[Phase 1]** Cover letter: kexec/`panic_on_warn` after
  `8bd2fa086a04`; also documents inflate/deflate `wait_event` hang.
- **[Phase 2]** Diff: 4 lines in `tell_host()` only; local file matches.
- **[Phase 2]** `virtqueue_add` returns `-EIO` if `vq->broken`
  (`virtio_ring.c:565-568`). `virtqueue_get_buf_*` returns NULL if
  broken (`834-836`, `1684-1686`).
- **[Phase 3]** Blame: `tell_host` `6b35e40767c6c1` (2008); unchecked
  add `4951cc90831470` (2014, removed `BUG()`).
- **[Phase 3]** `git show 4951cc90831470`: confirmed BUG → ignore.
- **[Phase 3]** `git merge-base --is-ancestor 8bd2fa086a04 HEAD` →
  **NO**. `198eda395067b` → **NO**.
- **[Phase 3]** `virtio_device_shutdown` / `virtballoon_quiesce` not in
  this tree.
- **[Phase 4]** `b4 dig -c 198eda395067b`: msgid
  `20260624140846.2616797-5-den@openvz.org`.
- **[Phase 4]** `b4 dig -a`: v1 quiesce-only; v2 added this patch.
- **[Phase 4]** `b4 dig -w`: MST + Hildenbrand + virtualization list.
- **[Phase 4]** Hildenbrand reply: asked about stats path; no NAK.
- **[Phase 4]** lore.kernel.org/stable: 403. gnuweeb: no discussion of
  this patch for stable.
- **[Phase 5]** Callers: `fill_balloon`, `leak_balloon`, migratepage;
  `remove_common` from remove/freeze.
- **[Phase 5]** `virtio_pci_remove` surprise-break: `43bb40c5b92659`
  (2021), present. `virtio_ccw` break on `device_lost`, present.
- **[Phase 6]** `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → 6.12.111.
- **[Phase 6]** Local `tell_host()` still unchecked; patch context
  present; not already patched.
- **[Phase 8]** Failure mode: infinite `wait_event` / stuck remove.
  Severity HIGH.
- **UNVERIFIED:** Whether any 6.12.y discussion already rejected this
  (stable list fetch failed). Not used to decide.

The hang is real in this tree, the fix is small and self-contained, and
it should be backported.

**YES**

 drivers/virtio/virtio_balloon.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index a3995e77a652c..0386e7b459bb1 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -185,16 +185,18 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 {
 	struct scatterlist sg;
 	unsigned int len;
+	int err;
 
 	sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
 
 	/* We should always be able to add one buffer to an empty queue. */
-	virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL);
+	err = virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL);
+	if (WARN_ON_ONCE(err))
+		return;
 	virtqueue_kick(vq);
 
 	/* When host has read buffer, this completes via balloon_ack */
 	wait_event(vb->acked, virtqueue_get_buf(vq, &len));
-
 }
 
 static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_info,
-- 
2.53.0

