Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8EF4749FD;
	Mon, 31 Aug 2026 13:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183329; cv=none; b=aqmD7cj1s5bvHvyHG8I7gNW+0IJU5/k6q6L/QoVno+sW/ohFaiRZoar+XChZOi1r4x0v44ct5MCrrc7PyyxWP+5qJ64pQsPGDGI+dmNnhK7mHXbjnstGAtMslbXTIR7F6gdYC65TjjDuhhosaKfDkdfgH4SV7HSxKSaJ/JS+al0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183329; c=relaxed/simple;
	bh=Um+Yywtq3mgBc4I/ppqwrBFLNpk9n+E7O6Xh+T4iosg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MichPg96l8lbHXSD+qGxzhKlVCpedxVpfraGdbUEKDzXKaoj1RDn22Neq2YAOurw5AsLANW5YYR+1CTddJ4ilwdvSZxoUzfNkoWAN5Zes6dhM/RRoc9DOjHjai/Lxz/0Wt6kUY4ew+/5S3RshjaIYQXiLsYfn35sNE6+2booIHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nJPmKiCb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nJPmKiCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3012C1F000E9;
	Mon, 31 Aug 2026 13:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183327;
	bh=zm9StJZEp4qD6VEDPXK6w2BZJySX2VKBZatzxTfHukg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJPmKiCb85bKy6ejAWm++rISBQqDZSm20r1bBTS4TBAKYjYVuBC6r2a0jXkyQK5M6
	 UJrChGU0atMkTMChRE2XuZiV9cgp5Cwc0boukKXgN7VtVIfifUOF7sIerTQIWKhzwc
	 AUIS0WKFADlzdkJkbIz2Ze99gDQ2X6UieaYZbcxVMhR6UIeslt6utV3VqkfLDHhAQc
	 tkUx86mKUjjuTdzjg4Uh8oVSUF2G7fAMzgd3aFbsiHRwuLAI/6jlByHMlfzBZgH/zV
	 ki6LfDkPk+njqwWdJqmhaaB2Zw1TDCCP5na9dYR4qKOXrfbl4rW+ucVi+KGhcJ16nv
	 7QCQN/Bg177Sw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maoyi Xie <maoyixie.tju@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] hsr: broadcast netlink notifications in the device's net namespace
Date: Mon, 31 Aug 2026 09:21:50 -0400
Message-ID: <20260831133314.4125787-82-sashal@kernel.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

[ Upstream commit a762fabd7ef9a6cc07258684138f9c3f078d0326 ]

The HSR generic netlink family sets .netnsok = true. HSR devices can
live in network namespaces other than init_net.

Two async notifiers broadcast events with genlmsg_multicast(). They
are hsr_nl_ringerror() and hsr_nl_nodedown(). That helper delivers
only on the default genl socket in init_net. So the events always land
in init_net. The network namespace of the device does not matter.

This has two effects. A listener in the device's own namespace never
sees its own ring error and node down events. A privileged listener in
init_net receives events from HSR devices in other namespaces. The
payload carries the peer node MAC (HSR_A_NODE_ADDR) and the slave port
ifindex (HSR_A_IFINDEX).

Switch both callers to genlmsg_multicast_netns(). Other families with
.netnsok = true already do this. Examples are gtp, ovpn, team,
batman-adv, netdev-genl, ethtool and handshake.

hsr_nl_ringerror() already has the slave port. It uses
dev_net(port->dev). hsr_nl_nodedown() takes the namespace from the
master port via hsr_port_get_hsr().

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/20260604054949.2999304-1-maoyixie.tju@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[hsr]` `[broadcast]` — Route HSR generic-netlink multicast
notifications into the HSR device's network namespace instead of always
using `init_net`.

**Step 1.2 — Tags**

Record:
- **Reviewed-by:** Fernando Fernandez Mancera `<fmancera@suse.de>` (HSR
  maintainer/contributor)
- **Signed-off-by:** Maoyi Xie `<maoyixie.tju@gmail.com>` (author)
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (net maintainer
  merge)
- **Link:** https://patch.msgid.link/20260604054949.2999304-1-
  maoyixie.tju@gmail.com
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc: stable@` on the merged
  commit (v3/net-next version)
- Notable: A separate `[PATCH net]` stable nomination (2026-05-27)
  included `Fixes: 09e91dbea0aa` and `Cc: stable@`

**Step 1.3 — Body analysis**

Record:
- **Bug:** With `.netnsok = true`, HSR devices can live outside
  `init_net`, but `hsr_nl_ringerror()` and `hsr_nl_nodedown()` use
  `genlmsg_multicast()`, which always delivers to `init_net`.
- **Symptom 1:** Listeners in the device's own namespace never receive
  ring-error or node-down events.
- **Symptom 2:** Privileged listeners in `init_net` receive events from
  HSR devices in *all* namespaces, including peer MAC
  (`HSR_A_NODE_ADDR`) and slave ifindex (`HSR_A_IFINDEX`).
- **Root cause:** Incomplete namespace support when `.netnsok` was
  enabled; other `.netnsok` families (team, gtp, ovpn, batman-adv, etc.)
  already use `genlmsg_multicast_netns()`.
- **Version info:** `.netnsok` added in 5.6 (commit `09e91dbea0aa3`);
  bug latent since then.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Despite net-next framing as a "behavior change," this
fixes (a) a cross-namespace information leak and (b) broken event
delivery for namespaced HSR consumers.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `net/hsr/hsr_netlink.c` — ~7 insertions, ~2 deletions
- **Functions:** `hsr_nl_ringerror()`, `hsr_nl_nodedown()`
- **Scope:** Single-file, surgical fix

**Step 2.2 — Code flow**

Record:
- **`hsr_nl_ringerror()`:** `genlmsg_multicast()` →
  `genlmsg_multicast_netns(..., dev_net(port->dev), ...)`. `port` is
  already available.
- **`hsr_nl_nodedown()`:** Adds `rcu_read_lock()`, looks up master via
  `hsr_port_get_hsr()`, then `genlmsg_multicast_netns(...,
  dev_net(master->dev), ...)`, then `rcu_read_unlock()`. Matches
  existing fail-path pattern.

**Step 2.3 — Bug mechanism**

Record: **Logic/correctness + namespace isolation bug.** Wrong netlink
multicast target namespace. Category: functional defect + cross-
namespace information disclosure (not crash/UAF).

**Step 2.4 — Fix quality**

Record: **High.** Minimal change, follows team/gtp/handshake pattern.
Low regression risk. v3 intentionally dropped NULL-master check (master
guaranteed present on prune/notify paths per Fernando's review).

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: Buggy `genlmsg_multicast()` calls date to HSRv0 introduction
(`f421436a591d3`, 2013). `.netnsok = true` added in `09e91dbea0aa3`
(March 2020, landed in 5.6). Both are ancestors of this tree.

**Step 3.2 — Fixes: tag**

Record: N/A on merged commit. Stable nomination used `Fixes:
09e91dbea0aa ("hsr: set .netnsok flag")`, which **is present** in this
6.18.44 tree.

**Step 3.3 — Related history**

Record:
- `c0178eec88842` (Oct 2025): Enforces HSR slaves must be in same netns
  as HSR device — shows active netns work in HSR.
- No prior fix for multicast namespace routing found.

**Step 3.4 — Author context**

Record: Maoyi Xie is an active net contributor (multiple netns-security
patches). Fernando Fernandez Mancera is the HSR reviewer/maintainer on
this patch.

**Step 3.5 — Dependencies**

Record: **Standalone.** Requires only `genlmsg_multicast_netns()`
(present since `134e63756d5f3` "genetlink: make netns aware") and
`.netnsok = true`. Both exist in this tree. No series dependencies.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record:
- Bug inquiry: https://lists.openwall.net/linux-kernel/2026/05/18/368
  (2026-05-18, with PoC)
- v1 stable nomination:
  https://www.spinics.net/lists/stable/msg951996.html (2026-05-27, `Cc:
  stable@`)
- v2 net-next: https://www.spinics.net/lists/netdev/msg1192529.html
  (author noted "behavior change," dropped stable tags)
- v3 merged version: https://lkml.iu.edu/2606.0/07764.html (dropped
  NULL-master check per Fernando)
- `b4 dig -c <hash>`: **Could not run** — fix commit not yet in local
  tree

**Step 4.2 — Reviewers**

Record: Fernando Fernandez Mancera provided `Reviewed-by`. CC list
included netdev, linux-kernel, HSR maintainers. Jakub Kicinski merged.

**Step 4.3 — Bug report**

Record: PoC (`poc_hsr_pernet.c`) demonstrates:
- Vanilla: `init_net` gets 2 notifications, child namespace gets 0
- Fixed: each namespace gets only its own device's notification
- Severity: namespace isolation violation + broken monitoring for
  namespaced HSR

**Step 4.4 — Series context**

Record: v1→v3 evolution; final merged version is v3 (no NULL check, no
stable tags). Functionally equivalent to stable nomination minus NULL
check.

**Step 4.5 — Stable list**

Record: Explicit stable nomination exists (spinics stable msg951996).
Fernando replied on stable thread (follow-up noted on spinics, full text
not fetched).

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `hsr_nl_ringerror()`, `hsr_nl_nodedown()`

**Step 5.2 — Callers**

Record:
- `hsr_nl_ringerror()`: `hsr_framereg.c:661` from `hsr_prune_nodes()`
  timer (under `rcu_read_lock` when port exists)
- `hsr_nl_nodedown()`: `hsr_framereg.c:668,702` from `hsr_prune_nodes()`
  and `hsr_prune_proxy_nodes()` timers

**Step 5.3 — Callees**

Record: `genlmsg_new()`, `genlmsg_put()`, `nla_put()`, `genlmsg_end()`,
`genlmsg_multicast[_netns]()`, `hsr_port_get_hsr()`, `dev_net()`

**Step 5.4 — Reachability**

Record: Triggered by HSR prune timers during normal HSR/PRP operation
(node aging, link failures). Reachable whenever HSR is configured and
nodes time out — not a rare error-only path. Requires `CONFIG_HSR=m/y`.

**Step 5.5 — Similar patterns**

Record: `drivers/net/team/team_core.c:2866`,
`drivers/net/gtp.c:560,747`, `net/handshake/netlink.c:67` all use
`genlmsg_multicast_netns()` with `dev_net(device->dev)`.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is `v6.18.44`.
`net/hsr/hsr_netlink.c:242,279` still use `genlmsg_multicast()`.
`.netnsok = true` at line 549. Fix not yet applied.

**Step 6.2 — Backport complications**

Record: **Clean apply expected.** File structure matches diff hunks. No
conflicting changes in recent history.

**Step 6.3 — Related fixes already present?**

Record: **No.** No existing fix for HSR multicast namespace routing.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem**

Record: `net/hsr` — networking, HSR/PRP industrial redundancy (IEC
62439). **Criticality: IMPORTANT** (niche but used in power
grid/industrial automation; namespace-aware deployments exist).

**Step 7.2 — Activity**

Record: Active development (netns enforcement Oct 2025, multiple
2025–2026 bug fixes in this tree).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users with `CONFIG_HSR` who run HSR/PRP devices in
non-`init_net` network namespaces, or who rely on namespace isolation.

**Step 8.2 — Trigger conditions**

Record: Normal HSR operation — ring errors detected, nodes pruned after
timeout. Common during link failures. Unprivileged users cannot directly
trigger netlink delivery, but HSR operation in containers/namespaces is
the affected scenario.

**Step 8.3 — Failure mode severity**

Record:
- Cross-namespace info leak (MAC + ifindex to `init_net` listeners):
  **MEDIUM-HIGH** (namespace isolation violation; requires
  `CAP_NET_ADMIN` in `init_net`)
- Missing events in device's namespace: **MEDIUM** (monitoring/alerting
  broken for namespaced HSR)
- No crash, corruption, or deadlock

**Step 8.4 — Risk-benefit**

Record:
- **Benefit:** Restores correct `.netnsok` semantics; closes info leak;
  enables monitoring in namespaced HSR deployments
- **Risk:** Very low — ~7 lines, established pattern, reviewed by HSR
  maintainer
- **Ratio:** Favorable

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence**

FOR:
- Real, demonstrated bug (PoC with before/after counts)
- Cross-namespace information leak across an isolation boundary
- Broken functionality for namespaced HSR consumers since `.netnsok` was
  enabled
- Small, obviously correct fix matching team/gtp/ethtool patterns
- Reviewed by Fernando Fernandez Mancera
- Explicit stable nomination existed
- All prerequisites present in 6.18.44 tree
- Clean apply expected

AGAINST:
- Author initially characterized net-next version as "behavior change"
  (not a fix)
- Latent since 5.6 without user reports until 2026
- HSR is niche (`CONFIG_HSR` tristate)
- Not a crash/corruption/deadlock
- Theoretically could affect tools that relied on receiving all HSR
  events in `init_net` (unintended behavior)

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — PoC verified; pattern used
   elsewhere; Reviewed-by from HSR maintainer
2. Fixes a real bug affecting users? **PASS** — demonstrated with PoC;
   affects namespaced HSR deployments
3. Important issue? **PASS** — cross-namespace info leak (namespace
   isolation) + broken event delivery for monitoring
4. Small and contained? **PASS** — 1 file, ~9 lines
5. No new features/APIs? **PASS** — corrects existing notification
   delivery
6. Can apply to local tree? **PASS** — buggy code and APIs present;
   clean apply expected

**Step 9.3 — Exception categories**

Record: None (not device ID, quirk, DT, build, or docs). Standard bug-
fix category.

**Step 9.4 — Decision rationale**

This commit completes the namespace support started by `.netnsok = true`
in 2020. The current code violates network-namespace isolation by
leaking HSR event data (peer MAC, slave ifindex) into `init_net`, while
simultaneously failing to deliver events to listeners in the device's
own namespace. For a 6.18.y tree where HSR namespace support is already
enabled and netns enforcement was recently tightened (`c0178eec88842`),
this is a warranted stable fix: small, low-risk, and addresses a real
isolation defect with demonstrated reproduction.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff
- [Phase 1] Confirmed no syzbot/Reported-by on merged commit; found
  original bug inquiry (2026-05-18)
- [Phase 2] Read `net/hsr/hsr_netlink.c:216-291` — confirmed buggy
  `genlmsg_multicast()` at lines 242, 279
- [Phase 2] Read `include/net/genetlink.h:508-530` — confirmed
  `genlmsg_multicast()` hardcodes `init_net`
- [Phase 3] `git describe HEAD` → `v6.18.44` / `6.18.44`
- [Phase 3] `git blame` — multicast calls from 2013; `.netnsok` from
  `09e91dbea0aa3` (2020)
- [Phase 3] `git merge-base --is-ancestor 09e91dbea0aa3 HEAD` → IS
  ancestor
- [Phase 3] `git merge-base --is-ancestor 134e63756d5f3 HEAD` → IS
  ancestor (`genlmsg_multicast_netns`)
- [Phase 3] `git log --oneline -20 -- net/hsr/` — recent HSR activity
  confirmed
- [Phase 4] Fetched openwall bug report with PoC test results
- [Phase 4] Fetched spinics stable nomination (Fixes: + Cc: stable@)
- [Phase 4] Fetched v2/v3 netdev threads (Reviewed-by, behavior-change
  discussion)
- [Phase 4] `b4 dig -c <hash>` — UNVERIFIED (commit not in local tree)
- [Phase 5] `grep hsr_nl_ringerror|hsr_nl_nodedown` — callers in
  `hsr_framereg.c:661,668,702`
- [Phase 5] Confirmed team/gtp use `genlmsg_multicast_netns()` pattern
- [Phase 6] Buggy code confirmed present in 6.18.44 tree; fix not yet
  applied
- [Phase 6] Read `net/hsr/Kconfig` — HSR is tristate industrial protocol
- [Phase 7] Subsystem activity confirmed via git log
- [Phase 8] Assessed severity: namespace info leak + functional
  monitoring defect

**YES**

 net/hsr/hsr_netlink.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index c96b63adf96ff..50a8104e864e2 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -239,7 +239,8 @@ void hsr_nl_ringerror(struct hsr_priv *hsr, unsigned char addr[ETH_ALEN],
 		goto nla_put_failure;
 
 	genlmsg_end(skb, msg_head);
-	genlmsg_multicast(&hsr_genl_family, skb, 0, 0, GFP_ATOMIC);
+	genlmsg_multicast_netns(&hsr_genl_family, dev_net(port->dev),
+				skb, 0, 0, GFP_ATOMIC);
 
 	return;
 
@@ -275,8 +276,12 @@ void hsr_nl_nodedown(struct hsr_priv *hsr, unsigned char addr[ETH_ALEN])
 	if (res < 0)
 		goto nla_put_failure;
 
+	rcu_read_lock();
+	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 	genlmsg_end(skb, msg_head);
-	genlmsg_multicast(&hsr_genl_family, skb, 0, 0, GFP_ATOMIC);
+	genlmsg_multicast_netns(&hsr_genl_family, dev_net(master->dev),
+				skb, 0, 0, GFP_ATOMIC);
+	rcu_read_unlock();
 
 	return;
 
-- 
2.53.0

