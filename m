Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F113370E4;
	Tue,  5 May 2026 09:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974795; cv=none; b=Jyz6PA9mhyYL6laegSroSHxHgXBHgkndpJ9Rd0W8rksi5n+4Tmg+dzf8woYH/f14MFKp4LccPDdPccIxt3Lxk6Ju8OpexHttOgRrs7Ka+tu6VI6TiAjPR38PhJeGezIXKfwY1FUfC6I5YpQEI/0IpG/j9UQX6BKVnpFvQ7WVb/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974795; c=relaxed/simple;
	bh=RboG9kYuRaM9umuhlHg6mVhf2LLLr+s+TsR0YegzkQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ql02NqzQrt1Fvns2FjWZDcfnGPLnTqM+MHuKTGh2jA+8plyGFwyMT/Rt7ojocaKJdPYgJ6tCiUkfEUiAPQrOy1fGodIbJknIKKS7L7MkT/cQNMWmrNaxB/yxz2xvt+dPMljePH3GwHXdlwgxxQRZeM9dMu+HADJ+eWH2YURI0kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tH9jetrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tH9jetrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C43C2BCB4;
	Tue,  5 May 2026 09:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974795;
	bh=RboG9kYuRaM9umuhlHg6mVhf2LLLr+s+TsR0YegzkQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tH9jetrrOQfgDxNDENoV3CraEMkTpgjCdYPda7sd6NkrqocswGh4mglNV44QXmoLr
	 au+A46Z4xDEuehcf6zQZA1i99EAJDmn4KfNgrjszj5jUvauDUkp1sTAxv7J9FB7GVn
	 xmckwyY036jYWqCZR92kL/iPEzBIjXDdvY5wxN9sNbcwO6l068PGVS69ELzi7xBybZ
	 aykS1xB/ThkWPTtEcTrAXvqouUmLO14okxuSuauN5U6tZxggjpf+K4ZMSaoeinyhvL
	 spDHAZkLUGtYWadJaRmrXtLw8zffHtnha9HDzFrLZpkchheHRmHdDUN3Ptu2C7s0G5
	 9D/MiNGzAayHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] nvme-multipath: put module reference when delayed removal work is canceled
Date: Tue,  5 May 2026 05:51:43 -0400
Message-ID: <20260505095149.512052-27-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505095149.512052-1-sashal@kernel.org>
References: <20260505095149.512052-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 3f150f0f010f234f34a67897344f18e68fe803f7 ]

The delayed disk removal work is canceled when a NS (re)appears. However,
we do not put the module reference grabbed in nvme_mpath_remove_disk(), so
fix that.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Decision Summary
This should be backported to stable trees that contain NVMe multipath
delayed removal, especially `v6.16+` trees checked locally. It fixes a
real module reference leak: `nvme_mpath_remove_disk()` takes a
`THIS_MODULE` reference before scheduling delayed removal work, but
`nvme_init_ns_head()` can cancel that work when a namespace reappears.
If canceled, the work callback never runs and therefore never executes
its existing `module_put(THIS_MODULE)`. The patch balances that
reference only when `cancel_delayed_work()` actually canceled pending
work.

## Phase 1: Commit Message Forensics
Step 1.1 Record: subsystem `nvme-multipath`; action verb `put`/implicit
`fix`; intent is to release a module reference when delayed namespace
removal work is canceled.

Step 1.2 Record: tags present: `Reviewed-by: Christoph Hellwig
<hch@lst.de>`, `Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>`,
`Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>`, `Signed-off-by: John
Garry <john.g.garry@oracle.com>`, `Signed-off-by: Keith Busch
<kbusch@kernel.org>`. No `Fixes:`, `Reported-by:`, `Tested-by:`,
`Link:`, or `Cc: stable` tag in the commit.

Step 1.3 Record: bug is a module reference leak. The commit body states
the delayed disk removal work is canceled when a namespace appears or
reappears, but the module reference acquired in
`nvme_mpath_remove_disk()` is not released. Symptom from related
blktests discussion: module refcount does not return to the original
value after reconnect. Root cause: cancellation bypasses
`nvme_remove_head_work()`, where the existing `module_put()` lives.

Step 1.4 Record: yes, this is a hidden resource/reference leak fix. The
subject does not say “fix leak”, but the body and code show a missing
`module_put()` on a cancellation path.

## Phase 2: Diff Analysis
Step 2.1 Record: one file changed, `drivers/nvme/host/core.c`, with 2
insertions and 1 deletion. Modified function: `nvme_init_ns_head()`.
Scope: single-file surgical fix.

Step 2.2 Record: before, `nvme_init_ns_head()` unconditionally called
`cancel_delayed_work(&head->remove_work)` after adding the namespace
head. After, it checks the return value and calls
`module_put(THIS_MODULE)` only if pending delayed work was canceled. The
affected path is namespace initialization/reappearance after delayed
multipath removal was scheduled.

Step 2.3 Record: bug category is reference counting/resource leak.
`nvme_mpath_remove_disk()` acquires a module reference with
`try_module_get(THIS_MODULE)` before scheduling `head->remove_work`;
`nvme_remove_head_work()` releases it with `module_put(THIS_MODULE)`
when the work runs. If `nvme_init_ns_head()` cancels the pending work,
the callback does not run, so the added `module_put()` balances the
acquired reference. Workqueue docs in `kernel/workqueue.c` verify
`cancel_delayed_work()` returns true if pending work was canceled and
false otherwise.

Step 2.4 Record: fix quality is high. It is minimal and correctly
conditional. Regression risk is very low: an extra `module_put()` is
only performed when the work was pending and canceled, matching the
exact reference lifetime. If the work was not pending or was already
running, no extra put is done.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` shows the cancellation line in
`nvme_init_ns_head()` was introduced by `dd2c18548964` (`nvme: reset
delayed remove_work after reconnect`), first contained around
`v6.16-rc4`. The delayed removal work and callback `module_put()` came
from `62188639ec16` (`nvme-multipath: introduce delayed removal of the
multipath head node`), first contained around `v6.16-rc1`.

Step 3.2 Record: no `Fixes:` tag is present, so there was no tagged
commit to follow. Manual history points to the interaction between
`62188639ec16` and `dd2c18548964`.

Step 3.3 Record: recent related commits include `62188639ec16`
introducing delayed removal, `dd2c18548964` adding cancellation on
reconnect, and `0f5197ea9a73` fixing a different delayed-removal module
reference failure path. This commit is standalone; it only changes the
cancellation path in `core.c`.

Step 3.4 Record: John Garry has recent NVMe-related commits and reviewed
the related `0f5197ea9a73` fix. The patch was committed by Keith Busch
and reviewed by Christoph Hellwig, both key NVMe maintainers.

Step 3.5 Record: no prerequisite commit beyond the delayed-removal
feature and reconnect cancellation code. The current `core.c` already
includes `<linux/module.h>`, so the new `module_put(THIS_MODULE)`
requires no include change.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c 3f150f0f010f2` found the original patch at `
https://patch.msgid.link/20260415155358.1517871-1-
john.g.garry@oracle.com`. `b4 dig -a` found only v1, so the committed
version is the submitted revision. Lore mirror shows three positive
reviews and Keith Busch applying it to `nvme-7.1`.

Step 4.2 Record: `b4 dig -w` shows John Garry, Christoph Hellwig, Keith
Busch, Nilay Shroff, and `linux-nvme` were included. Appropriate
maintainers/reviewers were on the thread.

Step 4.3 Record: no `Reported-by` or bugzilla/syzbot link. Related
blktests thread reported a concrete failure: `module refcount not as
original`; John Garry replied that he had posted the kernel fix for it,
referring to this fix.

Step 4.4 Record: related patch thread for `nvme-multipath: fix leak on
try_module_get failure` contains John Garry identifying this missing
`module_put()` on timer cancellation; Keith Busch agreed the check and
`module_put()` were correct and that `_sync` was unnecessary.

Step 4.5 Record: direct lore stable search was blocked by Anubis; web
search did not find stable-specific objections or reasons not to
backport.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: modified function is `nvme_init_ns_head()`.

Step 5.2 Record: `nvme_init_ns_head()` is called by `nvme_alloc_ns()`.
`nvme_alloc_ns()` is called by `nvme_scan_ns()` when a namespace is
discovered during controller scan. Scan work is queued from namespace
change AEN handling, reset/start paths, sysfs rescan, and ioctl rescan
paths.

Step 5.3 Record: key callees around the bug are `cancel_delayed_work()`,
`module_put()`, `nvme_mpath_remove_disk()`, `try_module_get()`,
`mod_delayed_work()`, and `nvme_remove_head_work()`.

Step 5.4 Record: reachable path is: namespace/path removal ->
`nvme_ns_remove()` -> last path -> `nvme_mpath_remove_disk()` ->
`try_module_get()` + delayed work; later namespace reappears -> scan
path -> `nvme_scan_ns()` -> `nvme_alloc_ns()` -> `nvme_init_ns_head()`
-> cancel delayed work. This is reachable through real NVMe multipath
path loss/reconnect and through the blktests NVMe loop scenario. I did
not verify an unprivileged trigger; the tested path writes
`delayed_removal_secs` via sysfs and manipulates NVMe connectivity.

Step 5.5 Record: similar reference-balancing pattern exists elsewhere in
the kernel, e.g. Bluetooth code checks `cancel_delayed_work()` and drops
a reference only when cancellation succeeds. No additional identical
NVMe missing-put sites were found in the searched files.

## Phase 6: Cross-Referencing And Stable Tree Analysis
Step 6.1 Record: local stable branch checks show `stable/linux-6.16.y`,
`6.17.y`, `6.18.y`, `6.19.y`, and `7.0.y` contain
`cancel_delayed_work(&head->remove_work)`,
`try_module_get(THIS_MODULE)`, `module_put(THIS_MODULE)`, and
`delayed_removal_secs`. `stable/linux-6.12.y` does not contain this
delayed-removal code, so this specific bug is not present there.

Step 6.2 Record: `git apply --check` for the patch succeeds on the
current `stable/linux-7.0.y` checkout. The exact hunk context exists in
local `6.16.y` through `7.0.y` branches, so backport difficulty should
be clean or trivial. I did not create separate worktrees for branch-
specific apply checks.

Step 6.3 Record: no alternative fix for this exact cancellation leak was
found in checked stable branches; the candidate commit itself is not an
ancestor of the checked stable branches.

## Phase 7: Subsystem And Maintainer Context
Step 7.1 Record: subsystem is NVMe host multipath, under
`drivers/nvme/host`. Criticality: important for systems using NVMe
multipath and delayed removal, not universal core-kernel impact.

Step 7.2 Record: subsystem is actively developed; recent history
includes delayed removal introduction, reconnect cancellation, and
related leak fixes. This bug is in relatively new code introduced for
`v6.16`.

## Phase 8: Impact And Risk Assessment
Step 8.1 Record: affected users are `CONFIG_NVME_MULTIPATH` users who
enable nonzero `delayed_removal_secs` and experience path loss followed
by namespace/path return before the delayed removal work fires.

Step 8.2 Record: trigger is realistic for NVMe multipath transient path
failures or hot-remove/re-add scenarios. Related blktests exercises this
with NVMe loop. Unprivileged trigger was not verified.

Step 8.3 Record: failure mode is module reference leak, severity medium.
It can prevent `nvme_core` from being unloadable and causes persistent
refcount imbalance; the test discussion shows a concrete refcount
mismatch.

Step 8.4 Record: benefit is moderate for affected NVMe multipath users
because it fixes a real reference leak in a recovery path. Risk is very
low: 2 added lines, no API change, no behavior change except balancing a
reference when pending work is canceled.

## Phase 9: Final Synthesis
Step 9.1 Record: evidence for backporting: real reference leak; concrete
test failure in related blktests discussion; tiny one-function fix;
reviewed by three NVMe developers; maintainer agreed the logic; applies
cleanly to current `7.0.y` and relevant code exists in `6.16+` stable
branches. Evidence against: affects a specific configured NVMe multipath
feature, not all systems; severity is not crash/data
corruption/security. Unresolved: I did not verify exact branch-specific
application in separate worktrees, and direct lore stable search was
blocked.

Step 9.2 Record: stable rules checklist:
1. Obviously correct and tested: yes, by code inspection and related
   blktests discussion; no `Tested-by` tag.
2. Fixes real bug: yes, module reference leak.
3. Important issue: yes enough for stable as a driver lifecycle
   reference leak, though severity is medium rather than critical.
4. Small and contained: yes, 2 insertions/1 deletion in one function.
5. No new feature/API: yes.
6. Can apply to stable: yes for current `7.0.y`; exact context exists in
   checked `6.16+` branches. Not applicable to trees lacking delayed
   removal.

Step 9.3 Record: no exception category such as device ID, quirk, DT,
build, or documentation. This is a normal bug fix.

Step 9.4 Record: backport recommended to stable trees containing NVMe
delayed removal cancellation, notably checked `6.16.y` through `7.0.y`;
not applicable to older trees where the feature is absent.

## Verification
- [Phase 1] Parsed commit `3f150f0f010f2` with `git show --format=fuller
  --stat --patch`; confirmed subject, body, tags, and 2-line fix.
- [Phase 2] Inspected `drivers/nvme/host/core.c` and
  `drivers/nvme/host/multipath.c`; confirmed `try_module_get()` in
  `nvme_mpath_remove_disk()` and `module_put()` in
  `nvme_remove_head_work()`.
- [Phase 2] Checked `kernel/workqueue.c`; confirmed
  `cancel_delayed_work()` returns true if pending work was canceled and
  false otherwise.
- [Phase 3] Ran `git blame` on the changed and related lines; identified
  `dd2c18548964`, `62188639ec16`, and `0f5197ea9a73`.
- [Phase 3] Ran `git show` on related commits; confirmed delayed removal
  introduction, reconnect cancellation, and prior try-module failure
  fix.
- [Phase 4] Ran `b4 dig -c`, `-a`, and `-w`; found original patch URL,
  single v1 revision, and appropriate NVMe recipients.
- [Phase 4] Fetched lore mirror thread; confirmed reviews by Christoph
  Hellwig, Nilay Shroff, Chaitanya Kulkarni, and application by Keith
  Busch.
- [Phase 4] Fetched related try-module failure and blktests threads;
  confirmed this missing cancellation `module_put()` was discussed and
  tied to module refcount mismatch.
- [Phase 5] Used `rg` and file reads to trace callers from
  `nvme_init_ns_head()` through `nvme_alloc_ns()`, `nvme_scan_ns()`, and
  `nvme_scan_work()`.
- [Phase 6] Used `git merge-base --is-ancestor` and branch object
  inspection to confirm the relevant code exists in local `6.16.y`,
  `6.17.y`, `6.18.y`, `6.19.y`, and `7.0.y`, but not `6.12.y`.
- [Phase 6] Ran `git apply --check` for the candidate diff on current
  `stable/linux-7.0.y`; it succeeded.
- UNVERIFIED: exact `git apply --check` on separate worktrees for every
  stable branch; unprivileged triggerability; direct stable-list search
  results due lore Anubis blocking.

**YES**

 drivers/nvme/host/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ac5a7d9781f58..2e8402513189d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4052,7 +4052,8 @@ static int nvme_init_ns_head(struct nvme_ns *ns, struct nvme_ns_info *info)
 	mutex_unlock(&ctrl->subsys->lock);
 
 #ifdef CONFIG_NVME_MULTIPATH
-	cancel_delayed_work(&head->remove_work);
+	if (cancel_delayed_work(&head->remove_work))
+		module_put(THIS_MODULE);
 #endif
 	return 0;
 
-- 
2.53.0

