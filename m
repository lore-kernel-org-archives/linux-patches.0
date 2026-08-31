Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27C1415F2E;
	Mon, 31 Aug 2026 13:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183198; cv=none; b=oSSgtp/WPIgZ+754X/r0BlOeLofDQTEP8iUaSlKo80yuTmZ2RakVLF4Ii15hIVIWq9OvA2F+dI5fNjySjrWxnNMSFXvManBFPp2gMBJPC7tG9vCkISKb2/lli2D4p7PSBAPfg2xLEA54Es6GCQvNnFCkvPGD2bqOu4amV51XONI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183198; c=relaxed/simple;
	bh=yV1RDIhNSNFbcxqQ19tWu+IIBErRIfLgNZa1zvqIgSA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Rwu1dby0nzGwM4lXp2b0Z1H0RDpOSbtG91IV4Xk4mljAjce8WETPe1yRoNpshIwQlkmhfB6fpY794kxXJID29fhHCalZXn0EYfTAOuwmuBVZlyVzCzBlVg4gl22UuXxe1zq+h4gmS8JFLnanlkG2W2Wc9tzU4vVia7+Cb1o7Pgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bS2jq2Hy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bS2jq2Hy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B061F000E9;
	Mon, 31 Aug 2026 13:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183196;
	bh=1J77XU+FRYLHnC+JWeMz+Cme7b3XPiYHdf82jWlS5kQ=;
	h=From:To:Cc:Subject:Date;
	b=bS2jq2HyaLGzggUI//8K6gY3Uu4GgUijMe4NgKr1RbXFkaS3eW7RCbqAj/haet98O
	 xoptXExsggFd+S/0am4eYcIfE5pNAG664T1sVuGwFAcn12gIaTEy0+2xbzji3JVvy5
	 RNtszlZFJxYvWGTtMRrpvXJbNtRPlZFjtJRatL8KdLCR2mW10b8Qqqf3Sb5/bgHcM5
	 xykF2VUS0q4QFIcepyYE2z75rKCgo+ShIit/ZahKAqaOMe8wAztiZB3m3i0v7wA0IV
	 eeQRPQUTw7Tu9kRo+s5ZodkRhIgG40kWqZuDFhiQ03FxjIIQKSaoy2QtdgtQq3v2rW
	 xhYU/gkKE13+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()
Date: Mon, 31 Aug 2026 09:20:29 -0400
Message-ID: <20260831133314.4125787-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit a2f5286ca4f304d3fd469f01b96b518608912a5c ]

The KASAN allocation trace shows that a malformed IE buffer is
stored via SIOCSIWGENIE (cfg80211_wext_siwgenie()) without any
validation. The crash trace shows that a subsequent SIOCSIWESSID
triggers a connection attempt which calls cfg80211_sme_get_conn_ies()
to process the stored IE buffer, causing:

 - An out-of-bounds read in skip_ie() which reads ies[pos+1]
   (the length byte) past the end of the 1-byte buffer.

 - An integer underflow in the memcpy size argument when offs
   returned by ieee80211_ie_split() exceeds ies_len, causing
   unsigned subtraction to wrap to SIZE_MAX and triggering a
   fortify panic.

Fix this by validating the IE buffer in cfg80211_wext_siwgenie()
before storing it.

Reported-by: syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cc867e537e4bd36f69bb
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://patch.msgid.link/20260725142028.32560-1-kartikey406@gmail.com
[drop unnecessary ie_len check, update commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[wifi: cfg80211]` `[validate]` — Add IE validation in
`cfg80211_wext_siwgenie()` before storing user-supplied generic IE data.

### Step 1.2: Tags
**Record:**
- **Reported-by:** syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com
  (fuzzer-found, strong YES signal)
- **Closes:**
  https://syzkaller.appspot.com/bug?extid=cc867e537e4bd36f69bb
- **Link:**
  https://patch.msgid.link/20260725142028.32560-1-kartikey406@gmail.com
- **Signed-off-by:** Deepanshu Kartikey, Johannes Berg (cfg80211
  maintainer committed/applied)
- No Fixes:, Cc: stable, Reviewed-by, Tested-by, or Acked-by tags
- Notable: syzbot report with maintainer application

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Malformed IE buffer stored via `SIOCSIWGENIE` without
  validation; later `SIOCSIWESSID` triggers connection and
  `cfg80211_sme_get_conn_ies()` processes the bad buffer.
- **Symptoms:** (1) OOB read in `skip_ie()` reading `ies[pos+1]` past a
  1-byte buffer; (2) integer underflow in `memcpy` size when
  `ieee80211_ie_split()` returns `offs > ies_len`, wrapping to
  `SIZE_MAX` and triggering fortify panic.
- **Root cause:** Wext path lacked the IE validation that nl80211
  already performs.
- **Version info:** None in commit message.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit bug fix for KASAN-reported OOB read
and fortify panic, not disguised cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `net/wireless/wext-sme.c` (+9 lines, 0 removed)
- **Function:** `cfg80211_wext_siwgenie()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (before):** If `ie_len > 0`, immediately `kmemdup()` and store
  buffer.
- **Hunk (after):** Before `kmemdup()`, walk IEs with
  `for_each_element()` and reject with `-EINVAL` if
  `!for_each_element_completed()`.
- **Path affected:** Error/input-validation path on `SIOCSIWGENIE`
  ioctl.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds read + integer underflow
- **Mechanism:** `skip_ie()` assumes well-formed IEs (`u8 len = ies[pos
  + 1]`). A 1-byte stored buffer causes OOB read. Bad split offset leads
  to `ies_len - offs` underflow in `cfg80211_sme_get_conn_ies()`:

```529:534:net/wireless/sme.c
                offs = ieee80211_ie_split(ies, ies_len, before_extcapa,
                                          ARRAY_SIZE(before_extcapa),
0);
                memcpy(buf, ies, offs);
                /* leave a whole for extended capabilities IE */
                memcpy(buf + offs +
rdev->wiphy.extended_capabilities_len + 2,
                       ies + offs, ies_len - offs);
```

### Step 2.4: Fix Quality
**Record:**
- **Quality:** High — matches existing `validate_ie_attr()` pattern in
  `nl80211.c`.
- **Regression risk:** Very low — only rejects malformed input that
  would crash later; well-formed IEs unchanged.
- **Note:** Johannes dropped the explicit `ie_len < 2` check from v2;
  `for_each_element_completed()` correctly rejects 1-byte buffers (loop
  never runs, completion check fails).

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Current `cfg80211_wext_siwgenie()` in this tree dates to
initial import at `5d324e5159d9e` (v6.18 merge base). The unvalidated
`kmemdup()` path has been present since wext-sme support was added — a
long-standing gap, not a recent regression.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related Changes
**Record:** Many related validation fixes in `net/wireless/` (e.g.
`f8c547e543e12`, `cfbda103aeae6`, `584657c5fc58d`). nl80211 already
validates IEs via `validate_ie_attr()`; wext path was the missing piece.
Standalone fix — v3 helper series was explicitly rejected by maintainer.

### Step 3.4: Author Context
**Record:** Deepanshu Kartikey is a contributor; Johannes Berg (cfg80211
maintainer) applied the patch with modifications.

### Step 3.5: Dependencies
**Record:** No prerequisites. Uses `for_each_element` /
`for_each_element_completed` from `include/linux/ieee80211.h` (included
via `cfg80211.h`). No dependency on rejected v3
`cfg80211_validate_ies()` helper.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- **URL:**
  https://patch.msgid.link/20260725142028.32560-1-kartikey406@gmail.com
- **Series:** v1 (2026-07-10) → v2 (2026-07-25, committed version)
- **Maintainer:** Johannes Berg applied modified v2 on 2026-07-28,
  declined v3 refactor: *"the bigger cleanup isn't great for wireless as
  a fix right now"*
- No explicit Cc: stable nomination; no NAKs

### Step 4.2: Reviewers
**Record:** CC'd: johannes@sipsolutions.net, linux-
wireless@vger.kernel.org, syzbot. Jeff Johnson replied on thread.
Maintainer applied directly.

### Step 4.3: Bug Report
**Record:**
- **syzkaller:** KASAN slab-out-of-bounds in `skip_ie()` /
  `ieee80211_ie_split_ric()`
- **Repro:** C reproducer on 2026/07/09; fix commit `a2f5286ca4f3`
  identified
- **Stack trace confirms path:** `cfg80211_wext_siwgenie()` →
  `cfg80211_mgd_wext_siwessid()` → `cfg80211_sme_get_conn_ies()` → crash
- **Severity:** Kernel crash (KASAN OOB); syzbot security assessment
  flags DoS/exploitable

### Step 4.4: Related Patches
**Record:** v3 series (`cfg80211_validate_ies()` helper) exists but was
explicitly not taken for this fix cycle.

### Step 4.5: Stable List
**Record:** lore.kernel.org/stable search blocked (bot protection). No
stable discussion found.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `cfg80211_wext_siwgenie()` (modified); downstream:
`cfg80211_mgd_wext_connect()`, `cfg80211_sme_get_conn_ies()`,
`skip_ie()`.

### Step 5.2: Callers
**Record:**
- `cfg80211_wext_siwgenie()` registered in `wext-compat.c` as
  `IW_HANDLER(SIOCSIWGENIE, ...)`
- Stored IEs consumed at connect time via `cfg80211_mgd_wext_connect()`
  (lines 31–32) → `cfg80211_connect()` → `cfg80211_sme_get_conn_ies()`

### Step 5.3: Callees
**Record:** `for_each_element()`, `for_each_element_completed()`,
`kmemdup()`, `kfree()`, `cfg80211_disconnect()`.

### Step 5.4: Reachability
**Record:**
- Reachable from userspace via `ioctl(SIOCSIWGENIE)` on wireless
  netdevice
- Requires `CAP_NET_ADMIN` (`wext_permission_check()` in `wext-
  core.c:991-996`)
- Only when `CONFIG_CFG80211_WEXT` is enabled (common on distros
  supporting `iwconfig`)

### Step 5.5: Similar Patterns
**Record:** Identical validation pattern in
`nl80211.c:validate_ie_attr()` and `scan.c:2749`. Wext path was the
outlier.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Local tree is **v6.18.44** (`git describe HEAD`).
`cfg80211_wext_siwgenie()` at lines 321–324 does unvalidated
`kmemdup()`. Fix commit `a2f5286ca4f3` is **NOT** an ancestor of HEAD
(`git merge-base --is-ancestor` → fix NOT in HEAD).

### Step 6.2: Backport Complications
**Record:** **Clean apply.** `git apply --check` on the fix diff
succeeds with no conflicts.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent validation in `cfg80211_wext_siwgenie()`.
nl80211 IE validation exists separately; does not cover wext path.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem
**Record:** `net/wireless` (cfg80211) — **IMPORTANT** subsystem; affects
wireless stack users.

### Step 7.2: Activity
**Record:** Actively maintained; multiple recent IE-validation hardening
commits in this tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users with `CONFIG_CFG80211_WEXT` and wireless interfaces
using wext ioctls (`iwconfig`, legacy tools). Not universal, but common
on desktop/server distros.

### Step 8.2: Trigger Conditions
**Record:**
- `SIOCSIWGENIE` with malformed IE (e.g. 1-byte buffer) + `SIOCSIWESSID`
  to trigger connect
- Requires `CAP_NET_ADMIN` (not unprivileged)
- syzbot has reproducible C reproducer

### Step 8.3: Failure Mode
**Record:** KASAN slab-out-of-bounds read → potential kernel oops/panic;
fortify panic on memcpy underflow. **Severity: HIGH** (kernel crash).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents kernel crash from malformed wext IE input
- **Risk:** VERY LOW — 9-line input validation, established pattern,
  maintainer-reviewed
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- syzbot-reported, reproducible KASAN OOB read
- Kernel crash (fortify panic) on realistic ioctl sequence
- Small, surgical, maintainer-applied fix
- Matches existing nl80211 validation pattern
- Applies cleanly to v6.18.44
- Buggy code confirmed present; fix not yet in tree
- Part of ongoing cfg80211 IE hardening in stable

**AGAINST backport:**
- Requires `CAP_NET_ADMIN` (not unprivileged attack)
- Only affects wext compat path (`CONFIG_CFG80211_WEXT`)
- No explicit Cc: stable nomination (not a negative per instructions)

**Unresolved:** None material to the decision.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — standard `for_each_element`
   validation; syzbot repro; maintainer applied
2. Fixes real bug affecting users? **PASS** — KASAN-confirmed crash path
3. Important issue? **PASS** — kernel crash (HIGH severity)
4. Small and contained? **PASS** — 9 lines, 1 file
5. No new features/APIs? **PASS** — input validation only
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception Categories
**Record:** N/A — standard bug fix, not device-ID/quirk/DT/docs
exception.

### Step 9.4: Decision Rationale

This commit closes a validation gap in the wext compatibility path that
nl80211 already covers. A `CAP_NET_ADMIN` caller can store a malformed
1-byte IE via `SIOCSIWGENIE`; a subsequent `SIOCSIWESSID` triggers
connection processing that reads past the buffer end in `skip_ie()` and
can panic via fortify-checked `memcpy`. The fix is minimal, follows an
established in-tree pattern, was applied by the cfg80211 maintainer,
applies cleanly to this v6.18.44 tree, and the vulnerable code is
confirmed present without the fix.

---

## Verification

- [Phase 1] Parsed tags: Reported-by syzbot, Closes syzkaller URL,
  Signed-off-by author + Johannes Berg
- [Phase 1] Subject: wifi: cfg80211 validate IEs in
  cfg80211_wext_siwgenie()
- [Phase 2] Diff: +9 lines in cfg80211_wext_siwgenie(), adds
  for_each_element validation before kmemdup
- [Phase 2] Verified skip_ie() OOB: `u8 len = ies[pos + 1]` at
  util.c:1967 with comment "assume validly formed"
- [Phase 2] Verified underflow path: cfg80211_sme_get_conn_ies() memcpy
  at sme.c:534 uses `ies_len - offs`
- [Phase 3] git blame: vulnerable function present in v6.18.44 tree
- [Phase 3] git merge-base --is-ancestor a2f5286ca4f3 HEAD → fix NOT in
  HEAD
- [Phase 3] git apply --check on fix diff → applies cleanly
- [Phase 4] b4 dig -c a2f5286ca4f3 →
  https://patch.msgid.link/20260725142028.32560-1-kartikey406@gmail.com
- [Phase 4] b4 dig -a → v1 and v2 series; v2 is committed version
- [Phase 4] b4 dig -w → johannes@sipsolutions.net, linux-wireless CC'd
- [Phase 4] Mbox: Johannes applied modified v2, declined v3 refactor
- [Phase 4] syzkaller report fetched: KASAN OOB in skip_ie, C repro, fix
  commit a2f5286ca4f3
- [Phase 4] Stack trace confirms siwgenie → siwessid → sme_get_conn_ies
  → skip_ie path
- [Phase 5] Call chain: wext-compat.c SIOCSIWGENIE handler → wext-sme.c
  connect path → sme.c
- [Phase 5] CAP_NET_ADMIN required: wext-core.c:991-996
  wext_permission_check()
- [Phase 5] for_each_element_completed pattern exists in nl80211.c:284
  and scan.c:2749
- [Phase 5] Macros available via cfg80211.h → ieee80211.h include chain
- [Phase 6] git describe HEAD → v6.18.44-2-g1b9e1abadee04 (6.18.y tree)
- [Phase 6] Makefile VERSION/PATCHLEVEL/SUBLEVEL → 6.18.44
- [Phase 6] Current wext-sme.c:321-324 lacks validation (buggy code
  confirmed)
- [Phase 7] net/wireless recent commits show active IE validation
  hardening
- [Phase 8] Failure mode: KASAN OOB + fortify panic, severity HIGH
- [Phase 8] Trigger requires CAP_NET_ADMIN (syzbot assessment:
  Unprivileged ❌)

**YES**

 net/wireless/wext-sme.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 573b6b15a446e..b5914f3658db4 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -319,6 +319,15 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
 		return 0;
 
 	if (ie_len) {
+		const struct element *elem;
+
+		for_each_element(elem, extra, ie_len) {
+			/* nothing */
+		}
+
+		if (!for_each_element_completed(elem, extra, ie_len))
+			return -EINVAL;
+
 		ie = kmemdup(extra, ie_len, GFP_KERNEL);
 		if (!ie)
 			return -ENOMEM;
-- 
2.53.0

