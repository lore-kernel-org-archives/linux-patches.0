Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E100202978;
	Wed, 23 Apr 2025 14:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420084; cv=none; b=mT8OeZv55QH3fJDAOjhFEd1QR9nfe/0LAEAVZXoEScgozdDuRVgZ6xrqXkgGGPbrFzqLZU9dCE5uiUY9INi/l7/G7SOtYJT6Zum3GBeCnHvYohAVQzK8O3rKBco9bkQ00pYPOhVaUAD1RbrLv6TvRXN0g6cTQXLZuqdbTsrfVHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420084; c=relaxed/simple;
	bh=jsPU7eO1GOZu38KqqAxhNsflGUDW5YZBoEsdfgirTLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOUmplTKKmONLh2a4GZ5qxDQRium7V1LgJoM6nDnsOeyk9FEPvuJKvBjHyssBnaIEpu3MPBB1BkQ0MjOd3nSSH9y4vsnamVr3ZH4r3QZXMHLLz0TjJCPPs1ZULoS0O6YlcJplc32Vcuo9oHNH2NfoqyqjRlv3M/wjpw0rJkviTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JB9Ye55W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JB9Ye55W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50B2C4CEE2;
	Wed, 23 Apr 2025 14:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420084;
	bh=jsPU7eO1GOZu38KqqAxhNsflGUDW5YZBoEsdfgirTLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JB9Ye55WRIC1a/r6ZCW8zYeYihkMWMurRnc2BwhlF/uIQ+joGy8SD60uypFJOhoqT
	 fTZpgkk2qnQAmP2/bTBYe5MP4pR2rrugKOX5Yhami3r1iQDusTFgsJv58dQptdhAOf
	 9PFz0+F8ItbgPfe/p39qX7kfFXFkoU5++o1JGYo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 058/241] eth: bnxt: fix missing ring index trim on error path
Date: Wed, 23 Apr 2025 16:42:02 +0200
Message-ID: <20250423142622.976651063@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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
index 2cd79b59cf002..1b39574e3fa22 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -783,7 +783,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	dev_kfree_skb_any(skb);
 tx_kick_pending:
 	if (BNXT_TX_PTP_IS_SET(lflags)) {
-		txr->tx_buf_ring[txr->tx_prod].is_ts_pkt = 0;
+		txr->tx_buf_ring[RING_TX(bp, txr->tx_prod)].is_ts_pkt = 0;
 		atomic64_inc(&bp->ptp_cfg->stats.ts_err);
 		if (!(bp->fw_cap & BNXT_FW_CAP_TX_TS_CMP))
 			/* set SKB to err so PTP worker will clean up */
@@ -791,7 +791,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
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



