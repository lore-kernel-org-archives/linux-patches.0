Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9703AD51A;
	Mon, 20 Apr 2026 13:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690996; cv=none; b=j7wmm0Li/nyv6EZwh7Xg3EBR0TqkyimGNK5MwguXbaFGPDllphWgroPIl7WPK+wE6QX0vI2etJX7mVbeH2xeaDDSf4ZCYT/Opg/wwbT1fkL6NIfNAVOVLfvg879uONMPNCKAEgGG73xoleIho3orWLk/N0Geu9Eb0yT6Dd/fL1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690996; c=relaxed/simple;
	bh=g6eSYJ1kKTsnlDXoUs+hi4LXrpzGwhbtMCS740mFErQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r1xvrft+2wiR31XOzOmaafP27QmZN5Wb+t5s70tCx1dKr5J8ox3yPspwyyTHhp48Xv3EuJ8fYdqqnOdkjsfDXVwLgGn2huWXQVqa88Ebt3Z2UAhQvXnHlsm21mnkCRJTuX1uebQPlKnCJqGoDEh9MOpumV4RTkfs3Qn7JR6UVlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NOTKVnee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NOTKVnee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB99C2BCC4;
	Mon, 20 Apr 2026 13:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690996;
	bh=g6eSYJ1kKTsnlDXoUs+hi4LXrpzGwhbtMCS740mFErQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOTKVneetI0Zzlv/5rpEOE3iAOAwKvnT+b9/Pd2ZDrnOml2rzWJ56FT7tGNtfVWWl
	 vT3dfxPJ2eur7Xc6QLEADvJjj7IiP2Tog30QkGqaPwUauEjNNI39eZ9jAS1egVCqQa
	 ZoJHJb8xvOKwQPbhhJDyCYjD01PeOW3VTRU901Bw+9cUNwWHCGx63rxwhd5p0O+GvM
	 TG8eSh6twpD3UEvRZghLEvflqhgLZLesyAe0HxOn1hr63PG1P1TTTBiGhF3whWqZJs
	 0MkUpfgmViIb63AAp+ijd/Hrus63sNE27ieVYU+6FpvhRK3P6KRJruj3u6M0VOMPZ7
	 DC6Np3GyrNPjQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michal Luczaj <mhal@rbox.co>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Sasha Levin <sashal@kernel.org>,
	john.fastabend@gmail.com,
	jakub@cloudflare.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] bpf, sockmap: Annotate af_unix sock:: Sk_state data-races
Date: Mon, 20 Apr 2026 09:08:19 -0400
Message-ID: <20260420131539.986432-33-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
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

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit a25566084e391348385a72dd507e0cc0c268dd5d ]

sock_map_sk_state_allowed() and sock_map_redirect_allowed() read af_unix
socket sk_state locklessly.

Use READ_ONCE(). Note that for sock_map_redirect_allowed() change affects
not only af_unix, but all non-TCP sockets (UDP, af_vsock).

Suggested-by: Kuniyuki Iwashima <kuniyu@google.com>
Suggested-by: Martin KaFai Lau <martin.lau@linux.dev>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260414-unix-proto-update-null-ptr-deref-v4-1-2af6fe97918e@rbox.co
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough context. Let me compile my analysis.

## Phase 1: Commit Message Forensics

**Step 1.1 - Subject Line Parse:**
- Subsystem: `bpf, sockmap:`
- Action verb: "Annotate" (not "fix")
- Summary: Adds READ_ONCE() to two lockless reads of af_unix sk_state in
  sock_map.c

Record: bpf/sockmap subsystem, annotation (data race), adds READ_ONCE()
to sk_state reads

**Step 1.2 - Tags:**
- `Suggested-by: Kuniyuki Iwashima` (networking/af_unix expert)
- `Suggested-by: Martin KaFai Lau` (BPF maintainer)
- `Signed-off-by: Michal Luczaj` (original author)
- `Signed-off-by: Martin KaFai Lau` (maintainer applied)
- `Reviewed-by: Jiayuan Chen`
- `Reviewed-by: Kuniyuki Iwashima`
- `Link:` to v4 on patch.msgid.link
- **No** Fixes: tag
- **No** Cc: stable
- **No** syzbot/KCSAN report

Record: Strong review endorsement (both suggesters are reviewers); no
Fixes:/stable tags; no concrete bug report cited.

**Step 1.3 - Body Text:**
The commit explicitly acknowledges that `sock_map_sk_state_allowed()`
and `sock_map_redirect_allowed()` read sk_state "locklessly". Change
uses READ_ONCE(). Notes the redirect_allowed change also affects UDP and
af_vsock. No crash/panic/reproducer described in body — it's purely a
data race annotation.

Record: Describes data race (paired writer uses WRITE_ONCE); no user-
visible symptom documented.

**Step 1.4 - Hidden fix?**
"Annotate data-races" is standard kernel terminology for adding
READ_ONCE/WRITE_ONCE pairings. This is a recognized synchronization bug
fix pattern per KCSAN/C11 memory model, even without a concrete crash.

## Phase 2: Diff Analysis

**Step 2.1 - Inventory:** Single file `net/core/sock_map.c`, 2 lines
changed (2 insertions, 2 deletions). Two functions modified:
`sock_map_redirect_allowed()` and `sock_map_sk_state_allowed()`. Minimal
surgical scope.

**Step 2.2 - Code flow:** Before/after behavior is identical modulo
compiler: READ_ONCE prevents load tearing/reordering/fusion by the
compiler for lockless reads.

**Step 2.3 - Bug mechanism:** Category (b) Synchronization. This is a
completion of a WRITE_ONCE/READ_ONCE pair: writer side at
`net/unix/af_unix.c:1775` uses `WRITE_ONCE(sk->sk_state,
TCP_ESTABLISHED)` in `unix_stream_connect()`, but sock_map.c readers
were plain reads — a data race per kernel/C11 rules.

**Step 2.4 - Fix quality:** Obviously correct. Zero regression risk —
READ_ONCE is a compiler barrier with no runtime cost on aligned reads.

## Phase 3: Git History

**Step 3.1 - Blame:** The affected lines originated from:
- `sock_map_redirect_allowed`: commit `122e6c79efe1c2` (Cong Wang, 2021)
- `sock_map_sk_state_allowed` af_unix branch: commit `8d6650646ce49e`
  (John Fastabend, Dec 2023 - fixing syzkaller null ptr deref in
  unix_bpf)

The af_unix branch of sock_map_sk_state_allowed was added in v6.8 (Dec
2023).

**Step 3.2 - Fixes tag:** No Fixes: tag on this patch. The series' patch
5/5 has `Fixes: c63829182c37 ("af_unix: Implement
->psock_update_sk_prot()")` — the null-ptr-deref is fixed there, not
here.

**Step 3.3 - File history:** Recent active development on sock_map.c.
This is patch 1/5 of a series fixing a null-ptr-deref that crashes via
`unix_stream_bpf_update_proto+0xa0`. Patch 5/5 is the actual crash fix.

**Step 3.4 - Author's role:** Michal Luczaj is an active vsock/unix
contributor. Martin KaFai Lau (BPF maintainer) applied it. Kuniyuki
Iwashima is the af_unix expert.

**Step 3.5 - Dependencies:** This patch is independent of the rest of
the series — it touches separate code than patches 2-5. No dependencies.

## Phase 4: Mailing List Research

**Step 4.1 - Original submission:** Found v3 on lore/yhbt and v4
referenced in the commit (20260414-unix-proto-update-null-ptr-deref-v4).
Series: `[PATCH bpf v3 0/5] bpf, sockmap: Fix af_unix null-ptr-deref in
proto update`.

**Step 4.2 - Reviewers:** Networking maintainers (Paolo, Jakub,
Kuniyuki, Eric Dumazet), BPF maintainers (Martin, Alexei, Daniel),
af_unix expert Kuniyuki explicitly reviewed and ACKed this patch.

**Step 4.3 - Bug report:** The series is motivated by a NULL ptr deref
crash (shown in patch 5/5's commit message) but THIS specific patch has
no explicit crash reporter. Kuniyuki notes: "Actually TCP path also
needs READ_ONCE(), but I think it's okay for now since this series
focuses on AF_UNIX" — confirming this is the known-pattern data race
annotation.

**Step 4.4 - Series context:** This is 1/5 of a series:
1. (this one) READ_ONCE annotations
2. Refactor to sock_map_sk_{acquire,release}() helpers
3. Fix af_unix iter deadlock (has Fixes: tag)
4. Selftest
5. Adapt sockmap for af_unix locking (has Fixes: tag — the actual null-
   ptr-deref fix)

**Step 4.5 - Stable discussion:** No explicit stable nomination. Author
himself noted patch 5/5's locking would make this READ_ONCE redundant
for the af_unix path, but the patch was kept as a minimal standalone
hardening.

## Phase 5: Code Semantic Analysis

**Step 5.1 - Functions modified:** `sock_map_redirect_allowed()`,
`sock_map_sk_state_allowed()`

**Step 5.2 - Callers:**
- `sock_map_redirect_allowed()`: 4 callers — `bpf_sk_redirect_map`,
  `bpf_msg_redirect_map`, `bpf_sk_redirect_hash`,
  `bpf_msg_redirect_hash`. Called from BPF programs at runtime (hot
  path).
- `sock_map_sk_state_allowed()`: 2 callers in `sock_map_update_elem_sys`
  and `sock_map_update_elem` — invoked on BPF_MAP_UPDATE_ELEM syscall.

**Step 5.3 - Callees:** Just reads sk->sk_state and does bitmask
comparison.

**Step 5.4 - Reachability:** Reachable from userspace via bpf() syscall
(BPF_MAP_UPDATE_ELEM) and from BPF programs redirecting sockets —
CONFIRMED reachable.

**Step 5.5 - Similar patterns:** Found the same pattern in
`net/unix/diag.c` (commit `0aa3be7b3e1f8 "af_unix: Annotate data-races
around sk->sk_state in UNIX_DIAG"`) — had Fixes: tags and went to
**ALL** stable trees: 5.10, 5.15, 6.1, 6.6, 6.12, 6.17, 6.18. Strong
precedent.

## Phase 6: Cross-referencing Stable Trees

**Step 6.1 - Code in stable:**
- `sock_map_redirect_allowed()`: Present in ALL active stable trees
  (5.10, 5.15, 6.1, 6.6, 6.12, 6.17, 6.18)
- `sock_map_sk_state_allowed()` af_unix branch (hunk 2): Only in 6.6.y
  and newer (added in v6.8 by backport of 8d6650646ce49)

**Step 6.2 - Backport complications:** Hunk 1
(sock_map_redirect_allowed) applies to all trees. Hunk 2
(sock_map_sk_state_allowed af_unix branch) only applies to 6.6+ where
the af_unix branch exists. Minor adjustment for older trees (drop hunk
2). Clean for 6.6+.

**Step 6.3 - Related fixes in stable:** Precedent 0aa3be7b3e1f8 is in
ALL stable trees — shows the same type of annotation is routinely
accepted.

## Phase 7: Subsystem Context

**Step 7.1 - Subsystem:** `net/core/sock_map.c` = networking core + BPF.
IMPORTANT criticality (BPF sockmap used in user-space networking stacks
like Cilium).

**Step 7.2 - Activity:** Actively developed subsystem with recent bug
fixes.

## Phase 8: Impact Assessment

**Step 8.1 - Affected users:** BPF sockmap users on systems with af_unix
BPF usage, and any users with BPF programs using
sk_redirect/msg_redirect on non-TCP sockets.

**Step 8.2 - Trigger:** Concurrent BPF_MAP_UPDATE_ELEM on a socket
that's undergoing state change (e.g., unix_stream_connect). On most
archs with aligned int reads, load tearing is unlikely, but compiler
fusion/reordering is possible. KCSAN would flag this.

**Step 8.3 - Failure mode:** Without READ_ONCE alone, theoretical
compiler-induced mis-behavior (torn/fused reads of sk_state leading to
wrong state checks). The concrete null-ptr-deref described in the series
is NOT fixed by this patch alone — that's fixed by patch 5/5. Severity:
LOW-MEDIUM for this patch in isolation.

**Step 8.4 - Risk/benefit:**
- Risk: ~zero (READ_ONCE is a compiler barrier; no runtime change on
  aligned reads)
- Benefit: Completes WRITE_ONCE/READ_ONCE pair, silences KCSAN, hardens
  against compiler edge cases

## Phase 9: Final Synthesis

**Evidence FOR backporting:**
- Fixes a genuine data race (plain read paired with WRITE_ONCE on the
  writer)
- Very small, surgical, obviously correct (2 lines)
- Strong reviewer endorsement (Kuniyuki, Jiayuan, Martin)
- Strong precedent: `0aa3be7b3e1f8` (identical pattern) was accepted
  into ALL stable trees with Fixes: tags
- Zero regression risk

**Evidence AGAINST backporting:**
- No Fixes: tag on THIS specific patch
- No Cc: stable tag
- No concrete syzbot/KCSAN report cited
- By itself, does NOT fix the null-ptr-deref (that's patch 5/5)
- Author acknowledged patch 5/5's proper locking would make this
  redundant on af_unix path
- "Annotation only" — preventive rather than curative for the crash

**Stable Rules checklist:**
1. Obviously correct and tested? YES (trivial READ_ONCE; reviewed by
   multiple maintainers)
2. Fixes a real bug? YES (data race per C11/kernel rules) but not a
   user-visible crash alone
3. Important issue? MEDIUM (data race without concrete trigger)
4. Small and contained? YES (2 lines)
5. No new features/APIs? YES
6. Applies to stable? Mostly — hunk 2 needs 6.6+ but hunk 1 applies
   everywhere

**Decision analysis:** This is a borderline case. The patch itself is
pure annotation with no concrete user-visible crash fix in isolation.
However, the precedent (0aa3be7b3e1f8) strongly shows this annotation
pattern IS routinely accepted into stable, including down to 5.10.y. The
patch is 2 lines, zero-risk, and completes a real WRITE_ONCE/READ_ONCE
pair. The Kuniyuki review noting "TCP path also needs READ_ONCE()"
indicates this is a recognized pattern.

Given:
- The precedent of identical-pattern commits going to all stable trees
- Zero regression risk
- Real (if benign) data race being fixed
- Strong review from domain experts

## Verification

- [Phase 1] Parsed tags: no Fixes:, no Cc: stable, but strong Reviewed-
  by from networking maintainer Kuniyuki and BPF maintainer Martin KaFai
  Lau
- [Phase 2] Diff analysis: exactly 2 lines changed, adds READ_ONCE() to
  2 lockless sk_state reads
- [Phase 2] Verified writer pairs with WRITE_ONCE at
  net/unix/af_unix.c:1556, 1775 in unix_stream_connect
- [Phase 3] git blame: affected code introduced by 122e6c79efe1c2 (2021)
  and 8d6650646ce49e (Dec 2023, v6.8)
- [Phase 3] git show c63829182c37: confirmed Fixes: target from patch
  5/5 is from 2021 (widely in stable)
- [Phase 4] Found lore discussion on yhbt.net showing full series thread
- [Phase 4] Confirmed this is patch 1/5; real null-ptr-deref crash is
  fixed by patch 5/5
- [Phase 4] Kuniyuki review comment: "Actually TCP path also needs
  READ_ONCE()" — confirms this is an incremental fix of a broader race
  pattern
- [Phase 5] grep sock_map_redirect_allowed: 4 callers in sockmap BPF
  redirect hooks
- [Phase 5] grep sock_map_sk_state_allowed: 2 callers in
  BPF_MAP_UPDATE_ELEM paths
- [Phase 5] Found precedent commit 0aa3be7b3e1f8 ("af_unix: Annotate
  data-races around sk->sk_state in UNIX_DIAG") — same pattern
- [Phase 6] Verified code presence in stable trees: redirect_allowed
  exists in all; state_allowed af_unix branch only in 6.6+ (6.6, 6.12,
  6.17, 6.18 checked)
- [Phase 6] Confirmed precedent 0aa3be7b3e1f8 backported to
  linux-5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y, 6.17.y, 6.18.y — all
  active stable trees
- [Phase 8] Failure mode: data race (compiler-level), severity LOW-
  MEDIUM in isolation
- UNVERIFIED: Whether the v4 of the series has been applied to mainline
  (appears not yet, as I couldn't locate the commit SHA in local
  mainline snapshot — checked bpf-next and linus-next/master)
- UNVERIFIED: Whether the rest of the series (patches 2-5) will also go
  through autoselection

The patch is 2 lines of low-risk data race annotation with strong
precedent for acceptance into all active stable trees. While it doesn't
fix the null-ptr-deref in isolation (that's patch 5/5), it genuinely
completes a WRITE_ONCE/READ_ONCE pair and silences KCSAN. Stable
maintainers routinely accept these annotations, as evidenced by
`0aa3be7b3e1f8` being in every active stable tree including 5.10.y.

**YES**

 net/core/sock_map.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index b0e96337a2698..02a68be3002a2 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -530,7 +530,7 @@ static bool sock_map_redirect_allowed(const struct sock *sk)
 	if (sk_is_tcp(sk))
 		return sk->sk_state != TCP_LISTEN;
 	else
-		return sk->sk_state == TCP_ESTABLISHED;
+		return READ_ONCE(sk->sk_state) == TCP_ESTABLISHED;
 }
 
 static bool sock_map_sk_is_suitable(const struct sock *sk)
@@ -543,7 +543,7 @@ static bool sock_map_sk_state_allowed(const struct sock *sk)
 	if (sk_is_tcp(sk))
 		return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
 	if (sk_is_stream_unix(sk))
-		return (1 << sk->sk_state) & TCPF_ESTABLISHED;
+		return (1 << READ_ONCE(sk->sk_state)) & TCPF_ESTABLISHED;
 	if (sk_is_vsock(sk) &&
 	    (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET))
 		return (1 << sk->sk_state) & TCPF_ESTABLISHED;
-- 
2.53.0

