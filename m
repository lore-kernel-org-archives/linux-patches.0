Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD62265CAF;
	Tue,  8 Apr 2025 11:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110898; cv=none; b=u0sE3jzIVK/MPuNcpZzEWioqo+WgiKCiYEoSOuZFv2lNA+fP3GVI7sLv1ZckMrx7/VA5qJb6xV4Z0cpenuqYtiCEy5YhK2vZxfMjJsogwhRAJDtc+i+LSf+A4QyfoBV76AavjIaZA/RAfdVrTk3srKoOIUyN5J9/bqnLkguqh5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110898; c=relaxed/simple;
	bh=E9+t5g/a67mP69YWYQoIBFPA7tZ8OlXFZejU9V5qPb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpRY721cU13xD3wK/I3wKRScigQ6w4Me4u5paD1mi7LACOvKjQxhZqZ1iJn932bnrl+pQCI4gAvwuE/76ctQRieKwn9KxjlQ4BOwvyl1dtfO6ZMqn1LZwS8iL5dm/KsfWCsCyjsaC8f3ZqDp2Q40gNPcR2sDtq49r/eVND9XYSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mbQ+2UgA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mbQ+2UgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4660CC4CEE5;
	Tue,  8 Apr 2025 11:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110897;
	bh=E9+t5g/a67mP69YWYQoIBFPA7tZ8OlXFZejU9V5qPb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mbQ+2UgAhM1qZxfeAUPQjRvIevBGKlEbqdKKwPXY6oXMguyR2vHFTMOSaO2OgM0lf
	 Epr3jwR1IiFCxayXZ4ct6viJ+NqxMmm5ngtlheVpUWBwGr3CX1t0pjpJfLSqg2KqbU
	 s5bL53/WA3GiYzPUZUbEJFMqdWQw4En64YZFYMZ8=
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
Subject: [PATCH 6.14 235/731] bnxt_en: Mask the bd_cnt field in the TX BD properly
Date: Tue,  8 Apr 2025 12:42:12 +0200
Message-ID: <20250408104919.747673295@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 0ddc3d41e2d81..158e9789c1f46 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -564,7 +564,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 					TX_BD_FLAGS_LHINT_512_AND_SMALLER |
 					TX_BD_FLAGS_COAL_NOW |
 					TX_BD_FLAGS_PACKET_END |
-					(2 << TX_BD_FLAGS_BD_CNT_SHIFT));
+					TX_BD_CNT(2));
 
 		if (skb->ip_summed == CHECKSUM_PARTIAL)
 			tx_push1->tx_bd_hsize_lflags =
@@ -639,7 +639,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	dma_unmap_addr_set(tx_buf, mapping, mapping);
 	flags = (len << TX_BD_LEN_SHIFT) | TX_BD_TYPE_LONG_TX_BD |
-		((last_frag + 2) << TX_BD_FLAGS_BD_CNT_SHIFT);
+		TX_BD_CNT(last_frag + 2);
 
 	txbd->tx_bd_haddr = cpu_to_le64(mapping);
 	txbd->tx_bd_opaque = SET_TX_OPAQUE(bp, txr, prod, 2 + last_frag);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 2373f423a523e..3b4a044db73e3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -82,6 +82,8 @@ struct tx_bd {
 #define TX_OPAQUE_PROD(bp, opq)	((TX_OPAQUE_IDX(opq) + TX_OPAQUE_BDS(opq)) &\
 				 (bp)->tx_ring_mask)
 
+#define TX_BD_CNT(n)	(((n) << TX_BD_FLAGS_BD_CNT_SHIFT) & TX_BD_FLAGS_BD_CNT)
+
 struct tx_bd_ext {
 	__le32 tx_bd_hsize_lflags;
 	#define TX_BD_FLAGS_TCP_UDP_CHKSUM			(1 << 0)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 299822cacca48..d71bad3cfd6bd 100644
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
2.39.5



