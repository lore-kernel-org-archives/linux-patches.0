Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1372E266C;
	Sat, 17 Oct 2026 17:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257868; cv=none; b=JJAxat8so492LVNLhz3Wy7mgGYks3ea2mza1wVf76nbXDfVPwD2f07JFTP3J7S2BMjzTfqzYQkWy5y04p4EB4q7KxA4yD6XJkgokv9C7NPkD6zdfT5F61HdtU/gcSN6z3tuI2auICdJB7+lVWO2gBlYbfNWdbFA/bVuiflgHme4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257868; c=relaxed/simple;
	bh=+Oz6mRpjFRTwz37Fj0N6dU7UiCJuJ3x7j9JF+0GdojQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImMY4FBf0zL0w0m0XSNncJByzNUzVW0IlPl05j7gPk6CbBuX5sTUBss1ZGvgMP7JOYZ3rEe7XviS0tRmPaSKJzp8SKnjEzxQmV1eHctGszl5js7Haf3Pp0MCIwPzgReor18aDRSn7RmrEppPaW5uR2PFE8nnc49qHLkdELW8Opo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIrgNWYF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIrgNWYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDA81F000C4;
	Sat, 17 Oct 2026 17:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257867;
	bh=anECkRpDUB31N5UuAogi+elQ0Al0BS1s7QR2Fj7B7zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TIrgNWYF9vYdWJLZuEvPSaG3E2Ez0iFuzHxbc2LC7AYMnrdFy/fLNw8poUZfLUWbm
	 +kiHDtjNduA9CKj4ytR6TdNOxqOJs7gqjBS3Q4blyna+yGjfU9mIVoS8yNrFZaqWHI
	 Bx0kKWZ+Gw1w0qzYixtWR0PVOvnQLgEQ40DbhOAo=
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
Subject: [PATCH 6.6 0695/1674] bnxt_en: Mask the bd_cnt field in the TX BD properly
Date: Sat, 17 Oct 2026 17:49:27 +0200
Message-ID: <20261017160448.942808445@linuxfoundation.org>
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
index 239dc465348ba..e066f44e900b6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -494,7 +494,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 					TX_BD_FLAGS_LHINT_512_AND_SMALLER |
 					TX_BD_FLAGS_COAL_NOW |
 					TX_BD_FLAGS_PACKET_END |
-					(2 << TX_BD_FLAGS_BD_CNT_SHIFT));
+					TX_BD_CNT(2));
 
 		if (skb->ip_summed == CHECKSUM_PARTIAL)
 			tx_push1->tx_bd_hsize_lflags =
@@ -560,7 +560,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	dma_unmap_addr_set(tx_buf, mapping, mapping);
 	flags = (len << TX_BD_LEN_SHIFT) | TX_BD_TYPE_LONG_TX_BD |
-		((last_frag + 2) << TX_BD_FLAGS_BD_CNT_SHIFT);
+		TX_BD_CNT(last_frag + 2);
 
 	txbd->tx_bd_haddr = cpu_to_le64(mapping);
 	txbd->tx_bd_opaque = SET_TX_OPAQUE(bp, prod, 2 + last_frag);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 67ec15eae5d57..4c1598d475059 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -74,6 +74,8 @@ struct tx_bd {
 #define TX_OPAQUE_PROD(bp, opq)	((TX_OPAQUE_IDX(opq) + TX_OPAQUE_BDS(opq)) &\
 				 (bp)->tx_ring_mask)
 
+#define TX_BD_CNT(n)	(((n) << TX_BD_FLAGS_BD_CNT_SHIFT) & TX_BD_FLAGS_BD_CNT)
+
 struct tx_bd_ext {
 	__le32 tx_bd_hsize_lflags;
 	#define TX_BD_FLAGS_TCP_UDP_CHKSUM			(1 << 0)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 5e62172fb5f29..f3e322e7d61cc 100644
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
 	txbd->tx_bd_opaque = SET_TX_OPAQUE(bp, prod, 1 + num_frags);
-- 
2.53.0



