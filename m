Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762322765ED;
	Wed, 10 Dec 2025 06:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765348512; cv=none; b=fvaj10z5ip1YqwpKBRxDdek3eh8ihZB+m6BJ4d0hvaNs66zq9qg704n59QegKi75syHnc3plV4HFT/PBJcbIoF72Akw3zqscKvgk1YbOyHKZv0x/tRnaW1bOQ1Sen3G+jGFP9hBN1Xv8ZsSsZlYn3frA1yrgIZTxwRVIRZ1A4k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765348512; c=relaxed/simple;
	bh=rgFkTHqO82auohP6XdbN3mzAXw0NxrdMgjtUOuJNaGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gt970jJ5m6AlXSvWPPXMEorMefVH3QH3oF753lVWfZ/B6VXS10Pqfpmh/4DVJZrCUacnhyU3hv7zMV3gUJwWwfWIfJyaA+hlQUlIpq3XB+0VGUTA8ojR8FQStz33hMYnZW3+bk6tUqzcL/UEO4ceJmkEDKGfMTcqiOOHcVu6zEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tBPpplOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tBPpplOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92A4C4CEF1;
	Wed, 10 Dec 2025 06:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765348512;
	bh=rgFkTHqO82auohP6XdbN3mzAXw0NxrdMgjtUOuJNaGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBPpplOzvwr2+he2d7OW/hvbfaWqD9K8262Lv8nKVpHbFHTWzqXTvbKEeKZJqSzsx
	 5rPf67FLuuDo+7tWTMVjLarL3/8a+/MGOiv9yduMvl2qDA2yHvCAiShWPEWtQTvD1O
	 sb9/9D9PcR8iZpvaNQclJGMg/eSGDBPaf99lR8cJYvPuYy/Dr8jSh+s78arGYOZD/2
	 tHqI43nP8B0cBnu4+Y22y7HsmLmjdTSAu9uioMOV4queosxS2Kizyu/D+yhSyCUMIg
	 26h0VKG8Ukl5R0BBxSem8B5rNJ1KxY5VGAX4+APn8g79AhZQBS+oxOtIGM4RK23aWO
	 +bS3QAGgauKoA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.17] usb: xhci: Don't unchain link TRBs on quirky HCs
Date: Wed, 10 Dec 2025 01:34:35 -0500
Message-ID: <20251210063446.2513466-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210063446.2513466-1-sashal@kernel.org>
References: <20251210063446.2513466-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Pecio <michal.pecio@gmail.com>

[ Upstream commit e6aec6d9f5794e85d2312497a5d81296d885090e ]

Some old HCs ignore transfer ring link TRBs whose chain bit is unset.
This breaks endpoint operation and sometimes makes it execute other
ring's TDs, which may corrupt their buffers or cause unwanted device
action. We avoid this by chaining all link TRBs on affected rings.

Fix an omission which allows them to be unchained by cancelling TDs.

The patch was tested by reproducing this condition on an isochronous
endpoint (non-power-of-two TDs are sometimes split not to cross 64K)
and printing link TRBs in trb_to_noop() on good and buggy HCs.

Actual hardware malfunction is rare since it requires Missed Service
Error shortly before the unchained link TRB, at least on NEC and AMD.
I have never seen it after commit bb0ba4cb1065 ("usb: xhci: Apply the
link chain quirk on NEC isoc endpoints"), but it's Russian roulette
and I can't test all affected hosts and workloads. Fairly often MSEs
happen after cancellation because the endpoint was stopped.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20251119142417.2820519-11-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Comprehensive Analysis

### 1. Commit Message Analysis

**Subject**: "usb: xhci: Don't unchain link TRBs on quirky HCs"

The commit message clearly describes a **hardware bug fix**:
- Some old xHCI HCs "ignore transfer ring link TRBs whose chain bit is
  unset"
- This "breaks endpoint operation and sometimes makes it execute other
  ring's TDs"
- Can "corrupt their buffers or cause unwanted device action"

**Key signals**:
- ❌ No `Cc: stable@vger.kernel.org` tag
- ❌ No explicit `Fixes:` tag
- ✅ References related fix commit `bb0ba4cb1065` for context
- ✅ Well-documented testing methodology
- ✅ Sign-offs from xHCI maintainer (Mathias Nyman) and USB maintainer
  (Greg Kroah-Hartman)

### 2. Code Change Analysis

The change is **small and surgical**:

1. **`trb_to_noop()` modification**: Adds an `unchain_links` parameter -
   only unchain link TRBs when `unchain_links=true`

2. **`td_to_noop()` modification**:
   - Now takes `xhci` and `ep` parameters
   - Checks `xhci_link_chain_quirk()` to determine if unchaining is safe
   - Only unchains on HCs without the quirk

3. **Call sites updated**: 5 call sites properly pass the new parameters

**Technical mechanism**: On quirky HCs, when TDs are cancelled and
converted to no-ops, link TRBs were being unchained unconditionally. The
quirky HCs then ignored these unchained link TRBs, causing the HC to
continue past the segment boundary and potentially execute other rings'
TRBs.

### 3. Dependency Analysis

**Critical dependency**: The fix uses `xhci_link_chain_quirk()`:
- Introduced in commit 7476a2215c077 (June 2024)
- First available in **v6.11** and later

This limits clean backporting to **6.11+ stable trees** only. Older LTS
trees (6.6.y, 6.1.y, 5.15.y) would require adaptation.

### 4. Scope and Risk Assessment

| Factor | Assessment |
|--------|------------|
| Lines changed | ~30 net lines in one file |
| Files touched | 1 (drivers/usb/host/xhci-ring.c) |
| Complexity | Low - adds conditional check |
| Regression risk | **Very Low** - only affects HCs with quirk |

### 5. User Impact

- **Affected hardware**: Older NEC, AMD 0x96 xHCI controllers
- **Severity**: Data corruption, endpoint malfunction
- **Trigger**: TD cancellation (relatively common operation)
- **Author's note**: "Actual hardware malfunction is rare" but
  acknowledges "it's Russian roulette"

### 6. Classification

- ✅ Bug fix (hardware quirk handling omission)
- ✅ Not a new feature
- ✅ Uses existing quirk infrastructure
- ✅ Affects specific hardware with known quirks

### 7. Stable Criteria Evaluation

| Criterion | Met? |
|-----------|------|
| Obviously correct | ✅ Uses existing quirk logic correctly |
| Fixes real bug | ✅ Data corruption/hardware malfunction |
| Small scope | ✅ One file, surgical change |
| No new features | ✅ Fixes existing functionality |
| Already in mainline | ✅ Yes |
| Testable | ✅ Author tested on good/buggy HCs |

### Risk vs Benefit

**Benefits**:
- Prevents data corruption on quirky HCs
- Prevents USB endpoint malfunction
- Low regression risk (only affects quirky HCs)

**Risks**:
- Minimal - change is conditional
- No explicit stable tag from maintainers

### Concerns

1. **No stable tag**: The maintainers didn't explicitly request stable
   backport, possibly:
   - Oversight
   - Wanting it to bake in mainline first
   - Considering the bug "rare" enough

2. **Dependency on 6.11+ infrastructure**: Clean backport limited to
   6.11+ stable trees

### Conclusion

This commit fixes a legitimate hardware bug that can cause **data
corruption** and **USB endpoint malfunction** on older xHCI controllers.
The fix is:
- Small and surgical
- Uses existing, tested quirk infrastructure
- Low risk of regression
- Well-tested by the author
- Properly reviewed and signed off by maintainers

The lack of explicit stable tags is concerning but doesn't disqualify it
- the fix clearly addresses a real hardware issue. For stable trees 6.11
and later where the helper function exists, this is a good backport
candidate.

**YES**

 drivers/usb/host/xhci-ring.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 5bdcf9ab2b99d..25185552287c0 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -128,11 +128,11 @@ static void inc_td_cnt(struct urb *urb)
 	urb_priv->num_tds_done++;
 }
 
-static void trb_to_noop(union xhci_trb *trb, u32 noop_type)
+static void trb_to_noop(union xhci_trb *trb, u32 noop_type, bool unchain_links)
 {
 	if (trb_is_link(trb)) {
-		/* unchain chained link TRBs */
-		trb->link.control &= cpu_to_le32(~TRB_CHAIN);
+		if (unchain_links)
+			trb->link.control &= cpu_to_le32(~TRB_CHAIN);
 	} else {
 		trb->generic.field[0] = 0;
 		trb->generic.field[1] = 0;
@@ -465,7 +465,7 @@ static void xhci_handle_stopped_cmd_ring(struct xhci_hcd *xhci,
 		xhci_dbg(xhci, "Turn aborted command %p to no-op\n",
 			 i_cmd->command_trb);
 
-		trb_to_noop(i_cmd->command_trb, TRB_CMD_NOOP);
+		trb_to_noop(i_cmd->command_trb, TRB_CMD_NOOP, false);
 
 		/*
 		 * caller waiting for completion is called when command
@@ -797,13 +797,18 @@ static int xhci_move_dequeue_past_td(struct xhci_hcd *xhci,
  * (The last TRB actually points to the ring enqueue pointer, which is not part
  * of this TD.)  This is used to remove partially enqueued isoc TDs from a ring.
  */
-static void td_to_noop(struct xhci_td *td, bool flip_cycle)
+static void td_to_noop(struct xhci_hcd *xhci, struct xhci_virt_ep *ep,
+			struct xhci_td *td, bool flip_cycle)
 {
+	bool unchain_links;
 	struct xhci_segment *seg	= td->start_seg;
 	union xhci_trb *trb		= td->start_trb;
 
+	/* link TRBs should now be unchained, but some old HCs expect otherwise */
+	unchain_links = !xhci_link_chain_quirk(xhci, ep->ring ? ep->ring->type : TYPE_STREAM);
+
 	while (1) {
-		trb_to_noop(trb, TRB_TR_NOOP);
+		trb_to_noop(trb, TRB_TR_NOOP, unchain_links);
 
 		/* flip cycle if asked to */
 		if (flip_cycle && trb != td->start_trb && trb != td->end_trb)
@@ -1091,16 +1096,16 @@ static int xhci_invalidate_cancelled_tds(struct xhci_virt_ep *ep)
 						  "Found multiple active URBs %p and %p in stream %u?\n",
 						  td->urb, cached_td->urb,
 						  td->urb->stream_id);
-					td_to_noop(cached_td, false);
+					td_to_noop(xhci, ep, cached_td, false);
 					cached_td->cancel_status = TD_CLEARED;
 				}
-				td_to_noop(td, false);
+				td_to_noop(xhci, ep, td, false);
 				td->cancel_status = TD_CLEARING_CACHE;
 				cached_td = td;
 				break;
 			}
 		} else {
-			td_to_noop(td, false);
+			td_to_noop(xhci, ep, td, false);
 			td->cancel_status = TD_CLEARED;
 		}
 	}
@@ -1125,7 +1130,7 @@ static int xhci_invalidate_cancelled_tds(struct xhci_virt_ep *ep)
 				continue;
 			xhci_warn(xhci, "Failed to clear cancelled cached URB %p, mark clear anyway\n",
 				  td->urb);
-			td_to_noop(td, false);
+			td_to_noop(xhci, ep, td, false);
 			td->cancel_status = TD_CLEARED;
 		}
 	}
@@ -4273,7 +4278,7 @@ static int xhci_queue_isoc_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 	 */
 	urb_priv->td[0].end_trb = ep_ring->enqueue;
 	/* Every TRB except the first & last will have its cycle bit flipped. */
-	td_to_noop(&urb_priv->td[0], true);
+	td_to_noop(xhci, xep, &urb_priv->td[0], true);
 
 	/* Reset the ring enqueue back to the first TRB and its cycle bit. */
 	ep_ring->enqueue = urb_priv->td[0].start_trb;
-- 
2.51.0

