Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA0F3AE43
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD48C433EF;
	Wed,  7 Jun 2023 20:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169400;
	bh=AQZkEWPJZCOmrKCeBaK/NgPxSZBRArXcG/4wa1Lksfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zzSlW9pNcTsOodAp+n2ZhgFKU8LxLQcAcqwlICDOUUCr6ri8qlyduhXVbFJjaQvXK
	 1PoNYElXibopZReV879BflZfwMxWBlTM88w00hCyWAAOm2W+C8010oG9angbz3jQxJ
	 NMo1amHT3NlxM80lehnP8D3xcbAHxapJWwyucr1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 035/286] net: mellanox: mlxbf_gige: Fix skb_panic splat under memory pressure
Date: Wed,  7 Jun 2023 22:12:14 +0200
Message-ID: <20230607200924.176974780@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit d68cb7cf1fd0ef4287bc0ecd1ed0b6ae8e05fc70 ]

Do skb_put() after a new skb has been successfully allocated otherwise
the reused skb leads to skb_panics or incorrect packet sizes.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230524194908.147145-1-tbogendoerfer@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c    | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
index afa3b92a6905f..0d5a41a2ae010 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
@@ -245,12 +245,6 @@ static bool mlxbf_gige_rx_packet(struct mlxbf_gige *priv, int *rx_pkts)
 
 		skb = priv->rx_skb[rx_pi_rem];
 
-		skb_put(skb, datalen);
-
-		skb->ip_summed = CHECKSUM_NONE; /* device did not checksum packet */
-
-		skb->protocol = eth_type_trans(skb, netdev);
-
 		/* Alloc another RX SKB for this same index */
 		rx_skb = mlxbf_gige_alloc_skb(priv, MLXBF_GIGE_DEFAULT_BUF_SZ,
 					      &rx_buf_dma, DMA_FROM_DEVICE);
@@ -259,6 +253,13 @@ static bool mlxbf_gige_rx_packet(struct mlxbf_gige *priv, int *rx_pkts)
 		priv->rx_skb[rx_pi_rem] = rx_skb;
 		dma_unmap_single(priv->dev, *rx_wqe_addr,
 				 MLXBF_GIGE_DEFAULT_BUF_SZ, DMA_FROM_DEVICE);
+
+		skb_put(skb, datalen);
+
+		skb->ip_summed = CHECKSUM_NONE; /* device did not checksum packet */
+
+		skb->protocol = eth_type_trans(skb, netdev);
+
 		*rx_wqe_addr = rx_buf_dma;
 	} else if (rx_cqe & MLXBF_GIGE_RX_CQE_PKT_STATUS_MAC_ERR) {
 		priv->stats.rx_mac_errors++;
-- 
2.39.2



