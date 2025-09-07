Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85124315A;
	Sun,  7 Sep 2025 20:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277504; cv=none; b=oH0XwYYEg9mxL1gUtoStdjl01Nw6AM1zQadRjOfFfA5H+xpppy2LumThoTER6SNb1f1nTUwXKkGKTWE8rd/FAnR/UtkKLQbUojpy6xbygu1eBULI1ewGEtbA76XMMCHkB6ZsunlhqzxnNUqLSzKH/IbSqlo+LvlIfOU7eCCg/qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277504; c=relaxed/simple;
	bh=Rct5CgoUH0bHyv5Anx6w7r1PuwByiIN5HoQez8Dfr74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bx0cGjVs7EmHjRJqm/MqVMAFwPndpBHDpFwT81fRpWKhTvwAOI5r2V9pohM7dYBpV8JkhNImh9HcKvOIxLHq67DGUB7jD0702a2qwtV06nt9O79C51VSI8/Y7gKkPTf0mA60VXy1DHyyIZ6qNpCOfzGhf9mDfT1h7kcJgEwpn+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXvwB4ae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXvwB4ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1ACC4CEF0;
	Sun,  7 Sep 2025 20:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277503;
	bh=Rct5CgoUH0bHyv5Anx6w7r1PuwByiIN5HoQez8Dfr74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXvwB4ae5mewIthnCELlea490hLZESGQM3lSuR4eirtPWjm25AcW+v5R5pZt0rgyS
	 lujLF27+ZyoGs5XQIC30c2ltV7qx1vfc/wrmyeEF0ykAZhLkwZG+J5fychU58Na9eK
	 8jS+Itdl5tKYWZqCeFVxeU72ry0sCgerb3ah7t/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad@monroe.io>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 036/183] wifi: mt76: mt7996: use the correct vif link for scanning/roc
Date: Sun,  7 Sep 2025 21:57:43 +0200
Message-ID: <20250907195616.633738253@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chad Monroe <chad@monroe.io>

[ Upstream commit 4be3b46ec5190dc79cd38e3750480b2c66a791ad ]

restore fix which was dropped during MLO rework

Fixes: f0b0b239b8f3 ("wifi: mt76: mt7996: rework mt7996_mac_write_txwi() for MLO support")
Signed-off-by: Chad Monroe <chad@monroe.io>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/180fffd409aa57f535a3d2c1951e41ae398ce09e.1754659732.git.chad@monroe.io
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index f675cf537898a..b0fa051fc3094 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -903,8 +903,12 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 				       IEEE80211_TX_CTRL_MLO_LINK);
 
 	mvif = vif ? (struct mt7996_vif *)vif->drv_priv : NULL;
-	if (mvif)
-		mlink = rcu_dereference(mvif->mt76.link[link_id]);
+	if (mvif) {
+		if (wcid->offchannel)
+			mlink = rcu_dereference(mvif->mt76.offchannel_link);
+		if (!mlink)
+			mlink = rcu_dereference(mvif->mt76.link[link_id]);
+	}
 
 	if (mlink) {
 		omac_idx = mlink->omac_idx;
-- 
2.50.1



