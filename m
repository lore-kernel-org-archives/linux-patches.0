Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCC83A6418;
	Sat, 17 Oct 2026 16:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255802; cv=none; b=eVpACabPgbQvz/HTAWRJxDt+uqHylr/hYuOC8EVFtpgctXX6Yq9m3k2NB7y3aLs4NtwawlhAdGrakXfIcQ7FWZ23nfBI47l81x8WAQgXtig3WjVBMQtrrcZck5bRmhaSWfPA2Gve+x2f1gAhkABkosdS8rd7lyP/FMCT0cIdYZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255802; c=relaxed/simple;
	bh=TKElsfhiIxHvViE99RnzwD3REIQtyAJKbXiFw/aBnKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVX2/+rVWUegiuzoS+3vwU9iRUoaBQ7/7teuw4Reafk27LYIabKdeCMiMko3rgz3qQ6R7tRW7ZSMcrHyLxwE+zjOvAVr2Evlb9zP4hNwECqT6VjwH6jWu1maQmn84WClZxDq3WQ//KYXL6M4l4pblQoLdUay7gbGQ5QqItizO4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbKMOGxZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbKMOGxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23D61F000C4;
	Sat, 17 Oct 2026 16:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255801;
	bh=Ta5fXssCBSXPqiaFDX7tgwLGzpsb6O6yBgvy0OG7sm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbKMOGxZ1b5evdYSqy125GhaEqS2EDuBTXYvaaPL6wGCj/j6e/dsEDDMaJMXe5xJH
	 IzCJV+zxZjIohnYEF4svYnXPxUPavnj/YZKynw9T4Hh6FZKnMTwTcg994Vvx4Vp9PP
	 nIzc8AV0iV+TiGodT7F4N6exCgHan6Tv5RZJQlh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Itzko <itzko@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0006/1674] net: ena: Add validation for completion descriptors consistency
Date: Sat, 17 Oct 2026 17:37:58 +0200
Message-ID: <20261017160431.303965509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit b37b98a3a0c1198bafe8c2d9ce0bc845b4e7a9a7 ]

Validate that `first` flag is set only for the first
descriptor in multi-buffer packets.
In case of an invalid descriptor, a reset will occur.
A new reset reason for RX data corruption has been added.

Signed-off-by: Shahar Itzko <itzko@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240512134637.25299-4-darinzon@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_eth_com.c | 37 ++++++++++++++-----
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  2 +
 .../net/ethernet/amazon/ena/ena_regs_defs.h   |  1 +
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index 933e619b3a313..4c6e07aa4bbb5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -229,30 +229,43 @@ static struct ena_eth_io_rx_cdesc_base *
 		idx * io_cq->cdesc_entry_size_in_bytes);
 }
 
-static u16 ena_com_cdesc_rx_pkt_get(struct ena_com_io_cq *io_cq,
-					   u16 *first_cdesc_idx)
+static int ena_com_cdesc_rx_pkt_get(struct ena_com_io_cq *io_cq,
+				    u16 *first_cdesc_idx,
+				    u16 *num_descs)
 {
+	u16 count = io_cq->cur_rx_pkt_cdesc_count, head_masked;
 	struct ena_eth_io_rx_cdesc_base *cdesc;
-	u16 count = 0, head_masked;
 	u32 last = 0;
 
 	do {
+		u32 status;
+
 		cdesc = ena_com_get_next_rx_cdesc(io_cq);
 		if (!cdesc)
 			break;
+		status = READ_ONCE(cdesc->status);
 
 		ena_com_cq_inc_head(io_cq);
+		if (unlikely((status & ENA_ETH_IO_RX_CDESC_BASE_FIRST_MASK) >>
+		    ENA_ETH_IO_RX_CDESC_BASE_FIRST_SHIFT && count != 0)) {
+			struct ena_com_dev *dev = ena_com_io_cq_to_ena_dev(io_cq);
+
+			netdev_err(dev->net_device,
+				   "First bit is on in descriptor #%d on q_id: %d, req_id: %u\n",
+				   count, io_cq->qid, cdesc->req_id);
+			return -EFAULT;
+		}
 		count++;
-		last = (READ_ONCE(cdesc->status) & ENA_ETH_IO_RX_CDESC_BASE_LAST_MASK) >>
-		       ENA_ETH_IO_RX_CDESC_BASE_LAST_SHIFT;
+		last = (status & ENA_ETH_IO_RX_CDESC_BASE_LAST_MASK) >>
+			ENA_ETH_IO_RX_CDESC_BASE_LAST_SHIFT;
 	} while (!last);
 
 	if (last) {
 		*first_cdesc_idx = io_cq->cur_rx_pkt_cdesc_start_idx;
-		count += io_cq->cur_rx_pkt_cdesc_count;
 
 		head_masked = io_cq->head & (io_cq->q_depth - 1);
 
+		*num_descs = count;
 		io_cq->cur_rx_pkt_cdesc_count = 0;
 		io_cq->cur_rx_pkt_cdesc_start_idx = head_masked;
 
@@ -260,11 +273,11 @@ static u16 ena_com_cdesc_rx_pkt_get(struct ena_com_io_cq *io_cq,
 			   "ENA q_id: %d packets were completed. first desc idx %u descs# %d\n",
 			   io_cq->qid, *first_cdesc_idx, count);
 	} else {
-		io_cq->cur_rx_pkt_cdesc_count += count;
-		count = 0;
+		io_cq->cur_rx_pkt_cdesc_count = count;
+		*num_descs = 0;
 	}
 
-	return count;
+	return 0;
 }
 
 static int ena_com_create_meta(struct ena_com_io_sq *io_sq,
@@ -539,10 +552,14 @@ int ena_com_rx_pkt(struct ena_com_io_cq *io_cq,
 	u16 cdesc_idx = 0;
 	u16 nb_hw_desc;
 	u16 i = 0;
+	int rc;
 
 	WARN(io_cq->direction != ENA_COM_IO_QUEUE_DIRECTION_RX, "wrong Q type");
 
-	nb_hw_desc = ena_com_cdesc_rx_pkt_get(io_cq, &cdesc_idx);
+	rc = ena_com_cdesc_rx_pkt_get(io_cq, &cdesc_idx, &nb_hw_desc);
+	if (unlikely(rc != 0))
+		return -EFAULT;
+
 	if (nb_hw_desc == 0) {
 		ena_rx_ctx->descs = nb_hw_desc;
 		return 0;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 4d7446bb66b77..60d8d2d99af14 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1335,6 +1335,8 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	if (rc == -ENOSPC) {
 		ena_increase_stat(&rx_ring->rx_stats.bad_desc_num, 1, &rx_ring->syncp);
 		ena_reset_device(adapter, ENA_REGS_RESET_TOO_MANY_RX_DESCS);
+	} else if (rc == -EFAULT) {
+		ena_reset_device(adapter, ENA_REGS_RESET_RX_DESCRIPTOR_MALFORMED);
 	} else {
 		ena_increase_stat(&rx_ring->rx_stats.bad_req_id, 1,
 				  &rx_ring->syncp);
diff --git a/drivers/net/ethernet/amazon/ena/ena_regs_defs.h b/drivers/net/ethernet/amazon/ena/ena_regs_defs.h
index 1e007a41a5256..23466d62fbc5c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_regs_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_regs_defs.h
@@ -21,6 +21,7 @@ enum ena_regs_reset_reason_types {
 	ENA_REGS_RESET_USER_TRIGGER                 = 12,
 	ENA_REGS_RESET_GENERIC                      = 13,
 	ENA_REGS_RESET_MISS_INTERRUPT               = 14,
+	ENA_REGS_RESET_RX_DESCRIPTOR_MALFORMED	    = 16,
 };
 
 /* ena_registers offsets */
-- 
2.53.0



