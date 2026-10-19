Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3074164A875;
	Mon, 19 Oct 2026 14:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418808; cv=none; b=LqkmBRROU/19HJXuASdQqp0bU2q/YL2tdqAvDrzK+lXt6xvyuywwvvVH+cxgOA1+d2lwMLBlFY70nEDTmfew6aM9vhGjD3eYLXoNpCAVtb2hAdKIe3AWL49asQ5aMsw643tFQ0hTbpu2xh/TghwXDH3fU+8S8Xdjwf14FbPrRcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418808; c=relaxed/simple;
	bh=aISxnCal5n++tChH+QVmU064sZT6GETF+i9liZ6pjJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wnv7DT/okiQTdN/rn6hk1+4pTQgmX83K8gnZIQG7Dz0uMqxbhiVybMu0L63M1cMXEpO6FMOqRBbJbKeqtf9NmnyTl7kZm3JdY3c0RzrivVNjzSbsSrixXE8Cn0hWAX/6c9XKsoY7RQ/8HOWkV3ZsIcBoAhqZJhWPbUQ5CIDwOvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O76lS/KK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O76lS/KK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43191F000CD;
	Mon, 19 Oct 2026 14:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418805;
	bh=yQu/sakkYOBaQWWxQz5VILvUfek9BvuHnlIow+z0Hs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O76lS/KK2teE7CTgIdZuWEecVXdisUyoOXIUVayKoeTb/mYVpKSS92I3vrGBUyBln
	 dFigPebfW2A/nC9WgBWFqPG0RMceC7qdXdivCzzheabsT3E2qctwnwcV4idbACMuI5
	 bGXHN3LliXnQyEOl0Z5xWyVKkj3pKvomP43eCRKejKlQamSnHR5TBgJyv8wdsJzgSd
	 ZiiUDSFlnobifOBuJ7ogehBWksJZZNWi4DXDTCvd4OZAnbc2b+MJczKKkAZcef4Mzg
	 fHQmeUG4gDDT7IkU8nmb89ukg6p279fq/J60tr0M7WyW1P37Q6SP8ZGLZMvJTLcrNn
	 /HUl7+Il/64Kw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yuho Choi <dbgh9129@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	dakr@kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] driver core: attribute_container: Unwind device_add() on attr failure
Date: Mon, 19 Oct 2026 09:53:20 -0400
Message-ID: <20261019135441.1420968-509-sashal@kernel.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 8cfe7ad274bb42c4653b645267410d4a3a23db98 ]

attribute_container_add_class_device() first calls device_add() and then
creates the container attributes. If attribute_container_add_attrs() fails,
the helper returns the error with the class device still registered.

Callers use an error from this helper as a failed add and do not call
device_del() on that path. Undo the successful device_add() before
returning the attribute creation error.

Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260608172717.88657-1-dbgh9129@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: **[driver core / attribute_container] [Unwind] [on
`device_add()` success, roll back if attribute creation fails]**

**Step 1.2: Tags**
Record:
- **Link:**
  `https://patch.msgid.link/20260608172717.88657-1-dbgh9129@gmail.com`
- **Signed-off-by:** Yuho Choi (author)
- **Signed-off-by:** Greg Kroah-Hartman (driver-core maintainer)
- **Committer:** Danilo Krummrich
- **No** `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence of the last two is expected for this
  review)
- Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
  …]` markers; they are not in the real commit

**Step 1.3: Body**
Record:
- **Bug:** `attribute_container_add_class_device()` does `device_add()`
  then `attribute_container_add_attrs()`. If attrs fail, the helper
  returns the error while the class device stays registered.
- **Symptom:** Callers treat the helper error as a failed add and do
  **not** `device_del()` that classdev.
- **Root cause:** Missing unwind of a successful `device_add()` on a
  later failure (classic probe-style leak).
- **Version info:** None in the message. History shows this pattern
  since 2005/2008.

**Step 1.4: Hidden bug fix?**
Record: **Not hidden.** This is an explicit error-path unwind /
leftover-registered-device fix, not a style cleanup.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- **File:** `drivers/base/attribute_container.c` — **+6 / −1**
- **Function:** `attribute_container_add_class_device()`
- **Scope:** single-file, surgical, error path only

**Step 2.2: Code flow**
Record: **Before:** `device_add()` success → `return
attribute_container_add_attrs()` (classdev stays registered on attr
failure). **After:** store attr error; on failure call
`device_del(classdev)`; return that error. Normal success path
unchanged.

**Step 2.3: Bug mechanism**
Record: **[error-path resource leak / incomplete unwind]**
`device_add()` publishes the classdev (sysfs, parent child list,
kobject). `attribute_container_add_attrs()` can fail via
`sysfs_create_group()` or `device_create_file()` (typically `-ENOMEM`,
also `-EEXIST` / other sysfs errors). Returning that error without
`device_del()` leaves a live classdev. Pairing is correct: callers
`device_initialize()` + this helper’s `device_add()`, so unwind is
`device_del()`, not `device_unregister()`.

**Step 2.4: Fix quality**
Record: **Obviously correct, textbook unwind, no API/data-structure
change.** Regression risk is low. Verified callers of this helper do
**not** `device_del(classdev)` on this error (they go to
`tclass->remove` only). `tclass->remove` implementations
(`sas_host_remove`, `fc_host_remove`, `iscsi_remove_host`,
`raid_remove`) do not `device_del` the classdev. No double-`device_del`.

---

## Phase 3: Git history

**Step 3.1: Blame**
Record: Missing unwind is original behavior.
- Function in `1da177e4c3f41` (Linux 2.6.12-rc2, 2005) as
  `class_device_add` + attrs.
- `ee959b00c335d7` (2008) converted it to `device_add` (`SCSI: convert
  struct class_device to struct device`).
- Bug present for ~18 years. This tree’s current lines 428–433 are this
  commit.

**Step 3.2: Fixes: tag**
Record: **None.** Equivalent historical target would be `1da177e4c3f41`
/ `ee959b00c335d7`. Both are ancestors of this tree.

**Step 3.3: File history**
Record (recent, this file): related error-path work already here:
- `e5da06b27ff5a` (2023) — `transport_class`: call `->remove()` if
  `transport_add_device()` fails (Fixes: `1da177e4c3f4`)
- `cd7ea70bb00aa` — propagate transport add errors
- `6e328b4a208f7` — unwind statistics group if encryption group create
  fails
This commit is **standalone** (not `n/m`). It complements those; it does
not depend on `6e328b4a208f7`.

**Step 3.4: Author**
Record: Yuho Choi is not the subsystem maintainer (a few driver-
core/regmap error-path patches). Weight comes from **Greg Kroah-Hartman
SOB** and **Danilo Krummrich** committing it.

**Step 3.5: Dependencies**
Record: **None.** Needs only `device_add` / `device_del` /
`attribute_container_add_attrs()`, all long-standing. Applies
standalone. `git merge-base --is-ancestor 8cfe7ad274bb4 HEAD` → **yes**
(commit is already in this checkout).

---

## Phase 4: Mailing list / external

**Step 4.1:**
Record: `b4 dig -c 8cfe7ad274bb4` →
https://patch.msgid.link/20260608172717.88657-1-dbgh9129@gmail.com
`b4 dig -a`: **v1 only**, 2026-06-08. Saved mbox: **one message** (the
patch), **no replies**. Direct lore fetch returned **403**. No NAKs
found. No public reviewer request for `Cc: stable`.

**Step 4.2:**
Record: `b4 dig -w` recipients: Greg Kroah-Hartman, Rafael J. Wysocki,
Danilo Krummrich, `driver-core@lists.linux.dev`, `linux-
kernel@vger.kernel.org`. Right maintainers were on the original To/Cc.

**Step 4.3:**
Record: **No bugzilla/syzbot/user report.** Looks like code inspection,
not a production crash report.

**Step 4.4:**
Record: Standalone v1, not a multi-patch series.

**Step 4.5:**
Record: Web search of lore/stable for this subject/author found **no**
stable-list discussion (search results were unrelated). **UNVERIFIED:**
whether anyone previously rejected it for stable.

---

## Phase 5: Semantic / call graph

**Step 5.1:**
Record: Modified function: `attribute_container_add_class_device()`.

**Step 5.2: Callers**
Record (this tree):
1. `transport_add_class_device()` in `drivers/base/transport_class.c` —
   **the live caller**. On helper error → `err_remove` →
   `tclass->remove` only, **not**
   `attribute_container_class_device_del()`.
2. Default `fn == NULL` path in `attribute_container_add_device()` —
   still present; **no in-tree caller passes NULL**
   (`attribute_container_add_device` is only used from
   `transport_setup_device()` with `transport_setup_classdev`).

`transport_add_device()` / `transport_register_device()` are used by
SCSI (SAS/FC/iSCSI/SRP/SPI, `scsi_sysfs.c`) and **libata**. Always-
built: `drivers/base/Makefile` lists `attribute_container.o` and
`transport_class.o`.

**Step 5.3: Callees**
Record: `device_add`, `attribute_container_add_attrs` →
`sysfs_create_group` / `device_create_file`, and on failure
`device_del`.

**Step 5.4: Reachability**
Record: **Yes, from normal storage bring-up**, not a syscall gadget.
Path: SCSI/ATA device add → `transport_add_device()` →
`transport_add_class_device()` → this helper. Trigger is **attr creation
failure**, not every boot. Unprivileged users cannot typically force it
except via memory pressure / device hotplug.

**Step 5.5: Similar patterns**
Record: Same file already uses `attribute_container_class_device_del()`
= remove attrs + `device_del`. `e5da06b27ff5a` is the sibling leak on
the transport `->setup()`/`->remove()` side. This fills the remaining
`device_add` hole.

---

## Phase 6: This checkout

**Step 6.1:**
Record: **Local tree: `v7.3-rc4-27-gf0100363d8c37`, `make kernelversion`
= 7.3.0-rc4** (mainline, VERSION 7 / PATCHLEVEL 3).
Buggy pre-image exists as parent of `8cfe7ad274bb4`; the **fix is
already in HEAD**. Surrounding helper and SCSI/ATA callers exist and
match the commit’s claim. Bug introduced ~2.6.12 / 2008 conversion —
**long before this tree**.

**Step 6.2:**
Record: Function body before the commit is exactly the diff context.
**Clean apply** on this lineage. No conflicting refactor of this helper.

**Step 6.3:**
Record: Related transport unwind (`e5da06b27ff5a`, `6e328b4a208f7`) is
already here. **No alternate fix** of this specific
`device_add`/`add_attrs` hole besides `8cfe7ad274bb4`.

---

## Phase 7: Subsystem context

**Step 7.1:**
Record: **driver core (`drivers/base/`)** used by SCSI/ATA transport
classes. Criticality: **IMPORTANT** (not mm/scheduler, but common on
servers/storage). Not staging.

**Step 7.2:**
Record: File is mature (2005); recent commits are small fixes and
treewide alloc changes, not a rewrite. Fits a long-standing error-path
hole, not a new-API follow-up.

---

## Phase 8: Impact and risk

**Step 8.1:**
Record: **Driver-core + SCSI/ATA/iSCSI/FC/SAS users** (large storage
population). Not universal for every kernel, but a default
`drivers/base` object.

**Step 8.2:**
Record: Trigger = `attribute_container_add_attrs()` failure after
successful `device_add()`. Uncommon (mostly ENOMEM / sysfs errors)
during host/target/rport/phy add. Not a race. Not a normal unprivileged
syscall.

**Step 8.3:**
Record: **Failure mode: leftover registered classdev** (sysfs node,
parent child, refs). Callers that then `device_del()` the **parent**
(verified: `ata_tport_add`, `sas_phy_add`) can tear down a parent while
the classdev child is still registered. That is sysfs/kobject
inconsistency, leak, and possible later `-EEXIST` / warnings — **HIGH**,
not a panic on the happy path. Not a CVE-class issue from the evidence
found.

**Step 8.4:**
Record: **Benefit: medium-high** for storage error paths (correct
unwind, avoids stale classdev). **Risk: very low** (5 net lines, error
path, pairing `device_add`/`device_del`). Ratio favors inclusion.

---

## Phase 9: Synthesis

**Step 9.1: Evidence**

**For:**
- Real incomplete unwind: registered device returned as failure
- Callers verified not to `device_del(classdev)` on that error
- Parent `device_del` after this failure is a concrete consistency
  hazard (libata/SAS)
- Tiny, obviously correct; Greg KH signed off
- Same class as `e5da06b27ff5a`, which treated this area as a real leak
  (`Fixes: 1da177e4c3f4`)
- Code and callers exist in this tree; no extra commits required
- Always-built driver core, SCSI/ATA bring-up

**Against:**
- No `Reported-by` / syzbot / crash log
- Error path only; not a guaranteed oops
- No public review comments in the matched thread
- No `Fixes:` (author omission, not a reason to reject)

**Unresolved:** lore HTTP 403; no stable-list hit; how often
`add_attrs()` fails in the field.

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — pairing is standard; merged
   by driver-core (no extra test tags).
2. Real user-affecting bug? **PASS** — leftover classdev on SCSI/ATA add
   failure.
3. Important (crash/security/corruption/deadlock)? **PASS** at leak /
   kobject-inconsistency severity (HIGH, not panic). Matches error-path
   leak fixes stable routinely takes.
4. Small and contained? **PASS** — one function, +6/−1.
5. No new features/APIs? **PASS**.
6. Can apply to this tree? **PASS** — context matches; already ancestor
   of HEAD, so no backport conflict here.

**Step 9.3: Exception category**
Record: **None** (not a device ID/quirk/DT/build/doc exception). It is a
normal small bugfix.

**Step 9.4: Decision**
This tree is **mainline 7.3-rc4**, which already contains the fix. That
does not make the change “already selected for stable”; it means the
buggy helper and the SCSI/ATA callers this commit talks about **are this
tree’s code**. The patch is a self-contained unwind of a leaked
registered class device. It should be treated as stable-worthy for this
codebase.

---

## What the commit solves for this tree

`attribute_container_add_class_device()` is the helper behind SCSI/ATA
transport class devices. It published the classdev, then created
attributes, and on attribute failure returned an error while leaving the
classdev registered. `transport_add_class_device()` treats that as a
failed add and only runs `tclass->remove()` (bsg/raid cleanup), not
`device_del()`. ATA/SAS callers then `device_del()` the **parent**. That
is a real leak and a parent/child sysfs mismatch on a failed add.

The fix is five lines: `device_del()` if
`attribute_container_add_attrs()` fails. No new API, no series
dependency, low regression risk.

---

## Verification

- **[Phase 1]** Parsed `8cfe7ad274bb4`: Link + two SOBs (Yuho Choi, Greg
  KH); committer Danilo Krummrich; no Fixes/Reported-by/Cc:stable
- **[Phase 2]** Diff: `attribute_container_add_class_device()` +6/−1;
  `device_del` on attr error only
- **[Phase 2]** Read `transport_add_class_device()`: helper error →
  `err_remove`, not `err_del` / `attribute_container_class_device_del`
- **[Phase 2]** Read `sas_host_remove` / `fc_host_remove` /
  `iscsi_remove_host` / `raid_remove`: no `device_del(classdev)`
- **[Phase 3]** `git blame`: hole from `1da177e4c3f41` (2005) /
  `ee959b00c335d7` (2008)
- **[Phase 3]** `git show 8cfe7ad274bb4^`: pre-image is `return
  attribute_container_add_attrs(classdev);`
- **[Phase 3]** Related: `e5da06b27ff5a` (2023 transport remove-on-add-
  fail), already in this tree
- **[Phase 3]** `git merge-base --is-ancestor 8cfe7ad274bb4 HEAD` → yes
- **[Phase 4]** `b4 dig -c/-a/-w/-m`: v1 only; maintainers CC’d; mbox
  has patch only, no replies
- **[Phase 4]** WebFetch lore: 403; stable search: no matching thread
- **[Phase 5]** Callers: `transport_class.c` + unused-looking NULL-fn
  path with no in-tree NULL caller
- **[Phase 5]** `transport_add_device` used from SCSI transports +
  `libata-transport.c` + `scsi_sysfs.c`
- **[Phase 5]** Confirmed `ata_tport_add` / `sas_phy_add` `device_del()`
  the parent on `transport_add_device()` error
- **[Phase 6]** `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` = 7.3.0-rc4
- **[Phase 6]** `drivers/base/Makefile`: `attribute_container.o` always
  built
- **[Phase 8]** Failure mode: leftover registered classdev / parent-
  child unwind bug, severity HIGH not panic
- **UNVERIFIED:** in-field hit rate of `add_attrs()` failure; any
  private review beyond the empty lore thread

**YES**

 drivers/base/attribute_container.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index b6f941a6ab693..b1d6eb6ab46b5 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -427,7 +427,12 @@ attribute_container_add_class_device(struct device *classdev)
 
 	if (error)
 		return error;
-	return attribute_container_add_attrs(classdev);
+
+	error = attribute_container_add_attrs(classdev);
+	if (error)
+		device_del(classdev);
+
+	return error;
 }
 
 /**
-- 
2.53.0

