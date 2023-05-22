Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68DB171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25ABFC4339B;
	Mon, 22 May 2023 19:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783808;
	bh=wr8VsoTcaARGTs3XbuORuraiZThopmKgOtfl/txzAVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ML1h5obVwDcmoHSeM0t0IqrtFwAd2Tslj2KZBCOF+PP0Um4MfI1VY24npzd0J26FO
	 wz+XzoZSgA32G11dzfqWOI0XCct7itQfWPQl5wD3/qaJgZm0v+jab78G9e0aJya8k4
	 NhmrlZGWOGoywZzTmN+Mazb/hcLtNTfUka04j6xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/292] wifi: mt76: connac: fix stats->tx_bytes calculation
Date: Mon, 22 May 2023 20:08:46 +0100
Message-Id: <20230522190410.189196473@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit c7ab7a29ef5c0779574120d922256ce4651555d3 ]

The stats->tx_bytes shall subtract retry byte from tx byte.

Fixes: 43eaa3689507 ("wifi: mt76: add PPDU based TxS support for WED device")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/b3cd45596943cf5a06b2e08e2fe732ab0b51311b.1682285873.git.ryder.lee@mediatek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac2_mac.h | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c  | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac2_mac.h b/drivers/net/wireless/mediatek/mt76/mt76_connac2_mac.h
index f33171bcd3432..c3b692eac6f65 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac2_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac2_mac.h
@@ -163,7 +163,7 @@ enum {
 #define MT_TXS5_MPDU_TX_CNT		GENMASK(31, 23)
 
 #define MT_TXS6_MPDU_FAIL_CNT		GENMASK(31, 23)
-
+#define MT_TXS7_MPDU_RETRY_BYTE		GENMASK(22, 0)
 #define MT_TXS7_MPDU_RETRY_CNT		GENMASK(31, 23)
 
 /* RXD DW1 */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index 19f02b632a204..68511597599e3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -570,7 +570,8 @@ bool mt76_connac2_mac_fill_txs(struct mt76_dev *dev, struct mt76_wcid *wcid,
 	/* PPDU based reporting */
 	if (FIELD_GET(MT_TXS0_TXS_FORMAT, txs) > 1) {
 		stats->tx_bytes +=
-			le32_get_bits(txs_data[5], MT_TXS5_MPDU_TX_BYTE);
+			le32_get_bits(txs_data[5], MT_TXS5_MPDU_TX_BYTE) -
+			le32_get_bits(txs_data[7], MT_TXS7_MPDU_RETRY_BYTE);
 		stats->tx_packets +=
 			le32_get_bits(txs_data[5], MT_TXS5_MPDU_TX_CNT);
 		stats->tx_failed +=
-- 
2.39.2



