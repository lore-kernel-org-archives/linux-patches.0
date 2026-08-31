Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D769547B43F;
	Mon, 31 Aug 2026 13:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183359; cv=none; b=deMbjD5G3X6NfuKOuqAE177Cga2VYCwGO2nCYuNmfGM2/IYl5oGYYLM4fSffc80ikpTlhO5vWrzEvYE8KZrGsjoKUPTTeJmwp6yBBwmHKkMMj/oyX2T1S/B88tdP6YbEq6LcYjhLrXypT3f/d5oh0t8EVAOHWrLnhC9VEnCddXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183359; c=relaxed/simple;
	bh=4nHe73gpJLS8AsND0tK6jofhpQT18Y2uw3N3lshEUA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XjMfVFEqcU2PPuVLQsqqDesMUOwCJzw/IRrSvFIEtlikCRgnDIMKvfkKjYJkh2O/VnNqkS8AQs8AScuGh+c4gJWZ6Fmmxb3LpdO2z/qnaTMTE/l4y8+glxL55ofaUuQ+ipDhHmJnx6HSYuQtas/t89MHHMbQ38pT7jYIN7YGqUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dFbThb0B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dFbThb0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E5B1F00A3D;
	Mon, 31 Aug 2026 13:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183357;
	bh=NN7rC/PhgdwP3YFrA5lqFCbYg474YP6A3Jrw20xnmco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dFbThb0BzNbtfwLP4RvGl5sW6ilc7qfsgetg3xEgtTBiGbkPzYdgSWpH/QCzOqcxM
	 bGru6krumtnj6jFwypEksxOsYFSEKfT2SA6A8+OQQ+fgb5w7xGwVP6H6rPUugxhP/5
	 as5DR7vIFLbX5A9FjcC8f1lzZQOcdrk3e2JnHexBkRVE04i5MF6poFokLPRgtGWNUp
	 Ca3YoRtfEXphxTSI7kPDgOW+WweenF8y3iqaajxeqw08fr0Buuw/PC46xmr2HTd/uo
	 lQOxVDdd31m8HV1TjqJHuIciytMde5l+DfPjwJzhemo5z9dIhOF1U0naGVAF0DX2Pt
	 rtuJlyP4VtEHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiang Liu <xiang.liu@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amd/ras: Fix CPER ring debugfs read overflow
Date: Mon, 31 Aug 2026 09:22:08 -0400
Message-ID: <20260831133314.4125787-100-sashal@kernel.org>
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

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit 1e40ef87ffdc291e05ccdade8b9170cc9c1c4249 ]

The legacy CPER debugfs reader can reach the payload path without a
valid pointer snapshot. The remaining user byte count is also treated as
the ring occupancy in dwords, so reads past the header can copy more than
requested.

Take the CPER lock before sampling pointers. Resample rptr/wptr for
payload reads, bound the payload copy by available dwords and the
remaining user size, and advance the file position for each dword copied.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: drm/amd/ras: Fix CPER ring debugfs read
overflow

**Local tree:** Linux 6.18.43 (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`, Makefile `6.18.43`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line**
Record: `[drm/amd/ras]` `[Fix]` — fixes a buffer-overflow / bounds bug
in the legacy CPER ring debugfs reader (`amdgpu_debugfs_ring_read`).

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Xiang Liu <xiang.liu@amd.com>` (author)
- `Reviewed-by: Tao Zhou <tao.zhou1@amd.com>`
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (drm/amdgpu
  maintainer)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable@vger.kernel.org`,
  `Tested-by:`
- Cherry-pick object in repo notes `(cherry picked from commit
  1e40ef87ffdc291e05ccdade8b9170cc9c1c4249)`

**Step 1.3 — Body analysis**
Record:
- **Bug:** Legacy CPER debugfs reader can enter the payload path without
  a valid rptr/wptr snapshot; user byte count (`size`) is overwritten
  with ring occupancy in dwords, so reads past the 12-byte header can
  copy more data than the user requested.
- **Symptom:** User buffer overflow on `read()` of
  `/sys/kernel/debug/dri/*/amdgpu_ring_cper`; also uninitialized pointer
  use and missing lock coverage on payload-only reads (`*pos >= 12`).
- **Root cause (author):** Lock taken only inside `if (*pos < 12)`;
  `early[]` not populated when skipping header; `size` repurposed as
  dword count; wrong wrap size (`ring_size` bytes vs dword indices);
  `*pos` not advanced in CPER payload loop.

**Step 1.4 — Hidden bug fix?**
Record: No — explicitly labeled and described as an overflow fix.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record:
- 1 file: `drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c` (+21 / −8 in the
  cherry-pick object `6bbede02dc62`)
- Function modified: `amdgpu_debugfs_ring_read()`
- Scope: single-file surgical fix (the user-provided diff also shows
  `amdgpu_ras_cper_debugfs_read` changes, but those are **not** in
  commit `6bbede02dc62` nor in this tree)

**Step 2.2 — Code flow changes**

| Hunk | Before | After |
|------|--------|-------|
| Lock scope | `mutex_lock` only inside `if (*pos < 12)` | Lock held for
entire CPER read path |
| Payload entry with `*pos >= 12` | `early[0/1]` never set; unlock
without lock | Resample rptr/wptr under lock |
| Copy bound | `size = ring occupancy` (dwords), ignoring user request |
`read_dw = min(avail_dw, size >> 2)` |
| Wrap calc | `ring->ring_size` (bytes) | `ring->buf_mask + 1` (dwords)
|
| Position | `*pos` not updated in CPER payload loop | `*pos += 4` per
dword |

**Step 2.3 — Bug mechanism**
Record: **Buffer overflow / out-of-bounds user copy** + **uninitialized
stack data** + **mutex imbalance** + **logic error** (wrong units,
missing file position advance).

Verified in current HEAD (`amdgpu_ring.c` lines 511–568):

```511:568:drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
        if (*pos < 12) {
                if (ring->funcs->type == AMDGPU_RING_TYPE_CPER)
                        mutex_lock(&ring->adev->cper.ring_lock);
                // early[0..2] populated here only
                ...
        }
        ...
        } else {
                p = early[0];   // uninitialized if *pos >= 12 at entry
                ...
                        size = (early[1] - early[0]);  // overwrites
user's byte count
                ...
                while (size) {   // may copy far more than user
requested
                        ...
                        size--;
                        // *pos not advanced
                }
        }
out:
        if (ring->funcs->type == AMDGPU_RING_TYPE_CPER)
                mutex_unlock(...);  // unlock even when lock was never
taken
```

**Step 2.4 — Fix quality**
Record: Obviously correct, minimal, no API changes. Low regression risk
— only affects CPER ring debugfs reads. Reviewed by AMD RAS engineer and
merged by amdgpu maintainer.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**
Record: Current buggy function attributed to merge `5d324e5159d9e`
(6.18-rc8 era). Shallow stable history prevents tracing the original
CPER introduction commit; `amdgpu_cper.c` and CPER ring debugfs support
are present in this tree.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag.

**Step 3.3 — Related file history**
Record: `git log --oneline -20 --
drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c` shows only merge commit in
this shallow tree. AUTOSel nomination exists: `[PATCH AUTOSEL 7.0-6.18]
drm/amd/ras: Fix CPER ring debugfs read overflow`.

**Step 3.4 — Author context**
Record: Xiang Liu (AMD). Reviewed by Tao Zhou (AMD RAS). Acked by Alex
Deucher (amdgpu maintainer).

**Step 3.5 — Dependencies**
Record: Standalone. `git cherry-pick --no-commit 6bbede02dc62` auto-
merges cleanly on HEAD (21 insertions, 8 deletions, 1 file only). No
prerequisite commits required.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original discussion**
Record: `b4 dig -c 6bbede02dc62` →
https://patch.msgid.link/20260507140004.244348-1-xiang.liu@amd.com
Single v1 patch, no NAKs found. Tao Zhou replied with `Reviewed-by`.

**Step 4.2 — Reviewers**
Record: `b4 dig -w`: To/Cc included `amd-gfx@lists.freedesktop.org`,
Hawking Zhang, Tao Zhou (AMD).

**Step 4.3 — Bug reports**
Record: No syzbot, bugzilla, or user crash reports. Issue identified by
code review / internal analysis.

**Step 4.4 — Series context**
Record: Standalone 1-patch series. AUTOSel 6.18 nomination confirms
stable relevance for this series.

**Step 4.5 — Stable list**
Record: AUTOSel 7.0-6.18 patch explicitly targets this stable series
(web search confirmed).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**
Record: `amdgpu_debugfs_ring_read()`, called from debugfs
`file_operations.read`.

**Step 5.2 — Callers**
Record: `amdgpu_debugfs_ring_fops.read` → debugfs file
`amdgpu_ring_<name>` created in `amdgpu_debugfs_ring_init()`. CPER ring
named `"cper"` → `/sys/kernel/debug/dri/<card>/amdgpu_ring_cper`.

**Step 5.3 — Callees**
Record: `mutex_lock/unlock`, `amdgpu_ring_get_rptr/wptr`, `put_user`,
ring buffer indexing.

**Step 5.4 — Reachability**
Record: Reachable via `read()` syscall on debugfs (requires
`CONFIG_DEBUG_FS`, debugfs mounted, typically `CAP_SYS_ADMIN`).
Triggered on any CPER ring read where `*pos >= 12` (normal after first
12-byte header) or partial reads.

**Step 5.5 — Similar patterns**
Record: Non-CPER ring path in same function correctly bounds by
`ring->ring_size + 12` and advances `*pos`; CPER path was the outlier.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

**Step 6.1 — Buggy code present?**
Record: **YES** — verified in HEAD at `amdgpu_ring.c:497–576`. CPER
subsystem present (`amdgpu_cper.c`, `amdgpu_cper_init()` in
`amdgpu_device.c:3310`). Fix commit `6bbede02dc62` is **not** an
ancestor of HEAD.

**Step 6.2 — Backport complications**
Record: **Clean apply** — cherry-pick test succeeded with no conflicts.

**Step 6.3 — Related fixes already present?**
Record: **No** — `git diff HEAD 6bbede02dc62 --
drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c` shows only the intended fix
hunks when cherry-picked; HEAD still has buggy code.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 — Subsystem**
Record: `drivers/gpu/drm/amd/amdgpu` — GPU driver, RAS/CPER debug path.
Criticality: **PERIPHERAL** (AMD GPU + debugfs + CPER/RAS enabled).

**Step 7.2 — Activity**
Record: Active development; CPER support is relatively recent (mainline
~6.15+ per external references).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 — Who is affected**
Record: Systems with AMDGPU, `CONFIG_DEBUG_FS`, CPER ring initialized
(ACA or SR-IOV RAS CPER enabled), and a privileged user reading the CPER
ring debugfs file.

**Step 8.2 — Trigger conditions**
Record: Common on second/subsequent `read()` calls (after 12-byte
header). Requires debugfs access (typically root). Not triggerable by
unprivileged users under default permissions (debugfs `0444` but debugfs
mount is root-only on most distros).

**Step 8.3 — Failure mode severity**
Record:
- User buffer overflow via `put_user` beyond requested `size` → **HIGH**
  (memory safety)
- `mutex_unlock` without `mutex_lock` when `*pos >= 12` → **HIGH**
  (lockdep WARN / potential corruption in debug builds)
- Uninitialized `early[]` → **MEDIUM-HIGH** (undefined behavior,
  possible kernel data leak to userspace)
- Overall: **HIGH** for memory safety; practical exploitability reduced
  by privileged-only access

**Step 8.4 — Risk vs benefit**
Record:
- **Benefit:** Prevents user buffer overflow, fixes mutex imbalance,
  corrects CPER debugfs semantics — **moderate** (narrow audience but
  real bugs)
- **Risk:** Very low — 21-line surgical change, reviewed, clean apply
- **Ratio:** Benefit outweighs risk

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence summary**

| FOR | AGAINST |
|-----|---------|
| Real user buffer overflow | Debugfs-only path |
| Mutex unlock-without-lock bug | Requires `CONFIG_DEBUG_FS` |
| Uninitialized stack variable use | Admin/privileged access typically
required |
| Small, reviewed, maintainer-acked fix | No syzbot/user crash reports |
| Applies cleanly to 6.18.43 | Affects narrow hardware/config subset |
| AUTOSel nominated for 6.18.y | |
| Buggy code confirmed in this tree | |

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — reviewed by AMD engineer +
   amdgpu maintainer; logic verified against buggy code
2. Fixes a real bug? **PASS** — confirmed overflow, mutex bug,
   uninitialized data
3. Important issue? **PASS** — memory safety / buffer overflow (severity
   tempered by privileged-only access)
4. Small and contained? **PASS** — 1 file, ~29 lines
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — cherry-pick tested clean

**Step 9.3 — Exception category**
Record: N/A (not device ID, quirk, DT, build, or docs fix — standard bug
fix).

**Step 9.4 — Decision rationale**
This fix addresses a genuine memory-safety bug in the CPER ring debugfs
reader that exists in Linux 6.18.43. The overflow is reachable on
ordinary multi-read patterns once the 12-byte header has been consumed.
While the path requires debugfs and typically root access, stable trees
routinely accept such fixes when they prevent kernel-to-userspace buffer
overruns and mutex imbalances. The patch is minimal, reviewed, applies
cleanly, and has been AUTOSel-nominated for 6.18.y.

---

## Verification

- [Phase 1] Parsed subject, tags (Reviewed-by Tao Zhou, SOB Alex
  Deucher); no Fixes/Reported-by/Link
- [Phase 1] Identified overflow, uninitialized pointers, lock scope as
  described bugs
- [Phase 2] Read `amdgpu_ring.c:497–576` — confirmed all four bug
  mechanisms in HEAD
- [Phase 2] Cherry-pick object `6bbede02dc62` changes only
  `amdgpu_debugfs_ring_read` (+21/−8)
- [Phase 3] `git describe HEAD` → v6.18.43; `make kernelversion`
  equivalent → 6.18.43
- [Phase 3] `git merge-base --is-ancestor 6bbede02dc62 HEAD` → NOT
  ancestor (fix not yet applied)
- [Phase 3] `git cherry-pick --no-commit 6bbede02dc62` → clean auto-
  merge on `amdgpu_ring.c`
- [Phase 3] `git show 5d324e5159d9e:...amdgpu_ring.c` lines 545–575 →
  buggy CPER path present at 6.18 base
- [Phase 4] `b4 dig -c 6bbede02dc62` →
  https://patch.msgid.link/20260507140004.244348-1-xiang.liu@amd.com
- [Phase 4] `b4 dig -a` → single v1 revision only
- [Phase 4] `b4 dig -w` → amd-gfx list, Hawking Zhang, Tao Zhou CC'd
- [Phase 4] Freedesktop archive — Tao Zhou Reviewed-by, no NAKs
- [Phase 4] Web search — AUTOSel 7.0-6.18 nomination found
- [Phase 5] `grep amdgpu_debugfs_ring_fops` → debugfs read entry point
  at `amdgpu_ring.c:592–595`
- [Phase 5] `amdgpu_debugfs_ring_init()` creates `amdgpu_ring_cper`
  debugfs file at line 648–656
- [Phase 6] `amdgpu_cper_init` present in `amdgpu_device.c:3310`;
  `amdgpu_cper.c` exists
- [Phase 6] No `amdgpu_uniras_enabled` or `amdgpu_ras_cper_debugfs_read`
  in this tree (not needed for fix)
- [Phase 8] Failure modes verified by code inspection: overflow, mutex
  imbalance, uninitialized `early[]`

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c | 29 +++++++++++++++++-------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
index 304564ec2f59a..431cc39ea0178 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -498,8 +498,9 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
 					size_t size, loff_t *pos)
 {
 	struct amdgpu_ring *ring = file_inode(f)->i_private;
-	uint32_t value, result, early[3];
+	u32 value, result, early[3] = { 0 };
 	uint64_t p;
+	u32 avail_dw, start_dw, read_dw;
 	loff_t i;
 	int r;
 
@@ -508,10 +509,10 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
 
 	result = 0;
 
-	if (*pos < 12) {
-		if (ring->funcs->type == AMDGPU_RING_TYPE_CPER)
-			mutex_lock(&ring->adev->cper.ring_lock);
+	if (ring->funcs->type == AMDGPU_RING_TYPE_CPER)
+		mutex_lock(&ring->adev->cper.ring_lock);
 
+	if (*pos < 12) {
 		early[0] = amdgpu_ring_get_rptr(ring) & ring->buf_mask;
 		early[1] = amdgpu_ring_get_wptr(ring) & ring->buf_mask;
 		early[2] = ring->wptr & ring->buf_mask;
@@ -543,13 +544,24 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
 			*pos += 4;
 		}
 	} else {
+		early[0] = amdgpu_ring_get_rptr(ring) & ring->buf_mask;
+		early[1] = amdgpu_ring_get_wptr(ring) & ring->buf_mask;
+
 		p = early[0];
 		if (early[0] <= early[1])
-			size = (early[1] - early[0]);
+			avail_dw = early[1] - early[0];
 		else
-			size = ring->ring_size - (early[0] - early[1]);
+			avail_dw = ring->buf_mask + 1 - (early[0] - early[1]);
 
-		while (size) {
+		start_dw = (*pos > 12) ? ((*pos - 12) >> 2) : 0;
+		if (start_dw >= avail_dw)
+			goto out;
+
+		p = (p + start_dw) & ring->ptr_mask;
+		avail_dw -= start_dw;
+		read_dw = min_t(u32, avail_dw, size >> 2);
+
+		while (read_dw) {
 			if (p == early[1])
 				goto out;
 
@@ -562,9 +574,10 @@ static ssize_t amdgpu_debugfs_ring_read(struct file *f, char __user *buf,
 
 			buf += 4;
 			result += 4;
-			size--;
+			read_dw--;
 			p++;
 			p &= ring->ptr_mask;
+			*pos += 4;
 		}
 	}
 
-- 
2.53.0

