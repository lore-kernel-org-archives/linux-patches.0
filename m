Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC043572E8C;
	Mon, 19 Oct 2026 13:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418300; cv=none; b=V5f9bIO4gmiAQMERfQ+UPNeCieD//GXPBIWnVu4JsrccG2iwHS7WGS0KSfhieJWAdVy0UY5HJyRJ/fBP/lnxcarSr8Mwdk6GLCIhYmwponzCYXV6DH8maaXFj45Jh2Y/0/gZTI9TiMsF7qhy4AciolPKKxbFm6ftrOYNyeydjEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418300; c=relaxed/simple;
	bh=rHlhK7BrYzJ2taWosO56xUgfj7J8FyLUJ/jEYcFEZLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k85RkYdk8NVzYFDgFtPiT0AG3ygYPavzxRpBJovfOcP2wDZZkXmvJqreujA+teHkOhMO2btzvjBDlad4xdMXxWhpqPPsJfOThbBy0FHFc5U6dqSNCrBlGn8cUbXiUuvruOepjk5ZdmLfCgGW2t99PFVPPvX+q3IX8yV8zWPOKN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbKN14RI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbKN14RI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B5E1F000CA;
	Mon, 19 Oct 2026 13:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418297;
	bh=Ex5NHql9fRsoG/YgsWMOdKOf3WuqmjPXcfJOdl+K4WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbKN14RIEGNnV05ONjEeZj68PH8pdu319eCTmakGDHhob3xphJJxH+xABxfu2o5/Q
	 dVE02xzwxXy8PPw81oiS1W8ePaP6/RAxZqQDz80mH+wUPco+8q5TecZqtrArjZjfNS
	 wlQHxiSQK3qd48UKAXQ72UTODQGMzTBf9MXeD43sMVSKKcqKBJ+HgZgv5hHHOp1K+9
	 yFVDqpc00dn7pVdTWOmk8kCnfkyzSsSt16XSqRLiWqP6jyoT6M8ckwLAQwWkC9fUvF
	 ZdBEzRq9TLm5nN3inYXg7GEEOyCuIqg3/UpwdhtA/WPAygJO6gd5Go2UAzXRMMP8se
	 ZqKclOuz+ObCA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rituparna Warwatkar <rwarwatkar@gmail.com>,
	syzbot+e9a1f5e196de6663631b@syzkaller.appspotmail.com,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: dvb-core: fix feed leak on failed DMX_ADD_PID
Date: Mon, 19 Oct 2026 09:47:19 -0400
Message-ID: <20261019135441.1420968-148-sashal@kernel.org>
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

From: Rituparna Warwatkar <rwarwatkar@gmail.com>

[ Upstream commit 9fa26c971ca310dd10a3bc0014f2fc7ea7167bba ]

dvb_dmxdev_add_pid() allocates a new dmxdev_feed, links it into
filter->feed.ts and, when the filter is already running, immediately
starts the feed.

If starting the feed fails, the newly allocated feed remains on the
list. Subsequent restart and rollback paths may then operate on this
stale entry, leaving feed resources allocated and causing leaks in
drivers that allocate resources from ->start_feed() and release them
from ->stop_feed().

Remove the feed from the list and free it when
dvb_dmxdev_start_feed() fails.

Reported-by: syzbot+e9a1f5e196de6663631b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e9a1f5e196de6663631b
Signed-off-by: Rituparna Warwatkar <rwarwatkar@gmail.com>
Link: https://patch.msgid.link/20260714141059.63582-1-rwarwatkar@gmail.com
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Message-ID: <20260714141059.63582-1-rwarwatkar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is mainline **7.3.0-rc4**. The change is a small,
syzbot-confirmed feed leak in `dvb_dmxdev_add_pid()`, present since
2009, and it belongs in this tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[media/dvb-core] [fix] feed leak on failed DMX_ADD_PID**

- Subsystem: `media: dvb-core:`
- Action verb: **fix** (explicit bug fix)
- Claimed intent: stop leaking a `dmxdev_feed` when `DMX_ADD_PID` fails
  to start a already-running filter

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Reported-by:** syzbot+e9a1f5e196de6663631b@syzkaller.appspotmail.com
  (fuzzer-found, reproducible)
- **Closes:**
  https://syzkaller.appspot.com/bug?extid=e9a1f5e196de6663631b
- **Signed-off-by:** Rituparna Warwatkar (author)
- **Link:**
  https://patch.msgid.link/20260714141059.63582-1-rwarwatkar@gmail.com
- **Signed-off-by:** Mauro Carvalho Chehab (media maintainer, committer)
- **Message-ID:** `<20260714141059.63582-1-rwarwatkar@gmail.com>`
- **No Fixes:** tag (expected for this review pipeline)
- **No Cc: stable** (expected)
- **No Reviewed-by / Tested-by / Acked-by**
- Sasha Levin SOB: not present on this commit (ignored per instructions
  anyway)

Notable pattern: syzbot report + media maintainer SOB.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `dvb_dmxdev_add_pid()` allocates a `dmxdev_feed`, links it
  onto `filter->feed.ts`, then (if the filter is already
  `DMXDEV_STATE_GO`) calls `dvb_dmxdev_start_feed()`. On start failure
  the object stays on the list.
- **Symptom:** leaked feed objects and leaked driver resources allocated
  in `->start_feed()` and meant to be released in `->stop_feed()`.
- **Failure mode:** resource leak; subsequent restart/rollback walks the
  stale list entry.
- **Version info:** none in the message. History shows the pattern dates
  to 2009.
- **Root cause (author):** missing `list_del` + `kfree` on the
  `dvb_dmxdev_start_feed()` error path.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not disguised.** This is an explicit error-path leak fix
(syzbot memory leak). Not a cleanup/refactor.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `drivers/media/dvb-core/dmxdev.c` (+9 / −2; net +7)
- **Function:** `dvb_dmxdev_add_pid()` only
- **Scope:** single-file surgical error-path fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** if `filter->state >= DMXDEV_STATE_GO`, return
  `dvb_dmxdev_start_feed(...)` directly. On failure the feed is already
  on `filter->feed.ts` and is never unlinked or freed.
- **After:** capture the return value; on `ret < 0`,
  `list_del(&feed->next)`, `kfree(feed)`, then return the error. Success
  path still returns 0.
- **Path affected:** error path of `DMX_ADD_PID` while a PES filter is
  already running. Normal success path unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** error-path resource leak, with a follow-on NULL deref /
  UAF on close/stop
- **Mechanism:** `list_add()` happens before start. `list_add()` inserts
  at the **head**. `dvb_dmxdev_start_feed()` sets `feed->ts = NULL` then
  may fail in `allocate_ts_feed()` (ts stays NULL) or fail after
  `release_ts_feed()` (ts dangling). `dvb_dmxdev_feed_stop()` /
  `dvb_dmxdev_filter_stop()` then walk the list and call
  `feed->ts->stop_filtering(feed->ts)` without a NULL check. Close
  (`dvb_dmxdev_filter_free`) always calls those stop/reset paths.
  Because the stale feed is at the head, stop hits it first and never
  stops the original live feed — matching the syzbot vidtv `start_feed`
  leak (mux/PSI objects never destroyed). `dvb_dmxdev_remove_pid()` also
  skips entries with `feed->ts == NULL`, so userspace cannot recover via
  `DMX_REMOVE_PID`.
- **Fix:** unlink and free the new feed if start fails, restoring the
  list to the pre-ioctl state.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** obviously correct. Mirrors the existing success-cleanup
  in `dvb_dmxdev_remove_pid()` (`list_del` + `kfree`).
  `dvb_dmxdev_start_feed()` already releases a partially allocated TS
  feed on its own error paths, so this does not double-free driver TS
  feeds.
- **Minimal:** only the failure branch.
- **Regression risk:** very low. Does not change locking, APIs, or
  success behavior. A remaining unrelated weakness is that
  `dvb_dmxdev_start_feed()` does not NULL `feed->ts` after
  `release_ts_feed()` on set/start_filtering failure; this patch kfree’s
  the wrapper so that dangling pointer is discarded.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Buggy allocate/list_add/start pattern introduced in
  **`1cb662a3144992`** (“V4L/DVB (12275): Add two new ioctls:
  DMX_ADD_PID and DMX_REMOVE_PID”), Andreas Oberritter, 2009-07-14.
- Contained in **v2.6.32-rc1**. Present in this tree and in every
  current LTS.
- Allocation line later became `kzalloc_obj` (`bf4afc53b77ae`, 2026);
  this patch does not depend on that.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Not applicable. The introducing commit is
identified via blame as `1cb662a3144992`, and `git merge-base --is-
ancestor` is not needed for that SHA as a Fixes target; the buggy
function is in this checkout.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Recent `dmxdev.c` commits are unrelated (ringbuffer reopen,
  kzalloc_obj conversion, vb2, mmap, UAF-on-release, etc.).
- No later follow-up on this function: `git log 9fa26c971ca31..HEAD --
  drivers/media/dvb-core/dmxdev.c` is empty.
- **Standalone**, not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Rituparna Warwatkar has this single commit under
`drivers/media/` in this tree. Not a subsystem maintainer. **Mauro
Carvalho Chehab** (media maintainer) committed it, which is the relevant
trust signal.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: **None.** Uses existing `list_del` / `kfree` /
`dvb_dmxdev_start_feed()`. Applies on top of the 2009 function. The
current `kzalloc_obj` line is **not** part of the hunk.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 9fa26c971ca31` →
  https://patch.msgid.link/20260714141059.63582-1-rwarwatkar@gmail.com
- `b4 dig -a`: **v1 only**, single patch, not a series
- `b4 dig -m`: thread is **only the original submission**; no public
  replies, NAKs, or reviewer-added `Cc: stable`
- lore.kernel.org WebFetch returned **403**; discussion recovered from
  the mbox instead
- Applied as submitted by Mauro on 2026-07-27

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To Mauro Carvalho Chehab; Cc linux-media, linux-
kernel, syzbot. No extra reviewers. Maintainer applied it (SOB as
committer).

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record (syzkaller, fetched successfully):
- Title: **memory leak in vidtv_psi_registration_desc_init**
- Status: upstream reported, **C repro**
- Labels: **prio:high**
- Fix commit listed: `9fa26c971ca3`
- Syzbot AI: DenialOfService exploitable, **Unprivileged: yes**
- Duplicate: “memory leak in vidtv_psi_sdt_service_init”
- Two crashes (2026-07-10, 2026-07-21) with C/syz reproducers
- Stack: `vidtv_start_feed` → `dmx_ts_feed_start_filtering` →
  `dvb_dmxdev_start_feed` → `dvb_dmxdev_filter_start` →
  `dvb_demux_do_ioctl` (ioctl path)
- Patch testing on upstream: **OK** (author + another tester)

The leak objects are vidtv PSI/mux allocations from `->start_feed()`.
That matches “drivers that allocate from start_feed and release from
stop_feed” once stop never runs because the stale list head is hit
first.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: standalone v1. Duplicate syzbot bug closed as dup. No sibling
patches required.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable WebFetch returned **403**. **UNVERIFIED**
whether stable@ discussed this. Absence of Cc: stable on the commit is
expected and not used against the patch.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `dvb_dmxdev_add_pid()` modified. Closely involved (not changed):
`dvb_dmxdev_start_feed()`, `dvb_dmxdev_feed_stop()`,
`dvb_dmxdev_filter_stop()`, `dvb_dmxdev_filter_start()`,
`dvb_dmxdev_filter_free()`, `dvb_dmxdev_remove_pid()`.

**Step 5.2: TRACE CALLERS**

Record:
- `dvb_dmxdev_pes_filter_set()` → `dvb_dmxdev_add_pid()` for the initial
  PID. At that point state is `SET` not `GO`, so the start-on-GO branch
  (the bug) is **not** taken there.
- `dvb_demux_do_ioctl()` `DMX_ADD_PID` → `dvb_dmxdev_add_pid()`. This
  **is** the GO-state path after `DMX_START` / immediate start.
- Context: userspace ioctl on `/dev/dvb/adapterX/demuxY`, under
  `dmxdevfilter->mutex`.

**Step 5.3: TRACE CALLEES**

Record: `kzalloc_obj` / historically `kzalloc`, `list_add`,
`dvb_dmxdev_start_feed()` → `allocate_ts_feed` / `tsfeed->set` /
`tsfeed->start_filtering` → driver `start_feed` (e.g. `vidtv_start_feed`
increments `nfeeds` and may call `vidtv_start_streaming`).

**Step 5.4: FOLLOW THE CALL CHAIN**

Record:
`ioctl(DMX_SET_PES_FILTER)` → start filter (`DMXDEV_STATE_GO`, driver
`start_feed`) → `ioctl(DMX_ADD_PID)` → fail `dvb_dmxdev_start_feed` →
stale list entry → `close` / `filter_stop` walks list.

**Userspace reachable: yes.** Syzbot C repro confirms it.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: `dvb_dmxdev_filter_start()` already rolls back with
`dvb_dmxdev_filter_stop()` if a later PID’s `start_feed` fails.
`add_pid` was the missing counterpart. `remove_pid` already does
`list_del`+`kfree`. No other copy of this exact bug in dvb-core.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- `git describe HEAD` → **v7.3-rc4-27-gf0100363d8c37**
- `make kernelversion` → **7.3.0-rc4** (mainline, not an LTS branch
  name)
- File and function exist at `drivers/media/dvb-core/dmxdev.c`
- Pre-fix body confirmed via `git show 9fa26c971ca31^:...`
- Bug introduced **v2.6.32-rc1** (`1cb662a3144992`); not a post-branch
  issue for this tree
- `git merge-base --is-ancestor 9fa26c971ca31 HEAD` → yes (the fix is
  already on this mainline checkout). That is **not** used as circular
  “already selected for stable” reasoning; it only confirms the code
  belongs here.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** Surrounding function has been stable since 2009
aside from the allocator rename, which this hunk does not touch. No
conflicting later edits to this function.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: this *is* the fix. No alternate older fix for the same error
path.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **media / DVB core demux (`drivers/media/dvb-core/`)**.
Criticality: **IMPORTANT** (shared by all DVB adapters; not mm/net core,
not staging). UAPI ioctl `DMX_ADD_PID` in
`include/uapi/linux/dvb/dmx.h`.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: dvb-core is mature; this function is ~17 years old. Occasional
security/leak/UAF fixes. Not a newly added subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **driver/config-specific** — users of DVB demux (`CONFIG` via
media/DVB stack), including the in-tree vidtv test adapter used by
syzbot. Any hardware driver that allocates in `start_feed` and frees in
`stop_feed` can leak the same way.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- Trigger: `DMX_ADD_PID` while a PES TSDEMUX_TAP filter is running, and
  `dvb_dmxdev_start_feed()` fails (allocation busy, invalid frontend,
  driver `-ENOMEM`, etc.).
- How common: error path, but syzbot produced a **C repro**.
- Unprivileged: syzbot assessment says yes (device node permissions
  permitting).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- Primary report: **memory leak** of driver streaming/PSI objects (and
  the `dmxdev_feed` itself)
- On close/stop: **NULL deref or UAF** walking `feed->ts` on the stale
  head entry; live feed never stopped
- Repeatable from ioctl → DoS via leak or oops
- Severity: **HIGH** (syzbot prio:high; leak + crash on teardown)

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit: high** — stops a userspace-triggerable leak/crash in DVB
  core, syzbot-confirmed, long-present bug
- **Risk: very low** — ~7 lines, error path only, maintainer-applied,
  syzbot patch test OK
- **Ratio: strongly favorable**

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real, reproducible leak (syzbot C repro, prio:high)
- Userspace ioctl trigger; unprivileged DoS per syzbot
- Also creates a stale list head that `feed_stop`/`filter_stop`
  dereference (NULL/UAF) so the original feed is never stopped
- Bug in code from **2009** (v2.6.32); present in this tree
- 7-line, obviously correct error-path cleanup
- No new APIs/features; standalone; no prerequisites
- Media maintainer committed it; syzbot patch tests passed

**AGAINST:**
- No public review comments (v1 applied as-is)
- No Fixes/Cc: stable tags (expected here, not a negative)
- DVB is not a universal core path (still a shared subsystem, not
  staging)

**UNRESOLVED:**
- lore.kernel.org and stable@ WebFetch 403; thread recovered via `b4 dig
  -m` (no replies)
- Whether stable@ already discussed it: unverified, not used in the
  decision

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — local code matches the
   described leak; syzbot C repro + patch test OK; maintainer SOB
2. Fixes a real bug that affects users? **PASS** — kmemleak + ioctl
   repro
3. Important issue? **PASS** — HIGH: resource leak and teardown NULL
   deref/UAF, not a style cleanup
4. Small and contained? **PASS** — one function, +9/−2
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — same function, no missing
   helpers

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: not a device-ID/quirk/DT/build/docs exception. It is a normal
important bugfix.

**Step 9.4: MAKE YOUR DECISION**

This is a small, correct error-path leak fix in DVB core, reachable from
`DMX_ADD_PID`, present in this tree since the ioctl was added, and
confirmed by syzbot. It meets stable rules for this checkout.

**What the commit solves for users of this tree:** a failed
`DMX_ADD_PID` on a running filter left a `dmxdev_feed` on
`filter->feed.ts`. Later stop/close walked that stale head entry,
skipped `->stop_feed()` for the live feed, and leaked driver allocations
(vidtv PSI/mux in the repro) and could NULL-deref `feed->ts`.

**Risk vs benefit:** benefit is a real leak/crash fix; risk is a few
lines on an ioctl error path.

**Concerns:** none for apply/prereqs on this tree. lore HTTP 403 did not
block verification because `b4 dig` saved the thread.

Verification:
- [Phase 1] Parsed tags: Reported-by syzbot, Closes syzkaller URL, Link
  msgid, SOB author + Mauro Chehab; no Fixes/Cc:stable
- [Phase 2] Diff: `dvb_dmxdev_add_pid()` only; on
  `dvb_dmxdev_start_feed()` failure, `list_del` + `kfree`
- [Phase 2] Confirmed `list_add` inserts at head;
  `dvb_dmxdev_feed_stop()` does `feed->ts->stop_filtering` without NULL
  check; `remove_pid` skips `ts == NULL`
- [Phase 3] git blame: buggy pattern from `1cb662a3144992` (2009-07-14),
  contained in v2.6.32-rc1
- [Phase 3] No Fixes tag; no follow-ups on `dmxdev.c` after this commit;
  standalone
- [Phase 3] Author has one media commit; maintainer Mauro committed it
- [Phase 4] `b4 dig -c 9fa26c971ca31`:
  https://patch.msgid.link/20260714141059.63582-1-rwarwatkar@gmail.com
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: To Mauro, Cc linux-media/lkml/syzbot
- [Phase 4] `b4 dig -m`: submission only, no replies/NAKs
- [Phase 4] WebFetch syzbot: prio:high, C repro, DoS unprivileged, fix
  SHA 9fa26c971ca3, patch test OK
- [Phase 4] lore.kernel.org and lore.kernel.org/stable WebFetch: 403 —
  UNVERIFIED via HTTP; mbox used instead
- [Phase 5] Callers: `DMX_ADD_PID` ioctl and `pes_filter_set` (GO-state
  path is the ioctl)
- [Phase 5] vidtv `start_feed`/`stop_feed` nfeeds + mux alloc/free
  confirms leak if stop skipped
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37;
  kernelversion 7.3.0-rc4
- [Phase 6] Pre-fix function verified with `git show
  9fa26c971ca31^:drivers/media/dvb-core/dmxdev.c`
- [Phase 6] `git merge-base --is-ancestor 9fa26c971ca31 HEAD`: yes
- [Phase 8] Failure mode: leak + teardown NULL deref/UAF, severity HIGH
- UNVERIFIED: stable@ mailing-list discussion (HTTP 403); not used for
  the verdict

**YES**

 drivers/media/dvb-core/dmxdev.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index ab34be22cd1aa..f6fb54ad05e7a 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -871,6 +871,7 @@ static int dvb_dmxdev_add_pid(struct dmxdev *dmxdev,
 			      struct dmxdev_filter *filter, u16 pid)
 {
 	struct dmxdev_feed *feed;
+	int ret;
 
 	if ((filter->type != DMXDEV_TYPE_PES) ||
 	    (filter->state < DMXDEV_STATE_SET))
@@ -888,8 +889,14 @@ static int dvb_dmxdev_add_pid(struct dmxdev *dmxdev,
 	feed->pid = pid;
 	list_add(&feed->next, &filter->feed.ts);
 
-	if (filter->state >= DMXDEV_STATE_GO)
-		return dvb_dmxdev_start_feed(dmxdev, filter, feed);
+	if (filter->state >= DMXDEV_STATE_GO) {
+		ret = dvb_dmxdev_start_feed(dmxdev, filter, feed);
+		if (ret < 0) {
+			list_del(&feed->next);
+			kfree(feed);
+			return ret;
+		}
+	}
 
 	return 0;
 }
-- 
2.53.0

