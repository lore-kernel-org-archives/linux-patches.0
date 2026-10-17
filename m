Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D54E397339;
	Sat, 17 Oct 2026 17:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257859; cv=none; b=j8DHm6iR10dV4gF/oHmf2oo4+aDn5HmXVnixPxHaiqN/nSxKor+bGaiFArFZgu8zc2WGTFO10OsVtuqv1az/GIQ9JPHwwMCZ4miCkxj2dgSG9XRiDqYkuokAINn/hi2JLC9UynX5QbP1zq39eHH78VRocPfItemCp1o7B0mYfB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257859; c=relaxed/simple;
	bh=SgwoEaaYBMirbwl3/DuCoVsZDlZjrb9zPnUy8hfMF5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpC4PpTb0SmnlS2tcQQ8QhtN4v0PKY0FvhYfKsL1lNR3f0S9cjUekjWJP6gDavzJhu8gzeBqGLPfYB6ZvGpn/QV4wcyujhdmI9zLxRQbv62bXALjlxsOjeNU2fyaLlFqhlvZ8Dp2LaJGVsQrRV3B/uX3VnRc6XfmiPSdN62YM3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YknnmJpA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YknnmJpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B901F000C4;
	Sat, 17 Oct 2026 17:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257857;
	bh=6TZc50F3BL0gZ55DWDRvVr61deRWoIUwdi2wtftzbBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YknnmJpALNj8ykq7bDezZCvI8WpmggCuo9hL5y/R1ENM8+daU71JCxwtJdUNeLsuZ
	 StN2Zp5a1U5gqJUTCypgYnWz9czHFQpbd0rOVpDGleXVUMUxC7eYLBngevjRJjJ3DR
	 1sG2FNSG8D2/eW0rAmMv6hovI79aKwwUxUZZzHaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <gospo@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0692/1674] bnxt_en: Put the TX producer information in the TX BD opaque field
Date: Sat, 17 Oct 2026 17:49:24 +0200
Message-ID: <20261017160448.869354234@linuxfoundation.org>
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

[ Upstream commit 34eec1f29a5998305578fcc3e55d491a1795b56d ]

Currently, the opaque field in the TX BD is only used for debugging.
The TX completion logic relies on getting one TX completion for each
packet and they always complete in order.

Improve this scheme by putting the producer information (ring index plus
number of BDs for the packet) in the opaque field.  This way, we can
handle TX completion processing by looking at the last TX completion
instead of counting the number of completions.

Since we no longer need to count the exact number of completions, we can
optimize xmit_more by disabling TX completion when the xmit_more
condition is true.  This will be done in later patches.

This patch is only initializing the opaque field in the TX BD and is
not changing the driver's TX completion logic yet.

Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 107b25db6112 ("bnxt_en: Mask the bd_cnt field in the TX BD properly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 5 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     | 7 +++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 12ab276b91a3a..ef30d43a5611c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -441,8 +441,6 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	txbd = &txr->tx_desc_ring[TX_RING(prod)][TX_IDX(prod)];
 
-	txbd->tx_bd_opaque = prod;
-
 	tx_buf = &txr->tx_buf_ring[prod];
 	tx_buf->skb = skb;
 	tx_buf->nr_frags = last_frag;
@@ -528,7 +526,9 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		txbd->tx_bd_len_flags_type = tx_push->tx_bd_len_flags_type;
 		txbd->tx_bd_haddr = txr->data_mapping;
+		txbd->tx_bd_opaque = SET_TX_OPAQUE(bp, prod, 2);
 		prod = NEXT_TX(prod);
+		tx_push->tx_bd_opaque = txbd->tx_bd_opaque;
 		txbd = &txr->tx_desc_ring[TX_RING(prod)][TX_IDX(prod)];
 		memcpy(txbd, tx_push1, sizeof(*txbd));
 		prod = NEXT_TX(prod);
@@ -563,6 +563,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		((last_frag + 2) << TX_BD_FLAGS_BD_CNT_SHIFT);
 
 	txbd->tx_bd_haddr = cpu_to_le64(mapping);
+	txbd->tx_bd_opaque = SET_TX_OPAQUE(bp, prod, 2 + last_frag);
 
 	prod = NEXT_TX(prod);
 	txbd1 = (struct tx_bd_ext *)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 739ed9d0b5ab5..77df9c8437e37 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -61,6 +61,13 @@ struct tx_bd {
 	__le64 tx_bd_haddr;
 } __packed;
 
+#define TX_OPAQUE_IDX_MASK	0x0000ffff
+#define TX_OPAQUE_BDS_MASK	0x00ff0000
+#define TX_OPAQUE_BDS_SHIFT	16
+
+#define SET_TX_OPAQUE(bp, idx, bds)					\
+	(((bds) << TX_OPAQUE_BDS_SHIFT) | ((idx) & (bp)->tx_ring_mask))
+
 struct tx_bd_ext {
 	__le32 tx_bd_hsize_lflags;
 	#define TX_BD_FLAGS_TCP_UDP_CHKSUM			(1 << 0)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index fc47d45805b75..8774bb0e14cbe 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -52,7 +52,7 @@ struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 		((num_frags + 1) << TX_BD_FLAGS_BD_CNT_SHIFT) |
 		bnxt_lhint_arr[len >> 9];
 	txbd->tx_bd_len_flags_type = cpu_to_le32(flags);
-	txbd->tx_bd_opaque = prod;
+	txbd->tx_bd_opaque = SET_TX_OPAQUE(bp, prod, 1 + num_frags);
 	txbd->tx_bd_haddr = cpu_to_le64(mapping);
 
 	/* now let us fill up the frags into the next buffers */
-- 
2.53.0



