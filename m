Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD3C2820B4;
	Wed, 23 Apr 2025 14:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419728; cv=none; b=EDu5Rv37Q9nWSaWHQybYmZwDV5LR2jQwlcD0PWW0/x2gx68KpNgxQDAnCZ1Etv57x860sJ+l1Q2pJBnw9w5lQ3FTLXP6CzxwjfEo7hgEFEc3YIBB//jgcJ54gk/JWXd6R5U52NyKSgtM9WSdX0vKsdBdBXYpn2lLWm/QvdQO5M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419728; c=relaxed/simple;
	bh=F1BuUm+W59FuG010QQpKVt0+t4AG8t+Z4uF7mApuMQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQGJbCYyPaM2f2PEHYZYXBpl/tQOxc2enIiTZDGmaUFRT/awFJcbnDxN8FWW27lSM08wRXHnRrwbkWlkAUgmIkJN6/bF6bWsNLd1jZiP4SzvrLAtFqANjs5C+VQY6kue2qDA61DWMofxGicm4WL88nVCTDxIV6oPjA8/IA7AX2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olk1saQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olk1saQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81E6C4CEE2;
	Wed, 23 Apr 2025 14:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419726;
	bh=F1BuUm+W59FuG010QQpKVt0+t4AG8t+Z4uF7mApuMQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olk1saQ5B8mHyGmlDGjqwAtqsH/jY9VlpDydM7pDiWYLk09i2L7jzKeKzsIJ9ewfF
	 JllrkNYUiDwd0XlXT9uX291kQ3HOAhDD93UHeBuTQXiZeBvn4Nd/NGcJ/Z6pse81KO
	 7efnMrEx257DRfyTQho9rKZK+t87WuUmZOFI8+0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/223] eth: bnxt: fix missing ring index trim on error path
Date: Wed, 23 Apr 2025 16:42:03 +0200
Message-ID: <20250423142619.212984078@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 12f2d033fae957d84c2c0ce604d2a077e61fa2c0 ]

Commit under Fixes converted tx_prod to be free running but missed
masking it on the Tx error path. This crashes on error conditions,
for example when DMA mapping fails.

Fixes: 6d1add95536b ("bnxt_en: Modify TX ring indexing logic.")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250414143210.458625-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e7580df13229a..016dcfec8d496 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -758,7 +758,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	dev_kfree_skb_any(skb);
 tx_kick_pending:
 	if (BNXT_TX_PTP_IS_SET(lflags)) {
-		txr->tx_buf_ring[txr->tx_prod].is_ts_pkt = 0;
+		txr->tx_buf_ring[RING_TX(bp, txr->tx_prod)].is_ts_pkt = 0;
 		atomic64_inc(&bp->ptp_cfg->stats.ts_err);
 		if (!(bp->fw_cap & BNXT_FW_CAP_TX_TS_CMP))
 			/* set SKB to err so PTP worker will clean up */
@@ -766,7 +766,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 	if (txr->kick_pending)
 		bnxt_txr_db_kick(bp, txr, txr->tx_prod);
-	txr->tx_buf_ring[txr->tx_prod].skb = NULL;
+	txr->tx_buf_ring[RING_TX(bp, txr->tx_prod)].skb = NULL;
 	dev_core_stats_tx_dropped_inc(dev);
 	return NETDEV_TX_OK;
 }
-- 
2.39.5



