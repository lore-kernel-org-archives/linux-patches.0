Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A686653FA11;
	Mon, 19 Oct 2026 14:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418733; cv=none; b=cusUfTiU4mEuw3rc5X1FQnUKcvYrNsby3yssbF0QG0Im0KhZpmleIQIBCOQexSxKYTvkAnWLuFFUtZlUJos+7t4CQLguIUfrXmp2/uCmRb771YxHqwP1botjlyTga0AgTN7eW4+YpPHltR4uL3qvh3yx0zuVfJuBeebTmK61GzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418733; c=relaxed/simple;
	bh=TfjXVatqllOc/iY/Q3aUVmNRuw/gl3fl3bHz3LPdrOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o1N2sjjAEBc+M15BdVNm+UgB15Dln+voFoTrCFDAs6xpy+uhNM8iRtpaxXY67DJB+bGx2PKyVlmoKwdoKgU86qcj0QvykAiztGaB6s7i4sTCwXhm1G8POnUSRtbczwqwTVCl75JFA/w/dYPdDNPGfQfHFmW4VcPxLFfBBtXWZ7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PE+cpiz7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PE+cpiz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3861F000C6;
	Mon, 19 Oct 2026 14:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418728;
	bh=czAK1+Kxgb1MOvp8fqcw27eT99l34C+QFqp+8Yw+G9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PE+cpiz78BNsZwWMJJnIdpLA2TFoE80XAz+fsH/oQKNNWpAsMF/S8HCyx62e1pOBS
	 BuerdfjMMbncx8a6VRi7M0B3fKJgmT0uB95y/Ylj4PXnV+3ult6a8cHRfG4y6AQlB1
	 n2CwQaEc2hx1FMaMlvYITLwQaK8wT6901Div4IDFW2DMWhXgp0oAHGhJz2xL2ROWum
	 9VBzWV/6p/nznyK9DbeKFmFENkie0DnXbsHRfYg7f7kFEgZawME28azV/lxETTfGNF
	 soy4l55GmS3Ag6QZaIx7bljy6Gvp1SYeZmvOY9M8TSLLUkyBUoQFrfaoTU9dFGX5ov
	 mFvg9X/cSxq/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	justin.tee@broadcom.com,
	nareshgottumukkala83@gmail.com,
	paul.ely@broadcom.com,
	axboe@kernel.dk,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] nvme-fc: do not warn on controller removal race
Date: Mon, 19 Oct 2026 09:52:25 -0400
Message-ID: <20261019135441.1420968-454-sashal@kernel.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 62b70e6c87121ae5b79ca20c3a5b005590336ec5 ]

In nvme_fc_reconnect_or_delete(), the system attempts to remove
the controller when reconnect limits are reached by calling
nvme_delete_ctrl(). This call is currently wrapped in a WARN_ON().

If a user concurrently deletes the controller via sysfs, the
controller's state may have already transitioned out of the
CONNECTING state. When this happens, nvme_delete_ctrl() correctly
rejects the operation and returns -EBUSY. Because of the WARN_ON()
wrapper, this race condition triggers an unnecessary kernel warning
stack trace.

Remove the WARN_ON() macro around nvme_delete_ctrl();
this allows the system to safely ignore the -EBUSY return value
if the controller is already being deleted.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the local-tree, diff, history, and review evidence. Below is the
full nine-phase analysis for this 6.18.y checkout.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[nvme-fc] [do not warn] suppress a false-positive WARN_ON when
controller deletion races with reconnect exhaustion`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>` (author)
- `Reviewed-by: Daniel Wagner <dwagner@suse.de>`
- `Signed-off-by: Keith Busch <kbusch@kernel.org>` (NVMe maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`, or `Cc: stable`
  (absence is expected)
- Pipeline-only tags ignored: `[Upstream commit 62b70e6c8712...]`,
  `Signed-off-by: Sasha Levin`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `nvme_fc_reconnect_or_delete()` wraps `nvme_delete_ctrl()` in
  `WARN_ON()`.
- **Symptom:** concurrent sysfs delete can move the controller out of
  `CONNECTING`; `nvme_delete_ctrl()` then correctly returns `-EBUSY`,
  and `WARN_ON()` dumps a kernel warning stack.
- **Root cause:** TOCTOU between the `NVME_CTRL_CONNECTING` check and
  the delete call. `-EBUSY` is a valid result, not a programming error.
- **Version info:** none stated. The `WARN_ON` has been on this call
  since 2017.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. It is an explicit false-positive `WARN_ON` fix
for a real race. Functional delete behavior is unchanged.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/nvme/host/fc.c` (`1 insertion, 1 deletion`)
- Function: `nvme_fc_reconnect_or_delete()`
- Scope: single-file, one-line surgical change

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** after reconnect limits / `dev_loss_tmo` expiry,
  `WARN_ON(nvme_delete_ctrl(&ctrl->ctrl))` fires on any non-zero return.
- **After:** `nvme_delete_ctrl()` is called and `-EBUSY` is ignored.
- Path: reconnect-failure / teardown, not the successful connect path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** race / incorrect assertion (`WARN_ON` on a legitimate
  `-EBUSY`)
- **Mechanism:** `nvme_delete_ctrl()` fails `nvme_change_ctrl_state(...,
  NVME_CTRL_DELETING)` or fails to queue `delete_work` if delete is
  already in progress. The reconnect path already checked
  `nvme_ctrl_state() == NVME_CTRL_CONNECTING` without a lock, so a
  concurrent sysfs/`nvme_delete_ctrl()` can win. The warning is the bug;
  deletion is already handled.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: other `nvme_delete_ctrl()` sites in the same file
  (remoteport unregister, module unload) and RDMA/TCP already omit
  `WARN_ON`.
- Minimal, no API/data-structure change.
- Regression risk is very low: the only behavior change is not warning
  on an expected `-EBUSY`. A still-`CONNECTING` controller is still
  deleted.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `WARN_ON(nvme_delete_ctrl(...))` blamed to `c5017e85705bfe` (“nvme:
  move controller deletion to common code”, Christoph Hellwig,
  2017-10-29).
- That commit replaced `WARN_ON(__nvme_fc_del_ctrl(ctrl))` with
  `WARN_ON(nvme_delete_ctrl(...))`. The common helper can return
  `-EBUSY` on a concurrent delete; the old wrapper’s assumption no
  longer holds.
- Present since ~v4.15-era NVMe-FC code; long-lived in this 6.18 series.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. Introducer is `c5017e85705bfe`,
which is in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Recent `fc.c` work is unrelated (DMA unmap, double-free, tagset, rport
  locking).
- Precedent in-tree: `6622f9acd29cd` “nvme-loop: do not warn for deleted
  controllers during reset” (2021) — same class of false `WARN_ON`
  during concurrent delete.
- Standalone; not `patch X/Y`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Maurizio Lombardi (Red Hat) is a regular NVMe contributor.
Applied by Keith Busch (NVMe maintainer). Reviewed by Daniel Wagner
(SUSE, active NVMe-FC). Thread also has `Reviewed-by: Hannes Reinecke`.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses existing `nvme_delete_ctrl()`. Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 62b70e6c87121ae5b79ca20c3a5b005590336ec5` →
  https://patch.msgid.link/20260908143434.105513-1-mlombard@redhat.com
- `b4 dig -a`: single v1, no later revisions
- Full thread saved via `b4 dig -m`
- Daniel Wagner: “Yes, this makes sense.” + Reviewed-by
- Hannes Reinecke: Reviewed-by
- No NAKs, no risk flags, no `Cc: stable` in review (not a negative)

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Recipients included `kbusch@kernel.org`, `dwagner@suse.de`,
`linux-nvme@lists.infradead.org`. Right maintainers and list. Keith
Busch signed off.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by` / bugzilla / syzbot. Description is a concrete
sysfs-vs-reconnect race, not theoretical cleanup.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone one-patch series. Sibling transports already call
`nvme_delete_ctrl()` without `WARN_ON`.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org WebFetch returned 403. The captured NVMe thread
has no stable discussion. **UNVERIFIED:** whether `stable@` discussed
this commit.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `nvme_fc_reconnect_or_delete()`; callee `nvme_delete_ctrl()`.

**Step 5.2: TRACE CALLERS**
Record:
- `nvme_fc_reset_ctrl_work()` → `nvme_fc_reconnect_or_delete(ctrl,
  -ENOTCONN)` when the remoteport is not `ONLINE`
- `nvme_fc_connect_ctrl_work()` → `nvme_fc_reconnect_or_delete(ctrl,
  ret)` when `nvme_fc_create_association()` fails
Both run on `nvme_wq` after link loss / failed reconnect — a normal SAN
path.

**Step 5.3: TRACE CALLEES**
Record: `nvme_delete_ctrl()` does `nvme_change_ctrl_state(ctrl,
NVME_CTRL_DELETING)` then `queue_work(nvme_delete_wq,
&ctrl->delete_work)`, returning `-EBUSY` if either fails. Sysfs
`delete_controller` uses `nvme_delete_ctrl_sync()` (same `DELETING`
transition).

**Step 5.4: FOLLOW THE CALL CHAIN**
Record:
```
fabric reconnect work / reset work
  → nvme_fc_reconnect_or_delete()
      [state == CONNECTING?]
      → nvme_delete_ctrl()   // races with:
           sysfs delete_controller (CAP_SYS_ADMIN, S_IWUSR)
           nvme_fc_unregister_remoteport()
           nvme_fc_delete_controllers() (module unload)
```
Reachable in production NVMe-FC setups. Sysfs delete needs privilege;
reconnect exhaustion does not.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: At `v6.18.57`, `WARN_ON(nvme_delete_ctrl` exists only in
`drivers/nvme/host/fc.c`. RDMA (`nvme_rdma_reconnect_or_remove`), TCP,
and the other two FC call sites already ignore the return. This site is
the leftover.

semcode MCP: not available; used `git grep` / `rg`.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Local tree: `v6.18.57` (`VERSION=6`, `PATCHLEVEL=18`, `SUBLEVEL=57`;
  `git describe HEAD` = `v6.18.57-155-gcdf239ca885b2`)
- At `v6.18.57`, `drivers/nvme/host/fc.c:3337` is
  `WARN_ON(nvme_delete_ctrl(&ctrl->ctrl));`
- Upstream fix `62b70e6c8712` is **not** an ancestor of `v6.18.57`
- Bug introduced 2017; present in this series

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. Context around the line at `v6.18.57` matches the
patch. `git apply --check` against the `v6.18.57` file succeeded.
Difficulty: clean apply.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No other in-tree commit removes this FC `WARN_ON`. The loop
analog (`6622f9acd29cd`) is already present and does not replace this
fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: NVMe over Fabrics FC host (`drivers/nvme/host/fc.c`).
**IMPORTANT** (enterprise SAN storage), not core mm/VFS, not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained (recent FC locking, tagset, DMA fixes). This
line itself has been stable since 2017.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Config-specific / driver-specific: `CONFIG_NVME_FC` users.
Typical audience is enterprise FC-SAN, i.e. LTS/stable deployments.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Trigger: reconnect attempts exhausted **and** a concurrent delete
  (sysfs, remoteport teardown, or module unload)
- Not every I/O; realistic during link flaps / admin teardown
- Unprivileged users cannot write `delete_controller`; they can
  contribute to reconnect failure. Privilege needed for the sysfs side
  of the described race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Default: `WARN_ON` stack dump (no data loss; delete still happens on
  the other path)
- With `panic_on_warn`: kernel panic during controller teardown
- Severity: **MEDIUM** normally, **HIGH/CRITICAL** if `panic_on_warn` is
  enabled (CI, hardened, some Android/enterprise)

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** medium — stops a user-visible warning and a possible
  `panic_on_warn` crash on a path enterprise NVMe-FC users actually hit
- **Risk:** very low — one line, no locking/API change, matches other
  transports
- **Ratio:** benefit exceeds risk

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real race; `-EBUSY` is correct, `WARN_ON` is not
- `WARN_ON` is a listed strong-yes class (and can panic)
- One-line, obviously correct, reviewed by Wagner/Reinecke, applied by
  Busch
- Buggy line exists in `v6.18.57`; applies cleanly; no prerequisites
- Same file’s other delete sites and RDMA/TCP already omit the warning
- Precedent: nvme-loop “do not warn for deleted controllers”

**AGAINST:**
- Not data corruption / UAF / deadlock
- No public user report or syzbot
- Default impact is a warning, not a functional hang
- NVMe-FC is not universal

**UNRESOLVED:**
- Whether `stable@` discussed it (lore search 403)
- How often the race is hit in the field (no `Reported-by`)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — one-line, two NVMe
   reviewers, maintainer SOB
2. Fixes a real bug that affects users? **PASS** — false `WARN_ON` on a
   reachable race
3. Important issue? **PASS** — `WARN_ON` / possible `panic_on_warn`
   panic; not silent corruption, but in the documented yes class
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — clean on `v6.18.57`

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID / quirk / DT / build / docs exception).
Qualifies as a normal small bugfix.

**Step 9.4: DECISION**
This tree is 6.18.y. The `WARN_ON` is still in `v6.18.57`. The patch is
a one-line removal of a false assertion on a real reconnect-vs-delete
race. It does not change successful-delete behavior, matches every other
NVMe transport, and is the kind of warning-to-panic issue stable should
take.

---

## What the commit solves, and why it matters here

On 6.18.y NVMe-FC, when reconnects are exhausted,
`nvme_fc_reconnect_or_delete()` tries to delete the controller. If
userspace (`delete_controller`) or another teardown path already moved
the controller to `DELETING`, `nvme_delete_ctrl()` returns `-EBUSY` by
design. Wrapping that in `WARN_ON()` turns a handled race into a kernel
warning (or a panic if `panic_on_warn` is set). Removing the wrapper is
the same policy RDMA, TCP, and the other FC delete sites already use.

Risk is negligible; benefit is avoiding a production warning/panic on
enterprise FC fabrics that 6.18.y actually ships.

---

## Verification
- [Phase 1] Parsed tags: author SOB Maurizio Lombardi; Reviewed-by
  Daniel Wagner; SOB Keith Busch; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: 1 line in `nvme_fc_reconnect_or_delete()`;
  `WARN_ON(nvme_delete_ctrl())` → `nvme_delete_ctrl()`
- [Phase 2] `nvme_delete_ctrl()` at `drivers/nvme/host/core.c:257`
  returns `-EBUSY` if state change or `queue_work` fails
- [Phase 2] State machine: `CONNECTING` → `DELETING` or `LIVE` only;
  concurrent delete explains `-EBUSY`
- [Phase 3] `git blame` at parent: line from `c5017e85705bfe` (2017);
  originally `WARN_ON(__nvme_fc_del_ctrl)`
- [Phase 3] `git log -S 'WARN_ON(nvme_delete_ctrl'` on `fc.c`:
  introducer + this removal
- [Phase 3] Related: `6622f9acd29cd` nvme-loop “do not warn…” is already
  an ancestor
- [Phase 3] No later `fc.c` commits after the candidate rewrite this
  line
- [Phase 4] `b4 dig -c 62b70e6c8712`:
  https://patch.msgid.link/20260908143434.105513-1-mlombard@redhat.com
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: kbusch, dwagner, linux-nvme CC’d
- [Phase 4] `b4 dig -m`: Wagner + Reinecke Reviewed-by; no NAK
- [Phase 4] lore WebFetch 403 — used b4 mbox instead
- [Phase 4] UNVERIFIED: stable@ mailing list history (403)
- [Phase 5] Callers verified: `nvme_fc_reset_ctrl_work`,
  `nvme_fc_connect_ctrl_work`
- [Phase 5] Concurrent deleters: `nvme_sysfs_delete` →
  `nvme_delete_ctrl_sync`; `nvme_fc_unregister_remoteport`;
  `nvme_fc_delete_controllers`
- [Phase 5] `git grep` at v6.18.57: only FC reconnect path uses
  `WARN_ON(nvme_delete_ctrl`
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.18.57
- [Phase 6] `git show v6.18.57:drivers/nvme/host/fc.c` line 3337:
  `WARN_ON` present
- [Phase 6] `git merge-base --is-ancestor 62b70e6c8712 v6.18.57` / HEAD:
  not in the 6.18.57 base
- [Phase 6] Apply check of the patch onto the v6.18.57 file: success
- [Phase 7] `CONFIG_NVME_FC`; MAINTAINERS: Keith Busch + NVMe FC
  transport
- [Phase 8] Failure mode: WARN_ON stack / panic_on_warn; severity MEDIUM
  (HIGH if panic_on_warn)
- UNVERIFIED: field frequency (no Reported-by)

The fix is small, surgical, present as a real bug in this 6.18.y tree,
and meets the stable criteria.

**YES**

 drivers/nvme/host/fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index fc7aa3fc6c2b5..186d1beecf32b 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3334,7 +3334,7 @@ nvme_fc_reconnect_or_delete(struct nvme_fc_ctrl *ctrl, int status)
 				ctrl->cnum, min_t(int, portptr->dev_loss_tmo,
 					(ctrl->ctrl.opts->max_reconnects *
 					 ctrl->ctrl.opts->reconnect_delay)));
-		WARN_ON(nvme_delete_ctrl(&ctrl->ctrl));
+		nvme_delete_ctrl(&ctrl->ctrl);
 	}
 }
 
-- 
2.53.0

