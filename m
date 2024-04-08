Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE32E2E62C;
	Mon,  8 Apr 2024 13:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581764; cv=none; b=o7fA9I9kHJMpK/TUpAgXKoVbFGgGO9AUzEgwvkaPfbCTho82dd9UGX8rv8QXmaXY09mUQmgc+Agfj+iIvLJ/1/W7xVcZ7y5tHUMrbuEslJYtHpgTdhY7IOixno/zOfWIxfobHA0kkfWtwDngnXVl3FWkOb90ryyJ4jlEHy0iptU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581764; c=relaxed/simple;
	bh=+UcuGIvrW49PeukjK1jWbpVlv9Mtd+VmIsQNLjrcbRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jl3Ezo74qIuJ1usAahkN+6aEtOZPrAolQRezcCGE0Ib4F0yEJaMVu48jMhwgu6Qm2KYb+OxGmwGxgN36hnlxVQ0wWv+ecEI3aQySorSxJWS8sQCVRaeD1WoMYjlAKPCET5PAGA831aPf7AS+vNGwCgZlkxoBF5lWupPVlPTmPQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlFIy8bl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlFIy8bl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493DBC433F1;
	Mon,  8 Apr 2024 13:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581764;
	bh=+UcuGIvrW49PeukjK1jWbpVlv9Mtd+VmIsQNLjrcbRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlFIy8blT9hqhOvVAuNWkRnqC9evUM4m3Ysa1R72fyek8wL5WND5OoTL+wtOxdWFH
	 nIB0BeI5cSWLDGXhUaFijwAiZo5LQoAKGKA63nzN1fMnisFSyN/bXuQM5CVRV7T1of
	 Lm+lzNIAP15RhdK+/rE+zW4qnktiwsh137drnJiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 050/138] net: phy: micrel: Fix potential null pointer dereference
Date: Mon,  8 Apr 2024 14:57:44 +0200
Message-ID: <20240408125257.784119794@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

commit 96c155943a703f0655c0c4cab540f67055960e91 upstream.

In lan8814_get_sig_rx() and lan8814_get_sig_tx() ptp_parse_header() may
return NULL as ptp_header due to abnormal packet type or corrupted packet.
Fix this bug by adding ptp_header check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20240329061631.33199-1-amishin@t-argos.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2303,7 +2303,7 @@ static void lan8814_txtstamp(struct mii_
 	}
 }
 
-static void lan8814_get_sig_rx(struct sk_buff *skb, u16 *sig)
+static bool lan8814_get_sig_rx(struct sk_buff *skb, u16 *sig)
 {
 	struct ptp_header *ptp_header;
 	u32 type;
@@ -2313,7 +2313,11 @@ static void lan8814_get_sig_rx(struct sk
 	ptp_header = ptp_parse_header(skb, type);
 	skb_pull_inline(skb, ETH_HLEN);
 
+	if (!ptp_header)
+		return false;
+
 	*sig = (__force u16)(ntohs(ptp_header->sequence_id));
+	return true;
 }
 
 static bool lan8814_match_rx_ts(struct kszphy_ptp_priv *ptp_priv,
@@ -2325,7 +2329,8 @@ static bool lan8814_match_rx_ts(struct k
 	bool ret = false;
 	u16 skb_sig;
 
-	lan8814_get_sig_rx(skb, &skb_sig);
+	if (!lan8814_get_sig_rx(skb, &skb_sig))
+		return ret;
 
 	/* Iterate over all RX timestamps and match it with the received skbs */
 	spin_lock_irqsave(&ptp_priv->rx_ts_lock, flags);
@@ -2605,7 +2610,7 @@ static int lan8814_ptpci_adjfine(struct
 	return 0;
 }
 
-static void lan8814_get_sig_tx(struct sk_buff *skb, u16 *sig)
+static bool lan8814_get_sig_tx(struct sk_buff *skb, u16 *sig)
 {
 	struct ptp_header *ptp_header;
 	u32 type;
@@ -2613,7 +2618,11 @@ static void lan8814_get_sig_tx(struct sk
 	type = ptp_classify_raw(skb);
 	ptp_header = ptp_parse_header(skb, type);
 
+	if (!ptp_header)
+		return false;
+
 	*sig = (__force u16)(ntohs(ptp_header->sequence_id));
+	return true;
 }
 
 static void lan8814_dequeue_tx_skb(struct kszphy_ptp_priv *ptp_priv)
@@ -2631,7 +2640,8 @@ static void lan8814_dequeue_tx_skb(struc
 
 	spin_lock_irqsave(&ptp_priv->tx_queue.lock, flags);
 	skb_queue_walk_safe(&ptp_priv->tx_queue, skb, skb_tmp) {
-		lan8814_get_sig_tx(skb, &skb_sig);
+		if (!lan8814_get_sig_tx(skb, &skb_sig))
+			continue;
 
 		if (memcmp(&skb_sig, &seq_id, sizeof(seq_id)))
 			continue;
@@ -2675,7 +2685,8 @@ static bool lan8814_match_skb(struct ksz
 
 	spin_lock_irqsave(&ptp_priv->rx_queue.lock, flags);
 	skb_queue_walk_safe(&ptp_priv->rx_queue, skb, skb_tmp) {
-		lan8814_get_sig_rx(skb, &skb_sig);
+		if (!lan8814_get_sig_rx(skb, &skb_sig))
+			continue;
 
 		if (memcmp(&skb_sig, &rx_ts->seq_id, sizeof(rx_ts->seq_id)))
 			continue;


