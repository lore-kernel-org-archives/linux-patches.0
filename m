Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730EE30C160;
	Fri,  4 Sep 2026 06:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501870; cv=none; b=baL/JDQV4TlJTiZ5ZLjVhhYjHG+roGVGFT1iv8+P5T6bS6/Xpuw8yL7CFqhtQa28s6kfrQFIkBvaNwTvTzYBYVK+ggg8orX+sRSXnXpBy9P0/qqfSY6zE75j7RczHHOcm65sO3AYd/0YS5LLHlmbm7aYkN7FTdFM0R5PoDAZwIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501870; c=relaxed/simple;
	bh=AvKesyjkAjbddFgrbokOD2nDc0/CxnOQ8MJ6toikMP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Thk/JRnuYXSS0yMejhToev5fTDdi9ocAdAV+Djxiu4mK4JotQpUdQeqgj6d23VKX0+SsL/3Xh3cOGbg/R8ets6BJAdXL7oZhI+DJEWQTLetPsLiJlQG5UnOyywUHG5MtmQiU7piT/0/A8TQQlNIgyHrZBfM6mdxE5l1rc6V/YfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMvovVZJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMvovVZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818901F00A3D;
	Fri,  4 Sep 2026 06:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501869;
	bh=pLAvynXV7jcN0utx2uylg/nCc7QESsd2o9ZZ5x+9veg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMvovVZJRzItwCNvJI/Wp5DVruqSmwqZHgJczl1UqpNjqZoiCzIN4Nqf/EkjoD7Eb
	 Wx4OAsUkV2+PERp3qY6HCmRp/6AXzs1W5AxXSRriA6koEmN/TrsvEmjiIwbksTt+MF
	 V5B9pgvaLdPumm9bu23xmu75YU6J2rv4hGaFIoVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/403] bnxt_en: Mask the bd_cnt field in the TX BD properly
Date: Fri,  4 Sep 2026 06:56:44 +0200
Message-ID: <20260904045734.841604558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

[ Upstream commit 107b25db61122d8f990987895c2912927b8b6e3f ]

The bd_cnt field in the TX BD specifies the total number of BDs for
the TX packet.  The bd_cnt field has 5 bits and the maximum number
supported is 32 with the value 0.

CONFIG_MAX_SKB_FRAGS can be modified and the total number of SKB
fragments can approach or exceed the maximum supported by the chip.
Add a macro to properly mask the bd_cnt field so that the value 32
will be properly masked and set to 0 in the bd_cnd field.

Without this patch, the out-of-range bd_cnt value will corrupt the
TX BD and may cause TX timeout.

The next patch will check for values exceeding 32.

Fixes: 3948b05950fd ("net: introduce a config option to tweak MAX_SKB_FRAGS")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250321211639.3812992-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     | 2 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 3 +--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2356b7ba7fcfb..e14e2a0bf89ce 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -553,7 +553,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 					TX_BD_FLAGS_LHINT_512_AND_SMALLER |
 					TX_BD_FLAGS_COAL_NOW |
 					TX_BD_FLAGS_PACKET_END |
-					(2 << TX_BD_FLAGS_BD_CNT_SHIFT));
+					TX_BD_CNT(2));
 
 		if (skb->ip_summed == CHECKSUM_PARTIAL)
 			tx_push1->tx_bd_hsize_lflags =
@@ -628,7 +628,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	dma_unmap_addr_set(tx_buf, mapping, mapping);
 	flags = (len << TX_BD_LEN_SHIFT) | TX_BD_TYPE_LONG_TX_BD |
-		((last_frag + 2) << TX_BD_FLAGS_BD_CNT_SHIFT);
+		TX_BD_CNT(last_frag + 2);
 
 	txbd->tx_bd_haddr = cpu_to_le64(mapping);
 	txbd->tx_bd_opaque = SET_TX_OPAQUE(bp, txr, prod, 2 + last_frag);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index f50fe72f83ac6..67a82b3262d58 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -79,6 +79,8 @@ struct tx_bd {
 #define TX_OPAQUE_PROD(bp, opq)	((TX_OPAQUE_IDX(opq) + TX_OPAQUE_BDS(opq)) &\
 				 (bp)->tx_ring_mask)
 
+#define TX_BD_CNT(n)	(((n) << TX_BD_FLAGS_BD_CNT_SHIFT) & TX_BD_FLAGS_BD_CNT)
+
 struct tx_bd_ext {
 	__le32 tx_bd_hsize_lflags;
 	#define TX_BD_FLAGS_TCP_UDP_CHKSUM			(1 << 0)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index fa3c6515cc4d6..850dabebdbf22 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -48,8 +48,7 @@ struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 		tx_buf->page = virt_to_head_page(xdp->data);
 
 	txbd = &txr->tx_desc_ring[TX_RING(bp, prod)][TX_IDX(prod)];
-	flags = (len << TX_BD_LEN_SHIFT) |
-		((num_frags + 1) << TX_BD_FLAGS_BD_CNT_SHIFT) |
+	flags = (len << TX_BD_LEN_SHIFT) | TX_BD_CNT(num_frags + 1) |
 		bnxt_lhint_arr[len >> 9];
 	txbd->tx_bd_len_flags_type = cpu_to_le32(flags);
 	txbd->tx_bd_opaque = SET_TX_OPAQUE(bp, txr, prod, 1 + num_frags);
-- 
2.53.0



