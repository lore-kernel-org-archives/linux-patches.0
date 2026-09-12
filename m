Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B733C9ED6;
	Sat, 12 Sep 2026 10:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209058; cv=none; b=Fm0RCHy4kItItwDZw/pSNmFqHTgYXbqNEXZmz4qKIqdfvqLGiu0Sbg03dSOV7pcttZxcIw6kFfrxgjlRICSPCJb2hEHmq0rNAorsZwpKBkKnXw6UmmMrxqR3hZMv0troMaMpWJDFPyMwQ7U9IDHapTE89cFCy7Qx6vK9egzwZhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209058; c=relaxed/simple;
	bh=7J2UOy4p2nxbZYVeh+XokxpmhY2VdhDmQtne8kMT0RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBwhJekX6k1CjTfbfmdbayHFSl6OMo3qDFuotzeMQBzLbEtlFZR/xqvxPcPrzyALr156jAPmrna1Eqdm/+5W7h8WMGBUJDc07ucYIBxp5bhMLSqhhuaJsUPB77o+PxdZc2wI4o2M39eLZjtjdT37KFXmrPf27yvHcE/uhKqDQHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRbO5v0F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRbO5v0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EBA1F000FF;
	Sat, 12 Sep 2026 10:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209054;
	bh=u9DZX+90fwXMjXLqLdElJztfaDUiEKZjhN6fbiW6rbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRbO5v0FK6ZO3ymk55IYNNdfhCbFryYnPtsPM5BRnuIK0bThLcHYNi0xvIDXBoQTE
	 TjjQkWHj4tKGPWbeMEROotFwnyxatlQUsi/jDhLt2eG205PrqOmL0e9D55og3Mfoau
	 8voqfjufd8eEcf3pBEKXAm9nh9FqgJmomxJRAyNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael-CY Lee <michael-cy.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0744/1518] wifi: mt76: assign link_id when sending probe request during scan
Date: Sat, 12 Sep 2026 08:48:33 +0200
Message-ID: <20260912065640.262728813@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael-CY Lee <michael-cy.lee@mediatek.com>

[ Upstream commit f137fabc1313427e08af06a414d929ebd9fd37d6 ]

The link_id in info->control.flags is required by mt7996 to select the
correct mt76_wcid for transmission.

Not assigning the link_id in info->control.flags is equivalent to
assigning the link_id to 0, causing mt7996 to select link_id 0 for
transmission, so probe requests sent on behalf of an MLD vif scanning
via a different link were transmitted with the wrong per-link wcid.

Fixes: 31083e38548f ("wifi: mt76: add code for emulating hardware scanning")
Signed-off-by: Michael-CY Lee <michael-cy.lee@mediatek.com>
Link: https://patch.msgid.link/20260722082610.2699628-5-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/scan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index 6cfca5108bc7e..2faa84c516e7b 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -46,6 +46,7 @@ mt76_scan_send_probe(struct mt76_dev *dev, struct cfg80211_ssid *ssid)
 	struct mt76_phy *phy = dev->scan.phy;
 	struct ieee80211_tx_info *info;
 	struct sk_buff *skb;
+	u8 link_id;
 
 	skb = ieee80211_probereq_get(phy->hw, vif->addr, ssid->ssid,
 				     ssid->ssid_len, req->ie_len);
@@ -75,6 +76,10 @@ mt76_scan_send_probe(struct mt76_dev *dev, struct cfg80211_ssid *ssid)
 		info->flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
 	info->control.flags |= IEEE80211_TX_CTRL_DONT_USE_RATE_MASK;
 
+	link_id = mvif->wcid ? mvif->wcid->link_id : IEEE80211_LINK_UNSPECIFIED;
+	info->control.flags &= ~IEEE80211_TX_CTRL_MLO_LINK;
+	info->control.flags |= u32_encode_bits(link_id, IEEE80211_TX_CTRL_MLO_LINK);
+
 	mt76_tx(phy, NULL, mvif->wcid, skb);
 
 out:
-- 
2.53.0



