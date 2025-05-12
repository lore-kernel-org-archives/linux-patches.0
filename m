Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5A5297A64;
	Mon, 12 May 2025 18:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073050; cv=none; b=SmuT7X5cOXFxAkwtatS6cBSieeyNvsA94P11mjXDXKKfBwrknX8qxBxXowUjeHvo9kEF5FobE/g1ZRpyQiWtxGzPVH/NJrn1SNBula0o0qAwP+iuRvQsjgLpL0/KE+DLMWyIAYA9L/r1Hzxpq97BFqohRIo2+7J8bRUTmhhE+d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073050; c=relaxed/simple;
	bh=KTCTNddeHNcmSRUBzdv+55+85RQDahMaHZvsfCAXfCI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O4WBePEomzNzhb6/6a4/g0GTgdRUEYvRLr4U7tFnhU7We9q5lhdoGpatt392ixZA4HqKxAObjkpM4bjWcIn8CUXcmHMI7QQ2/bR23AYRdx3bPStULIq8cn0z9VQrfKjzXvSNBcdXm/qkKYmbmr+9g3s/sO2RjJA0YroroK/+vHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qXjXM7k/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qXjXM7k/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F39EC4CEF0;
	Mon, 12 May 2025 18:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747073049;
	bh=KTCTNddeHNcmSRUBzdv+55+85RQDahMaHZvsfCAXfCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXjXM7k/xecgvGL2CxwS2xwb/BScLmWKbAE+bIOpggB+THNKfrPQq580hRftcXCzW
	 RiT13+1l/zN0fVAfxHkefZCh1oq8Xhxq6AgGpoMdoJrbxfzXagLDDDCfaNCQ17ywMF
	 N+6eHlyOE+jHB4zHWhEoAyzwUTAGZ0iiVDWoaR7CM4D+QAtrPJzsCqKBx3oD/c8h+S
	 gEtHOHuhsbMwnmlZlxPY2p4+V26MXlp2ouwX4iOKrdsWpm4WKuOCtB+HGH/fXlXu2H
	 fV+fRU1eB5vMqNSG1GB5L4+ayL3t12+cDGlZcpW/cbgZBJQOzycHORqAhsrdc0toJA
	 vf7KFBvBRpEIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michal Pecio <michal.pecio@gmail.com>,
	Jonathan Bell <jonathan@raspberrypi.org>,
	Oliver Neukum <oneukum@suse.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 08/15] usb: xhci: Don't trust the EP Context cycle bit when moving HW dequeue
Date: Mon, 12 May 2025 14:03:43 -0400
Message-Id: <20250512180352.437356-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250512180352.437356-1-sashal@kernel.org>
References: <20250512180352.437356-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.6
Content-Transfer-Encoding: 8bit

From: Michal Pecio <michal.pecio@gmail.com>

[ Upstream commit 6328bdc988d23201c700e1e7e04eb05a1149ac1e ]

VIA VL805 doesn't bother updating the EP Context cycle bit when the
endpoint halts. This is seen by patching xhci_move_dequeue_past_td()
to print the cycle bits of the EP Context and the TRB at hw_dequeue
and then disconnecting a flash drive while reading it. Actual cycle
state is random as expected, but the EP Context bit is always 1.

This means that the cycle state produced by this function is wrong
half the time, and then the endpoint stops working.

Work around it by looking at the cycle bit of TD's end_trb instead
of believing the Endpoint or Stream Context. Specifically:

- rename cycle_found to hw_dequeue_found to avoid confusion
- initialize new_cycle from td->end_trb instead of hw_dequeue
- switch new_cycle toggling to happen after end_trb is found

Now a workload which regularly stalls the device works normally for
a few hours and clearly demonstrates the HW bug - the EP Context bit
is not updated in a new cycle until Set TR Dequeue overwrites it:

[  +0,000298] sd 10:0:0:0: [sdc] Attached SCSI disk
[  +0,011758] cycle bits: TRB 1 EP Ctx 1
[  +5,947138] cycle bits: TRB 1 EP Ctx 1
[  +0,065731] cycle bits: TRB 0 EP Ctx 1
[  +0,064022] cycle bits: TRB 0 EP Ctx 0
[  +0,063297] cycle bits: TRB 0 EP Ctx 0
[  +0,069823] cycle bits: TRB 0 EP Ctx 0
[  +0,063390] cycle bits: TRB 1 EP Ctx 0
[  +0,063064] cycle bits: TRB 1 EP Ctx 1
[  +0,062293] cycle bits: TRB 1 EP Ctx 1
[  +0,066087] cycle bits: TRB 0 EP Ctx 1
[  +0,063636] cycle bits: TRB 0 EP Ctx 0
[  +0,066360] cycle bits: TRB 0 EP Ctx 0

Also tested on the buggy ASM1042 which moves EP Context dequeue to
the next TRB after errors, one problem case addressed by the rework
that implemented this loop. In this case hw_dequeue can be enqueue,
so simply picking the cycle bit of TRB at hw_dequeue wouldn't work.

Commit 5255660b208a ("xhci: add quirk for host controllers that
don't update endpoint DCS") tried to solve the stale cycle problem,
but it was more complex and got reverted due to a reported issue.

Cc: Jonathan Bell <jonathan@raspberrypi.org>
Cc: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250505125630.561699-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 5a0e361818c27..14b6fd91a7404 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -643,7 +643,7 @@ static int xhci_move_dequeue_past_td(struct xhci_hcd *xhci,
 	int new_cycle;
 	dma_addr_t addr;
 	u64 hw_dequeue;
-	bool cycle_found = false;
+	bool hw_dequeue_found = false;
 	bool td_last_trb_found = false;
 	u32 trb_sct = 0;
 	int ret;
@@ -659,25 +659,24 @@ static int xhci_move_dequeue_past_td(struct xhci_hcd *xhci,
 	hw_dequeue = xhci_get_hw_deq(xhci, dev, ep_index, stream_id);
 	new_seg = ep_ring->deq_seg;
 	new_deq = ep_ring->dequeue;
-	new_cycle = hw_dequeue & 0x1;
+	new_cycle = le32_to_cpu(td->end_trb->generic.field[3]) & TRB_CYCLE;
 
 	/*
-	 * We want to find the pointer, segment and cycle state of the new trb
-	 * (the one after current TD's end_trb). We know the cycle state at
-	 * hw_dequeue, so walk the ring until both hw_dequeue and end_trb are
-	 * found.
+	 * Walk the ring until both the next TRB and hw_dequeue are found (don't
+	 * move hw_dequeue back if it went forward due to a HW bug). Cycle state
+	 * is loaded from a known good TRB, track later toggles to maintain it.
 	 */
 	do {
-		if (!cycle_found && xhci_trb_virt_to_dma(new_seg, new_deq)
+		if (!hw_dequeue_found && xhci_trb_virt_to_dma(new_seg, new_deq)
 		    == (dma_addr_t)(hw_dequeue & ~0xf)) {
-			cycle_found = true;
+			hw_dequeue_found = true;
 			if (td_last_trb_found)
 				break;
 		}
 		if (new_deq == td->end_trb)
 			td_last_trb_found = true;
 
-		if (cycle_found && trb_is_link(new_deq) &&
+		if (td_last_trb_found && trb_is_link(new_deq) &&
 		    link_trb_toggles_cycle(new_deq))
 			new_cycle ^= 0x1;
 
@@ -689,7 +688,7 @@ static int xhci_move_dequeue_past_td(struct xhci_hcd *xhci,
 			return -EINVAL;
 		}
 
-	} while (!cycle_found || !td_last_trb_found);
+	} while (!hw_dequeue_found || !td_last_trb_found);
 
 	/* Don't update the ring cycle state for the producer (us). */
 	addr = xhci_trb_virt_to_dma(new_seg, new_deq);
-- 
2.39.5

