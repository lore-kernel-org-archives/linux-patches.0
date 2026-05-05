Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95FF3128CC;
	Tue,  5 May 2026 09:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974733; cv=none; b=MHsTbGmqu6gSQvpdvjMjvoUkKv8NXKrj63Tjv0eLIeSBrE+7iJnRUG701je4lF6/ZJCbfxNxhiTbEj/1THP+WnbT00RB10QyCaK3SfTkAviasAVAOi9PVJwU6J0buQIMkH5MkMT+8FdYNDk3ob6PzG1AvUhCa4I0k++HrU1Aw7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974733; c=relaxed/simple;
	bh=b8EmRXYUHhHpMi2mh0G8JaV05ulaXXDdg5z3WQYkrtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SmDJKrBjbQ1pBbWnF+CpJpvymDASwogBDXlEkZ/xw344D66TpsvInJJqy2J1wlNB9ZGpG3EPEsaza+yMEb9dcM9BJzyVTt63WYJwBQrZsXpyV7I0djusv2H7Pksk1LiT66kPJVlcZHOWu4xHgjJzxBuG+neInBEiyn9g0Bx1oNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F8pic0AT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8pic0AT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42160C2BCB4;
	Tue,  5 May 2026 09:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974733;
	bh=b8EmRXYUHhHpMi2mh0G8JaV05ulaXXDdg5z3WQYkrtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8pic0ATB1pkJGvgbGQ0MMKCKtUhphyuJWHKgCWIwXghQKfFGRlCQTLcdwjewEP2F
	 2DnohjvNlQnSlvApJnYNpAEVZvSIu0Yy3odheLa1XHZOA8K4ah3ZfLahvlTdtEefKA
	 8sVTgF5267fLz+zaKUSAWunwR2NJJj958RZBUVSzpaWkQDiSAEiX8nne7ldbXPerXO
	 63wab5KLIS7lQpz6Otwj9ihJis+vq7uqkw1tvHIUjIgYwmcjK/72m7/Lm/usjIJdeU
	 cmHaaBQeor1l/jDHpKDjM5c4cZjgDqFsjoB02XGN7XsegiU/v5uava5V0hiG/hDNIw
	 r+JfjfUgTQnIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ivan Vecera <ivecera@redhat.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Petr Oros <poros@redhat.com>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jiri@resnulli.us,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] dpll: export __dpll_pin_change_ntf() for use under dpll_lock
Date: Tue,  5 May 2026 05:51:23 -0400
Message-ID: <20260505095149.512052-7-sashal@kernel.org>
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

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 620055cb1036a6125fd912e7a14b47a6572b809b ]

Export __dpll_pin_change_ntf() so that drivers can send pin change
notifications from within pin callbacks, which are already called
under dpll_lock. Using dpll_pin_change_ntf() in that context would
deadlock.

Add lockdep_assert_held() to catch misuse without the lock held.

Acked-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Petr Oros <poros@redhat.com>
Tested-by: Alexander Nowlin <alexander.nowlin@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260427-jk-iwl-net-petr-oros-fixes-v1-9-cdcb48303fd8@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: subsystem `dpll`; action verb `export`; intent is to
expose `__dpll_pin_change_ntf()` so drivers can notify pin changes while
already under `dpll_lock`.

Step 1.2 Record: tags present: `Acked-by: Vadim Fedorenko`; `Signed-off-
by: Ivan Vecera`; `Signed-off-by: Petr Oros`; `Tested-by: Alexander
Nowlin`; `Reviewed-by: Arkadiusz Kubalewski`; `Signed-off-by: Jacob
Keller`; `Link: https://patch.msgid.link/20260427-jk-iwl-net-petr-oros-
fixes-v1-9-cdcb48303fd8@intel.com`; `Signed-off-by: Paolo Abeni`. No
`Fixes:`, `Reported-by:`, or `Cc: stable`.

Step 1.3 Record: the message describes a real locking problem: pin
callbacks are already invoked with `dpll_lock` held, and calling
exported `dpll_pin_change_ntf()` there would try to acquire the same
mutex again and deadlock. It adds a lockdep assertion to catch misuse.

Step 1.4 Record: this is a hidden/preparatory bug fix. Alone it mostly
exports an internal helper, but in the verified series it enables the
following ice fix to send peer DPLL notifications without self-
deadlocking.

## Phase 2: Diff Analysis
Step 2.1 Record: files changed are `drivers/dpll/dpll_netlink.c` `+10`,
`drivers/dpll/dpll_netlink.h` `-2`, and `include/linux/dpll.h` `+1`;
total `11 insertions, 2 deletions`. Modified function:
`__dpll_pin_change_ntf()`. Scope is small and contained.

Step 2.2 Record: before, only `dpll_pin_change_ntf()` was exported and
it always acquired `dpll_lock`; the unlocked helper was internal. After,
the helper is documented, asserts `dpll_lock` is held, is exported GPL-
only, and its declaration moves from private dpll header to public
kernel dpll header.

Step 2.3 Record: bug category is synchronization/deadlock avoidance plus
prerequisite API exposure for a driver bug fix. The specific mechanism
is avoiding recursive acquisition of non-recursive `dpll_lock` from
callbacks already reached through `dpll_pin_pre_doit()`.

Step 2.4 Record: fix quality is good: minimal, obvious, lockdep-guarded,
no userspace ABI, no broad refactor. Regression risk is low; the main
concern is that it is useful only with the dependent ice fixes.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` showed `dpll_pin_change_ntf()` came from
`9d71b54b65b1` in v6.7-era dpll netlink code; `__dpll_pin_change_ntf()`
declaration was added by `58256a26bfb3`, first in v6.17. The ice bug
being fixed by the dependent commits was introduced by `2dd5d03c77e2`,
first in v6.17.

Step 3.2 Record: candidate has no `Fixes:` tag. Related follow-up
commits `1a41b58fd4dc` and `9e5dead140af` both fix `2dd5d03c77e2 ("ice:
redesign dpll sma/u.fl pins control")`.

Step 3.3 Record: recent history shows this is immediately followed by
`ice: fix missing dpll notifications for SW pins` and `ice: add dpll
peer notification for paired SMA and U.FL pins`; it is part of that fix
series and is a prerequisite for the third patch.

Step 3.4 Record: Ivan Vecera has multiple recent dpll commits in this
area; Petr Oros and Intel reviewers are active in the dpll/ice code. The
patch was committed through Paolo Abeni’s net tree path.

Step 3.5 Record: dependency found: the real user-visible fix needs the
two following ice commits. For older stable trees before v7.0, the patch
also needs a small backport adjustment because `dpll: Add notifier chain
for dpll events` is absent.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c 620055cb1036a` found the original applied
submission as `[PATCH net 09/11]` at `20260427-jk-iwl-net-petr-oros-
fixes-v1-9-cdcb48303fd8@intel.com`. `b4 dig -a` showed earlier v4-v7
iterations of the ice DPLL fix series; v7 split the ice fix as requested
by review.

Step 4.2 Record: `b4 dig -w` showed netdev maintainers and relevant
Intel/dpll reviewers were CC’d, including David Miller, Eric Dumazet,
Jakub Kicinski, Paolo Abeni, Jiri Pirko, Vadim Fedorenko, Arkadiusz
Kubalewski, Jacob Keller, Intel wired LAN, and netdev.

Step 4.3 Record: lore mirror confirmed the series purpose: SMA/U.FL
software-controlled pins missed DPLL notifications, and userspace
consumers such as `synce4l` would not learn about state/phase-offset
changes. Alexander Nowlin provided `Tested-by`; Arkadiusz Kubalewski
reviewed.

Step 4.4 Record: related patches are the following two ice commits;
patch 3 specifically calls `__dpll_pin_change_ntf()` from dpll pin
callbacks because `dpll_lock` remains held.

Step 4.5 Record: direct lore stable search via WebFetch was blocked by
Anubis; web search found no stable-specific objection or discussion.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: modified function is `__dpll_pin_change_ntf()`.

Step 5.2 Record: callers are `dpll_pin_change_ntf()`, internal dpll
netlink setters, dpll core ref-sync code, and after the dependent patch,
`ice_dpll_sw_pin_notify_peer()`.

Step 5.3 Record: callees are `lockdep_assert_held(&dpll_lock)`,
`dpll_pin_notify()` on v7.0+, and `dpll_pin_event_send()`.

Step 5.4 Record: user reachability is through generic netlink
`DPLL_CMD_PIN_SET`, which uses `dpll_pin_pre_doit()` and
`dpll_pin_post_doit()` around the operation. The netlink operation is
admin-permission gated, so this is not an unprivileged trigger.

Step 5.5 Record: existing internal `__dpll_pin_change_ntf()` callers are
in dpll code under dpll locking. The problematic missing pattern was an
exported helper for already-locked driver callback context.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: affected stable trees are v6.17+, because
`2dd5d03c77e2` exists in `stable/linux-6.17.y`, `6.18.y`, `6.19.y`, and
`7.0.y`. It is absent from `6.12.y` and older checked branches;
`drivers/dpll` is absent in `6.6.y`.

Step 6.2 Record: current `7.0.y` accepts the patch with `git apply
--check`. `git merge-tree` showed `6.17.y`-`6.19.y` need minor backport
adjustment because they lack the dpll notifier-chain change; `7.0.y` is
straightforward.

Step 6.3 Record: stable branches checked do not contain this candidate
or the dependent two ice fixes.

## Phase 7: Subsystem And Maintainer Context
Step 7.1 Record: subsystem is dpll core plus Intel ice networking driver
context. Criticality is important but hardware/config-specific: users of
DPLL-capable Intel ice devices and DPLL netlink consumers.

Step 7.2 Record: dpll and ice DPLL code are actively developed; recent
history shows several related dpll/ice fixes, including missing SMA
initialization and paired-pin state fixes.

## Phase 8: Impact And Risk
Step 8.1 Record: affected population is driver-specific: DPLL-capable
Intel ice hardware using SMA/U.FL software-controlled pins.

Step 8.2 Record: trigger is DPLL pin state/direction changes or periodic
DPLL updates on affected hardware. Userspace impact is missed netlink
notifications and stale phase-offset reporting; triggering netlink
changes requires admin privileges.

Step 8.3 Record: failure mode severity is medium for the user-visible
bug: time-sync management software can miss DPLL pin transitions/phase-
offset changes. The locking issue would be a deadlock if the public
helper were used in the already-locked callback path.

Step 8.4 Record: benefit is medium-high for affected hardware and
required for the real ice fix; risk is low because the change is tiny,
GPL-only, lockdep-guarded, and does not alter userspace ABI.

## Phase 9: Final Synthesis
Evidence for backporting: it is a small, reviewed, tested prerequisite
for real ice DPLL notification fixes; it prevents a concrete self-
deadlock in the callback context verified through `dpll_pin_pre_doit()`
locking; affected stable trees contain the buggy ice redesign from v6.17
onward.

Evidence against backporting: by itself it is mostly an exported in-
kernel helper, so it should not be backported alone for standalone
value. Older affected stable trees need a minor manual backport due to
missing dpll notifier-chain code.

Stable rules checklist: obviously correct and tested: yes; fixes/enables
fix for real user-visible bug: yes, as part of the series; important
issue: medium functional correctness and deadlock avoidance; small and
contained: yes; no userspace API: yes; applies: clean on `7.0.y`, minor
backport for `6.17.y`-`6.19.y`.

Exception category: not a device ID or quirk. This is an acceptable
prerequisite/helper export for a stable-worthy driver fix series.

Verification:
- Phase 1: parsed `git show 620055cb1036a`; confirmed tags and no
  `Fixes:`.
- Phase 2: inspected diff; confirmed `11 insertions, 2 deletions` across
  three files.
- Phase 3: ran `git blame` and `git show` for `9d71b54b65b1`,
  `58256a26bfb3`, `2dd5d03c77e2`.
- Phase 4: ran `b4 dig -c`, `-a`, `-w`; fetched lore mirror thread
  showing v7 review, `Tested-by`, and `Reviewed-by`.
- Phase 5: searched callers and dpll netlink ops; verified
  `DPLL_CMD_PIN_SET` uses `dpll_pin_pre_doit()` and callbacks run while
  `dpll_lock` is held.
- Phase 6: checked stable branches for `2dd5d03c77e2`, candidate
  absence, dependent fix absence, and merge-tree/apply behavior.
- Phase 7: reviewed recent dpll and ice DPLL history.
- Phase 8: verified trigger/user impact from the dependent ice commit
  messages and diffs.

Backport recommendation: backport this commit to affected stable trees
together with `1a41b58fd4dc` and `9e5dead140af`; do not take it alone
unless it is queued as that prerequisite.

**YES**

 drivers/dpll/dpll_netlink.c | 10 ++++++++++
 drivers/dpll/dpll_netlink.h |  2 --
 include/linux/dpll.h        |  1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index 83cbd64abf5a4..95ae786e98aab 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -842,11 +842,21 @@ int dpll_pin_delete_ntf(struct dpll_pin *pin)
 	return dpll_pin_event_send(DPLL_CMD_PIN_DELETE_NTF, pin);
 }
 
+/**
+ * __dpll_pin_change_ntf - notify that the pin has been changed
+ * @pin: registered pin pointer
+ *
+ * Context: caller must hold dpll_lock. Suitable for use inside pin
+ *          callbacks which are already invoked under dpll_lock.
+ * Return: 0 if succeeds, error code otherwise.
+ */
 int __dpll_pin_change_ntf(struct dpll_pin *pin)
 {
+	lockdep_assert_held(&dpll_lock);
 	dpll_pin_notify(pin, DPLL_PIN_CHANGED);
 	return dpll_pin_event_send(DPLL_CMD_PIN_CHANGE_NTF, pin);
 }
+EXPORT_SYMBOL_GPL(__dpll_pin_change_ntf);
 
 /**
  * dpll_pin_change_ntf - notify that the pin has been changed
diff --git a/drivers/dpll/dpll_netlink.h b/drivers/dpll/dpll_netlink.h
index dd28b56d27c56..a9cfd55f57fc4 100644
--- a/drivers/dpll/dpll_netlink.h
+++ b/drivers/dpll/dpll_netlink.h
@@ -11,5 +11,3 @@ int dpll_device_delete_ntf(struct dpll_device *dpll);
 int dpll_pin_create_ntf(struct dpll_pin *pin);
 
 int dpll_pin_delete_ntf(struct dpll_pin *pin);
-
-int __dpll_pin_change_ntf(struct dpll_pin *pin);
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
index 2ce295b46b8cd..8f97120ee7b37 100644
--- a/include/linux/dpll.h
+++ b/include/linux/dpll.h
@@ -276,6 +276,7 @@ int dpll_pin_ref_sync_pair_add(struct dpll_pin *pin,
 
 int dpll_device_change_ntf(struct dpll_device *dpll);
 
+int __dpll_pin_change_ntf(struct dpll_pin *pin);
 int dpll_pin_change_ntf(struct dpll_pin *pin);
 
 int register_dpll_notifier(struct notifier_block *nb);
-- 
2.53.0

