Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBE1559C8C;
	Mon, 31 Aug 2026 13:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184037; cv=none; b=I0WOh5Q2nA88vfr9mpPMLYOUSs4aMQYT+f6qItQxewjiaBHP4fbLSQd4UkyoLFgbAUMQCPji2F3wGsO8eNjs0FiBUSq5HpTWc9QadNbwzBxE7NGtqZMDhpqG31BEw8fDJIRZoO3pcoiDola3kGA77blLrhg803CvMpY6cbKYHD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184037; c=relaxed/simple;
	bh=OGBNe6Of555E3cMhokYzTCprUdg5piyVluzuP1eNiMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bMFvt7/LoKyWwHJ1OCU/bmHxzaj5ZCmvfM1m91DOtupjCtzOFq6X136jPsPj7jM/Dnpv+xFiz4s63k1FZQO0CTCjbUd0wUGxKdD1tmcmRVa+uqJjut4VG/vmhaB6SIvSxmX0BGGGNnppizxpwfoxQjigSW+WhsU7wbAEhIZB7Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EEeFzdGZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EEeFzdGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC05A1F00ACF;
	Mon, 31 Aug 2026 13:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184035;
	bh=Mt5YSHE4bKinXdaYDMwvfpUDb934LVODG8gkA2CRJLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EEeFzdGZscG7bUIgFAY+id07Din3hIFNbtyaZsMmrrDVVv81WMwzGsKVdnu7l5u82
	 LuR9fgyhPlPK6CfwMi/XkarjO05dm5p4UL+npuQIYQgZv44K4ISGKVuPyWZyZXP2IN
	 LSONJMZPbo3mQJgE/Z8OGqxVFHj4/yPaD0YbkT/BGov5exG2NWTLR5DB5hchDAai3f
	 JCtejl2D3XHRID+YxlxX3EC+iwd1SAuoavbOqRnyJoyej35Qg5NxaRAPnNclQx5hK8
	 DJ4chb/DcXLoK9N7e4Smrl/gFrNUZOmhB8Dj1PmU9pMAUv7WyDEKF3Wfu/mbV/cPkU
	 KLDl7UxvwqUBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net: ibm: emac: Reserve VLAN header in MJS limit
Date: Mon, 31 Aug 2026 09:28:00 -0400
Message-ID: <20260831133314.4125787-452-sashal@kernel.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 0906c117f81c2ae6e6dbfa82719f79c75e1c9325 ]

The IBM EMAC programs its Maximum Jumbo Size (MJS) drop
threshold from ndev->mtu directly. The hardware sizes the threshold
against the L2 frame minus the ethernet header, but does not
discount the 802.1Q tag, so a frame carrying a VLAN tag and a full
1500-byte payload exceeds MJS by exactly 4 bytes and is dropped.

This is normally hidden because JPSM (and therefore the MJS check)
only engages when the MTU is raised above ETH_DATA_LEN.  With the
qca8k DSA tagger the conduit MTU is bumped by QCA_HDR_LEN to 1502
during dsa_conduit_setup(), which is enough to enable JPSM and
expose the off-by-VLAN-tag in the limit.

Pad MJS by VLAN_HLEN so a VLAN-tagged full-MTU frame passes.

Reported on Meraki MX60 (qca8k switch): tagged VLAN
traffic drops at 1500-byte payload, while 1496 bytes works
and untagged 1500 bytes works.

Assisted-by: Claude:Opus-4.7
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20260526202247.13823-1-rosenp@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[net: ibm: emac]` `[Reserve]` — Reserve VLAN header space
in the Maximum Jumbo Size (MJS) hardware limit.

### Step 1.2: Tags
**Record:**
- **Link:**
  https://patch.msgid.link/20260526202247.13823-1-rosenp@gmail.com
- **Assisted-by:** Claude:Opus-4.7
- **Signed-off-by:** Rosen Penev \<rosenp@gmail.com\>
- **Signed-off-by:** Paolo Abeni \<pabeni@redhat.com\> (net maintainer,
  committer)
- No Fixes:, Reported-by:, Cc: stable@vger.kernel.org, Tested-by:, or
  Reviewed-by: in commit message
- Notable: Real-world hardware report in body (Meraki MX60); maintainer
  ack on commit

### Step 1.3: Body Analysis
**Record:**
- **Bug:** IBM EMAC APM821xx programs MJS from `ndev->mtu`. Hardware
  compares frame size minus Ethernet header against MJS but does not
  account for the 802.1Q VLAN tag (4 bytes).
- **Symptom:** VLAN-tagged frames with a 1500-byte payload are dropped;
  1496-byte payloads and untagged 1500-byte payloads work.
- **Trigger:** JPSM/MJS only engages when MTU > `ETH_DATA_LEN` (1500).
  With qca8k DSA, `dsa_conduit_setup()` sets conduit MTU to
  `ETH_DATA_LEN + QCA_HDR_LEN` = 1502, enabling JPSM and exposing the
  off-by-4 bug.
- **Root cause:** MJS threshold is 4 bytes too small for VLAN-tagged
  full-MTU frames.
- **Version info:** None explicit; bug latent since jumbo/MJS support
  was added (2012).

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit hardware-limit bug fix, not
disguised cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/ethernet/ibm/emac/core.c` (+2, -1 functional;
  +1 include)
- **Functions modified:** `emac_iff2rmr()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (include):** Adds `#include <linux/if_vlan.h>` for
  `VLAN_HLEN`.
- **Hunk 2 (`emac_iff2rmr`):**
  - **Before:** `EMAC4_RMR_MJS(ndev->mtu)` — MJS equals netdev MTU.
  - **After:** `EMAC4_RMR_MJS(ndev->mtu + VLAN_HLEN)` — MJS includes
    4-byte VLAN headroom.
  - **Path:** Runs when `EMAC_APM821XX_REQ_JUMBO_FRAME_SIZE` is set,
    during `emac_configure()` and multicast updates.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic/correctness — hardware workaround
- **Mechanism:** Hardware MJS check ignores VLAN tag size; driver must
  pad MJS by `VLAN_HLEN` (4) so tagged full-MTU frames pass.

### Step 2.4: Fix Quality
**Record:**
- Fix is minimal and matches the described hardware behavior.
- Low regression risk: only affects APM821xx EMAC with jumbo/MJS enabled
  (MTU > 1500).
- Slightly more permissive MJS is safe; the alternative is incorrect
  drops.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- Buggy MJS line introduced in `ae5d33723e3253` (2012-03-05):
  "powerpc/44x: Add more changes for APM821XX EMAC driver"
- Present in this tree at `drivers/net/ethernet/ibm/emac/core.c:460`

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related File History
**Record:**
- Fix commit: `0906c117f81c2` on `all-next` (2026-06-01), not in current
  HEAD (6.18.44)
- Recent emac changes on 6.18.y include UAF and NULL-deref fixes; no
  prior MJS/VLAN fix
- Standalone single patch (v1 only, no series)

### Step 3.4: Author Context
**Record:** Rosen Penev — active networking contributor (DSA/Meraki-
related work). Committer Paolo Abeni is a net maintainer.

### Step 3.5: Dependencies
**Record:**
- No patch-series dependencies
- Exposure path requires `dsa_conduit_setup()` MTU bump — present in
  this tree since `6ca80638b90ce` (2023-10-24)
- Applies cleanly: `git apply --check` on `0906c117f81c2` succeeds

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- **URL:**
  https://patch.msgid.link/20260526202247.13823-1-rosenp@gmail.com
- **Revisions:** v1 only (2026-05-26)
- **Key feedback:** Jacob Keller noted dropped packets are user-visible.
  Paolo Abeni replied it is not a regression ("never worked"), suitable
  for net-next to enable DSA support. Jacob Keller gave Reviewed-by.
- **Stable nomination:** None in thread
- **NAKs:** None

### Step 4.2: Reviewers
**Record:** netdev@vger.kernel.org, Andrew Lunn, David S. Miller, Eric
Dumazet, Jakub Kicinski, Paolo Abeni CC'd. Reviewed-by: Jacob Keller.

### Step 4.3: Bug Report
**Record:** Meraki MX60 with qca8k switch — tagged VLAN traffic drops at
1500-byte payload. Severity: functional networking breakage (silent
packet loss).

### Step 4.4: Related Patches
**Record:** Standalone; no multi-patch series.

### Step 4.5: Stable List History
**Record:** Not searched separately; no stable discussion found in the
patch thread.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `emac_iff2rmr()` — builds Receive Mode Register including
MJS field.

### Step 5.2: Callers
**Record:**
- `emac_configure()` (line 668) — device init/reconfigure, link setup,
  TX reset
- `__emac_set_multicast_list()` (line 949) — multicast/promisc flag
  changes
- `emac_configure()` called from `emac_reinitialize()`,
  `emac_full_tx_reset()`, and MTU resize path when jumbo mode toggles

### Step 5.3: Callees
**Record:** `emac_has_feature()`, `EMAC4_RMR_MJS()` macro, netdev
flag/multicast helpers.

### Step 5.4: Reachability
**Record:**
- **Call chain:** DSA setup → `dsa_conduit_setup()` →
  `dev_set_mtu(1502)` → EMAC jumbo/MJS enabled → tagged VLAN frames at
  1500 payload hit hardware MJS drop
- **Userspace reachable:** Yes — normal bridged/VLAN traffic on affected
  hardware
- **Config:** `ibm,emac-apm821xx` + qca8k DSA conduit (e.g. Meraki MX60)

### Step 5.5: Similar Patterns
**Record:** No similar MJS/VLAN padding elsewhere in emac driver; this
is the only MJS programming site.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code in Tree?
**Record:** **Yes.** Local tree is **Linux 6.18.44**
(`stable/linux-6.18.y`). Buggy line at `core.c:460`:
`EMAC4_RMR_MJS(ndev->mtu)`. Bug present since 2012 APM821xx jumbo
support. Fix commit `0906c117f81c2` is **not** in HEAD.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — `git apply --check` passed with no
conflicts.

### Step 6.3: Related Fixes Already Present?
**Record:** None for this MJS/VLAN issue.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/net/ethernet/ibm/emac` — **PERIPHERAL** driver
(PowerPC APM821xx), but networking correctness on real production
hardware (Meraki MX60).

### Step 7.2: Subsystem Activity
**Record:** Moderately active — recent UAF/NULL-deref fixes in 6.18.y;
DSA conduit infrastructure actively maintained.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of **ibm,emac-apm821xx** (APM821xx SoC) with **qca8k
DSA** conduit and **VLAN-tagged** traffic at standard MTU. Meraki MX60
is a confirmed case. Driver already contains Meraki MX60-specific MDIO
workaround (line 2451).

### Step 8.2: Trigger Conditions
**Record:**
- MTU > 1500 (automatically 1502 with qca8k DSA via
  `dsa_conduit_setup()`)
- VLAN-tagged frames with payload at MTU−4 boundary (1500 bytes with MTU
  1502 conduit overhead accounting)
- **Likelihood:** High on affected configs for standard enterprise VLAN
  usage
- **Unprivileged trigger:** Yes — normal network traffic

### Step 8.3: Failure Mode Severity
**Record:** Silent **packet drops** for VLAN traffic at full MTU. Not a
crash or data corruption, but breaks standard VLAN networking.
**Severity: MEDIUM-HIGH** (functional breakage, silent loss).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores correct VLAN forwarding on affected hardware;
  trivial 3-line fix
- **Risk:** Very low — scoped to APM821xx jumbo path only
- **Ratio:** Strong benefit for affected users, minimal risk

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real user-reported bug (Meraki MX60)
- Silent packet drops on standard VLAN/MTU traffic
- Minimal, obviously correct hardware workaround
- Buggy code and exposure path (DSA conduit MTU bump) both exist in
  6.18.44
- Applies cleanly
- Reviewed on mailing list; maintainer committed
- Falls under hardware quirk/workaround exception

**AGAINST backport:**
- Narrow hardware scope (APM821xx + qca8k DSA)
- Not a regression — latent since 2012
- Paolo routed to net-next as non-regression fix
- Packet drops, not crash/security/corruption

**Unresolved:** No independent Tested-by on target hardware in commit
message.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic matches hardware
   behavior; reviewed on list
2. Fixes real bug affecting users? **PASS** — Meraki MX60 report,
   reproducible symptoms
3. Important issue? **PASS** — silent packet loss on standard VLAN
   traffic (MEDIUM-HIGH)
4. Small and contained? **PASS** — 3 lines, one file
5. No new features/APIs? **PASS** — hardware limit correction only
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception Category
**Record:** Hardware quirk/workaround — EMAC hardware does not account
for VLAN tag in MJS calculation.

### Step 9.4: Decision Rationale

For **Linux 6.18.44**, this fix should be backported. The buggy MJS
programming and the DSA conduit MTU bump that exposes it are both
present. On Meraki MX60-class hardware, standard VLAN traffic at
1500-byte payload is silently dropped — a real, user-visible networking
failure. The fix is a 3-line hardware workaround with verified clean
apply and negligible regression risk. Paolo's net-next routing reflects
that this is not a regression, not that the fix lacks stable merit.

---

## Verification

- [Phase 1] `git show 0906c117f81c2`: parsed subject, tags, body
- [Phase 2] Read diff and `core.c:438-464`: confirmed
  `EMAC4_RMR_MJS(ndev->mtu)` → `+ VLAN_HLEN`
- [Phase 3] `git blame -L 458,461`: buggy code from `ae5d33723e3253`
  (2012)
- [Phase 3] `git merge-base --is-ancestor 0906c117f81c2 HEAD`:
  NOT_IN_HEAD
- [Phase 3] `git apply --check` on `0906c117f81c2`: passes
- [Phase 3] `git describe HEAD` / `make kernelversion`: 6.18.44
- [Phase 4] `b4 dig -c 0906c117f81c2`: found lore thread
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: netdev maintainers CC'd
- [Phase 4] `/tmp/emac_vlan_thread.mbox`: Keller review, Abeni net-next
  rationale
- [Phase 5] `grep emac_iff2rmr`: callers at lines 668, 949
- [Phase 5] Read `net/dsa/conduit.c:419-445`: MTU = `ETH_DATA_LEN +
  dsa_tag_protocol_overhead()`
- [Phase 5] Read `net/dsa/tag_qca.c:118`: `needed_headroom =
  QCA_HDR_LEN` (2)
- [Phase 5] Read `include/linux/if_vlan.h:16`: `VLAN_HLEN = 4`
- [Phase 6] `grep EMAC4_RMR_MJS`: buggy code at `core.c:460`
- [Phase 6] `git merge-base --is-ancestor 6ca80638b90ce HEAD`:
  conduit_in_tree (2023-10-24)
- [Phase 6] `git show 6ca80638b90ce:net/dsa/conduit.c`: MTU bump present
  from introduction
- [Phase 7] `core.c:2869-2872`: APM821xx feature flag assignment
  confirmed
- [Phase 7] `core.c:2451`: existing Meraki MX60 reference in driver

**YES****Verdict: YES** for backport to Linux 6.18.44.

The commit (`0906c117f81c2` on `all-next`) pads the IBM EMAC APM821xx
MJS limit by `VLAN_HLEN` so VLAN-tagged full-MTU frames aren’t dropped.
It isn’t in the current 6.18.y tree yet, but the buggy code and the
qca8k DSA conduit MTU bump that exposes it are both present, and the
patch applies cleanly.

Worth backporting: small hardware workaround for a real Meraki MX60 bug
(silent VLAN packet loss at 1500-byte payload).

 drivers/net/ethernet/ibm/emac/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index e1047915e101e..f48568140480e 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -30,6 +30,7 @@
 #include <linux/skbuff.h>
 #include <linux/crc32.h>
 #include <linux/ethtool.h>
+#include <linux/if_vlan.h>
 #include <linux/mii.h>
 #include <linux/bitops.h>
 #include <linux/of.h>
@@ -457,7 +458,7 @@ static inline u32 emac_iff2rmr(struct net_device *ndev)
 
 	if (emac_has_feature(dev, EMAC_APM821XX_REQ_JUMBO_FRAME_SIZE)) {
 		r &= ~EMAC4_RMR_MJS_MASK;
-		r |= EMAC4_RMR_MJS(ndev->mtu);
+		r |= EMAC4_RMR_MJS(ndev->mtu + VLAN_HLEN);
 	}
 
 	return r;
-- 
2.53.0

