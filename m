Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971E9250BE9;
	Wed,  5 Mar 2025 18:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197803; cv=none; b=IoipBbnr4Saf/RWFeKIbwJ4gYzF7xgzFC3wzqX8X30yiWvBATCeZz5Tbo7QPf+b5M6WDVOHSKOpQOuT1DWb0N/bvOBUc1ZJgvLNxCR6jzoE2HhHTgTa7Bugt/IYKnWtmbEynBx5ElwrTxGzezNJCb1ZsOQdl3cKRgtJ3gVtvJH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197803; c=relaxed/simple;
	bh=BjVGJp2aFwLZbq68WPRjzWg3gYUAOroneRQrAQnfaHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A71sYJ1A5W0BOUO5Dtny3DYA2xIG+qSHXb0bHIUKH9D19MRGLy9MgQogyzT6TXEq4VFfQZubcCa8mcJi0phA7afnnHt750gzvgZSRY8zMef4AhysdNKfJmkFf+hTvNHvDarihNteofJnds/t1bfpnK+/DuvDG2udp58IqCDtxeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQNmd85T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQNmd85T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC4AC4CED1;
	Wed,  5 Mar 2025 18:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197803;
	bh=BjVGJp2aFwLZbq68WPRjzWg3gYUAOroneRQrAQnfaHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQNmd85TPIcWaMIFBsF6pAmuskChZqRIO+xqYVUDZEeIxdSf9xBKfcMyCJsfrBw0c
	 HyTtctzd3Ok3WZuh84Vo8KmlFgVNlk0/lorkIPljQMcLhLCyeZa9w+/fQMS9k18ouI
	 V+qm8yQwfRGVxOcBuGUgx3wCZdec4P8Njlmaww74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Wei Fang <wei.fang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 074/142] net: enetc: keep track of correct Tx BD count in enetc_map_tx_tso_buffs()
Date: Wed,  5 Mar 2025 18:48:13 +0100
Message-ID: <20250305174503.308760810@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

commit da291996b16ebd10626d4b20288327b743aff110 upstream.

When creating a TSO header, if the skb is VLAN tagged, the extended BD
will be used and the 'count' should be increased by 2 instead of 1.
Otherwise, when an error occurs, less tx_swbd will be freed than the
actual number.

Fixes: fb8629e2cbfc ("net: enetc: add support for software TSO")
Cc: stable@vger.kernel.org
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://patch.msgid.link/20250224111251.1061098-3-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -351,14 +351,15 @@ dma_err:
 	return 0;
 }
 
-static void enetc_map_tx_tso_hdr(struct enetc_bdr *tx_ring, struct sk_buff *skb,
-				 struct enetc_tx_swbd *tx_swbd,
-				 union enetc_tx_bd *txbd, int *i, int hdr_len,
-				 int data_len)
+static int enetc_map_tx_tso_hdr(struct enetc_bdr *tx_ring, struct sk_buff *skb,
+				struct enetc_tx_swbd *tx_swbd,
+				union enetc_tx_bd *txbd, int *i, int hdr_len,
+				int data_len)
 {
 	union enetc_tx_bd txbd_tmp;
 	u8 flags = 0, e_flags = 0;
 	dma_addr_t addr;
+	int count = 1;
 
 	enetc_clear_tx_bd(&txbd_tmp);
 	addr = tx_ring->tso_headers_dma + *i * TSO_HEADER_SIZE;
@@ -401,7 +402,10 @@ static void enetc_map_tx_tso_hdr(struct
 		/* Write the BD */
 		txbd_tmp.ext.e_flags = e_flags;
 		*txbd = txbd_tmp;
+		count++;
 	}
+
+	return count;
 }
 
 static int enetc_map_tx_tso_data(struct enetc_bdr *tx_ring, struct sk_buff *skb,
@@ -533,9 +537,9 @@ static int enetc_map_tx_tso_buffs(struct
 
 		/* compute the csum over the L4 header */
 		csum = enetc_tso_hdr_csum(&tso, skb, hdr, hdr_len, &pos);
-		enetc_map_tx_tso_hdr(tx_ring, skb, tx_swbd, txbd, &i, hdr_len, data_len);
+		count += enetc_map_tx_tso_hdr(tx_ring, skb, tx_swbd, txbd,
+					      &i, hdr_len, data_len);
 		bd_data_num = 0;
-		count++;
 
 		while (data_len > 0) {
 			int size;


