Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45430470EAF;
	Mon, 31 Aug 2026 13:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183312; cv=none; b=NGNv4e5ipY9R4RtD4sOFeBho9/IrfmyATNTfGAhcz/3pPIZG6/ei1qgsaTrxjsM84HuclJPLCuBMD98AYshx/7FEdLlgOAXh3x5lRh8x2nzJuu76iNCskbJobQWyUWLV6K3Q1T6DGTBEBtK78S5xoqzvIsPvb3DGH6vpwM/TVSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183312; c=relaxed/simple;
	bh=7wMyDMBZA6HeL/s6hth1FV4f65Mhk0LhZD2XLqkH9qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gSC6H34C45ukfqiELN+Ix5mph//t1LmhOWEogSn/NqE5kCdE3iyAVlowclkqhl5skVfxWD4Pk+oMlkHZ9qNfO/YEnhDmPX6+zmI7Kjyen07nMqy6rGgtA1NSjmW5I7YtqfR5cL9VykBIHHLjCd0AgyWXU8mZFov+ac2+xYwdn8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QUjYrnQA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QUjYrnQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94881F00A3D;
	Mon, 31 Aug 2026 13:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183310;
	bh=Lz9orBHvHMuo2dDSot13uNApdhTqMMfYVzL1h6ipsZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QUjYrnQAKW/ksUfF7byGAmxb+Uj9pht8eHYxDSjj+Cw6wFHqEWxnyF1NuOoN8R6wf
	 hU15rhFVb/2LafJewl2iNCsDB5L2DMnz/lV7lVvh2ifuWZ2Inj3qWFSRd8geKDr73P
	 bltSRHC0ezufihdGOHfg0NqmvMpAuxqf7BVXcJ+09c3sX/UjJccDzOC+0NHqakIrgg
	 X+yq52NDNY5WpWCs1WtCtQU1lrI1HnCKFVNHhelgvZRichzRow2dwa2UQmCOA/Wv6r
	 kZ2ZxKVSydaLY0dZlPdXSgpZ4FWZkUDpwBalzckWJgM/xzubjPgrpWieT0kwzUAV+C
	 jlT2joRtwaDeQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Minhong He <heminhong@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	courmisch@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] phonet: check register_netdevice_notifier() error in phonet_device_init()
Date: Mon, 31 Aug 2026 09:21:40 -0400
Message-ID: <20260831133314.4125787-72-sashal@kernel.org>
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

From: Minhong He <heminhong@kylinos.cn>

[ Upstream commit d1ff66b66151c14b084e88040512a064b1c1e493 ]

phonet_device_init() registers a netdevice notifier before calling
phonet_netlink_register(), but does not check whether notifier
registration succeeded. On failure, netlink setup still proceeds and
init may return success without the notifier in place.

Also, the existing phonet_netlink_register() failure path called
phonet_device_exit(), which runs rtnl_unregister_all() even though
rtnl_register_many() already unwound any partial registration. Calling
the full exit helper on a partial init is not correct.

Check each registration error, including proc_create_net(), and unwind
only the steps that have succeeded so far, in reverse order.

Signed-off-by: Minhong He <heminhong@kylinos.cn>
Link: https://patch.msgid.link/20260721093956.162617-1-heminhong@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[phonet]` `[check]` — Add missing error checking in
`phonet_device_init()` for notifier/proc registration and fix partial-
init unwind.

**Step 1.2 — Tags**

Record:
- `Signed-off-by: Minhong He <heminhong@kylinos.cn>` (author)
- `Link:
  https://patch.msgid.link/20260721093956.162617-1-heminhong@kylinos.cn`
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (netdev maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc:
  stable@vger.kernel.org`, or syzbot tags

**Step 1.3 — Body analysis**

Record:
- **Bug:** `phonet_device_init()` registers a netdevice notifier and
  proc entry without checking return values. If notifier registration
  fails, netlink setup still runs and init can return success without
  the notifier.
- **Second bug:** On `phonet_netlink_register()` failure,
  `phonet_device_exit()` is called, which runs `rtnl_unregister_all()`
  even though `rtnl_register_many()` already unwound partial
  registrations.
- **Symptom:** Partially initialized Phonet subsystem reported as
  successfully loaded; incorrect teardown on failure paths.
- **Root cause:** Missing error checks and use of full exit helper
  instead of reverse-order partial unwind.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Despite no "fix" in the subject, this is init error-
path correctness: unchecked registration failures and improper cleanup
on failure.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `net/phonet/pn_dev.c` (~18 lines added, ~6 removed)
- **Functions:** `phonet_device_init()`, `phonet_device_exit()`
- **Scope:** Single-file, surgical init/exit fix

**Step 2.2 — Code flow changes**

Record:
- **Hunk 1 (`phonet_device_init`):** Before — `proc_create_net()` and
  `register_netdevice_notifier()` called with ignored return values;
  netlink failure calls full `phonet_device_exit()`. After — each step
  checked; labeled error paths unwind only completed steps in reverse
  order (`err_notifier` → `err_proc` → `err_pernet`).
- **Hunk 2 (`phonet_device_exit`):** Before —
  `unregister_pernet_subsys()` before `remove_proc_entry()`. After —
  `remove_proc_entry()` before `unregister_pernet_subsys()`, matching
  reverse of init order.

**Step 2.3 — Bug mechanism**

Record:
- **Category:** Error-path / resource-leak / logic correctness
- **Mechanism 1:** Ignored `register_netdevice_notifier()` failure →
  init can return 0 with no notifier; `phonet_device_notify()` never
  runs for `NETDEV_REGISTER`/`NETDEV_UNREGISTER`.
- **Mechanism 2:** Ignored `proc_create_net()` failure → silent loss of
  `/proc/net/pnresource`.
- **Mechanism 3:** `phonet_device_exit()` on netlink-only failure calls
  `rtnl_unregister_all(PF_PHONET)` after `__rtnl_register_many()`
  already unwound via `__rtnl_unregister_many()` (documented in
  `net/core/rtnetlink.c` lines 523–526).

**Step 2.4 — Fix quality**

Record: Fix is minimal, follows established netdev init patterns
(compare `mctp_device_init()` in this tree). Low regression risk; no API
changes.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: Current buggy lines in `phonet_device_init()` are at
`net/phonet/pn_dev.c:351–372`. `git blame` attributes them to merge
`5d324e5159d9e` (2025-11-28); shallow stable history shows `pn_dev.c`
added in that merge, but file content dates to 2008 Phonet code.

**Step 3.2 — Fixes: tag**

Record: N/A — no `Fixes:` tag in commit message.

**Step 3.3 — Related file history**

Record:
- `52b8f5ef82c88` — phonet RCU UAF fix (already in this tree, `Cc:
  stable`)
- Other recent phonet stable backports: `a48a889b60f73` (pep UAF), skb
  overflow fixes
- **This commit is NOT yet in the tree**

**Step 3.4 — Author's other commits**

Record: Same author (Minhong He) has two nearly identical fixes
**already backported to this 6.18.44 tree**:
- `391a23c503856` — `mctp: check register_netdevice_notifier() error in
  mctp_device_init()`
- `50edffd0854fe` — `can: isotp: check register_netdevice_notifier()
  error in module init()`

**Step 3.5 — Dependencies**

Record: Standalone; no series or prerequisite commits required. All
symbols exist in this tree.

---

## Phase 4: Mailing List and External Research

**Step 4.1–4.5**

Record: **Could not verify** — `b4 dig` requires a commit hash not
present in this tree; lore.kernel.org and patch.msgid.link blocked by
bot protection (Anubis). No local mbox found for this patch.

UNVERIFIED: Reviewer stable nominations, NAKs, or thread discussion.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `phonet_device_init()`, `phonet_device_exit()`,
`phonet_device_notify()` (indirectly affected)

**Step 5.2 — Callers**

Record: `phonet_device_init()` called from `phonet_init()` in
`net/phonet/af_phonet.c:501` during `module_init`. Only runs when
`CONFIG_PHONET` module is loaded.

**Step 5.3 — Callees**

Record: `register_pernet_subsys()`, `proc_create_net()`,
`register_netdevice_notifier()`, `phonet_netlink_register()` →
`rtnl_register_many()`, and corresponding unregister/remove helpers.

**Step 5.4 — Reachability**

Record: Triggered at module load time under resource pressure (e.g.
`-ENOMEM` from notifier chain registration). Not userspace-syscall
reachable directly, but affects module load success semantics.

**Step 5.5 — Similar patterns**

Record: `phonet_init_net()` at line 325 already checks
`proc_create_net()` for the per-net `"phonet"` entry;
`phonet_device_init()` inconsistently does not check the `"pnresource"`
entry. Same notifier-check pattern fixed in `net/mctp/device.c` and
`net/can/isotp.c` in this tree.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Current code at `net/phonet/pn_dev.c:357–362`:

```351:363:net/phonet/pn_dev.c
int __init phonet_device_init(void)
{
        int err = register_pernet_subsys(&phonet_net_ops);
        if (err)
                return err;

        proc_create_net("pnresource", 0, init_net.proc_net,
&pn_res_seq_ops,
                        sizeof(struct seq_net_private));
        register_netdevice_notifier(&phonet_device_notifier);
        err = phonet_netlink_register();
        if (err)
                phonet_device_exit();
        return err;
}
```

**Step 6.2 — Backport complications**

Record: **Clean apply expected** — no conflicting changes; only
`phonet_device_init()`/`phonet_device_exit()` affected.

**Step 6.3 — Related fixes already present?**

Record: MCTP and CAN isotp notifier-check fixes present; phonet
equivalent absent. Phonet RCU/UAF fixes present, showing maintainers
accept phonet stable fixes.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem and criticality**

Record: `net/phonet` — **PERIPHERAL** (Nokia Phonet protocol;
`CONFIG_PHONET` tristate, niche hardware). However, this tree actively
backports phonet fixes.

**Step 7.2 — Activity**

Record: Multiple phonet stable backports in recent history (UAF, skb
overflow, RCU).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users who build/load the `phonet` kernel module (cellular modem
/ legacy Nokia platforms).

**Step 8.2 — Trigger conditions**

Record: Failure of `register_netdevice_notifier()` or
`proc_create_net()` during module init — typically memory pressure
(`-ENOMEM`). Uncommon but possible.

**Step 8.3 — Failure mode severity**

Record:
- **Partial success:** Module appears loaded but notifier missing →
  `phonet_device_notify()` never handles `NETDEV_UNREGISTER`, so
  `phonet_device_destroy()` and `phonet_route_autodel()` are skipped →
  **resource leaks and stale route state** (see `pn_dev.c:296–309`).
- **Wrong cleanup:** Redundant/incorrect `rtnl_unregister_all()` on
  netlink registration failure.
- **Severity: MEDIUM** — not a hot-path crash, but real correctness bug
  with leak potential; module reports success when broken.

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** MEDIUM for Phonet users; prevents silently broken module
  load and improves failure-path correctness
- **Risk:** VERY LOW — ~25 lines, mirrors already-accepted mctp/isotp
  backports in this tree
- **Ratio:** Favorable

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Real init error-handling bug with partial-init-success path
- Missing notifier can skip unregister cleanup (`phonet_device_destroy`,
  `phonet_route_autodel`)
- Small, obviously correct, netdev-maintainer-reviewed
- Same author, same bug class, already backported here for MCTP and CAN
  isotp
- Phonet subsystem receives other stable fixes in this tree
- Applies cleanly to 6.18.44

**Evidence AGAINST:**
- Niche subsystem, few users
- Only triggers on init failure under resource pressure
- No syzbot/user reports
- Impact is correctness/leak, not demonstrated crash in production

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** (pattern proven in-tree for
   mctp/isotp)
2. Fixes a real bug? **PASS**
3. Important issue? **PASS** (partial init success + cleanup bugs;
   MEDIUM severity)
4. Small and contained? **PASS**
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS**

**Exception category:** None (standard init error-path fix).

---

## What This Fix Does and Why It Matters

`phonet_device_init()` can currently return success when the netdevice
notifier was never registered. Without that notifier, Phonet never
reacts to network device registration/unregistration events —
autoconfiguration is skipped and unregister cleanup
(`phonet_device_destroy`, `phonet_route_autodel`) never runs, leaving
leaked state in a module that appeared to load correctly.

The patch also adds the missing `proc_create_net()` check (consistent
with `phonet_init_net()` elsewhere in the same file) and replaces the
blunt `phonet_device_exit()` call on netlink failure with proper step-
by-step unwind.

For stable 6.18.44 users who enable Phonet, this is a low-risk
correctness fix in the same vein as two commits already accepted into
this tree from the same author.

---

## Verification

- [Phase 1] Parsed commit message from user query; tags listed above
- [Phase 2] Read diff and current `net/phonet/pn_dev.c:351–372`;
  confirmed unchecked calls and `phonet_device_exit()` on netlink
  failure
- [Phase 2] Read `phonet_device_notify()` at `pn_dev.c:296–309`;
  confirmed unregister cleanup depends on notifier
- [Phase 2] Read `__rtnl_register_many()` at `rtnetlink.c:523–526`;
  confirmed partial unwind on failure
- [Phase 3] `git blame -L 351,372 net/phonet/pn_dev.c` → all lines from
  `5d324e5159d9e`
- [Phase 3] `git log --oneline -20 -- net/phonet/pn_dev.c` → 2 commits
  visible
- [Phase 3] `git show 391a23c503856`, `git show 50edffd0854fe` → same-
  author notifier fixes already in tree with `Signed-off-by: Sasha
  Levin`
- [Phase 3] `git log --oneline --grep="phonet"` → multiple phonet stable
  backports present; this fix absent
- [Phase 4] UNVERIFIED: lore/patch.msgid.link blocked; `b4 dig` needs
  commit hash not in tree
- [Phase 5] `grep phonet_device_init` → caller `af_phonet.c:501`
- [Phase 5] Read `register_netdevice_notifier()` at `dev.c:1961–1999`;
  can return error with rollback
- [Phase 6] `git describe HEAD` → `v6.18.44-2-g1b9e1abadee04`; `make
  kernelversion` → `6.18.44`
- [Phase 6] Buggy code confirmed present; fix not yet applied
- [Phase 8] Compared with backported `mctp_device_init()` fix at
  `net/mctp/device.c:536–556`

**YES**

 net/phonet/pn_dev.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
index ec9363c337a9f..4bf8f63d45a9a 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -350,16 +350,34 @@ static struct pernet_operations phonet_net_ops = {
 /* Initialize Phonet devices list */
 int __init phonet_device_init(void)
 {
-	int err = register_pernet_subsys(&phonet_net_ops);
+	int err;
+
+	err = register_pernet_subsys(&phonet_net_ops);
 	if (err)
 		return err;
 
-	proc_create_net("pnresource", 0, init_net.proc_net, &pn_res_seq_ops,
-			sizeof(struct seq_net_private));
-	register_netdevice_notifier(&phonet_device_notifier);
+	if (!proc_create_net("pnresource", 0, init_net.proc_net,
+			     &pn_res_seq_ops, sizeof(struct seq_net_private))) {
+		err = -ENOMEM;
+		goto err_pernet;
+	}
+
+	err = register_netdevice_notifier(&phonet_device_notifier);
+	if (err)
+		goto err_proc;
+
 	err = phonet_netlink_register();
 	if (err)
-		phonet_device_exit();
+		goto err_notifier;
+
+	return 0;
+
+err_notifier:
+	unregister_netdevice_notifier(&phonet_device_notifier);
+err_proc:
+	remove_proc_entry("pnresource", init_net.proc_net);
+err_pernet:
+	unregister_pernet_subsys(&phonet_net_ops);
 	return err;
 }
 
@@ -367,8 +385,8 @@ void phonet_device_exit(void)
 {
 	rtnl_unregister_all(PF_PHONET);
 	unregister_netdevice_notifier(&phonet_device_notifier);
-	unregister_pernet_subsys(&phonet_net_ops);
 	remove_proc_entry("pnresource", init_net.proc_net);
+	unregister_pernet_subsys(&phonet_net_ops);
 }
 
 int phonet_route_add(struct net_device *dev, u8 daddr)
-- 
2.53.0

