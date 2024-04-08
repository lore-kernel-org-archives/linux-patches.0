Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B522757E3;
	Mon,  8 Apr 2024 13:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582658; cv=none; b=Yc+ihdR6b0rLsP2lDsJKMbfOcG3aYL25cW+w37/IC8+/qxQ6LOdmemsnwzocgYUg96l0FwZ2pdjpWS36h3B1KJy6VOwkO/Ut7mgNYajkEmW0bVWsXohmQjHtDeUfpzKDLhW+/9kfs9B4yI4LaM4H9mpEKaVsYRrMsJq06ElmVQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582658; c=relaxed/simple;
	bh=VpaN91ob+oXAVRHiDrkdqkctmaJ8RtbDe+T1vLH0XfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqKPzMDmC8AMwPw17GmIurqgMzm4wudP9EGNy59ztKgIkmVkm8IYv0YblbvOu17L0eJV+f7DsuyOlcmrFIh7CfuKOIJxYdm21MGzGk+id7YSdVkxQhihkQ9ELPJp4DvS+XvnkGMAQonfQUNIOfUF1gtYZBjJiCKhkTmOiovvjUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DViKtLpG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DViKtLpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251B6C43394;
	Mon,  8 Apr 2024 13:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582658;
	bh=VpaN91ob+oXAVRHiDrkdqkctmaJ8RtbDe+T1vLH0XfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DViKtLpGJKzgIkU7VvC9zD9l0Iw1tkmZeaNsbEIDQ/mf07XgbfUzbUlvOXvDFutFl
	 e+opbpVc+GoxEisp4BVFma4ivjuKftmTha2ziKZJqkAf4AlJPy9ZFOcADDs5b4Gvx3
	 GrKtADmQZ3aP6cC9QyjwsG5wgVADzCYU7Njm6u9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 110/252] net: phy: micrel: Fix potential null pointer dereference
Date: Mon,  8 Apr 2024 14:56:49 +0200
Message-ID: <20240408125310.053679940@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2503,7 +2503,7 @@ static void lan8814_txtstamp(struct mii_
 	}
 }
 
-static void lan8814_get_sig_rx(struct sk_buff *skb, u16 *sig)
+static bool lan8814_get_sig_rx(struct sk_buff *skb, u16 *sig)
 {
 	struct ptp_header *ptp_header;
 	u32 type;
@@ -2513,7 +2513,11 @@ static void lan8814_get_sig_rx(struct sk
 	ptp_header = ptp_parse_header(skb, type);
 	skb_pull_inline(skb, ETH_HLEN);
 
+	if (!ptp_header)
+		return false;
+
 	*sig = (__force u16)(ntohs(ptp_header->sequence_id));
+	return true;
 }
 
 static bool lan8814_match_rx_skb(struct kszphy_ptp_priv *ptp_priv,
@@ -2525,7 +2529,8 @@ static bool lan8814_match_rx_skb(struct
 	bool ret = false;
 	u16 skb_sig;
 
-	lan8814_get_sig_rx(skb, &skb_sig);
+	if (!lan8814_get_sig_rx(skb, &skb_sig))
+		return ret;
 
 	/* Iterate over all RX timestamps and match it with the received skbs */
 	spin_lock_irqsave(&ptp_priv->rx_ts_lock, flags);
@@ -2805,7 +2810,7 @@ static int lan8814_ptpci_adjfine(struct
 	return 0;
 }
 
-static void lan8814_get_sig_tx(struct sk_buff *skb, u16 *sig)
+static bool lan8814_get_sig_tx(struct sk_buff *skb, u16 *sig)
 {
 	struct ptp_header *ptp_header;
 	u32 type;
@@ -2813,7 +2818,11 @@ static void lan8814_get_sig_tx(struct sk
 	type = ptp_classify_raw(skb);
 	ptp_header = ptp_parse_header(skb, type);
 
+	if (!ptp_header)
+		return false;
+
 	*sig = (__force u16)(ntohs(ptp_header->sequence_id));
+	return true;
 }
 
 static void lan8814_match_tx_skb(struct kszphy_ptp_priv *ptp_priv,
@@ -2827,7 +2836,8 @@ static void lan8814_match_tx_skb(struct
 
 	spin_lock_irqsave(&ptp_priv->tx_queue.lock, flags);
 	skb_queue_walk_safe(&ptp_priv->tx_queue, skb, skb_tmp) {
-		lan8814_get_sig_tx(skb, &skb_sig);
+		if (!lan8814_get_sig_tx(skb, &skb_sig))
+			continue;
 
 		if (memcmp(&skb_sig, &seq_id, sizeof(seq_id)))
 			continue;
@@ -2881,7 +2891,8 @@ static bool lan8814_match_skb(struct ksz
 
 	spin_lock_irqsave(&ptp_priv->rx_queue.lock, flags);
 	skb_queue_walk_safe(&ptp_priv->rx_queue, skb, skb_tmp) {
-		lan8814_get_sig_rx(skb, &skb_sig);
+		if (!lan8814_get_sig_rx(skb, &skb_sig))
+			continue;
 
 		if (memcmp(&skb_sig, &rx_ts->seq_id, sizeof(rx_ts->seq_id)))
 			continue;


