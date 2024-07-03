Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61439194A49;
	Wed,  3 Jul 2024 11:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005811; cv=none; b=kNTAU5YPClsXUxA9oav01L9k3eRcs6hSXUOtwsK0PERJmMrn8kYwHay9l0pjlGrDyin3rYHQtyeBsuL29SfitPxJqVNXrtXRq4vpGssApHIuYRjk7s93KnIzWluv6YE2I89UOl+3xSdIeqYs3qBxuHanlCgAIaX3gnjZY5zUjjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005811; c=relaxed/simple;
	bh=ZaElN8XuWLTS+2iBiw8JUwxC9oB7RwP1BHbGqla2UJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdNhC7D812q4HU3TuzXk8SFaTlFj0rsC/n5ZXCMX1Cq/7Y5OX8jd1BdLMjDt3+zMIU5JRD2D2zH01USDlOSoPdK5J6biYolXmpoPAIP/9Ef/4zyXV8R1vdaal9WYG5vZbJ6xHrkJagWXY0dH9D6vmVSc5Lv8VR2gv4dj86RbEYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6g5mGlw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6g5mGlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BAAC2BD10;
	Wed,  3 Jul 2024 11:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005811;
	bh=ZaElN8XuWLTS+2iBiw8JUwxC9oB7RwP1BHbGqla2UJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6g5mGlwtp6+ilOElT9HZR3OnCPQCabP8E/HZthNa1YlLDXUheiDLPKpYnQxVRJJk
	 yRW5zfUXRjxZriHzf62P16k9HTqdBeE/fj/vA+J61gzWwkG/UD0aKA0qWIGDR6eHWc
	 IPfQKyVCPD6hzCM1O9exF8NjRln5e5LZj0kiHzpk=
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
Subject: [PATCH 5.15 204/356] bnxt_en: Restore PTP tx_avail count in case of skb_pad() error
Date: Wed,  3 Jul 2024 12:39:00 +0200
Message-ID: <20240703102920.822399096@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3888561a5cc8f..f3c6a122a079a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -667,9 +667,6 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 
 tx_dma_error:
-	if (BNXT_TX_PTP_IS_SET(lflags))
-		atomic_inc(&bp->ptp_cfg->tx_avail);
-
 	last_frag = i;
 
 	/* start back at beginning and unmap skb */
@@ -691,6 +688,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
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



