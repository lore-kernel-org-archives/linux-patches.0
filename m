Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8A64E0206;
	Thu, 17 Sep 2026 18:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668023; cv=none; b=gaNaIv3nVQzawYHmyy3sfDoOeIA19YtGCv98/mlhNYXZRvCAflKHBEimBhaGKwyFn4ZeaN7LZUBjTSU61YYh9ensw3gNUqkXQpZtgXMNXr9N2vHGwVWUWSvFsH4YvkrQPE4WC6UxJgZ8rph1KPYyUJ1DvMf/zyq3NDH6pXV2R+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668023; c=relaxed/simple;
	bh=Aptz6ExpGOpRARvo0HkGIXtjTh5rdgOo+kwlJ0eWXNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CaYhOtZ71rj0X3NHvjQ6iQz4Enycv4+BKC6WYkXeyzvBpxantstX6fkIzgLTMsYrerq8JcrKQ0GwvR3+Q94zl5+Z7OqPwy4kCW2V6mMU74a3ib1mu7zE7bVlvSRDKnDR8JNi8JmIWW6lN4A/wF7Uhqpuu7FqLk5sHZAWmNxxH2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFNsKeRQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFNsKeRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29871F000FF;
	Thu, 17 Sep 2026 18:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668021;
	bh=RfAQG0bTeUxNEdj2m5pH9qWekJpU1qHozzWDtcXK+YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFNsKeRQN5SaY1YBUiB9yiE1c8Yu28qv7efgS2tvoopEjvYYg5oYIPiImpI/yGTF5
	 n8nh7GSlO3kyhTNc5tnP9drdRVHUSlfOoHUkD8MFRWLV24T0+gVF6C8uVl0PpcJhaP
	 eVgXQRs8YyypSvXqeSVk+YsfCZM7AjzDHBdxE7LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcin FM <marcin@lgic.pl>,
	Cristian-Florin Radoi <radoi.chris@gmail.com>,
	George Salukvadze <giosal90@gmail.com>,
	Evgeny Kapusta <3193631@gmail.com>,
	Samu Toljamo <samu.toljamo@gmail.com>,
	Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>,
	Chapuis Dario <chapuisdario4@gmail.com>,
	=?UTF-8?q?Thibaut=20Fran=C3=A7ois?= <tibo@humeurlibre.fr>,
	=?UTF-8?q?=E5=BC=A0=E6=97=AD=E6=B6=B5?= <Loong.0x00@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Javier Tia <floss@jetm.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0255/1102] wifi: mt76: mt7925: handle 320MHz bandwidth in RXV and TXS
Date: Thu, 17 Sep 2026 16:03:18 +0100
Message-ID: <20260917151545.996841207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Tia <floss@jetm.me>

[ Upstream commit 2237b7b332990f135c1f1550b45ac77b29bcbf7b ]

The RX vector (RXV) and TX status (TXS) parsing in mac.c lack handling
for 320MHz channel width. When the hardware reports 320MHz in the
bandwidth field, mt7925_mac_fill_rx_rate() returns -EINVAL and
mt7925_mac_add_txs_skb() records no bandwidth stats.

Add IEEE80211_STA_RX_BW_320 cases to both functions. The RXV parser
also handles BW_320+1 since the hardware can report 320MHz in two
adjacent encoding positions.

Tested-by: Marcin FM <marcin@lgic.pl>
Tested-by: Cristian-Florin Radoi <radoi.chris@gmail.com>
Tested-by: George Salukvadze <giosal90@gmail.com>
Tested-by: Evgeny Kapusta <3193631@gmail.com>
Tested-by: Samu Toljamo <samu.toljamo@gmail.com>
Tested-by: Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>
Tested-by: Chapuis Dario <chapuisdario4@gmail.com>
Tested-by: Thibaut François <tibo@humeurlibre.fr>
Tested-by: 张旭涵 <Loong.0x00@gmail.com>
Reviewed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Javier Tia <floss@jetm.me>
Link: https://patch.msgid.link/20260425195011.790265-4-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index a8fbf3b50f3d5..41b2fe4b65bb9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -338,6 +338,11 @@ mt7925_mac_fill_rx_rate(struct mt792x_dev *dev,
 	case IEEE80211_STA_RX_BW_160:
 		status->bw = RATE_INFO_BW_160;
 		break;
+	/* RXV can report 320 in two positions */
+	case IEEE80211_STA_RX_BW_320:
+	case IEEE80211_STA_RX_BW_320 + 1:
+		status->bw = RATE_INFO_BW_320;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -999,6 +1004,10 @@ mt7925_mac_add_txs_skb(struct mt792x_dev *dev, struct mt76_wcid *wcid,
 	stats->tx_mode[mode]++;
 
 	switch (FIELD_GET(MT_TXS0_BW, txs)) {
+	case IEEE80211_STA_RX_BW_320:
+		rate.bw = RATE_INFO_BW_320;
+		stats->tx_bw[4]++;
+		break;
 	case IEEE80211_STA_RX_BW_160:
 		rate.bw = RATE_INFO_BW_160;
 		stats->tx_bw[3]++;
-- 
2.53.0



