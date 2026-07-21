Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C520E43031D;
	Tue, 21 Jul 2026 19:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662010; cv=none; b=uX+YSfoNIacFnhmSmaE1fal48Ml/kIL+YQoRwkYH4lO6UXk4WyzD8WL4w8R9gz7AHKmYEfAtxeWAVC3W3AIf+oSbgDZ8gR/UXRnOf8JJZx5Zz0btLiG+126pfluaRrahq+lruMxG3PJKMXzm5lohrtfaqgtqW8sk5fmo3e7nO38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662010; c=relaxed/simple;
	bh=vgS4MGBqOQ07BB9DS9VMCJqxwhRPClc0xMMMmmLkfQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFJ8GKh+j2+boOWqCw5rCKI/uzP8xc2Cai0aWMqZWYAZ+qY9jyFcIuYJgX9JF68WjfnzY/EUfKY1xdIpLNeJiNrbj6hrG9KxEXw0kbdSFlD31FzGYS1lfW45YGjJKgxyZhZRJu5FHq/E8TS97fhJNsq2IQTg3tIHHAyUsRcs0KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V279OM4V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V279OM4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6031F00A3A;
	Tue, 21 Jul 2026 19:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662008;
	bh=w45F+ztJfximLeCzcW3SOZkDIxoVeZzKw9TseGZAgv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V279OM4VK4uqz/0PUZrVyuH/I/X6eIY3z5eZavTNT5eeFwng0W2avgOXHXKQ/mY4y
	 3J6MhC4B9g7BWRx6tg0w7ojC3t26ZKd1mEULM9onnOXpw5NRR9btPYPSp4Rk/7BdlW
	 gejaTUrnXrNNvAHN0FSHec2UaPxh2LPkrnXWSxCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0283/1276] wifi: mt76: mt792x: skip MLD header rewrite for 802.3 encap TX
Date: Tue, 21 Jul 2026 17:12:06 +0200
Message-ID: <20260721152452.414010409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit a1152244702bb31b64650e5ca8308142286c0e4a ]

mt792x_tx() rewrites addr1/addr2/addr3 by treating skb->data as
an 802.11 header for MLD traffic.

That is only valid for native 802.11 frames. Direct 802.3 TX can also
reach this path with IEEE80211_TX_CTL_HW_80211_ENCAP set, where
skb->data is not an 802.11 header.

Skip the MLD header rewrite for HW-encap packets to avoid corrupting
802.3 frame contents.

Fixes: ebb1406813c6 ("wifi: mt76: mt7925: add link handling to txwi")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20260425144648.734030-1-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt792x_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index b87eed4d168df5..c6afdf90fade6e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -79,7 +79,8 @@ void mt792x_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		wcid = &mvif->sta.deflink.wcid;
 	}
 
-	if (vif && control->sta && ieee80211_vif_is_mld(vif)) {
+	if (vif && control->sta && ieee80211_vif_is_mld(vif) &&
+	    !(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)) {
 		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 		struct ieee80211_link_sta *link_sta;
 		struct ieee80211_bss_conf *conf;
-- 
2.53.0



