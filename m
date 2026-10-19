Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D075AD629;
	Mon, 19 Oct 2026 14:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418415; cv=none; b=a7uvNSYTO/47BD5Xm7RGWlD41CDeJtaXNxpnRTu/WHy6OcXxqbx+qFCBp5xsV1EVYMJZhDWHam5feL2nCoxAkXhSX8bF5kmWURT27KPg/7qQ44C1/OzLLld6nOav72uDGb3VoLR3HRkF/HCIkUhC7yl3twcd/TABSRMEvFLnPiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418415; c=relaxed/simple;
	bh=3uFoKIpdhXZ589AhylMXL9PXU4x2uzPwH3PCDNvPTwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f4JWLzmxnPFHJcITa9KY/AFhHQwFSbMDQyagvDzx86VazQZwxCZJVDQOqnMlNmYQ93iV+vK7PZCuq0iWKJ5s13IQpoe/Z1v0A4FkAG+RBEmGD7i0Z3sVBYxOXI6dN+qIBVb3CvNbJsBQVPvRTBcxlNbQsQxZTOCpJFmaC84S1lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HIux8TKR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HIux8TKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AED1F000C7;
	Mon, 19 Oct 2026 14:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418412;
	bh=n+rhH6sFi7Wv5X0hh3VjHO8MU1I4EKEJ3OCazhVuTZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HIux8TKRZ/qUweUgywVCamTemxbClEOu6xsmEIBtYIxdVIZUpMkGmhz0lu+qTuTOj
	 0oMO+Q1gnnq/Pk8bxlT4gn5NgPK4/jjMw7/iZoZq6tJsQ5K4SAQ9b5oytBaPoFHU9C
	 l7dQegkCoLyw7sHJjMPW50ucXQaLFJITcZoD8ILRndWIXrAbiMqeOPJmKO4YSe04rY
	 RMnG0E5nwvSd8eCT4rOTr+L1BM49gwTsJoLUJrRHhh7DIm9NLs1n21eSQkCCFDBZ+t
	 Fw7MeGT1ic+JfUtf3XcMPw4FblNHcNc/zD6AyNTD/xh1TG7dCDvxRb06V1+O/CVZ9v
	 KCBUJOoequogQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Geliang Tang <tanggeliang@kylinos.cn>,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	axboe@kernel.dk,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] nvme-tcp: look up host_iface in the current netns
Date: Mon, 19 Oct 2026 09:48:42 -0400
Message-ID: <20261019135441.1420968-231-sashal@kernel.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 58202950e39c127d593ec4f0624d8b8985a285b1 ]

nvme_tcp_alloc_ctrl() looks opts->host_iface up in &init_net, the boot-time
netns. When called from any other netns - e.g. the selftest's ns2, where
ns2eth1 actually lives - the lookup misses and the controller setup fails
with "invalid interface passed":

 nvmet: adding nsid 1 to subsystem nqn.2014-08.org.nvmexpress.mptcpdev
 nvmet_tcp: enabling port 24660 (0.0.0.0:24099)
 # nvme discover -a 10.1.1.1 --tos=0x10 --host-iface=ns2eth1
 nvme_tcp: invalid interface passed: ns2eth1
 # failed to add controller, error invalid interface

Look the device up in current->nsproxy->net_ns instead so the check sees
the calling task's netns.

Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line netns-correctness fix in existing NVMe-TCP `host-
iface` validation. The buggy lookup is in this 6.12 tree; the patch
applies cleanly.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [nvme-tcp] [look up] [validate `host_iface` in the calling
task’s netns instead of `init_net`]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Reviewed-by: Hannes Reinecke \<hare@kernel.org\> (NVMe/storage
  maintainer)
- Signed-off-by: Geliang Tang \<tanggeliang@kylinos.cn\> (author; MPTCP
  contributor)
- Signed-off-by: Keith Busch \<kbusch@kernel.org\> (NVMe maintainer;
  applied the patch)
- No Fixes:, Reported-by, Tested-by, Link:, or Cc: stable (absence
  expected for this review)
- Ignore pipeline markers (Upstream commit / Sasha Levin SOB) — none in
  the origin commit `58202950e39c1`

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `nvme_tcp_alloc_ctrl()` looks up `opts->host_iface` with
  `__dev_get_by_name(&init_net, ...)`. In any other netns the name is
  missing, so controller setup fails.
- Symptom: `nvme_tcp: invalid interface passed: ns2eth1` then `failed to
  add controller, error invalid interface`. Concrete repro: `nvme
  discover -a 10.1.1.1 --tos=0x10 --host-iface=ns2eth1` from netns
  `ns2`.
- Failure mode: connect/discover abort with `-ENODEV`. Not a crash,
  leak, or corruption.
- Root cause: hardcoded boot netns instead of the calling task’s netns.
- Version info: none in the message. The log line
  `nqn.2014-08.org.nvmexpress.mptcpdev` is from an MPTCP NVMe selftest
  that is not in this tree; the mechanism is not MPTCP-specific.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit correctness fix:
wrong netns for a name lookup. No hidden leak/race/UAF.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/nvme/host/tcp.c` (+2/−1)
- Function: `nvme_tcp_alloc_ctrl()`
- Scope: single-file, one-line surgical change

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record: In the `NVMF_OPT_HOST_IFACE` validation path, existence check
was `__dev_get_by_name(&init_net, opts->host_iface)`. After:
`__dev_get_by_name(current->nsproxy->net_ns, opts->host_iface)`. Normal
connect path only; if the name is missing, still `-ENODEV` /
`out_free_ctrl`.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: logic/correctness (wrong network namespace)
- Mechanism: interface names are per-netns. Lookup in `init_net` rejects
  names that only exist in the caller’s netns (veths, container NICs).
  The later `SO_BINDTODEVICE` already uses `sock_net(sk)`
  (`net/core/sock.c` `sock_setbindtodevice()`), and `sock_create()`
  already uses `current->nsproxy->net_ns`. Only this existence check was
  wrong.
- Not UAF/leak/race/crash. Pre-existing `__dev_get_by_name` without
  RTNL/RCU is unchanged (comment in `net/core/dev.c` says RTNL is
  required). Later MPTCP RFCs added RCU; mainline did not.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct and consistent with `sock_create()`. Minimal.
`current->nsproxy` is valid here: `nvme_tcp_alloc_ctrl()` is only called
from `nvme_tcp_create_ctrl()` → `nvmf_create_ctrl()` →
`nvmf_dev_write()` (userspace write to `/dev/nvme-fabrics`), not from
reconnect workqueues. Regression risk very low: a caller that relied on
init_net names while running in another netns would still fail later at
`SO_BINDTODEVICE`.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Feature: `3ede8f72a9a28` (“nvme-tcp: allow selecting the network
  interface for connections”), 2021-06-03, first in v5.14-rc1. Used
  `dev_get_by_name(&init_net, ...)`.
- Switch to `__dev_get_by_name`: `8b43ced64d2bac` (2021-07-13), Fixes:
  3ede8f72, to avoid holding a netdev ref that blocked unregister. Still
  `&init_net`.
- Both are ancestors of this 6.12 tree. Bug present since the feature
  landed.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Buggy pattern comes from `3ede8f72a9a28` /
`8b43ced64d2bac`, both in HEAD.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent `tcp.c` history in this tree is TLS/PDU hardening, not
host_iface. Origin after this commit has no further host_iface change on
this file. Standalone v1, not “patch X/Y”.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Geliang Tang is an MPTCP contributor, not an NVMe maintainer. In
this tree his nvme work is unrelated (`nvmet-tcp` leak, unused
variable). On origin this is his only `tcp.c` host_iface change. Weight
comes from Hannes’s Reviewed-by and Keith applying it.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: No new helpers. `__dev_get_by_name` and
`current->nsproxy->net_ns` exist here. Applies standalone (hunk
succeeded at offset 32). `inet_pton_with_scope(&init_net, ...)` for
addresses is left as-is; that is a separate scope issue, not a
dependency.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- SHA: `58202950e39c127d593ec4f0624d8b8985a285b1` (not in this tree; on
  origin)
- b4 dig: https://patch.msgid.link/c14cd4633c27abe2dec863480168691023694
  aee.1785033817.git.tanggeliang@kylinos.cn
- Thread (gnuweeb mirror; lore.kernel.org returned 403/bot wall):
  standalone `[PATCH]`, 2026-07-26
- b4 dig -a: v1 only; applied version is that v1
- Hannes Reinecke 2026-07-27: Reviewed-by. Note that discovery-log
  addresses in a netns may not be reachable from the initiator; not a
  NAK of this lookup fix.
- Keith Busch 2026-08-10: “Thanks, applied to nvme-7.3.”
- No NAK, no Cc: stable in the thread
- Earlier MPTCP RFC series combined netns + RCU (`dev_get_by_name_rcu` /
  `netdev_name_in_use`); the committed patch is the netns one-liner only

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: b4 dig -w recipients: Keith Busch, Jens Axboe, Christoph
Hellwig, Sagi Grimberg, Hannes Reinecke, linux-nvme. Appropriate
maintainers. Hannes reviewed; Keith applied.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Evidence is the author’s selftest log
(`ns2eth1` in ns2). That MPTCP NVMe selftest is not in this 6.12 tree.
Bug is still real for any netns + `host-iface`.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Applied as a standalone linux-nvme patch, not as part of the
MPTCP NVMe series. No sibling patch required for this lookup.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: gnuweeb `/stable/` search 404; lore.kernel.org 403. No verified
stable-list discussion. UNVERIFIED: whether anyone already nominated or
rejected this for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `nvme_tcp_alloc_ctrl()` only.

Step 5.2: TRACE CALLERS
Record:
- `nvme_tcp_alloc_ctrl` ← `nvme_tcp_create_ctrl` (`.create_ctrl` of
  `nvme_tcp_transport`)
- ← `nvmf_create_ctrl()` in `drivers/nvme/host/fabrics.c`
- ← `nvmf_dev_write()` (misc device write)
- Userspace: nvme-cli `connect`/`discover` writing to `/dev/nvme-
  fabrics`
- Reconnect (`nvme_tcp_setup_ctrl` / `nvme_tcp_alloc_queue`) does not
  call `alloc_ctrl`; it reuses `opts->host_iface` on `SO_BINDTODEVICE`

Step 5.3: TRACE CALLEES
Record: `__dev_get_by_name(net, name)` → `netdev_name_node_lookup()`.
Existence check only; no ref taken (that was the point of
`8b43ced64d2bac`).

Step 5.4: FOLLOW THE CALL CHAIN
Record: Reachable from userspace via `/dev/nvme-fabrics` when
`host_iface=` is set. Privileged fabrics connect, not an unprivileged
syscall smash. In this tree `nvme_tcp_alloc_queue()` uses
`sock_create()` → `current->nsproxy->net_ns`, then `sock_setsockopt(...,
SO_BINDTODEVICE, ...)` which looks up the name in `sock_net(sk)`.
Validation was the only `init_net` step on that path.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Only this `__dev_get_by_name` in `drivers/nvme/`. RDMA transport
has no `NVMF_OPT_HOST_IFACE`. `inet_pton_with_scope(&init_net, ...)`
remains for `traddr`/`host_traddr` (numeric parse; different issue).

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. `drivers/nvme/host/tcp.c:3000`:
`if (!__dev_get_by_name(&init_net, opts->host_iface))`
Tree: pending-6.12, `make kernelversion` 6.12.111, `git describe HEAD`
p-6.12-3-gc504cf0baa3d8. Bug since v5.14. `git merge-base --is-ancestor
58202950e39c1 HEAD` is false (fix not present).

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: `git apply --check` of origin diff: hunk succeeded at offset 32.
Local context still `kcalloc` (mainline later `kzalloc_objs`); that is
after the hunk, not in it. Expected: clean apply / trivial offset.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No later host_iface netns fix. `1be52169` (sock_create_kern) and
`b013b817` (netns UAF on kernel TCP socket) are not in this tree; this
patch does not depend on them.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: NVMe over Fabrics TCP host (`drivers/nvme/host/tcp.c`,
`CONFIG_NVME_TCP`). Criticality: IMPORTANT — datacenter remote block
storage, not core mm/vfs, not staging.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained (TLS, PDU validation, etc.). `host_iface`
itself has been stable since 5.14 with only the 2021 refcount change
until this 2026 netns fix.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Users of NVMe-TCP who pass `host_iface=` from a non-init netns,
when that name is not also in `init_net`. Driver-specific + config
(`CONFIG_NVME_TCP`) + optional option. Typical host-net `eth0` cases
often pass the init_net check by accident; unique names (`ns2eth1`,
container veths) fail.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Write connect/discover options including `host_iface=<name>`
from a process whose netns is not `init_net`. Not every boot; only this
option. Needs fabrics connect privilege, not unprivileged
exploitability.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Controller creation fails (`-ENODEV`); no NVMe device. No oops,
hang, or corruption. Severity: MEDIUM (availability of an existing
option), HIGH for those who need interface pinning in a netns.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: medium for netns/container NVMe-TCP with `host-iface`; low
  for default host-net users
- Risk: very low (1-line, same helper, same error path)
- Ratio: favorable — almost no regression surface, real connectivity bug

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR:
- Real, reproduced failure: `host-iface` rejected in non-init netns
- Feature and buggy code exist in 6.12 since v5.14
- Matches how sockets are created and bound in this tree
- One-line, obviously correct; applies with offset only
- Reviewed by Hannes Reinecke; applied by Keith Busch
- No new API/feature; restores intended `host-iface` behavior
- Storage connect failure is user-visible for affected deployments
  (containers, netns isolation, multi-homed pinning)

AGAINST:
- Not a crash, UAF, corruption, deadlock, or security bug
- Optional `host-iface` plus non-init netns is a relatively narrow path
- Motivating selftest (MPTCP NVMe) is not in 6.12
- Went into nvme-7.3 updates, not a -fixes pull; no stable nomination in
  the thread
- Hannes noted broader discovery/netns limitations (not a NAK)

UNRESOLVED:
- Stable mailing list discussion (lore blocked / gnuweeb stable 404)
- Whether distro/k8s NVMe-TCP actually uses `host-iface` from a
  container netns (plausible, not counted)

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — one-line netns fix; maintainer
   Reviewed-by; author reproduced
2. Fixes a real bug that affects users? PASS — connect fails with
   `-ENODEV` for a valid interface in the caller’s netns
3. Important issue? PASS — availability of NVMe-TCP when `host-iface` is
   used from a netns; not a panic, but a functional showstopper on that
   path. Small correctness fixes of this kind are routine in stable
4. Small and contained? PASS — +2/−1 in one function
5. No new features or APIs? PASS
6. Can apply to the local tree? PASS — buggy line present; apply-check
   succeeded at offset 32

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device ID, quirk, DT, build, or docs fix). Qualifies
as a normal small bugfix.

Step 9.4: MAKE YOUR DECISION
The local 6.12 tree still looks `host_iface` up in `init_net` while
creating the TCP socket in the caller’s netns. That is a long-standing,
self-contained correctness bug. Backporting this line restores
connect/discover with `--host-iface` from containers and other netns
without new infrastructure. Risk is negligible compared with leaving
NVMe-TCP interface pinning broken off host netns.

===============================================================
What the commit solves for this tree
===============================================================

`host_iface` is supposed to force NVMe-TCP onto a named NIC via
`SO_BINDTODEVICE`. Validation used `&init_net`, so a name that only
exists in the calling netns is treated as invalid and controller setup
aborts. In 6.12 the socket is already created with `sock_create()`
(current netns) and bind-to-device already searches that netns. The
check is the broken piece. Stable users who pin NVMe-TCP to a NIC from a
netns/container hit a hard connect failure; this is the whole fix.

Risk vs benefit: benefit is restoring an existing option in netns; risk
is a one-line lookup change with the same `-ENODEV` path. No
prerequisites. `inet_pton_with_scope(&init_net)` is untouched and not
required for this fix.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed origin commit `58202950e39c1`: Reviewed-by Hannes
  Reinecke; SOB Geliang Tang + Keith Busch; no Fixes/Cc-stable
- [Phase 2] Diff: +2/−1 in `nvme_tcp_alloc_ctrl()`; `&init_net` →
  `current->nsproxy->net_ns`
- [Phase 2] Confirmed `sock_setbindtodevice()` uses `sock_net(sk)`;
  `sock_create()` uses `current->nsproxy->net_ns` (`net/socket.c:1614`)
- [Phase 3] blame: `3ede8f72a9a28` (v5.14-rc1) introduced init_net
  lookup; `8b43ced64d2bac` switched to `__dev_get_by_name`, still
  init_net; both ancestors of HEAD
- [Phase 3] `git merge-base --is-ancestor 58202950e39c1 HEAD` → not an
  ancestor (fix absent)
- [Phase 4] `b4 dig -c 58202950e39c1`: lore msgid `c14cd4633c27abe2...`;
  v1 only
- [Phase 4] `b4 dig -w`: linux-nvme maintainers on To/Cc
- [Phase 4] Hannes: Reviewed-by plus discovery/netns remark, no NAK;
  Keith: applied to nvme-7.3
- [Phase 4] lore.kernel.org 403; used lore-kernel.gnuweeb.org.
  UNVERIFIED: stable@ thread
- [Phase 5] Callers via grep: only `nvme_tcp_create_ctrl` →
  `nvmf_dev_write`; reconnect does not call `alloc_ctrl`
- [Phase 6] `git describe HEAD` p-6.12-3-gc504cf0baa3d8; `make
  kernelversion` 6.12.111; buggy line at `tcp.c:3000`
- [Phase 6] `git apply --check` of origin diff: succeeded at offset 32
- [Phase 6] `1be52169` / `b013b817` not in this tree; not required
- [Phase 8] Failure: `-ENODEV` / invalid interface; severity MEDIUM–HIGH
  availability, not crash
- UNVERIFIED: production hit rate of host-iface from container netns;
  MPTCP selftest not in this tree

**YES**

 drivers/nvme/host/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index beef2b576102a..1f26e35d7a99e 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2999,7 +2999,8 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 	}
 
 	if (opts->mask & NVMF_OPT_HOST_IFACE) {
-		if (!__dev_get_by_name(&init_net, opts->host_iface)) {
+		if (!__dev_get_by_name(current->nsproxy->net_ns,
+				       opts->host_iface)) {
 			pr_err("invalid interface passed: %s\n",
 			       opts->host_iface);
 			ret = -ENODEV;
-- 
2.53.0

