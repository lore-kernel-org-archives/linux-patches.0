Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550874C8FFE;
	Mon, 31 Aug 2026 13:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183545; cv=none; b=tjagbpSLOHuG4vNX8VS+f2IHa8bf9kCtIaW2srxjGOjP9YtbY/3mEzhbpz4NvZ3CmylHBgw33bxNC40ue7jYHdz4rxapn3x5sTcLlMjaYH57qezQbB41oc5ncolVnJ7cx+4GEv3lluvZ3J8z3kqD39Qau1YMvewW2ydbjV9JCQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183545; c=relaxed/simple;
	bh=hDn+MG3zaJ3Ev1VDEUwORPgunUXPp1iLvQLKPQjrZfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ky/wtTdcfS+59C3caDWBCHsusmOsPYH82vKJ/Lsx1auiw0TRhAwdeoYaDHii4wQaHLqKiNbtEtUwZG/oJ/Q4e+7N611hIClISJAgZepW/zkFJB+phtsQlbSfVaw6v2SeQKb4tnwAlEp2oOrXxGICwrHCaVX899EkCBJUYZZ5Q9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTHIYoo3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTHIYoo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C196B1F00A3E;
	Mon, 31 Aug 2026 13:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183543;
	bh=laq2hpFbfluEc0ZX6BuNQjKzw/dl/BtfV7yElBYugd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTHIYoo3q/iS768Py59zGnDdzD3eyuGPbLIWlNVVfX0lq+Tk92oBUvdx7G47+d5Y3
	 76YZFoHVlYeDwcoK6CBiSz4QdK8FODQB+GmaKUT12+Dq/nXgwBgSbVUXWFe7pO1/iK
	 Kf2dtiyrzs4NT1XFiUWNvkdHEAiFotiXKjnWTGe2fqr612b7U9r2WjerhbndwrA0F8
	 5LVEP37NjTAlwGJVPAQBbtW8G0jJzqYBCppSYIWtm/YhAnow2CIzho2kTc0XujuDY1
	 CsEdFBazW36JGKwIAS+Abb6lH0JgkVUm5XMGwdiB2goPz1GLLjPG6/RGj1hJxzISsk
	 7gIxXnKkhSCYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Hannes Reinecke <hare@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	john.fastabend@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] tls: Flush backlog before waiting for a new record
Date: Mon, 31 Aug 2026 09:23:07 -0400
Message-ID: <20260831133314.4125787-159-sashal@kernel.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit edcf32b8a48f5882b5b7a91b21c89d233d4aecf2 ]

While lock_sock is held, incoming TCP segments land on
sk->sk_backlog rather than sk->sk_receive_queue.
tls_rx_rec_wait() inspects only sk_receive_queue, so backlog
data remains invisible. For non-blocking callers (read_sock,
and recvmsg or splice_read with MSG_DONTWAIT) this causes a
spurious -EAGAIN. For blocking callers it forces an
unnecessary sleep/wakeup cycle.

Flush the backlog inside tls_rx_rec_wait() before checking
sk_receive_queue so the strparser can parse newly-arrived
segments immediately. On the next loop iteration
tls_read_flush_backlog() may redundantly flush, but this
path is cold and the cost is negligible.

Backlog processing can run tcp_reset(), which calls
tcp_done_with_error() to set sk->sk_err = ECONNRESET and then
tcp_done() to set sk->sk_shutdown = SHUTDOWN_MASK. The pre-existing
top-of-loop sk_err check already ran before the flush, so the
freshly-set error would be masked by the next-line sk_shutdown test
returning 0 (EOF). Re-check sk_err immediately before the sk_shutdown
test so a connection abort surfaces as -ECONNRESET rather than a clean
EOF.

Commit f508262ae9f2 ("tls: Preserve sk_err across recvmsg() when
data has been copied") gave the top-of-loop sk_err check a
has_copied split. The recheck applies the same handling: when the
caller has already copied bytes, sk_err is reported but preserved
so the error surfaces on the next call; otherwise sock_error()
consumes it so the error is reported exactly once.

Suggested-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/netdev/ahgHgQ84RCc8uYrG@krikkit/
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20260604-tls-read-sock-v12-6-b114efa6e3e2@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `tls: Flush backlog before waiting for a new
record`

**Local tree:** v6.18.44 (`make kernelversion` → 6.18.44)
**Commit analyzed:** `edcf32b8a48f5` (on `master`, **not** in this
checkout)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[tls]` `[flush]` — Flush socket backlog inside
`tls_rx_rec_wait()` before inspecting `sk_receive_queue` and before
sleeping.

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Suggested-by | Sabrina Dubroca \<sd@queasysnail.net\> |
| Link | https://lore.kernel.org/netdev/ahgHgQ84RCc8uYrG@krikkit/ |
| Reviewed-by | Hannes Reinecke \<hare@suse.de\> |
| Reviewed-by | Sabrina Dubroca \<sd@queasysnail.net\> |
| Link | https://patch.msgid.link/20260604-tls-read-
sock-v12-6-b114efa6e3e2@oracle.com |
| Signed-off-by | Chuck Lever, Jakub Kicinski |

No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or syzbot
tags. Two subsystem reviewers reviewed it. No syzbot signal.

### Step 1.3: Body Analysis
**Record:**
- **Bug 1:** While `lock_sock` is held, TCP segments land on
  `sk->sk_backlog`, but `tls_rx_rec_wait()` only checks
  `sk->sk_receive_queue`. Backlog data is invisible → spurious `-EAGAIN`
  for non-blocking callers (`read_sock`, `MSG_DONTWAIT` recvmsg/splice);
  unnecessary sleep/wakeup for blocking callers.
- **Bug 2:** `sk_flush_backlog()` can invoke `tcp_reset()` → sets
  `sk_err` then `sk_shutdown`. Top-of-loop `sk_err` check already ran;
  `sk_shutdown` test returns 0 (EOF) → connection abort surfaces as
  clean EOF instead of `-ECONNRESET`.
- **Root cause:** Missing backlog flush before receive-queue inspection;
  missing post-flush `sk_err` recheck.
- **Dependency cited:** `f508262ae9f2` / local `81c8a9f75a426`
  (`has_copied` split for `sk_err` handling).

### Step 1.4: Hidden Bug Fix?
**Record:** No — explicitly described as a correctness bug (wrong return
codes, masked connection errors).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `net/tls/tls_sw.c` (+12 lines)
- **Function:** `tls_rx_rec_wait()` only
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| Backlog flush | Only `tls_read_flush_backlog()` during record
processing (periodic, ≥128KB) | `sk_flush_backlog(sk)` each wait-loop
iteration before receive-queue check |
| Error handling | Single top-of-loop `sk_err` check | Duplicate
`sk_err` check after backlog flush, same `has_copied` logic as top-of-
loop |

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic / correctness (error-path handling + backlog
  visibility)
- **Mechanism:** Socket lock held → segments queued on backlog → wait
  loop sees empty receive queue → premature `-EAGAIN` or sleep. Backlog
  flush can set `sk_err`+`sk_shutdown` between the two existing checks,
  masking reset as EOF.

### Step 2.4: Fix Quality
**Record:** Obviously correct — mirrors existing `sk_err` handling and
uses established `sk_flush_backlog()` API already used by
`tls_read_flush_backlog()`. Minimal regression risk; redundant flush on
next iteration is acknowledged as negligible on a cold path.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Wait-loop receive-queue check dates to 2020
(`20ffc7adf53a5f`). `has_copied`/`sk_err` split added by `81c8a9f75a426`
(May 2026, **in tree**). Buggy pattern (no backlog flush in wait loop)
present since `tls_rx_rec_wait()` was written; exacerbated by
`read_sock` (2023, **in tree**) which always passes `nonblock=true`.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag. Referenced commit `81c8a9f75a426` is
an ancestor of HEAD.

### Step 3.3: Related File History
**Record:** Recent TLS fixes in this tree include `81c8a9f75a426` (same
`sk_err`/EOF class), `e8a4c9fc437b1` (read_sock empty records). v12
series patches 1–5 (`4da7925c124a3` … `22f8bf8808dc8`) are **not** in
tree; this is patch 6/6 but is functionally standalone (only touches
`tls_rx_rec_wait()`).

### Step 3.4: Author Context
**Record:** Chuck Lever is a primary kTLS maintainer. Multiple TLS
receive-path fixes in this tree from him (`81c8a9f75a426`,
`9f557c7eae127`, etc.).

### Step 3.5: Dependencies
**Record:**
- `sk_flush_backlog()` — present in `include/net/sock.h` (since 2022,
  `c46b01839f7aa` era)
- `has_copied` parameter — present (`81c8a9f75a426`)
- `tls_read_flush_backlog()` — present (`c46b01839f7aa`)
- **Standalone:** No dependency on other v12 patches; applies with
  trivial context adjustment (`tls_strp_check_rcv(&ctx->strp)` vs
  mainline's two-argument form)

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig -c edcf32b8a48f5` →
https://patch.msgid.link/20260604-tls-read-
sock-v12-6-b114efa6e3e2@oracle.com. Part of v12 series (v4→v12
revisions). Sabrina Dubroca reviewed and thanked author. No explicit
stable nomination found in thread.

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: CC'd Jakub Kicinski, netdev, kernel-tls-
handshake, Eric Dumazet, Paolo Abeni, Hannes Reinecke. Reviewed-by from
Hannes Reinecke and Sabrina Dubroca.

### Step 4.3: Bug Report
**Record:** `Suggested-by: Sabrina Dubroca`; original thread at lore
link (fetch blocked by Anubis). No syzbot/bugzilla. Subsystem expert
identified the issue.

### Step 4.4: Series Context
**Record:** v12 0/6 "receive-path fixes and clean-ups"; patches 1–5 are
separate read_sock/decrypt fixes not in this tree. Patch 6/6 is
independent.

### Step 4.5: Stable List History
**Record:** No stable-list discussion found in mbox grep.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `tls_rx_rec_wait()` modified.

### Step 5.2: Callers
**Record:** Three call sites in `net/tls/tls_sw.c`:
- `tls_sw_recvmsg()` — line 2124 (`MSG_DONTWAIT` aware)
- `tls_sw_splice_read()` — line 2311 (`SPLICE_F_NONBLOCK` aware)
- `tls_sw_read_sock()` — line 2398 (always `nonblock=true`)

All are kTLS software receive paths reachable from userspace or in-
kernel consumers (sockmap, etc.).

### Step 5.3: Callees
**Record:** `sk_flush_backlog()` → `__sk_flush_backlog()` →
`__release_sock()` (moves backlog to receive queue, can run
`tcp_reset()`). `sock_error()`, `sk_wait_event()`,
`tls_strp_check_rcv()`.

### Step 5.4: Reachability
**Record:** Reachable from `recvmsg()`/`splice()`/`read()` on TLS
sockets and kernel `read_sock` consumers. Unprivileged users with TLS
sockets can trigger. `CONFIG_TLS` required.

### Step 5.5: Similar Patterns
**Record:** `tls_read_flush_backlog()` already calls
`sk_flush_backlog()` during record processing but only after ≥128KB
(`c46b01839f7aa`). Wait loop had no flush — gap this patch closes.
`81c8a9f75a426` already fixed analogous `sk_err`/EOF masking for
periodic flush path.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Current `tls_rx_rec_wait()` at lines 1407–1414
checks `sk_receive_queue` without prior `sk_flush_backlog()`. No post-
flush `sk_err` recheck. Commit `edcf32b8a48f5` is **not** an ancestor of
HEAD.

### Step 6.2: Backport Complications
**Record:** `git apply --check` fails on comment/context around
`tls_strp_check_rcv(&ctx->strp, false)` vs local
`tls_strp_check_rcv(&ctx->strp)`. **Minor adjustment needed** —
functional change is independent of that difference.

### Step 6.3: Related Fixes Already Present?
**Record:** `81c8a9f75a426` (preserve `sk_err` / `has_copied`) is in
tree but does **not** cover the wait-loop backlog-flush path this commit
adds. No duplicate fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `net/tls` — kTLS software receive path. **Criticality:
IMPORTANT** (production TLS workloads; growing kTLS adoption).

### Step 7.2: Activity
**Record:** Active — multiple TLS fixes in recent stable history
(`81c8a9f75a426`, `e8a4c9fc437b1`, UAF/off-by-one fixes).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** kTLS users (`CONFIG_TLS`): applications using kernel TLS
recvmsg/splice, and in-kernel `read_sock` consumers. Not universal, but
significant in data-center/edge deployments.

### Step 8.2: Trigger Conditions
**Record:** Data arrives on `sk_backlog` while socket lock held during
`tls_rx_rec_wait()`. Common during active TLS reads. Non-blocking paths
(`read_sock`, `MSG_DONTWAIT`) hit spurious `-EAGAIN` deterministically
when backlog has data but receive queue is empty. Connection reset
during backlog flush triggers EOF masking.

### Step 8.3: Failure Mode Severity
**Record:**
- Spurious `-EAGAIN` → **MEDIUM** (functional failure; apps may
  drop/retry incorrectly; `read_sock` always non-blocking)
- `ECONNRESET` masked as EOF → **MEDIUM-HIGH** (wrong semantics; same
  class as `81c8a9f75a426` which was backported)
- Not crash/UAF/corruption/deadlock

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** MEDIUM-HIGH — fixes real kTLS correctness bugs; completes
  error-handling started by `81c8a9f75a426`
- **Risk:** LOW — 12 lines, reviewed, uses existing API, mirrors
  existing `sk_err` pattern
- **Ratio:** Favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR:**
- Fixes two real, reproducible correctness bugs in kTLS receive
- Small (12 lines), surgical, dual-reviewed by subsystem experts
- Prerequisites (`has_copied`, `sk_flush_backlog`) all in v6.18.44
- Companion to `81c8a9f75a426` already in this stable tree (same EOF-
  masking class)
- Affects production paths: `recvmsg`, `splice_read`, `read_sock`
- Applies with trivial context adjustment

**AGAINST:**
- Not crash/security/corruption/deadlock
- No syzbot or explicit end-user bug report
- Borderline on stable rule "important issue"
- Rest of v12 series not in tree (but this patch is standalone)

**UNRESOLVED:** Original Sabrina Dubroca bug-report thread content (lore
blocked by Anubis).

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — reviewed by two
subsystem experts; logic mirrors existing `sk_err` handling |
| 2. Fixes real bug affecting users? | **PASS** — spurious EAGAIN +
masked ECONNRESET on kTLS paths |
| 3. Important issue? | **PASS** — wrong error semantics on active TLS
connections; same severity class as already-backported `81c8a9f75a426` |
| 4. Small and contained? | **PASS** — 12 lines, one function |
| 5. No new features/APIs? | **PASS** — behavior correction only |
| 6. Can apply to local tree? | **PASS** — minor context tweak for
`tls_strp_check_rcv` signature |

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs).

### Step 9.4: Decision Rationale

This tree already carries `81c8a9f75a426`, which fixes `sk_err` being
masked as EOF when `tls_read_flush_backlog()` triggers `tcp_reset()`.
The analyzed commit closes the parallel hole in `tls_rx_rec_wait()` —
the wait loop never flushed backlog before checking the receive queue,
and a post-flush `sk_err` recheck was missing. Without it, kTLS non-
blocking reads (`read_sock`, `MSG_DONTWAIT`) can spuriously return
`-EAGAIN` despite available data, and connection resets during wait can
still appear as clean EOF.

The fix is minimal, self-contained, prerequisite-complete in v6.18.44,
and addresses the same error-reporting correctness class already deemed
stable-worthy in this tree.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from `git show
  edcf32b8a48f5`
- **[Phase 2]** Diff analysis: +12 lines in `tls_rx_rec_wait()`, two
  hunks (flush + sk_err recheck)
- **[Phase 3]** `git describe HEAD` → v6.18.44; `git merge-base --is-
  ancestor` → `edcf32` NOT in tree; `81c8a9`, `c46b018`, `662fbcec` IN
  tree
- **[Phase 3]** `git blame -L 1394,1435 net/tls/tls_sw.c` → receive-
  queue-only check since 2020; `has_copied` from `81c8a9f75a426`
- **[Phase 3]** v12 series commits 1–5 all NOT in tree; patch 6/6 is
  standalone
- **[Phase 4]** `b4 dig -c edcf32b8a48f5` → lore URL found; `b4 dig -a`
  → v4–v12 revisions; `b4 dig -w` → maintainers CC'd
- **[Phase 4]** `b4 dig -m /tmp/tls_flush_thread.mbox` → Reviewed-by
  Sabrina Dubroca, Hannes Reinecke; no stable nomination
- **[Phase 4]** WebFetch lore URL → blocked (Anubis); UNVERIFIED
  original bug-report content
- **[Phase 5]** `grep tls_rx_rec_wait` → 3 call sites (recvmsg,
  splice_read, read_sock)
- **[Phase 5]** `include/net/sock.h:1218` → `sk_flush_backlog()` inline
  confirmed
- **[Phase 6]** Read current `tls_rx_rec_wait()` at lines 1379–1441 —
  missing fix
- **[Phase 6]** `git apply --check` → fails on `tls_strp_check_rcv`
  context; functional change still applicable
- **[Phase 7]** `git log --oneline -20 -- net/tls/` → active subsystem
  with recent stable fixes
- **[Phase 8]** `tls_sw_read_sock()` line 2398 always passes
  `nonblock=true` — verified spurious EAGAIN path

**YES**

 net/tls/tls_sw.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index f19b504efa5d0..23872d7e32567 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1404,12 +1404,24 @@ tls_rx_rec_wait(struct sock *sk, struct sk_psock *psock, bool nonblock,
 		if (ret < 0)
 			return ret;
 
+		if (sk_flush_backlog(sk))
+			released = true;
 		if (!skb_queue_empty(&sk->sk_receive_queue)) {
 			tls_strp_check_rcv(&ctx->strp);
 			if (tls_strp_msg_ready(ctx))
 				break;
 		}
 
+		/* sk_flush_backlog() can run tcp_reset(), which sets
+		 * sk_err and then sk_shutdown via tcp_done(). Recheck
+		 * sk_err here so a connection abort surfaces as the
+		 * actual error rather than a clean EOF.
+		 */
+		if (sk->sk_err) {
+			if (has_copied)
+				return -READ_ONCE(sk->sk_err);
+			return sock_error(sk);
+		}
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
 			return 0;
 
-- 
2.53.0

