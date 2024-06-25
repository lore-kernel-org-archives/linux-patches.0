Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F991487E9;
	Tue, 25 Jun 2024 10:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309615; cv=none; b=fNqfgsqPc+Zyj90a7PbjQIUjwih/qumq8cPxBJROD83xZGcv3waAfiS+2hSyRtgSTRbtqYX45Q1Pvbk/o8hl9fBsZ5c2kgz0VClMNA19srPwx2BN4M8yumlGM7hhn47GCZImmpcue7WG4hPP+IZemMHS9uMSwYccgWo5wNyU/Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309615; c=relaxed/simple;
	bh=dCAR1apLYOLSi2jN3thF8RHe7ggsc4iLz8a53F3xfoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xao8o7oAbpffoyUn2tNufBj95hat1qZHDrvMrd7natnaWcCHwyH+ru6rukxV/J46OtydECYNk/Fxs586vAamrgwlzOgOtoHju+l8urHALkFO6tw4HhctIo3+kW5l88M5o5/Mr5QEqrukN0L6CATOGSJplssBHU4p8tBnT8LAZBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5Kpt4aQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5Kpt4aQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AD7C4AF0A;
	Tue, 25 Jun 2024 10:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309615;
	bh=dCAR1apLYOLSi2jN3thF8RHe7ggsc4iLz8a53F3xfoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5Kpt4aQxF8SNHAVYQ4ORnCyrHvY8/svgQypmdusM/flJ5cTOkoUpFLzNkuFT/+08
	 VsUVvGWM5dsIrUhIuk2kGwo9ghulx/N/LBqmbIp0hW7EE2lvch3ZTIZIseXYXqZtTa
	 ZM2Z8jcqOrGbGt4efz0GaDGV231PxGVbp021zVr4=
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
Subject: [PATCH 6.1 076/131] bnxt_en: Restore PTP tx_avail count in case of skb_pad() error
Date: Tue, 25 Jun 2024 11:33:51 +0200
Message-ID: <20240625085528.829975435@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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
index 77ea19bcdc6fe..20e2fae64e67f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -617,9 +617,6 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 
 tx_dma_error:
-	if (BNXT_TX_PTP_IS_SET(lflags))
-		atomic_inc(&bp->ptp_cfg->tx_avail);
-
 	last_frag = i;
 
 	/* start back at beginning and unmap skb */
@@ -641,6 +638,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
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



