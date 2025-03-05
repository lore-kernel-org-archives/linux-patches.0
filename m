Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703FC1A5BB7;
	Wed,  5 Mar 2025 18:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198294; cv=none; b=TMDlq4A//ra0shPpYpIL1SORZdDZC+tSbmUI5HqyKBJnzGI+QRG3Y9gD/SJGkf8+Talx4VgbkhgMJ6sZzaa2WsQuItgKNfs97YzWSq32Sl0UfEnS6v2cm6b9f8cDtjCY6WcwkAnP5n27psaii3zxQYL8Cz2D54uuY2NxB4/cdlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198294; c=relaxed/simple;
	bh=vjOm8fDztvnscnSV8lkYRxK98OctyQ/eCoJkcV0g+cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4DoZx5dO1OusmFyHQA5NZspqkbc1yyj/q7PnnNSJxOzrurpoVo5OpyUqrvCzfR+jUBCsqIQGUbg3hM8Vk0Qyg0HqnfvrUcRsaWsGgrIlFihURmlUvGBrvPrLVu7GzLHh1/swxp1ditPpzBq9RLAQJmRgJrLp96brmp60i3JmIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jALC718x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jALC718x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB073C4CED1;
	Wed,  5 Mar 2025 18:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198294;
	bh=vjOm8fDztvnscnSV8lkYRxK98OctyQ/eCoJkcV0g+cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jALC718x++/BhBY7x6ESDHgPHjHDi5qnRGR1PoRUBqQdXmJI+srRQK5G6sMnwOLYI
	 Pg5i6VdPS58cLBKvp/MysnKYigw5BmjEmA0yoYep/d9Jr0CjNt1GHwc1geDdHiR4zR
	 wnJYIl7lnObqGT8l3QiXNWVfOORAD/2m4jSmBwps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Wei Fang <wei.fang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 112/150] net: enetc: keep track of correct Tx BD count in enetc_map_tx_tso_buffs()
Date: Wed,  5 Mar 2025 18:49:01 +0100
Message-ID: <20250305174508.315430998@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


