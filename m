Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846E25CDB7F;
	Mon, 19 Oct 2026 14:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418476; cv=none; b=rofrOf2p+Y3f7pz63Hkbr5UzZRY0JUVMhspNwofDYkgZOOo8TyQoZ8Z2MKoeQgq3zDtX23Rpw9u44FveBXdceDonpv0TgarH+/c1pDkwzAa5p30SDnAP7lLPXT4gVDSeON7jx8ngqyF72eXegIK9oTXIo2BuKAIsBqR3NEptaWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418476; c=relaxed/simple;
	bh=2vNjjOL4BVHS72l3hrXYOnFW5T4XsSjcJReEj0tWiR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aV54V+tR0otq6BQVrRzzepeAyaCuqumcvekbZ7IDManhMfyxaEwFdHJy891iJdl3aVXH/yNn0JZY8LUjoYwPx5S3HlRtYGejp+17yeUWtC4rTe53Vvckf2Ic38DYZq3W/l5nP5MDhpDM/u7eHMtEc74lQljpExMAtACM/WcfUIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M5pBQBrG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M5pBQBrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9C21F000C6;
	Mon, 19 Oct 2026 14:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418474;
	bh=+2pbJ771we+h3ohOnYuS+F6Sr49YChib6X+vHKw7WIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5pBQBrGymByiOzgpqERs39DLLuZ8WAOy9jwhMrVdmEF/B9TXFIglOrV2PvcdIcOF
	 km3ZhY9ox29eWGAE3mxOxOukGua8LJj7dg1vwbGNruU3Owle9U3iuXXB+VvjvN9knT
	 XI/xUHAgJ6b5RQ2hRZkBqpczj0f9xDmBZ4KRkbRUOMV2MH314/oPwLWQBK3wUaUfeO
	 6uvMCLPCu9Hg0MlZMvkeuDPHju948Q4tIklUK5PszAOOv8FH9c4M58+/jt5aATbqDT
	 k5zoTCb6jphlm6WoTC8DDFZndP2TCnYuhyO2sgMRskxUeiCFFjnwHp4OCMFiQHTuoe
	 W7JT/NA47L4Hw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chris Lew <christopher.lew@oss.qualcomm.com>,
	Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mathieu.poirier@linaro.org,
	linux-remoteproc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] rpmsg: char: Check for ongoing chrdev destroy
Date: Mon, 19 Oct 2026 09:49:25 -0400
Message-ID: <20261019135441.1420968-274-sashal@kernel.org>
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

From: Chris Lew <christopher.lew@oss.qualcomm.com>

[ Upstream commit 1f9c2897afb0fe86c1fdf4f5e23c5fb8f7442f6d ]

A null pointer panic is observed when stopping a remoteproc and closing
a character device using the RPMSG_DESTROY_EPT_IOCTL. There is a race
where each context calls rpmsg_chrdev_eptdev_destroy(). The thread that
runs second will call cdev_device_del() for a second time, which fails
because the first call already removed the device from sysfs. Add a
check at the beginning of destroy and exit early if the destroy call
has already been done.

[ 26.654130] Call trace
[ 26.656658] kernfs_find_and_get_ns+0x28/0x8
[ 26.661140] sysfs_unmerge_group+0x2c/0x7
[ 26.665357] dpm_sysfs_remove+0x38/0x8
[ 26.669305] device_del+0xa4/0x3e
[ 26.672811] cdev_device_del+0x28/0x7
[ 26.676675] rpmsg_chrdev_eptdev_destroy+0x68/0x98
[ 26.682765] rpmsg_eptdev_ioctl+0x130/0x11c8
[ 26.688318] __arm64_sys_ioctl+0xb4/0x10
[ 26.692448] invoke_syscall+0x50/0x12
[ 26.696312] el0_svc_common.constprop.0+0xc8/0xf
[ 26.701151] do_el0_svc+0x24/0x3
[ 26.704570] el0_svc+0x40/0x17
[ 26.707810] el0t_64_sync_handler+0x120/0x13
[ 26.712288] el0t_64_sync+0x1a0/0x1a

Signed-off-by: Chris Lew <christopher.lew@oss.qualcomm.com>
Signed-off-by: Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260406-rpmsg-char-fix-chrdev-destroy-race-v1-1-7317434fa246@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the race, callers, prerequisites, and mailing-list thread.
Compiling the full 9-phase verdict for this 7.3-rc4 tree.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[rpmsg: char:]` `[Check]` Check for ongoing chrdev destroy —
serialize/idempotent-ize `rpmsg_chrdev_eptdev_destroy()` so a second
destroy does not run `cdev_device_del()` again.

**Step 1.2: Tags**
Record:
- `Signed-off-by: Chris Lew <christopher.lew@oss.qualcomm.com>` (author)
- `Signed-off-by: Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>`
  (submitter)
- `Link: https://lore.kernel.org/r/20260406-rpmsg-char-fix-chrdev-
  destroy-race-v1-1-7317434fa246@oss.qualcomm.com`
- `Signed-off-by: Bjorn Andersson <andersson@kernel.org>`
  (remoteproc/rpmsg maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence expected)
- SHA: `1f9c2897afb0fe86c1fdf4f5e23c5fb8f7442f6d`

**Step 1.3: Body**
Record:
[Bug] Concurrent `rpmsg_chrdev_eptdev_destroy()` from remoteproc
teardown and `RPMSG_DESTROY_EPT_IOCTL`.
[Symptom] NULL-pointer panic in `kernfs_find_and_get_ns` via
`device_del`/`cdev_device_del` (arm64 ioctl stack provided).
[Root cause] Second destroy calls `cdev_device_del()` after the first
already removed the device from sysfs.
[Fix] Under `ept_lock`, if `eptdev->rpdev` is already NULL, return 0.
[Versions] None stated.

**Step 1.4: Hidden bug fix?**
Record: No — this is an explicit race/panic fix, not cleanup disguised
as a fix.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record: `drivers/rpmsg/rpmsg_char.c` only, **+5 / -0**. Function:
`rpmsg_chrdev_eptdev_destroy()`. Single-file surgical fix.

**Step 2.2: Flow change**
Record: Before: every caller locked, set `rpdev = NULL`, tore down the
endpoint, unlocked, woke readers, then always `cdev_device_del()` +
`put_device()`. After: if `rpdev` is already NULL, unlock and return;
only the first destroy does sysfs/cdev teardown.

**Step 2.3: Bug mechanism**
Record: **Race / double `device_del`**. First destroy clears `rpdev`
under `ept_lock` then deletes the device. Second destroy used to delete
again → NULL deref in sysfs. Guard reuses the existing `rpdev == NULL`
“already released” flag from `17b88a2050e9d`.

**Step 2.4: Fix quality**
Record: Minimal and consistent with `rpmsg_eptdev_open()` (`!rpdev` →
`-ENETRESET`). Mutex serializes the check/set. Second path also skips a
second `put_device()`, which is correct (only one destroy should drop
the register/init ref). Regression risk is low; remaining window is
“second thread still takes `ept_lock` after teardown started,” which is
safe while the ioctl file or `device_for_each_child()` holds a device
ref.

---

## Phase 3: Git history

**Step 3.1: Blame**
Record: Destroy body dates to `c0cdc19f84a471` (“rpmsg: Driver for user
space endpoint interface”, **v4.11-rc1**). `eptdev->rpdev = NULL` from
`17b88a2050e9d` (**v6.3-rc1**). `cdev_device_del` from `7a534ae89e34e`
(v5.17 era). This 5-line guard is `1f9c2897afb0fe` (v7.3-rc1).

**Step 3.2: Fixes: tag**
Record: None. Implicitly completes the v6.3 `rpdev = NULL` locking,
which did not make destroy idempotent.

**Step 3.3: Related commits (path-limited)**
Record:
- `17b88a2050e9d` — lock + `rpdev = NULL` (prerequisite for this check)
- `c23965b7f7d99` — `ctrl_lock` in `rpmsg_ctrldev_remove` (CREATE vs
  remove only; does **not** cover endpoint DESTROY ioctl)
- `467233a4ac29b` — avoid double destroy of default endpoint
- `7a534ae89e34e` — switch to `cdev_device_del`
- Standalone v1 patch, not `n/m`

**Step 3.4: Author**
Record: Chris Lew is a regular Qualcomm rpmsg/glink contributor; Vishnu
submitted; Bjorn Andersson (maintainer) applied it.

**Step 3.5: Dependencies**
Record: Needs `ept_lock` and `eptdev->rpdev = NULL` in destroy
(`17b88a2050e9d`). Both are in this tree (`git merge-base --is-ancestor`
exit 0). Applies standalone here.

---

## Phase 4: Mailing list

**Step 4.1:** `b4 dig -c 1f9c2897afb0fe` →
https://lore.kernel.org/r/20260406-rpmsg-char-fix-chrdev-destroy-
race-v1-1-7317434fa246@oss.qualcomm.com
`b4 dig -a`: **v1 only**. Thread: submission + Bjorn “Applied, thanks!”
(`1f9c2897afb0fe`). No NAK, no review comments, no reviewer `Cc:
stable`.

**Step 4.2:** `b4 dig -w`: To/Cc Bjorn Andersson, Mathieu Poirier,
`linux-remoteproc`, `linux-kernel`, Deepak Singh, Chris Lew.

**Step 4.3:** Bug report is the in-message crash trace (Qualcomm
remoteproc + DESTROY ioctl). No syzbot/bugzilla.

**Step 4.4:** Single-patch series; no sibling patches required.

**Step 4.5:** lore.kernel.org WebFetch returned 403. `b4 dig -m` got the
full thread (2 messages). No stable-list discussion found in that
thread.

---

## Phase 5: Semantic / call-path analysis

**Step 5.1:** Modified: `rpmsg_chrdev_eptdev_destroy()`.

**Step 5.2: Callers** (verified with grep):
1. `rpmsg_eptdev_ioctl()` / `RPMSG_DESTROY_EPT_IOCTL` — userspace ioctl
   (stack in the commit)
2. `rpmsg_chrdev_remove()` — `device_for_each_child(...,
   rpmsg_chrdev_eptdev_destroy)` on rpmsg device removal
3. `rpmsg_ctrldev_remove()` — same for the control device when
   remoteproc/rpmsg device goes away

**Step 5.3:** Callees: `mutex_lock/unlock`, `rpmsg_destroy_ept`,
`wake_up_interruptible`, `cdev_device_del` → `device_del` →
`dpm_sysfs_remove`, `put_device`.

**Step 5.4:** Reachable from userspace ioctl while firmware is stopped.
`ctrl_lock` only wraps CREATE/RELEASE on the **ctrl** fd, not DESTROY on
the **endpoint** fd — so the race is real.

**Step 5.5:** Same `!rpdev` pattern already used in
`rpmsg_eptdev_open()`. No other copy of this exact double-destroy bug
in-tree.

---

## Phase 6: This checkout

**Step 6.1:** Local tree: **`v7.3-rc4-27-gf0100363d8c37`**, `VERSION=7
PATCHLEVEL=3` (`7.3.0-rc4`).
Buggy function exists at `drivers/rpmsg/rpmsg_char.c`. Dual call paths
exist. Commit is already an ancestor (`git merge-base --is-ancestor
1f9c2897afb0fe HEAD` → 0) because it landed in **v7.3-rc1**. That is the
mainline landing, not a reason to reject on technical merit. Parent of
the commit still has the unguarded destroy.

**Step 6.2:** Parent destroy matches this tree aside from the 5-line
guard. Backport difficulty: **clean apply** onto any tree that already
has `17b88a2050e9d`.

**Step 6.3:** No later follow-up on this file after `1f9c2897afb0fe`. No
alternate fix for this double-`cdev_device_del` race.

---

## Phase 7: Subsystem

**Step 7.1:** `drivers/rpmsg/` — IMPORTANT for Android/embedded
remoteproc (Qualcomm, TI, ST), not core mm/VFS. Panic on a user ioctl
still matters.

**Step 7.2:** Mature driver (since v4.11), ongoing Qualcomm/Linaro
fixes. This is a long-standing race, not a brand-new API.

---

## Phase 8: Impact and risk

**Step 8.1:** Users with `CONFIG_RPMSG_CHAR` who stop a remote processor
while userspace DESTROYs an endpoint (typical Qualcomm/Android rpmsg).

**Step 8.2:** Trigger: remoteproc stop **and**
`RPMSG_DESTROY_EPT_IOCTL`. Timing-dependent but demonstrated.
Unprivileged userspace with the endpoint fd can be one side of the race.

**Step 8.3:** Failure: kernel NULL deref / oops in `device_del`.
**Severity: CRITICAL**.

**Step 8.4:** Benefit high (prevents oops). Risk very low (5 lines,
existing lock/flag). Ratio strongly favors backport.

---

## Phase 9: Synthesis

**For:** Real oops with stack; userspace-reachable race; 5-line
idempotent destroy; maintainer-applied; prereqs present; matches stable
rules.

**Against:** No `Fixes:`/`Cc: stable`; no extra `Reviewed-by`; rpmsg-
char not universal on desktops; uses `rpdev` as a destroyed flag
(already established in v6.3).

**Unresolved:** Direct lore HTTP 403 (thread recovered via `b4`). No
independent stable@ discussion.

**Stable rules:**
1. Obviously correct and tested? **PASS** — lock + existing flag; crash
   reproduced by author.
2. Real user bug? **PASS** — oops on remoteproc stop + ioctl.
3. Important? **PASS** — kernel panic.
4. Small/contained? **PASS** — +5 lines, one function.
5. No new features/APIs? **PASS**.
6. Applies to this tree? **PASS** — same function/callers; prereq
   `17b88a2050e9d` present.

**Exception category:** None needed; this is a normal crash fix.

This is a textbook stable candidate: a small, obviously correct guard
that stops a double `cdev_device_del()` oops when remoteproc teardown
races `RPMSG_DESTROY_EPT_IOCTL`. The affected code and the `rpdev =
NULL` flag it depends on are in this tree.

Verification:
- [Phase 1] Parsed tags: Chris Lew/Vishnu SOB, Bjorn SOB, lore Link; no
  Fixes/Reported-by/Cc stable
- [Phase 2] Diff: +5 lines in `rpmsg_chrdev_eptdev_destroy()` after
  `mutex_lock(&eptdev->ept_lock)`
- [Phase 2] Confirmed `cdev_device_del()` always calls `device_del()`
  (`fs/char_dev.c`); second `device_del` matches the
  `dpm_sysfs_remove`/`kernfs_find_and_get_ns` stack
- [Phase 3] `git blame`: `rpdev = NULL` from `17b88a2050e9d` (v6.3-rc1);
  function from `c0cdc19f84a471` (v4.11-rc1)
- [Phase 3] `git merge-base --is-ancestor 17b88a2050e9d HEAD` → present;
  `1f9c2897afb0fe` also ancestor (landed v7.3-rc1)
- [Phase 3] Parent of `1f9c2897afb0fe` still does unconditional
  `cdev_device_del`
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 only; Bjorn applied; maintainers
  CC’d; no NAK
- [Phase 4] WebFetch lore/stable: 403; thread contents verified from
  `/tmp/rpmsg-destroy-thread.mbox`
- [Phase 5] Callers: ioctl DESTROY, `rpmsg_chrdev_remove`,
  `rpmsg_ctrldev_remove`; `ctrl_lock` does not cover DESTROY
- [Phase 6] `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` → 7.3.0-rc4
- [Phase 8] Failure mode: NULL deref oops, CRITICAL
- UNVERIFIED: public lore HTML (403); whether a given older LTS lacks
  `17b88a2050e9d` (this tree has it)

**YES**

 drivers/rpmsg/rpmsg_char.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/rpmsg/rpmsg_char.c b/drivers/rpmsg/rpmsg_char.c
index d918cb30db9b0..3edc95f48967b 100644
--- a/drivers/rpmsg/rpmsg_char.c
+++ b/drivers/rpmsg/rpmsg_char.c
@@ -79,6 +79,11 @@ int rpmsg_chrdev_eptdev_destroy(struct device *dev, void *data)
 	struct rpmsg_eptdev *eptdev = dev_to_eptdev(dev);
 
 	mutex_lock(&eptdev->ept_lock);
+	if (!eptdev->rpdev) {
+		mutex_unlock(&eptdev->ept_lock);
+		return 0;
+	}
+
 	eptdev->rpdev = NULL;
 	if (eptdev->ept) {
 		/* The default endpoint is released by the rpmsg core */
-- 
2.53.0

