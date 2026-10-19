Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB2D612565;
	Mon, 19 Oct 2026 14:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418633; cv=none; b=ZP8RT2jq11J0IOhzXk72P/Txxmckw6W5thVEpzxn1LuL2GjyEtcFJUcGT1bhRlfUITog89o9ZxDG6cPRH82uJRO6v7hx03/EQKOyL3jxjjvfvN00rdqNdN21tK/ljAanz+ONZvoaxErjDVNPiNtI28nDiufiPZ52635VKWOReNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418633; c=relaxed/simple;
	bh=ZfxOOX3ej3q0mFdA/DyGaopJmYWIhBshTMlyYAqSVrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LQIMyI8mwT8qUldTdJLkKdPllx82TC17sx0EEqrLRARHq28mHXJlOVPQNr8ULEIN2taxnwZO2Gt46DTZC3tHYbHQ/xH9yB52/giW4lxwFuNWr3lGh0a3EeikaWMIP12vCEuHqBk1A388a7WIkE+iKVISeVUtoFHsIX589PZmqTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AfbQ1jl/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AfbQ1jl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9871F000C8;
	Mon, 19 Oct 2026 14:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418630;
	bh=Zev1xjlOxm+rYJyfpM2+m7m0Kp99smLd/rcxrOeHMJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AfbQ1jl/o4qP/jZWo2mhs761kp/rrE7UFJE2nUyJYR49lfzCVH6GLXTa4wCJDsUTC
	 qluVLQeW0ArMPelYgQGZmsJMeo4PncFNlGRAsts2gIru9hvehgsbelMm3ji0oU7GVT
	 uqmfW9CJDU3CoCTGkEBSqmdLBNhrXFwU9m1D+3ulYzb6PY2daa/1ZLPQBGWG2GAINU
	 Q6/81EmiOilXjcWmgkHkWMrtVh7Y17jGFuw2x6bv8qInhlxez2pK7JStXoxfdZU+V9
	 kpsM+IQ1V8QhL991hUTxVSIN+0MPnuYsPfknHaFPxCFgnfQ28KomCSpdGzgshEhvrn
	 Ha8peKpb+sI+A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ruoyu Wang <ruoyuw560@gmail.com>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	ping.cheng@wacom.com,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] HID: wacom: avoid copying Bluetooth input reports
Date: Mon, 19 Oct 2026 09:51:17 -0400
Message-ID: <20261019135441.1420968-386-sashal@kernel.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 8310cdeefc8a14d2093c3234b570c7805c20bcbf ]

wacom_intuos_bt_irq() duplicates the received Bluetooth report with
kmemdup() so that it can pass 10-byte input report payloads to the
common Intuos parser. The helper then copies each payload back into
wacom->data before calling wacom_intuos_irq().

Avoid the allocation and copy by temporarily pointing wacom->data at the
current 10-byte payload while the common parser runs, then restoring the
original report pointer. The Bluetooth report parser keeps using the
original report buffer for dispatch and battery parsing, while the common
parser sees the same payload bytes as before.

This also removes the unchecked kmemdup() result from the Bluetooth IRQ
path.

Suggested-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Vanilla 6.18.53 still has the unchecked `kmemdup(GFP_KERNEL)` in this
Bluetooth IRQ path. The rest of the walkthrough is below.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [HID: wacom] [avoid] [stop kmemdup/memcpy of Bluetooth Intuos
reports by switching the parser onto the live 10-byte payload]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Suggested-by: Jason Gerecke <jason.gerecke@wacom.com>
- Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com> (author)
- Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com> (Wacom driver
  maintainer)
- Signed-off-by: Jiri Kosina <jkosina@suse.com> (HID maintainer)
- Ignore: `[Upstream commit 8310cdeefc8a...]`, `Signed-off-by: Sasha
  Levin`
- No Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable (absence
  expected)

Notable: maintainer both suggested the approach and reviewed it.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `wacom_intuos_bt_irq()` `kmemdup()`s the Bluetooth report, then
  `wacom_intuos_bt_process_data()` `memcpy`s each 10-byte payload into
  `wacom->data` for `wacom_intuos_irq()`. The `kmemdup()` result is not
  checked.
- Symptom: NULL deref of `data[0]` if allocation fails; also an
  allocation+copy on every report.
- Version info: none in the message. The `kmemdup` itself was added
  later (see Phase 3).
- Root cause: the copy exists only so the shared Intuos parser can see a
  10-byte payload without destroying the packed Bluetooth report. The
  author replaces that with a temporary `wacom->data` pointer swap.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Yes. v1 on the list was explicitly `HID: wacom: handle kmemdup
failure in Bluetooth IRQ path` (NULL check). v2, at Jason Gerecke’s
request, removes the allocation instead. This is a crash fix written as
“avoid copying.”

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/hid/wacom_wac.c` (~5 insertions, 3 deletions; series
  mail said 8 lines)
- Functions: `wacom_intuos_bt_process_data()`, `wacom_intuos_bt_irq()`
- Scope: single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: `wacom_intuos_bt_irq()` does `data = kmemdup(wacom->data, len,
  GFP_KERNEL)` then `switch (data[0])`. Helper `memcpy(wacom->data,
  data, 10)` then `wacom_intuos_irq()`. `kfree(data)` at the end.
- After: `data = wacom->data`. Helper saves `wacom->data`, points it at
  the 10-byte slice, calls `wacom_intuos_irq()`, restores the original
  pointer.
- Path: HID input IRQ for `INTUOS4WL` (Wacom Intuos4 Wireless, USB ID
  0xBD), not probe/error-only.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: NULL deref on failed `kmemdup`; GFP_KERNEL allocation on the
  HID input IRQ path.
- Mechanism: `hid_irq_in()` (USB URB complete) →
  `hid_safe_input_report()` → `wacom_raw_event()` → `wacom_wac_irq()` →
  `wacom_intuos_bt_irq()`. `__hid_input_report()` uses `down_trylock()`
  because this can run in atomic context. `kmemdup(..., GFP_KERNEL)`
  there can sleep or return NULL; `switch (data[0])` then oopses. The
  pointer swap keeps the packed report intact without allocating.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Quality: small, equivalent for this device. `wacom_intuos_inout()` /
  `wacom_intuos_general()` / INTUOS4 pad parsing only read
  `data[0]`–`data[9]`. Restore of `wacom->data` is synchronous; nothing
  stashes the pointer.
- Regression risk: low-medium. Sashiko flagged unaligned
  `be16_to_cpup((__be16 *)&data[2])` because payloads start at offset
  1/11. Old `memcpy` landed those 10 bytes on the aligned URB buffer;
  the new pointer does not. Jason Gerecke treated that as non-blocking
  and asked for a later alignment cleanup. Intuos4 WL is a PC USB
  tablet, so strict-alignment ARM faults are unlikely. No API/data-
  structure change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Bluetooth packing/`memcpy` helper: 81af7e61a774e6 (Benjamin Tissoires,
  2014-08-06).
- `kmemdup`/`kfree`: 5e013ad206895e (“HID: wacom: Remove static
  WACOM_PKGLEN_MAX limit”, Jason Gerecke, 2025-03-03). That replaced a
  stack `unsigned char data[WACOM_PKGLEN_MAX]` + `memcpy`. First in
  v6.15 (in v6.15, not in v6.14). Present in this 6.18.53 tree.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Functionally this repairs 5e013ad206895e, which
is an ancestor of this tree.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- c8dc23c97680e “HID: wacom: fix out-of-bounds read in
  wacom_intuos_bt_irq” — length checks; already in v6.18.53.
- 74ec08f7b81c2 — Pro2 BT length validation, different function.
- Standalone; not patch x/y. No extra prereqs beyond the `kmemdup` code
  this tree already has.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Ruoyu Wang has this one wacom commit here. Jason Gerecke is the
Wacom maintainer and both introduced the `kmemdup` and reviewed this
fix.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None. Uses existing `wacom->data` / `wacom_intuos_irq()`.
Applies to v6.18.53 as written.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- Lore/msgid:
  https://patch.msgid.link/20260617072035.3373487-1-ruoyuw560@gmail.com
- v1 (2026-06-06):
  https://patch.msgid.link/20260606040344.4-1-ruoyuw560@gmail.com —
  NULL-check only.
- v2 (2026-06-17): pointer swap, as Jason asked.
- v1: Jason Reviewed-by + “do away with the kmemdup entirely.”
- v2: Sashiko unaligned-access warning; Jason: do not block; wants a
  later alignment cleanup; Reviewed-by.
- Jiri Kosina: “Applied, thanks.”
- No NAK. No reviewer Cc: stable.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: To/Cc: Ping Cheng, Jason Gerecke, Jiri Kosina, Benjamin
Tissoires, linux-input, linux-kernel. Jason reviewed; Jiri applied.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No Reported-by / bugzilla / syzbot. Found by code review of the
unchecked `kmemdup`.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: v1→v2 of one patch, not a multi-commit series. Related OOB fix
already in this tree.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: UNVERIFIED — lore.kernel.org/stable returned 403. b4 thread has
no stable discussion.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `wacom_intuos_bt_process_data()`, `wacom_intuos_bt_irq()`.

Step 5.2: TRACE CALLERS
Record:
- `wacom_intuos_bt_irq()` ← `wacom_wac_irq()` case `INTUOS4WL`
  (`drivers/hid/wacom_wac.c`).
- `wacom_wac_irq()` ← `wacom_raw_event()` (`wacom_sys.c`).
- USB: `hid_irq_in()` (`drivers/hid/usbhid/hid-core.c`) calls
  `hid_safe_input_report()` from URB complete (atomic/softirq).
- Bluetooth HIDP: `hidp_process_report()` from the l2cap/session path
  (process context). This device is USB ID 0xBD, so the USB IRQ path is
  the one that matters.
- Device table: `wacom_features_0xBD` / “Wacom Intuos4 WL”.

Step 5.3: TRACE CALLEES
Record: `wacom_intuos_irq()` → pad/inout/general parsers;
`wacom_notify_battery()`; `input_sync()`. No alloc after the change.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Reachable from normal USB HID input of Intuos4 Wireless.
Unprivileged userspace is not required; hardware input is enough. Not a
syscall fuzzer path.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Pro2 BT (`wacom_intuos_pro2_bt_irq`) does not `kmemdup`. This
packed 10-byte copy was unique to Intuos4 WL.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Local tree: 6.18.53 (`autosel`,
`v6.18.53-5049-g0f0bdc2b0dffb`). `v6.18.53:drivers/hid/wacom_wac.c`
still has `kmemdup` + `memcpy` + unchecked `data[0]`. Upstream fix
8310cdeefc8a is not an ancestor of v6.18.53.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. Surrounding OOB length checks are already in
6.18.53.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: OOB length checks yes. No earlier version of this pointer-
swap/NULL-check.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: HID / Wacom tablet driver. IMPORTANT for tablet users,
PERIPHERAL overall (one 2010-era wireless Intuos4 model).

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Active (device IDs, BT OOB fixes, pktlen work). The `kmemdup` is
from the v6.15 pktlen change, not ancient code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific — Intuos4 Wireless (`INTUOS4WL`, USB
0x056A:0x00BD).

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Every packed BT/WL input report allocates. Oops if `kmemdup`
fails; GFP_KERNEL from USB complete is illegal even when the alloc hits
the slab cache. Not a userspace-triggered security hole.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: NULL deref → oops (HIGH). GFP_KERNEL from URB complete →
sleeping-in-atomic WARN/instability (HIGH). Practical hit rate is low
(small alloc, old device), but the bug is on the live input path.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: medium — real IRQ-path crash/atomic-sleep fix, small user
  population.
- Risk: low — ~8 lines, maintainer-reviewed; unaligned `be16_to_cpup` is
  the main caveat and was accepted upstream.
- Ratio: benefit outweighs risk for 6.18.y.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Unchecked `kmemdup` NULL deref in this 6.18.53 tree.
- GFP_KERNEL on USB HID URB complete; 5e013ad replaced an atomic-safe
  stack buffer.
- v1 was an explicit crash fix; v2 is the maintainer-preferred form.
- Reviewed by Jason Gerecke, applied by Jiri Kosina.
- Small, no new API, applies cleanly, parsers only use 10 payload bytes.

AGAINST:
- Niche Intuos4 Wireless hardware.
- No user/syzbot report.
- Subject reads like an optimization.
- Unaligned access vs old memcpy-to-aligned-buffer; no follow-up
  alignment patch verified here.

UNRESOLVED:
- No stable@ thread (lore 403).
- No evidence of a field oops.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — pointer save/restore; Wacom
   maintainer Reviewed-by.
2. Fixes a real bug that affects users? PASS — NULL deref and GFP_KERNEL
   in IRQ on a shipping device path.
3. Important issue? PASS — oops / sleeping-in-atomic (HIGH), not a style
   cleanup.
4. Small and contained? PASS — one file, ~8 lines.
5. No new features or APIs? PASS.
6. Can apply to the local tree? PASS — buggy code is in v6.18.53; patch
   matches.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary bugfix.

Step 9.4: MAKE YOUR DECISION
This belongs on 6.18.53. The tree still does `kmemdup(..., GFP_KERNEL)`
in `wacom_intuos_bt_irq()` and dereferences `data[0]` with no NULL
check, on the USB HID complete path. Replacing that with a temporary
`wacom->data` pointer is the same fix the maintainer asked for, and it
applies here without extra commits.

Verification:
- [Phase 1] Tags: Suggested-by/Reviewed-by Jason Gerecke, SOB Ruoyu Wang
  and Jiri Kosina; no Fixes/Reported-by/Cc: stable
- [Phase 1] v1 subject from b4: “handle kmemdup failure in Bluetooth IRQ
  path”
- [Phase 2] Diff: drop kmemdup/kfree/memcpy; save/restore `wacom->data`
  around `wacom_intuos_irq()`
- [Phase 2] Parsers for INTUOS4WL use `data[0]`–`data[9]` only
  (inout/general/pad)
- [Phase 3] Blame: kmemdup from 5e013ad206895e (v6.15+); in HEAD and
  v6.18.53
- [Phase 3] `git merge-base --is-ancestor 5e013ad206895e v6.18.53` →
  yes; `8310cdeefc8a` → no
- [Phase 3] Related OOB fix c8dc23c97680e already in v6.18.53
- [Phase 4] `b4 dig -c 8310cdeefc8a` → v1+v2 msgid links; Jason reviewed
  both; Jiri applied v2
- [Phase 4] Sashiko unaligned warning; Jason said do not block
- [Phase 4] lore.kernel.org WebFetch 403; stable@ search UNVERIFIED
- [Phase 5] Call chain: `hid_irq_in` → `hid_safe_input_report` →
  `wacom_raw_event` → `wacom_intuos_bt_irq`; USB 0xBD Intuos4 WL
- [Phase 6] `git describe HEAD` → v6.18.53-5049-g0f0bdc2b0dffb; `make
  kernelversion` → 6.18.53
- [Phase 6] `git show v6.18.53:drivers/hid/wacom_wac.c` still has
  kmemdup
- [Phase 8] Failure: NULL deref / GFP_KERNEL from URB complete; severity
  HIGH
- UNVERIFIED: whether this was already requested on stable@

**YES**

 drivers/hid/wacom_wac.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index af76e49fd0f25..8feb8027be95e 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1192,8 +1192,11 @@ static int int_dist(int x1, int y1, int x2, int y2)
 static void wacom_intuos_bt_process_data(struct wacom_wac *wacom,
 		unsigned char *data)
 {
-	memcpy(wacom->data, data, 10);
+	u8 *saved_data = wacom->data;
+
+	wacom->data = data;
 	wacom_intuos_irq(wacom);
+	wacom->data = saved_data;
 
 	input_sync(wacom->pen_input);
 	if (wacom->pad_input)
@@ -1202,7 +1205,7 @@ static void wacom_intuos_bt_process_data(struct wacom_wac *wacom,
 
 static int wacom_intuos_bt_irq(struct wacom_wac *wacom, size_t len)
 {
-	u8 *data = kmemdup(wacom->data, len, GFP_KERNEL);
+	u8 *data = wacom->data;
 	int i = 1;
 	unsigned power_raw, battery_capacity, bat_charging, ps_connected;
 
@@ -1242,7 +1245,6 @@ static int wacom_intuos_bt_irq(struct wacom_wac *wacom, size_t len)
 		break;
 	}
 
-	kfree(data);
 	return 0;
 }
 
-- 
2.53.0

