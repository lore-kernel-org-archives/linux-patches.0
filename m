Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C5A12EBEA;
	Tue, 25 Jun 2024 09:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308492; cv=none; b=bBZEJ/ZBwsM6e8Y47acOkJALdp69mRpk2FZUfWeDQu2P/SgR1zkBXBxmKO/rnIPx1Y991tOC0/zPKnp1NsOIumFJl/3F6PQ/j+g2+6WZXnBHxCbe6or2vDIj6l7X+B7uv5ej2IQ+Zr+6xIyUegLYTgIXJpXhn20Dq/fICO7jB6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308492; c=relaxed/simple;
	bh=GLrFvgcmC9GAKNnNQaqTNftbabYcIeEKP1EDUTvwTuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C13EVHbcmmfAYZoWhOIh2LzIU2m3Rh0u7TCShD320j7FQLKm8r9xA09Omwfwd0VyVuhWo1aOulCX+RhKWxp8AKoWPWpZTcJ97RfGuC1ScxtHkIsd+dTyTQDHXs4EaiTXZTzCQBud+agZmmENRVDYVSNxAKC0FrWzTw4Xh1lQx4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtH0mnl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtH0mnl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C157AC32781;
	Tue, 25 Jun 2024 09:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308492;
	bh=GLrFvgcmC9GAKNnNQaqTNftbabYcIeEKP1EDUTvwTuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtH0mnl1kuKQGQNurkbXqCdlqwFkQDLaG5JuQV+dDT3XkeBJX3Yr+BAmfY/x9lPf5
	 RXBIM4Y+g/9+y1uVhRmsVWLqLNkM/pK7B6U+mAi4XfEOkNSnsCrrKc6XJSvVVgDWbU
	 sdZZiXFEMIanLN8L/1xNA5uP3xrbqp49+fOnOcVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 140/250] bnxt_en: Restore PTP tx_avail count in case of skb_pad() error
Date: Tue, 25 Jun 2024 11:31:38 +0200
Message-ID: <20240625085553.433206594@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 1e7962114c10957fe4d10a15eb714578a394e90b ]

The current code only restores PTP tx_avail count when we get DMA
mapping errors.  Fix it so that the PTP tx_avail count will be
restored for both DMA mapping errors and skb_pad() errors.
Otherwise PTP TX timestamp will not be available after a PTP
packet hits the skb_pad() error.

Fixes: 83bb623c968e ("bnxt_en: Transmit and retrieve packet timestamps")
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240618215313.29631-4-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2c2ee79c4d779..0fab62a56f3b3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -730,9 +730,6 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 
 tx_dma_error:
-	if (BNXT_TX_PTP_IS_SET(lflags))
-		atomic_inc(&bp->ptp_cfg->tx_avail);
-
 	last_frag = i;
 
 	/* start back at beginning and unmap skb */
@@ -754,6 +751,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 tx_free:
 	dev_kfree_skb_any(skb);
 tx_kick_pending:
+	if (BNXT_TX_PTP_IS_SET(lflags))
+		atomic_inc(&bp->ptp_cfg->tx_avail);
 	if (txr->kick_pending)
 		bnxt_txr_db_kick(bp, txr, txr->tx_prod);
 	txr->tx_buf_ring[txr->tx_prod].skb = NULL;
-- 
2.43.0



