Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9034847AF6D;
	Mon, 31 Aug 2026 13:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183356; cv=none; b=ULtPXtfqaeyhz5TxzCjOls1FdgBgWfpjqe+QCYug48hxPU8BqgGxvOYU7wboLDqUaQdLR8i+a9725IPeVvtmmboFMp5deHwcfdrw50D2R8iEDEhZENK1zouMdl9NBXwxHhKpc6s+raX3ohm70K1Ix1EVgHWKA0xnCHp6B1T1+/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183356; c=relaxed/simple;
	bh=kXbKb5kc9ITPSUqllwtRiC9x2pc6HjWC0xoK++Rug6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dz8YPIgG/dIpuwTtUlvytgX4rOKALwQmG9I6uYuWZHSE05uhfh2Cuu5HjEkL6qf0pYty8G97ztuFS3l/sb3K1gg1377NohaBhEBKy6tB64+SRLpECqu1U9kfzFTsH9HmxgVEaITdyClIaUz4ji39yNmRKSJ8Zi6qbhxmQ3MX9Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OrhEoctW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OrhEoctW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0F41F00A3F;
	Mon, 31 Aug 2026 13:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183354;
	bh=HSkhL9GEPh+pjRNfJc8hLKIsYQDXSRpdkikCUwYosQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OrhEoctWOCtSw/GE1uNv1080RfJV4OHV2RZ849wX1Ci21F+GX5gbIXe0i7VURno4w
	 qpcgCCOcD12jrbU+bUdiTR+WfbfGK8UeD9R8w69X05ceL10VRaJRwhhGRmDZ1X4ION
	 DU1JnyOjOEA+ZN/rSlniF6a4mT3IE3n4d/f6zhEPM22dB793to495yq2u8vCmHDJVc
	 BgryyxGypF44z3datQstHbxD/Fzke1NI5ctiubMzCE+awUJzLJIX06fNKJ0mt5UGPN
	 KVsG8KfVGc3DAtbyns2y4wqg+XPNQamRmDjIJfwj/mLMlguNaVm7kLDAvlnwtLie7U
	 BCcoxpA1g9xmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	xen-devel@lists.xenproject.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] xen/front-pgdir-shbuf: free grant reference head on errors
Date: Mon, 31 Aug 2026 09:22:06 -0400
Message-ID: <20260831133314.4125787-98-sashal@kernel.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 678d59219ce0ae883f04c96936222c6168ef1164 ]

grant_references() allocates a private grant-reference head before
claiming references for the page directory and, for guest-owned buffers,
the data pages. The success path frees the remaining head, but claim
failures and grant_refs_for_buffer() errors return immediately.

Unwind through a common exit path so the private grant-reference head is
released even when granting fails part-way through setup. The caller
still tears down any references already stored in buf->grefs.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260629160517.29340-1-alhouseenyousef@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `xen/front-pgdir-shbuf: free grant reference
head on errors`

**Local tree:** Linux 6.18.44 (`v6.18.44-1-g2736c32da98b9`)
**Fix commit (mainline):** `678d59219ce0a` — not an ancestor of this
tree; buggy code is still present.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[xen/front-pgdir-shbuf]` `[free]` — fix missing cleanup of
a private grant-reference head on error paths in `grant_references()`.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Signed-off-by:** Yousef Alhouseen `<alhouseenyousef@gmail.com>`
  (author)
- **Reviewed-by:** Stefano Stabellini `<sstabellini@kernel.org>` (Xen
  maintainer)
- **Signed-off-by:** Juergen Gross `<jgross@suse.com>` (Xen maintainer,
  committer)
- **Message-ID:** `<20260629160517.29340-1-alhouseenyousef@gmail.com>`
- No Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable tags
- Notable: Reviewed by a Xen subsystem maintainer; committed by Xen tree
  maintainer

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `grant_references()` allocates a private grant-reference list
  (`priv_gref_head`) via `gnttab_alloc_grant_references()`. On success,
  unclaimed entries are returned via `gnttab_free_grant_references()`.
  On two error paths (`gnttab_claim_grant_reference()` failure and
  `grant_refs_for_buffer()` failure), the function returned immediately
  without freeing `priv_gref_head`.
- **Symptom:** Unclaimed grant references remain off the global free
  list — a resource leak in the Xen grant table.
- **Root cause:** Missing common error-exit cleanup; caller
  `xen_front_pgdir_shbuf_free()` only tears down refs already stored in
  `buf->grefs`, not the private head list.
- **Version info:** None in the message.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — this is an explicit error-path resource-leak
fix, though described without a crash report.

---

## PHASE 2: DIFF ANALYSIS — LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **File:** `drivers/xen/xen-front-pgdir-shbuf.c` (+8 / −4 lines)
- **Function modified:** `grant_references()` only
- **Scope:** Single-file surgical fix

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Hunk 1 (claim failure in directory loop):** Before: `return cur_ref`
  leaked `priv_gref_head`. After: `ret = cur_ref; goto out_free_refs`.
- **Hunk 2 (`grant_refs_for_buffer` failure):** Before: `return ret`
  leaked head. After: `goto out_free_refs`.
- **Hunk 3 (success path restructured):** Before: free head, `return 0`.
  After: `ret = 0; out_free_refs:
  gnttab_free_grant_references(priv_gref_head); return ret` — same
  success behavior, unified cleanup on all paths after allocation.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Error-path resource leak (grant reference leak)
- **Mechanism:** `gnttab_alloc_grant_references()` removes entries from
  the global grant free pool into a private linked list. Claimed refs
  are removed from that list and stored in `buf->grefs`. Unclaimed refs
  remain in `priv_gref_head` and must be returned via
  `gnttab_free_grant_references()`. Early returns skipped that free,
  permanently shrinking the grant table pool.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- **Quality:** Obviously correct; mirrors the established pattern in
  `gntdev-dmabuf.c` (`out:` label + `gnttab_free_grant_references()`).
- **Regression risk:** Very low. `gnttab_free_grant_references()` only
  frees refs still linked in `priv_gref_head`; already-claimed refs in
  `buf->grefs` are untouched and still cleaned up by the caller on
  failure.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** `grant_references()` introduced in `b3383974fee27`
(Oleksandr Andrushchenko, 2018-11-30) — "xen: Introduce shared buffer
helpers for page directory based frontends." The missing error-path
cleanup has existed since introduction (~kernel 5.0 era).

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No Fixes: tag present — N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Related prior fix `53f131c284e83` (2021): "don't record
wrong grant handle upon error" — different issue (invalid handle on
error), already in this tree. No prerequisite commits needed; standalone
single-patch series (v1 only per b4).

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Yousef Alhouseen is a contributor; this is their Xen front-
pgdir-shbuf fix. Reviewed/committed by Xen maintainers (Stabellini,
Gross).

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No dependencies. `git apply --check` on the fix diff
succeeds cleanly against this tree's file. Standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** `b4 dig -c 678d59219ce0a` → https://patch.msgid.link/2026062
9160517.29340-1-alhouseenyousef@gmail.com
Single v1 submission (2026-06-29). Lore page fetch blocked by bot
protection; thread content not directly readable.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** `b4 dig -w`: To/Cc included Juergen Gross, Stefano
Stabellini, xen-devel@lists.xenproject.org, linux-
kernel@vger.kernel.org. Stefano Stabellini Reviewed-by on committed
version.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No Reported-by or bug-report Link tags. Bug identified via
code-path analysis (missing cleanup), not a syzbot/fuzzer report.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Standalone 1/1 patch; no series dependencies.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched (no stable-list nomination found in commit;
lore stable search not performed due to limited external access).
Absence of Cc: stable is expected per review instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `grant_references()` (modified);
`guest_grant_refs_for_buffer()` (error source via ops callback,
unchanged).

### Step 5.2: TRACE CALLERS
**Record:** `grant_references()` is called only from
`xen_front_pgdir_shbuf_alloc()` (line 534). Callers of
`xen_front_pgdir_shbuf_alloc()`:
- `drivers/gpu/drm/xen/xen_drm_front.c` — Xen PV DRM frontend
- `sound/xen/xen_snd_front_alsa.c` — Xen PV sound frontend
Both run during device/buffer setup on Xen PV guests.

### Step 5.3: TRACE CALLEES
**Record:** `gnttab_alloc_grant_references()`,
`gnttab_claim_grant_reference()`, `gnttab_grant_foreign_access_ref()`,
`buf->ops->grant_refs_for_buffer()` (guest:
`guest_grant_refs_for_buffer()`), `gnttab_free_grant_references()`.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** Xen guest driver probe → buffer alloc → `grant_references()`
→ on failure, `xen_front_pgdir_shbuf_free()` cleans `buf->grefs` but not
`priv_gref_head`. Reachable during normal Xen PV driver initialization;
not a syscall path, but triggered by guest driver operations
(potentially from userspace opening DRM/audio devices).

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Correct pattern already used in `drivers/xen/gntdev-
dmabuf.c` lines 509–511 (`out:
gnttab_free_grant_references(priv_gref_head)`). `drivers/usb/host/xen-
hcd.c` and `drivers/net/xen-netfront.c` also use alloc/free pairs. This
file was the outlier missing error-path free.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **Yes.** `drivers/xen/xen-front-pgdir-shbuf.c` lines 449–451
and 461–462 still have bare `return` on error without freeing
`priv_gref_head`. Bug present since 2018 introduction (`b3383974fee27`).

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply expected.** `git apply --check` on commit
`678d59219ce0a` diff passes with no conflicts on this tree.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** Fix `678d59219ce0a` is **not** in this tree (`git merge-base
--is-ancestor` returns 1). Prior related fix `53f131c284e83` is present.
No duplicate fix applied.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **Subsystem:** Xen grant-table / shared-buffer
infrastructure (`drivers/xen/`). **Criticality:** IMPORTANT — grant
references are a finite global resource shared by all Xen PV drivers
(net, block, USB, DRM, sound, etc.). Leaks affect the whole guest.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Moderate activity; file last touched in-tree by
`50e865a56876b` (2023, kernel-doc cleanup). Core logic stable since
2018.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Xen PV guests with `CONFIG_XEN_FRONT_PGDIR_SHBUF` (selected
by `CONFIG_DRM_XEN` and Xen sound). Affects DRM and audio buffer setup
on Xen; grant-table exhaustion can impact all Xen drivers in the guest.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** Triggered when `grant_references()` fails after
`gnttab_alloc_grant_references()` succeeds — specifically
`gnttab_claim_grant_reference()` returning negative, or
`guest_grant_refs_for_buffer()` failing. Uncommon in steady state
(allocation size matches claim count), but possible under resource
pressure, accounting edge cases, or repeated alloc/free retry loops. Not
unprivileged-direct, but reachable through Xen frontend driver usage.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** **Failure mode:** Grant reference leak → progressive
depletion of global grant free pool → `-ENOSPC` on subsequent grant
operations across the guest (network, block, console, etc.).
**Severity:** HIGH (resource exhaustion degrading entire Xen guest; not
an immediate oops, but can render the guest unusable over time or after
repeated failures).

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** Prevents grant-table leaks on error paths; protects all
  Xen PV functionality
- **Risk:** Very low — 8-line surgical change, maintainer-reviewed,
  matches existing codebase pattern
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real resource leak on error paths (grant references never returned to
  free pool)
- Bug present in this 6.18.y tree since 2018
- Fix is small, obviously correct, maintainer-reviewed
- Applies cleanly to this tree
- Grant-table exhaustion is a serious Xen guest-wide failure mode
- Matches established cleanup pattern in sibling Xen code (`gntdev-
  dmabuf.c`)

**AGAINST backporting:**
- No user crash report or syzbot reproduction
- Error path may be rarely exercised in production
- Affects only Xen PV guests with specific drivers enabled

**Unresolved:** Exact production trigger frequency; lore thread
discussion content (bot-blocked).

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — standard goto cleanup;
   Reviewed-by Xen maintainer
2. Fixes a real bug? **PASS** — grant ref leak on error paths
3. Important issue? **PASS** — grant table exhaustion (HIGH severity for
   Xen guests)
4. Small and contained? **PASS** — 1 file, ~12 lines
5. No new features or APIs? **PASS** — error-path cleanup only
6. Can apply to local tree? **PASS** — `git apply --check` succeeds

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug-fix category.

### Step 9.4: DECISION RATIONALE
This fix closes a long-standing error-path leak in Xen grant-reference
management. While the trigger may be uncommon, leaked grant references
are a finite, guest-wide resource — exhaustion can break networking,
storage, and other PV devices. The patch is minimal, reviewed by Xen
maintainers, applies cleanly to Linux 6.18.44, and introduces no new
behavior on success paths.

---

## Verification

- **[Phase 1]** Parsed commit `678d59219ce0a` message and tags:
  Reviewed-by Stefano Stabellini; Signed-off-by Juergen Gross
- **[Phase 2]** Diff analysis: 3 error-path changes in
  `grant_references()`, adds `out_free_refs` unified cleanup
- **[Phase 3]** `git blame`: buggy code from `b3383974fee27`
  (2018-11-30), present in tree
- **[Phase 3]** `git log -20 -- drivers/xen/xen-front-pgdir-shbuf.c`:
  related fix `53f131c284e83` present; this fix absent
- **[Phase 3]** `git merge-base --is-ancestor 678d59219ce0a HEAD`: exit
  1 — fix not in tree
- **[Phase 3]** `git apply --check` on fix diff: passes cleanly
- **[Phase 4]** `b4 dig -c 678d59219ce0a`: lore URL found
- **[Phase 4]** `b4 dig -a`: single v1 patch, no series
- **[Phase 4]** `b4 dig -w`: Juergen Gross, Stefano Stabellini, xen-
  devel CC'd
- **[Phase 4]** WebFetch lore thread: blocked (bot protection) — review
  discussion unverified
- **[Phase 5]** `grep grant_references`: single caller
  `xen_front_pgdir_shbuf_alloc()`
- **[Phase 5]** `grep xen_front_pgdir_shbuf_alloc`: callers in
  `xen_drm_front.c`, `xen_snd_front_alsa.c`
- **[Phase 5]** Read `gntdev-dmabuf.c` 509–511: confirms correct error-
  path pattern
- **[Phase 5]** Read `grant-table.c` 619–658, 685–692: confirmed
  alloc/claim/free semantics
- **[Phase 6]** `git describe HEAD`: v6.18.44; `Makefile`: 6.18.44
- **[Phase 6]** Read `xen-front-pgdir-shbuf.c` 430–467: confirmed buggy
  early returns present
- **[Phase 6]** Read `xen_front_pgdir_shbuf_free()` 131–142: caller
  cleans `buf->grefs` only, not `priv_gref_head`
- **[Phase 8]** Grant ref leak → pool exhaustion → `-ENOSPC` for all Xen
  grant users: severity HIGH

**YES**

 drivers/xen/xen-front-pgdir-shbuf.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/xen-front-pgdir-shbuf.c b/drivers/xen/xen-front-pgdir-shbuf.c
index 223870a0111b2..e7fb06f607711 100644
--- a/drivers/xen/xen-front-pgdir-shbuf.c
+++ b/drivers/xen/xen-front-pgdir-shbuf.c
@@ -447,8 +447,10 @@ static int grant_references(struct xen_front_pgdir_shbuf *buf)
 		unsigned long frame;
 
 		cur_ref = gnttab_claim_grant_reference(&priv_gref_head);
-		if (cur_ref < 0)
-			return cur_ref;
+		if (cur_ref < 0) {
+			ret = cur_ref;
+			goto out_free_refs;
+		}
 
 		frame = xen_page_to_gfn(virt_to_page(buf->directory +
 						     PAGE_SIZE * i));
@@ -459,11 +461,13 @@ static int grant_references(struct xen_front_pgdir_shbuf *buf)
 	if (buf->ops->grant_refs_for_buffer) {
 		ret = buf->ops->grant_refs_for_buffer(buf, &priv_gref_head, j);
 		if (ret)
-			return ret;
+			goto out_free_refs;
 	}
 
+	ret = 0;
+out_free_refs:
 	gnttab_free_grant_references(priv_gref_head);
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.53.0

