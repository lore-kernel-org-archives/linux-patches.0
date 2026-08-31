Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4974AEBC2;
	Mon, 31 Aug 2026 13:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184142; cv=none; b=GrG9MSXWMb6wZOsduF/e1ln0/dcwbpveoV/uM2aAnHUe5V6v89cHxV7ACCE/kAAi860TLv9tsAboLwoTN9nYgaFG75FlWIRD95IB/ZsqZDwW0G1XGPo/NZ//1iHE8++x2lASfauJKDtOauHfx4DSUEmY52Yyhpz1Vej2hf70LSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184142; c=relaxed/simple;
	bh=7zEFP8ZY1r0gCLEU+l9NnJVIjNcgzLZ61BnKsn/iRQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gj59GLW2ZMDP3aTxlVjUL+Q6rmFycLn+K7m5opGoI73DgpnjEA9m2K2mlvBXEiQDRjTocn1+dmOPbT3EZ/ml9Jj8qe+ukRgG+sVq2EgaYGmNFQgqEdeXoop/TGie//m5wKXOYphkRqoJ1sZnp07zS90U5reRoD0+CZqAUtmPBKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VN1j4fm4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VN1j4fm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B781F00A3E;
	Mon, 31 Aug 2026 13:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184137;
	bh=CBWdldcJE8xPdqsaPFZXxeaY6tXuX3vHWPhS0ty9szg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VN1j4fm4/DWVdV0vyIyeTHUL1iiUyLT72F896UCjcoQxlq55FK00YmNvBE1pHH18Z
	 yPjuu9pDVbAhkcQxi8eMRpq1bLUPhFqcy7yVIzXmPQWuEM7KZBNa8vM7bGWQM9Elc7
	 P1s0ZtvAQW3dOLoPBxTW6i5Y0hrsvkrWjOTyvSuKfq0oAvLjFWCih+mjPfJPy6SKVz
	 RkJVcSqlCX2u4BpKwJwby8/JZztWqRani+YNv5ol2K2iFEkLRqAkSt/j6azevSRUAB
	 JW8UIIhGgzx9G+PG2507qz1FRMCofzCzeLgYj4AQKtr67Cs7uGad0K4n3XSi+VZNXr
	 hskj+33uQdSfQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yongqiang Sun <Yongqiang.Sun@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdkfd: fix SMI event cross-process information leak
Date: Mon, 31 Aug 2026 09:29:02 -0400
Message-ID: <20260831133314.4125787-514-sashal@kernel.org>
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

From: Yongqiang Sun <Yongqiang.Sun@amd.com>

[ Upstream commit 92a8dba246d371fe268280e5fd74b0955688e6df ]

kfd_smi_ev_enabled() skips the suser privilege check when pid=0.
PROCESS_START, PROCESS_END, and VMFAULT events are emitted with
pid=0 while carrying another process's PID and command name, so any
/dev/kfd user in the render group can monitor all GPU workloads.

Pass the target process PID into kfd_smi_event_add() for these events
so the existing per-client filter restricts delivery to the owning
process or CAP_SYS_ADMIN subscribers.

Signed-off-by: Yongqiang Sun <Yongqiang.Sun@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[drm/amdkfd] [fix] SMI event cross-process information leak`

**Step 1.2 — Tags**

Record:
- `Signed-off-by: Yongqiang Sun <Yongqiang.Sun@amd.com>` (author)
- `Acked-by: Alex Deucher <alexander.deucher@amd.com>` (AMD DRM
  maintainer)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (committer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`, or `Cc:
  stable@vger.kernel.org`

Notable: maintainer Acked-by; no syzbot or user bug report tags.

**Step 1.3 — Body analysis**

Record:
- **Bug:** `kfd_smi_ev_enabled()` does not apply per-client PID
  filtering when the filter PID argument is `0`. `PROCESS_START`,
  `PROCESS_END`, and `VMFAULT` events are emitted with filter PID `0`
  but carry another process's PID and command name in the event payload.
- **Symptom:** Any `/dev/kfd` user in the render group can monitor all
  GPU workloads (other processes' PIDs and command names).
- **Root cause:** `kfd_smi_event_add(0, ...)` bypasses the `if (pid &&
  ...)` guard in `kfd_smi_ev_enabled()`.
- **Fix:** Pass `task_info->tgid` into `kfd_smi_event_add()` so the
  existing filter restricts delivery to the owning process or
  `CAP_SYS_ADMIN` subscribers (`client->suser`).

**Step 1.4 — Hidden bug fix?**

Record: No — this is an explicit security/privacy bug fix, not disguised
cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c` (+5 / -3
  lines)
- **Functions modified:** `kfd_smi_event_update_vmfault()`,
  `kfd_smi_event_process()`
- **Scope:** Single-file surgical fix

**Step 2.2 — Code flow changes**

Record:
- **Hunk 1 (`kfd_smi_event_update_vmfault`):** Before:
  `kfd_smi_event_add(0, dev, VMFAULT, ...)` → all subscribed clients
  receive VM fault events with other processes' PID/comm. After:
  `kfd_smi_event_add(task_info->tgid, dev, VMFAULT, ...)` → only
  matching client or admin receives it.
- **Hunk 2 (`kfd_smi_event_process`):** Before: `kfd_smi_event_add(0,
  pdd->dev, PROCESS_START/END, ...)` → broadcast. After:
  `kfd_smi_event_add(task_info->tgid, pdd->dev, ...)` → per-process
  filtering.

**Step 2.3 — Bug mechanism**

Record: **Information leak / missing access control.** Category (d)
memory-safety adjacent — logic/correctness in security filtering.
`pid=0` is intentional for system-wide events (GPU reset, thermal
throttle); using it for per-process events defeats isolation.

**Step 2.4 — Fix quality**

Record: Obviously correct — uses `task_info->tgid`, which matches
`client->pid = current->tgid` set in `kfd_smi_event_open()`. Minimal
change. Low regression risk; system-wide events still use `pid=0`.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record:
- `kfd_smi_ev_enabled()` filter: Philip Yang, 2022-01-13
  (`163a5a58437062`); superuser logic simplified by Eric Huang,
  2025-04-14 (`6b9d26089f56f`).
- VMFAULT with `pid=0`: since at least Shashank Sharma refactor,
  2024-01-18 (`b8f67b9ddf4f8`); format-only change in 2024-02-16
  (`663b0f1e141dc`).
- PROCESS_START/END with `pid=0`: introduced 2025-04-07
  (`4172b556fd5bd`).

**Step 3.2 — Fixes: tag**

Record: Not applicable — no `Fixes:` tag. Buggy PROCESS events
introduced by `4172b556fd5bd`; VMFAULT leak predates that.

**Step 3.3 — Related file history**

Record: Recent related commits in this tree:
- `6b9d26089f56f` — superuser SMI filter fix (present)
- `4172b556fd5bd` — process start/end events (present, introduced leak)
- `9315860d05aa2` — NULL check fix for process SMI event
- `9fd86747daa6c` — queue restore string fix
- On master but not in 6.18.44: `92a8dba246d37` / `3b347d011773d` (this
  fix), `1142738572ef3` (container PID reporting — separate, larger
  change)

**Step 3.4 — Author context**

Record: Yongqiang Sun has at least one other amdkfd fix in history. Alex
Deucher (maintainer) Acked and committed the fix.

**Step 3.5 — Dependencies**

Record: Standalone — uses `task_info->tgid` already present in `struct
amdgpu_task_info` since 2018 (`2aa37bf58838f`). No series prerequisites.
`git apply --check` passes cleanly on 6.18.44.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig -c 3b347d011773d` found v1 only at
https://patch.msgid.link/20260527141014.567441-1-Yongqiang.Sun@amd.com.
Lore fetch blocked by Anubis bot protection; no thread replies
retrieved.

**Step 4.2 — Reviewers**

Record: `b4 dig -w` — sent to Yongqiang Sun and `amd-
gfx@lists.freedesktop.org`. Alex Deucher Acked in commit.

**Step 4.3 — Bug report**

Record: Not applicable — no `Reported-by:` or `Link:` tags. Bug
identified by code review / internal AMD analysis per commit message.

**Step 4.4 — Related patches**

Record: Container PID fix (`1142738572ef3`) is a separate follow-up on
master; not required for this security fix to function on non-container
or host-PID setups.

**Step 4.5 — Stable list**

Record: Not searched (lore blocked). No stable nomination found in
available sources.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `kfd_smi_ev_enabled()`, `kfd_smi_event_add()`,
`kfd_smi_event_update_vmfault()`, `kfd_smi_event_process()`,
`kfd_smi_event_open()`

**Step 5.2 — Callers**

Record:
- `kfd_smi_event_update_vmfault()` ← `kfd_int_process_v9.c`,
  `kfd_int_process_v11.c`, `cik_event_interrupt.c` (GPU fault interrupt
  paths)
- `kfd_smi_event_process()` ← `kfd_process.c` (process start at line
  ~1727, end at ~1059)
- `kfd_smi_event_open()` ← `kfd_chardev.c` via `kfd_ioctl_smi_events()`
  (userspace ioctl)

**Step 5.3 — Callees**

Record: `amdgpu_vm_get_task_info_pasid()`,
`amdgpu_vm_get_task_info_vm()`, `add_event_to_kfifo()` → iterates all
SMI clients and checks `kfd_smi_ev_enabled()`.

**Step 5.4 — Reachability**

Record: Userspace opens SMI event fd via KFD ioctl (`/dev/kfd`, render
group). GPU faults and process lifecycle events are triggered by normal
KFD compute workloads. **Reachable by unprivileged render-group users**
who can subscribe to SMI events and receive other users' process
metadata.

**Step 5.5 — Similar patterns**

Record: Other per-process events (`page_fault`, `migration`,
`queue_eviction`, etc.) already pass non-zero PID and are correctly
filtered. Only VMFAULT and PROCESS_START/END incorrectly used `pid=0`.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is `v6.18.44` on `stable/linux-6.18.y`.
Verified:
- Line 257: `kfd_smi_event_add(0, dev, KFD_SMI_EVENT_VMFAULT, ...)`
- Line 359: `kfd_smi_event_add(0, pdd->dev, PROCESS_START/END, ...)`
- Filter at lines 168-169 skips all PID checks when `pid==0`
- Fix commit `3b347d011773d` is **not** an ancestor of HEAD (`merge-
  base` exit 1)

**Step 6.2 — Backport complications**

Record: **Clean apply** — `git show 3b347d011773d -p | git apply
--check` succeeded with no conflicts.

**Step 6.3 — Related fixes already present?**

Record: Superuser filter fix (`6b9d26089f56f`) is present but does not
address `pid=0` bypass. This specific information-leak fix is absent.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem**

Record: `drivers/gpu/drm/amd/amdkfd` — AMD KFD (ROCm/HSA GPU compute).
Criticality: **IMPORTANT** for AMD GPU compute users; config-dependent
(`CONFIG_HSA_AMD`).

**Step 7.2 — Activity**

Record: Actively maintained — multiple SMI event commits in 2024-2026 in
this file.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Multi-user systems with AMD GPUs and KFD/ROCm enabled; any user
in the render group with `/dev/kfd` access.

**Step 8.2 — Trigger conditions**

Record: Another user's KFD process starts/ends or triggers a VM fault
while a malicious/co-resident user has an SMI event fd subscribed.
Common on shared GPU servers, HPC clusters, and multi-tenant
workstations.

**Step 8.3 — Failure mode severity**

Record: **Cross-process information disclosure** — other processes' PIDs
and command names exposed. Severity: **HIGH** (security/privacy; not
crash/corruption, but violates process isolation). Unprivileged render-
group users can trigger it.

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** HIGH — closes a real cross-process monitoring hole on
  shared GPU systems
- **Risk:** VERY LOW — 8-line change, uses existing fields and filtering
  logic, maintainer-acked
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR:**
- Real security/privacy bug (cross-process PID/comm leak)
- Small, surgical, maintainer-acked fix
- Applies cleanly to 6.18.44
- Buggy code confirmed present in this tree
- Unprivileged users in render group can exploit
- Aligns with stable policy for security fixes

**AGAINST:**
- Affects only AMD KFD users (not universal)
- No external bug report or syzbot confirmation
- Container PID correctness is a separate follow-up on master (not a
  reason to reject this fix)

**UNRESOLVED:**
- Full lore thread discussion (Anubis blocked fetch)
- No explicit stable-list nomination found

**Step 9.2 — Stable rules checklist**

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — logic clear; Acked-by
maintainer |
| 2. Fixes real bug affecting users? | **PASS** — cross-process info
leak on shared GPUs |
| 3. Important issue? | **PASS** — security information disclosure
(HIGH) |
| 4. Small and contained? | **PASS** — 8 lines, 1 file |
| 5. No new features/APIs? | **PASS** — corrects existing event delivery
only |
| 6. Can apply to this tree? | **PASS** — clean apply verified |

**Step 9.3 — Exception categories**

Record: None (not a quirk/DT/build/doc fix) — qualifies on security bug-
fix merits.

**Step 9.4 — Decision rationale**

This commit fixes a genuine cross-process information leak in AMD KFD
SMI events. The buggy code is present in Linux 6.18.44, the fix is
minimal and obviously correct, and it restores the intended per-process
isolation that `kfd_smi_ev_enabled()` was designed to provide. Shared-
GPU and multi-user ROCm deployments on stable kernels should receive
this security fix.

---

## Verification

- [Phase 1] Parsed commit message and tags from user query and `git show
  3b347d011773d`
- [Phase 2] Read current `kfd_smi_events.c` lines 163-366; confirmed
  diff changes only VMFAULT and PROCESS paths
- [Phase 3] `git blame` on filter and event functions; identified
  introducing commits `4172b556fd5bd`, `b8f67b9ddf4f8`, `6b9d26089f56f`,
  `163a5a58437062`
- [Phase 3] `git merge-base --is-ancestor`: PROCESS events and superuser
  fix present; info-leak fix absent
- [Phase 3] `git show 3b347d011773d -p | git apply --check`: clean apply
- [Phase 4] `b4 dig -c 3b347d011773d`: found lore URL; v1 only
- [Phase 4] `b4 dig -w`: amd-gfx list CC'd
- [Phase 4] `b4 dig -a`: single v1 revision
- [Phase 4] WebFetch lore URL: blocked by Anubis (no thread content)
- [Phase 5] `grep` callers of `kfd_smi_event_update_vmfault` and
  `kfd_smi_event_process`
- [Phase 5] Read `kfd_smi_event_open()`: `client->pid = current->tgid`,
  `client->suser = capable(CAP_SYS_ADMIN)`
- [Phase 5] Verified `task_info->tgid` populated in `amdgpu_vm.c:2543`
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] Confirmed buggy `kfd_smi_event_add(0, ...)` at lines 257 and
  359 in current tree
- [Phase 6] `git log stable/linux-6.18.y..master -- kfd_smi_events.c`:
  fix on master, not in stable
- [Phase 8] Assessed severity as cross-process information disclosure
  via render-group `/dev/kfd` access

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
index d2bc169e84b0b..fe4b936923854 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
@@ -254,8 +254,10 @@ void kfd_smi_event_update_vmfault(struct kfd_node *dev, uint16_t pasid)
 	if (task_info) {
 		/* Report VM faults from user applications, not retry from kernel */
 		if (task_info->task.pid)
-			kfd_smi_event_add(0, dev, KFD_SMI_EVENT_VMFAULT, KFD_EVENT_FMT_VMFAULT(
-					  task_info->task.pid, task_info->task.comm));
+			kfd_smi_event_add(task_info->tgid, dev,
+					  KFD_SMI_EVENT_VMFAULT,
+					  KFD_EVENT_FMT_VMFAULT(task_info->task.pid,
+								task_info->task.comm));
 		amdgpu_vm_put_task_info(task_info);
 	}
 }
@@ -356,7 +358,7 @@ void kfd_smi_event_process(struct kfd_process_device *pdd, bool start)
 	task_info = amdgpu_vm_get_task_info_vm(avm);
 
 	if (task_info) {
-		kfd_smi_event_add(0, pdd->dev,
+		kfd_smi_event_add(task_info->tgid, pdd->dev,
 				  start ? KFD_SMI_EVENT_PROCESS_START :
 				  KFD_SMI_EVENT_PROCESS_END,
 				  KFD_EVENT_FMT_PROCESS(task_info->task.pid,
-- 
2.53.0

