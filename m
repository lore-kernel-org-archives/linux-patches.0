Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDB73CFF7F;
	Mon, 30 Mar 2026 12:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874329; cv=none; b=V5VLIBM5Tv5aH1WrPfkgglPCC9t00LByo9RE2deySZJQ5FX4iGFDMilvBvrpN/mC7fYlCrYQBd0ht2o7y8NfN1mhIp2hlctKjwFJZE5aj+W+qBUd4xI7FzOdw8WVQ6l/6toP57c3Owx7z/OknTc2SH3V0Q6n5/zf4bDhykvoFns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874329; c=relaxed/simple;
	bh=/hseZRdmw9bY/4L7bbjVEziEl/vgaxGnCH1lCzpW+0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O9B/qJxWjoIPwrbnTk+JuOafVVVwvkOV59bOmw0Hn5zAHAIAInANarHLsZKDba6oicXsstlRmQGUSL0GGjdkdd7RHOKiTh5Etrmm5lljxeoHZ3TazUWZ1BecTt4J933YzjTBzyXbfW0SrM8yjQEgwH41uWlYRbkuAyor9Xpcrho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ok9OZ7iV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ok9OZ7iV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E78BC4AF09;
	Mon, 30 Mar 2026 12:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874329;
	bh=/hseZRdmw9bY/4L7bbjVEziEl/vgaxGnCH1lCzpW+0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ok9OZ7iVBqRPZ+4W5T3z/TuVEve6jiyFf7mMRTmqNmMq71Hw3c8ddyEKeonIrVa6M
	 X4vbKZMaH50FvWjlMBsE6q8zXHBHiSCL8H9wwDYTa6kI3gAOWK236c5p9aSpPmr1M4
	 WOfaGIIp+u2/XmijvT9dDTQoYI82uRRHyfoxbFu/rKP51y4kWxTHuyJ+HW0VIgbpph
	 ewFzIyfIDYdH/fJRKRArTQHEtjCTxEeI/5Lehqm8zEUsOLKNklsFysEFZnMzzUd/vy
	 cjyvbcOjVl5j1cxZuLoD1AEPuo0vL//LM/r/+CT4X48o8Tnxm0pGaAY5Ea6xTwMHTG
	 LTFg2Atw4CRWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] Bluetooth: hci_sync: annotate data-races around hdev->req_status
Date: Mon, 30 Mar 2026 08:38:17 -0400
Message-ID: <20260330123842.756154-4-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit b6807cfc195ef99e1ac37b2e1e60df40295daa8c ]

__hci_cmd_sync_sk() sets hdev->req_status under hdev->req_lock:

    hdev->req_status = HCI_REQ_PEND;

However, several other functions read or write hdev->req_status without
holding any lock:

  - hci_send_cmd_sync() reads req_status in hci_cmd_work (workqueue)
  - hci_cmd_sync_complete() reads/writes from HCI event completion
  - hci_cmd_sync_cancel() / hci_cmd_sync_cancel_sync() read/write
  - hci_abort_conn() reads in connection abort path

Since __hci_cmd_sync_sk() runs on hdev->req_workqueue while
hci_send_cmd_sync() runs on hdev->workqueue, these are different
workqueues that can execute concurrently on different CPUs. The plain
C accesses constitute a data race.

Add READ_ONCE()/WRITE_ONCE() annotations on all concurrent accesses
to hdev->req_status to prevent potential compiler optimizations that
could affect correctness (e.g., load fusing in the wait_event
condition or store reordering).

Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information for a comprehensive analysis. Let me
compile the full assessment.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1:** Record: [Bluetooth: hci_sync] [annotate] Add
READ_ONCE/WRITE_ONCE annotations to all concurrent accesses to
`hdev->req_status`.

**Step 1.2:** Record: Tags: `Signed-off-by: Cen Zhang
<zzzccc427@gmail.com>` (author), `Signed-off-by: Luiz Augusto von Dentz
<luiz.von.dentz@intel.com>` (Bluetooth subsystem maintainer). No Fixes:,
Reported-by:, Tested-by:, Reviewed-by:, Link:, or Cc: stable tags
present.

**Step 1.3:** Record: The commit explains that `__hci_cmd_sync_sk()`
sets `hdev->req_status = HCI_REQ_PEND` under `hdev->req_lock`, but other
functions read/write `req_status` without any lock. The separate
workqueues (`hdev->req_workqueue` vs `hdev->workqueue`) execute
concurrently on different CPUs. Failure mode: compiler may fuse loads in
the `wait_event` condition or reorder stores.

**Step 1.4:** Record: This IS a real concurrency fix, not merely
cosmetic. The "annotate" framing understates the correctness
implication: under the Linux kernel memory model, concurrent
unsynchronized plain accesses constitute a data race (undefined
behavior).

## PHASE 2: DIFF ANALYSIS

**Step 2.1:** Record: Files: `net/bluetooth/hci_conn.c` (1 read),
`net/bluetooth/hci_core.c` (1 read), `net/bluetooth/hci_sync.c` (6 reads
+ 4 writes). Total: ~12 line replacements, zero logic changes. Functions
modified: `hci_abort_conn()`, `hci_send_cmd_sync()`,
`hci_cmd_sync_complete()`, `__hci_cmd_sync_sk()`,
`hci_cmd_sync_cancel()`, `hci_cmd_sync_cancel_sync()`. Scope: small,
surgical, single-variable annotation across 3 files.

**Step 2.2:** Record: Every hunk replaces a plain `hdev->req_status`
read with `READ_ONCE(hdev->req_status)` or a plain write with
`WRITE_ONCE(hdev->req_status, value)`. No control flow, logic, or API
changes whatsoever.

**Step 2.3:** Record: Category: data race / synchronization fix.
Mechanism: `hdev->req_status` is shared between:
- The sync command waiter (on `req_workqueue` via `__hci_cmd_sync_sk`)
- The command transmitter (on `workqueue` via
  `hci_send_cmd_sync`/`hci_cmd_work`)
- HCI event completion (`hci_cmd_sync_complete`)
- Cancel paths (`hci_cmd_sync_cancel`, `hci_cmd_sync_cancel_sync`)
- Connection abort (`hci_abort_conn`)

The most critical concern: in `hci_cmd_sync_cancel()` and
`hci_cmd_sync_cancel_sync()`, without WRITE_ONCE, the store to
`req_status = HCI_REQ_CANCELED` could be reordered by the compiler with
the store to `req_result`, leading to the waiter in `__hci_cmd_sync_sk`
seeing `HCI_REQ_CANCELED` but reading a stale `req_result`.

**Step 2.4:** Record: Fix is obviously correct — mechanical replacement
with standard kernel annotations. Zero regression risk. No behavior
change intended.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1:** Record: `git blame` shows:
- Core `req_status` in `hci_sync.c` introduced by `6a98e3836fa207`
  (Marcel Holtmann, 2021-10-27) — "Bluetooth: Add helper for serialized
  HCI command execution"
- `hci_abort_conn()` `req_status` read introduced by `a13f316e90fdb1`
  (Luiz von Dentz, 2023-06-26)
- `hci_send_cmd_sync()` direct `req_status` read from `8bedf130c26538`
  (Luiz von Dentz, 2024-07-01)

**Step 3.2:** Record: No Fixes: tag.

**Step 3.3:** Record: Related: `09b0cd1297b4d` ("Bluetooth: hci_sync:
fix race in hci_cmd_sync_dequeue_once") by same author — a real UAF race
fix in the same subsystem. This patch is standalone.

**Step 3.4:** Record: Cen Zhang has one other Bluetooth commit in this
tree (the race fix above). Luiz Augusto von Dentz is the Bluetooth
subsystem maintainer. Maintainer sign-off provides trust.

**Step 3.5:** Record: No dependencies. The change is self-contained
mechanical annotation. However, backport to older trees needs adaptation
(see Phase 6).

## PHASE 4: MAILING LIST RESEARCH

Record: Lore.kernel.org was inaccessible (Anubis PoW challenge). Could
not verify patch discussion, reviewer feedback, or stable nominations.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1:** Functions: `hci_abort_conn()`, `hci_send_cmd_sync()`,
`hci_cmd_sync_complete()`, `__hci_cmd_sync_sk()`,
`hci_cmd_sync_cancel()`, `hci_cmd_sync_cancel_sync()`.

**Step 5.2:** Verified callers:
- `hci_send_cmd_sync()` ← `hci_cmd_work()` on `hdev->workqueue`
- `hci_cmd_sync_complete()` ← installed as `req_complete_skb` callback,
  reached from HCI event processing
- `hci_abort_conn()` ← connection timeout, management disconnect/unpair
  commands
- `__hci_cmd_sync_sk()` ← core HCI sync command infrastructure (many
  callers)
- Cancel functions ← timeout, send error, power-off, mgmt paths

**Step 5.3-5.4:** Record: All paths reachable during normal Bluetooth
operations (device init, connection setup/teardown, suspend/resume). The
separate workqueue allocation confirmed at `hci_core.c:2604` and
`hci_core.c:2610` — two distinct `alloc_ordered_workqueue()` calls.

**Step 5.5:** Record: The `hci_req_sync_lock` macro exists and IS used
extensively (verified via grep), expanding to
`mutex_lock(&hdev->req_lock)`. It protects the caller-side serialization
of `__hci_cmd_sync_sk`. However, the readers in event/cancel/abort paths
do NOT hold this lock — confirming the race window.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** Verified:
- `6a98e3836fa207` is ancestor of v6.1 ✓ and v6.6 ✓ — `hci_sync.c` with
  plain `req_status` accesses exists in both
- `a13f316e90fdb1` is ancestor of v6.6 ✓ — `hci_abort_conn()`
  `req_status` check exists in v6.6
- `8bedf130c26538` is NOT ancestor of v6.6 — v6.6 uses
  `hci_req_status_pend(hdev)` wrapper in `hci_core.c`
- `hci_sync.c` does NOT exist in v5.15 (verified: `git show
  v5.15:net/bluetooth/hci_sync.c` failed)
- v6.6 and v6.1 `hci_sync.c` both have the same plain `req_status`
  pattern (10 occurrences each, verified)

**Step 6.2:** Record: Minor backport adjustment needed for `hci_core.c`
on v6.6/v6.1 (uses `hci_req_status_pend()` wrapper instead of direct
access). `hci_sync.c` changes should apply with minor context
adjustments.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** Record: `net/bluetooth/` — IMPORTANT subsystem. Used by
laptops, phones, IoT, embedded systems. Not core kernel (mm/vfs/net-core
level), but widely used.

**Step 7.2:** Record: Very active subsystem — 20 recent commits in the
touched files.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Record: All Bluetooth users with `CONFIG_BT`. The affected
functions are on the core HCI command synchronization path.

**Step 8.2:** Record: The race requires concurrent access from separate
workqueues or event completion while a sync command is pending. This is
a realistic scenario during normal Bluetooth operation (connection
attempts, command timeouts, connection aborts).

**Critical nuance on the `wait_event` concern:** I verified the
`___wait_event` macro expands to a `for(;;)` loop that calls
`prepare_to_wait_event()` (an out-of-line function with
`spin_lock`/`spin_unlock`) each iteration. This acts as an implicit
compiler barrier, meaning the compiler cannot cache `req_status` across
iterations. The load fusing risk within `wait_event` is therefore
mitigated in practice by the function-call barrier.

However, the **store reordering concern in cancel paths** is more
legitimate: without WRITE_ONCE, the compiler could reorder
`hdev->req_result = err` and `hdev->req_status = HCI_REQ_CANCELED` in
`hci_cmd_sync_cancel()`, causing the waiter to observe `CANCELED` status
but read a stale `req_result`. The reads in `hci_abort_conn()` and
`hci_send_cmd_sync()` also lack annotation.

**Step 8.3:** Record: Failure mode: Incorrect error propagation via
stale `req_result` reads, potential KCSAN reports. Severity: MEDIUM —
not a guaranteed crash but a real correctness issue that could cause
wrong error codes or unexpected command behavior.

**Step 8.4:** Record: Benefit: LOW-MEDIUM (fixes real LKMM violation,
prevents potential incorrect behavior). Risk: VERY LOW (purely
mechanical annotation). Ratio: favorable.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**

FOR backporting:
- Real data race verified across separate workqueues (`hdev->workqueue`
  vs `hdev->req_workqueue`)
- Readers in event/cancel/abort paths confirmed to NOT hold `req_lock`
- Fix is surgical, mechanical, and zero-risk (READ_ONCE/WRITE_ONCE only)
- Core Bluetooth infrastructure — wide user base
- Maintainer signed off
- Author has established credibility (prior UAF race fix in same
  subsystem)
- Buggy code exists in v6.1 and v6.6 stable trees (verified)
- Store reordering in cancel paths is a legitimate correctness concern
- Under LKMM, these are definitionally data races (bugs)

AGAINST backporting:
- No crash/hang/syzbot/KCSAN report cited
- No Fixes: tag, no Reported-by:
- Commit message frames this as "annotation" not "fix"
- The `wait_event` load fusing risk is partially mitigated by implicit
  compiler barriers from `prepare_to_wait_event()`
- Needs minor adaptation for v6.6/v6.1 (`hci_req_status_pend()` wrapper)
- Practical user-visible impact is unverified

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — mechanical, maintainer-
   committed
2. Fixes a real bug? **YES** — LKMM data race, store reordering concern
   in cancel paths
3. Important issue? **BORDERLINE** — correctness issue but no
   demonstrated crash
4. Small and contained? **YES** — 12 line replacements, 3 files
5. No new features or APIs? **YES**
6. Applies to stable? **YES with minor adjustment** for `hci_core.c`

**Step 9.3:** No exception category applies.

**Step 9.4: Decision**

This is a borderline case. The data race is real per the Linux kernel
memory model, and the fix carries effectively zero regression risk. The
store reordering concern in the cancel paths
(`hci_cmd_sync_cancel`/`hci_cmd_sync_cancel_sync`) is a legitimate
correctness issue — the compiler could reorder the `req_result` and
`req_status` stores, causing the waiter to observe inconsistent state.
However, the most dramatic failure scenario (load fusing in
`wait_event`) is largely mitigated in practice by implicit compiler
barriers.

The fix is small, surgical, and obviously correct. The risk/benefit
ratio strongly favors inclusion. The kernel community's position under
LKMM is that data races are bugs, and this fix addresses real concurrent
accesses on core Bluetooth infrastructure. While no crash report exists,
the potential for incorrect error propagation during command
cancellation is a real functional concern for Bluetooth users.

## Verification

- [Phase 1] Parsed tags: only two Signed-off-by present; no Fixes:,
  Reported-by:, Link:, or Cc: stable
- [Phase 2] Diff: confirmed 12 mechanical READ_ONCE/WRITE_ONCE
  replacements across 3 files, zero logic changes
- [Phase 3] git blame: `6a98e3836fa207` (Marcel Holtmann, 2021-10-27)
  introduced core `req_status` pattern in `hci_sync.c`; `a13f316e90fdb1`
  (2023-06-26) introduced `hci_abort_conn()` access; `8bedf130c26538`
  (2024-07-01) introduced `hci_send_cmd_sync()` direct access
- [Phase 3] `git merge-base --is-ancestor`: confirmed `6a98e3836fa207`
  in v6.1 and v6.6; `a13f316e90fdb1` in v6.6; `8bedf130c26538` NOT in
  v6.6
- [Phase 3] `git show v5.15:net/bluetooth/hci_sync.c` failed — file
  doesn't exist in v5.15
- [Phase 3] Author: `git log --author="Cen Zhang"` found one Bluetooth
  commit: `09b0cd1297b4d` (UAF race fix in same area)
- [Phase 5] Verified separate workqueue allocation at `hci_core.c:2604`
  and `hci_core.c:2610` (two `alloc_ordered_workqueue` calls)
- [Phase 5] Verified `hci_req_sync_lock` macro expands to
  `mutex_lock(&hdev->req_lock)` (`include/net/bluetooth/hci_sync.h:15`);
  it IS used extensively by callers of `__hci_cmd_sync_sk` but NOT held
  by event/cancel/abort paths
- [Phase 5] Verified `wait_event` macro: `___wait_event` expands to
  `for(;;)` loop calling `prepare_to_wait_event()` (out-of-line,
  contains spinlock) — acts as implicit compiler barrier per iteration
- [Phase 6] v6.6 `hci_sync.c`: 10 plain `req_status` accesses confirmed;
  v6.1: 10 plain accesses confirmed
- [Phase 6] v6.6 `hci_core.c`: uses `hci_req_status_pend(hdev)` wrapper,
  not direct access (needs adaptation)
- [Phase 6] v6.6 `hci_conn.c`: plain `req_status` read at line 2934
  confirmed
- [Phase 8] `prepare_to_wait_event()` verified: contains
  `spin_lock_irqsave`/`spin_unlock_irqrestore` — mitigates load fusing
  in `wait_event` loop
- UNVERIFIED: Lore.kernel.org discussion (blocked by Anubis)
- UNVERIFIED: Whether KCSAN specifically reported this data race
- UNVERIFIED: Concrete runtime failure attributable to this specific
  race

**YES**

 net/bluetooth/hci_conn.c |  2 +-
 net/bluetooth/hci_core.c |  2 +-
 net/bluetooth/hci_sync.c | 20 ++++++++++----------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 0f512c2c2fd3c..6335444331bd9 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2989,7 +2989,7 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
 	 * hci_connect_le serializes the connection attempts so only one
 	 * connection can be in BT_CONNECT at time.
 	 */
-	if (conn->state == BT_CONNECT && hdev->req_status == HCI_REQ_PEND) {
+	if (conn->state == BT_CONNECT && READ_ONCE(hdev->req_status) == HCI_REQ_PEND) {
 		switch (hci_skb_event(hdev->sent_cmd)) {
 		case HCI_EV_CONN_COMPLETE:
 		case HCI_EV_LE_CONN_COMPLETE:
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 8ccec73dce45c..0f86b81b39730 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4125,7 +4125,7 @@ static int hci_send_cmd_sync(struct hci_dev *hdev, struct sk_buff *skb)
 		kfree_skb(skb);
 	}
 
-	if (hdev->req_status == HCI_REQ_PEND &&
+	if (READ_ONCE(hdev->req_status) == HCI_REQ_PEND &&
 	    !hci_dev_test_and_set_flag(hdev, HCI_CMD_PENDING)) {
 		kfree_skb(hdev->req_skb);
 		hdev->req_skb = skb_clone(hdev->sent_cmd, GFP_KERNEL);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 43b36581e336d..bd2f5e646eecf 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -25,11 +25,11 @@ static void hci_cmd_sync_complete(struct hci_dev *hdev, u8 result, u16 opcode,
 {
 	bt_dev_dbg(hdev, "result 0x%2.2x", result);
 
-	if (hdev->req_status != HCI_REQ_PEND)
+	if (READ_ONCE(hdev->req_status) != HCI_REQ_PEND)
 		return;
 
 	hdev->req_result = result;
-	hdev->req_status = HCI_REQ_DONE;
+	WRITE_ONCE(hdev->req_status, HCI_REQ_DONE);
 
 	/* Free the request command so it is not used as response */
 	kfree_skb(hdev->req_skb);
@@ -167,20 +167,20 @@ struct sk_buff *__hci_cmd_sync_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 
 	hci_cmd_sync_add(&req, opcode, plen, param, event, sk);
 
-	hdev->req_status = HCI_REQ_PEND;
+	WRITE_ONCE(hdev->req_status, HCI_REQ_PEND);
 
 	err = hci_req_sync_run(&req);
 	if (err < 0)
 		return ERR_PTR(err);
 
 	err = wait_event_interruptible_timeout(hdev->req_wait_q,
-					       hdev->req_status != HCI_REQ_PEND,
+					       READ_ONCE(hdev->req_status) != HCI_REQ_PEND,
 					       timeout);
 
 	if (err == -ERESTARTSYS)
 		return ERR_PTR(-EINTR);
 
-	switch (hdev->req_status) {
+	switch (READ_ONCE(hdev->req_status)) {
 	case HCI_REQ_DONE:
 		err = -bt_to_errno(hdev->req_result);
 		break;
@@ -194,7 +194,7 @@ struct sk_buff *__hci_cmd_sync_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 		break;
 	}
 
-	hdev->req_status = 0;
+	WRITE_ONCE(hdev->req_status, 0);
 	hdev->req_result = 0;
 	skb = hdev->req_rsp;
 	hdev->req_rsp = NULL;
@@ -665,9 +665,9 @@ void hci_cmd_sync_cancel(struct hci_dev *hdev, int err)
 {
 	bt_dev_dbg(hdev, "err 0x%2.2x", err);
 
-	if (hdev->req_status == HCI_REQ_PEND) {
+	if (READ_ONCE(hdev->req_status) == HCI_REQ_PEND) {
 		hdev->req_result = err;
-		hdev->req_status = HCI_REQ_CANCELED;
+		WRITE_ONCE(hdev->req_status, HCI_REQ_CANCELED);
 
 		queue_work(hdev->workqueue, &hdev->cmd_sync_cancel_work);
 	}
@@ -683,12 +683,12 @@ void hci_cmd_sync_cancel_sync(struct hci_dev *hdev, int err)
 {
 	bt_dev_dbg(hdev, "err 0x%2.2x", err);
 
-	if (hdev->req_status == HCI_REQ_PEND) {
+	if (READ_ONCE(hdev->req_status) == HCI_REQ_PEND) {
 		/* req_result is __u32 so error must be positive to be properly
 		 * propagated.
 		 */
 		hdev->req_result = err < 0 ? -err : err;
-		hdev->req_status = HCI_REQ_CANCELED;
+		WRITE_ONCE(hdev->req_status, HCI_REQ_CANCELED);
 
 		wake_up_interruptible(&hdev->req_wait_q);
 	}
-- 
2.53.0

