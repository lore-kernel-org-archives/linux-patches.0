Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68DF37FF6D;
	Sat, 12 Sep 2026 08:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200852; cv=none; b=L1qyEErwDXx2GUqoPNqFuGWs1FBcv0QOjgjDKbe2kHoI0tysuURbdMcJTlbnqre7qjzLRIUbO8x52S0OHatTm/ENCl2Ha5r93D2Im5lfpO227kwB0Fl7ZpmgE5SROHOmaqrDzOmjcOsAEBvMs4tHKbsYADcj2uvlx1pY8UpwWbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200852; c=relaxed/simple;
	bh=riaIdkbGge3CBKSy1Ahq9mZS7f39hmf7yyh4QNT01OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0GGjNLMLq66MIloEIrpqjQ2o2NSIJ7aYhtWiAD8chaXBmkfPAjHsrKPqnEkuvgp+1zi/Uu6KHlLzkroH+Qq3qg1nGBujouXfq0Fr1wGK3MYOFaNEAaJJfP5bvMHZd+zTSBzmjHis59+PE+orAPMttkjBtIfK4srJAd1HJXigu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpF8m0KY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpF8m0KY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F231F00893;
	Sat, 12 Sep 2026 08:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200849;
	bh=mDawxjKRslhta4SmvhZmnBOevuIQZJy/Awa67Bve0R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LpF8m0KYEU13rj6yppORPSFJSyJTnrl5xEthCzHWfHyQUxDCDqQZAHJpfXHJc3jI5
	 7WcO0Yyw2gNGXm7TL19OD78ba7/qqhn5O6loOKOWNFWi9FsCOPB6TzYuVoIdU7IySE
	 b+h06UrD/Ot/EedUAuyU5tNnx4t1p2SygJLQGvFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Lu <rex.lu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0876/1815] wifi: mt76: fix RX data queuing of RRO 3.0
Date: Sat, 12 Sep 2026 08:43:46 +0200
Message-ID: <20260912065709.487724713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rex Lu <rex.lu@mediatek.com>

[ Upstream commit 86897f106669c07eea4c34b54c3268d448d41426 ]

For RRO 3.0, RX data released from a RRO data queue should be put to
the indicator queue. The frames are processed and completed in the
context of the indicator queue NAPI, which only polls skbs queued on
the MT_RXQ_RRO_IND list; frames queued under the data queue id are
left sitting on that list until the data queue NAPI happens to run,
stalling and reordering RX data.

Fixes: b1e58e137b61 ("wifi: mt76: mt7996: Introduce RRO MSDU callbacks")
Signed-off-by: Rex Lu <rex.lu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20260722082610.2699628-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index c4cbf7195b805..f92277770488a 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -893,6 +893,7 @@ static void mt76_rx_release_amsdu(struct mt76_phy *phy, enum mt76_rxq_id q)
 	struct sk_buff *skb = phy->rx_amsdu[q].head;
 	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
 	struct mt76_dev *dev = phy->dev;
+	struct mt76_queue *rxq = &dev->q_rx[q];
 
 	phy->rx_amsdu[q].head = NULL;
 	phy->rx_amsdu[q].tail = NULL;
@@ -921,6 +922,13 @@ static void mt76_rx_release_amsdu(struct mt76_phy *phy, enum mt76_rxq_id q)
 			return;
 		}
 	}
+
+	/* RRO 3.0 data queue skbs are processed and completed in the context
+	 * of the indicator queue NAPI, which only polls its own skb list
+	 */
+	if (mt76_queue_is_wed_rro_data(rxq) && dev->hwrro_mode == MT76_HWRRO_V3)
+		q = MT_RXQ_RRO_IND;
+
 	__skb_queue_tail(&dev->rx_skb[q], skb);
 }
 
-- 
2.53.0



