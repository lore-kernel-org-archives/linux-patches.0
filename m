Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7A51E7658;
	Tue, 15 Oct 2024 11:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993355; cv=none; b=vEVi2Y+fN/icCfq3c7JO5PovYWf68Lk2aJfz26HDQTv7yUmMCY6g8kSxAup6uTYmL+cqjM6miinAAMnaJli3Aj1Ulbb5qESBquWmu9dLlDBsnY0eXQ4j7nUY+S5nbtQoxD9NRIDaEeF5vFwFBaZQ0JhpV+H+pWqJZbEeQmhwf6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993355; c=relaxed/simple;
	bh=UTQjGs9EdbBt7BoURQWmAxT/ZC3LZYuCv7EUv1ey53k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSb0c0aAXNoi5OBKhhp+ByqWMtPawpwygxwBxwin0IBXdh1Ldt2JgabGjfg5GM90ZWa3n/XYeLRIjTqEQKd+rdQgxm0AFb/BQYMxk/XmSs6rbdnjpqYDHo+IHeM3riEpj9S9wEnx8IgwagWUFAaajxZiggw4AZjT8oz8+bQSMzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zaDQxIKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zaDQxIKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E2DC4CECF;
	Tue, 15 Oct 2024 11:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993355;
	bh=UTQjGs9EdbBt7BoURQWmAxT/ZC3LZYuCv7EUv1ey53k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zaDQxIKmJNNNTj98vdsnmThToZHlTQeHQlDRBwz+SybiEUtz6asj+SCpzGYUo1eMb
	 VSwpFtR/+ct9xSsBUoYwq6wWAde3gTQHegJ9QBOOEZcLhejx2tyWnZZmsgyuea3Ahr
	 risSVda1xXpyKGwA2AKFZy27DKGHint3vUGYX3tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 355/691] xhci: remove xhci_test_trb_in_td_math early development check
Date: Tue, 15 Oct 2024 13:25:03 +0200
Message-ID: <20241015112454.435146643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 54f9927dfe2266402a226d5f51d38236bdca0590 ]

Time to remove this test trb in td math check that was added
in early stage of xhci driver development.

It verified that the size, alignment and boundaries of the event and
command rings allocated by the driver itself are correct.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230202150505.618915-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: e5fa8db0be3e ("usb: xhci: fix loss of data on Cadence xHC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c | 160 ------------------------------------
 1 file changed, 160 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 1ab3571b882e3..5b5b8ac28e746 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1941,164 +1941,6 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	xhci->usb3_rhub.bus_state.bus_suspended = 0;
 }
 
-static int xhci_test_trb_in_td(struct xhci_hcd *xhci,
-		struct xhci_segment *input_seg,
-		union xhci_trb *start_trb,
-		union xhci_trb *end_trb,
-		dma_addr_t input_dma,
-		struct xhci_segment *result_seg,
-		char *test_name, int test_number)
-{
-	unsigned long long start_dma;
-	unsigned long long end_dma;
-	struct xhci_segment *seg;
-
-	start_dma = xhci_trb_virt_to_dma(input_seg, start_trb);
-	end_dma = xhci_trb_virt_to_dma(input_seg, end_trb);
-
-	seg = trb_in_td(xhci, input_seg, start_trb, end_trb, input_dma, false);
-	if (seg != result_seg) {
-		xhci_warn(xhci, "WARN: %s TRB math test %d failed!\n",
-				test_name, test_number);
-		xhci_warn(xhci, "Tested TRB math w/ seg %p and "
-				"input DMA 0x%llx\n",
-				input_seg,
-				(unsigned long long) input_dma);
-		xhci_warn(xhci, "starting TRB %p (0x%llx DMA), "
-				"ending TRB %p (0x%llx DMA)\n",
-				start_trb, start_dma,
-				end_trb, end_dma);
-		xhci_warn(xhci, "Expected seg %p, got seg %p\n",
-				result_seg, seg);
-		trb_in_td(xhci, input_seg, start_trb, end_trb, input_dma,
-			  true);
-		return -1;
-	}
-	return 0;
-}
-
-/* TRB math checks for xhci_trb_in_td(), using the command and event rings. */
-static int xhci_check_trb_in_td_math(struct xhci_hcd *xhci)
-{
-	struct {
-		dma_addr_t		input_dma;
-		struct xhci_segment	*result_seg;
-	} simple_test_vector [] = {
-		/* A zeroed DMA field should fail */
-		{ 0, NULL },
-		/* One TRB before the ring start should fail */
-		{ xhci->event_ring->first_seg->dma - 16, NULL },
-		/* One byte before the ring start should fail */
-		{ xhci->event_ring->first_seg->dma - 1, NULL },
-		/* Starting TRB should succeed */
-		{ xhci->event_ring->first_seg->dma, xhci->event_ring->first_seg },
-		/* Ending TRB should succeed */
-		{ xhci->event_ring->first_seg->dma + (TRBS_PER_SEGMENT - 1)*16,
-			xhci->event_ring->first_seg },
-		/* One byte after the ring end should fail */
-		{ xhci->event_ring->first_seg->dma + (TRBS_PER_SEGMENT - 1)*16 + 1, NULL },
-		/* One TRB after the ring end should fail */
-		{ xhci->event_ring->first_seg->dma + (TRBS_PER_SEGMENT)*16, NULL },
-		/* An address of all ones should fail */
-		{ (dma_addr_t) (~0), NULL },
-	};
-	struct {
-		struct xhci_segment	*input_seg;
-		union xhci_trb		*start_trb;
-		union xhci_trb		*end_trb;
-		dma_addr_t		input_dma;
-		struct xhci_segment	*result_seg;
-	} complex_test_vector [] = {
-		/* Test feeding a valid DMA address from a different ring */
-		{	.input_seg = xhci->event_ring->first_seg,
-			.start_trb = xhci->event_ring->first_seg->trbs,
-			.end_trb = &xhci->event_ring->first_seg->trbs[TRBS_PER_SEGMENT - 1],
-			.input_dma = xhci->cmd_ring->first_seg->dma,
-			.result_seg = NULL,
-		},
-		/* Test feeding a valid end TRB from a different ring */
-		{	.input_seg = xhci->event_ring->first_seg,
-			.start_trb = xhci->event_ring->first_seg->trbs,
-			.end_trb = &xhci->cmd_ring->first_seg->trbs[TRBS_PER_SEGMENT - 1],
-			.input_dma = xhci->cmd_ring->first_seg->dma,
-			.result_seg = NULL,
-		},
-		/* Test feeding a valid start and end TRB from a different ring */
-		{	.input_seg = xhci->event_ring->first_seg,
-			.start_trb = xhci->cmd_ring->first_seg->trbs,
-			.end_trb = &xhci->cmd_ring->first_seg->trbs[TRBS_PER_SEGMENT - 1],
-			.input_dma = xhci->cmd_ring->first_seg->dma,
-			.result_seg = NULL,
-		},
-		/* TRB in this ring, but after this TD */
-		{	.input_seg = xhci->event_ring->first_seg,
-			.start_trb = &xhci->event_ring->first_seg->trbs[0],
-			.end_trb = &xhci->event_ring->first_seg->trbs[3],
-			.input_dma = xhci->event_ring->first_seg->dma + 4*16,
-			.result_seg = NULL,
-		},
-		/* TRB in this ring, but before this TD */
-		{	.input_seg = xhci->event_ring->first_seg,
-			.start_trb = &xhci->event_ring->first_seg->trbs[3],
-			.end_trb = &xhci->event_ring->first_seg->trbs[6],
-			.input_dma = xhci->event_ring->first_seg->dma + 2*16,
-			.result_seg = NULL,
-		},
-		/* TRB in this ring, but after this wrapped TD */
-		{	.input_seg = xhci->event_ring->first_seg,
-			.start_trb = &xhci->event_ring->first_seg->trbs[TRBS_PER_SEGMENT - 3],
-			.end_trb = &xhci->event_ring->first_seg->trbs[1],
-			.input_dma = xhci->event_ring->first_seg->dma + 2*16,
-			.result_seg = NULL,
-		},
-		/* TRB in this ring, but before this wrapped TD */
-		{	.input_seg = xhci->event_ring->first_seg,
-			.start_trb = &xhci->event_ring->first_seg->trbs[TRBS_PER_SEGMENT - 3],
-			.end_trb = &xhci->event_ring->first_seg->trbs[1],
-			.input_dma = xhci->event_ring->first_seg->dma + (TRBS_PER_SEGMENT - 4)*16,
-			.result_seg = NULL,
-		},
-		/* TRB not in this ring, and we have a wrapped TD */
-		{	.input_seg = xhci->event_ring->first_seg,
-			.start_trb = &xhci->event_ring->first_seg->trbs[TRBS_PER_SEGMENT - 3],
-			.end_trb = &xhci->event_ring->first_seg->trbs[1],
-			.input_dma = xhci->cmd_ring->first_seg->dma + 2*16,
-			.result_seg = NULL,
-		},
-	};
-
-	unsigned int num_tests;
-	int i, ret;
-
-	num_tests = ARRAY_SIZE(simple_test_vector);
-	for (i = 0; i < num_tests; i++) {
-		ret = xhci_test_trb_in_td(xhci,
-				xhci->event_ring->first_seg,
-				xhci->event_ring->first_seg->trbs,
-				&xhci->event_ring->first_seg->trbs[TRBS_PER_SEGMENT - 1],
-				simple_test_vector[i].input_dma,
-				simple_test_vector[i].result_seg,
-				"Simple", i);
-		if (ret < 0)
-			return ret;
-	}
-
-	num_tests = ARRAY_SIZE(complex_test_vector);
-	for (i = 0; i < num_tests; i++) {
-		ret = xhci_test_trb_in_td(xhci,
-				complex_test_vector[i].input_seg,
-				complex_test_vector[i].start_trb,
-				complex_test_vector[i].end_trb,
-				complex_test_vector[i].input_dma,
-				complex_test_vector[i].result_seg,
-				"Complex", i);
-		if (ret < 0)
-			return ret;
-	}
-	xhci_dbg(xhci, "TRB math tests passed.\n");
-	return 0;
-}
-
 static void xhci_set_hc_event_deq(struct xhci_hcd *xhci)
 {
 	u64 temp;
@@ -2549,8 +2391,6 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 					0, flags);
 	if (!xhci->event_ring)
 		goto fail;
-	if (xhci_check_trb_in_td_math(xhci) < 0)
-		goto fail;
 
 	ret = xhci_alloc_erst(xhci, xhci->event_ring, &xhci->erst, flags);
 	if (ret)
-- 
2.43.0



