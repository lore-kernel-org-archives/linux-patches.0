Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6314302F5;
	Tue, 21 Jul 2026 19:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662944; cv=none; b=cUbjxP3w6dOxCRSe/0DYfuFFJFgA6wxCg0kiMs5y/0VXz1sHfJh0mM8eVWgoKO6nMAYEmtmtguIQSX5m8bJWBW19a/VEp+YK8G2KczPNvm3bYdAyH2WhUDbMimxD1oKmBpNeBcjzzT9hoSIVd9CqHUqfEdxXOGtJV9a9JCJArv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662944; c=relaxed/simple;
	bh=uKklwU2m/o1RTZMhM0RDXDUENK0ud0DOy01M20AI0Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oawyk1onnRxS/dMGyEdQBA3GScIpiOQ+r882oa3a9JvgNp+ZnZMrd+SVs2aYtxXrc8o7a3h2YM1Ht3wBoGHkIwzSlPBNY/bHDQCxh8SMpyUWSWcQ/86PQvjLpxlqAvDMG959uqgZACFqCq02hX/1WyGqS7Pj5u9+zcuu9Msxf/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ed/GH4BG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ed/GH4BG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF961F000E9;
	Tue, 21 Jul 2026 19:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662943;
	bh=lx4ZPKJd/G/L1vwX7AJvi76wVxV00QuAd9ybNYhvPbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ed/GH4BGw2Tzr4Nt9VgIRE9RZJvHoK6J30PeVTPr34mVXsnByWCuneaNBr/gQco1j
	 VWjQ4o5l72U4VQ0p1nZEaJzbbG2DDDsGTKk6kR2J/V6aIs5af5TR7DSttOfulpMrNX
	 49BvUf9720MG43CCl2CV19J8x/+IVLqKa9/NS6c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0635/1276] net: bnxt: use ethtool string helpers
Date: Tue, 21 Jul 2026 17:17:58 +0200
Message-ID: <20260721152500.319224158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 9b4b2e02c1e19e6a983cf1b3f082315239d38cb0 ]

Avoids having to use manual pointer manipulation.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20241029233229.9385-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 40529e58629b ("eth: bnxt: improve the timing of stats")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 115 ++++++++----------
 1 file changed, 54 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 0be9c64ae2fad3..9833d0a0b83861 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -705,112 +705,105 @@ static void bnxt_get_ethtool_stats(struct net_device *dev,
 static void bnxt_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 {
 	struct bnxt *bp = netdev_priv(dev);
-	static const char * const *str;
 	u32 i, j, num_str;
+	const char *str;
 
 	switch (stringset) {
 	case ETH_SS_STATS:
 		for (i = 0; i < bp->cp_nr_rings; i++) {
-			if (is_rx_ring(bp, i)) {
-				num_str = NUM_RING_RX_HW_STATS;
-				for (j = 0; j < num_str; j++) {
-					sprintf(buf, "[%d]: %s", i,
-						bnxt_ring_rx_stats_str[j]);
-					buf += ETH_GSTRING_LEN;
+			if (is_rx_ring(bp, i))
+				for (j = 0; j < NUM_RING_RX_HW_STATS; j++) {
+					str = bnxt_ring_rx_stats_str[j];
+					ethtool_sprintf(&buf, "[%d]: %s", i,
+							str);
 				}
-			}
-			if (is_tx_ring(bp, i)) {
-				num_str = NUM_RING_TX_HW_STATS;
-				for (j = 0; j < num_str; j++) {
-					sprintf(buf, "[%d]: %s", i,
-						bnxt_ring_tx_stats_str[j]);
-					buf += ETH_GSTRING_LEN;
+			if (is_tx_ring(bp, i))
+				for (j = 0; j < NUM_RING_TX_HW_STATS; j++) {
+					str = bnxt_ring_tx_stats_str[j];
+					ethtool_sprintf(&buf, "[%d]: %s", i,
+							str);
 				}
-			}
 			num_str = bnxt_get_num_tpa_ring_stats(bp);
 			if (!num_str || !is_rx_ring(bp, i))
 				goto skip_tpa_stats;
 
 			if (bp->max_tpa_v2)
-				str = bnxt_ring_tpa2_stats_str;
+				for (j = 0; j < num_str; j++) {
+					str = bnxt_ring_tpa2_stats_str[j];
+					ethtool_sprintf(&buf, "[%d]: %s", i,
+							str);
+				}
 			else
-				str = bnxt_ring_tpa_stats_str;
-
-			for (j = 0; j < num_str; j++) {
-				sprintf(buf, "[%d]: %s", i, str[j]);
-				buf += ETH_GSTRING_LEN;
-			}
-skip_tpa_stats:
-			if (is_rx_ring(bp, i)) {
-				num_str = NUM_RING_RX_SW_STATS;
 				for (j = 0; j < num_str; j++) {
-					sprintf(buf, "[%d]: %s", i,
-						bnxt_rx_sw_stats_str[j]);
-					buf += ETH_GSTRING_LEN;
+					str = bnxt_ring_tpa_stats_str[j];
+					ethtool_sprintf(&buf, "[%d]: %s", i,
+							str);
 				}
+skip_tpa_stats:
+			if (is_rx_ring(bp, i))
+				for (j = 0; j < NUM_RING_RX_SW_STATS; j++) {
+					str = bnxt_rx_sw_stats_str[j];
+					ethtool_sprintf(&buf, "[%d]: %s", i,
+							str);
+				}
+			for (j = 0; j < NUM_RING_CMN_SW_STATS; j++) {
+				str = bnxt_cmn_sw_stats_str[j];
+				ethtool_sprintf(&buf, "[%d]: %s", i, str);
 			}
-			num_str = NUM_RING_CMN_SW_STATS;
-			for (j = 0; j < num_str; j++) {
-				sprintf(buf, "[%d]: %s", i,
-					bnxt_cmn_sw_stats_str[j]);
-				buf += ETH_GSTRING_LEN;
-			}
-		}
-		for (i = 0; i < BNXT_NUM_RING_ERR_STATS; i++) {
-			strscpy(buf, bnxt_ring_err_stats_arr[i], ETH_GSTRING_LEN);
-			buf += ETH_GSTRING_LEN;
 		}
+		for (i = 0; i < BNXT_NUM_RING_ERR_STATS; i++)
+			ethtool_puts(&buf, bnxt_ring_err_stats_arr[i]);
 
-		if (bp->flags & BNXT_FLAG_PORT_STATS) {
+		if (bp->flags & BNXT_FLAG_PORT_STATS)
 			for (i = 0; i < BNXT_NUM_PORT_STATS; i++) {
-				strcpy(buf, bnxt_port_stats_arr[i].string);
-				buf += ETH_GSTRING_LEN;
+				str = bnxt_port_stats_arr[i].string;
+				ethtool_puts(&buf, str);
 			}
-		}
+
 		if (bp->flags & BNXT_FLAG_PORT_STATS_EXT) {
 			u32 len;
 
 			len = min_t(u32, bp->fw_rx_stats_ext_size,
 				    ARRAY_SIZE(bnxt_port_stats_ext_arr));
 			for (i = 0; i < len; i++) {
-				strcpy(buf, bnxt_port_stats_ext_arr[i].string);
-				buf += ETH_GSTRING_LEN;
+				str = bnxt_port_stats_ext_arr[i].string;
+				ethtool_puts(&buf, str);
 			}
+
 			len = min_t(u32, bp->fw_tx_stats_ext_size,
 				    ARRAY_SIZE(bnxt_tx_port_stats_ext_arr));
 			for (i = 0; i < len; i++) {
-				strcpy(buf,
-				       bnxt_tx_port_stats_ext_arr[i].string);
-				buf += ETH_GSTRING_LEN;
+				str = bnxt_tx_port_stats_ext_arr[i].string;
+				ethtool_puts(&buf, str);
 			}
+
 			if (bp->pri2cos_valid) {
 				for (i = 0; i < 8; i++) {
-					strcpy(buf,
-					       bnxt_rx_bytes_pri_arr[i].string);
-					buf += ETH_GSTRING_LEN;
+					str = bnxt_rx_bytes_pri_arr[i].string;
+					ethtool_puts(&buf, str);
 				}
+
 				for (i = 0; i < 8; i++) {
-					strcpy(buf,
-					       bnxt_rx_pkts_pri_arr[i].string);
-					buf += ETH_GSTRING_LEN;
+					str = bnxt_rx_pkts_pri_arr[i].string;
+					ethtool_puts(&buf, str);
 				}
+
 				for (i = 0; i < 8; i++) {
-					strcpy(buf,
-					       bnxt_tx_bytes_pri_arr[i].string);
-					buf += ETH_GSTRING_LEN;
+					str = bnxt_tx_bytes_pri_arr[i].string;
+					ethtool_puts(&buf, str);
 				}
+
 				for (i = 0; i < 8; i++) {
-					strcpy(buf,
-					       bnxt_tx_pkts_pri_arr[i].string);
-					buf += ETH_GSTRING_LEN;
+					str = bnxt_tx_pkts_pri_arr[i].string;
+					ethtool_puts(&buf, str);
 				}
 			}
 		}
 		break;
 	case ETH_SS_TEST:
 		if (bp->num_tests)
-			memcpy(buf, bp->test_info->string,
-			       bp->num_tests * ETH_GSTRING_LEN);
+			for (i = 0; i < bp->num_tests; i++)
+				ethtool_puts(&buf, bp->test_info->string[i]);
 		break;
 	default:
 		netdev_err(bp->dev, "bnxt_get_strings invalid request %x\n",
-- 
2.53.0



