Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867FC40F8D5;
	Mon, 20 Apr 2026 13:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691637; cv=none; b=tl48QoGzQOsYo07aqALWVH8WXRMZAJNw5dXQGqXcZt+e1W4n/XEHAp52js/r/Olre1c7Y+JP6IyBwmXRUL/XK7i8KXdlDbAO+aVofB7IIJ/RiilCgTiLPQANMDo/8hhItf+tXROSWZwlwKgM+H55Ad1WLfJ8C/QBbBf5EgF3fkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691637; c=relaxed/simple;
	bh=/0rZJZACPZFhpXFy+Y4nxmNApchB5LY37TE1oIjiqdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gkjfh8uacXZdqMpX3X/pUwWkxfX1xa+6TFUfaSllIEpINgbmlesMN6zRE8lrGCKenAsguiB3qHv3e8MxzkPf3g09gJUpwyOBn3d1skjnmfK74pO9B7NAyKcMGtJG7tjblmg2vu3wukOZHdEeqhCDqHktaa+rcj2pnAobAanMKCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rTuA5E9k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rTuA5E9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F50C2BCC9;
	Mon, 20 Apr 2026 13:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691637;
	bh=/0rZJZACPZFhpXFy+Y4nxmNApchB5LY37TE1oIjiqdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTuA5E9k5GP6FRBjSbPDfOxe5/JkyBsl6dAQqTtr8P18z5hkBgsGMJtnK8cj8M1yi
	 nuZM2NteETPViPnR0HsgEUhiIkH+JpMXG2uuzJnUzjk079+h0vW2YjZff3cKI3Cewd
	 SZeJjNpHGsMwZfbsbK/YDNLkJAblg4DxQoc6aznR2JH7t8Hp73t63KMPh1q9twFZLt
	 hkqqK8a9jYtqOoCGZjGYZoBRpc0F6SmQ4DaYQE9L8GhKISomypj6hobZXx61+F7ev4
	 ksguk94alwYHLMUyOrmZgscCTdOquKlmAOqKE4sEKvyE00lHhV5WntEMyL4pmXg+ij
	 7yYfVD6J8g95w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ankit Garg <nktgrg@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jordan Rhee <jordanrhee@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Joshua Washington <joshwash@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	kuba@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] gve: fix SW coalescing when hw-GRO is used
Date: Mon, 20 Apr 2026 09:18:59 -0400
Message-ID: <20260420132314.1023554-145-sashal@kernel.org>
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

From: Ankit Garg <nktgrg@google.com>

[ Upstream commit ea4c1176871fd70a06eadcbd7c828f6cb9a1b0cd ]

Leaving gso_segs unpopulated on hardware GRO packet prevents further
coalescing by software stack because the kernel's GRO logic marks the
SKB for flush because the expected length of all segments doesn't match
actual payload length.

Setting gso_segs correctly results in significantly more segments being
coalesced as measured by the result of dev_gro_receive().

gso_segs are derived from payload length. When header-split is enabled,
payload is in the non-linear portion of skb. And when header-split is
disabled, we have to parse the headers to determine payload length.

Signed-off-by: Ankit Garg <nktgrg@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jordan Rhee <jordanrhee@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Signed-off-by: Joshua Washington <joshwash@google.com>
Link: https://patch.msgid.link/20260303195549.2679070-3-joshwash@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Excellent. I now have a complete picture. Let me compile the full
analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** `gve` (Google Virtual Ethernet driver,
  `drivers/net/ethernet/google/gve/`)
- **Action verb:** "fix"
- **Summary:** Fix software GRO coalescing when hardware GRO (RSC) is
  used by correctly setting `gso_segs`.

### Step 1.2: Tags
- **Signed-off-by:** Ankit Garg (author), Joshua Washington (submitter),
  Paolo Abeni (maintainer who merged)
- **Reviewed-by:** Eric Dumazet (top networking maintainer), Jordan
  Rhee, Harshitha Ramamurthy (GVE team)
- **Link:** `https://patch.msgid.link/20260303195549.2679070-3-
  joshwash@google.com` — patch 3 of a 4-patch series
- No `Fixes:` tag, no `Cc: stable`, no `Reported-by:` — expected for
  autosel candidates.

Notable: Eric Dumazet reviewing gives high confidence in correctness.

### Step 1.3: Commit Body
The commit explains:
- **Bug:** `gso_segs` is left at 0 (unpopulated) for HW-GRO/RSC packets.
- **Symptom:** The kernel's GRO stack marks the SKB for flush because
  `count * gso_size = 0 != payload_len`, preventing any further software
  coalescing.
- **Impact:** "significantly more segments being coalesced" when fixed —
  quantifiable performance impact.
- **Root cause:** Missing `gso_segs` initialization in
  `gve_rx_complete_rsc()`.

### Step 1.4: Hidden Bug Fix?
This is explicitly labeled "fix" and describes a concrete functional bug
(broken GRO coalescing, wrong TCP accounting).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed:** 1 (`drivers/net/ethernet/google/gve/gve_rx_dqo.c`)
- **Functions modified:** `gve_rx_complete_rsc()` only
- **Scope:** ~25 lines changed/added within a single function. Surgical.

### Step 2.2: Code Flow Change
**Before:** `gve_rx_complete_rsc()` sets `shinfo->gso_type` and
`shinfo->gso_size` but NOT `shinfo->gso_segs`. The SKB arrives in the
GRO stack with `gso_segs=0`.

**After:** The function:
1. Extracts `rsc_seg_len` and returns early if 0 (no RSC data)
2. Computes segment count differently based on header-split mode:
   - Header-split: `DIV_ROUND_UP(skb->data_len, rsc_seg_len)`
   - Non-header-split: `DIV_ROUND_UP(skb->len - hdr_len, rsc_seg_len)`
     where `hdr_len` is determined by `eth_get_headlen()`
3. Sets both `gso_size` and `gso_segs`

### Step 2.3: Bug Mechanism
**Category:** Logic/correctness fix — missing initialization.

The mechanism is confirmed by reading the GRO core code:

```495:502:net/core/gro.c
        NAPI_GRO_CB(skb)->count = 1;
        if (unlikely(skb_is_gso(skb))) {
                NAPI_GRO_CB(skb)->count = skb_shinfo(skb)->gso_segs;
                /* Only support TCP and non DODGY users. */
                if (!skb_is_gso_tcp(skb) ||
                    (skb_shinfo(skb)->gso_type & SKB_GSO_DODGY))
                        NAPI_GRO_CB(skb)->flush = 1;
        }
```

With `gso_segs=0`, `count=0`. Then in TCP offload:

```351:353:net/ipv4/tcp_offload.c
        /* Force a flush if last segment is smaller than mss. */
        if (unlikely(skb_is_gso(skb)))
                flush = len != NAPI_GRO_CB(skb)->count *
skb_shinfo(skb)->gso_size;
```

`0 * gso_size = 0`, `len > 0` → `flush = true` always. Packets are
immediately flushed, preventing further coalescing and corrupting TCP
segment accounting.

### Step 2.4: Fix Quality
- **Obviously correct:** Yes, the pattern is well-established (identical
  to the MLX5 gso_segs fix).
- **Minimal/surgical:** Yes, changes one function in one file.
- **Regression risk:** Very low. Only executes for RSC packets
  (`desc->rsc` set).

---

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
The buggy code (`gve_rx_complete_rsc()`) was introduced in commit
`9b8dd5e5ea48b` ("gve: DQO: Add RX path") by Bailey Forrest on
2021-06-24. This commit has been in the tree since v5.14.

### Step 3.2: No Fixes: tag
N/A — no `Fixes:` tag. The implicit fix target is `9b8dd5e5ea48b`.

### Step 3.3: File History
48 total commits to `gve_rx_dqo.c`. Active development. The function
`gve_rx_complete_rsc()` itself has not been modified since initial
introduction.

### Step 3.4: Author
Ankit Garg (`nktgrg@google.com`) is a regular Google GVE driver
contributor. Joshua Washington (`joshwash@google.com`) is the main GVE
maintainer who submitted the series.

### Step 3.5: Dependencies
This is patch 2/4 in a series "[PATCH net-next 0/4] gve: optimize and
enable HW GRO for DQO". The patches are:
1. `gve: Advertise NETIF_F_GRO_HW instead of NETIF_F_LRO`
2. **THIS COMMIT** — `gve: fix SW coalescing when hw-GRO is used`
3. `gve: pull network headers into skb linear part`
4. `gve: Enable hw-gro by default if device supported`

**This fix is standalone.** The `gve_rx_complete_rsc()` function is
called whenever `desc->rsc` is set, regardless of whether the device
advertises `NETIF_F_LRO` or `NETIF_F_GRO_HW`. The `gso_segs` bug exists
with both feature flags.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Original Submission
Found via yhbt.net mirror: `https://yhbt.net/lore/netdev/20260303195549.
2679070-1-joshwash@google.com/`

The series was posted to net-next on 2026-03-03 and was accepted by
patchwork-bot on 2026-03-05. No NAKs or objections were raised.

### Step 4.2: Reviewers
The patch was CC'd to all major networking maintainers: Andrew Lunn,
David S. Miller, Eric Dumazet, Jakub Kicinski, Paolo Abeni. Eric Dumazet
gave Reviewed-by. Paolo Abeni signed off as the committer.

### Step 4.3: Analogous Bug Report
The MLX5 driver had an identical bug (missing `gso_segs` for LRO
packets). That fix was sent to the `net` tree (targeted at stable), with
`Fixes:` tag and detailed analysis of the consequences. The GVE fix
addresses the same root cause.

### Step 4.4: Series Context
Patches 1, 3, 4 in the series are feature/optimization changes (not
stable material). Patch 2 (this commit) is the only actual bug fix and
is self-contained.

### Step 4.5: Stable Discussion
No specific stable discussion found, as expected for an autosel
candidate.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
- `gve_rx_complete_rsc()` — the only function changed.

### Step 5.2: Callers
`gve_rx_complete_rsc()` is called from `gve_rx_complete_skb()` at line
991, which is called from `gve_rx_poll_dqo()` — the main RX polling
function for all DQO mode traffic. This is a hot path for all GVE
network traffic.

### Step 5.3: Callees
The new code calls `eth_get_headlen()` (available via `gve_utils.h` →
`<linux/etherdevice.h>`), `skb_frag_address()`, `skb_frag_size()`, and
`DIV_ROUND_UP()`. All are standard kernel APIs available in all stable
trees.

### Step 5.4: Reachability
The buggy path is directly reachable from network I/O for any GVE user
with HW-GRO/RSC enabled. GVE is the standard NIC for Google Cloud VMs —
millions of instances.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable?
The original commit `9b8dd5e5ea48b` is confirmed present in v5.14,
v5.15, v6.1, v6.6, v6.12, and v7.0. All active stable trees are
affected.

### Step 6.2: Backport Complications
The function `gve_rx_complete_rsc()` has not changed since initial
introduction. The diff should apply cleanly to all stable trees since
v5.14. All APIs used (`eth_get_headlen`, `skb_frag_address`,
`DIV_ROUND_UP`) exist in all stable trees.

### Step 6.3: Related Fixes
No related fixes already in stable for this specific issue.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
`drivers/net/ethernet/google/gve/` — Network driver for Google Virtual
Ethernet (gVNIC).
- **Criticality:** IMPORTANT — used by all Google Cloud VMs, which is a
  major cloud platform.

### Step 7.2: Activity
Very active subsystem with 48 commits to this file.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Affected Users
All GVE users (Google Cloud VMs) with HW-GRO/RSC enabled. This is a
large user population.

### Step 8.2: Trigger Conditions
Triggered on every RSC/HW-GRO packet received — common during TCP
traffic. No special conditions needed.

### Step 8.3: Failure Mode
- **Performance degradation:** SKBs are immediately flushed from GRO,
  preventing further coalescing. The commit says "significantly more
  segments being coalesced" when fixed.
- **Incorrect TCP accounting:** `gso_segs=0` propagates to
  `tcp_gro_complete()` which sets `shinfo->gso_segs =
  NAPI_GRO_CB(skb)->count` = 0. This causes incorrect `segs_in`,
  `data_segs_in` (as documented in the MLX5 fix).
- **Potential checksum issues:** As seen in the MLX5 case, `gso_segs=0`
  can lead to incorrect GRO packet merging and "hw csum failure" errors.
- **Severity:** MEDIUM-HIGH (performance + functional correctness)

### Step 8.4: Risk-Benefit
- **Benefit:** HIGH — fixes broken GRO for a major cloud NIC driver,
  affects many users
- **Risk:** VERY LOW — 25-line change in one function, only touches RSC
  path, well-reviewed
- **Ratio:** Strongly favorable for backporting

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a real, functional bug (missing `gso_segs` breaks GRO coalescing
  and TCP accounting)
- Identical class of bug to the MLX5 fix which was targeted at `net`
  (stable-track tree)
- Small, surgical change (25 lines, 1 function, 1 file)
- Self-contained — no dependencies on other patches in the series
- Reviewed by Eric Dumazet
- Buggy code exists in all active stable trees (since v5.14)
- Affects a major driver (Google Cloud VMs)
- Uses only standard APIs available in all stable trees
- Clean apply expected

**AGAINST backporting:**
- Submitted to `net-next` (not `net`), as part of a feature series
- No `Fixes:` tag or `Cc: stable`
- The symptom is primarily performance degradation, not a crash (though
  TCP accounting is also incorrect)

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — reviewed by Eric Dumazet,
   standard pattern
2. **Fixes a real bug?** YES — missing `gso_segs` causes GRO flush and
   wrong TCP accounting
3. **Important issue?** YES — affects all GVE users with HW-GRO,
   performance + correctness
4. **Small and contained?** YES — 25 lines, 1 function, 1 file
5. **No new features?** Correct — pure bug fix
6. **Can apply to stable?** YES — clean apply expected, all APIs
   available

### Step 9.3: Exception Categories
Not applicable — this is a standard bug fix, not an exception category.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Eric Dumazet, Harshitha Ramamurthy,
  Jordan Rhee; Link shows patch 3/4 of series
- [Phase 2] Diff analysis: 25 lines changed in `gve_rx_complete_rsc()`,
  adds `gso_segs` calculation
- [Phase 2] Verified flush mechanism in `net/core/gro.c:496-497` and
  `net/ipv4/tcp_offload.c:352-353`
- [Phase 3] git blame: buggy code introduced in commit `9b8dd5e5ea48b`
  (v5.14, 2021-06-24)
- [Phase 3] Verified `9b8dd5e5ea48b` is in v5.14, v5.15, v6.1, v6.6,
  v6.12
- [Phase 3] Verified function `gve_rx_complete_rsc()` unchanged since
  introduction
- [Phase 4] Found original series at yhbt.net mirror: 4-patch net-next
  series, accepted 2026-03-05
- [Phase 4] Confirmed no NAKs or objections in thread
- [Phase 4] Confirmed MLX5 had identical `gso_segs=0` bug fixed via
  `net` tree
- [Phase 5] Verified `eth_get_headlen` available via `gve_utils.h` →
  `<linux/etherdevice.h>`
- [Phase 5] Verified `gve_rx_complete_rsc()` called from hot RX poll
  path
- [Phase 6] Confirmed buggy code in all active stable trees (v5.14+)
- [Phase 6] Confirmed clean apply expected (function unchanged since
  introduction)
- [Phase 8] Failure mode: broken GRO coalescing + incorrect TCP
  accounting, severity MEDIUM-HIGH
- UNVERIFIED: Could not access lore.kernel.org directly due to bot
  protection; used mirror

The fix is small, well-contained, well-reviewed, fixes a real functional
bug in a widely-used driver, and meets all stable kernel criteria.

**YES**

 drivers/net/ethernet/google/gve/gve_rx_dqo.c | 23 ++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index c706c79321594..cf69570f4d57a 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -944,11 +944,16 @@ static int gve_rx_complete_rsc(struct sk_buff *skb,
 			       struct gve_ptype ptype)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	int rsc_segments, rsc_seg_len, hdr_len;
 
-	/* Only TCP is supported right now. */
+	/* HW-GRO only coalesces TCP. */
 	if (ptype.l4_type != GVE_L4_TYPE_TCP)
 		return -EINVAL;
 
+	rsc_seg_len = le16_to_cpu(desc->rsc_seg_len);
+	if (!rsc_seg_len)
+		return 0;
+
 	switch (ptype.l3_type) {
 	case GVE_L3_TYPE_IPV4:
 		shinfo->gso_type = SKB_GSO_TCPV4;
@@ -960,7 +965,21 @@ static int gve_rx_complete_rsc(struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	shinfo->gso_size = le16_to_cpu(desc->rsc_seg_len);
+	if (skb_headlen(skb)) {
+		/* With header-split, payload is in the non-linear part */
+		rsc_segments = DIV_ROUND_UP(skb->data_len, rsc_seg_len);
+	} else {
+		/* HW-GRO packets are guaranteed to have complete TCP/IP
+		 * headers in frag[0] when header-split is not enabled.
+		 */
+		hdr_len = eth_get_headlen(skb->dev,
+					  skb_frag_address(&shinfo->frags[0]),
+					  skb_frag_size(&shinfo->frags[0]));
+		rsc_segments = DIV_ROUND_UP(skb->len - hdr_len, rsc_seg_len);
+	}
+	shinfo->gso_size = rsc_seg_len;
+	shinfo->gso_segs = rsc_segments;
+
 	return 0;
 }
 
-- 
2.53.0

