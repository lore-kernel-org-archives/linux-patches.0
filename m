Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4812F9492;
	Tue, 17 Jun 2025 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177582; cv=none; b=qqJo8MKv7IwJ1uNPbzorLozKBkOg9JHX3VnXxaS4HINB/w/8hyjtYX3vPpt5RDkaON0MsMFcZP7a044J+gl3DBDjVEhhkB0HShGWuFoTgePXioHCbK4tuSZJI5DHToX7+u5sJ+4YH1MeUhJMUC6a7Zev+QWDHv2Z1g1yfbmtsRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177582; c=relaxed/simple;
	bh=USO2p/QdaUbmE4uU5NMzWpCMlAlXKf1ElgK4a6uWzPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P272+TftVj0tDc+XwoACF1HZGINCxyHb6ZL5z1baZI+RG9CNKX2ryZiatWY1tkaEdEXxRBUjFVQyHvpdKIjgUr/sYrSv/JbWiu1HE+7g2Q7FdqW2RoKyCzxqUu/zulK4T/6XzACvLngud9mXgwuq/fEO50SUXh8B1JeXKIyneiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QG6TKrK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QG6TKrK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0275C4CEE3;
	Tue, 17 Jun 2025 16:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177582;
	bh=USO2p/QdaUbmE4uU5NMzWpCMlAlXKf1ElgK4a6uWzPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QG6TKrK5C7Khszr394XCLyWF4ev0v3qE3i/VyRedSKg/u9EhV015QP0fD7+6hSxKY
	 f9Kq9KMA/RdqdLWrwDG1qPKYN2vuxsXi9a3SSRmQAT0qT0k9af9J+AlNgJm6Ib9Mnh
	 flSa7xLjY0ObPhPHtbCdopUD32sgM8IEihyDizt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 305/780] wifi: mt76: fix available_antennas setting
Date: Tue, 17 Jun 2025 17:20:13 +0200
Message-ID: <20250617152503.883643114@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 249173e94dd5edef9e704f89513de7d9715ddf22 ]

Check if available_antennas_tx and available_antennas_rx are already set
during the per-chip initialization phase; otherwise, they could be
overwritten with incorrect values.

Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20250515032952.1653494-8-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index b88d7e10742ee..e9605dc222910 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -449,8 +449,10 @@ mt76_phy_init(struct mt76_phy *phy, struct ieee80211_hw *hw)
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_AIRTIME_FAIRNESS);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_AQL);
 
-	wiphy->available_antennas_tx = phy->antenna_mask;
-	wiphy->available_antennas_rx = phy->antenna_mask;
+	if (!wiphy->available_antennas_tx)
+		wiphy->available_antennas_tx = phy->antenna_mask;
+	if (!wiphy->available_antennas_rx)
+		wiphy->available_antennas_rx = phy->antenna_mask;
 
 	wiphy->sar_capa = &mt76_sar_capa;
 	phy->frp = devm_kcalloc(dev->dev, wiphy->sar_capa->num_freq_ranges,
-- 
2.39.5



