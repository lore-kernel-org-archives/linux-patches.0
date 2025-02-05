Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D86C155751;
	Wed,  5 Feb 2025 14:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765738; cv=none; b=VmBJycBBtHpuiNY2AofL3x7CAXNvdZrgjmXxJvXAYJZXsuB+aK2KCmWBLHf4+agfzJC8qPTGIK6QvBAGNo7NnsMO7UhPn580U8IyNPYMozLR/ttVbuMBNseA7MmuXpPhITxSn2Rizj9rXTPfllmddfXyEGLHr+qxiQHeTeJtPYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765738; c=relaxed/simple;
	bh=MHLxApZOTbGAkJozaD9PJb3OhJOGccITYKuPb5LAj2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqhsT4AKYurJ5ipwQ2hZWgoHXtPzYo4iAWrtV/bASuoKwZcyrI+v+gMsr1o12PpT+v0aH3XFWmmLtBnUSueMsPCN2/7ZHh2/1yM4IVZlvBbDDzNi4nG/vlM4g6gOAGdCG2SnQFJTrIrCJMqhBM9CmArEotD6iU9vr8wc8P6a7D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2uuo2uRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2uuo2uRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76784C4CED1;
	Wed,  5 Feb 2025 14:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765737;
	bh=MHLxApZOTbGAkJozaD9PJb3OhJOGccITYKuPb5LAj2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2uuo2uRC5rUaespyfDO1AwTJOIJCqhXzffd3hZjciOciLkt0Hi0lpOdjO28j5gC5J
	 1tf7albwC0Vw6XaPjzlEzL3tjZj6NkkhJ6R/tE64bbCQxv/R0pITEETyQ7tV+fYMuL
	 SuZk/OmAjgCr02X2Ap9RG/cFI2tWfaS6+Mf7VUS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 194/623] wifi: mt76: Enhance mt7925_mac_link_sta_add to support MLO
Date: Wed,  5 Feb 2025 14:38:56 +0100
Message-ID: <20250205134503.657716429@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit e6803d39a8aa59e557402a541a97ee04b06c49b2 ]

Enhance mt7925_mac_link_sta_add to support MLO.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-9-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 3cd3c3e289e72..1140af6577937 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -878,9 +878,14 @@ static int mt7925_mac_link_sta_add(struct mt76_dev *mdev,
 	link_conf = mt792x_vif_to_bss_conf(vif, link_id);
 
 	/* should update bss info before STA add */
-	if (vif->type == NL80211_IFTYPE_STATION && !link_sta->sta->tdls)
-		mt7925_mcu_add_bss_info(&dev->phy, mconf->mt76.ctx,
-					link_conf, link_sta, false);
+	if (vif->type == NL80211_IFTYPE_STATION && !link_sta->sta->tdls) {
+		if (ieee80211_vif_is_mld(vif))
+			mt7925_mcu_add_bss_info(&dev->phy, mconf->mt76.ctx,
+						link_conf, link_sta, link_sta != mlink->pri_link);
+		else
+			mt7925_mcu_add_bss_info(&dev->phy, mconf->mt76.ctx,
+						link_conf, link_sta, false);
+	}
 
 	if (ieee80211_vif_is_mld(vif) &&
 	    link_sta == mlink->pri_link) {
-- 
2.39.5



