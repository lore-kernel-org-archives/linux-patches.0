Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DFC477280;
	Mon, 31 Aug 2026 13:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183341; cv=none; b=ke/PQuJLWPSJq41JHWH7n6tsCOa0eth4PY4Wc5i5Q55L0G3xtufSJCrpYh2DUXNBdrI1Yu0hokQ+0Y/zf0ojTMQTTc55PVJisZRxMc3+VWaMW/qJUIwlqFBcA44Jn/S6wPP49411wVqNM6+71YNVQMrt+mjTj8/VvpLWPvXpoZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183341; c=relaxed/simple;
	bh=zCwVNMWm9AJarhUGZuV8079zSkn5F2Ic6om4TiPHmW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fUjv8kgBj8xivrv5bC2akJp5RZ6/qBeEE6RgcW4SD/fnPc6QZmnYs5K288M26u8zyurWH5K1JhSXGPy3Wck83wGZcDHjjJlSUAlplHWKkUD9Her+G20dnNuYr9gclv9VMBypoPjc1vqZUM05MbuuJcEOFES6m2yaX61vY+rVxnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JpWI9G5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JpWI9G5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1499D1F00A3F;
	Mon, 31 Aug 2026 13:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183339;
	bh=kKb26iVImiPGyTnZ71DQ0DY1f9MALfzVnRrVOZzO4mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JpWI9G5quEyUvQ6URcmYRXV3Hkax89IhAXL2g70duB7A5J6c7Njkrnjm/dfzl4nDb
	 jDoWcj8tOoVOPjweHX1I0exa2yxfEI9GdMh3I+y2WNVc4//EZr4G6KHQ1wjFXwSF3e
	 BYwAR/Xsnhbv7ppj+kPKpxBCqOP50SDqCO+2JWlqSkl0nmtuPfLEapnTbnEnIRXalP
	 u+xWGaRvNc6YqCnnR+3VvIsvdeuLvX8wyRNwsrJ6T2gU+h+AJnNsjeMeJG2sDKrv8t
	 u6hPE5c10sg9inlGkRFdszMoPI33IUHL0M5+ULDaN/GF1XUO5a32fkTrwMnq1k3aiX
	 XAy1E8UVtdrFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jasowangio@gmail.com,
	michael.christie@oracle.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] vhost-scsi: flush backend after device ioctls
Date: Mon, 31 Aug 2026 09:21:57 -0400
Message-ID: <20260831133314.4125787-89-sashal@kernel.org>
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

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit 22598f55a4c2b510b3df5e69e563387a963222ae ]

vhost-scsi translates guest response descriptors into userspace iovecs
when commands are submitted.  Target-core completes those commands
asynchronously, so VHOST_SET_MEM_TABLE can replace the memory table while
an in-flight command still retains response iovecs translated through the
old table.

If the old mapping is reused after VHOST_SET_MEM_TABLE returns, command
completion can write the response to an unrelated userspace object.

Flush the vhost-scsi backend after vhost_dev_ioctl() handles a device
ioctl.  This waits for in-flight commands that can still use the old
response iovecs before the ioctl returns.

Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260724060919.1569170-1-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 – Subject line**

Record: `[vhost-scsi] [flush] Flush backend after device ioctls to
prevent stale response-iovec writes after memory table changes.`

**Step 1.2 – Tags**

Record:
- **Fixes:** none
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none in commit message
- **Acked-by:** none in commit message
- **Link:** none
- **Cc: stable:** none (expected for pipeline candidates)
- **Signed-off-by:** Jia Jia `<physicalmtea@gmail.com>`, Michael S.
  Tsirkin `<mst@redhat.com>` (ignore pipeline-added SOBs)
- **Message-ID:** `<20260724060919.1569170-1-physicalmtea@gmail.com>`
  (v2 submission)

Notable: Signed-off-by from vhost maintainer (mst) is a strong quality
signal. No syzbot/fuzzer report; this is a logic/lifetime bug.

**Step 1.3 – Body analysis**

Record:
- **Bug:** `vhost_scsi_setup_resp_iovs()` copies guest response
  descriptor addresses (translated userspace HVAs) into per-command
  `tvc_resp_iovs` at submit time. Target-core completes SCSI commands
  asynchronously. `VHOST_SET_MEM_TABLE` can replace the memory table
  while commands still hold iovecs from the old table.
- **Symptom:** After the ioctl returns and old mappings are reused,
  async completion via `copy_to_iter()` can write the virtio-scsi
  response into unrelated userspace memory → **host memory corruption**.
- **Versions:** Not specified; mechanism has existed since the 2012 TODO
  was added.
- **Root cause:** Missing synchronization barrier between device-wide
  ioctls (especially `VHOST_SET_MEM_TABLE`) and in-flight async
  completions using stale response iovecs.

**Step 1.4 – Hidden bug fix?**

Record: **Yes.** Although the subject says "flush" rather than "fix",
this closes a long-standing correctness hole marked by a `/* TODO: flush
backend after dev ioctl. */` comment since 2012. It is not cosmetic
cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 – Inventory**

Record:
- **File:** `drivers/vhost/scsi.c` (+2 / -1 lines net)
- **Function:** `vhost_scsi_ioctl()` default branch
- **Scope:** Single-file, surgical fix

**Step 2.2 – Code flow change**

Record:
- **Before:** After `vhost_dev_ioctl()`, unknown ioctls fall through to
  `vhost_vring_ioctl()` on `-ENOIOCTLCMD`; no flush for handled device
  ioctls (`VHOST_SET_MEM_TABLE`, etc.).
- **After:** On any non-`-ENOIOCTLCMD` result from `vhost_dev_ioctl()`,
  call `vhost_scsi_flush(vs)` before returning. Vring ioctls still
  bypass this flush (they return `-ENOIOCTLCMD` and go to
  `vhost_vring_ioctl()`).
- **Path affected:** Control-plane ioctl path only; data path unchanged.

**Step 2.3 – Bug mechanism**

Record: **Memory safety / lifetime bug (stale pointer use).**
- `vhost_get_vq_desc()` → `translate_desc()` builds `vq->iov[]` using
  current `dev->umem` mappings.
- `vhost_scsi_setup_resp_iovs()` copies those pointers into
  `cmd->tvc_resp_iovs`.
- Completion in `vhost_scsi_complete_cmd_work()` writes via those stored
  iovecs:

```721:723:drivers/vhost/scsi.c
                iov_iter_init(&iov_iter, ITER_DEST, cmd->tvc_resp_iovs,
                              cmd->tvc_resp_iovs_cnt, sizeof(v_rsp));
                ret = copy_to_iter(&v_rsp, sizeof(v_rsp), &iov_iter);
```

- `vhost_set_memory()` replaces `d->umem` and frees the old IOTLB
  without waiting for in-flight completions using old HVAs.

**Step 2.4 – Fix quality**

Record:
- **Obviously correct:** Matches the established pattern in `vhost-net`
  and `vhost-vsock`:

```1827:1835:drivers/vhost/net.c
        default:
                mutex_lock(&n->dev.mutex);
                r = vhost_dev_ioctl(&n->dev, ioctl, argp);
                if (r == -ENOIOCTLCMD)
                        r = vhost_vring_ioctl(&n->dev, ioctl, argp);
                else
                        vhost_net_flush(n);
                mutex_unlock(&n->dev.mutex);
                return r;
```

- **Minimal:** 3-line change; removes TODO, adds `else
  vhost_scsi_flush(vs)`.
- **Regression risk:** Low. Flush only on rare device-wide control
  ioctls; vring hot-path ioctls explicitly excluded.
  `vhost_scsi_flush()` already used in set/clear endpoint paths and
  requires `dev.mutex` (held here).

---

## Phase 3: Git History Investigation

**Step 3.1 – Blame**

Record: TODO introduced in `935cdee7ee1595` (Dec 2012, Michael S.
Tsirkin, "vhost: avoid backend flush on vring ops"). Default ioctl
branch dates to `057cbf49a1f082` (Jul 2012). Buggy gap present ~14
years.

**Step 3.2 – Fixes: tag**

Record: N/A — no Fixes: tag.

**Step 3.3 – Related file history**

Record:
- `vhost_scsi_flush()` introduced/evolved through inflight refcount
  mechanism (commits like `25b98b64e2842`, `31fbea3ab94ea`).
- `vhost_scsi_setup_resp_iovs()` added in `9d8960672d63d` (2024) — makes
  explicit per-command storage of response iovecs, but the race predates
  this.
- Fix is **standalone**; not part of a multi-patch dependency series for
  this specific change.

**Step 3.4 – Author context**

Record: Jia Jia submitted v2 (Jul 2026); Michael S. Tsirkin Signed-off-
by. Author also submitted related vhost-scsi hardening patches in the
same timeframe.

**Step 3.5 – Prerequisites**

Record: **None required.** `vhost_scsi_flush()` exists in this tree.
Patch applies to current `vhost_scsi_ioctl()` structure. No new APIs or
structures.

---

## Phase 4: Mailing List and External Research

**Step 4.1 – Original discussion**

Record:
- Thread found via web search (lore.kernel.org blocked by bot
  protection):
  - https://www.spinics.net/lists/netdev/msg1207854.html
  - https://lists.openwall.net/netdev/2026/07/21/81
  - v2: Message-ID `<20260724060919.1569170-1-physicalmtea@gmail.com>`
- Author explains flush is control-plane only; vring ioctls
  intentionally excluded per 2012 design.
- Mike Christie reviewed (Jul 22); author responded Jul 23 with detailed
  lifetime analysis.
- **b4 dig:** Could not run — commit hash not present in this checkout;
  `b4 dig -c` requires a commitish.

**Step 4.2 – Reviewers**

Record: CC'd netdev, kvm, virtualization; Paolo Bonzini, Stefan
Hajnoczi, Eugenio Pérez, Mike Christie, Jason Wang area. mst Signed-off-
by on committed version.

**Step 4.3 – Bug report**

Record: No external bugzilla/syzbot report. Bug identified through code
analysis of the 2012 TODO and async completion path.

**Step 4.4 – Related patches**

Record: Author has related vhost-scsi patches (feature-change rejection,
T10-PI lifecycle) but this flush fix is independent.

**Step 4.5 – Stable list history**

Record: No stable-list discussion found (lore blocked). Not used as
negative signal.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 – Key functions**

Record: `vhost_scsi_ioctl()`, `vhost_scsi_flush()`, `vhost_dev_ioctl()`,
`vhost_scsi_setup_resp_iovs()`, `vhost_scsi_complete_cmd_work()`,
`vhost_set_memory()`.

**Step 5.2 – Callers**

Record:
- `vhost_scsi_ioctl()` — userspace via `/dev/vhost-scsi` ioctl
  (QEMU/vhost owner process).
- `vhost_scsi_flush()` — already called from
  `vhost_scsi_set_endpoint()`, `vhost_scsi_clear_endpoint()`.
- Trigger ioctl `VHOST_SET_MEM_TABLE` — userspace during guest memory
  layout changes (hotplug, migration prep).

**Step 5.3 – Callees**

Record: `vhost_scsi_flush()` → `vhost_scsi_init_inflight()`,
`kref_put()` on old generation, `vhost_dev_flush()`,
`wait_for_completion()` on old inflight completions.

**Step 5.4 – Reachability**

Record: **Reachable from userspace** with `CONFIG_VHOST_SCSI`. Requires
active vhost-scsi endpoint with in-flight SCSI I/O concurrent with
`VHOST_SET_MEM_TABLE`. Realistic in virtualization workloads.

**Step 5.5 – Similar patterns**

Record: `vhost_net_flush()` and `vhost_vsock_flush()` already follow
identical ioctl pattern. vhost-scsi is the outlier with an unfilled
TODO.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 – Buggy code present?**

Record: **YES.** Local tree is `v6.18.44` / `6.18.44`. Current code
still has the TODO and no flush:

```2431:2438:drivers/vhost/scsi.c
        default:
                mutex_lock(&vs->dev.mutex);
                r = vhost_dev_ioctl(&vs->dev, ioctl, argp);
                /* TODO: flush backend after dev ioctl. */
                if (r == -ENOIOCTLCMD)
                        r = vhost_vring_ioctl(&vs->dev, ioctl, argp);
                mutex_unlock(&vs->dev.mutex);
                return r;
```

Fix not yet applied (`git log --grep='vhost-scsi: flush backend'`
returned empty).

**Step 6.2 – Backport complications**

Record: **Clean apply expected.** Identical structure to vhost-net fix;
no refactoring conflicts in recent `drivers/vhost/scsi.c` history.

**Step 6.3 – Related fixes already present?**

Record: **No.** No alternative fix for this race found in this tree.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 – Subsystem**

Record: **drivers/vhost** (virtio host backends). Criticality:
**IMPORTANT** for virtualization (KVM/QEMU with kernel virtio-scsi
target). Not universal like mm/net core, but data corruption in host
userspace is serious.

**Step 7.2 – Activity**

Record: vhost-scsi actively maintained in 6.18 (logging, resource
handling, bug fixes in recent commits).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 – Who is affected**

Record: Users of `CONFIG_VHOST_SCSI` — QEMU/KVM setups using kernel
vhost-scsi with target-core backend.

**Step 8.2 – Trigger conditions**

Record: `VHOST_SET_MEM_TABLE` (or other `vhost_dev_ioctl()` handlers)
while SCSI commands are in flight. Moderately rare (control-plane) but
normal during memory hotplug/migration. Unprivileged users cannot
directly ioctl vhost-scsi without device access, but VM operators can
trigger it.

**Step 8.3 – Failure mode severity**

Record: **Stale HVA write on async completion → host userspace memory
corruption.** Severity: **CRITICAL** (data corruption, potential
security impact in multi-tenant/host scenarios).

**Step 8.4 – Risk-benefit**

Record:
- **Benefit:** HIGH — prevents real corruption bug present since 2012.
- **Risk:** LOW — 3-line change, mirrors proven net/vsock pattern, flush
  infrastructure already exists and is tested in endpoint paths.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

**Step 9.1 – Evidence summary**

**FOR backport:**
- Real memory-corruption bug with clear mechanism
- Long-standing known gap (TODO since 2012)
- Surgical 3-line fix, obviously correct
- Matches existing vhost-net/vhost-vsock behavior
- vhost maintainer Signed-off-by
- Reviewed on netdev list with technical discussion
- All prerequisites (`vhost_scsi_flush`) present in 6.18.44
- Buggy code confirmed present in this tree

**AGAINST backport:**
- Affects only `CONFIG_VHOST_SCSI` users (narrower than core subsystems)
- No fuzzer/user bug report (theoretical until triggered — but mechanism
  is concrete, not speculative)
- Flush adds latency on rare control ioctls (acceptable; same as vhost-
  net)

**Unresolved:** Could not access lore.kernel.org directly; relied on
spinics/openwall mirrors. Commit hash not in local tree for `b4 dig -c`.

**Step 9.2 – Stable rules checklist**

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — mirrors net/vsock; mst
SOB; list review |
| 2. Fixes real bug affecting users? | **PASS** — stale-iovec corruption
on mem table update |
| 3. Important issue? | **PASS** — data corruption, severity CRITICAL |
| 4. Small and contained? | **PASS** — 3 lines, one function |
| 5. No new features/APIs? | **PASS** — uses existing
`vhost_scsi_flush()` |
| 6. Can apply to local tree? | **PASS** — clean apply to current
`scsi.c` |

**Step 9.3 – Exception categories**

Record: Not a device-ID/quirk/DT/build/docs exception. Qualifies as a
**real bug fix** under stable rules.

**Step 9.4 – Decision rationale**

This commit closes a genuine control-plane synchronization hole in
vhost-scsi that can cause host memory corruption when
`VHOST_SET_MEM_TABLE` races with asynchronously completing SCSI
commands. The bug exists in Linux 6.18.44, the fix is minimal and
follows an established pattern in sibling vhost drivers, and all
infrastructure is already present in this tree.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified corruption bug and
  mst SOB
- [Phase 1] Confirmed no Fixes:/Reported-by:/syzbot tags
- [Phase 2] Read diff: removes TODO, adds `else vhost_scsi_flush(vs)` in
  `vhost_scsi_ioctl()` default branch
- [Phase 2] Traced completion path: `vhost_scsi_setup_resp_iovs()` →
  `copy_to_iter()` at lines 721-723
- [Phase 2] Traced mem table update: `vhost_set_memory()` replaces
  `d->umem`, frees old IOTLB at lines 2021-2032
- [Phase 2] Confirmed `translate_desc()` builds userspace HVAs from
  memory table at lines 2646-2688
- [Phase 3] `git blame -L 2431,2438`: TODO from `935cdee7ee1595` (Dec
  2012)
- [Phase 3] `git show 935cdee7ee1595`: original commit added TODO when
  splitting vring vs dev ioctl flush
- [Phase 3] `git log --grep='vhost-scsi: flush backend'`: empty — fix
  not in tree
- [Phase 3] `git log -S 'vhost_scsi_flush'`: flush infrastructure
  present since inflight mechanism
- [Phase 4] Web search found netdev thread (spinics/openwall); author v2
  Jul 24 2026; Mike Christie review Jul 22
- [Phase 4] lore.kernel.org fetch: **FAILED** (403/bot protection)
- [Phase 4] `b4 dig -c`: **NOT RUN** — commit hash unavailable in
  checkout
- [Phase 5] Confirmed `vhost_scsi_flush()` at lines 1855-1876 uses
  inflight generation + `vhost_dev_flush()` + wait
- [Phase 5] Confirmed inflight refcount on cmd alloc/release (lines 768,
  454)
- [Phase 5] Compared with `vhost_net_flush` pattern at net.c:1827-1835
  and vsock.c:883-891
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] `make -s kernelversion`: 6.18.44
- [Phase 6] Confirmed buggy TODO still present at scsi.c:2434
- [Phase 6] Expected clean backport — no conflicting changes in ioctl
  path
- [Phase 8] Failure mode: host userspace memory corruption; severity
  CRITICAL
- [Phase 8] Affected population: CONFIG_VHOST_SCSI virtualization users

**YES**The background checks finished: `git log --grep='vhost-scsi:
flush backend'` returned nothing, so this fix is **not** in the local
**6.18.44** tree yet. The `/* TODO: flush backend after dev ioctl. */`
comment is still in `drivers/vhost/scsi.c`.

That matches the earlier analysis — this is a real memory-corruption bug
on the `VHOST_SET_MEM_TABLE` path, and the 3-line fix mirrors what
`vhost-net` and `vhost-vsock` already do.

**YES** — it should be backported to this tree.

 drivers/vhost/scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 98e4f68f4e3cb..e369f57ce1679 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2431,9 +2431,10 @@ vhost_scsi_ioctl(struct file *f,
 	default:
 		mutex_lock(&vs->dev.mutex);
 		r = vhost_dev_ioctl(&vs->dev, ioctl, argp);
-		/* TODO: flush backend after dev ioctl. */
 		if (r == -ENOIOCTLCMD)
 			r = vhost_vring_ioctl(&vs->dev, ioctl, argp);
+		else
+			vhost_scsi_flush(vs);
 		mutex_unlock(&vs->dev.mutex);
 		return r;
 	}
-- 
2.53.0

