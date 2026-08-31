Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175FE595741;
	Mon, 31 Aug 2026 13:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184279; cv=none; b=TBiRrNcBApeIZGCFhx6UNuLIKOXPpj0puLjwfT9ZF8B3nd/hcgeUgEd/IsccQ3MieWPvYdKKEYSN8D03UOEo7E69f+5+ownO2Mb1I3Ipq+onrus3+yxQlbb8RHVtbL8vkp7wcO3iKUCJFHDRxR9dv8+lo7/yPNKjwq5eabaqUU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184279; c=relaxed/simple;
	bh=MFGo9wuqcFy1OaeTjRO8+XEpDfoOa0+pGig6UGW5TEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k2adEaUNMXzeHaIJip3Xc0TRzdaViUIPMAuOey+Xwth65BEVFq+ARjsSf6t1BGbM8m/W9r+a8T6e7cFX2fjmdLejtvC+ydA9I4UcbnPhyjWZSLCQOghdoknRkLnRlN+5cQh7XQX/2+UIrQMU3C+FZ5sX3/7azkix3FPKs/LAzCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajLWnB44; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajLWnB44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59C61F00ADB;
	Mon, 31 Aug 2026 13:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184276;
	bh=utPV3/Hfyctc6H1HLah8UnMa23Eh18Ko5bEFsp5BTmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajLWnB4410jPFEKqGRgC37YkrVDG+4Zu9BvMHjs02iM0mluMHFbxwB0hehs2y50Tl
	 KHhsExYkv2qNryhQWa0/oxHw3Rf4yQytyClGBNggqd3alOpXJA8fE7H+fRekx04ypA
	 WBqc1MSVa048bFSNEAG/4zb10rzWrOyPt8+wSyMysn9WaYB2Riu8uNzlhgbl3VHDc1
	 N4ajLbBTqjL6syuBf6wwDZrbdh8iGJMlSYg2OFwiCUJXziiuNK2cs+EjLM4RW6Cwqt
	 6nzdGTtlKd+0KuVg9HjJ5Lv412HUEDV06rwdykl5l2qG8HzaQN+SNukOujqKvZPL00
	 ibOAVyOatj/5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Sasha Levin <sashal@kernel.org>,
	john.fastabend@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] tls: reject the combination of TLS and sockmap
Date: Mon, 31 Aug 2026 09:30:24 -0400
Message-ID: <20260831133314.4125787-596-sashal@kernel.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 460e6486617c17dd19abe8f3fc67d9a6fa25f8ca ]

TLS and sockmap (BPF psock) integration hides a lot of latent bugs.
Bugs which may be more or less relevant for real users but they
are definitely exploitable.

We could not find anyone actively using this integration so let's
reject this config. Adding a TLS socket to a sockmap was already
rejected by sk_psock_init() through the inet_csk_has_ulp() check.
We need to reject the attempts to configure the TLS keys (rather
than adding the ULP itself) because checking prior to the ULP
installation is tricky without risking a race with sockmap getting
added in parallel (sockmap does not hold the socket lock).

This patch is a minimal rejection of the feature. Subsequent patch
in the series will do a light dead code removal. Full cleanup would
require a major rewrite of the Tx path, we don't need skmsg any more.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20260614014102.461064-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[tls]` / `reject` — reject the unsupported TLS + sockmap
(BPF psock) configuration.

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Jakub Sitnicki `<jakub@cloudflare.com>`
- **Reviewed-by:** Sabrina Dubroca `<sd@queasysnail.net>`
- **Link:**
  https://patch.msgid.link/20260614014102.461064-2-kuba@kernel.org
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>`
- No Fixes:, Reported-by:, Cc: stable@vger.kernel.org, or syzbot tags
- Notable: two subsystem reviewers; commit explicitly calls bugs
  “definitely exploitable”

### Step 1.3: Body analysis
**Record:**
- **Bug:** TLS + sockmap integration has multiple latent, exploitable
  bugs; only half of the mutual exclusion was enforced
  (`sk_psock_init()` blocks TLS→sockmap, but not sockmap→TLS key setup).
- **Symptom:** Reverse-order setup (sockmap first, then TLS key
  configuration) reaches broken code paths (UAF, data corruption, kernel
  BUG/panic — documented externally and in related stable fixes).
- **Root cause:** `sk_psock_init()` checks `inet_csk_has_ulp()`, but
  `do_tls_setsockopt_conf()` did not check for an existing psock;
  checking earlier (at ULP install) is racy because sockmap does not
  hold the socket lock.
- **Version info:** None in the commit message; external report confirms
  impact on 6.12.77 LTS.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although phrased as “reject this config,” this is
security hardening that closes an exploitable attack/configuration path,
not a cosmetic cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `net/tls/tls_main.c` (+11 / -0)
- **Function:** `do_tls_setsockopt_conf()`
- **Scope:** Single-file, surgical change

### Step 2.2: Code flow change
**Record:**
- **Before:** `do_tls_setsockopt_conf()` accepted `TLS_TX`/`TLS_RX`
  crypto configuration on any socket, including one already in a
  sockmap.
- **After:** Under `rcu_read_lock()`, if `sk_psock(sk)` is non-NULL,
  return `-EINVAL` before any crypto configuration proceeds.
- **Path affected:** `setsockopt(SOL_TLS, TLS_TX/TLS_RX, ...)` error
  path; called from `do_tls_setsockopt()` under `lock_sock()`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness + security hardening (unsupported
  configuration reachable).
- **Mechanism:** Sockmap-first, TLS-second (“reverse order”) bypasses
  the existing `inet_csk_has_ulp()` guard in `sk_psock_init()`. TLS
  RX/TX key setup arms strparser/send paths that corrupt TCP sequence
  state and can trigger UAF (as in commit `1861d369efd62` already
  present in this tree).

### Step 2.4: Fix quality
**Record:**
- Obviously correct: mirrors the existing one-way rejection in
  `sk_psock_init()`.
- Minimal and self-contained.
- Low regression risk: only affects sockets already in a sockmap; author
  states no known users of this combination.
- Uses the same `sk_psock()` + `rcu_read_lock()` pattern already used
  elsewhere in TLS code.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** `do_tls_setsockopt_conf()` dates to 2017 (`Dave Watson`);
the missing psock check has been present since the function existed.
TLS+sockmap integration was added in `d3b18ad31f93` (2018, “tls: add bpf
support to sk_msg handling”).

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in this commit.

### Step 3.3: Related file history
**Record:** Related stable-worthy fixes in this tree:
- `1861d369efd62` — UAF when sockmap inserted before TLS RX (already in
  6.18.44)
- `54a3ecaeeeae8` — kernel BUG in `tls_sw_sendmsg` with sockmap
- `4da6a196f93b1` — sockmap/TLS teardown infinite loop (syzbot, Cc:
  stable)
- Long history of TLS+sockmap fixes since 2019 “bpf-sockmap-tls-fixes”
  merge

### Step 3.4: Author context
**Record:** Jakub Kicinski is the networking maintainer; reviewers
Sitnicki and Dubroca are active TLS/BPF contributors.

### Step 3.5: Dependencies
**Record:** Standalone. Part of a 5-patch net-next series (`461064-1`
through `461064-5`); later patches remove dead code but are not required
for this rejection to work. Cherry-pick to current HEAD applies cleanly.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:**
- **b4 dig URL:**
  https://patch.msgid.link/20260614014102.461064-2-kuba@kernel.org
- **Series:** v1 only (no later revisions found)
- **Reviewers:** Sitnicki and Dubroca Reviewed-by in thread
- No explicit stable nomination found in thread; no NAKs found

### Step 4.2: Reviewers CC'd
**Record:** netdev@vger.kernel.org, bpf@vger.kernel.org, davem,
edumazet, pabeni, john.fastabend, sd@queasysnail.net — appropriate
maintainer/reviewer coverage.

### Step 4.3: Bug reports
**Record:** oss-sec report (2026/q2/423) documents “reverse order”
KTLS+sockmap UAF/data corruption:
- Sockmap first, then enable KTLS
- Bypass for CVE-2025-37756 mitigation
- Confirmed on Linux 6.12.77 LTS
- Requires `CAP_NET_ADMIN` + `CAP_BPF` (container/LPE context)
- Recommends blocking reverse-order in `tls_main.c`

### Step 4.4: Series context
**Record:** Patch 1/5 rejects the combination; patches 2–5 remove dead
sockmap handling from TLS SW path and selftests. This patch is
independently valuable without the cleanup series.

### Step 4.5: Stable list
**Record:** No stable-list discussion found for this specific commit.
Related UAF fix `1861d369efd62` was already backported to this 6.18.y
tree.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `do_tls_setsockopt_conf()`, called from
`do_tls_setsockopt()` for `TLS_TX`/`TLS_RX`.

### Step 5.2: Callers
**Record:** `tls_setsockopt()` → `do_tls_setsockopt()` →
`do_tls_setsockopt_conf()`. Reachable from userspace via `setsockopt()`
on a TLS ULP socket.

### Step 5.3: Callees
**Record:** `sk_psock(sk)` (inline in `include/linux/skmsg.h`),
`rcu_read_lock/unlock`, existing crypto validation path.

### Step 5.4: Reachability
**Record:**
1. Create TCP socket
2. `bpf_map_update_elem()` to insert into sockmap (needs `CAP_BPF` +
   `CAP_NET_ADMIN`)
3. `setsockopt(TCP_ULP, "tls")`
4. `setsockopt(SOL_TLS, TLS_RX/TLS_TX, ...)` — **blocked by this patch**

Userspace-reachable with container-privileged capabilities.

### Step 5.5: Similar patterns
**Record:** Complementary guard already exists in `sk_psock_init()`:

```758:761:net/core/skmsg.c
        if (sk_is_inet(sk) && inet_csk_has_ulp(sk)) {
                psock = ERR_PTR(-EINVAL);
                goto out;
        }
```

This patch completes the other direction.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** `git describe HEAD` → `v6.18.44-1-g2736c32da98b9`.
`do_tls_setsockopt_conf()` at lines 610–624 has no `sk_psock()` check.
Commit `460e6486617c` is **not** in HEAD history (`NOT in HEAD
history`).

### Step 6.2: Backport complications
**Record:** **Clean apply.** Test cherry-pick: `Auto-merging
net/tls/tls_main.c`, +11 lines, no conflicts. `sk_psock()` available via
`net/tls/tls.h` → `#include <linux/skmsg.h>`.

### Step 6.3: Related fixes already present?
**Record:** `1861d369efd62` (UAF fix for sockmap-before-TLS-RX) is
already in this tree. That fixes one specific failure mode; this commit
prevents the configuration entirely and blocks additional exploitable
paths the maintainers cite.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem criticality
**Record:** **IMPORTANT** — `net/tls` (kTLS) + BPF sockmap; affects
container/cloud workloads using BPF socket policy and kTLS.

### Step 7.2: Activity
**Record:** Actively maintained; multiple TLS+sockmap fixes in
2025–2026.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users with `CONFIG_TLS` + `CONFIG_BPF_SYSCALL` + sockmap
enabled who can configure both subsystems (typical in
container/K8s/service-mesh environments).

### Step 8.2: Trigger conditions
**Record:** Deliberate reverse-order configuration: sockmap attach, then
TLS key setup. Unlikely in production (no known users), but reachable
and documented as exploitable.

### Step 8.3: Failure mode severity
**Record:** **CRITICAL** — UAF, kernel BUG/panic, data corruption;
external report ties to privilege-escalation/container-escape class
issues and CVE-2025-37756 bypass.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** High — closes exploitable security path; complements
  existing one-way guard and partial UAF fix.
- **Risk:** Very low — 11 lines, returns `-EINVAL` on unsupported
  config, reviewed by TLS experts.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Exploitable security issue (maintainer statement + oss-sec report)
- Confirmed on 6.12.77 LTS; same integration exists in 6.18.44
- Small, surgical, applies cleanly
- Completes mutual exclusion already half-implemented
- Reviewed by TLS subsystem experts
- Prevents bypass of prior CVE mitigations
- Related UAF already backported here — this is the upstream-preferred
  prevention

**AGAINST backport:**
- Part of a larger removal series (subsequent dead-code cleanup not
  needed for function)
- Does not block `tls_init()` at TCP_ULP time (oss-sec suggested that);
  blocks at key config instead — minor gap, but key config is where
  dangerous paths arm
- No known production users (low practical impact, but security still
  matters)

**Unresolved:** No syzbot link in this specific commit; lore thread had
no explicit stable nomination.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — simple guard, reviewed,
   cherry-picks cleanly.
2. Fixes real bug affecting users? **PASS** — closes documented
   exploitable configuration path.
3. Important issue? **PASS** — security/UAF/crash class.
4. Small and contained? **PASS** — 11 lines, one file.
5. No new features/APIs? **PASS** — restricts unsupported config only.
6. Can apply to local tree? **PASS** — verified clean cherry-pick on
   6.18.44.

### Step 9.3: Exception category
**Record:** Security hardening / unsupported-configuration rejection
(similar to prior stable rejections of broken feature combinations).

### Step 9.4: Decision rationale
This tree (6.18.44) still allows sockmap-first → TLS-key-configuration,
a path with documented UAF and privilege-escalation potential. The fix
is minimal, expert-reviewed, applies cleanly, and closes a gap left by
the existing one-way `sk_psock_init()` check. Even though a related UAF
was already fixed in `1861d369efd62`, maintainers state multiple
exploitable bugs remain in this integration. Blocking the configuration
is appropriate stable material.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified security-hardening
  intent
- [Phase 2] Diff: +11 lines in `do_tls_setsockopt_conf()`, adds
  `sk_psock()` check under RCU
- [Phase 3] `git blame`: function from 2017; TLS+sockmap since
  `d3b18ad31f93` (2018)
- [Phase 3] Related fixes verified: `1861d369efd62`, `54a3ecaeeeae8`,
  `4da6a196f93b1` in tree history
- [Phase 3] `git merge-base --is-ancestor 460e6486617c HEAD` → NOT in
  HEAD history
- [Phase 4] `b4 dig -c 460e6486617c`: lore URL found; v1 series only
- [Phase 4] `b4 dig -w`: netdev, bpf lists and maintainers CC'd
- [Phase 4] Web search: oss-sec 2026/q2/423 documents reverse-order UAF
  on 6.12.77 LTS
- [Phase 5] Call chain: `setsockopt` → `tls_setsockopt` →
  `do_tls_setsockopt_conf`
- [Phase 5] `sk_psock_init()` one-way guard verified at
  `net/core/skmsg.c:758-761`
- [Phase 6] `git describe HEAD` → v6.18.44; buggy code confirmed absent
  of fix
- [Phase 6] Cherry-pick test of `460e6486617c` → clean apply
- [Phase 6] `1861d369efd62` confirmed ancestor of HEAD (UAF fix present)
- [Phase 8] Failure mode: UAF/crash/security — CRITICAL severity

**YES****Verdict: YES** — backport to this tree (6.18.44).

The commit (`460e6486617c`) adds an 11-line guard in
`do_tls_setsockopt_conf()` to reject TLS key setup on sockets already in
a sockmap. That closes the “reverse order” path (sockmap first, then
TLS) that bypasses the existing `sk_psock_init()` check and has led to
UAF/crash bugs; an oss-sec report documents this on 6.12.77 LTS.

The patch is not in HEAD yet, but it cherry-picks cleanly onto 6.18.44.
It’s small, security-relevant, and reviewed by TLS maintainers.

 net/tls/tls_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 39a2ab47fe720..ab30f5de2c658 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -620,6 +620,17 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 	int rc = 0;
 	int conf;
 
+	/* TLS and sockmap are mutually exclusive. A socket already in a
+	 * sockmap (i.e. with a psock attached) cannot be upgraded to TLS.
+	 * sockmap rejects TLS sockets already (see sk_psock_init()).
+	 */
+	rcu_read_lock();
+	if (sk_psock(sk)) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	rcu_read_unlock();
+
 	if (sockptr_is_null(optval) || (optlen < sizeof(*crypto_info)))
 		return -EINVAL;
 
-- 
2.53.0

