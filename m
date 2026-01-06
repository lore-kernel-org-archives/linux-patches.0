Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B99023EA8A;
	Tue,  6 Jan 2026 17:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719828; cv=none; b=uE9A5ziB7fBDc0lRc5q20uAKT9cX5sFgjr7gq0eTXj91ywrTXRNhE3SF8mx28rGPqmduXpFcCyN81DbqHPaAb3JY6jQ5Rk/I6KVwtBzmN/QUOJvUp/89ZXLOP0VQgvjwuwOCi4TCYeOSzfkLB8ZEZwrpiYVPylyn69DHW4+QtNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719828; c=relaxed/simple;
	bh=craBEdLI2GmStOuyF909cL7+jY4NRZQtdYw63VsLGEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3XenAPpeGbdhLwtDEe+4FsLEeZqWuYVCbTR4dd6Jn7fYZfZggxrj903kJqv4guEiTarKh7BLNTlvBg/Yk780u4z4VzIY6OIGALOwEIeD8ioXXw9eKm4A3yXfAkhcvASBU4xOeAMKwdnVC9xm1kkJGPMa3C510HshdqfHaa5D24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccZDiAZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccZDiAZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1034C116C6;
	Tue,  6 Jan 2026 17:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719828;
	bh=craBEdLI2GmStOuyF909cL7+jY4NRZQtdYw63VsLGEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccZDiAZlpqsUWoMT3ZB4gaZKjstyNBpcVzBGaqK/ZUDU7T/Cwzx4zRn5icMMNewPt
	 dFxluyStcd7EKZtCwKog9EP759KSq3eFx5SOFdS0mn4FBToOfNu/rlL9KHPdIQvgtt
	 UZ4UuTm1TB8osQ0/dPGuIhNGE5fnEr4z5HkASpRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Dubovitsky <pdubovitsky@meta.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/567] bnxt_en: Fix XDP_TX path
Date: Tue,  6 Jan 2026 17:57:14 +0100
Message-ID: <20260106170453.263334847@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 0373d5c387f24de749cc22e694a14b3a7c7eb515 ]

For XDP_TX action in bnxt_rx_xdp(), clearing of the event flags is not
correct.  __bnxt_poll_work() -> bnxt_rx_pkt() -> bnxt_rx_xdp() may be
looping within NAPI and some event flags may be set in earlier
iterations.  In particular, if BNXT_TX_EVENT is set earlier indicating
some XDP_TX packets are ready and pending, it will be cleared if it is
XDP_TX action again.  Normally, we will set BNXT_TX_EVENT again when we
successfully call __bnxt_xmit_xdp().  But if the TX ring has no more
room, the flag will not be set.  This will cause the TX producer to be
ahead but the driver will not hit the TX doorbell.

For multi-buf XDP_TX, there is no need to clear the event flags and set
BNXT_AGG_EVENT.  The BNXT_AGG_EVENT flag should have been set earlier in
bnxt_rx_pkt().

The visible symptom of this is that the RX ring associated with the
TX XDP ring will eventually become empty and all packets will be dropped.
Because this condition will cause the driver to not refill the RX ring
seeing that the TX ring has forever pending XDP_TX packets.

The fix is to only clear BNXT_RX_EVENT when we have successfully
called __bnxt_xmit_xdp().

Fixes: 7f0a168b0441 ("bnxt_en: Add completion ring pointer in TX and RX ring structures")
Reported-by: Pavel Dubovitsky <pdubovitsky@meta.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20251203003024.2246699-1-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 844812bd65363..fa3c6515cc4d6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -268,13 +268,11 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 	case XDP_TX:
 		rx_buf = &rxr->rx_buf_ring[cons];
 		mapping = rx_buf->mapping - bp->rx_dma_offset;
-		*event &= BNXT_TX_CMP_EVENT;
 
 		if (unlikely(xdp_buff_has_frags(xdp))) {
 			struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 
 			tx_needed += sinfo->nr_frags;
-			*event = BNXT_AGG_EVENT;
 		}
 
 		if (tx_avail < tx_needed) {
@@ -287,6 +285,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		dma_sync_single_for_device(&pdev->dev, mapping + offset, *len,
 					   bp->rx_dir);
 
+		*event &= ~BNXT_RX_EVENT;
 		*event |= BNXT_TX_EVENT;
 		__bnxt_xmit_xdp(bp, txr, mapping + offset, *len,
 				NEXT_RX(rxr->rx_prod), xdp);
-- 
2.51.0



