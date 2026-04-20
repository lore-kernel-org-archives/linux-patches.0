Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E11D3B3BF4;
	Mon, 20 Apr 2026 13:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691008; cv=none; b=ha90zNdL22EoGQ3kFks+ebOImToHkwi12rmJ9SXFyRuH6ztw3eUs64hhlEQ8dwNXI1IkkAhF+9vUv9q9QcMK44pFnMa0aRXkwGIDWCjySXexWPHErUJjmBQc+VF+sAM3phwnDR9SA/7M4Se6PdPMFMbg9IZjyt/RwA6mxLZK8wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691008; c=relaxed/simple;
	bh=gNoPHLTzLSHP/u4qNCTb11g14KhSXkf/SUU7ZM0A0fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LrA1/TaRMntCXLDanu2+JnrSr8TgPoFvfJK0H+3BdAjiz9vg6Q8PQqBlZayDVRNiegULiwiAvL1sCWpj0Wp33M9sjQ6+vOaenWAuAFalBZDlZ4V+kAl2BJxRWg4Y8/7klScM1FhUDbkOMo9hInEyDbPX1G4pZ5WHGey8+mnvHvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uP9Rcf1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uP9Rcf1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB63C19425;
	Mon, 20 Apr 2026 13:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691008;
	bh=gNoPHLTzLSHP/u4qNCTb11g14KhSXkf/SUU7ZM0A0fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uP9Rcf1cPXITWjO0cXgPkcUF9ghG0vptRgstt0vXQFDTFth9Rp2qHCbFvHr0xNCz/
	 bO5oZsvsTgyR8rb36kbMvYOSs3RaU9BUGQDamiB16gDkNZHS8OiGVzR+nTGiBN/q19
	 VquL+5OeAYCdDOYSUpPiBz3YnxdYuYGBS0r379dg5CZdgIzmNRIKe6spI9mgNd2r+p
	 5LqwcquxoXEc8RBzf1kfGFqF2qT/mlaxMIHSayFqTLONG747XG0Dm42BOX2Y/Z/AJZ
	 Pm4sGx/A80D0FyKULaMs3e9/YZ+R5nLHhny7wC2eK+W/ogpaHcHbw2AQ5IpgeO5EyR
	 0pdnv3/OjKYIg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] HID: logitech-hidpp: fix race condition when accessing stale stack pointer
Date: Mon, 20 Apr 2026 09:08:26 -0400
Message-ID: <20260420131539.986432-40-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Benoît Sevens <bsevens@google.com>

[ Upstream commit e2aaf2d3ad92ac4a8afa6b69ad4c38e7747d3d6e ]

The driver uses hidpp->send_receive_buf to point to a stack-allocated
buffer in the synchronous command path (__do_hidpp_send_message_sync).
However, this pointer is not cleared when the function returns.

If an event is processed (e.g. by a different thread) while the
send_mutex is held by a new command, but before that command has
updated send_receive_buf, the handler (hidpp_raw_hidpp_event) will
observe that the mutex is locked and dereference the stale pointer.

This results in an out-of-bounds access on a different thread's kernel
stack (or a NULL pointer dereference on the very first command).

Fix this by:
1. Clearing hidpp->send_receive_buf to NULL before releasing the mutex
   in the synchronous command path.
2. Moving the assignment of the local 'question' and 'answer' pointers
   inside the mutex_is_locked() block in the handler, and adding
   a NULL check before dereferencing.

Signed-off-by: Benoît Sevens <bsevens@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to make a thorough analysis. Let me
compile my findings.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Parse Subject Line**
- Record: Subsystem `HID: logitech-hidpp`, action verb `fix`, summary:
  race condition when accessing stale stack pointer (clear bug fix).

**Step 1.2: Parse Tags**
- Record: `Signed-off-by: Benoît Sevens <bsevens@google.com>` (author)
  and `Signed-off-by: Jiri Kosina <jkosina@suse.com>` (HID subsystem
  maintainer). No Reported-by/Link/Fixes tags. No stable tag. Author is
  a known Google security researcher (has other HID UAF/OOB fixes in
  roccat and wacom).

**Step 1.3: Analyze Body**
- Record: Bug description: `hidpp->send_receive_buf` is assigned to
  point at a stack-allocated response buffer inside
  `__do_hidpp_send_message_sync()` but never cleared when the function
  returns. Meanwhile `hidpp_raw_hidpp_event()` speculatively reads this
  pointer whenever `send_mutex` is locked. The race:
  1. Thread A finishes a command; leaves `send_receive_buf` pointing at
     A's stack.
  2. Thread B grabs `send_mutex`; there is a window before B writes
     `send_receive_buf = response`.
  3. Event handler fires (different thread), sees the mutex locked,
     dereferences the stale pointer from A's stack. The handler even
     performs `*answer = *report` — a WRITE to the stale stack pointer
     using device-supplied data (potential stack corruption / info leak
     / exploit primitive).
  4. On very first use, `send_receive_buf` is NULL → NULL deref.
     Symptom: OOB stack access on a different thread or NULL deref on
     first command.

**Step 1.4: Hidden Bug Detection**
- Record: Not hidden — commit title already says "fix race condition".
  Classic race + UAF/stale-pointer bug.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Record: One file changed (`drivers/hid/hid-logitech-hidpp.c`), +17/-7
  lines. Two functions touched: `__do_hidpp_send_message_sync()` and
  `hidpp_raw_hidpp_event()`. Classification: single-file surgical fix.

**Step 2.2: Code Flow Change**
- Record: Producer (`__do_hidpp_send_message_sync`): early returns
  converted to `goto out`, new `out:` label clears
  `hidpp->send_receive_buf = NULL` before returning. Consumer
  (`hidpp_raw_hidpp_event`): `question/answer` assignments moved inside
  the `mutex_is_locked()` block, plus `if (!question) return 0;` NULL
  guard before use.

**Step 2.3: Bug Mechanism**
- Record: Category (b)+(d) — race / memory safety fix. Adds implicit
  synchronization by ensuring the shared pointer is NULL'd while still
  holding `send_mutex`, and adds a NULL check on the read side to close
  the small window between mutex acquisition and pointer assignment.
  Addresses two failure modes: stale stack pointer dereference (UAF of
  stack memory) and NULL dereference on first use.

**Step 2.4: Fix Quality**
- Record: Obviously correct. Minimal. No new locks, no API/ABI changes.
  Possible (extremely minor) regression risk: if a report raced in
  between `mutex_lock` and the assignment, the early-out `return 0` will
  now skip matching it against the question — but this was already
  broken (it used a stale pointer) and the send path has a 5-second
  timeout with retry, so the benign behavior is strictly safer. No
  regression risk beyond that.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- Record: The stale-pointer pattern (`hidpp->send_receive_buf =
  response;` and the speculative read `struct hidpp_report *question =
  hidpp->send_receive_buf;`) dates to commit `2f31c52529103d` "HID:
  Introduce hidpp" by Benjamin Tissoires, Sep 2014 (≈ v3.18). Bug is
  therefore present in every stable tree from v3.18 through
  v6.19/mainline.

**Step 3.2: Fixes: tag**
- Record: No `Fixes:` tag in the commit. Manually identified introducing
  commit as `2f31c52529103d` (original driver introduction, 2014).

**Step 3.3: Related Changes to the File**
- Record: Recent file history shows actively maintained file (device ID
  adds, quirks, other UAF fix `f7a4c78b` "Prevent use-after-free on
  force feedback initialisation failure"). Function was split into
  `__do_hidpp_send_message_sync`/`hidpp_send_message_sync` in
  `60165ab774cb0c` (v6.7, Jul 2023). Before that split (v6.6 is the
  earliest with `__do_hidpp_send_message_sync`), the logic lived inline
  in `hidpp_send_message_sync`.

**Step 3.4: Author's Other Commits**
- Record: Benoît Sevens (Google) has prior HID security fixes:
  `d802d848` (roccat UAF), `2f1763f6` (wacom OOB), plus similar fixes in
  uvcvideo and ALSA. Consistent pattern of Google-originated kernel
  security research. High trust.

**Step 3.5: Dependencies**
- Record: Self-contained, no prerequisites. Fix only touches one file
  and two functions. For v6.1.y and older the function was not yet
  split, so the fix requires trivial rewording to apply (move the NULL-
  out before `mutex_unlock` in `hidpp_send_message_sync`), but the
  change is mechanical.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original Discussion**
- Record: `b4 dig -c e2aaf2d3ad92a` found the thread at https://lore.ker
  nel.org/all/20260401144811.1242722-1-bsevens@google.com/. Only one
  version (v1) was posted; no review-imposed revisions.

**Step 4.2: Reviewers**
- Record: `b4 dig -w`: patch CC'd `Filipe Laíns`, `Bastien Nocera`,
  `Jiri Kosina`, `Benjamin Tissoires`, linux-input, linux-kernel — all
  the correct maintainers. Merged by Jiri Kosina (subsystem maintainer)
  with note: "Now applied. Benjamin had some ideas on further cleanup
  (allocating with __free__ instead of using stack pointer), but that'd
  be a little bigger cleanup, so let's keep that separate." Confirms
  maintainer reviewed and accepted; any follow-up is an orthogonal
  cleanup, not a fix correction.

**Step 4.3: Bug Reports**
- Record: No Reported-by or Link tags. Author is from Google — likely
  discovered via internal audit/fuzzing. No public reproducer cited.

**Step 4.4: Related Series**
- Record: Single standalone patch, no series.

**Step 4.5: Stable ML**
- Record: Not searched; the patch was only posted April 1, 2026 and
  applied soon after — too fresh for independent stable ML activity.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Functions**
- Record: `__do_hidpp_send_message_sync` (producer) and
  `hidpp_raw_hidpp_event` (consumer).

**Step 5.2: Callers**
- Record: 45 call sites for `hidpp_send_*_sync` inside the driver —
  every HID++ query (battery, connect, feature discovery, probe,
  get_report_length, etc.). `hidpp_raw_hidpp_event` is invoked from
  `hidpp_raw_event` (registered as `.raw_event` in `hid_ll_driver`),
  reached from the HID core for every HID report coming from any
  Logitech HID++ device (receivers, mice, keyboards, touchpads). Both
  paths fire during normal operation — not rare.

**Step 5.3: Callees**
- Record: Sync path calls `__hidpp_send_report()` (USB/Bluetooth
  transmit) and `wait_event_timeout()`. Event path does a struct-copy
  `*answer = *report` — this is the dangerous write when `answer` is
  stale.

**Step 5.4: Reachability**
- Record: The sync path runs in process context (probe, sysfs,
  workqueue). The event path runs from HID input processing (URB
  completion / BT callback, softirq or kthread depending on transport).
  Different contexts on different CPUs → true concurrent race possible.
  Triggers do not require privilege — any HID++ device that sends
  unsolicited reports while a command is in flight can race. This is the
  normal mode of operation for hidpp devices (connect events, battery
  notifications, keypresses).

**Step 5.5: Similar Patterns**
- Record: Only one occurrence of `send_receive_buf` in the file; pattern
  is unique to this driver.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable**
- Record: Verified via `git show <tag>:drivers/hid/hid-logitech-hidpp.c`
  that the exact same vulnerable pattern (`send_receive_buf = response`
  without clearing, `question = hidpp->send_receive_buf` read without
  NULL check) exists in v4.19, v5.4, v5.10, v5.15, v6.1, v6.6. All
  active stable trees are affected.

**Step 6.2: Backport Complications**
- Record: v6.6+ (and mainline): patch applies cleanly — identical
  function structure. v6.1 and earlier: `__do_hidpp_send_message_sync`
  does not yet exist; the logic is inline in `hidpp_send_message_sync`
  which also holds/releases `send_mutex`. Backport requires mechanically
  placing `hidpp->send_receive_buf = NULL;` before
  `mutex_unlock(&hidpp->send_mutex)` in `hidpp_send_message_sync`, and
  applying the event-handler hunk unchanged. Straightforward for the
  stable maintainers.

**Step 6.3: Related Fixes in Stable**
- Record: No prior independent fix for this specific race is in stable.
  Unrelated recent fixes (force-feedback UAF `f7a4c78b`) target other
  paths.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Criticality**
- Record: Subsystem: `drivers/hid/` HID++ Logitech driver. Logitech
  Unifying receivers/MX mice/keyboards are ubiquitous on laptops and
  desktops; the driver ships on most distributions. Classification:
  IMPORTANT (wide hardware user base), not CORE.

**Step 7.2: Activity**
- Record: Actively developed — multiple merges per release cycle (device
  IDs, quirks, bug fixes). Mature core codepaths in the driver have been
  stable for years.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who Is Affected**
- Record: Anyone with a Logitech HID++ device (mice, keyboards,
  receivers, presenters) using the in-tree driver. Essentially most
  laptop users with Logitech peripherals. Driver-specific but very
  widespread hardware.

**Step 8.2: Trigger Conditions**
- Record: Requires concurrent activity: one thread invoking a sync
  command while the device sends an asynchronous report. Races happen
  during connect/disconnect, battery reporting, feature queries. The
  very-first-use path yields NULL deref (no concurrency needed: any
  async event before any sync command completes once) — but that path is
  rare because probe typically drives the first sync command before any
  report arrives. Attacker plane: a malicious or faulty HID device can
  flood reports to widen the window — reachable from device-trust
  boundary, relevant for BadUSB-style threat models.

**Step 8.3: Failure Mode Severity**
- Record: (a) NULL pointer dereference → kernel oops (CRITICAL: crash).
  (b) Stale stack pointer read → OOB read (HIGH: info leak). (c) Stale
  stack pointer WRITE via `*answer = *report` using device-controlled
  data → stack corruption on an unrelated thread (CRITICAL: memory
  corruption, potential privilege escalation/exploit primitive). Overall
  severity: CRITICAL.

**Step 8.4: Risk/Benefit**
- Record: Benefit HIGH — closes a long-standing race with
  crash/corruption potential in a widely-deployed driver. Risk LOW —
  24-line surgical change, no new locking, no API change, reviewed and
  applied by subsystem maintainer, only risk is a missed-answer timeout
  that already has retry logic and a 5-second wait. Ratio clearly favors
  backporting.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**
- FOR: Fixes real race/UAF/NULL-deref, very widespread hardware, small
  and surgical, author has security-fix track record, applied by
  subsystem maintainer, bug is 10+ years old (present in every active
  stable), failure modes include potential stack corruption from device-
  controlled data (security-relevant).
- AGAINST: No Reported-by/Fixes/Cc: stable tag; no public reproducer;
  for older stables (≤v6.1) a trivial mechanical adaptation is needed
  because the function was later split.
- UNRESOLVED: Exact kernel trigger rate in the wild is not documented;
  CVE status unknown.

**Step 9.2: Stable Rules**
1. Obviously correct & tested? Yes — tiny, mechanical; applied by
   maintainer.
2. Fixes real bug? Yes — race + stale/NULL pointer deref with concrete
   failure modes.
3. Important? Yes — kernel oops and potential stack corruption.
4. Small & contained? Yes — 24 lines, one file, two functions.
5. No new features/APIs? Correct — pure fix.
6. Applies to stable? v6.6+: clean. ≤v6.1: needs trivial adaptation.

**Step 9.3: Exceptions**
- Not an exception category; qualifies on normal bug-fix merit.

**Step 9.4: Decision**
- The commit is a textbook stable candidate: small, targeted race fix in
  a broadly used driver, repairing a NULL-deref + stale-pointer write
  that a faulty/malicious device can provoke.

### Verification

- [Phase 1] Read full commit message — no Fixes/Reported-by/Cc: stable
  tags; identified bug description and two-step fix.
- [Phase 2] Read diff end-to-end; confirmed +17/-7 in one file, two
  functions, classic NULL-out + NULL-check pattern with `goto out`.
- [Phase 3] `git blame` on both functions: pattern dates to
  `2f31c52529103d` (2014, v3.18). Split into
  `__do_hidpp_send_message_sync` at `60165ab774cb0c` (v6.7).
- [Phase 3] `git log --oneline -- drivers/hid/hid-logitech-hidpp.c`:
  file is actively maintained.
- [Phase 3] `git log --oneline --author="Benoit Sevens\|Benoît Sevens"`:
  confirmed author's pattern of HID/UVC/ALSA security fixes.
- [Phase 4] `b4 dig -c e2aaf2d3ad92a`: found lore thread at `https://lor
  e.kernel.org/all/20260401144811.1242722-1-bsevens@google.com/`.
- [Phase 4] `b4 dig -w`: confirmed CC list includes Jiri Kosina,
  Benjamin Tissoires, Filipe Laíns, Bastien Nocera, linux-input, linux-
  kernel.
- [Phase 4] `b4 dig -a`: only v1 was posted; no further revisions.
- [Phase 4] Read `/tmp/hidpp_race.mbox`: confirmed maintainer Jiri
  Kosina's "Now applied" reply and note about deferred cleanup idea from
  Benjamin Tissoires.
- [Phase 5] `rg send_receive_buf`: confirmed only 4 references (struct
  member + 1 write + 2 reads), no other use sites.
- [Phase 5] Read `hidpp_raw_event` caller: confirmed registered as
  `.raw_event` and called for every HID++ short/long/very-long report
  from the device.
- [Phase 6] `git show vX:drivers/hid/hid-logitech-hidpp.c` for v4.19,
  v5.4, v5.10, v5.15, v6.1, v6.6: verified vulnerable pattern exists in
  every stable tree.
- [Phase 6] Verified `__do_hidpp_send_message_sync` only exists from
  v6.6 onward; older trees need trivial adaptation of the producer hunk.
- [Phase 8] Reviewed event handler body: `*answer = *report` is a write,
  confirming the stack-corruption / write-primitive aspect (not merely
  an info leak).
- UNVERIFIED: Whether a CVE was assigned; whether a public reproducer
  exists; exact in-wild trigger rate.

The fix is small, surgical, reviewed by the HID maintainer, repairs a
long-standing race with crash and stack-corruption consequences
affecting extremely common Logitech hardware, and backports cleanly to
recent stables with only a mechanical adjustment needed for older ones.

**YES**

 drivers/hid/hid-logitech-hidpp.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 5f63f1d2303a0..b1330d23bd2d0 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -306,21 +306,22 @@ static int __do_hidpp_send_message_sync(struct hidpp_device *hidpp,
 	if (ret) {
 		dbg_hid("__hidpp_send_report returned err: %d\n", ret);
 		memset(response, 0, sizeof(struct hidpp_report));
-		return ret;
+		goto out;
 	}
 
 	if (!wait_event_timeout(hidpp->wait, hidpp->answer_available,
 				5*HZ)) {
 		dbg_hid("%s:timeout waiting for response\n", __func__);
 		memset(response, 0, sizeof(struct hidpp_report));
-		return -ETIMEDOUT;
+		ret = -ETIMEDOUT;
+		goto out;
 	}
 
 	if (response->report_id == REPORT_ID_HIDPP_SHORT &&
 	    response->rap.sub_id == HIDPP_ERROR) {
 		ret = response->rap.params[1];
 		dbg_hid("%s:got hidpp error %02X\n", __func__, ret);
-		return ret;
+		goto out;
 	}
 
 	if ((response->report_id == REPORT_ID_HIDPP_LONG ||
@@ -328,10 +329,14 @@ static int __do_hidpp_send_message_sync(struct hidpp_device *hidpp,
 	    response->fap.feature_index == HIDPP20_ERROR) {
 		ret = response->fap.params[1];
 		dbg_hid("%s:got hidpp 2.0 error %02X\n", __func__, ret);
-		return ret;
+		goto out;
 	}
 
-	return 0;
+	ret = 0;
+
+out:
+	hidpp->send_receive_buf = NULL;
+	return ret;
 }
 
 /*
@@ -3843,8 +3848,7 @@ static int hidpp_input_configured(struct hid_device *hdev,
 static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
 		int size)
 {
-	struct hidpp_report *question = hidpp->send_receive_buf;
-	struct hidpp_report *answer = hidpp->send_receive_buf;
+	struct hidpp_report *question, *answer;
 	struct hidpp_report *report = (struct hidpp_report *)data;
 	int ret;
 	int last_online;
@@ -3854,6 +3858,12 @@ static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
 	 * previously sent command.
 	 */
 	if (unlikely(mutex_is_locked(&hidpp->send_mutex))) {
+		question = hidpp->send_receive_buf;
+		answer = hidpp->send_receive_buf;
+
+		if (!question)
+			return 0;
+
 		/*
 		 * Check for a correct hidpp20 answer or the corresponding
 		 * error
-- 
2.53.0

