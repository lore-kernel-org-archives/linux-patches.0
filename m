Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D8E5AE45A;
	Mon, 19 Oct 2026 14:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418421; cv=none; b=X0rTkc4YknWxQXd88gY1kJoyb8W7wb0Oxm911rv2zyPM3QBKhE/gII4GGbwaoVV8F4puOgljspGYDgdzwbv8dx89eyB9o6yJ++LaLEtSSeOjY6c6hOsO/mJudOWZwUjhU5UvqUOy14vboQWj6vLcyOyxUdtoQ/IQjB07ex/EO5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418421; c=relaxed/simple;
	bh=ohiKVwGBW/HgW6cAQ5hSeVvxlF41FUTYLFZTrr4qzts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dBFhESr164TFQxDoG4Dvwretr2emx/xQqekaHwMOeK8Crt6Alj2faxBGfs5qa1ZzoUZbmcXfzLm7oMXH+1z6+uVa+ojuUdhq5CE5WTdDvx9crZ5oIVLO6+Dtbu0mglXEqy3Rq3w3/o7WirIWepN4D+b+eAL/zBYBmj88q2fj/pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L9qzc92O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L9qzc92O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764E01F000C8;
	Mon, 19 Oct 2026 14:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418418;
	bh=h2Hvcgw2hUlCTkHyOGDzv+fTQQzBzyg8RgPkqOcqH0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9qzc92OcHPAzDvoOtczAiin1vXpArIROmusk4KyHgmApiCQHIsDsZLuGsDZJf+Jw
	 8oTZyvJMe32gGoq+z1HEWk1l0C+F8Z1GEWEjJPwQYTZcUJNjjP2OfxQSlb6iFAyKnk
	 t+2fiyciV1YFHokjLUT82ykJIfP1vxO1XvvrlzkqdQeboa4n2LmLwpMy7xARDSClwX
	 UYkLSNYrSo8BTax7t4Q86nTUvdfQ7KqLQWyx/a6eOPBosUxnM2Uu+gPB7nCH+lTofA
	 +/prvhreMdIKk0MKbrAMoQCY36aUJ88m8QnHJPsh9g+lFfNr2kmXQjFIQv6qCVK56j
	 TQrKAOGQJazqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wahid Khan <wahidzk0091@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Zhang Lixu <lixu.zhang@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] HID: intel-ish-hid: ignore post-init ENUM_DEVICES from firmware
Date: Mon, 19 Oct 2026 09:48:46 -0400
Message-ID: <20261019135441.1420968-235-sashal@kernel.org>
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

From: Wahid Khan <wahidzk0091@gmail.com>

[ Upstream commit f3f3f6df05226dfa220c4e603310dae94595060a ]

Some ISH firmware versions (observed on Tiger Lake LP, 8086:a0fc,
GUID {33AECD58-B679-4E54-9BD9-A04D34F0C226}) periodically re-send an
unsolicited HOSTIF_DM_ENUM_DEVICES response roughly every 79 seconds.

The current guard collapses two distinct cases into one condition:

  if (!(response_flag) || init_done)  ->  bad packet + ish_hw_reset

This incorrectly treats a valid post-init firmware announcement as a
corrupted packet, triggering an ISH soft-reset and a full ISHTP
re-initialisation cycle on each occurrence (~1100 times per day on
affected hardware).

Split the check: reject messages with no response flag as before, but
simply discard valid ENUM_DEVICES messages that arrive after init is
complete.

Signed-off-by: Wahid Khan <wahidzk0091@gmail.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Tested-by: Zhang Lixu <lixu.zhang@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **5.15.221** (`pending-5.15`,
`p-5.15-2-g9a29d9b0f9507`). The buggy `HOSTIF_DM_ENUM_DEVICES` /
`init_done` reset guard is present here and matches the patch, so this
is a decision for this tree only.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[HID/intel-ish-hid] [ignore] discard post-init ENUM_DEVICES
from firmware instead of treating them as bad packets**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Fixes: **none** (expected for this review pipeline)
- Reported-by: **none**
- Tested-by: Zhang Lixu \<lixu.zhang@intel.com\> (Intel; independent of
  the author)
- Acked-by: Srinivas Pandruvada \<srinivas.pandruvada@linux.intel.com\>
  (ISH maintainer)
- Reviewed-by: **none**
- Link: **none**
- Cc: stable: **none** (expected)
- Signed-off-by: Wahid Khan (author); Jiri Kosina (HID maintainer,
  applied the patch)
- Ignore: any Sasha Levin SOB / `[Upstream commit ...]` (pipeline)

Notable: maintainer Ack + Intel Tested-by + HID maintainer SOB.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Some ISH firmware (Tiger Lake LP, PCI `8086:a0fc`, HID GUID
  `{33AECD58-B679-4E54-9BD9-A04D34F0C226}`) periodically resends a valid
  `HOSTIF_DM_ENUM_DEVICES` **response** about every 79 seconds after
  init.
- **Symptom:** The driver treats that as a bad packet, calls
  `ish_hw_reset()`, and fully re-inits ISHTP. About **1100 times per
  day**.
- **Root cause:** One condition folds “no response flag” and `init_done`
  together:
  `if (!(response_flag) || init_done) -> bad packet + ish_hw_reset`
- **Fix:** Keep rejecting messages with no response flag; drop valid
  post-init ENUM_DEVICES.
- **Versions:** Observed on TGL LP; no kernel-version bound in the
  message.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not a hidden fix.** Explicit firmware-quirk / incorrect-error-
handling fix. “Ignore” here is the workaround, not cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/hid/intel-ish-hid/ishtp-hid-client.c` only
- Scope: **+3 / -2** in `process_recv()`, `HOSTIF_DM_ENUM_DEVICES` case
- Classification: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** Any ENUM_DEVICES with no response bit **or**
  `client_data->init_done` increments `bad_recv_cnt`, logs via
  `report_bad_packet()`, and calls `ish_hw_reset()`.
- **After:** No response bit still resets. If the response bit is set
  and `init_done` is true, the handler `break`s (discard). Pre-init
  responses still enumerate devices.
- Path: receive path after probe succeeds (`init_done = 1` at the end of
  `hid_ishtp_cl_init()`).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** hardware/firmware workaround + logic/correctness
- **Mechanism:** Firmware sends a valid post-init ENUM_DEVICES
  **response**. The driver wrongly classifies it as corruption and
  resets the ISH PCI function.
- Header check: `CMD_MASK` is `0x7F`, `IS_RESPONSE` is `0x80`.
  `!(recv_msg->hdr.command & ~CMD_MASK)` means “bit 7 not set” (request,
  not response). That part is unchanged.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct relative to the described firmware behavior: stop
  resetting on a valid response after init.
- Minimal; no API/data-structure change.
- Regression risk: **low**. Post-init ENUM_DEVICES were never processed
  as enumeration; they only caused reset+reinit. Discarding them avoids
  the reset storm. Genuine hotplug would use `HOSTIF_DM_ADD_DEVICE`
  (command 34), which this patch does not touch.
- GET_HID_DESCRIPTOR / GET_REPORT_DESCRIPTOR still use the old
  `init_done` reset. That is out of scope; the commit only claims
  ENUM_DEVICES is resent.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Combined guard introduced in `0b28cb4bcb17dc` (2016-08-17) **HID:
  intel-ish-hid: ISH HID client driver** — original driver.
- `ish_hw_reset()` in that path: `29b06d12ba796a` (2019) **Use the new
  interface functions in HID ish client**.
- Present in this tree from the beginning of intel-ish-hid. Not a recent
  mainline-only bug.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Bug is in original 2016 client driver, which
**is** an ancestor of HEAD (`git merge-base --is-ancestor 0b28cb4bcb17dc
HEAD`).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- `d21497331b967` already in this tree: **Reset enum_devices_done before
  enumeration**. Same failure mode (`init_done` + ENUM_DEVICES →
  `ish_hw_reset`) on S3/S4 when there are 0 sensors. Different trigger
  (stale `enum_devices_done`), complementary, **not** a substitute for
  this patch.
- Not a numbered series (`X/Y`). Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Wahid Khan has **no** prior commits in this tree under
`drivers/hid/`. Weight comes from Srinivas Ack, Zhang Tested-by, Jiri
Kosina SOB. Srinivas is listed in MAINTAINERS for INTEL INTEGRATED
SENSOR HUB DRIVER.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: **None.** Touches existing `process_recv` / `init_done` /
`CMD_MASK`. No new helpers. A later “clamp HID device count” patch
(openwall, 2026-07-30) is independent and not required.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- v1: 2026-06-27, https://ratatoskr.run/linux-input/2026/06/17183853 —
  same diff; SOB was `Wahid` (incomplete).
- v2: 2026-07-20, https://ratatoskr.run/linux-input/2026/07/17285763 —
  changelog: “added proper sign off”. **No code change.**
- Thread listing also shows Srinivas replies on 2026-06-29.
- `b4 dig -c 13054abbaa4f...` was the wrong SHA (hid.git SID from a
  search snippet); lore is behind Anubis (403/PoW). **UNVERIFIED:** full
  text of Srinivas’s replies.
- Committed version is v2 plus Acked-by / Tested-by / Jiri Kosina SOB.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Recipients/maintainers for this subsystem are Srinivas
Pandruvada, Jiri Kosina, Benjamin Tissoires, linux-input. Ack is from
the ISH maintainer; apply from HID maintainer. **UNVERIFIED:** `b4 dig
-w` recipient list (lore blocked).

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla Link. Hardware observation is in the commit:
TGL LP `8086:a0fc`, ~79s period. Tested-by from Intel’s Zhang Lixu (same
tester as the related `enum_devices_done` stable fix).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone. Not part of Shen Yongchao’s later process_recv
bounds-check series. Related `enum_devices_done` fix is already here.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: Searches hit AUTOSEL for **Reset enum_devices_done**, not this
subject. **UNVERIFIED:** whether this exact patch was already discussed
on stable@. That is ignored as circular anyway.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `process_recv()` only.

**Step 5.2: TRACE CALLERS**
Record:
- `ish_cl_event_cb()` → `process_recv()`
- Registered in `hid_ishtp_cl_init()` via `ishtp_register_event_cb()`
- `ishtp_cl_bus_rx_event()` `schedule_work(&device->event_work)` →
  `ishtp_bus_event_work()` → `event_cb`
- Workqueue RX path, not a syscall; triggered by ISH firmware messages
  on systems with `CONFIG_INTEL_ISH_HID`.

**Step 5.3: TRACE CALLEES**
Record: On the bad path: `report_bad_packet()`, `ish_hw_reset()` →
`_ish_hw_reset()` → `pci_reset_function()`. After reset,
`hid_ishtp_cl_reset()` schedules `hid_ishtp_cl_reset_handler()`, which
deinits and calls `hid_ishtp_cl_init(..., 1)` up to 3 times.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace does not send ENUM_DEVICES; firmware does. Reachable
on every TGL-LP (and similar) ISH laptop after HID client init. High
impact for those machines: periodic PCI reset of the sensor hub.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same `!(command & ~CMD_MASK) || init_done` reset in
`HOSTIF_GET_HID_DESCRIPTOR` and `HOSTIF_GET_REPORT_DESCRIPTOR`. Commit
only changes ENUM_DEVICES, matching the firmware that resends that
command.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `ishtp-hid-client.c` lines 112–121 are identical to the
pre-patch code. TGL LP ID `0xA0FC` is in `ipc/hw-ish.h` / `pci-ish.c`
(`1479a82d82df6`, 2019). HID GUID in this file matches the commit. Bug
introduced with the original driver (`0b28cb4bcb17`, 2016).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Exact hunk context matches this file
(verified). No refactor of `process_recv` between the patch parent and
this 5.15 tree.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `d21497331b967` is here and does **not** ignore post-init
ENUM_DEVICES; it only clears `enum_devices_done` before sending the
command. The periodic-resend bug remains.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **HID / Intel ISH** (`drivers/hid/intel-ish-hid/`).
**IMPORTANT** for Intel laptops/tablets (accelerometer, gyro, ALS,
etc.), not core mm/VFS. Not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature since 2016. This tree still receives ISH fixes (e.g.
`enum_devices_done`). Platform IDs through Tiger Lake are present.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / platform-specific:** `CONFIG_INTEL_ISH_HID`
on x86 with ISH firmware that resends ENUM_DEVICES. Confirmed example:
TGL LP `8086:a0fc`, a common 11th-gen laptop platform. Same HID client
GUID is used across ISH generations, so other firmware versions could
hit it too.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: After successful ISH HID init, firmware timer ~79s. No userspace
trigger; unprivileged users do not need to do anything. Very likely on
affected hardware (every ~79s forever).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Failure: `pci_reset_function()` on ISH + full ISHTP reinit, plus `BAD
  packet` `dev_err` flood.
- Sensors drop and come back ~1100 times/day; possible gaps in
  input/IIO; extra PCI reset load.
- Severity: **HIGH** (stability / availability of ISH; not a KASAN UAF,
  not silent FS corruption).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** high for TGL-class ISH machines still on 5.15 LTS
  (Android/ChromeOS/enterprise).
- **Risk:** very low (5 lines, post-init discard only; malformed packets
  still reset).
- **Ratio:** strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real firmware misbehavior on shipping Intel ISH (TGL LP `8086:a0fc` in
  this tree).
- User-visible: PCI reset + ISHTP reinit ~1100/day, error log flood,
  sensor disruption.
- Buggy guard present here since original 2016 driver.
- 5-line, obviously correct split of two cases.
- Applies cleanly.
- ISH maintainer Ack, Intel Tested-by, HID maintainer applied it.
- Same `init_done` + ENUM_DEVICES + `ish_hw_reset` class of bug already
  accepted into this tree (`d21497331b967`).
- Fits the **hardware quirk/workaround** stable exception.

AGAINST:
- Not a panic/UAF/CVE; driver-specific.
- Silently ignoring post-init ENUM_DEVICES will not pick up a device
  list change via that command (old code did that only via a brutal
  reset).
- Full Srinivas review text not retrieved (lore Anubis).

UNRESOLVED:
- Exact lore body of 2026-06-29 replies.
- How many ISH firmware versions besides TGL LP resend ENUM_DEVICES.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — Tested-by Intel; Acked by
   ISH maintainer; logic is a 2-way split of an existing if.
2. Fixes a real bug that affects users? **PASS** — observed on TGL LP;
   periodic ISH reset.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   repeated PCI function reset and full client reinit is a serious
   stability issue, not cosmetic.
4. Small and contained? **PASS** — one file, 5 lines.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — exact context in 5.15.221.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk/workaround** for non-compliant/buggy ISH
firmware. Also a logic fix for misclassifying a valid response.

**Step 9.4: MAKE YOUR DECISION**

This should be backported to **this** 5.15 tree. The bug exists here,
the hardware ID exists here, the fix is tiny and applies cleanly, and
the current behavior is a reset storm on common Intel ISH laptops.

===============================================================
Verification
===============================================================
- [Phase 1] Tags: Tested-by Zhang Lixu; Acked-by Srinivas Pandruvada;
  SOB Jiri Kosina; no Fixes/Cc:stable/Reported-by.
- [Phase 2] Diff: `process_recv` ENUM_DEVICES only; split `!response ||
  init_done` into reject-without-flag vs discard-if-init_done.
- [Phase 2] `CMD_MASK`/`IS_RESPONSE` in `ishtp-hid.h` confirmed
  (`0x7F`/`0x80`).
- [Phase 3] blame: guard from `0b28cb4bcb17dc` (2016); ancestor of HEAD.
- [Phase 3] related: `d21497331b967` already in tree; does not fix
  periodic resend.
- [Phase 3] author: no prior Wahid Khan commits in this hid tree.
- [Phase 4] ratatoskr v1 2026-06-27, v2 2026-07-20 (“proper sign off”
  only); Srinivas replies listed 2026-06-29.
- [Phase 4] lore.kernel.org 403/Anubis; `b4 dig` on a mistaken hid.git
  SHA failed. UNVERIFIED: full review email text.
- [Phase 5] callers: workqueue `ishtp_bus_event_work` →
  `ish_cl_event_cb` → `process_recv`.
- [Phase 5] reset: `_ish_hw_reset` uses `pci_reset_function`;
  `hid_ishtp_cl_reset_handler` re-runs `hid_ishtp_cl_init`.
- [Phase 6] `git describe HEAD` = `p-5.15-2-g9a29d9b0f9507`; `make
  kernelversion` = 5.15.221.
- [Phase 6] buggy if at lines 113–114 present; exact patch context
  matches.
- [Phase 6] TGL `0xA0FC` in tree (`1479a82d82df6`); GUID matches commit.
- [Phase 7] MAINTAINERS: INTEL INTEGRATED SENSOR HUB DRIVER → Srinivas +
  Jiri.
- [Phase 8] failure mode: periodic ISH PCI reset, HIGH; not a kernel
  oops.
- UNVERIFIED: exact Srinivas reply text; whether other FW besides TGL LP
  hits this.

The problem is a firmware quirk that this 5.15 driver turns into an ISH
reset loop. The fix is small, reviewed, tested, and already matches the
local source.

**YES**

 drivers/hid/intel-ish-hid/ishtp-hid-client.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp-hid-client.c b/drivers/hid/intel-ish-hid/ishtp-hid-client.c
index 12a43c64e8156..085313ae354ab 100644
--- a/drivers/hid/intel-ish-hid/ishtp-hid-client.c
+++ b/drivers/hid/intel-ish-hid/ishtp-hid-client.c
@@ -113,8 +113,7 @@ static void process_recv(struct ishtp_cl *hid_ishtp_cl, void *recv_buf,
 
 		switch (recv_msg->hdr.command & CMD_MASK) {
 		case HOSTIF_DM_ENUM_DEVICES:
-			if ((!(recv_msg->hdr.command & ~CMD_MASK) ||
-					client_data->init_done)) {
+			if (!(recv_msg->hdr.command & ~CMD_MASK)) {
 				++client_data->bad_recv_cnt;
 				report_bad_packet(hid_ishtp_cl, recv_msg,
 						  cur_pos,
@@ -122,6 +121,8 @@ static void process_recv(struct ishtp_cl *hid_ishtp_cl, void *recv_buf,
 				ish_hw_reset(ishtp_get_ishtp_device(hid_ishtp_cl));
 				break;
 			}
+			if (client_data->init_done)
+				break;
 			client_data->hid_dev_count = (unsigned int)*payload;
 			if (!client_data->hid_devices)
 				client_data->hid_devices = devm_kcalloc(
-- 
2.53.0

