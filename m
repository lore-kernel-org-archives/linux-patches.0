Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA88585994;
	Mon, 31 Aug 2026 13:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184211; cv=none; b=gv8XDDeReta9BxOioAyH7OR+xGtJTDLNqABoKG4X/2v39VnKkf28k0xG0cMvZFO/TV8l2lAaZdPiadp8OeOuBnhimg6HbJJRnCjRfdK2vllWYYLDMninzhPBcLg+FhrKICinT5TKcJ5M5CefioSLBDSgc2SZsntt0TBlRBy7B1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184211; c=relaxed/simple;
	bh=YPHlnGdrKCFmmYRPMXidT8+5WmdIN/x9DSkhn6kKrWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=smy3zLZ+lmEEG0kQlaw8LrLidtLYgQwgtFu+/vTuhgDfFG0sARmQ2RK7CD77afQO2hTK/16QXC987ENUu+M4WB01sbLWI9hx1YX5Uit4MmWUr2mED+yT/17KPslN4c5spsCK0eqpIhHJZSiMULPpe6UP78OBYf/AOAxSEg/aRFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YP41X942; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YP41X942"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF3C1F000E9;
	Mon, 31 Aug 2026 13:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184208;
	bh=MpRQ8P2gXziEUB85NYPqrgG3Gn19jCXIpeBcMD40xjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YP41X942FWawTmCDA9uJCWijN0lc1Bb+2+SNOMZ4/N7Cz3pQmPYV/EjcS3e0hTG2H
	 PPBzPqzPccdhAAcevKNEDDrKZDTNFoPxaVMTf+Z6B9tLgoVhS1u9E3A3ISvQi7Zgai
	 v/EBPbt7t8bUfgknIgsgvQeHAyMVVNiFaJaq0ZU2beSXdQ8EAhTeb8s6fX82FerUJZ
	 Krqgn5T458peolAj4J0iFIyvqf87WS/BlT8HlDSN3TrmVUEDvIHEzCgSyRu+RJA/zM
	 pTyXWoewsF76ztwJlb3gfIyYLq3WdvWrddfkl3gsFJdGL5cM+h1CFOj75lJ2Q07DuP
	 V3BnUkXYSngDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dawei Feng <dawei.feng@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] bpf: NUL-terminate replaced sysctl value
Date: Mon, 31 Aug 2026 09:29:44 -0400
Message-ID: <20260831133314.4125787-556-sashal@kernel.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

[ Upstream commit a66e3b5bacf38d6ab29fa05a9754f7a114485605 ]

When writing to sysctls, proc_sys_call_handler() guarantees that the
buffer passed to proc handlers is NUL-terminated. If
bpf_sysctl_set_new_value() replaces the pending sysctl value, it can
hand a replacement buffer directly to proc handlers. However, the
helper currently copies only buf_len bytes into that buffer without
appending a NUL terminator, leaving downstream parsers vulnerable to
out-of-bounds access.

Fix this by appending a '\0' after the replaced value to restore the
expected sysctl semantics. Since the helper already rejects buf_len
greater than PAGE_SIZE - 1, there is always room for the extra byte.

Reproduced in a QEMU x86_64 guest booted with KASAN while exercising
the sysctl replacement path with a cgroup/sysctl BPF program. The
reproducer targets `/proc/sys/net/core/flow_limit_cpu_bitmap`, fills
the original user write buffer with non-zero bytes, and overrides the
sysctl value so the replacement buffer lacks a terminating NUL. Under
that setup, the pre-fix kernel reported:

  BUG: KASAN: slab-out-of-bounds in strnchrnul+0x72/0x90
  Read of size 1 at addr ffff88800de57000 by task repro_patch3/66
  CPU: 0 UID: 0 PID: 66 Comm: repro_patch3 Not tainted 7.1.0-rc3-00269-g8370ca1f87cc #6 PREEMPT(lazy)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x68/0xa0
   print_report+0xcb/0x5e0
   ? __virt_addr_valid+0x21d/0x3f0
   ? strnchrnul+0x72/0x90
   ? strnchrnul+0x72/0x90
   kasan_report+0xca/0x100
   ? strnchrnul+0x72/0x90
   strnchrnul+0x72/0x90
   bitmap_parse+0x37/0x2e0
   flow_limit_cpu_sysctl+0xc6/0x840
   ? __pfx_flow_limit_cpu_sysctl+0x10/0x10
   ? __kvmalloc_node_noprof+0x5ba/0x870
   proc_sys_call_handler+0x31d/0x480
   ? __pfx_proc_sys_call_handler+0x10/0x10
   ? selinux_file_permission+0x39f/0x500
   ? lock_is_held_type+0x9e/0x120
   vfs_write+0x98e/0x1000
   ...
   </TASK>
  The buggy address is located 0 bytes to the right of
  allocated 4096-byte region [ffff88800de56000, ffff88800de57000)
With this fix applied, rerunning the same sysctl-targeted path yields
no corresponding KASAN reports.

Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20260603105317.944304-2-dawei.feng@seu.edu.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `bpf: NUL-terminate replaced sysctl value`

**Local tree:** Linux 6.18.44 (`git describe HEAD` → `v6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[bpf]` — fix (implicit via "NUL-terminate") — ensure BPF-
replaced sysctl write buffers are NUL-terminated before downstream proc
handlers parse them.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Zilin Guan, Dawei Feng, Alexei Starovoitov (ignore
  pipeline SOBs)
- **Acked-by:** Yonghong Song `<yonghong.song@linux.dev>` (BPF
  maintainer)
- **Link:** https://lore.kernel.org/r/20260603105317.944304-2-
  dawei.feng@seu.edu.cn
- No `Fixes:` tag (expected for manual review)
- No `Cc: stable@vger.kernel.org` in the committed message, but the v3
  series cover letter and sibling patches include stable CC (verified
  via b4 mbox)

**Notable patterns:** BPF maintainer ack; KASAN reproduction with full
stack trace; part of a 3-patch series fixing sysctl replacement path.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `bpf_sysctl_set_new_value()` copies `buf_len` bytes into
  `ctx->new_val` without appending `'\0'`, breaking the contract that
  `proc_sys_call_handler()` normally provides (NUL-terminated buffer).
- **Symptom:** KASAN slab-out-of-bounds in `strnchrnul` → `bitmap_parse`
  → `flow_limit_cpu_sysctl` when a cgroup/sysctl BPF program replaces a
  sysctl write value.
- **Root cause:** Downstream sysctl proc handlers (e.g. `cpumask_parse`
  → `bitmap_parse` with `UINT_MAX` length) scan until they find `'\0'`,
  reading past the valid string and past the kmalloc allocation.
- **Reproducer:** QEMU x86_64 + KASAN, BPF program targeting
  `/proc/sys/net/core/flow_limit_cpu_bitmap`.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit memory-safety bug fix (out-of-
bounds read), not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `kernel/bpf/cgroup.c` (+1 line)
- **Function:** `bpf_sysctl_set_new_value()`
- **Scope:** Single-file, surgical fix (1 line added)

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `memcpy(ctx->new_val, buf, buf_len)` then set
  `ctx->new_len = buf_len` — buffer has no guaranteed terminator at
  `buf_len`.
- **After:** Same memcpy, then `((char *)ctx->new_val)[buf_len] = '\0'`
  — restores NUL-termination contract before
  `__cgroup_bpf_run_filter_sysctl()` hands the buffer to proc handlers
  via `proc_sys_call_handler()`.
- **Path affected:** Sysctl write path when a `BPF_CGROUP_SYSCTL`
  program calls `bpf_sysctl_set_new_value()`.

### Step 2.3: Bug Mechanism
**Record:** **Buffer overflow / out-of-bounds read (memory safety).**
`cpumask_parse()` calls `bitmap_parse(buf, UINT_MAX, ...)`, which calls
`strnchrnul(start, buflen, '\n')`. Without a NUL at the end of the
replaced string, `strnchrnul` keeps reading until it finds `'\0'`,
scanning past the kmalloc'd `PAGE_SIZE` buffer into unmapped memory.

### Step 2.4: Fix Quality
**Record:** Obviously correct and minimal. The helper already rejects
`buf_len > PAGE_SIZE - 1`, so index `buf_len` is always within the
`PAGE_SIZE` allocation. Matches what `proc_sys_call_handler()` does at
line 591 (`kbuf[count] = '\0'`). No regression risk — `ctx->new_len`
remains `buf_len` (length excluding terminator), consistent with normal
sysctl semantics.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy `bpf_sysctl_set_new_value()` logic introduced in
`4e63acdff8646` ("bpf: Introduce bpf_sysctl_{get,set}_new_value
helpers", April 2019). All lines of the function blame to that commit.
Bug has existed since the helper was added.

### Step 3.2: Fixes Tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related File History
**Record:** Recent related fixes already in this 6.18.44 tree:
- `d94ab0e91d3ff` — "bpf: Restore sysctl new-value from 1 to 0" (fixes
  stale `ret == 1` check; restores replacement functionality broken
  since `f10d05966196`)
- `65bd0c0afb0e1` — "bpf: use kvfree() for replaced sysctl write buffer"

These are patches 3/3 and 2/3 of the same v3 series. Only patch 1/3
(NUL-terminate) is missing from this tree.

### Step 3.4: Author Context
**Record:** Dawei Feng authored the full 3-patch sysctl series. Same
author committed patches 2 and 3 to this tree (via stable backports with
Greg KH as committer).

### Step 3.5: Dependencies
**Record:** Standalone one-line fix. The replacement path must be
functional for the bug to be reachable; `d94ab0e91d3ff` (already in
tree) restored that path. No additional prerequisites needed beyond
existing code.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- **b4 dig URL:**
  https://patch.msgid.link/20260603105317.944304-2-dawei.feng@seu.edu.cn
- **Series revisions:** v1 (2026-05-26), v2 (2026-05-29), v3
  (2026-06-03) — committed version matches v3
- **Reviewer feedback:** Acked-by Yonghong Song; Reviewed-by Emil
  Tsalapatis, Jiayuan Chen; Acked-by Xu Kuohai
- **Stable nomination:** v3 cover letter and sibling patches CC
  `stable@vger.kernel.org`; reviewer noted "Without it the fix is
  unlikely to be picked up for stable"
- **No NAKs found** in mbox thread

### Step 4.2: Reviewers
**Record:** CC'd: ast@kernel.org, daniel@iogearbox.net,
andrii@kernel.org, yonghong.song@linux.dev, bpf@vger.kernel.org, linux-
kernel@vger.kernel.org — appropriate BPF maintainers and lists.

### Step 4.3: Bug Report
**Record:** KASAN stack trace in commit message (self-contained
reproducer). No syzbot report. Reproduced by authors in QEMU with KASAN.

### Step 4.4: Series Context
**Record:** 3-patch series "bpf: fix sysctl new-value handling in
__cgroup_bpf_run_filter_sysctl()". Patches 2 and 3 already backported to
6.18.44; patch 1 is the remaining piece.

### Step 4.5: Stable List History
**Record:** Sibling patches in the series were explicitly CC'd to stable
and have already landed in this tree. This patch was intended for stable
as part of the same series.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `bpf_sysctl_set_new_value()` (modified); callers via BPF
helper dispatch in `sysctl_func_proto()`.

### Step 5.2: Callers / Impact Surface
**Record:** Called only from BPF programs attached as
`BPF_CGROUP_SYSCTL`. Triggered during `write()` to `/proc/sys/*` files
when `BPF_CGROUP_RUN_PROG_SYSCTL` runs in `proc_sys_call_handler()` →
`__cgroup_bpf_run_filter_sysctl()`.

### Step 5.3: Callees
**Record:** `memcpy()`, sets `ctx->new_updated`. On success,
`__cgroup_bpf_run_filter_sysctl()` replaces `*buf` with `ctx->new_val`
and calls the sysctl proc handler.

### Step 5.4: Reachability
**Record:**
```
write(/proc/sys/...) → proc_sys_write → proc_sys_call_handler
  → BPF_CGROUP_RUN_PROG_SYSCTL → __cgroup_bpf_run_filter_sysctl
    → bpf_prog_run (BPF program calls bpf_sysctl_set_new_value)
  → table->proc_handler (e.g. flow_limit_cpu_sysctl → cpumask_parse →
bitmap_parse → strnchrnul)
```
Reachable from syscall path (`write`). Requires privileges to load BPF
cgroup programs and write sysctls, but the OOB read is a real kernel
memory safety defect.

### Step 5.5: Similar Patterns
**Record:** `copy_sysctl_value()` in the same file correctly NUL-
terminates at lines 2332–2337. The missing NUL in
`bpf_sysctl_set_new_value()` is an inconsistency with established sysctl
helper semantics.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Current `kernel/bpf/cgroup.c` lines 2386–2388 show
`memcpy` without NUL terminator:

```2386:2388:kernel/bpf/cgroup.c
        memcpy(ctx->new_val, buf, buf_len);
        ctx->new_len = buf_len;
        ctx->new_updated = 1;
```

Fix commit `a78e6d830b563` / upstream `a66e3b5bacf38` is **NOT** an
ancestor of HEAD.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — single line addition at a location
unchanged since 2019. No conflicts anticipated.

### Step 6.3: Related Fixes Already Present?
**Record:** Patches 2/3 and 3/3 of the series are already in tree
(`65bd0c0afb0e1`, `d94ab0e91d3ff`). No alternate fix for the NUL-
termination issue.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `kernel/bpf/` — BPF cgroup sysctl filtering. **Criticality:
IMPORTANT** (core BPF infrastructure on sysctl write path; affects any
sysctl targeted by BPF programs).

### Step 7.2: Activity
**Record:** Actively maintained; recent sysctl-related fixes landed in
this tree in 2026.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Systems using `BPF_PROG_TYPE_CGROUP_SYSCTL` programs that
call `bpf_sysctl_set_new_value()`. Config-dependent
(`CONFIG_BPF_SYSCALL`, `CONFIG_CGROUP_BPF`).

### Step 8.2: Trigger Conditions
**Record:** Sysctl write + BPF program replaces value via
`bpf_sysctl_set_new_value()` + downstream proc handler parses buffer as
C string. Requires elevated privileges (CAP_BPF, sysctl write access).
Replacement path is now functional in 6.18.44 after `d94ab0e91d3ff`.

### Step 8.3: Failure Mode Severity
**Record:** KASAN slab-out-of-bounds read in `strnchrnul`. **Severity:
HIGH** — kernel memory safety violation; potential info leak or crash
depending on what lies past the allocation. Proven with KASAN.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents OOB read on a real, tested code path;
  completes a partially-backported fix series
- **Risk:** VERY LOW — one line, mirrors existing
  `proc_sys_call_handler` behavior, room guaranteed by `PAGE_SIZE - 1`
  limit
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, KASAN-proven slab-out-of-bounds read
- Small (1 line), obviously correct fix
- Bug present in 6.18.44 since helper introduction (2019); now reachable
  after sibling fix `d94ab0e91d3ff`
- BPF maintainer Acked-by
- Series explicitly nominated for stable; patches 2/3 already in this
  tree
- Completes an incomplete stable backport of a 3-patch series

**AGAINST backport:**
- Requires privileged BPF + sysctl access to trigger (not unprivileged
  attack)
- No CVE assigned (minor concern)

**Unresolved:** None material to the decision.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — KASAN reproducer; maintainer
   ack
2. Fixes a real bug affecting users? **PASS** — OOB read on sysctl write
   path
3. Important issue? **PASS** — memory safety / potential crash (HIGH)
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply expected

### Step 9.3: Exception Categories
**Record:** N/A (standard bug fix, not a quirk/DT/device-ID exception).

### Step 9.4: Decision Rationale
This is a clear memory-safety fix for a bug that exists in Linux
6.18.44. The replacement path is functional in this tree (thanks to
`d94ab0e91d3ff`), making the OOB read reachable. Two of three patches
from the same fix series are already backported; this is the missing
piece. The fix is trivial, proven, and low-risk.

---

## Verification

- [Phase 1] `git describe HEAD` → v6.18.44; parsed subject, tags, body
  from provided commit message
- [Phase 1] Acked-by Yonghong Song confirmed in commit message
- [Phase 2] Read `kernel/bpf/cgroup.c` lines 2377–2391 — buggy code
  confirmed (no NUL terminator)
- [Phase 2] `git diff a78e6d830b563^..a78e6d830b563` — exactly 1 line
  added
- [Phase 2] Read `fs/proc/proc_sysctl.c` lines 583–600 — `kbuf[count] =
  '\0'` confirms expected contract
- [Phase 2] Read `net/core/sysctl_net_core.c` lines 209–223 —
  `cpumask_parse(buffer, mask)` on write path
- [Phase 2] Read `include/linux/cpumask.h` line 977–979 —
  `bitmap_parse(buf, UINT_MAX, ...)`
- [Phase 2] Read `lib/bitmap-str.c` line 476 — `strnchrnul(start,
  buflen, '\n')`
- [Phase 2] Read `lib/string.c` lines 367–371 — `strnchrnul` scans until
  `*s == 0`
- [Phase 3] `git blame -L 2377,2391 kernel/bpf/cgroup.c` → all lines
  from `4e63acdff8646` (2019-04-12)
- [Phase 3] `git show 4e63acdff8646` — introduced
  `bpf_sysctl_set_new_value`
- [Phase 3] `git log --oneline -30 -- kernel/bpf/cgroup.c` — related
  fixes `d94ab0e91d3ff`, `65bd0c0afb0e1` present
- [Phase 3] `git merge-base --is-ancestor f10d05966196 HEAD` →
  BPF_PROG_RUN_ARRAY change in tree
- [Phase 3] `git merge-base --is-ancestor a78e6d830b563 HEAD` → fix NOT
  in tree
- [Phase 4] `b4 dig -c a78e6d830b563` → lore URL found
- [Phase 4] `b4 dig -c a78e6d830b563 -a` → v1/v2/v3 series; v3 is latest
- [Phase 4] `b4 dig -c a78e6d830b563 -w` → BPF maintainers CC'd
- [Phase 4] `b4 dig -c a78e6d830b563 -m /tmp/bpf_nul_thread.mbox` —
  stable CC, Acked-by, Reviewed-by confirmed
- [Phase 5] Read `kernel/bpf/cgroup.c` lines 1931–1988 —
  `__cgroup_bpf_run_filter_sysctl` buffer replacement path
- [Phase 5] Read `include/linux/bpf-cgroup.h` lines 366–370 —
  `BPF_CGROUP_RUN_PROG_SYSCTL` macro
- [Phase 6] Confirmed buggy code at lines 2386–2388 without fix
- [Phase 6] `git merge-base --is-ancestor 65bd0c0afb0e1 HEAD` → kvfree
  fix in tree
- [Phase 6] `git merge-base --is-ancestor d94ab0e91d3ff HEAD` → ret==0
  fix in tree
- [Phase 8] KASAN stack trace from commit message — slab OOB at
  PAGE_SIZE boundary

**YES**

 kernel/bpf/cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index fc2f44b60a551..86475115ccad6 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -2384,6 +2384,7 @@ BPF_CALL_3(bpf_sysctl_set_new_value, struct bpf_sysctl_kern *, ctx,
 		return -E2BIG;
 
 	memcpy(ctx->new_val, buf, buf_len);
+	((char *)ctx->new_val)[buf_len] = '\0';
 	ctx->new_len = buf_len;
 	ctx->new_updated = 1;
 
-- 
2.53.0

