Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C725DD55A;
	Mon, 19 Oct 2026 14:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418548; cv=none; b=kim03SQQQ8CDv1PEIZ6MCrMzNOpGgWJ5S3xBya7y8mehdNi7Emiu/B+tYZkyt4Qv7X3NZw/qt4+OBESPWHoZIyWJgDBvMeSpdyzZSp3pORcMFtDCyGJgn1aIe6e3agV1LSzUiSdSVKKp/LZTyGMnvVz2R/TQEBgdtkJMgbmrxlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418548; c=relaxed/simple;
	bh=LE3Kv7Qns3rlZoneNgTeytOBAiXvMZHekS2Zx5AqkVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=duXsBSO4zYGoDpZrN/2lB8jhBTc9o0DsblUKoq1DiIWwRwdh68GjgWDhPVXhsV2xkC9OdmsQoOOV7I3mRFCAKTzwPHBPs1Eq0m7U+jJZcYpSBK21juEIDej1mXmstSZ1XndnNlb0bjoSJiwjAQpEQ07wlx8k1dAjZYh/UTVkuKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Am/QgtGB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Am/QgtGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F1E1F000CA;
	Mon, 19 Oct 2026 14:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418545;
	bh=uAyfzSL+KBnTpm8lz6gbxfhV5Hr/gzCgN0IahSCbmUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Am/QgtGB90XDPD4NzcronxpUAEPSHHAA/XF6NfC9qsNBCJUK8dxSka7z1XfJ710UY
	 1lv5Cx2z1wIroLGiNJ6DVeiq4oJ9LZoVKqvgskoLKDQFvB7ls0hUIFCSbVELG5b5jG
	 wrRmEbVTNaL1LnCw71C5RAMJb+vN2gSX2VpBJy3nHntX3WmP1cALweXbonxDlkns/a
	 nfWa9PLePEpCncXQ64QPtJcunjBiCwwcCADEnTTGnguxXtfOMQTtZkAnU3P3aNlw0L
	 KEnHnG2Srdisjw0iqRzBcheV2+zJgEorx/4OnDa/4QUxid0tmZ52MZhMXp3BIOfFBi
	 H3Yym/oW8qTNQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zihan Xi <zihanx@nebusec.ai>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	magnus.karlsson@intel.com,
	maciej.fijalkowski@intel.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] xsk: account ring allocations to memcg
Date: Mon, 19 Oct 2026 09:50:15 -0400
Message-ID: <20261019135441.1420968-324-sashal@kernel.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

[ Upstream commit b0057c68df711bf6a62033c072ac61c4f9d3cbc1 ]

AF_XDP rings are allocated from setsockopt() and can be mapped into user
space.  The shared xskq_create() helper allocates the ring backing memory,
but the user-controlled and long-lived allocation is not charged as kmem
to the allocating memory cgroup.

The current implementation uses vmalloc_user(), which allocates the
backing pages with GFP_KERNEL | __GFP_ZERO.  Use the same VM_USERMAP
vmalloc path, but pass GFP_KERNEL_ACCOUNT so the ring backing pages are
attributed to memcg/kmem and can be constrained by existing cgroup memory
limits.  This keeps the existing zeroing and mmap semantics while avoiding
AF_XDP-specific optmem or RLIMIT_MEMLOCK accounting.

Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260731164623.4694-2-zihanx@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The AF_XDP ring path
still uses unaccounted `vmalloc_user()`, so this is a real memcg/DoS
hole in this checkout, not a no-op.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: `xsk` (AF_XDP / `net/xdp`)
- Action verb: **account** (resource-accounting fix, not a refactor)
- Claimed intent: charge AF_XDP ring backing pages to memcg/kmem

Record: `[xsk] [account] charge AF_XDP ring allocations to memcg`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

From the candidate message:
- `Acked-by: Stanislav Fomichev <sdf@fomichev.me>`
- `Link:
  https://patch.msgid.link/20260731164623.4694-2-zihanx@nebusec.ai`
- `Signed-off-by: Zihan Xi <zihanx@nebusec.ai>`
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>`
- Ignore: any `Signed-off-by: Sasha Levin` (pipeline)

From the original v3 submission (mailing list, not treated as “already
selected”):
- `Fixes: 423f38329d26 ("xsk: add umem fill queue support and mmap")`
- `Cc: stable@vger.kernel.org`
- `Reported-by: Vega <vega@nebusec.ai>`
- `Assisted-by: Codex:gpt-5.4`

No syzbot, no Tested-by. Absence of Fixes/Cc:stable on the candidate
copy is expected and is not a NO signal.

Record: Ack from XDP/BPF reviewer; original submission had Fixes +
Cc:stable + Reported-by; applied by netdev maintainer.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Bug: `xskq_create()` allocates mmapable ring memory from `setsockopt()`
with `vmalloc_user()` (`GFP_KERNEL | __GFP_ZERO`). That allocation is
user-controlled, long-lived, and **not charged to memcg/kmem**.

Symptom: a task with `CAP_NET_RAW` in a user+net namespace can request
very large RX/TX/fill/completion rings **before bind or packet I/O**.
Cover letter includes a PoC (`unshare -Urn ./poc`, 1<<25 entries) and an
OOM panic on **6.12.95** with `panic_on_oom`.

Root cause: missing `__GFP_ACCOUNT` on the VM_USERMAP vmalloc path.
Author explicitly says panic_on_oom is environment-specific; the defect
is missing kmem attribution.

Record: `[Bug: unaccounted userspace-triggered vmalloc of AF_XDP rings]
[Symptom: memcg-limit bypass / global OOM] [Version: repro on 6.12.95]
[Cause: vmalloc_user uses GFP_KERNEL, not GFP_KERNEL_ACCOUNT]`

**Step 1.4: DETECT HIDDEN BUG FIXES**

Not disguised. It is a missing-accounting fix. Kernel policy in
`Documentation/core-api/memory-allocation.rst` says untrusted userspace
allocations **must** set `__GFP_ACCOUNT`.

Record: `[Not hidden; explicit resource-accounting / isolation bug]`

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

File: `net/xdp/xsk_queue.c` only (~+11 / -1)

- Add `#include <asm/shmparam.h>`
- Add `xskq_vmalloc_user()`
- In `xskq_create()`: `vmalloc_user(size)` → `xskq_vmalloc_user(size)`

`xskq_destroy()` still `vfree()`s the ring (uncharge is automatic on
page free).

Record: `[1 file, ~12 lines] [xskq_vmalloc_user added; xskq_create
modified] [single-file surgical]`

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Before: `vmalloc_user()` → `__vmalloc_node_range(..., GFP_KERNEL |
__GFP_ZERO, PAGE_KERNEL, VM_USERMAP, ...)`

After: same VM_USERMAP/SHMLBA/zeroing/mmap path, GFP flag is
`GFP_KERNEL_ACCOUNT | __GFP_ZERO`.

Affected path: `setsockopt(SOL_XDP,
XDP_{RX,TX,UMEM_FILL,UMEM_COMPLETION}_RING)` → `xsk_setsockopt` →
`xsk_init_queue` → `xskq_create`. Normal allocation path, not an error-
path-only change.

Record: `[before: unaccounted vmalloc_user] [after: identical vmalloc,
charged to memcg]`

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Category: resource accounting / isolation (userspace-triggered kernel
memory not charged to kmemcg). Secondary failure mode: OOM /
panic_on_oom.

Mechanism: `GFP_KERNEL` vs `GFP_KERNEL_ACCOUNT` (`GFP_KERNEL |
__GFP_ACCOUNT`). In this tree, `__vmalloc_node_range_noprof()` honors
`__GFP_ACCOUNT` (page alloc + `MEMCG_VMALLOC` stat).

Not UAF, leak, race, or bounds check.

Record: `[resource accounting] [uncharged mmapable ring pages; fix is
GFP_KERNEL_ACCOUNT]`

**Step 2.4: ASSESS THE FIX QUALITY**

Obviously correct relative to `vmalloc_user()` in `mm/vmalloc.c` (same
args except GFP). No new uAPI. `vfree()` already drops the pages, so no
extra unaccount helper (unlike rejected v2 `mm_account_pinned_pages`).

Regression risk: AF_XDP in a **tight memcg** can now get `-ENOMEM` where
it previously escaped the limit. That is the intended isolation. No
lock/API/lifetime change.

Stanislav noted dislike of open-coding `__vmalloc_node_range`; same
pattern already used for mmapable BPF maps after
`vmalloc_user_node_flags` was removed. Acceptable.

Record: `[minimal, matches vmalloc_user] [low regression risk; memcg
ENOMEM is intended]`

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

- Ring helper/mmap: `423f38329d267` (2018, Magnus Karlsson) — “xsk: add
  umem fill queue support and mmap”
- `vmalloc_user` switch: `9f78bf330a66c` (2023, Xuan Zhuo) — “xsk:
  support use vaddr as ring”
- Overflow guard: `a12bbb3cccf03` (2023)

Buggy missing accounting dates to the original mmapable queue (2018).
`vmalloc_user` only changed the allocator.

Record: `[introduced conceptually in 423f38329d267 (v4.18-era);
vmalloc_user since 9f78bf330a66c / v6.3]`

**Step 3.2: FOLLOW THE FIXES: TAG**

`423f38329d267` **is an ancestor of this HEAD** (`git merge-base --is-
ancestor` exit 0). Original code used `__get_free_pages`; accounting was
missing then too.

Record: `[Fixes target in this tree] [no later in-tree substitute for
ring memcg charge]`

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Recent `net/xdp/xsk_queue.c`: overflow check, vmalloc conversion, header
moves. No existing memcg/optmem/RLIMIT charge on rings.

Series history (mailing list): v1 optmem + socket lifetime coupling; v2
RLIMIT_MEMLOCK; **v3 is standalone 1/1** memcg-only.

Record: `[standalone v3; no in-tree prereq refactor]`

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Zihan Xi is not an XDP maintainer. Reviewer Stanislav Fomichev is a
regular XDP/BPF reviewer and Acked v3. Applied by Jakub Kicinski.

Record: `[author: reporter/fixer; reviewer: subsystem regular;
maintainer applied]`

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Needs `__vmalloc_node_range`, `SHMLBA`, `VM_USERMAP`,
`GFP_KERNEL_ACCOUNT`. All present in 6.12.

Local `xskq_create` uses `kzalloc(sizeof(*q), GFP_KERNEL)` vs mainline
`kzalloc_obj(*q)` — **not in the changed hunks**. Functional diff
applies.

Record: `[no functional dependencies] [applies standalone with trivial
context]`

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

`b4 dig -c <msgid>` could not match a local commit (patch not in this
tree). `b4 mbox` retrieved the 4-message thread.

- Cover: https://lists.openwall.net/netdev/2026/07/31/395
- Patch: https://lists.openwall.net/netdev/2026/07/31/392
- Review: https://lists.openwall.net/netdev/2026/07/31/437

v1 optmem, v2 RLIMIT_MEMLOCK, v3 memcg. Applied version is v3 (latest).
No NAK. Stanislav Acked. Patchwork-bot accepted it.

Author nominated `Cc: stable` on v3. Reviewer did not object.

Record: `[lore msgid 20260731164623.4694-2] [v1→v3, v3 applied] [Ack, no
NAK] [author Cc:stable]`

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

To/Cc: netdev, bpf, Magnus Karlsson, Maciej Fijalkowski, Stanislav
Fomichev, davem, edumazet, pabeni, horms, ast, daniel, hawk,
john.fastabend.

Stanislav reviewed v2 (pushed memcg over RLIMIT_MEMLOCK) and Acked v3.

Record: `[Stanislav Fomichev Ack; XDP maintainers were CC'd]`

**Step 4.3: SEARCH FOR THE BUG REPORT**

Internal report (`Reported-by: Vega`) plus full PoC and panic log on
6.12.95. Trigger: `socket(AF_XDP)` + `setsockopt` with 2^25 entries,
`unshare -Urn`. No syzbot/bugzilla.

Record: `[reproducible OOM/panic on 6.12.95; userns+CAP_NET_RAW]`

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

v3 is 0/1 + 1/1. No extra patches required. v1/v2 approaches were
dropped.

Record: `[self-contained; earlier series versions superseded]`

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

No useful hit on lore.kernel.org/stable for this subject. No recorded
rejection for 6.12.y.

Record: `[no stable-list rejection found]`

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `[xskq_vmalloc_user (new), xskq_create (modified)]`

**Step 5.2: TRACE CALLERS**

`xskq_create` is only called from `xsk_init_queue()` in `net/xdp/xsk.c`,
from `xsk_setsockopt` for the four ring options. Process context,
syscall.

`xsk_create()` requires `ns_capable(net->user_ns, CAP_NET_RAW)` —
**available to an unprivileged user inside a user namespace**.

Record: `[setsockopt path; userns CAP_NET_RAW]`

**Step 5.3: TRACE CALLEES**

`__vmalloc_node_range` → page alloc with GFP; `vfree` on destroy. No new
locks.

Record: `[vmalloc/vfree only]`

**Step 5.4: FOLLOW THE CALL CHAIN**

`socket(AF_XDP)` → `setsockopt(SOL_XDP, XDP_*_RING, &entries)` →
`xskq_create`.

`xsk_init_queue` only checks `entries != 0`, power of two, and queue not
already set. **No upper bound.** `xdp_desc` is 16 bytes; 2^25 entries ≈
512 MiB per RX/TX ring (fill/completion similar with `u64` descs). Eight
sockets × four rings is multi-GB kernel vmalloc.

Reachable from userspace: **yes**.

Record: `[userspace-reachable unbounded vmalloc]`

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

UMEM pages are charged via `user->locked_vm`
(`xdp_umem_unaccount_pages`). BPF mmapable maps use
`__vmalloc_node_range` with accounting flags. Rings were the hole.

`vmalloc_user()` elsewhere (kcov, perf, videobuf) is a separate
question; this patch only fixes AF_XDP.

Record: `[UMEM already bounded; rings were not; BPF already accounts
mmapable vmalloc]`

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Yes. `net/xdp/xsk_queue.c:49` is `q->ring = vmalloc_user(size);`. `make
kernelversion` = **6.12.111**. Repro log is 6.12.95. `423f38329d267` and
`9f78bf330a66c` are ancestors. No `xskq_vmalloc_user` /
`GFP_KERNEL_ACCOUNT` in `net/xdp`.

Record: `[buggy code present; bug since 2018 / vmalloc path since ~6.3]`

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Expected apply: **clean / trivial context**. Only surrounding difference
is `kzalloc` vs `kzalloc_obj`. `asm/shmparam.h` exists
(`arch/x86/include/asm/shmparam.h`, `include/asm-generic/shmparam.h`).
`__vmalloc_node_range` macro exists in `include/linux/vmalloc.h`.

Record: `[clean apply or one-hunk context tweak]`

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

No memcg/optmem/RLIMIT accounting on ring create in this tree.

Record: `[no substitute fix present]`

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

`net/xdp` — AF_XDP. Config: `CONFIG_XDP_SOCKETS` (depends on
`BPF_SYSCALL`, default n).

Criticality: **IMPORTANT** (not core mm/VFS). Used for high-performance
networking; also a userns attack surface when enabled.

Record: `[net/xdp AF_XDP] [IMPORTANT]`

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Mature since 2018; ongoing XDP work. This is an old hole, not a bug in
brand-new code.

Record: `[mature; hole is long-standing]`

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Config-specific (`CONFIG_XDP_SOCKETS`) plus anyone who can create AF_XDP
sockets. Isolation impact is highest for **containers / memcg-limited
workloads** on LTS kernels.

Record: `[config-specific AF_XDP; high impact for cgroup/container
hosts]`

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

`setsockopt` of a large power-of-two ring. No bind, no traffic.
Unprivileged in a user ns with `CAP_NET_RAW`. Easy and deterministic.

Caveat (verified from author): **without a memcg limit**,
`GFP_KERNEL_ACCOUNT` does not stop global OOM (`CONSTRAINT_NONE` in
their prototype). Enforcement is cgroup memory policy.

Record: `[easy syscall trigger] [fix enforces memcg, not a global hard
cap]`

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

- With memcg limits (typical k8s/LTS): bypass of memory.max / kmem →
  **container isolation hole** (HIGH/CRITICAL for multi-tenant)
- With panic_on_oom: **kernel panic** (CRITICAL in that config)
- Without memcg limits: still global OOM killer after the patch

Record: `[memcg bypass + OOM] [HIGH; CRITICAL under panic_on_oom /
multi-tenant]`

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Benefit: closes documented-required kmem accounting; lets existing
cgroup limits constrain a userspace-triggered multi-hundred-MB vmalloc;
matches BPF-style mmapable alloc policy.

Risk: ~12 lines, GFP flag only, one file. Possible `-ENOMEM` for
oversized rings inside a small memcg — correct.

Record: `[benefit high for container/LTS] [risk very low] [favorable]`

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, documented policy violation: untrusted userspace alloc without
  `__GFP_ACCOUNT`
- Concrete PoC and panic on **6.12.95**, this series
- Reachable via userns `CAP_NET_RAW` + `setsockopt`, no bind needed
- Unbounded ring size (power-of-two only)
- Small, obviously equivalent to `vmalloc_user` + account flag
- APIs and buggy code exist in this 6.12.111 tree
- Acked by Stanislav Fomichev; applied by Jakub Kicinski
- Standalone (v3 dropped optmem/RLIMIT machinery)
- UMEM already resource-bounded; rings were the gap
- Author asked for stable; reviewer did not object

AGAINST:
- Does **not** by itself stop global OOM if there is no memcg limit
  (author confirmed)
- `CONFIG_XDP_SOCKETS` is not default-on
- Open-codes `__vmalloc_node_range` (reviewer accepted)
- Can change success/failure of huge rings inside tight memcgs

UNRESOLVED:
- Exact mainline SHA of the applied commit (not in this checkout; thread
  was retrieved by msgid)
- No stable-list discussion found

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — same vmalloc path as
   `vmalloc_user`; PoC/discussion; maintainer Ack
2. Fixes a real bug that affects users? **PASS** — missing kmem charge;
   OOM/isolation on 6.12
3. Important issue? **PASS** — memcg isolation hole and OOM
   (panic_on_oom in the report)
4. Small and contained? **PASS** — one file, ~12 lines
5. No new features or APIs? **PASS** — GFP flag only, not a new uAPI
6. Can apply to the local tree? **PASS** — code and helpers present

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Not a device-ID/quirk/DT/docs exception. Ordinary resource-accounting
bug fix.

Record: `[no exception category; qualifies on primary rules]`

**Step 9.4: MAKE YOUR DECISION**

This is a small, correct fix for a userspace-reachable hole that this
6.12 tree still has. LTS hosts that run AF_XDP and cgroups (containers)
need the charge so memory.max actually applies. Incomplete as a *global*
OOM cap is not a reason to keep rings unaccounted; kernel policy already
requires `__GFP_ACCOUNT`, and that is exactly what this patch adds.

===============================================================
DETAILED EXPLANATION
===============================================================

**Problem:** `xskq_create()` backs AF_XDP rings with `vmalloc_user()`
(`GFP_KERNEL`). `setsockopt()` can request an arbitrary power-of-two
entry count with no memcg charge. In a user namespace that grant
`CAP_NET_RAW`, that is a large, long-lived kernel allocation that
bypasses cgroup kmem limits. The report includes a panic on 6.12.95
under `panic_on_oom`.

**Why it matters here:** This checkout is 6.12.111; the `vmalloc_user()`
call is still present. 6.12.y is an LTS line used with cgroups. Charging
the pages is what makes existing memory limits apply to this path.

**Rules:** Surgical, no new API, no series prereq, applies with at most
trivial `kzalloc` context. Reviewer-directed design (memcg, not
optmem/RLIMIT).

**Risk vs benefit:** Benefit is isolation/OOM under memcg; risk is a GFP
flag on one alloc. `vfree()` already releases pages. The remaining gap
(no memcg → still global OOM) is a property of memcg, not a reason to
skip the charge.

**Concerns:** Incomplete without cgroup limits; XDP sockets are
optional. Neither outweighs backporting the accounting the kernel
already requires for untrusted userspace allocations.

===============================================================
Verification:
===============================================================
- [Phase 1] Parsed subject/body/tags from the candidate message;
  mailing-list v3 also had Fixes: 423f38329d26, Cc: stable, Reported-by:
  Vega
- [Phase 2] Diff is one file: helper wrapping `__vmalloc_node_range`
  with `GFP_KERNEL_ACCOUNT | __GFP_ZERO`, VM_USERMAP, SHMLBA — compared
  to `vmalloc_user_noprof()` in mm/vmalloc.c:4063-4068
- [Phase 2] Confirmed `GFP_KERNEL_ACCOUNT` is `GFP_KERNEL |
  __GFP_ACCOUNT` in include/linux/gfp_types.h:379
- [Phase 2] Confirmed vmalloc honors `__GFP_ACCOUNT` in
  mm/vmalloc.c:3734-3738
- [Phase 3] `git blame net/xdp/xsk_queue.c`: vmalloc_user from
  9f78bf330a66c; helper from 423f38329d267
- [Phase 3] `git merge-base --is-ancestor 423f38329d267 HEAD` → 0;
  `9f78bf330a66c` → 0
- [Phase 3] `git log --oneline -20 -- net/xdp/xsk_queue.c`: no memcg
  accounting already present
- [Phase 3] No `GFP_KERNEL_ACCOUNT` under net/xdp in this tree
- [Phase 4] `b4 dig -c <msgid>`: no local commit match; `b4 mbox` saved
  4-message thread
- [Phase 4] Thread: v3 patch, Stanislav Ack, patchwork-bot, cover
  letter; no NAK
- [Phase 4] Openwall cover+review: PoC, 6.12.95 panic, memcg vs RLIMIT
  debate
- [Phase 4] WebSearch of lore.kernel.org/stable: no rejection thread
  found (UNVERIFIED: lore search 403 on some URLs)
- [Phase 5] Callers: only `xsk_init_queue` ← `xsk_setsockopt` for four
  ring optnames
- [Phase 5] `xsk_create`: `ns_capable(net->user_ns, CAP_NET_RAW)` at
  net/xdp/xsk.c:1742
- [Phase 5] `xsk_init_queue`: no max entries, only power-of-two
  (net/xdp/xsk.c:1061-1062)
- [Phase 5] `struct xdp_desc` is 16 bytes
  (include/uapi/linux/if_xdp.h:155-159)
- [Phase 6] `git describe HEAD` → p-6.12-2-gd38d58a4e0359; `make
  kernelversion` → 6.12.111
- [Phase 6] Current file still has `q->ring = vmalloc_user(size)` at
  line 49
- [Phase 6] `__vmalloc_node_range` and `asm/shmparam.h` exist in this
  tree
- [Phase 7] CONFIG_XDP_SOCKETS in net/xdp/Kconfig, default n, depends on
  BPF_SYSCALL
- [Phase 8] UMEM uses locked_vm in xdp_umem.c; rings do not
- [Phase 8] Documentation/core-api/memory-allocation.rst:53-56 requires
  __GFP_ACCOUNT for untrusted userspace allocs
- UNVERIFIED: mainline commit SHA (patch not in this checkout)
- UNVERIFIED: whether a later mainline follow-up added a hard ring-size
  cap (not in this tree)

The patch is a small, correct memcg charge for a userspace-reachable
AF_XDP allocation that this 6.12 tree still leaves unaccounted.

**YES**

 net/xdp/xsk_queue.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk_queue.c b/net/xdp/xsk_queue.c
index d2c2640300171..7069830943ea8 100644
--- a/net/xdp/xsk_queue.c
+++ b/net/xdp/xsk_queue.c
@@ -9,6 +9,8 @@
 #include <linux/vmalloc.h>
 #include <net/xdp_sock_drv.h>
 
+#include <asm/shmparam.h>
+
 #include "xsk_queue.h"
 
 static size_t xskq_get_ring_size(struct xsk_queue *q, bool umem_queue)
@@ -21,6 +23,14 @@ static size_t xskq_get_ring_size(struct xsk_queue *q, bool umem_queue)
 	return struct_size(rxtx_ring, desc, q->nentries);
 }
 
+static void *xskq_vmalloc_user(unsigned long size)
+{
+	return __vmalloc_node_range(size, SHMLBA, VMALLOC_START, VMALLOC_END,
+				     GFP_KERNEL_ACCOUNT | __GFP_ZERO, PAGE_KERNEL,
+				     VM_USERMAP, NUMA_NO_NODE,
+				     __builtin_return_address(0));
+}
+
 struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
 {
 	struct xsk_queue *q;
@@ -46,7 +56,7 @@ struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
 
 	size = PAGE_ALIGN(size);
 
-	q->ring = vmalloc_user(size);
+	q->ring = xskq_vmalloc_user(size);
 	if (!q->ring) {
 		kfree(q);
 		return NULL;
-- 
2.53.0

