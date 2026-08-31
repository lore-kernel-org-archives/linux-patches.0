Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A4F5AD599;
	Mon, 31 Aug 2026 13:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184387; cv=none; b=mDz54/BegkArBvkROYs0sOgzVUn/VBZFxjmhfWUHm8IJmR1On2CxvFKLG+6E8YXzVInxHb1KGn3WeLBE1MlAb7anb5mlbQm8cZriuroXfRyUxaQ2P5/yIpkq+2xWQA7A+/mrU9a7RVZFwSMUXyRDAtGQYlrrWk9H4nhM7zY9T0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184387; c=relaxed/simple;
	bh=C6XQPvjgdxej9woOQ6YkQyNADp/CMc3NB3qpa9UOZ58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GPIjULjLgNyA+RtB+MX4XpQ9CDSIH8W7SMv4oGZKz2AlRq65YsO1t6iSX9UrHQeLvv0mESleadk3oSnD+Nz63Ija2fL0/JBBpRUgRWdPGrF0o3EWv1ywYvnp1Ze/PJ7X1i6ITZdvQhRdgXL1+b1DTPeZeZA99g88k5ErqFMu5sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JxyBfNju; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JxyBfNju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DB91F00A3D;
	Mon, 31 Aug 2026 13:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184385;
	bh=YffCrb4yA2dg2Rn7RGt7PWTJJWYA91dzHVs9EUJk3jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JxyBfNjuJuVy+0P8N+tbibRxX826BGkJ6EkZqaPvJvVjQmZcGosu678fPNJLzq9kb
	 XTWXER1bD0LfeJ0b7XdjZwEkF99GijxX+i0KJyKsrDwZwMRxk0TfmkGziOh/vfNK/8
	 SwfiGYIcsduyVCR1l4zf4aPjw8M3zdAFGEh5A+sO8Rru/nTbCvB2Uaa/khXVYDe0eY
	 hiQWUXd5Dc1/7u8aj9JI8Y6zoPyEdkPKNdxS9cRoem9l6ZLiWCHH5iDgYeapLFt/jO
	 Vxgppl3CLdCwBFziFjiHyYjweZvwTceialn3dYfr6kDfD2kXoUchYZozPdiqqNRcvg
	 Keq/5y06km6gQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	edumazet@google.com,
	kuniyu@google.com,
	pabeni@redhat.com,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: ensure SCM_TXTIME delivery time is no older than system boot
Date: Mon, 31 Aug 2026 09:31:30 -0400
Message-ID: <20260831133314.4125787-662-sashal@kernel.org>
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

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 73f1a618b064884410e7f772467a5f515d6751af ]

Limit input to sane values to avoid having to add tests later in the
kernel hot path, e.g., in FQ.

SCM_TXTIME timestamps are converted to signed ktime_t when assigned to
skb->tstamp. Avoid having negative values overflow into large positive
ones when again used as u64, e.g., in FQ time_to_send.

For CLOCK_MONOTONIC, only allow positive values.

For CLOCK_REALTIME and CLOCK_TAI, allow equivalent values, i.e., no
older than the boot of the machine.

skb->tstamp zero is a special case signaling feature off. This is not
converted between clockids.

Handle the special case where the realtime clock is set so small that
real - mono is negative, however unlikely in practice.

Ideally we would also set a sane upper bound, but that would require
reading the clock, which is an expensive operation. Continue to defer
that validation to users of the data. FQ already does this.

Bound rather than return error on older timestamps. This is the
existing policy e.g., in FQ.

Signed-off-by: Willem de Bruijn <willemb@google.com>

----

Changes
  v1 -> v2
    - remove spurious semicolon at end of switch
    - remove Fixes tag

Link: https://patch.msgid.link/20260604194221.3319080-2-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[net]` `[ensure]` — SCM_TXTIME delivery times must not be
older than system boot; clamp invalid timestamps at input.

### Step 1.2: Commit message tags
**Record:**
- **Signed-off-by:** Willem de Bruijn `<willemb@google.com>` (author)
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (netdev
  maintainer commit)
- **Link:** https://patch.msgid.link/20260604194221.3319080-2-
  willemdebruijn.kernel@gmail.com
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or
  Cc: stable@
- **Notable:** v1→v2 notes removed a spurious semicolon and **removed
  the Fixes: tag** (no tied regression commit in final form)

### Step 1.3: Body analysis
**Record:**
- **Bug:** SCM_TXTIME `u64` values become signed `ktime_t` in
  `skb->tstamp`; negative values later become huge `u64` in FQ
  `time_to_send`, breaking scheduling.
- **Symptom:** Packets scheduled far in the future in `sch_fq`,
  effectively stalling a flow.
- **Root cause:** No lower-bound validation on SCM_TXTIME input;
  signed/unsigned conversion at FQ enqueue.
- **Policy:** Clamp to minimum valid time per clockid; preserve `txtime
  == 0` special case; defer upper-bound checks to consumers (FQ already
  caps horizon).

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although phrased as input sanitization, this is a real
correctness fix for signed/unsigned overflow in the SO_TXTIME → FQ path.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `net/core/sock.c` (+31 / -1)
- **Function:** `__sock_cmsg_send()` — `SCM_TXTIME` case only
- **Scope:** Single-file, surgical input-validation fix

### Step 2.2: Code flow change
**Record:**
- **Before:** `sockc->transmit_time = get_unaligned((u64
  *)CMSG_DATA(cmsg));` — any `u64` accepted.
- **After:**
  - `txtime == 0` → pass through (feature-off sentinel).
  - Otherwise compute `tmin` from `sk->sk_clockid`:
    - `CLOCK_MONOTONIC`: `tmin = 1`
    - `CLOCK_REALTIME`: `tmin = max(ktime_mono_to_real(0), 1)`
    - `CLOCK_TAI`: `tmin = max(ktime_mono_to_any(0, TK_OFFS_TAI), 1)`
  - `sockc->transmit_time = max_t(ktime_t, txtime, tmin)`

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Type/signedness correctness bug.
- **Mechanism:**
  1. Userspace sends SCM_TXTIME `u64`.
  2. Value flows to `skb_set_delivery_type_by_clockid()` as `ktime_t`.
  3. Pre-epoch / pre-boot REALTIME/TAI values are negative `ktime_t`.
  4. FQ does `fq_skb_cb(skb)->time_to_send = skb->tstamp` (`u64`),
     turning negative `s64` into ~2⁶⁴.
  5. `fq_dequeue()` treats packet as far-future and throttles
     indefinitely.

### Step 2.4: Fix quality
**Record:**
- Fix is minimal, obviously correct, and matches existing FQ “bound
  rather than error” policy.
- **Regression risk:** Very low; preserves zero sentinel; only raises
  too-small timestamps.
- **Concern:** Upper bound still deferred (by design).

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** SCM_TXTIME handling introduced in `80b14dee2bea1` (Richard
Cochran, 2018-07-03, “net: Add a new socket option for a future transmit
time”). Bug present since introduction; not a recent regression.

### Step 3.2: Fixes: tag
**Record:** N/A — v2 deliberately removed Fixes: tag.

### Step 3.3: Related file history
**Record:** Part of 3-patch series merged as `1e127c94fa11c` (“Merge
branch 'so_txtime-improvements'”):
1. `73f1a618b0648` — this commit (sock.c validation)
2. `c4f796c4f16ba` — `sch_fq.c` clock conversion + BPF bounds
3. `b016022b127fc` — selftest extension

Related in-tree: `73451e9aaa24e` (“net: validate SO_TXTIME clockid
coming from userspace”, syzbot-reported WARN_ON fix).

### Step 3.4: Author context
**Record:** Willem de Bruijn is a core networking contributor; Jakub
Kicinski (netdev maintainer) merged the series.

### Step 3.5: Dependencies
**Record:** Standalone for SCM_TXTIME userspace path. Uses
`ktime_mono_to_real()` and `ktime_mono_to_any()` — both present in this
tree. BPF bypass still needs sibling FQ patch, but that is a separate
commit.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:**
- **b4 dig URL:** https://patch.msgid.link/20260604194221.3319080-2-
  willemdebruijn.kernel@gmail.com
- **Series:** v1 (2026-06-03), v2 (2026-06-04); committed version is v2.
- **Review feedback in thread:** No stable nomination, NAK, Reviewed-by,
  or Acked-by found in saved mbox.

### Step 4.2: Reviewers
**Record:** CC list included netdev, davem, kuba, edumazet, pabeni,
horms — appropriate maintainer coverage.

### Step 4.3: Bug reports
**Record:** No syzbot/bugzilla/user bug report for this specific
overflow issue.

### Step 4.4: Related patches
**Record:** Patch 2 (`sch_fq.c`) adds monotonic conversion and BPF-side
bounds; patch 3 extends selftests. Patch 1 is independently useful for
all SCM_TXTIME consumers.

### Step 4.5: Stable list history
**Record:** Not investigated on lore stable@; no explicit stable
discussion found.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `__sock_cmsg_send()` modified; downstream
`sock_cmsg_send()`, `skb_set_delivery_type_by_clockid()`,
`fq_enqueue()`.

### Step 5.2: Callers
**Record:** `__sock_cmsg_send()` / `sock_cmsg_send()` called from
IPv4/IPv6 datagram paths, TCP, packet sockets, CAN raw, Bluetooth, etc.
— all reachable via `sendmsg()` with cmsg.

### Step 5.3: Callees
**Record:** Uses `ktime_mono_to_real()`, `ktime_mono_to_any()`,
`max_t()`, `get_unaligned()`.

### Step 5.4: Reachability
**Record:**
- Requires `SO_TXTIME` enabled via `setsockopt()`.
- `CLOCK_REALTIME` / `CLOCK_TAI` require `CAP_NET_ADMIN` (see
  `sock.c:1617-1624`).
- `CLOCK_MONOTONIC` is available without admin caps.
- Overflow on monotonic path is theoretically possible only for `u64 >
  S64_MAX` (not realistic since boot).
- Realistic overflow trigger: admin-configured REALTIME/TAI with pre-
  boot/pre-epoch timestamp.

### Step 5.5: Similar patterns
**Record:** `sch_etf.c` already rejects past timestamps via
`ktime_before()`. FQ lacks equivalent lower-bound protection and is
vulnerable to the signed→unsigned wrap.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy code present?
**Record:** Yes. Local tree is **6.18.44** (`git describe HEAD` →
`v6.18.44`). `net/core/sock.c:3016-3021` still has unvalidated
SCM_TXTIME assignment. Commit `73f1a618b0648` is in master but **not**
in this stable checkout.

### Step 6.2: Backport complications
**Record:** Cherry-pick test: **auto-merges cleanly** into
`linux-6.18.y`. Expected difficulty: clean apply.

### Step 6.3: Related fixes already present?
**Record:** `73451e9aaa24e` (SO_TXTIME clockid validation, syzbot) is
already in tree. This overflow/bounds issue is **not** fixed elsewhere.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem criticality
**Record:** **net/core** + **net/sched** — **CORE/IMPORTANT**. Affects
packet scheduling for SO_TXTIME users (TSN, time-aware traffic shaping).

### Step 7.2: Subsystem activity
**Record:** Networking core is mature but actively maintained;
SO_TXTIME/tstamp_type work continued through 2024–2026.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users of `SO_TXTIME` with `sch_fq` (default TCP qdisc on
many systems). Most severe for REALTIME/TAI (admin). Monotonic path
largely unaffected in practice.

### Step 8.2: Trigger conditions
**Record:** `SO_TXTIME` + invalid/old SCM_TXTIME timestamp + FQ on path.
Unlikely but reachable; admin or buggy userspace can trigger
REALTIME/TAI case.

### Step 8.3: Failure mode severity
**Record:** Indefinite flow stall in FQ (packet treated as ~2⁶⁴ ns in
future). **Severity: HIGH** functionally, not CRITICAL (no
crash/corruption/CVE).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents serious scheduling misbehavior; fixes long-
  standing signedness hole.
- **Risk:** Very low — 30 lines, input-only, no API change.
- **Ratio:** Moderate-to-good benefit for niche but real production use
  case (TSN/time-aware networking).

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real signed/unsigned correctness bug with concrete failure mode
- Small, surgical, obviously correct fix
- Applies cleanly to 6.18.y
- Buggy code present since 2018
- All helper dependencies exist in tree
- Prevents indefinite FQ flow stall

**AGAINST backport:**
- Part of 3-patch series; BPF/non-monotonic FQ issues need sibling
  commit
- No syzbot/user crash report
- Realistic overflow trigger needs CAP_NET_ADMIN (REALTIME/TAI)
- Monotonic (unprivileged) path barely affected
- Proactive hardening rather than reported regression

**Unresolved:** No explicit stable nomination in lore thread.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is clear; series has
   selftest (patch 3, separate).
2. Fixes real bug affecting users? **PASS** — FQ stall on bad
   SCM_TXTIME.
3. Important issue? **PASS** — serious functional/scheduling failure
   (not crash/security).
4. Small and contained? **PASS** — 31 lines, one file.
5. No new features/APIs? **PASS** — input validation only.
6. Can apply to local tree? **PASS** — clean cherry-pick.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs fix).

### Step 9.4: Decision rationale

For **linux-6.18.y**, this commit fixes a real, long-standing signedness
bug in core socket cmsg handling that can cause `sch_fq` to treat
packets as scheduled billions of years in the future. The fix is
minimal, low-risk, applies cleanly, and all prerequisites
(`ktime_mono_to_real`, `ktime_mono_to_any`, `tstamp_type`, SO_TXTIME)
exist in this tree. While the realistic trigger is somewhat niche
(SO_TXTIME + FQ + invalid REALTIME/TAI timestamp, typically admin), the
failure mode is severe for time-sensitive networking workloads, and
validating at the SCM_TXTIME source is the right defensive layer
regardless of the companion FQ patch.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; noted removed Fixes: tag in
  v2.
- **[Phase 2]** Read diff: +31/-1 in `net/core/sock.c`,
  `__sock_cmsg_send()` SCM_TXTIME case.
- **[Phase 3]** `git blame`: SCM_TXTIME introduced `80b14dee2bea1`
  (2018-07-03).
- **[Phase 3]** Series on master: `1e127c94fa11c` contains patches 1–3;
  this is patch 1/3.
- **[Phase 3]** `git merge-base --is-ancestor 73f1a618b0648 HEAD` → not
  in 6.18.44; in master.
- **[Phase 4]** `b4 dig -c 73f1a618b0648`: lore URL found; v1+v2
  revisions.
- **[Phase 4]** `b4 dig -w`: netdev maintainers CC'd.
- **[Phase 4]** Mbox search: no stable/NAK/Reviewed-by entries.
- **[Phase 5]** Traced callers: `sock_cmsg_send()` from
  IPv4/IPv6/TCP/packet/CAN paths.
- **[Phase 5]** Read `sch_fq.c:557-571`, `fq_dequeue():704-707` —
  confirms `u64 time_to_send` assignment and future-throttle logic.
- **[Phase 5]** Read `sock.c:1617-1624` — REALTIME/TAI require
  CAP_NET_ADMIN.
- **[Phase 5]** Read `sch_etf.c:100-103` — ETF has past-timestamp
  rejection; FQ does not.
- **[Phase 6]** `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44.
- **[Phase 6]** Confirmed buggy code at `net/core/sock.c:3021` in
  current tree.
- **[Phase 6]** Cherry-pick test of `73f1a618b0648`: auto-merges
  cleanly.
- **[Phase 6]** Verified `ktime_mono_to_real` / `ktime_mono_to_any` in
  `include/linux/timekeeping.h` and `kernel/time/timekeeping.c`.
- **[Phase 6]** Related fix `73451e9aaa24e` present; this overflow fix
  is not.

**YES**Analyzed commit `73f1a618b0648` ("net: ensure SCM_TXTIME delivery
time is no older than system boot") for backport to **linux-6.18.y**
(currently at 6.18.44).

**Summary:** The fix clamps invalid SCM_TXTIME values before they become
negative `ktime_t` values that wrap to huge `u64` timestamps in
`sch_fq`, which can stall a flow indefinitely. The buggy code is present
in this tree (since SO_TXTIME was added in 2018), the patch applies
cleanly, and it's a small, low-risk input-validation change.

**Verdict: YES** — worth backporting to 6.18.y. The companion FQ patch
(`c4f796c4f16ba`, clock conversion/BPF bounds) is a separate candidate
if you want full SO_TXTIME/FQ coverage.

 net/core/sock.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 5a658606c50e8..510867963f4d0 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3014,12 +3014,42 @@ int __sock_cmsg_send(struct sock *sk, struct cmsghdr *cmsg,
 		sockc->tsflags |= tsflags;
 		break;
 	case SCM_TXTIME:
+	{
+		ktime_t tmin;
+		u64 txtime;
+
 		if (!sock_flag(sk, SOCK_TXTIME))
 			return -EINVAL;
 		if (cmsg->cmsg_len != CMSG_LEN(sizeof(u64)))
 			return -EINVAL;
-		sockc->transmit_time = get_unaligned((u64 *)CMSG_DATA(cmsg));
+
+		txtime = get_unaligned((u64 *)CMSG_DATA(cmsg));
+
+		/* Allow sending without a delivery time: zero special case */
+		if (!txtime) {
+			sockc->transmit_time = 0;
+			break;
+		}
+
+		switch (sk->sk_clockid) {
+		case CLOCK_MONOTONIC:
+			tmin = 1;
+			break;
+		case CLOCK_REALTIME:
+			tmin = max(ktime_mono_to_real(0), 1);
+			break;
+		case CLOCK_TAI:
+			tmin = max(ktime_mono_to_any(0, TK_OFFS_TAI), 1);
+			break;
+		default:
+			tmin = 1;
+			WARN_ON_ONCE(1);
+			break;
+		}
+
+		sockc->transmit_time = max_t(ktime_t, txtime, tmin);
 		break;
+	}
 	case SCM_TS_OPT_ID:
 		if (sk_is_tcp(sk))
 			return -EINVAL;
-- 
2.53.0

