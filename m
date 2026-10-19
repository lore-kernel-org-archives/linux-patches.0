Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8311C5586E4;
	Mon, 19 Oct 2026 13:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418230; cv=none; b=Zo9X6OT/Faz/pUQb7g1wtPa6/g6+rkrskdkXWuLPhzPmZpTR/y5ItnDkalloVMUEe6zNrNp6NcwXrX4Ln3CkkA3WgNRdrMkXOQBnKZfkgiFogP9KvJ2HrQ+N5hTqdBMF61aGgzNEYu3aGOmMLOTBve+SMnHBDbwI2m52v/5hyYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418230; c=relaxed/simple;
	bh=SCEIpo3ag9euaCtixW5igfDR6iGxfBzuufmmCTw0c0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PubCF9oZkoo8sU+F+coW2+nVwtjI/Z2DP+wk4J+NayF1cIoT6M+sow+a7OV3UMp1OHeFjA8F9o0w88egAO3R7zVUpbulF+bYGUkhjUXfZYLaY8n4fcJZGMUbBJw6lUXWw/HmKVYjUJ2PRgR3MD758n+dbOTNxVLDCsyXcKXk388=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjXidz9M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjXidz9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198EB1F000C5;
	Mon, 19 Oct 2026 13:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418227;
	bh=Tsa+O50cD+IE1OIK+QCJ95up2t7XPcqoYagvI7nqtjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HjXidz9Mae+0I7CSQ/bRyzQOeNNqQYthFS1Myr/9q/GH3y3LN9tVelpZHNK8CGOSt
	 1IlmviB+7/GJ5PhNz8wjENcZi555qp4iBEgy3BeA3PAI3IJBfhvht+ZPJMKzFFkBj4
	 c6mSXtktj4WA64vNUHoYHrZSa6Z4V2iI3c65nXb5OnWd6GIWkezTl62LTfMR7n4Ak1
	 KdfK5b6LSqGIBB3ftkqhf/Duk9UsINQtVvQVu7FfDCSrO+W8Yag/yQBNaGjraWmrpN
	 mNyKxfaUhbyeOh725/AEf/kipf5MkFPGN+eXOR7B+t/9dHIC0hYDL8p4fmKdxInWZ4
	 36T7losJO4+cQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vladimir Murzin <vladimir.murzin@arm.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>,
	chunfeng.yun@mediatek.com,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] usb: mtu3: Fix double dereference in TP_printk
Date: Mon, 19 Oct 2026 09:46:33 -0400
Message-ID: <20261019135441.1420968-102-sashal@kernel.org>
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

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit cfb3293c4573289f11f913611f530ea6b1926d67 ]

Paul reported kernel splat:

[    0.000000] TRACE EVENT ERROR: Event mtu3_gadget_ep_set_halt has double dereference in TP_printk: &REC->gpd_ring->dma
[    0.000000] ------------[ cut here ]------------
[    0.000000] Event mtu3_gadget_ep_set_halt has double dereference in TP_printk: &REC->gpd_ring->dma
[    0.000000] WARNING: kernel/trace/trace_events.c:420 at test_double_dereference+0x144/0x14c, CPU#0: swapper/0/0
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.3.0-rc1 #15247 PREEMPT
[    0.000000] Hardware name: linux,dummy-virt (DT)
[    0.000000] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.000000] pc : test_double_dereference+0x144/0x14c
[    0.000000] lr : test_double_dereference+0x144/0x14c
[    0.000000] sp : ffffc80aa7633bf0
[    0.000000] x29: ffffc80aa7633bf0 x28: ffffc80aa7c0f047 x27: 000508b58019388f
[    0.000000] x26: 0000000000000003 x25: 0000000000000007 x24: ffffc80aa5fceff8
[    0.000000] x23: ffffc80aa7c0f05a x22: ffffc80aa64edfe8 x21: ffffc80aa7c0fce8
[    0.000000] x20: ffffc80aa7c0f047 x19: 0000000000000013 x18: 0000000000000001
[    0.000000] x17: 6572656420656c62 x16: 756f642073616820 x15: 746c61685f746573
[    0.000000] x14: 0000000000000000 x13: ffff000139d90000 x12: 0000000000000045
[    0.000000] x11: 00000000000000cf x10: ffff00013f546428 x9 : ffff000139d90000
[    0.000000] x8 : 3fffffffffffc000 x7 : 0000000000000001 x6 : 0000000000000001
[    0.000000] x5 : ffff00013f4e6440 x4 : 0000000000000000 x3 : 0000000000000000
[    0.000000] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffffc80aa764a700
[    0.000000] Call trace:
[    0.000000]  test_double_dereference+0x144/0x14c (P)
[    0.000000]  trace_event_raw_init+0x37c/0x5d8
[    0.000000]  event_init+0x34/0xc0
[    0.000000]  trace_event_init+0xec/0x588
[    0.000000]  trace_init+0x24/0x6e0
[    0.000000]  start_kernel+0x4a0/0x8ec
[    0.000000]  __primary_switched+0x88/0x90
[    0.000000] irq event stamp: 0
[    0.000000] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[    0.000000] hardirqs last disabled at (0): [<0000000000000000>] 0x0
[    0.000000] softirqs last  enabled at (0): [<0000000000000000>] 0x0
[    0.000000] softirqs last disabled at (0): [<0000000000000000>] 0x0
[    0.000000] ---[ end trace 0000000000000000 ]---
[    0.000000] TRACE EVENT ERROR: Event mtu3_gadget_ep_disable has double dereference in TP_printk: &REC->gpd_ring->dma
[    0.000000] TRACE EVENT ERROR: Event mtu3_gadget_ep_enable has double dereference in TP_printk: &REC->gpd_ring->dma

Which also observed by Mark and myself.

The splat it result of new check introduced by b5cc230af5e5 ("tracing:
Warn when an event dereferences a pointer in TP_printk()") which
correctly catches issue with %pad dereferencing the address saved in
the ring buffer. TP_fast_assign() logic gets executed when the
tracepoint is triggered, however the TP_printk() is executed when the
user reads the trace buffer which could be seconds, minutes, hours,
days, even months later and nothing guarantee that __entry->gpd_ring
pointer will still be pointing to what it was when it was recorded.

Fix the issue by capturing immediate value of gpd_ring.dma when trace
point is triggered.

Reported-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: **[usb/mtu3]** **[Fix]** Double dereference in `TP_printk` for
the `mtu3_log_ep` trace class
(`mtu3_gadget_ep_enable/disable/set_halt`).

**Step 1.2: Tags**
Record:
- **Reported-by:** Paul E. McKenney
- **Tested-by:** Mark Rutland
- **Reviewed-by:** Steven Rostedt (tracing maintainer)
- **Signed-off-by:** Vladimir Murzin (author); Paul E. McKenney (merged
  via his tree)
- **No Fixes:** tag (expected for this review)
- **No Cc: stable** (expected)
- No syzbot, no CVE, no bugzilla Link
- Ignore pipeline “Upstream commit” / Sasha Levin SOB

Notable: three independent observers (Paul, Mark, the author). Rostedt
reviewed it.

**Step 1.3: Body**
Record:
- **Bug:** `TP_printk` uses `%pad` with `&REC->gpd_ring->dma`, i.e. it
  follows a pointer stored in the ring buffer when the trace is printed,
  not when it is recorded.
- **Symptom that motivated the patch:** boot `WARNING` in
  `test_double_dereference()` on 7.3.0-rc1 (`linux,dummy-virt`), events
  `mtu3_gadget_ep_set_halt/disable/enable`.
- **Root cause (author):** check added by `b5cc230af5e5` (“tracing: Warn
  when an event dereferences a pointer in TP_printk()”).
  `TP_fast_assign()` runs at the tracepoint; `TP_printk()` can run much
  later, when `__entry->gpd_ring` may be stale.
- **Fix:** snapshot `mep->gpd_ring.dma` into a `dma_addr_t` field at
  assign time and print `&__entry->gpd_ring_dma`.
- **Versions in the message:** 7.3.0-rc1 only. Mailing list later says
  the splat was still present in 7.3-rc5/rc6.

Linus’s merge of `8fc6e594884a` describes the same bug as pre-existing:
it can dump garbage traces because `TP_printk()` may run after the
pointed-to memory is gone. Extra tracing checks only **exposed** it.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. It is an explicit tracing UAF/stale-pointer fix. The
boot WARN is how it was found; the real defect is delayed dereference of
a saved kernel pointer.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/usb/mtu3/mtu3_trace.h` only (+3 / −1; 4-line class)
- Function/class: `DECLARE_EVENT_CLASS(mtu3_log_ep)` (shared by
  `mtu3_gadget_ep_enable`, `mtu3_gadget_ep_disable`,
  `mtu3_gadget_ep_set_halt`)
- Scope: single-file surgical tracing fix

**Step 2.2: Code flow**
Record: **Before:** `TP_fast_assign` stores `__entry->gpd_ring =
&mep->gpd_ring`. `TP_printk` prints `%p/%pad` with `__entry->gpd_ring,
&__entry->gpd_ring->dma`. **After:** also stores `__entry->gpd_ring_dma
= mep->gpd_ring.dma` and prints `&__entry->gpd_ring_dma`. Affected path
is trace **print**, not gadget I/O.

Verified in this tree’s `lib/vsprintf.c` `address_val()`: `%pad` does
`*(const dma_addr_t *)addr`. The old argument therefore both follows
`gpd_ring` and then dereferences `.dma`.

**Step 2.3: Bug mechanism**
Record: **Memory safety / delayed pointer dereference in tracing (UAF or
garbage).** `%p` of the saved pointer is safe; `%pad` is not. `gpd_ring`
is embedded in `struct mtu3_ep` (`mtu3.h`). `mtu3_gpd_ring_free()`
`memset`s the ring on disable; the `mtu3_ep` itself is freed on unbind.
Reading traces after unbind is a use-after-free. Reading after disable
but before unbind can print a later (zeroed) DMA address instead of the
recorded one.

**Step 2.4: Fix quality**
Record: Obviously correct and minimal. `%pad` still gets a `dma_addr_t
*`, now into the ring-buffer entry. The missing semicolon on the new
assign is harmless: `TP_fast_assign` is expanded with a trailing `;`. No
API/locking/hot-path change. Regression risk is very low. The leftover
`__field(struct mtu3_gpd_ring *, gpd_ring)` is still only printed with
`%p`.

---

## Phase 3: Git history

**Step 3.1: Blame**
Record: Buggy `mtu3_log_ep` pattern comes from `83374e035b628` (“usb:
mtu3: add tracepoints to help debug”, Chunfeng Yun, 2019-03-21). Present
in this tree (`git merge-base --is-ancestor 83374e035b628 HEAD`
succeeded). Long-lived, not recent code.

**Step 3.2: Fixes: tag**
Record: None on the merged commit. An earlier unused submission
(Shixiong Ou, 2026-08-28) tagged `Fixes: 83374e035b62`. That introducing
commit **is** in this tree.

**Step 3.3: File history**
Record (path-limited log):
- `83374e035b628` add tracepoints
- later style/`__vstring`/`__assign_str` churn
- this fix

Standalone; not patch X/Y. No prerequisite refactor in this file beyond
what 6.18 already has (`__assign_str(name)` without a second argument is
already here).

**Step 3.4: Author**
Record: Vladimir Murzin is not the mtu3 maintainer (that is Chunfeng
Yun, CC’d). He is an ARM engineer fixing a splat he, Paul, and Mark hit.
Rostedt reviewed. Paul merged it when USB maintainers were slow (splat
still in 7.3-rc6).

**Step 3.5: Dependencies**
Record: None. Uses existing `dma_addr_t`, `TP_*`, and
`mep->gpd_ring.dma`. No new tracing helpers. `b5cc230af5e5` is the
detector, **not** a prerequisite for the fix.

---

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
Record:
- `b4 dig -c cfb3293c4573289f11f913611f530ea6b1926d67` → https://patch.m
  sgid.link/20260922103756.104846-1-vladimir.murzin@arm.com
- `b4 dig -a`: single revision (v1 only)
- Thread: ping for 7.3-rc5/rc6 splat; Paul offered to merge because the
  WARN broke his tests; later merged and Linus pulled it
- No NAK. No reviewer asked for `Cc: stable`
- lore.kernel.org fetch returned 403; thread recovered via `b4 dig -m`

**Step 4.2: Recipients (`b4 dig -w`)**
Record: linux-usb, linux-arm-kernel, linux-mediatek, linux-kernel,
Chunfeng Yun, Greg KH, Steven Rostedt, Paul McKenney, Mark Rutland.
Right lists and maintainers.

**Step 4.3: Bug report**
Record: Reproduced by Paul, Mark, and Vladimir on 7.3-rc1+ (dummy-virt).
Independent earlier patch from Shixiong Ou describes the same WARN and
the same stale-pointer/UAF. Severity for **those** kernels is a boot
WARN whenever `CONFIG_USB_MTU3` is built. That WARN is **not** in
6.18.y.

**Step 4.4: Series**
Record: Standalone. Duplicate independently submitted by Shixiong Ou
(same approach, field named `gpd_dma`). Murzin’s version is what merged.

**Step 4.5: Stable list**
Record: No useful hit on lore stable for this subject. Not a documented
“do not backport.”

---

## Phase 5: Semantic / call graph

**Step 5.1: Functions**
Record: `mtu3_log_ep` class; events `mtu3_gadget_ep_enable`,
`mtu3_gadget_ep_disable`, `mtu3_gadget_ep_set_halt`.

**Step 5.2: Callers**
Record (this tree):
- `mtu3_gadget_ep_enable()` — `drivers/usb/mtu3/mtu3_gadget.c:202`
- `mtu3_gadget_ep_disable()` — line 214 (before `mtu3_ep_disable()` /
  `mtu3_gpd_ring_free()`)
- `mtu3_gadget_ep_set_halt()` — line 404

These are USB gadget ep ops: enable/disable/halt from gadget drivers /
configfs. Common on MediaTek gadget/OTG, not a syscall of its own.

**Step 5.3: Callees**
Record: TRACE_EVENT assign/print only. No alloc/lock/I/O in the changed
code. `%pad` → `address_val()` → dereference `dma_addr_t *`.

**Step 5.4: Reachability**
Record: Recording: gadget ep enable/disable/halt with these events on.
Printing: reading the trace buffer. UAF: print after `mtu3_ep` is freed
(driver unbind). Boot WARN: only if `test_double_dereference()` exists
(it does not here). Unprivileged users normally cannot enable tracefs.

**Step 5.5: Similar patterns**
Record: Other mtu3 events print saved pointers with `%p` only (safe).
Same class already in this 6.18.y tree: `0b0d2f9db2406` (“eth: ice:
don't dereference pointers from TP_printk()”), also written against
`b5cc230af5e5`, and it **is** an ancestor of `v6.18.57`.

---

## Phase 6: This checkout only

**Step 6.1: Does the buggy code exist?**
Record: **Yes, in v6.18.57.** `git describe HEAD` →
`v6.18.57-155-gcdf239ca885b2`; `make kernelversion` → **6.18.57**.
v6.18.57 `mtu3_trace.h` still has `__entry->gpd_ring,
&__entry->gpd_ring->dma`. Introduced 2019. `git merge-base --is-ancestor
dff6c93cf7131 v6.18.57` failed (fix not in 6.18.57).
`test_double_dereference` is **absent** from `kernel/trace/`
(`b5cc230af5e5` is not an ancestor of HEAD).

**Step 6.2: Backport difficulty**
Record: **Clean apply.** `git diff v6.18.57 dff6c93cf7131 --
drivers/usb/mtu3/mtu3_trace.h` is exactly this 4-line change. Context
matches 6.18 (`__assign_str(name)` already present).

**Step 6.3: Related fix already here?**
Record: No other mtu3 `TP_printk` fix in `v6.18..v6.18.57`. The ice
analogue **is** already in 6.18.57. That does not replace this mtu3 bug.

---

## Phase 7: Subsystem context

**Step 7.1**
Record: **drivers/usb/mtu3** — MediaTek USB3 dual-role. Criticality:
**PERIPHERAL/IMPORTANT for MTK** (`CONFIG_USB_MTU3`, `depends on
ARCH_MEDIATEK || COMPILE_TEST`). Tracepoints compiled with the driver
when `CONFIG_TRACEPOINTS` is on.

**Step 7.2**
Record: Mature driver (tracepoints since 2019). Recent 6.18.y mtu3 fixes
include DMA unmap on queue failure and suspend-with-gadget. Not staging.

---

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: MediaTek USB3 gadget users who enable these ftrace events and
later print the buffer. Distro kernels that build mtu3 for
`COMPILE_TEST` do **not** get the 7.3 boot WARN here, because that check
is missing.

**Step 8.2: Trigger**
Record: Not every boot on 6.18.y. Needs `CONFIG_USB_MTU3` + tracepoints
+ enable these events + later print. UAF additionally needs the
endpoint/device object to have been freed. Not unprivileged. The 7.3
boot WARN fires even on dummy-virt; **that path does not exist in this
tree**.

**Step 8.3: Failure mode**
Record:
- On 7.3+: boot `WARNING` — **does not apply to 6.18.57**
- On this tree: delayed deref → **garbage DMA address in traces**, or
  **UAF/oops** if `mtu3_ep` was freed — severity **HIGH** when hit,
  **MEDIUM** overall because the trigger is a debug path

**Step 8.4: Risk vs benefit**
Record: **Benefit:** closes a real stale-pointer/UAF in mtu3 gadget
traces; same class already taken for ice on this series. **Risk:** very
low (3 insertions, print-time only). Ratio favors backport.

---

## Phase 9: Synthesis

**Step 9.1: Evidence**

For:
- Real delayed dereference of a kernel pointer from the trace buffer
  (`%pad` confirmed to dereference)
- Buggy code present in this 6.18.y tree since 2019
- Small, obviously correct, applies cleanly
- Reviewed by Rostedt; reported/tested by McKenney and Rutland
- Same class (`TP_printk` must not follow saved pointers) already in
  v6.18.57 for ice
- No new API/feature; no series dependency

Against:
- The boot splat that drove the patch **cannot happen here**
  (`test_double_dereference` / `b5cc230af5e5` not in 6.18.y)
- Debug/tracing path, MediaTek-specific, needs events enabled
- Failure is often wrong trace text rather than a production USB failure
- No `Cc: stable` in review (not a negative per the rules)

Unresolved: lore.kernel.org HTTP 403 (thread read from `b4` mbox
instead).

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** (Rostedt Reviewed-by, Mark
   Tested-by, logic is local)
2. Real bug that affects users? **PASS** (stale pointer / UAF when
   traces are printed)
3. Important (crash/security/corruption/deadlock)? **PASS** (UAF/oops
   possible on print after free; garbage traces otherwise). The 7.3 boot
   WARN is not the important part **for this tree**.
4. Small and contained? **PASS** (one header, 4 lines)
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** (clean vs v6.18.57)

**Step 9.3: Exception category**
Record: None (not a device ID/quirk/DT/build/docs exception). It is a
normal small bugfix.

**Step 9.4: Decision**
The 7.3 boot WARN is not a reason to take this on 6.18.y. The reason to
take it is the pre-existing `TP_printk` dereference, which **is** in
this tree, is a real UAF/garbage-print bug, is a 4-line no-brainer, and
matches a fix this series already accepted for ice.

---

## What this means for 6.18.y users

`mtu3_log_ep` stores `&mep->gpd_ring` and later does `%pad` on
`&gpd_ring->dma`. Print can happen long after disable/unbind. That is a
real bug in this tree. The patch only snapshots `gpd_ring.dma` at event
time. It does not change gadget behavior.

## Verification

- **[Phase 1]** Parsed tags: Reported-by Paul McKenney, Tested-by Mark
  Rutland, Reviewed-by Steven Rostedt; no Fixes/Cc-stable
- **[Phase 2]** Diff: +`gpd_ring_dma` field, assign `mep->gpd_ring.dma`,
  print `&__entry->gpd_ring_dma`
- **[Phase 2]** `%pad` in `lib/vsprintf.c` `address_val()`: `num =
  *(const dma_addr_t *)addr`
- **[Phase 2]** `struct mtu3_ep` has embedded `struct mtu3_gpd_ring
  gpd_ring`; `mtu3_gpd_ring_free()` memsets it
- **[Phase 3]** Blame: `83374e035b628` (2019) introduced the pattern;
  ancestor of HEAD
- **[Phase 3]** `git merge-base --is-ancestor b5cc230af5e5 HEAD` failed;
  no `test_double_dereference` in this tree
- **[Phase 3]** Author log on `drivers/usb/`: this commit plus unrelated
  xhci work
- **[Phase 4]** `b4 dig -c cfb3293c4573`: msgid
  `20260922103756.104846-1-vladimir.murzin@arm.com`; v1 only
- **[Phase 4]** `b4 dig -w`: USB/Mediatek lists, Greg KH, Chunfeng Yun,
  Rostedt
- **[Phase 4]** mbox: Paul merged after 7.3-rc5/rc6 pings; no NAK; no
  stable nomination
- **[Phase 4]** UNVERIFIED: live lore.kernel.org page (403)
- **[Phase 5]** Callers: `mtu3_gadget_ep_enable/disable/set_halt` in
  `mtu3_gadget.c`
- **[Phase 6]** `git describe HEAD` = v6.18.57-155-gcdf239ca885b2;
  kernelversion 6.18.57
- **[Phase 6]** v6.18.57 still has `&__entry->gpd_ring->dma`; fix not an
  ancestor of v6.18.57
- **[Phase 6]** File diff vs v6.18.57 is exactly this patch (clean)
- **[Phase 6]** ice TP_printk analogue `0b0d2f9db2406` **is** in
  v6.18.57
- **[Phase 8]** Boot WARN not reachable here; UAF/garbage on delayed
  print is

The fix is small, correct, already matches this tree’s context, and
closes a real tracing UAF, not a 7.3-only WARN.

**YES**

 drivers/usb/mtu3/mtu3_trace.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/mtu3/mtu3_trace.h b/drivers/usb/mtu3/mtu3_trace.h
index 89870175d6356..9aaa167d69c13 100644
--- a/drivers/usb/mtu3/mtu3_trace.h
+++ b/drivers/usb/mtu3/mtu3_trace.h
@@ -224,6 +224,7 @@ DECLARE_EVENT_CLASS(mtu3_log_ep,
 		__field(unsigned int, flags)
 		__field(unsigned int, direction)
 		__field(struct mtu3_gpd_ring *, gpd_ring)
+		__field(dma_addr_t, gpd_ring_dma)
 	),
 	TP_fast_assign(
 		__assign_str(name);
@@ -235,12 +236,13 @@ DECLARE_EVENT_CLASS(mtu3_log_ep,
 		__entry->flags = mep->flags;
 		__entry->direction = mep->is_in;
 		__entry->gpd_ring = &mep->gpd_ring;
+		__entry->gpd_ring_dma = mep->gpd_ring.dma
 	),
 	TP_printk("%s: type %s maxp %d slot %d mult %d burst %d ring %p/%pad flags %c:%c%c%c:%c",
 		__get_str(name), usb_ep_type_string(__entry->type),
 		__entry->maxp, __entry->slot,
 		__entry->mult, __entry->maxburst,
-		__entry->gpd_ring, &__entry->gpd_ring->dma,
+		__entry->gpd_ring, &__entry->gpd_ring_dma,
 		__entry->flags & MTU3_EP_ENABLED ? 'E' : 'e',
 		__entry->flags & MTU3_EP_STALL ? 'S' : 's',
 		__entry->flags & MTU3_EP_WEDGE ? 'W' : 'w',
-- 
2.53.0

