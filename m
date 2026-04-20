Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5D5478E55;
	Mon, 20 Apr 2026 13:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691851; cv=none; b=rpZZVLbSqj/OkzO8Q88NE0pUXQSzv1kbeTQ/FGiNpKyriXKZxWU57+GjBOTzgzX2rCpNgyZhrrR9WoqlPCEIEjP7GE1SsoQiGNBLkiKExY8kbi/ebGBvdHJqe0g6AD/CQGRfxVn2rJks4fMmzqvNwiusLM8bysB10+MZxCfUrGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691851; c=relaxed/simple;
	bh=j6fd763CQFZzWDOaM0/iX6f8lZNQ0r0PAPKDPJ5VpIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fs01RqKgXDtFP/HFazXl1CPhvIi8JYg+JE283ZFxSzvxttBYdxTGlwuArPPsfNAVxn/c/tXCAEP3vcze+G0w31+h4NxUGdvuWysBtyrOXZ88OhGRwxd621UMvjC8P85+r01zf/YDRXPcEielZyPEh8+XJrY6UOjTA7Bv4Bx5AdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LkM0UjAN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LkM0UjAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF488C2BCC4;
	Mon, 20 Apr 2026 13:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691851;
	bh=j6fd763CQFZzWDOaM0/iX6f8lZNQ0r0PAPKDPJ5VpIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkM0UjANKeydIQl5KPV4Fn1k+olvinc3QdFGXTD1bBc12LSpAGR7IR1WVL4j/rmg6
	 yfpK2/5lStihOEUb6Cn1Jfm7d1MNq15aQTDkoHERNcbx4SNLWc2GN20crI2pPhfllW
	 RlYfWoQ8dZpie0qTE/nCKr4SdpvKlpdRdjKvfY7swbDhmRWBpK/zri3U1jXu8ozuMV
	 534Hl1Wu3cN4E4/D4MY483dQkkbq8RR+TalhjjWeYMAVeHiEDo39MMrn9sVaK151DY
	 X1bIk+MlLxs2JvjHqXazH6sYgwcpT2LKyaLwSPWk03GJNjGFN0zWgr8rBx6gX0NupW
	 kWebEOWuaGEGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jian Zhang <zhangjian.3032@bytedance.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>,
	openipmi-developer@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] ipmi: ssif_bmc: cancel response timer on remove
Date: Mon, 20 Apr 2026 09:20:25 -0400
Message-ID: <20260420132314.1023554-231-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jian Zhang <zhangjian.3032@bytedance.com>

[ Upstream commit 7fc3e2546cf3fa9a28a2acc92a512c779a8e5038 ]

The response timer can stay armed across device teardown. If it fires after
remove, the callback dereferences the SSIF context and the i2c client after
teardown has started.

Cancel the timer in remove so the callback cannot run after the device is
unregistered.

Signed-off-by: Jian Zhang <zhangjian.3032@bytedance.com>
Message-ID: <20260403090603.3988423-1-zhangjian.3032@bytedance.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to do the full analysis.

---

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject parsing**
Record: Subsystem `ipmi: ssif_bmc:`; action verb `cancel` (equivalent to
"fix/prevent"); summary: cancel response timer in remove path so a
queued timer callback cannot dereference a torn-down context.

**Step 1.2 — Commit message tags**
Record:
- `Signed-off-by: Jian Zhang <zhangjian.3032@bytedance.com>` (author)
- `Message-ID: <20260403090603.3988423-1-zhangjian.3032@bytedance.com>`
  — lore msgid
- `Signed-off-by: Corey Minyard <corey@minyard.net>` — IPMI subsystem
  maintainer applied it
- No `Fixes:` tag, no `Cc: stable`, no `Reported-by:`, no `Reviewed-by:`
  / `Acked-by:` in the applied version (absence of Fixes/Cc stable is
  expected in this pipeline and not a negative signal)
- Related patches 2/5, 3/5, 4/5 in the same series DO carry `Fixes:
  dd2bc5cc9e25 ("ipmi: ssif_bmc: Add SSIF BMC driver")`

**Step 1.3 — Body analysis**
Record: Bug description is explicit — "response timer can stay armed
across device teardown"; failure mode is "the callback dereferences the
SSIF context and the i2c client after teardown has started". This is a
classic **use-after-free** scenario. The author names the exact
mechanism (pending timer firing after `ssif_bmc_remove()`).

**Step 1.4 — Hidden bug detection**
Record: Not hidden. Clearly presented as a UAF-prevention fix even
without the word "fix" in the subject. The phrase "so the callback
cannot run after the device is unregistered" is unambiguous fix
language.

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record: 1 file (`drivers/char/ipmi/ssif_bmc.c`), +1/-0 lines, inside
`ssif_bmc_remove()`. Single-file surgical fix.

**Step 2.2 — Flow change**
Record: Before: `ssif_bmc_remove()` calls `i2c_slave_unregister()` then
`misc_deregister()` and returns, leaving `response_timer` possibly
pending. After: `timer_delete_sync(&ssif_bmc->response_timer)` is called
first, which both cancels a pending timer and waits for any in-flight
callback on another CPU to finish before continuing.

**Step 2.3 — Bug mechanism**
Record: Category (d) memory safety / (b) synchronization with teardown.
Root cause:
- `ssif_bmc` is `devm_kzalloc`'d at probe (line 809), so it is freed by
  devres AFTER `.remove` returns.
- `response_timer` is armed via `mod_timer(&ssif_bmc->response_timer,
  jiffies + 500 ms)` inside `handle_request()` (line 335).
- `response_timeout()` callback dereferences `ssif_bmc`
  (`timer_container_of`), takes `ssif_bmc->lock` and touches several
  fields (lines 300–315).
- Without `timer_delete_sync()` in remove, the timer can fire after
  remove returns and after devres frees `ssif_bmc`, producing a UAF on
  `ssif_bmc` and on `ssif_bmc->client`. On module unload the callback
  address itself may also be in freed module text.

**Step 2.4 — Fix quality**
Record: 1 line, the canonical pattern (`timer_delete_sync()` in remove
for a driver-owned timer). V1 of the patch used the non-sync variant;
review led to v2 using `timer_delete_sync()`, which is the correct
choice because it also waits for a concurrent callback on another CPU.
Zero-initialized `timer_list` (never armed because `handle_request`
never ran) is safely handled by `timer_delete_sync()` —
`timer_pending()` returns false on a zeroed list entry. No regression
risk.

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: `git blame -L 820,870` shows `ssif_bmc_remove` untouched since
`dd2bc5cc9e2555` (Quan Nguyen, 2022-10-04), which first appears in
**v6.2**. So the bug has been present in every release from v6.2 onward.

**Step 3.2 — Fixes: tag follow-up**
Record: No explicit `Fixes:` tag on this patch, but companion patches
2/5, 3/5, 4/5 all point to `dd2bc5cc9e25`. The same commit introduces
both the timer and the buggy `ssif_bmc_remove()`. `dd2bc5cc9e25` is
present in stable branches from 6.6.y onward (verified via `git show
pending-6.6:drivers/char/ipmi/ssif_bmc.c`) but NOT in 6.1.y (`git show
pending-6.1:drivers/char/ipmi/ssif_bmc.c` reports the file does not
exist — driver was added after 6.1 branched).

**Step 3.3 — File history**
Record: Recent file commits: 41cb08555c416 (treewide
`timer_container_of()` rename, v6.16), 8fa7292fee5c5 (treewide
`timer_delete[_sync]()` rename, v6.15), plus prior IPMI fixes. No
prerequisites for this patch. It is self-contained.

**Step 3.4 — Author context**
Record: Jian Zhang has multiple prior kernel contributions (NCSI, MCTP,
i2c-aspeed, etc.). Not the maintainer, but the patch was applied by
`corey@minyard.net`, the IPMI maintainer, and was discussed with Quan
Nguyen, the original driver author.

**Step 3.5 — Dependencies**
Record: None. A single `timer_delete_sync()` call inside `.remove` does
not rely on any other patch in the series. For stable branches below
v6.15, the API is `del_timer_sync()` — a trivial rename that the stable
maintainers routinely handle as a backport adjustment.

## Phase 4: Mailing List Research

**Step 4.1 — Original submission**
Record: `b4 dig -c 7fc3e2546cf3f` found the thread at `https://lore.kern
el.org/all/20260403090603.3988423-1-zhangjian.3032@bytedance.com/`. This
is patch **1/5** in a 5-patch series of IPMI SSIF BMC fixes.

**`b4 dig -a` — revisions**: v1 (2026-04-02) and v2 (2026-04-03). v2
changelog: "use `timer_delete_sync()` to cancel the timer" — review
feedback upgraded v1's non-sync delete to the sync variant.

In-thread discussion from Corey Minyard (reply to v2 1/5): "Thanks for
the updates on this. I have the new version in my tree." — explicit
maintainer acceptance.

**Step 4.2 — Recipients**
Record: CC list on v2 was Corey Minyard (IPMI maintainer), Quan Nguyen
(original author of the driver / MAINTAINERS entry), openipmi-developer
list, linux-kernel. Correct audience; reviewed by the right people.

**Step 4.3 — Bug report**
Record: No syzbot / bugzilla / user report cited. The bug was apparently
found through code review or internal testing at Bytedance. Unverified
whether there is a field occurrence.

**Step 4.4 — Series context**
Record: Siblings in the same series (all for
`drivers/char/ipmi/ssif_bmc.c`, all with `Fixes: dd2bc5cc9e25`):
copy_to_user partial failure fix (2/5), message desynchronization after
truncated response (3/5), log-level change (4/5), and a kunit test
(5/5). This patch is independent and applies on its own.

**Step 4.5 — Stable-list discussion**
Record: None visible. Anubis anti-bot blocked direct lore searches, but
the archived mbox I pulled via `b4 dig -m` contained no stable-list
cross-post or stable nomination.

## Phase 5: Code Semantic Analysis

**Step 5.1 — Modified function**: `ssif_bmc_remove()`.

**Step 5.2 — Callers**
Record: `ssif_bmc_remove` is assigned to `i2c_driver.remove` and invoked
by the i2c bus core when the device is unbound (rmmod, device unbind via
sysfs, or driver removal).

**Step 5.3 — Callees/related**
Record: The fix target is `response_timer`. Arming site is
`handle_request()` (`mod_timer(... RESPONSE_TIMEOUT=500 ms)`). Callback
is `response_timeout()` which locks `ssif_bmc->lock` and touches
`ssif_bmc->busy`, `response_timer_inited`, `aborting` — all of which are
inside a `devm_kzalloc`'d struct.

**Step 5.4 — Reachability**
Record: Triggered every time a SSIF IPMI request is handled from the
host side; the window to teardown can be up to 500 ms per request.
Remove path is reached when the module is unloaded or the i2c device is
unbound — a real, not theoretical, code path in BMC firmware
environments (OpenBMC) that allow driver rebinding.

**Step 5.5 — Similar patterns**
Record: `timer_delete_sync()` in driver `.remove` is the standard idiom
for any driver-owned timer with a pointer to devres-managed state. The
same pattern is also added in the kunit test (patch 5/5) for correctness
of the test fixture.

## Phase 6: Stable-tree Analysis

**Step 6.1 — Exists in stable?**
Record: Buggy `ssif_bmc_remove()` exists identically in 6.6.y, 6.12.y,
6.15.y, 6.16.y and later (verified by `git show
pending-6.X:drivers/char/ipmi/ssif_bmc.c`). Not present in 6.1.y (driver
added after 6.1 branched).

**Step 6.2 — Backport complications**
Record: Mainline (7.0) uses `timer_delete_sync()`; stable branches <
v6.15 expose it as `del_timer_sync()`. This is a trivial rename that
stable maintainers handle routinely. Otherwise the patch applies cleanly
— the 3 surrounding lines (`struct ssif_bmc_ctx *ssif_bmc = ...;
i2c_slave_unregister(client); misc_deregister(&ssif_bmc->miscdev);`) are
identical in all stable branches I checked.

**Step 6.3 — Prior stable fixes**
Record: No earlier fix for this UAF window has been applied to any
stable branch I checked.

## Phase 7: Subsystem Context

**Step 7.1 — Criticality**: `drivers/char/ipmi/ssif_bmc.c` — PERIPHERAL
(BMC-side SSIF; used on Linux-running BMCs, e.g. OpenBMC). Real users,
narrow hardware scope.

**Step 7.2 — Activity**: Low-frequency but active; Corey Minyard
actively maintains; Jian Zhang's 5-patch series is a recent hardening
round.

## Phase 8: Impact and Risk

**Step 8.1 — Affected users**: Users of Linux BMC firmware that exposes
SSIF to a host CPU (OpenBMC et al.).

**Step 8.2 — Trigger**: Requires device unbind/rmmod while a timer from
a recent IPMI request is still armed (≤500 ms window per request). Not
routinely triggered at runtime on production BMCs that never unbind, but
reachable on development / test / field-service paths and by privileged
userspace actions.

**Step 8.3 — Failure mode**: UAF on `ssif_bmc` (and potentially on
`client`), plus potential call into freed module text on module unload.
Severity: HIGH — potential kernel crash / memory corruption; the
callback also takes a spinlock on the freed struct.

**Step 8.4 — Risk/benefit**
Record: Benefit = eliminates a real UAF window on device removal in a
driver present in many live stable trees. Risk = near-zero; one line,
canonical idiom, no control-flow change, safe on a never-initialized
`timer_list`. Ratio is strongly favorable.

## Phase 9: Synthesis

**Evidence for**: Classic UAF-prevention pattern; minimal 1-line diff;
obviously correct; review feedback already incorporated (v1 → v2
upgraded non-sync to sync); IPMI maintainer applied it; original driver
author was on CC; self-contained (no dependencies); bug present since
driver introduction (v6.2).

**Evidence against**: No explicit `Fixes:` tag on this specific patch
(though companion patches in the series tag dd2bc5cc9e25); no
syzbot/user report cited; backport to < 6.15 needs `del_timer_sync()`
rename.

**Stable-rules checklist**
1. Obviously correct and tested — YES (1 line, canonical, in maintainer
   tree)
2. Real bug — YES (UAF on timer callback after teardown)
3. Important issue — YES (UAF / possible kernel panic)
4. Small and contained — YES (+1/-0 line, single function)
5. No new features/APIs — YES (adds a cleanup call only)
6. Applies to stable — YES, with a trivial API rename for < v6.15

**Exception categories**: Not applicable; stands on bug-fix merit alone.

**Decision**: YES. Small UAF fix in a never-canceled timer on device
teardown, accepted by the subsystem maintainer, safe and trivial to
backport to all stable trees that carry the driver (6.6.y and later).

## Verification

- [Phase 1] Parsed subject / body / tags directly from the commit and
  companion series — confirmed no `Fixes:`/`Cc: stable`, but sibling
  patches in series carry `Fixes: dd2bc5cc9e25`.
- [Phase 2] Read `ssif_bmc.c` lines 77–100 (struct fields including
  `response_timer`), 200–228 (`timer_delete()` in write path), 298–336
  (`response_timeout` callback + `mod_timer` arming site), 804–848
  (probe/remove) — confirmed `ssif_bmc` is `devm_kzalloc`'d (line 809)
  and that `response_timeout` dereferences fields inside it.
- [Phase 3] `git blame -L 820,870 drivers/char/ipmi/ssif_bmc.c` — buggy
  `ssif_bmc_remove` unchanged since `dd2bc5cc9e2555`.
- [Phase 3] `git show --stat dd2bc5cc9e255` — initial driver add (Oct
  2022).
- [Phase 3] `git tag --contains dd2bc5cc9e255` — earliest release is
  **v6.2**.
- [Phase 3] `git tag --contains 8fa7292fee5c5` — `timer_delete_sync()`
  rename lands in v6.15.
- [Phase 3] `git tag --contains 41cb08555c416` — `timer_container_of()`
  rename lands in v6.16.
- [Phase 4] `b4 dig -c 7fc3e2546cf3f` — matched series at `lore.kernel.o
  rg/all/20260403090603.3988423-1-zhangjian.3032@bytedance.com/`.
- [Phase 4] `b4 dig -c 7fc3e2546cf3f -a` — two revisions (v1 and v2);
  applied version is the latest (v2).
- [Phase 4] `b4 dig -m /tmp/ssif_thread.mbx` — full thread saved; Corey
  Minyard acknowledges acceptance: "I have the new version in my tree."
  v2 changelog: "use timer_delete_sync() to cancel the timer".
- [Phase 5] `Grep response_timer` in the file — arming site in
  `handle_request`, callback `response_timeout` dereferences `ssif_bmc`
  (line 300), uses `ssif_bmc->lock`.
- [Phase 6] `git show pending-6.6:drivers/char/ipmi/ssif_bmc.c` and
  `pending-6.12`, `pending-6.15`, `pending-6.16` — confirmed identical
  buggy `ssif_bmc_remove()` in all of them; confirmed older trees use
  `del_timer_sync()` / `from_timer()`.
- [Phase 6] `git show pending-6.1:drivers/char/ipmi/ssif_bmc.c` — file
  does not exist (driver added after 6.1).
- [Phase 8] Failure mode: timer callback on freed devres memory → UAF /
  possible panic on module unload (inferred from code inspection of the
  callback plus `devm_kzalloc` semantics).
- UNVERIFIED: no reachable syzbot/bugzilla/user report cited; impact in
  field is plausible but I did not locate a concrete crash report.
- UNVERIFIED: did not retrieve v1 body directly (Anubis blocked lore
  fetch), but v2 changelog and the maintainer reply unambiguously
  document the v1 → v2 change.

**YES**

 drivers/char/ipmi/ssif_bmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/ipmi/ssif_bmc.c b/drivers/char/ipmi/ssif_bmc.c
index 7a52e3ea49ed8..dc1d5bb4a4604 100644
--- a/drivers/char/ipmi/ssif_bmc.c
+++ b/drivers/char/ipmi/ssif_bmc.c
@@ -843,6 +843,7 @@ static void ssif_bmc_remove(struct i2c_client *client)
 {
 	struct ssif_bmc_ctx *ssif_bmc = i2c_get_clientdata(client);
 
+	timer_delete_sync(&ssif_bmc->response_timer);
 	i2c_slave_unregister(client);
 	misc_deregister(&ssif_bmc->miscdev);
 }
-- 
2.53.0

