Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D05556D2B5;
	Mon, 31 Aug 2026 13:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184110; cv=none; b=nQC2B3d2ROj9WC4r219CVfP5eLcXxaie5TdZSNmcYl7s0khc5y+F/oTVfMqZbFmIUu+HPOzw/P7wRd7ME2EqEE90YqxbHVexixQvJR2lw1eR2K0Bp5usJnKO6KPZeyP3cMIPMMOzTfLtuQ7fWvJyfgt73JXpV0DEA1YICQBGGmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184110; c=relaxed/simple;
	bh=fVxi0YdCLhDJvU4MoBMSyVst1d6Hu3CNhEy/OwqxrVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oZX2luF2i8AC/o21gyep4/z0KcnGhMJ8e5i1MSnqHR9ynf9Jq6llgtmarms0va0Sn3qCEQTMaaFoSI3NgD6QwKFtbMK9qBc88+cqRpYrauCTAAFm8ztzG9ggzDM61JrLe5VzpIe37XnzYh3YJTyXh/3GGvcq6WUhq0RqOpPvYJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JSZmA/Xa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JSZmA/Xa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C97D1F000E9;
	Mon, 31 Aug 2026 13:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184107;
	bh=LHY8jlUOXSsp3EloEQxl2pnjuDjAk43+SZgSWjjKyRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JSZmA/Xa+03KAZJu3aT7Pqq/lFzdwUaiK/RNBHhWNaGFcMzBSobkiyy7bIiMXuuJd
	 eBBwr5+vaUV3EvTab158zVCOZca74M+nK6nE62AYPStc4J879H1lBydGcC9MMuEUbL
	 FRbC4nvGccKivoxtPdxSYLrDNF/9/S66QLHf0GYo3fHFbpuKTwGwmEJc27VcAm5mXg
	 5kIpDCgVyqFs7ekOYl4jHw/wRyQD4bY+AKl2w7hn7m/DsYzPdpGf9imi6zOYZuqzfQ
	 gLs2CC4jVkhjdqHzKnRpK8KuD8KJ+7+TXJF3a51tbtV6FHoBBQx/Ya5AEnmORYucU5
	 /EeuYqWGbKEiA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Joonwon Kang <joonwonkang@google.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] mailbox: Make mbox_send_message() return error code when tx fails
Date: Mon, 31 Aug 2026 09:28:43 -0400
Message-ID: <20260831133314.4125787-495-sashal@kernel.org>
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

From: Joonwon Kang <joonwonkang@google.com>

[ Upstream commit 96a3d2f3167f5644b30e60171898e67123c3c2c6 ]

When the mailbox controller failed transmitting message, the error code
was only passed to the client's tx done handler and not to
mbox_send_message() in blocking mode. For this reason, the function could
return a false success. This commit resolves the issue by introducing the
tx status and checking it before mbox_send_message() returns.

This commit works with the premise that the multi-threads' access to a
channel in blocking mode is serialized by clients, not by the mailbox
APIs, since the current mbox_send_message() in blocking mode does not
support multi-threads.

Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[mailbox]` `[Make]` — Make `mbox_send_message()` return an
error code when TX fails in blocking mode.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Joonwon Kang `<joonwonkang@google.com>` (author)
- **Reviewed-by:** Sudeep Holla `<sudeep.holla@kernel.org>` (mailbox/ARM
  maintainer)
- **Signed-off-by:** Jassi Brar `<jassisinghbrar@gmail.com>` (mailbox
  subsystem maintainer)
- **No** `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`, or `Cc:
  stable` in the committed message (v6 submission notes Cc was removed
  from the commit message but was present in the patch email)
- Notable: reviewed by subsystem maintainer; patch series explicitly
  CC'd `stable@vger.kernel.org` in v6 submission

### Step 1.3: Body analysis
**Record:**
- **Bug:** In blocking mode (`tx_block`), when the mailbox controller
  reports a TX failure via `mbox_chan_txdone()` / `tx_tick()`, the error
  is delivered only to the optional `tx_done` callback.
  `mbox_send_message()` still returns the positive queue index from
  `add_to_rbuf()`, i.e. false success.
- **Symptom:** Callers checking `ret < 0` believe TX succeeded; they may
  proceed or wait for RX that never arrives, eventually timing out with
  the wrong error.
- **Root cause:** `mbox_send_message()` only converts timeout (`ret ==
  0` from `wait_for_completion_timeout`) to `-ETIME`; it never inspects
  the TX result passed to `tx_tick()`.
- **Constraint:** Author documents that blocking mode does not support
  multi-threaded concurrent senders; clients must serialize access.

### Step 1.4: Hidden bug fix?
**Record:** Yes — this is a straightforward API correctness bug fix, not
cosmetic cleanup. The kerneldoc for `mbox_send_message()` states
blocking mode should return after transmission completes; TX failure is
not success.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- `drivers/mailbox/mailbox.c`: +5 / -1 lines
- `include/linux/mailbox_controller.h`: +2 lines (field + comment)
- **Functions modified:** `tx_tick()`, `mbox_send_message()`
- **Scope:** Single-subsystem, surgical fix (7 lines net)

### Step 2.2: Code flow changes
**Record:**
- **Hunk 1 (`tx_tick`):** Before: on non-timeout completion in blocking
  mode, only called `complete()`. After: also stores `chan->tx_status =
  r` before waking the waiter.
- **Hunk 2 (`mbox_send_message`):** Before: after successful wait,
  always returned positive queue index `t`. After: if `chan->tx_status <
  0`, returns that error instead.
- **Affected path:** Blocking-mode TX completion and error reporting
  only.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / API contract fix (incorrect return value
  propagation)
- **Mechanism:** TX error `r` flows through `tx_tick(chan, r)` →
  `tx_done` callback, but `mbox_send_message()` waiter was not told. Fix
  stores `r` in per-channel `tx_status` and propagates it to the return
  value.

### Step 2.4: Fix quality
**Record:**
- Fix is minimal and obviously correct for single-threaded blocking use
  (the documented/accepted model).
- **Regression risk:** Low for intended use. Reviewer Sudeep Holla noted
  per-channel `tx_status` can be stale/overwritten with concurrent
  blocking senders; author and maintainers accepted this as a pre-
  existing limitation (blocking mode is not multi-thread safe).
- No public API change; only corrects return semantics.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Current `tx_tick()` / `mbox_send_message()` blocking path in
this tree comes from commit `a112b91dd6349` (Jeff Layton, 2026-07-23) —
a sunrpc backport that brought in the current `mailbox.c` content. The
buggy blocking-return logic is present in that version. This tree's git
history is shallow for `drivers/mailbox/` (only one commit shown), so
the original introduction date of `tx_block` cannot be determined from
this checkout alone.

### Step 3.2: Fixes tag
**Record:** N/A — no `Fixes:` tag in the commit message.

### Step 3.3: Related file history
**Record:** `git log --oneline -20 -- drivers/mailbox/mailbox.c` shows
only `a112b91dd6349`. No related fix or prerequisite series is visible
in this tree. The final v6 patch is standalone (detached from earlier
multi-thread completion work per submission changelog).

### Step 3.4: Author context
**Record:** Joonwon Kang (Google). Jassi Brar is the mailbox maintainer
and committed/acked. Sudeep Holla reviewed. No other commits from these
authors appear in this tree's mailbox history.

### Step 3.5: Dependencies
**Record:** No dependencies on other patches. Diff matches current tree
structure (`scoped_guard`, same function layout). Applies cleanly to
this tree's `mailbox.c` and `mailbox_controller.h`.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:**
- **URL:** https://lists.openwall.net/linux-kernel/2026/05/10/136
  (`[PATCH v6] mailbox: Make mbox_send_message() return error code when
  tx fails`)
- Series evolved v1→v6; v4 detached from multi-thread completion patch;
  v6 is the final standalone version matching the analyzed diff.
- Reviewer concern (Sudeep Holla, v4 thread): per-channel
  `tx_status`/`tx_complete` unsafe with concurrent blocking senders.
  Author response: blocking mode does not support multi-thread; clients
  serialize.

### Step 4.2: Reviewers
**Record:** To: Jassi Brar, Sudeep Holla. Cc: `linux-kernel`,
`stable@vger.kernel.org`, `akpm`, `dianders`. Subsystem maintainers were
directly involved.

### Step 4.3: Bug reports
**Record:** No syzbot, Bugzilla, or user crash reports. Bug identified
through API behavior analysis during a blocking-mode improvement series.

### Step 4.4: Related patches
**Record:** Earlier series `[PATCH v3 0/2]` included a per-thread
completion patch (not in this final commit). This commit is self-
contained.

### Step 4.5: Stable list
**Record:** Could not search lore.kernel.org/stable (bot protection).
Patch submission explicitly CC'd `stable@vger.kernel.org`.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `tx_tick()`, `mbox_send_message()`, indirectly
`mbox_chan_txdone()`, `mbox_client_txdone()`, `msg_submit()`.

### Step 5.2: Callers
**Record:** `mbox_send_message()` is used across ~40+ in-tree files
(firmware, remoteproc, ACPI PCC, RPMSG, media, crypto, etc.). Blocking-
mode users (`tx_block = true`) include at minimum:
- `drivers/firmware/raspberrypi.c`
- `drivers/firmware/arm_scpi.c`
- `drivers/remoteproc/imx_dsp_rproc.c`
- `drivers/remoteproc/stm32_rproc.c`
- `drivers/soc/microchip/mpfs-sys-controller.c`
- `drivers/firmware/thead,th1520-aon.c`
- `drivers/i2c/busses/i2c-xgene-slimpro.c`
- others

Many check `ret < 0` after `mbox_send_message()`.

### Step 5.3: Callees
**Record:** `add_to_rbuf()`, `msg_submit()`,
`wait_for_completion_timeout()`, `complete()`, optional `tx_done`
callback, controller `send_data()` / IRQ completion paths.

### Step 5.4: Reachability
**Record:** Reachable from normal driver probe/runtime on SoCs using
mailbox firmware interfaces (RPi, ARM SCPI, i.MX DSP remoteproc,
Microchip MPFS, etc.). Not a syscall path, but common on embedded/ARM
platforms.

### Step 5.5: Similar patterns
**Record:** Timeout path already returns `-ETIME` correctly. Only non-
timeout TX errors were mishandled. No other instances of this exact bug
pattern elsewhere in the mailbox core.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Local tree is `v6.18.43-1-gc7f0dac02d232`
(Makefile: 6.18.43). `drivers/mailbox/mailbox.c` lines 103–104 and
269–276 show the buggy behavior (no `tx_status`, no error propagation).
`include/linux/mailbox_controller.h` has no `tx_status` field.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Current tree matches the patch
context (`scoped_guard` in `tx_tick`, same line structure). Only 2 files
touched.

### Step 6.3: Fix already present?
**Record:** **No.** `git grep tx_status` in mailbox code returns
nothing. Fix is not in this tree.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem criticality
**Record:** `drivers/mailbox/` — **IMPORTANT** infrastructure for
firmware/SoC communication (SCPI, RPi firmware, remoteproc kick/stop,
system controllers).

### Step 7.2: Activity
**Record:** Limited history visible in this stable checkout; mailbox
core is mature infrastructure with long-standing blocking-mode API.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Platforms using mailbox clients with `tx_block = true` —
embedded ARM, RPi, i.MX, STM32 remoteproc, Microchip MPFS, ACPI PCC
paths, etc. Config-dependent (`CONFIG_MAILBOX` and specific drivers).

### Step 8.2: Trigger conditions
**Record:** Triggered when a mailbox controller reports TX failure (via
`mbox_chan_txdone(chan, negative_error)`) while client uses blocking
mode. Requires actual controller TX failure (hardware/firmware error
path). Not user-triggerable from syscalls directly, but common in
firmware interaction error paths.

### Step 8.3: Failure mode severity
**Record:**
- **Failure mode:** False success return; callers miss immediate TX
  error; may wait for RX/timeouts with wrong error code; degraded
  firmware/remoteproc operation.
- **Severity:** **MEDIUM** — not a direct crash/UAF/security issue, but
  causes incorrect error handling and can lead to multi-second hangs
  (e.g. SCPI `MAX_RX_TIMEOUT`) instead of immediate failure.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — restores documented blocking-mode semantics for
  widely used firmware paths; enables proper error handling in drivers
  that check return values.
- **Risk:** LOW — 7-line change, maintainer-reviewed, no behavior change
  for successful TX or for non-blocking mode.
- **Ratio:** Benefit outweighs risk for this tree.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real, reproducible API bug: false success on TX failure in blocking
  mode
- Buggy code confirmed present in Linux 6.18.43 checkout
- Affects multiple production drivers using `tx_block` + `ret < 0`
  checks
- Small, surgical, maintainer-reviewed fix
- Patch series CC'd stable; standalone, no dependencies
- Corrects behavior to match kerneldoc contract

**AGAINST backport:**
- No crash, UAF, security, or data-corruption report
- Severity is incorrect error propagation / delayed failure, not system
  panic
- Pre-existing multi-thread limitation in blocking mode (reviewer
  concern)
- No fuzzer or user bug report

**Unresolved:** Exact kernel version when `tx_block` was introduced
(shallow history in this tree).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is clear; Reviewed-by
   maintainer; no Tested-by but straightforward.
2. Fixes a real bug affecting users? **PASS** — false success on TX
   failure in blocking mode.
3. Important issue? **PASS (borderline)** — MEDIUM severity API bug on
   firmware-critical paths; wrong error handling and potential hangs.
4. Small and contained? **PASS** — 7 lines, 2 files.
5. No new features or APIs? **PASS** — internal `tx_status` field;
   corrects existing return semantics.
6. Can apply to local tree? **PASS** — buggy code present; clean apply
   expected.

### Step 9.3: Exception categories
**Record:** None (not a device ID, quirk, DT, build fix, or docs-only
change).

### Step 9.4: Decision rationale
For **this** 6.18.y tree, the buggy blocking-mode behavior exists today
and affects real firmware/remoteproc drivers that rely on
`mbox_send_message()` return values. The fix is minimal, low-risk, and
restores the documented API contract. While not a crash-level bug,
incorrect error propagation on mailbox TX failures is meaningful for
stable users on embedded platforms, and the patch was explicitly
prepared for stable with maintainer review.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
  and lore submission
- **[Phase 2]** Read `drivers/mailbox/mailbox.c` lines 84–105, 245–277;
  confirmed buggy logic (no `tx_status`, returns queue index on TX
  error)
- **[Phase 2]** Read `include/linux/mailbox_controller.h`; confirmed no
  `tx_status` field
- **[Phase 3]** `git describe HEAD` → `v6.18.43-1-gc7f0dac02d232`;
  Makefile → 6.18.43
- **[Phase 3]** `git blame -L 84,105 drivers/mailbox/mailbox.c` → all
  from `a112b91dd6349`
- **[Phase 3]** `git log --oneline -20 -- drivers/mailbox/mailbox.c` →
  only one commit in this tree
- **[Phase 3]** `git log --grep` for commit subject → not found in tree
  (fix not merged)
- **[Phase 4]** Fetched https://lists.openwall.net/linux-
  kernel/2026/05/10/136 — confirmed v6 patch, Reviewed-by Sudeep Holla,
  Cc stable in submission
- **[Phase 4]** Web search found Sudeep Holla multi-thread review
  concern and author response
- **[Phase 4]** `b4 dig -c` not run — commit not in this tree; `b4 dig
  -q` unsupported
- **[Phase 4]** lore.kernel.org/stable search blocked by bot protection
- **[Phase 5]** `grep mbox_send_message(` — 40+ call sites across
  firmware/remoteproc/ACPI/etc.
- **[Phase 5]** `grep tx_block = true` — 10+ blocking-mode clients
  identified
- **[Phase 5]** Read `raspberrypi.c:49-71`, `arm_scpi.c:512-520`, `mpfs-
  sys-controller.c:50-74`, `imx_dsp_rproc.c:611` — all use blocking mode
  and check return values
- **[Phase 6]** Confirmed fix absent: no `tx_status` in mailbox code
- **[Phase 6]** Confirmed patch context matches current tree
  (`scoped_guard` present in `tx_tick`)
- **[Phase 7]** Mailbox is firmware/SoC communication infrastructure —
  IMPORTANT
- **[Phase 8]** Failure mode: false success → wrong error handling / RX
  wait timeouts — MEDIUM severity
- **UNVERIFIED:** Exact mainline commit SHA (not in this tree); date
  `tx_block` was originally introduced

**YES**

 drivers/mailbox/mailbox.c          | 6 +++++-
 include/linux/mailbox_controller.h | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 60866e8417c9b..0f2019aadc216 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -100,8 +100,10 @@ static void tx_tick(struct mbox_chan *chan, int r)
 	if (chan->cl->tx_done)
 		chan->cl->tx_done(chan->cl, mssg, r);
 
-	if (r != -ETIME && chan->cl->tx_block)
+	if (r != -ETIME && chan->cl->tx_block) {
+		chan->tx_status = r;
 		complete(&chan->tx_complete);
+	}
 }
 
 static enum hrtimer_restart txdone_hrtimer(struct hrtimer *hrtimer)
@@ -270,6 +272,8 @@ int mbox_send_message(struct mbox_chan *chan, void *mssg)
 		if (ret == 0) {
 			t = -ETIME;
 			tx_tick(chan, t);
+		} else if (chan->tx_status < 0) {
+			t = chan->tx_status;
 		}
 	}
 
diff --git a/include/linux/mailbox_controller.h b/include/linux/mailbox_controller.h
index 1db0069c27c52..e6af0721198b4 100644
--- a/include/linux/mailbox_controller.h
+++ b/include/linux/mailbox_controller.h
@@ -114,6 +114,7 @@ struct mbox_controller {
  * @txdone_method:	Way to detect TXDone chosen by the API
  * @cl:			Pointer to the current owner of this channel
  * @tx_complete:	Transmission completion
+ * @tx_status:		Transmission status
  * @active_req:		Currently active request hook
  * @msg_count:		No. of mssg currently queued
  * @msg_free:		Index of next available mssg slot
@@ -126,6 +127,7 @@ struct mbox_chan {
 	unsigned txdone_method;
 	struct mbox_client *cl;
 	struct completion tx_complete;
+	int tx_status;
 	void *active_req;
 	unsigned msg_count, msg_free;
 	void *msg_data[MBOX_TX_QUEUE_LEN];
-- 
2.53.0

