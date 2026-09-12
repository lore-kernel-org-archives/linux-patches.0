Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D243750D6;
	Sat, 12 Sep 2026 08:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200865; cv=none; b=khrdGV8rNHFk/4/EKjIqwS+alnxRLLsJIK4z+1NrwJYfwNTnm5FufN+NtWY55XsugQutxkPW50UsxeE+pJpz6gZzRr39OPamEaY9sXxHlXRQlX50lxjYuj2dSxtB5HExHZNT8KxOyXxlvNd4SYoolsfNwg1QHBKSdie7FrAlJyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200865; c=relaxed/simple;
	bh=RU31OsDq1LVffWkaMSliEvNcq6MFJsUXLQ2NJkQMSUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m73JFKwfIgQ54/y0jVKA3y90X0PcbuhhGSEB8XmcPH3TtpI1rp2V1CPV7r32t9sFnj0Neyr2X6SYweNED/v2ERLx+MPc+pFvRQGIKMJMP/zLYF13taKTzES/nYytRkv4RhRbH09AQCjcqWyMxk7guEwhO8RyM6ZyVz79XX86d48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGNoYhq+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGNoYhq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B211F000FF;
	Sat, 12 Sep 2026 08:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200864;
	bh=/wqzxSIiBPVh6onYMPTfmBr4YylUcJQuFPnpmPNOACs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGNoYhq+da0pygTY/F21qaucgWq92TPX2R3i45r2tf0nqZb5r9/PShyODCC0XYDpu
	 ooSf4xsvTrqm/OO3twKKZ5wko66KZWENsRBDh9pIVfz+qiALVLArq+pgxP6mfvLyIL
	 XMmaoTfRMeEPAs6kuIZjOELB6hccr5ob2BGKkY2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael-CY Lee <michael-cy.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0879/1815] wifi: mt76: assign link_id when sending probe request during scan
Date: Sat, 12 Sep 2026 08:43:49 +0200
Message-ID: <20260912065709.556021446@linuxfoundation.org>
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
index 7fe1b1fbb699b..325638d587c96 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -48,6 +48,7 @@ mt76_scan_send_probe(struct mt76_dev *dev, struct cfg80211_ssid *ssid)
 	struct mt76_phy *phy = dev->scan.phy;
 	struct ieee80211_tx_info *info;
 	struct sk_buff *skb;
+	u8 link_id;
 
 	skb = ieee80211_probereq_get(phy->hw, vif->addr, ssid->ssid,
 				     ssid->ssid_len, req->ie_len);
@@ -77,6 +78,10 @@ mt76_scan_send_probe(struct mt76_dev *dev, struct cfg80211_ssid *ssid)
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



