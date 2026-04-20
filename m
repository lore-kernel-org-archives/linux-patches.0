Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6848D48AE0A;
	Mon, 20 Apr 2026 13:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691916; cv=none; b=KtNDIRSK/f2+uzWaI4EvFS8cqtDWfugHLfHc2OJxigqc7hkyeTd0pWXYRwhqa4ouPh2G9qIHcdIlgkqZLuUDANpNoB7Afz5mM/HzQvOVsi5VEOV4SpDMQoescp96Crx3LuS7y/9WPkUJP5LuQcWXfqzGRxUcT5bRgNBLolMrSKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691916; c=relaxed/simple;
	bh=8ew+j/NqZEznH8DJZaI17gxPsIofwwyece4AdOhuLks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZSLMjhXBgmQoxvtrMFpSg+CZLhu0Vrp/uZl3u7PuJHK7nAZm6blsQvsDijapE1BK5b1N8U+RiCgmxeYPo/mB/st394dy+DbiQDe/F/I5xS0z0bmeXdv6yaAbftaUdiQdRPGdtcZzuAhLBQC5K2OsZIpatlUFwLBnuXb3byIQzIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmFiGjAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmFiGjAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBD7C2BCB6;
	Mon, 20 Apr 2026 13:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691916;
	bh=8ew+j/NqZEznH8DJZaI17gxPsIofwwyece4AdOhuLks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmFiGjAAag0cugVbSxwAfKwxVOdz0PvUcc7BLdXcpFKq8iyqJAbZpDIP1KGyBFed3
	 pXAetP5rvJng50SDVx0uh8rJF43wjC/4r0fkEJ/0JPZ+Bs3MD36shNGstXQhfFhJZA
	 Pab3bnrHaxupQlnoQDqLzEwshAe8Np3XEaXlhpnoHhEi2icInNyPw8tNSdMXhSj2mJ
	 A7Ww1vJLyQiFUB3kTOYer0W7xuDtWGoW/7K/D4nmlpcONF91oMSAbefpSj3lDIV+WT
	 OLErILZDY8d5gKMVRplpt09/CNS3vautRwWCmpdKNC6yxsI/M6pljUzGgW/ZYAx8Xo
	 xcTVb+GBKRzzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mashiro Chen <mashiro.chen@mailbox.org>,
	Joerg Reuter <jreuter@yaina.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] net: hamradio: bpqether: validate frame length in bpq_rcv()
Date: Mon, 20 Apr 2026 09:21:01 -0400
Message-ID: <20260420132314.1023554-267-sashal@kernel.org>
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

From: Mashiro Chen <mashiro.chen@mailbox.org>

[ Upstream commit 6183bd8723a3eecd2d89cbc506fe938bc6288345 ]

The BPQ length field is decoded as:

  len = skb->data[0] + skb->data[1] * 256 - 5;

If the sender sets bytes [0..1] to values whose combined value is
less than 5, len becomes negative.  Passing a negative int to
skb_trim() silently converts to a huge unsigned value, causing the
function to be a no-op.  The frame is then passed up to AX.25 with
its original (untrimmed) payload, delivering garbage beyond the
declared frame boundary.

Additionally, a negative len corrupts the 64-bit rx_bytes counter
through implicit sign-extension.

Add a bounds check before pulling the length bytes: reject frames
where len is negative or exceeds the remaining skb data.

Acked-by: Joerg Reuter <jreuter@yaina.de>
Signed-off-by: Mashiro Chen <mashiro.chen@mailbox.org>
Link: https://patch.msgid.link/20260409024927.24397-2-mashiro.chen@mailbox.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information I need. Let me compile the complete
analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `net: hamradio: bpqether`
- Action verb: "validate" — implies adding a missing safety check (a bug
  fix)
- Summary: Add bounds checking to the frame length parsing in
  `bpq_rcv()`
Record: [net/hamradio/bpqether] [validate] [Add missing frame length
bounds check in receive path]

**Step 1.2: Tags**
- `Acked-by: Joerg Reuter <jreuter@yaina.de>` — Joerg Reuter IS the
  hamradio subsystem maintainer (confirmed from MODULE_AUTHOR)
- `Signed-off-by: Mashiro Chen <mashiro.chen@mailbox.org>` — patch
  author
- `Link: https://patch.msgid.link/20260409024927.24397-2-
  mashiro.chen@mailbox.org` — lore reference
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` — netdev maintainer
  applied it
- IMPORTANT: The original submission (from the mbox) includes `Cc:
  stable@vger.kernel.org` which was stripped during merge
Record: Acked by subsystem maintainer. Originally Cc'd to stable.
Applied by netdev maintainer.

**Step 1.3: Commit Body**
The bug mechanism is clearly described:
- `len = skb->data[0] + skb->data[1] * 256 - 5` can produce a negative
  value if bytes [0..1] sum to < 5
- Passing negative `int` to `skb_trim(unsigned int)` produces a huge
  unsigned value, making it a no-op
- Frame is delivered to AX.25 with untrimmed garbage payload
- Negative `len` also corrupts the 64-bit `rx_bytes` counter via
  implicit sign-extension
Record: Bug is clearly described with specific mechanism. Two distinct
problems: garbage data delivery and stats corruption.

**Step 1.4: Hidden Bug Fix**
This is explicitly a validation/bug fix — "validate" means adding a
missing safety check.
Record: Not hidden — explicitly a bug fix adding missing input
validation.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file modified: `drivers/net/hamradio/bpqether.c`
- +3 lines added, 0 removed
- Function modified: `bpq_rcv()`
- Scope: single-file surgical fix
Record: [1 file, +3 lines, bpq_rcv()] [Minimal single-file fix]

**Step 2.2: Code Flow Change**
The single hunk inserts a bounds check after the length calculation:

```190:192:drivers/net/hamradio/bpqether.c
        if (len < 0 || len > skb->len - 2)
                goto drop_unlock;
```

- BEFORE: `len` is calculated and used unconditionally — negative `len`
  passes through
- AFTER: Negative or oversized `len` causes the frame to be dropped
- This is on the data receive path (normal path for incoming frames)
Record: [Before: no validation on computed len → After: reject frames
with invalid len]

**Step 2.3: Bug Mechanism**
Category: **Logic/correctness fix + type conversion bug**
- `len` is `int` (line 152), computed from untrusted network data
- `skb_trim()` takes `unsigned int len` (confirmed from header: `void
  skb_trim(struct sk_buff *skb, unsigned int len)`)
- Negative `int` → huge `unsigned int` → `skb->len > len` is false → no
  trimming occurs
- `dev->stats.rx_bytes += len` with negative `len` corrupts stats via
  sign extension to 64-bit

The fix also checks `len > skb->len - 2` to reject frames claiming more
data than present (the `-2` accounts for the 2 length bytes about to be
pulled).
Record: [Type conversion bug causing no-op trim + stats corruption. Fix
adds proper bounds check.]

**Step 2.4: Fix Quality**
- Obviously correct: a bounds check of `len < 0 || len > skb->len - 2`
  before using `len`
- Minimal/surgical: 3 lines in one location
- No regression risk: rejecting invalid frames cannot harm valid
  operation
- Uses existing `drop_unlock` error path (already well-tested)
Record: [Clearly correct, minimal, no regression risk]

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
The buggy line (`len = skb->data[0] + skb->data[1] * 256 - 5`) dates to
commit `1da177e4c3f41` — Linus Torvalds' initial Linux import
(2005-04-16). This code has been present in every Linux version ever
released.
Record: [Bug present since initial Linux git commit — affects ALL stable
trees]

**Step 3.2: Fixes Tag**
No explicit `Fixes:` tag. The buggy code predates git history.
Record: [N/A — bug predates git history, all stable trees affected]

**Step 3.3: File History**
Recent changes to `bpqether.c` are all unrelated refactoring (lockdep,
netdev_features, dev_addr_set). None touch the `bpq_rcv()` length
parsing logic. The function `bpq_rcv` hasn't been meaningfully modified
in its length handling since the initial commit.
Record: [No related changes or prerequisites. Standalone fix.]

**Step 3.4: Author**
Mashiro Chen appears to be a contributor fixing input validation issues
(this series fixes two hamradio drivers). The patch was Acked by Joerg
Reuter (subsystem maintainer) and applied by Jakub Kicinski (netdev
maintainer).
Record: [Contributor fix, but Acked by subsystem maintainer and applied
by netdev maintainer — high confidence]

**Step 3.5: Dependencies**
This is patch 1/2 in a series, but both patches are independent
(different files: `bpqether.c` vs `scc.c`). No dependencies.
Record: [Self-contained, no dependencies. Applies standalone.]

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original Discussion**
From the b4 am output, the thread at
`20260409024927.24397-1-mashiro.chen@mailbox.org` contains 5 messages.
This is v2; the change between v1 and v2 for bpqether was only "add
Acked-by: Joerg Reuter" (no code change).

Critical finding from the mbox: **The original patch included `Cc:
stable@vger.kernel.org`**, indicating the author explicitly nominated it
for stable. This tag was stripped during the merge process (common
netdev practice).
Record: [Original submission Cc'd to stable. v2 adds only Acked-by.
Acked by subsystem maintainer.]

**Step 4.2: Reviewers**
- Acked-by: Joerg Reuter (hamradio subsystem maintainer)
- Applied by: Jakub Kicinski (netdev co-maintainer)
- CC'd to linux-hams mailing list
Record: [Reviewed by the right people]

**Step 4.3-4.5: Bug Report / Stable Discussion**
No external bug report referenced. This appears to be found by code
inspection. The author explicitly Cc'd stable.
Record: [Found by code inspection, author nominated for stable]

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
Only `bpq_rcv()`.

**Step 5.2: Callers**
`bpq_rcv` is registered as a packet_type handler via
`bpq_packet_type.func = bpq_rcv` (line 93). It is called by the kernel
networking stack for every incoming BPQ ethernet frame (`ETH_P_BPQ`).
This is the main receive path for the driver.
Record: [Called by kernel network stack on every incoming BPQ frame]

**Step 5.3-5.4: Call Chain**
The receive path: network driver → netif_receive_skb → protocol dispatch
→ `bpq_rcv()` → ax25_type_trans → netif_rx.
Any BPQ frame arriving on the network can trigger this. No special
privileges needed to send a malformed Ethernet frame on a local network.
Record: [Reachable from any incoming network frame — attack surface for
local network]

**Step 5.5: Similar Patterns**
The second patch in the series fixes a similar input validation issue in
`scc.c`, suggesting systematic review of hamradio drivers.
Record: [Systematic validation audit by author]

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Code Exists in Stable?**
Yes. The buggy code (line 188: `len = skb->data[0] + skb->data[1] * 256
- 5`) has been present since the initial commit and exists in ALL stable
trees. The changes since v5.4 and v6.1 to this file are all unrelated
refactoring that don't touch the `bpq_rcv()` length logic.
Record: [Bug exists in ALL stable trees from v5.4 through v7.0]

**Step 6.2: Backport Complications**
None. The surrounding code in `bpq_rcv()` is essentially unchanged. The
fix is a 3-line insertion with no context dependencies on recent
changes.
Record: [Clean apply expected to all stable trees]

**Step 6.3: Related Fixes Already in Stable**
No prior fix for this issue exists.
Record: [No prior fix]

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
- Path: `drivers/net/hamradio/` — Amateur (ham) radio networking driver
- Criticality: PERIPHERAL (niche driver for ham radio enthusiasts)
- However: it processes network frames and the bug is a missing input
  validation — security relevance
Record: [Peripheral subsystem, but network input validation issue gives
it security relevance]

**Step 7.2: Activity**
The file has had minimal changes. Mature, stable code that rarely gets
touched.
Record: [Very mature code — bug has been present for ~20 years]

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who Is Affected**
Users of the BPQ (AX.25-over-Ethernet) hamradio protocol. While niche,
these are real users.
Record: [Driver-specific: ham radio BPQ users]

**Step 8.2: Trigger Conditions**
- Any malformed BPQ frame with length field < 5 triggers the bug
- Can be triggered by any device on the local Ethernet segment (no
  privileges needed)
- Reliably reproducible — no race condition
Record: [Triggered by malformed network frame from local network,
reliably reproducible, no auth needed]

**Step 8.3: Failure Mode**
- Garbage data delivered to AX.25 protocol — potential info leak /
  protocol confusion
- Stats counter corruption (rx_bytes goes wildly negative)
- Severity: MEDIUM-HIGH (garbage data delivery from network, potential
  security implication)
Record: [Garbage data delivery + stats corruption. Severity: MEDIUM-
HIGH]

**Step 8.4: Risk-Benefit**
- BENEFIT: Prevents garbage data delivery and counter corruption from
  malformed frames. Has been broken for 20 years.
- RISK: Extremely low. 3-line bounds check using existing `drop_unlock`
  path. Obviously correct.
Record: [High benefit, very low risk. Excellent ratio.]

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Compilation**

FOR backporting:
- Fixes a real input validation bug present since the initial Linux
  commit
- 3-line surgical fix — minimal risk
- Obviously correct bounds check
- Acked by subsystem maintainer (Joerg Reuter)
- Applied by netdev co-maintainer (Jakub Kicinski)
- Author explicitly Cc'd stable@vger.kernel.org in original submission
- Prevents garbage data delivery to AX.25 from malformed frames
- Prevents stats counter corruption
- Will apply cleanly to all stable trees
- No dependencies, self-contained

AGAINST backporting:
- Niche driver (ham radio) — limited user base
- No crash/panic, "only" garbage data and stats corruption

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — trivial bounds check, Acked
   by maintainer
2. Fixes a real bug? **YES** — garbage data delivery + counter
   corruption
3. Important issue? **YES** — input validation on network data
   (security-adjacent)
4. Small and contained? **YES** — 3 lines, 1 file
5. No new features/APIs? **YES** — pure bug fix
6. Applies to stable? **YES** — code unchanged since initial commit

**Step 9.3: Exception Categories**
Not an exception category — this is a standard bug fix.

**Step 9.4: Decision**
This is a textbook stable backport: small, obviously correct input
validation fix for network-facing code, Acked by subsystem maintainer,
explicitly nominated for stable by author, fixes a 20-year-old bug.

## Verification

- [Phase 1] Parsed tags: Acked-by Joerg Reuter, Link to
  patch.msgid.link, SOB from Jakub Kicinski
- [Phase 2] Diff analysis: +3 lines adding bounds check in `bpq_rcv()`
  before `skb_trim`/`skb_pull`
- [Phase 2] Confirmed `skb_trim()` takes `unsigned int len`
  (include/linux/skbuff.h:3321)
- [Phase 3] git blame: buggy code from commit 1da177e4c3f41 (Linus
  initial, 2005-04-16), present in all stable trees
- [Phase 3] git log: no recent changes touch the length handling in
  bpq_rcv()
- [Phase 4] b4 am: found original thread, 5 messages, v2 series with 2
  patches
- [Phase 4] Read mbox: original submission includes `Cc:
  stable@vger.kernel.org` (line 28 of mbx)
- [Phase 4] Cover letter: v2 changes for bpqether are "no code change;
  add Acked-by"
- [Phase 5] bpq_rcv registered as packet_type handler, called on every
  incoming BPQ frame
- [Phase 6] Code exists in all active stable trees (v5.4+), no
  divergence in affected lines
- [Phase 6] Clean apply expected — surrounding code unchanged
- [Phase 8] Failure mode: garbage data to AX.25 + counter corruption,
  severity MEDIUM-HIGH

**YES**

 drivers/net/hamradio/bpqether.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 045c5177262ea..214fd1f819a1b 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -187,6 +187,9 @@ static int bpq_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_ty
 
 	len = skb->data[0] + skb->data[1] * 256 - 5;
 
+	if (len < 0 || len > skb->len - 2)
+		goto drop_unlock;
+
 	skb_pull(skb, 2);	/* Remove the length bytes */
 	skb_trim(skb, len);	/* Set the length of the data */
 
-- 
2.53.0

