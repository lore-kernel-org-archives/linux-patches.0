Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7904F472F8E;
	Mon, 31 Aug 2026 13:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183322; cv=none; b=tMjh1WrPvpMGEt2ynFDXaXHZGO9PF1KvdMPLFU0KoBtpRl18ZJB76HDqX1pdG2Gla+PiKn51KQCdWUuWQuOrv8D9xwoOt20ZpjgKAvV67QIO3zmEZpgu9W/t6znGJyfb3noolvJIjxh1586wxJURSB9KS5ee/fOxdnAAjCcx98o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183322; c=relaxed/simple;
	bh=GEfuo7jybmwEdA+J3urxirNsvp1rfz4AJmXJBTtIAd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G+P3GTAkIS2UFvAKD6OaQ/4dMg4ufDV431/pE/nZlId7z/JAcxCyYnibxCTBbLh0XAbAYXyWWsiz9AsYeqzJuv9qZWBOi1QxBpQxCD0YObt40rdvrpszoN5Mp5p0Cbor6oko2ErIBMvLg/qSwBheIiO0BA+R8uEcXdT8y9dXylA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnGn9/cl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnGn9/cl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4290F1F000E9;
	Mon, 31 Aug 2026 13:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183320;
	bh=auyLa4LJUekJJ7/dH68FyslgfszJS2Q1yk4nVhb69iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hnGn9/clEiXtYH8Ezb5RuBMupn5s4X5MEobhDEmTd2NwO6m3b0uKZC47YQZCs32zz
	 bdi65vN8QBuDP6HXslneQWp29htk3Wm8TGAFgmno59uFBj9Cf5zixKC/uxq70dTnRj
	 ZgkwbuYi9t3aUfWddaDYOcZx35+gEeJPOrbsIxqMZ47OiEqzuLGm2739mD41V+rALY
	 V476wiyCVh7c7reKFSNom/S/2p5qcGIvMoVJui04Ah89jKksGQoBt1AmNJApGs1Rzp
	 K+c3jBQlY6F3/2GX0v2Uys06h9UvDTonJAZXoWyeQBkZDsY0BwnGi9dZ4vUfSiBGDv
	 pGQf3j00MSQbw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] usb: xhci: remove legacy 'num_trbs_free' tracking
Date: Mon, 31 Aug 2026 09:21:46 -0400
Message-ID: <20260831133314.4125787-78-sashal@kernel.org>
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

From: Niklas Neronin <niklas.neronin@linux.intel.com>

[ Upstream commit 7ee645963075651d72f8d85bee428a9b7f1f148c ]

Keeping track of free TRBs in a ring by adding and subtracting each time
a enqueue or dequeue pointer is modified has proven to be buggy and
complicated, especially over long periods of time.
The xhci driver has already moved to calculating free TRBs dynamically
based on ring size and the enqueue/dequeue positions.

The DbC path is the last user of 'num_trbs_free'. Rather than maintaining
two separate accounting mechanisms, remove the field entirely and switch
DbC to use xhci_num_trbs_free(). Since 'num_trbs_free' undercounts by one,
and xhci_num_trbs_free() does not, the check for sufficient free TRBs is
adjusted.

Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260603091132.1110849-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[usb: xhci]` `[remove]` — remove legacy `num_trbs_free`
tracking from the xHCI DbC (Debug Capability) path.

**Step 1.2 — Tags**

Record:
- `Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>`
  (author)
- `Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>` (xHCI
  maintainer)
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>` (USB
  maintainer)
- `Link: https://patch.msgid.link/20260603091132.1110849-3-
  mathias.nyman@linux.intel.com`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org`
- Ignore `[Upstream commit ...]` and pipeline `Signed-off-by: Sasha
  Levin` per instructions

Notable: maintainer sign-offs only; no explicit reporter or stable
nomination.

**Step 1.3 — Body**

Record:
- **Bug:** Manual `num_trbs_free` increment/decrement on enqueue/dequeue
  is buggy and drifts over long runtimes.
- **Symptom:** Incorrect free-TRB accounting can cause DbC to believe
  the transfer ring is full and refuse new transfers (`failed to queue
  trbs` in related DbC fixes).
- **Root cause:** DbC was the last user of legacy counter-based
  accounting; the rest of xHCI already uses dynamic
  `xhci_num_trbs_free()`.
- **Fix:** Remove `num_trbs_free` field entirely; DbC uses
  `xhci_num_trbs_free()`. Comparison adjusted from `< num_trbs` to `<=
  num_trbs` because legacy counter undercounted by one.
- **Versions:** No explicit version range in message.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Despite “remove legacy tracking” wording, this fixes
incorrect ring-space accounting — the same class of bug fixed for main
transfer rings in `2710f8186f889` (“Stop unnecessary tracking of free
trbs in a ring”), with a user report and bugzilla for that path.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
| File | Change |
|------|--------|
| `xhci-dbgcap.c` | −4 manual counter ops, +1 dynamic check |
| `xhci-mem.c` | −6 (init of `num_trbs_free`) |
| `xhci-ring.c` | `static` → exported `xhci_num_trbs_free()` |
| `xhci.h` | Remove struct field, add prototype |

- Net: ~12 lines removed, ~3 added
- Functions: `xhci_dbc_queue_trb()`, `xhci_dbc_queue_bulk_tx()`,
  `dbc_handle_xfer_event()`, `xhci_initialize_ring_info()`,
  `xhci_num_trbs_free()`
- Scope: **single-subsystem surgical fix** (xHCI DbC only)

**Step 2.2 — Code flow per hunk**

Record:
1. **`xhci_dbc_queue_trb()`** — Before: decrement `num_trbs_free` on
   enqueue. After: no manual accounting; enqueue pointer only.
2. **`xhci_dbc_queue_bulk_tx()`** — Before: `ring->num_trbs_free <
   num_trbs` → `-EBUSY`. After: `xhci_num_trbs_free(ring) <= num_trbs` →
   `-EBUSY`.
3. **`dbc_handle_xfer_event()`** — Before: `num_trbs_free++` on
   completion and stale-stall giveback. After: no manual increments;
   pointer-based calculation handles it.
4. **`xhci_initialize_ring_info()`** — Before: initialize
   `num_trbs_free`. After: removed.
5. **`xhci_num_trbs_free()`** — Before: `static`. After: non-static +
   header export for DbC use.

**Step 2.3 — Bug mechanism**

Record: **Logic/correctness fix — stale manual counter accounting.**
- Legacy path manually `++`/`--` on queue/complete/stall paths.
- Counter can drift from actual ring state (noop TRBs, stall handling,
  long-lived sessions) — same failure mode fixed on main transfer rings
  in `fe82f16aafda` / `2710f8186f889`.
- Dynamic `xhci_num_trbs_free()` derives free space from enqueue/dequeue
  pointers and ring geometry.

**Step 2.4 — Fix quality**

Record:
- **Obviously correct:** Reuses the same mechanism already used for
  command/transfer rings in this tree.
- **Minimal:** Removes duplicate accounting; no new APIs beyond
  exporting an existing function.
- **Regression risk:** Low. Comparison operator change (`<` → `<=`) is
  documented compensation for the one-TRB undercount in legacy init (`-
  1` in `xhci-mem.c:325`).

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: `num_trbs_free` initialization dates to `b008df60c6369b` (Andiry
Xu, 2012-03-05). Legacy accounting has been present since early xHCI;
main path stopped using it in `2710f8186f889` (2023). DbC retained it
until this commit.

**Step 3.2 — Fixes: tag**

Record: Not applicable — no `Fixes:` tag. Related introducing/fix
commits in tree:
- `2710f8186f889` — main path moved to dynamic calculation (in tree)
- `fe82f16aafda` — original transfer-ring accounting bug (user report,
  Cc: stable)
- `a5c98e8b13985` — DbC ring-full workaround on reconnect (in tree, Cc:
  stable)

**Step 3.3 — Related file history**

Record: Recent DbC fixes in this tree include `a5c98e8b13985` (ring full
after reconnects), `f3d12ec847b94` (stall race), `2bbd38fcd2967`
(resume). This commit is standalone (not “patch X/Y”); `5adc1cc038f44`
(off-by-one in `xhci_num_trbs_free`) is already present. No other series
dependency.

**Step 3.4 — Author context**

Record: Niklas Neronin is an active Intel xHCI contributor
(`931e468764b22`, `ff9a09b3e09c7`, etc.). Mathias Nyman is the xHCI
maintainer and authored the original transfer-ring accounting fix.

**Step 3.5 — Prerequisites**

Record:
- `xhci_num_trbs_free()` exists (static) in `xhci-ring.c:342` —
  **present**
- `2710f8186f889` main-path refactor — **present**
- `5adc1cc038f44` off-by-one fix — **present**
- DbC support (`dfba2174dc42`, 2017) — **present**
- Patch applies cleanly (`git apply --check` passed)
- **Standalone:** yes

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig -c 9e332a74fa0de` → https://patch.msgid.link/20260521080
426.258909-1-niklas.neronin@linux.intel.com. Single-patch submission
(not a multi-revision series). Mbox downloaded; no review replies,
stable nominations, or NAKs in thread.

**Step 4.2 — Reviewers**

Record: `b4 dig -w` shows CC to `mathias.nyman@linux.intel.com` and
`linux-usb@vger.kernel.org`. Mathias Nyman Signed-off-by on committed
version.

**Step 4.3 — Bug reports**

Record: No `Reported-by:` or syzbot link for this commit. Related bug
context from `fe82f16aafda` / bugzilla #217242 applies to the same
accounting mechanism on transfer rings. Related DbC symptom documented
in `a5c98e8b13985`: `"failed to queue trbs"`.

**Step 4.4 — Series context**

Record: Commit Link references `...1110849-3-...` (possibly part of a
3-patch series on a later submission), but the committed diff is self-
contained. No other patches required.

**Step 4.5 — Stable list**

Record: Not searched on lore stable (WebFetch blocked). No stable
nomination in commit or mbox thread. Not a negative signal per
instructions.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `xhci_dbc_queue_bulk_tx()`, `dbc_handle_xfer_event()`,
`xhci_num_trbs_free()`, `dbc_ep_do_queue()`.

**Step 5.2 — Callers**

Record:
- `xhci_dbc_queue_bulk_tx()` ← `dbc_ep_do_queue()` ← `dbc_ep_queue()`
  (TTY/gadget write path)
- `dbc_handle_xfer_event()` ← event polling workqueue in DbC
- `xhci_num_trbs_free()` also used in `xhci-ring.c:3328` for command-
  ring space checks

Impact surface: **CONFIG_USB_XHCI_DBGCAP** users only; not general USB
hot path.

**Step 5.3 — Callees**

Record: `xhci_num_trbs_free()` walks ring segments using `enqueue`,
`dequeue`, `enq_seg`, `deq_seg`. `count_trbs()`, `xhci_dbc_queue_trb()`,
`xhci_dbc_giveback()` on queue/complete paths.

**Step 5.4 — Reachability**

Record: Triggered when DbC is configured and TTY I/O is active over USB3
debug port. Requires `CONFIG_USB_XHCI_DBGCAP=y` and hardware with xHCI
DbC. Not a general syscall path, but reachable by any user with debug-
cable access and DbC enabled.

**Step 5.5 — Similar patterns**

Record: Main xHCI path already uses `xhci_num_trbs_free(ep_ring) <=
num_trbs` at `xhci-ring.c:3328`. This commit aligns DbC with that
pattern and removes the last manual counter user.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is `v6.18.44` / `6.18.44`. Commit
`9e332a74fa0de` is **not** an ancestor of HEAD. Legacy code present at:
- `xhci-dbgcap.c:263,284,785,850`
- `xhci-mem.c:325`
- `xhci.h:1380`

**Step 6.2 — Backport complications**

Record: **Clean apply expected.** `git apply --check` on the patch
succeeded with no conflicts. File structure matches upstream diff
context.

**Step 6.3 — Related fixes already present?**

Record: `a5c98e8b13985` (DbC ring reinit on disconnect) is in tree —
symptom workaround for ring-full case. This commit addresses the
underlying accounting mechanism. The dynamic-calculation infrastructure
(`xhci_num_trbs_free`, `2710f8186f889`) is already in tree. This
specific DbC migration is **not** yet applied.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: **drivers/usb/host (xHCI DbC)** — IMPORTANT for developers using
USB3 debug port; PERIPHERAL for general production workloads (optional
Kconfig, default off).

**Step 7.2 — Activity**

Record: xHCI DbC actively maintained — 10+ DbC commits in recent history
on `xhci-dbgcap.c`.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users with `CONFIG_USB_XHCI_DBGCAP=y` on xHCI hosts with DbC
hardware — kernel developers, early-debug/remote-console setups. Not
universal.

**Step 8.2 — Trigger conditions**

Record:
- Long-running DbC sessions
- Stall/no-op TRB handling paths
- Repeated connect/disconnect (partially mitigated by `a5c98e8b13985`,
  but accounting drift can occur in other paths)
- Likelihood: low-to-moderate for active DbC users over time; not every
  boot

**Step 8.3 — Failure mode severity**

Record:
- **Failure:** DbC returns `-EBUSY`, prints `"failed to queue trbs"`,
  debug port stops accepting I/O
- **Severity: MEDIUM** — functional failure of debug infrastructure; not
  kernel crash, deadlock, data corruption, or security issue
- Does not affect normal USB device operation

**Step 8.4 — Risk/benefit**

Record:
- **Benefit:** Prevents false ring-full conditions; completes removal of
  known-buggy accounting (same class as stable-worthy
  `fe82f16aafda`/`2710f8186f889`)
- **Risk:** Very low — 15-line net deletion, uses existing tested
  function, maintainer-reviewed
- **Ratio:** Moderate benefit for small DbC user base, very low risk

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Fixes real accounting bug (same mechanism as user-reported transfer-
  ring bug)
- Small, surgical, applies cleanly to v6.18.44
- All prerequisites already in tree
- DbC ring-full fixes already accepted for stable (`a5c98e8b13985` with
  Cc: stable)
- xHCI maintainers (Nyman, Kroah-Hartman) signed off
- Removes duplicate/error-prone code path

**Evidence AGAINST backport:**
- Only affects optional `CONFIG_USB_XHCI_DBGCAP` (debug feature)
- No explicit user report or syzbot for this specific DbC commit
- Failure mode is debug-port unusability, not crash/corruption/security
- Symptom partially mitigated by existing `a5c98e8b13985` reconnect
  workaround

**Unresolved questions:**
- No review-thread discussion beyond sign-offs
- Exact long-run drift scenarios for DbC not documented with a specific
  reporter

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — reuses proven
   `xhci_num_trbs_free()`, maintainer SOBs; no Tested-by
2. Fixes a real bug? **PASS** — legacy counter drift is a documented
   real bug class
3. Important issue? **PASS (borderline)** — debug infrastructure
   failure, not crash/corruption; comparable to memory-growth fix that
   went stable for main path
4. Small and contained? **PASS** — 4 files, ~15 lines net
5. No new features/APIs? **PASS** — refactor only; exporting existing
   function is not a userspace API
6. Can apply to local tree? **PASS** — verified clean apply

**Exception category:** None (not device ID, quirk, DT, build, or docs).

---

## Problem Summary for Stable Users

The xHCI driver stopped using manual `num_trbs_free` counter tracking
for normal transfer/command rings in 2023 because it drifted over time
(user-reported memory growth from unnecessary ring expansion). DbC (USB3
debug port / `ttyDBC`) was left on the old mechanism. Over long
sessions, especially with stall/no-op TRB edge cases, the counter can
desync from actual ring state, causing DbC to falsely report the ring as
full and refuse transfers with `"failed to queue trbs"`. This commit
switches DbC to the same dynamic calculation used everywhere else — a
low-risk completion of an already-stable refactoring.

For v6.18.44 specifically: the buggy code exists, prerequisites are
present, the patch applies cleanly, and related DbC ring-full fixes are
already in this tree.

## Verification

- [Phase 1] Parsed commit `9e332a74fa0de` message and tags via `git
  show`
- [Phase 2] Full diff analyzed via `git show 9e332a74fa0de -p`
- [Phase 3] `git describe HEAD` → `v6.18.44`; `make kernelversion`
  equivalent from Makefile → 6.18.44
- [Phase 3] `git merge-base --is-ancestor 9e332a74fa0de HEAD` → exit 1
  (not in tree)
- [Phase 3] `git blame` on `xhci-mem.c:325` → `b008df60c6369b` (2012)
- [Phase 3] `2710f8186f889`, `5adc1cc038f44`, `dfba2174dc42` confirmed
  ancestors of HEAD
- [Phase 3] `git log --grep='num_trbs_free'` found related history
- [Phase 4] `b4 dig -c 9e332a74fa0de` → lore URL found
- [Phase 4] `b4 dig -m /tmp/xhci_num_trbs.mbox` → mbox downloaded, no
  review replies or stable CC
- [Phase 4] WebFetch of lore URLs blocked (403/Anubis); used b4 mbox
  instead
- [Phase 5] `grep num_trbs_free` / `grep xhci_num_trbs_free` in
  `drivers/usb/host/`
- [Phase 5] Read `xhci-dbgcap.c`, `xhci-ring.c:342-370`, `xhci-
  ring.c:3328`, `Kconfig` for `USB_XHCI_DBGCAP`
- [Phase 6] Buggy code confirmed present at lines listed above
- [Phase 6] `git apply --check` on patch → clean apply
- [Phase 6] `a5c98e8b13985` confirmed in tree with Cc: stable and
  `"failed to queue trbs"` symptom
- [Phase 8] Failure mode: false `-EBUSY` on DbC queue → debug port
  stops; severity MEDIUM

**YES**The analysis is done for **usb: xhci: remove legacy
'num_trbs_free' tracking** on the **v6.18.44** tree.

**Summary:** This is a small DbC-only fix that drops manual TRB free-
space counting (known to drift) and uses the existing
`xhci_num_trbs_free()` path instead. The buggy code is still present in
this tree, prerequisites are already there, and the patch applies
cleanly. Main downside: it only affects `CONFIG_USB_XHCI_DBGCAP` users,
and the failure mode is the debug port stopping with `"failed to queue
trbs"`, not a crash or data corruption.

**Recommendation: YES** for backport to this stable tree.

 drivers/usb/host/xhci-dbgcap.c | 5 +----
 drivers/usb/host/xhci-mem.c    | 6 ------
 drivers/usb/host/xhci-ring.c   | 2 +-
 drivers/usb/host/xhci.h        | 2 +-
 4 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/xhci-dbgcap.c b/drivers/usb/host/xhci-dbgcap.c
index ecda964e018ac..e2e0694d0c22a 100644
--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -260,7 +260,6 @@ xhci_dbc_queue_trb(struct xhci_ring *ring, u32 field1,
 	trace_xhci_dbc_gadget_ep_queue(ring, &trb->generic,
 				       xhci_trb_virt_to_dma(ring->enq_seg,
 							    ring->enqueue));
-	ring->num_trbs_free--;
 	next = ++(ring->enqueue);
 	if (TRB_TYPE_LINK_LE32(next->link.control)) {
 		next->link.control ^= cpu_to_le32(TRB_CYCLE);
@@ -281,7 +280,7 @@ static int xhci_dbc_queue_bulk_tx(struct dbc_ep *dep,
 
 	num_trbs = count_trbs(req->dma, req->length);
 	WARN_ON(num_trbs != 1);
-	if (ring->num_trbs_free < num_trbs)
+	if (xhci_num_trbs_free(ring) <= num_trbs)
 		return -EBUSY;
 
 	addr	= req->dma;
@@ -782,7 +781,6 @@ static void dbc_handle_xfer_event(struct xhci_dbc *dbc, union xhci_trb *event)
 		}
 		if (r->status == -COMP_STALL_ERROR) {
 			dev_warn(dbc->dev, "Give back stale stalled req\n");
-			ring->num_trbs_free++;
 			xhci_dbc_giveback(r, 0);
 		}
 	}
@@ -847,7 +845,6 @@ static void dbc_handle_xfer_event(struct xhci_dbc *dbc, union xhci_trb *event)
 		break;
 	}
 
-	ring->num_trbs_free++;
 	req->actual = req->length - remain_length;
 	xhci_dbc_giveback(req, status);
 }
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 6e5b6057de79e..7f8c4a680832d 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -317,12 +317,6 @@ void xhci_initialize_ring_info(struct xhci_ring *ring)
 	 * handling ring expansion, set the cycle state equal to the old ring.
 	 */
 	ring->cycle_state = 1;
-
-	/*
-	 * Each segment has a link TRB, and leave an extra TRB for SW
-	 * accounting purpose
-	 */
-	ring->num_trbs_free = ring->num_segs * (TRBS_PER_SEGMENT - 1) - 1;
 }
 EXPORT_SYMBOL_GPL(xhci_initialize_ring_info);
 
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 3f1a6089a01ce..859680bc74a2c 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -339,7 +339,7 @@ static struct xhci_segment *trb_in_td(struct xhci_td *td, dma_addr_t suspect_dma
  * Only for transfer and command rings where driver is the producer, not for
  * event rings.
  */
-static unsigned int xhci_num_trbs_free(struct xhci_ring *ring)
+unsigned int xhci_num_trbs_free(struct xhci_ring *ring)
 {
 	struct xhci_segment *enq_seg = ring->enq_seg;
 	union xhci_trb *enq = ring->enqueue;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 4cd4cb0e431d1..64f4207270f32 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1377,7 +1377,6 @@ struct xhci_ring {
 	u32			cycle_state;
 	unsigned int		stream_id;
 	unsigned int		num_segs;
-	unsigned int		num_trbs_free; /* used only by xhci DbC */
 	unsigned int		bounce_buf_len;
 	enum xhci_ring_type	type;
 	u32			old_trb_comp_code;
@@ -1953,6 +1952,7 @@ void xhci_ring_doorbell_for_active_rings(struct xhci_hcd *xhci,
 void xhci_cleanup_command_queue(struct xhci_hcd *xhci);
 void inc_deq(struct xhci_hcd *xhci, struct xhci_ring *ring);
 unsigned int count_trbs(u64 addr, u64 len);
+unsigned int xhci_num_trbs_free(struct xhci_ring *ring);
 int xhci_stop_endpoint_sync(struct xhci_hcd *xhci, struct xhci_virt_ep *ep,
 			    int suspend, gfp_t gfp_flags);
 void xhci_process_cancelled_tds(struct xhci_virt_ep *ep);
-- 
2.53.0

