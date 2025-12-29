Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81C13164B0;
	Mon, 29 Dec 2025 16:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025027; cv=none; b=nogpVgST5oT0ED3n++JekiPQllK/gkMhQi1xVpwbz9n4i6MUoF4QyOXZGMJ2dKaSv9d1OthDALzMjKrkZP1KEmCtmMOL47quRviR19LKJ1hNpuNBPMYgKY2TnhDBRBF2JzPi9qzoRZLY2MCRGrWHA0GJHg/v2gQdJ/z7Rzt78Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025027; c=relaxed/simple;
	bh=NzHOpdj8BQaJG4eNsMULD2LTCFhtjCDQMPYlpz0gtz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4u/2eGLSgWPG8CjAAt3R0VeNiFhuA7TahyKLSKmIPRf5AijmcAohIGrIQxZBoF48uWo+uJGthuACeQf1ueAkYRlK9AtDEzl5zDdr9fjq8GAJDMH8oQAXlZLkvsO3Jglo1y/DS9D69fCYS3nBqu2v65jtMS6qzAHZBvHbLWEDoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yG4e74kr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yG4e74kr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42890C4CEF7;
	Mon, 29 Dec 2025 16:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025027;
	bh=NzHOpdj8BQaJG4eNsMULD2LTCFhtjCDQMPYlpz0gtz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yG4e74krulSshmpSTUwbbCnc+XuC/hncqaBIH4nzI6zWmyfo+3DN/ZTlgCR1QtP2x
	 Z3NgA+v5/qpf+Z+2Om85T/O3BFyY7fS05v8wJSx/m4QiOS4bysgwTslZmv9SrIcRG2
	 BSCHJitLdS+LYNb5JMg8qN7/KvD5tZEj1PicuYlw=
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
Subject: [PATCH 6.18 069/430] bnxt_en: Fix XDP_TX path
Date: Mon, 29 Dec 2025 17:07:51 +0100
Message-ID: <20251229160726.904617625@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3e77a96e5a3e3..c94a391b1ba5b 100644
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



