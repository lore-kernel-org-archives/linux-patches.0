Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66D95B5846;
	Mon, 19 Oct 2026 14:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418441; cv=none; b=ehfp4hJXcE+n77sQ0Fg+vIsqSXuwAk5DaNLOq6jSfYM7zjZmARTZt8hnpze1qizLDaBIh6Qey0li7XXMRiV9WTtzpl7dgl/w8/GBbUlOIkV6UfXCHEcWH7SvBM8UDQi84RNoTn1kJvkmvyG+ZQQ3GLmSpI6O2DrrCySJiWOfUkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418441; c=relaxed/simple;
	bh=OfY8kwR5Zo1Kl5sBko8Vv1llLZEvGXcKYqIjTfwpz50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UmrR+xKR4GjDlU3UC7gUo24X4SYJ+Ubp8oD02pOjC3uelB0weG1OabBqsTqa22e5V/hLutB0DtmblgnQ/4L2L9lgDHBYKpk7+HmyTj2ymZAJZcGobbwlaO4QTmmL2zViyg4BZoj59c6n380xeGyiVId1arvcgJkGEZRAy2M+epU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WWnyzBXI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WWnyzBXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914701F000C4;
	Mon, 19 Oct 2026 14:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418438;
	bh=GxtG7fv1eAppClQmc13q7JrC+mlvaj0Pd5oOi23SH4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWnyzBXInruMWZn1vq+OtEe5pSKBMk5ZKYcz0bQGManGSACwikCmNF1CvsuDr2nhp
	 LUozowgiskLubg+6Y2Ry0WS64Co8Mh9zdKncg6A9pVrijVP0Sre7GkJ6EBzROmbAJ1
	 cknDPoqntETcHvBMMnJwjGrOx9JVHmWlv0C1PPtcOSoJaYYWyed1wF4hxA/WCQidr7
	 XT2GnB6LYoufBz06E1L7c5yyQS1hsBXxtz5rP/zk84WJwzd6wjtLLTS7fMN7TYNbuQ
	 gGoTU4bTF42lYL4s3a+Oa9q7gCec7cm3ZqhPSL81MqHULI28cSAel1K31Lh9HhK3/1
	 QmfaSzZLjeiSA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	axboe@kernel.dk,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] nvme-tcp: delay nvme_tcp_reclassify_socket()
Date: Mon, 19 Oct 2026 09:49:00 -0400
Message-ID: <20261019135441.1420968-249-sashal@kernel.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 447a7a3026eda85ac2738cbe6ee5ab066a39dad0 ]

Commit 841aee4d75f1 ("nvme-tcp: lockdep: annotate in-kernel sockets")
introduced nvme_tcp_reclassify_socket() to resolve a lockdep WARN by
distinguishing userspace sockets from nvme-tcp sockets. After that, TLS
encryption support was introduced to nvme-tcp and it added another lock
dependency on userspace socket handling by tlshd, which resulted in a
new lockdep WARN. This WARN was hidden by the commit 19bdb70c77d3
("nvme-tcp: lockdep: use dynamic lockdep keys per socket instance").
However, it turned out the commit 19bdb70c77d3 has a bug of lockdep key
lifetime management, and it is to be reverted by another patch in this
series. After the revert, the WARN was unveiled and observed at the
blktests test case nvme/062:

  WARNING: possible circular locking dependency detected
  7.3.0-rc2+ #455 Tainted: G        W
  ------------------------------------------------------
  tlshd/75867 is trying to acquire lock:
  ffffffff91ada5e0 (fs_reclaim){+.+.}-{0:0}, at: __kmalloc_cache_noprof+0x64/0x6d0

  but task is already holding lock:
  ffff888197808258 (sk_lock-AF_INET-NVME){+.+.}-{0:0}, at: do_tcp_setsockopt+0x499/0x26a0

  which lock already depends on the new lock.

To fix the lockdep WARN caused by the TLS encryption support, delay the
reclassification of the nvme-tcp sockets. Currently the reclassification
happens before the TLS handshake starts, which pulls in the additional
lock dependencies related to tlshd. Reclassify the sockets after the TLS
handshake instead, to cut that dependency.

Link: https://lore.kernel.org/lkml/CANn89i+wnTLC==UnXCpjsS4YxvEfhe5oK0N7fttbqr1zKyqdug@mail.gmail.com/
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **6.18.57** (`v6.18.57-155-gcdf239ca885b2`). The question
is whether `nvme-tcp: delay nvme_tcp_reclassify_socket()` should be
backported **here**. The buggy pattern is present in 6.18, the change is
three lines, and it does not depend on the 7.3-era revert that
accompanied it upstream.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[nvme-tcp] [delay] delay nvme_tcp_reclassify_socket() until
after the TLS handshake`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Link: https://lore.kernel.org/lkml/CANn89i+wnTLC==UnXCpjsS4YxvEfhe5oK
  0N7fttbqr1zKyqdug@mail.gmail.com/` (Eric Dumazet report of the
  lockdep-key lifetime bug)
- `Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>`
- `Signed-off-by: Eric Dumazet <edumazet@google.com>` (author)
- `Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>`
- `Signed-off-by: Keith Busch <kbusch@kernel.org>` (NVMe maintainer)
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected)
- No `Reported-by:` / syzbot tag on this commit itself (the Link is the
  related lockdep-key discussion)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** After `841aee4d75f1` put nvme-tcp sockets in a private lock
  class, TLS support made `tlshd` operate on an already-reclassified
  NVME socket. That pulled userspace TLS lock dependencies into
  `sk_lock-AF_INET-NVME`.
- **Symptom:** lockdep `WARNING: possible circular locking dependency
  detected` in blktests `nvme/062`. `tlshd` holds `sk_lock-AF_INET-NVME`
  and tries to take `fs_reclaim` via `__kmalloc_cache_noprof`.
- **Hiding commit:** `19bdb70c77d3` (dynamic per-socket lockdep keys)
  hid the WARN, then proved buggy and is reverted by patch 1/2 of the
  same series.
- **Fix:** reclassify after the TLS handshake so `tlshd` runs against
  the default socket class.
- **Version in the splat:** 7.3.0-rc2+; that is the mainline
  observation, not a claim that 6.18 is unaffected.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit lockdep-isolation
fix. `nvme_tcp_reclassify_socket()` is already a no-op without
`CONFIG_DEBUG_LOCK_ALLOC`, so the runtime effect is lockdep-only.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/nvme/host/tcp.c` (`+2 / -1`)
- Function: `nvme_tcp_alloc_queue()`
- Scope: single-file surgical move of one call

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `sock_create_kern` → `sock_alloc_file` →
  `sk_net_refcnt_upgrade` → **`nvme_tcp_reclassify_socket()`** →
  sockopts/connect → optional `nvme_tcp_start_tls()` →
  `nvme_tcp_init_connection()`
- **After:** same path, but reclassify runs **after** TLS handshake (or
  after connect if TLS is not used), still **before**
  `nvme_tcp_init_connection()`
- Affected path: queue allocation / controller connect, including the
  TLS handshake path

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: lockdep class mixing (userspace `tlshd` vs in-kernel nvme-
  tcp), same family as `841aee4d75f1`
- Mechanism: early reclassify makes TLS setsockopt/`kmalloc` look like
  NVME-class `sk_lock` → `fs_reclaim`. Combined with existing NVME-class
  reclaim dependencies, lockdep reports a cycle.
- Fix: keep handshake on the default `AF_INET` class; switch to NVME
  class only once kernel NVMe protocol I/O begins.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: one call moved past the userspace-like handshake.
- Minimal; no API/data-structure change.
- Regression risk is low. `sock_allow_reclassification()` only requires
  the socket not to be user-owned or slocked; `nvme_tcp_start_tls()`
  waits for handshake completion before returning. Failed TLS goes to
  `err_init_connect` without reclassify, which is fine because the
  socket is being torn down. Reviewers accepted this; blktests
  `nvme/062` was reported to pass.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Reclassify call introduced by `841aee4d75f1` (Chris Leech, 2022-02-15;
  in this tree, first appeared around 5.18).
- TLS handshake call introduced by `be8e82caa6859` (Hannes Reinecke,
  2023-08-24; `v6.7-rc1`).
- The lockdep WARN exists from TLS introduction onward whenever
  reclassify happens first.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Referenced commits:
- `841aee4d75f1`: **is** an ancestor of this tree.
- `19bdb70c77d3`: **is not** an ancestor of HEAD or of `v6.18` (dated
  2026-06-04, contained around 7.x). The “hiding” commit never landed
  here, so the TLS lockdep WARN was never suppressed in 6.18.y.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: This is **patch 2/2** of Shin'ichiro Kawasaki’s series “nvme-
tcp: do not use dynamic lockdep key for socket instances”:
1. Revert `19bdb70c77d3`
2. This delay of reclassify

Patch 1 is a no-op for this tree (nothing to revert). This delay patch
is standalone on 6.18.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Authored by Eric Dumazet (networking/lockdep); submitted by
Shin'ichiro Kawasaki; applied by Keith Busch. Cover letter: tested on
v7.3-rc2, `nvme/005` and `nvme/062` pass with no lockdep splat.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Revert of `19bdb70c77d3`: **not needed** here.
- Cover letter also cites `0ba6912f7e97` (“Revert once: don't use a work
  queue…”) to cut a **different** chain (`sk_lock → cpu_hotplug_lock`)
  for `nvme/005`. That commit is **not** in this tree, and it is **not**
  a prerequisite of this TLS reclassify move.
- `nvme_tcp_reclassify_socket()`, `nvme_tcp_start_tls()`, and the
  alloc_queue control flow all exist in `v6.18` with the same ordering
  the patch expects.

Can this apply standalone? **Yes.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 447a7a3026eda85ac2738cbe6ee5ab066a39dad0` → https://patch.m
  sgid.link/20260914074853.3990397-3-
  shinichiro.kawasaki@opensource.wdc.com
- Cover: https://patch.msgid.link/20260914074853.3990397-1-
  shinichiro.kawasaki@opensource.wdc.com
- Single revision (v1 of a 2-patch series). Direct lore.kernel.org fetch
  returned 403; full thread was retrieved via `b4 dig -m`.
- No NAKs. Keith Busch: “Thanks, applied to nvme-7.3.”
- No reviewer `Cc: stable` suggestion found in the thread.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): linux-nvme, Keith Busch, Jens Axboe, Christoph
Hellwig, Sagi Grimberg, Eric Dumazet, Nilay Shroff. Nilay: “Looks good
to me.” / `Reviewed-by`. Eric reviewed the companion revert.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: Observed in blktests `nvme/062` (NVMe-TCP TLS). The Link tag is
Eric’s report of the *dynamic key* lifetime WARN that motivated the
revert; this delay patch is the follow-up so that revert does not re-
expose the TLS class-mixing splat. Severity: lockdep warning, not a
reported production hang.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Companion revert is irrelevant to 6.18. A side discussion about
keeping per-queue dynamic keys was dropped; Eric argued static “kernel
vs user” classes are sufficient and per-instance keys hide real AB/BA
bugs. That does not affect this delay patch.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: Web search of lore.kernel.org/stable for this subject did not
turn up a prior stable discussion or an explicit rejection.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `nvme_tcp_alloc_queue()` (call moved); helper
`nvme_tcp_reclassify_socket()` unchanged; handshake still in
`nvme_tcp_start_tls()`.

**Step 5.2: TRACE CALLERS**
Record: `nvme_tcp_alloc_queue()` is called from
`nvme_tcp_alloc_admin_queue()` and `__nvme_tcp_alloc_io_queues()` during
controller setup. Userspace trigger: connecting an NVMe/TCP controller
(`nvme-cli` / nvmf), including TLS PSK when `CONFIG_NVME_TCP_TLS` is
enabled.

**Step 5.3: TRACE CALLEES**
Record: `nvme_tcp_start_tls()` → `tls_client_hello_psk()` + wait for
`tlshd`. Reclassify → `sock_lock_init_class_and_name()` only under
`CONFIG_DEBUG_LOCK_ALLOC`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable from normal NVMe/TCP connect. The lockdep splat needs
lockdep + TLS + `tlshd`. Without lockdep the moved function is an empty
stub in this tree (`static void nvme_tcp_reclassify_socket(struct socket
*sock) { }` in the `#else` of `CONFIG_DEBUG_LOCK_ALLOC`).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same reclassify pattern exists in sunrpc (`xprtsock.c`,
`svcsock.c`), SMB client, Bluetooth. Those also guard with
`sock_allow_reclassification()`. This is the established in-kernel
socket isolation approach.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** On `v6.18`:

```
1801: nvme_tcp_reclassify_socket(queue->sock);   /* immediately after
create */
1885: ret = nvme_tcp_start_tls(...);             /* later */
1890: ret = nvme_tcp_init_connection(queue);
```

TLS (`be8e82caa6859`) and static reclassify (`841aee4d75f1`) are both in
6.18. Dynamic keys (`19bdb70c77d3`) are not, so the TLS lockdep WARN is
live here, not hypothetical.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. The hunk is a single function-call move around
`nvme_tcp_start_tls()` / `nvme_tcp_init_connection()`, which have the
same shape in `v6.18`. Later `sockaddr_unsized` / `__fput_sync` churn
does not touch this call.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No equivalent delay of reclassify in 6.18 history. No other TLS
lockdep isolation fix on this path.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: NVMe over Fabrics TCP host (`drivers/nvme/host/tcp.c`).
**IMPORTANT** for NVMe/TCP users; not core mm/VFS. TLS is
`CONFIG_NVME_TCP_TLS` (“If unsure, say N”).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained (TLS, digest, security, reconnect). This is
a targeted lockdep fix, not a refactor of new 7.3 infrastructure.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: NVMe/TCP users with `CONFIG_NVME_TCP_TLS` **and**
`CONFIG_DEBUG_LOCK_ALLOC`/`LOCKDEP`, during TLS connect (`tlshd`).
Production configs without lockdep: no functional change (stub
function).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Controller connect with TLS PSK, lockdep enabled. Reproduced by
blktests `nvme/062`. Not an unprivileged syscall smash; it is a
privileged NVMe fabrics connect path. Timing: every TLS queue setup, not
a rare race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: lockdep circular-dependency **WARNING** (kernel tainted `W`).
Discussion treats it as class mixing (false cycle from `tlshd` vs in-
kernel NVMe), not a confirmed production deadlock. The same isolation
hole has existed since TLS landed in 6.7; no production hang report was
found for this chain. Severity: **MEDIUM** for debug/CI kernels, **LOW**
for production 6.18 users.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: restores the `841aee4d75f1` kernel-vs-user isolation for TLS;
  silences a real blktests splat; keeps lockdep usable on NVMe/TCP+TLS.
- Risk: very low (3-line move, no-op without lockdep, reviewed, tested).
- Ratio: favorable. The “important issue” bar is the only weak point,
  not correctness or applyability.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Buggy ordering exists in this 6.18 tree (reclassify before TLS).
- Tiny, obviously correct, reviewed by Nilay Shroff, applied by Keith
  Busch, idea from Eric Dumazet.
- Tested (blktests `nvme/062`).
- Applies cleanly; no missing helpers or struct changes.
- Companion revert is **not** required here because `19bdb70c77d3` never
  landed.
- Zero production behavioral change without lockdep.
- Same class of fix as the existing `841aee4d75f1` annotation; TLS had
  re-broken that isolation.

AGAINST:
- Debug-only (`nvme_tcp_reclassify_socket()` is empty without
  `CONFIG_DEBUG_LOCK_ALLOC`).
- Not a reported oops, hang, corruption, or CVE.
- Needs optional TLS + `tlshd` + lockdep to fire.
- Written as patch 2/2 of a 7.3 series whose other half does not apply
  here (that is not a blocker; it just explains origin).

UNRESOLVED:
- Direct lore.kernel.org HTTP fetch returned 403; thread content was
  still verified via `b4 dig -m`.
- No stable-list nomination/rejection found.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** (3-line move; Reviewed-by;
   blktests `nvme/062`)
2. Fixes a real bug that affects users? **PASS** (reproducible lockdep
   WARN on NVMe/TCP TLS connect; bothers debug/CI users)
3. Important issue? **PASS** (weak but acceptable: lockdep splat / “oh,
   that's not good”; restores lock-class isolation that this tree
   already relies on)
4. Small and contained? **PASS** (3 lines, one function)
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** (`v6.18` has the same call
   sites)

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary small
bugfix.

**Step 9.4: MAKE YOUR DECISION**
Backport. The defect is in this tree, the patch is self-contained
without the 7.3 revert, and the risk is negligible. Leaving early
reclassify in place keeps a known lockdep isolation hole in NVMe/TCP TLS
on 6.18.y.

---

### What the commit solves for this tree
On 6.18, nvme-tcp still reclassifies sockets immediately after create,
then may run a TLS handshake via `tlshd`. That puts userspace handshake
locking into the NVME socket class and produces a lockdep circular-
dependency warning (blktests `nvme/062`). Moving reclassify to after
handshake (and after connect when TLS is off) cuts that dependency.
Production kernels without lockdep do not change behavior.

### Stable rules / risk
Meets the written rules: small, obviously correct, tested, no new API,
applies here. Benefit is debug/CI lockdep correctness; regression risk
is essentially zero.

### Concerns
Do not pull in the companion revert of `19bdb70c77d3` (absent here). Do
not treat `0ba6912f7e97` as a dependency of this patch; that is a
separate `nvme/005` lock chain.

---

Verification:
- [Phase 1] Parsed tags: Link to Eric’s lore report; Reviewed-by Nilay
  Shroff; SOBs Eric Dumazet, Shin'ichiro Kawasaki, Keith Busch; no
  Fixes/Cc:stable
- [Phase 2] Diff: move `nvme_tcp_reclassify_socket()` in
  `nvme_tcp_alloc_queue()` from after `sk_net_refcnt_upgrade` to after
  optional `nvme_tcp_start_tls()`, +2/-1
- [Phase 2] Confirmed `#else` stub: function is empty without
  `CONFIG_DEBUG_LOCK_ALLOC` in this tree
- [Phase 3] `git describe HEAD` / Makefile: 6.18.57
- [Phase 3] `git merge-base --is-ancestor 841aee4d75f1 HEAD`: YES
  (reclassify present)
- [Phase 3] `git merge-base --is-ancestor be8e82caa6859 HEAD`: YES (TLS
  present)
- [Phase 3] `git merge-base --is-ancestor 19bdb70c77d3 HEAD`: NO
  (hiding/dynamic-key commit not in 6.18)
- [Phase 3] `git grep` on `v6.18:drivers/nvme/host/tcp.c`: reclassify at
  line 1801, TLS at 1885 — buggy order confirmed
- [Phase 3] `git blame v6.18 -- drivers/nvme/host/tcp.c`: reclassify =
  `841aee4d75f1`, TLS = `be8e82caa6859`
- [Phase 3] `git merge-base --is-ancestor 0ba6912f7e97 HEAD`: NO; not
  required for this hunk
- [Phase 4] `b4 dig -c 447a7a3026…`: patch 2/2, msgid
  `20260914074853.3990397-3-…`
- [Phase 4] `b4 dig -a`: v1 series only (cover + revert + this patch)
- [Phase 4] `b4 dig -w`: linux-nvme +
  Busch/Axboe/Hellwig/Grimberg/Dumazet/Shroff
- [Phase 4] mbox: Nilay Reviewed-by; Keith applied to nvme-7.3; no NAK;
  no Cc:stable
- [Phase 4] lore.kernel.org WebFetch: 403; used b4 mbox instead
- [Phase 4] stable list search: no prior discussion found
- [Phase 5] Callers: `nvme_tcp_alloc_admin_queue`,
  `__nvme_tcp_alloc_io_queues` (controller setup)
- [Phase 5] `sock_allow_reclassification()`: `!sock_owned_by_user &&
  !spin_is_locked(slock)`
- [Phase 6] Apply: same surrounding symbols in v6.18; expected clean
- [Phase 8] Failure mode: lockdep WARNING on TLS connect, not a verified
  production deadlock
- UNVERIFIED: whether any distro 6.18 debug kernel has a live user
  report of this splat (commit cites blktests, not a distro bugzilla)

The patch is small, the buggy ordering is in this 6.18 tree, and it does
not need the later revert series to be useful.

**YES**

 drivers/nvme/host/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 1f26e35d7a99e..9f15feff66132 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1859,7 +1859,6 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid,
 	}
 
 	sk_net_refcnt_upgrade(queue->sock->sk);
-	nvme_tcp_reclassify_socket(queue->sock);
 
 	/* Single syn retry */
 	tcp_sock_set_syncnt(queue->sock->sk, 1);
@@ -1948,6 +1947,8 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid,
 			goto err_init_connect;
 	}
 
+	nvme_tcp_reclassify_socket(queue->sock);
+
 	ret = nvme_tcp_init_connection(queue);
 	if (ret)
 		goto err_init_connect;
-- 
2.53.0

