Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8D8628638;
	Mon, 19 Oct 2026 14:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418704; cv=none; b=gONAsHXHtIcyToqa2BfWFK8wV2dITCOR9bKeA4NP+61PZFESvOikPESn6m4nZpADd2RK60N0GysJF139Db5JOMWdTZTjXkgbh3O89cY4/9+M9q3jcQ/ADKd2jOdWB3vKGtRwlNkkymNMMUgkBCItTGetG2esyyVu3JgJV8TH6yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418704; c=relaxed/simple;
	bh=ubWJsTrmxFE6ICmJKaNja386JtZQgHuyHSdVR4SfIJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gKVtbckxfUc5RU+eErSu0tpiVpzccI6E6pqiUMZec4MN09/tvbYk1L4Byqqtip1wPD45ZkWPPnL7wdS6FxETcPRyapaHF6vHx6TET3+lbYj0pu4tAdZCdhGLSmgSqRoXeJIZxwrHzFQ7mmGo00SWkC9XmtYsP2afhOR/AIoo+MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=exH7Jv7b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="exH7Jv7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03FD1F000CA;
	Mon, 19 Oct 2026 14:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418701;
	bh=eYRXq3vFTvpdlRnOfhYDICc+n99eAzITxfIpAp/mwgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=exH7Jv7b/A8SygG+FVPi1+pP2j9PdAPlxrnaA2qV8A5f8eSCjxycgoZ0ZlMrppTru
	 sqLkzwgFNsb6d4KPaQdrwEixmL1nNwUmQluSAgV2hiuddi+WYC00p+fdgwDWsNtdQ2
	 jjePukk7AkzrGdHJ/8UXQmYLfvrscBy8fKwd7liRrac8DJn58GNTkkACU2fCgjCeE9
	 BgU2fphLdtPovKML2WnBQm3g7S8AHyncorM/4BofFFEjlvohT8p8dFBOVLClC5uvDx
	 anPSjyRciiqpWV2p4J3BX4W0dPDKg256Fr4GGLOQZKSbYvCh+oDvXykwGSvZOp9okR
	 15u6+mO6gaPKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xu Rao <raoxu@uniontech.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] usb: gadget: u_audio: clean up capture endpoint on feedback failure
Date: Mon, 19 Oct 2026 09:52:06 -0400
Message-ID: <20261019135441.1420968-435-sashal@kernel.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 7a0d4f60da261f61dcb50c8e05fa53cc7d4d4427 ]

u_audio_start_capture() enables the capture OUT endpoint, queues capture
requests and marks the stream active before setting up the optional
feedback endpoint.

If feedback endpoint configuration or enablement fails, the function
returns an error while the capture endpoint remains enabled and its
requests may remain queued. The current code even leaves TODO comments
at these return paths.

Unwind the already started capture endpoint on these failures. Also set
fb_ep_enabled only after usb_ep_enable() succeeds, so the software state
matches the endpoint state.

Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/183621D513E0DE8B+20260611091229.4017443-1-raoxu@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to judge this against the local 7.3-rc4 tree: it is a
small error-path unwind in USB gadget UAC2 capture, and the surrounding
code is present here.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[usb: gadget: u_audio]** **[clean up]** Capture OUT endpoint
is left enabled/queued if optional feedback-endpoint setup fails.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Xu Rao <raoxu@uniontech.com>` (author)
- `Link: https://patch.msgid.link/183621D513E0DE8B+20260611091229.401744
  3-1-raoxu@uniontech.com`
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>` (USB
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence of the last two is expected for this
  review)
- Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
  ...]` markers; none are in the real commit

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `u_audio_start_capture()` enables the capture OUT endpoint,
  queues ISO requests, and marks the stream active *before* configuring
  the optional feedback IN endpoint.
- **Symptom:** On `config_ep_by_speed()` / `usb_ep_enable()` failure for
  the feedback EP, the function returns an error while OUT remains
  enabled and requests may stay queued. Author notes existing `TODO:
  Clean up out_ep` comments.
- **Root cause:** Incomplete unwind on feedback-setup error;
  `fb_ep_enabled` was also set before `usb_ep_enable()` succeeded, so
  software state could claim the feedback EP was enabled when it was
  not.
- **Version info:** none in the message. Related introducer is
  `76a7bfc445b8e` (v6.11-rc3), which added those error returns with
  TODOs.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Yes — a real error-path leak, not style cleanup.** “Clean up”
here means unwind an already-started ISO endpoint. The TODOs in the pre-
patch code make that explicit.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/usb/gadget/function/u_audio.c` — **+9 / −3** (12 lines)
- Function: `u_audio_start_capture()` only
- Scope: **single-file surgical error-path fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: feedback `config_ep_by_speed` / `usb_ep_enable` failure did
  `return ret; // TODO: Clean up out_ep`. `fb_ep_enabled = true` ran
  *before* `usb_ep_enable()`.
- After: those two failures `goto err_out_ep`, which does
  `set_active(prm, false)` and `free_ep(prm, ep)` (dequeue + disable
  capture OUT). `fb_ep_enabled` is set only after successful enable.
- Path affected: **error path only**, and only when
  `audio_dev->in_ep_fback` is non-NULL.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** error-path resource leak + software/hardware state
  mismatch
- **Mechanism:** Capture OUT is enabled and ISO requests queued;
  feedback setup then fails; caller (`set_alt`) returns error without
  calling `u_audio_stop_capture()`. OUT stays live. `fb_ep_enabled`
  could be true while enable failed, so later `free_ep_fback()` could
  `usb_ep_disable()` an endpoint that never enabled.
- **Fix:** reuse existing `free_ep()` / `set_active()`; set the flag
  after enable succeeds.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Quality:** Obviously correct. `prm` is `&uac->c_prm`; `ep` is
  `audio_dev->out_ep`; that matches `u_audio_stop_capture()`. Not
  calling `free_ep_fback()` on these two failures is correct (feedback
  never successfully enabled).
- **Regression risk:** Low. Error path only; same helpers already used
  on stop/disable.
- **Incomplete but still valid:** `usb_ep_alloc_request()` / `kzalloc()`
  `-ENOMEM` returns after feedback enable still skip unwind. This patch
  only closes the two TODO paths. Remaining holes are not a reason to
  reject this hunk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- TODO returns introduced by **`76a7bfc445b8e`** (`usb: gadget: u_audio:
  Check return codes from usb_ep_enable and config_ep_by_speed.`, Chris
  Wulff, 2024-07-21).
- That commit is contained in **`v6.11-rc3`**.
- Feedback endpoint itself: **`24f779dac8f3ef`** (2021). Capture core:
  **`eb9fecb9e69b`** (v4.13-rc1).
- `free_ep()` has existed since the feedback-support commit.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No `Fixes:` tag** (expected). The incomplete unwind was
introduced by `76a7bfc445b8e`, which itself had `Fixes:` for
`eb9fecb9e69b` / `24f779dac8f3` and **`Cc: stable@vger.kernel.org`**.
This commit completes that error handling. `76a7bfc445b8e` **is an
ancestor of this HEAD**.

**Step 3.3: CHECK FILE HISTORY**
Record: Recent `u_audio.c` work is independent (kmalloc conversions, UAF
on disconnect). This is **standalone**, not patch X/Y. One later commit
on the file (`858965947081d` UAF on disconnect) does not depend on this
unwind.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Xu Rao is not the u_audio maintainer. Other USB gadget work here
includes `f_printer` kref handling. USB maintainer **Greg Kroah-
Hartman** applied this.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs `free_ep()`, `set_active()`, `fb_ep_enabled`, and the
feedback error returns from `76a7bfc445b8e`. **All present in this
tree.** Can apply standalone on any tree that already has
`76a7bfc445b8e`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 7a0d4f60da261` → https://patch.msgid.link/183621D513E0DE8B+
  20260611091229.4017443-1-raoxu@uniontech.com
- `b4 dig -a`: **v1 only** (2026-06-11), no later revisions
- Saved mbox (`b4 dig -m`): **submission only, no replies**
- WebFetch of lore/msgid.link returned **403**; discussion content
  verified from the mbox instead
- No NAK, no `Cc: stable` in the submission, no reviewer-requested
  changes

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To Greg Kroah-Hartman; Cc Kees Cook, linux-usb,
linux-kernel. Greg signed off and applied it. No separate `Reviewed-by`
in git or the mbox.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by` / bugzilla / syzbot. The pre-patch `TODO: Clean
up out_ep` comments are in-tree evidence the gap was already known
(`76a7bfc445b8e`).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone single patch, not a series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: Lore stable search via WebFetch **403**. `b4` mbox has no
stable-list traffic. **UNVERIFIED** whether stable@ discussed this
specific follow-up. The *introducer* `76a7bfc445b8e` was explicitly
Cc:stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: `u_audio_start_capture()` modified. Callees on the new path:
`set_active()`, `free_ep()`.

**Step 5.2: TRACE CALLERS**
Record:
- `f_uac2.c` `afunc_set_alt()`: `u_audio_start_capture(&uac2->g_audio)`
  when capture interface alt != 0
- `f_uac1.c` `f_audio_set_alt()`: same, but UAC1 never assigns
  `in_ep_fback`, so the feedback error path is UAC2-only
- Called from gadget `SET_INTERFACE` in `composite.c` (`f->set_alt()`
  under `cdev->lock`). **Host-triggered**, not an init-only path.

**Step 5.3: TRACE CALLEES**
Record: `free_ep()` dequeues queued requests, clears `ep_enabled`,
`usb_ep_disable()`. `set_active(false)` clears the ALSA rate-control
“running” flag. Same sequence as `u_audio_stop_capture()` for the OUT
endpoint.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: USB host SET_INTERFACE (alt=1) on UAC2 capture → `afunc_set_alt`
→ `u_audio_start_capture`. Reachable whenever a device uses `f_uac2`
with capture. **Default `c_sync` is `USB_ENDPOINT_SYNC_ASYNC`
(`UAC2_DEF_CSYNC`), so `in_ep_fback` is allocated by default.** Trigger
of the *bug* still requires feedback `config_ep_by_speed` /
`usb_ep_enable` failure (malformed/missing speed descriptors, UDC enable
failure). Composite does **not** roll back `set_alt` on error
(`composite.c` just returns the error to the host). `as_out_alt` is
stored *before* `start_capture`, so a retry of alt=1 can call start
again with OUT still live. `afunc_disable` / alt=0 does call
`u_audio_stop_capture()`, so disconnect eventually unwinds — retries and
the window before alt=0 are the problem.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Playback has no feedback EP; no matching TODO there. The two
`-ENOMEM` returns after feedback enable in the same function still skip
unwind — same class of bug, not fixed here.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Local tree: **`v7.3-rc4-27-gf0100363d8c37`**, `VERSION=7 PATCHLEVEL=3
  SUBLEVEL=0 EXTRAVERSION=-rc4`
- `git merge-base --is-ancestor 7a0d4f60da261 HEAD` → **yes** (this
  commit is already in this checkout)
- Surrounding code **is** in this tree: `u_audio_start_capture`,
  `free_ep`, `in_ep_fback`, UAC2 async feedback default
- Bug introduced **v6.11-rc3** (`76a7bfc445b8e`), long before 7.3 —
  **not** “introduced after this tree branched”
- Current file already contains `err_out_ep` / post-enable
  `fb_ep_enabled` (the fixed form)

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Patch is 12 lines against `u_audio_start_capture()`. Helpers it
uses exist since 2021/2022. **Clean apply** on trees that have
`76a7bfc445b8e`. This 7.3-rc4 checkout already has the result.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This *is* the fix; it is already in this tree. No earlier
substitute unwind of these two returns.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **USB gadget function / UAC2 audio
(`drivers/usb/gadget/function/`)**. **IMPORTANT** for gadgets that act
as USB sound cards (embedded, Android accessory, configfs UAC2); not
core mm/VFS. Default UAC2 capture uses async + feedback.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: File is mature (core from 2017, feedback from 2021) with
occasional correctness fixes. Not a new subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: **Driver-specific / config-specific:** `CONFIG` USB gadget UAC2
with capture. Feedback EP is **on by default** (`UAC2_DEF_CSYNC =
USB_ENDPOINT_SYNC_ASYNC`).

**Step 8.2: TRIGGER CONDITIONS**
Record: Host SET_INTERFACE to start capture, then feedback
`config_ep_by_speed` or `usb_ep_enable` fails. Uncommon compared with
the success path, but the same conditions `76a7bfc445b8e` documented
(bad/missing descriptors for the selected speed, enable failure). Not a
syzbot/syscall UAF; a USB host/UDC error path. Unprivileged local
userspace on the gadget does not directly call this; the USB host does.

**Step 8.3: FAILURE MODE SEVERITY**
Record:
- Enabled ISO OUT + queued requests after `set_alt` reports failure
- Stream left “active” in ALSA rate control
- Retry of start can enable/queue an already-live endpoint
- `fb_ep_enabled` vs actual enable mismatch on the enable-fail path
- **Severity: HIGH** for the gadget (stuck/inconsistent USB audio until
  alt=0 or disconnect), not a generic kernel panic. Not silent
  filesystem corruption.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** Restores correct unwind on a path the previous stable-
  bound commit left as TODO; prevents leftover ISO endpoint state
- **Risk:** Very low (9 insertions, existing helpers, error path only)
- **Ratio:** Favorable

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real incomplete unwind; pre-patch TODOs name the bug
- Completes error handling from `76a7bfc445b8e`, which was `Cc: stable`
  and is in this tree
- Leaves a live ISO endpoint and queued requests after `set_alt`
  failure; composite does not auto-stop
- Also fixes `fb_ep_enabled` vs `usb_ep_enable()` ordering
- 12-line, obviously correct, uses existing `free_ep()` / `set_active()`
- UAC2 capture + feedback is the default, not an obscure option
- Applied by Greg Kroah-Hartman
- All helpers and the introducer exist in this tree; no missing
  prerequisites

**AGAINST:**
- Error path; needs feedback enable/config failure (not every start)
- No user/syzbot report in the commit or mbox
- `-ENOMEM` after feedback enable still leaks (incomplete, but this hunk
  is still correct)
- No `Reviewed-by` / mailing-list discussion in the matched thread
- Original submission did not Cc stable (not a negative per the review
  rules)

**UNRESOLVED:** Lore HTML 403; no public review comments in the b4 mbox;
no stable@ thread found.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — unwind matches
   `u_audio_stop_capture()`; merged by USB maintainer. No extra `Tested-
   by`.
2. Fixes a real bug that affects users? **PASS** — leftover enabled ISO
   EP after failed SET_INTERFACE.
3. Important issue? **PASS** — not a panic, but inconsistent gadget
   USB/audio state; HIGH for UAC2 gadgets. Matches the error-path leak
   class that stable routinely takes.
4. Small and contained? **PASS** — one function, 12 lines.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — code and prerequisites are
   here; the patch is the current code.

**Step 9.3: EXCEPTION CATEGORIES**
Record: None (not a device ID, quirk, DT, build, or docs fix). Qualifies
as a normal small bugfix.

**Step 9.4: DECISION**
This tree is **7.3-rc4**. The UAC2 capture/feedback code and the v6.11
incomplete returns are part of this lineage. The change is a small,
correct unwind of a real leftover-endpoint bug on SET_INTERFACE failure,
including a state-flag fix. That meets stable rules for **this** tree’s
code. Remaining `-ENOMEM` holes do not make this hunk unsafe or feature-
like.

The problem for stable users of gadget UAC2 is a capture start that
fails while configuring the default async feedback endpoint: OUT stays
enabled with ISO requests queued, `set_alt` returns error, and a host
retry can hit an already-live endpoint. The patch only touches that
failure path and reuses `free_ep()`. Risk is low; benefit is restoring a
consistent gadget state after a failure the previous stable-destined
commit already started handling.

### Verification
- **[Phase 1]** Parsed commit
  `7a0d4f60da261f61dcb50c8e05fa53cc7d4d4427`: SOB Xu Rao + Greg KH; Link
  msgid; no Fixes/Reported-by/Cc:stable
- **[Phase 2]** Diff: +9/−3 in `u_audio_start_capture()`; TODO returns →
  `goto err_out_ep`; `fb_ep_enabled` moved after successful
  `usb_ep_enable()`
- **[Phase 2]** Read `free_ep()` / `u_audio_stop_capture()`: same
  dequeue/disable sequence
- **[Phase 3]** `git blame`: TODOs from `76a7bfc445b8e` (v6.11-rc3,
  Cc:stable); `git describe --contains 76a7bfc445b8e` →
  `v6.11-rc3~4^2~12`
- **[Phase 3]** `git merge-base --is-ancestor 76a7bfc445b8e HEAD` → 0
  (present); same for `24f779dac8f3ef`, `eb9fecb9e69b`
- **[Phase 3]** `git log --author="Xu Rao"` limited to
  `drivers/usb/gadget/`: this commit + unrelated f_printer change
- **[Phase 4]** `b4 dig -c/-a/-w/-m`: v1 only; recipients gregkh, kees,
  linux-usb; mbox has patch text only, no replies
- **[Phase 4]** WebFetch lore/msgid/stable search: 403; used b4 mbox
  instead
- **[Phase 5]** Callers: `f_uac2.c:1464`, `f_uac1.c:969`; `in_ep_fback`
  only set in `f_uac2.c` when `EPOUT_FBACK_IN_EN`; `UAC2_DEF_CSYNC` is
  `USB_ENDPOINT_SYNC_ASYNC`
- **[Phase 5]** `composite.c` SET_INTERFACE: `set_alt` error is
  returned; no automatic `stop_capture`
- **[Phase 6]** `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` → `7.3.0-rc4`; ancestor check for this commit →
  yes
- **[Phase 8]** Failure mode: leftover enabled ISO OUT + queued reqs +
  active flag; severity HIGH for UAC2 gadget, not a generic oops
- **UNVERIFIED:** Public review comments beyond the empty b4 thread;
  whether stable@ already queued this SHA

**YES**

 drivers/usb/gadget/function/u_audio.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index 24c673dcbbd77..75a4ce406c2a3 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -641,15 +641,15 @@ int u_audio_start_capture(struct g_audio *audio_dev)
 	ret = config_ep_by_speed(gadget, &audio_dev->func, ep_fback);
 	if (ret < 0) {
 		dev_err(dev, "config_ep_by_speed in_ep_fback failed (%d)\n", ret);
-		return ret; // TODO: Clean up out_ep
+		goto err_out_ep;
 	}
 
-	prm->fb_ep_enabled = true;
 	ret = usb_ep_enable(ep_fback);
 	if (ret < 0) {
 		dev_err(dev, "usb_ep_enable failed for in_ep_fback (%d)\n", ret);
-		return ret; // TODO: Clean up out_ep
+		goto err_out_ep;
 	}
+	prm->fb_ep_enabled = true;
 	req_len = ep_fback->maxpacket;
 
 	req_fback = usb_ep_alloc_request(ep_fback, GFP_ATOMIC);
@@ -680,6 +680,12 @@ int u_audio_start_capture(struct g_audio *audio_dev)
 		dev_err(dev, "%s:%d Error!\n", __func__, __LINE__);
 
 	return 0;
+
+err_out_ep:
+	set_active(prm, false);
+	free_ep(prm, ep);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(u_audio_start_capture);
 
-- 
2.53.0

