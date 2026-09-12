Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B358381EBB;
	Sat, 12 Sep 2026 09:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207063; cv=none; b=bygOJ0Z72SEw7rZkiH5zZthe6n7uj8T+gbluUPtNkjGO/JW65iDGLB+wHmpUzg872DCbXpmdisn+JIbxZ4rEheLIthp9dTOJFlnRSC2Fg6iyT9Uf0BgX/fxOUWGCVmeHlybV6J9snBUa6gsD8mX+9oQEodOleFUu+AN1AOPLYIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207063; c=relaxed/simple;
	bh=G4gQpFU4+Jt4qdCwVqVqRVS8G+RZVb9PgayjszoP6vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHAvfJmKNevBBLIzmKklmKqK0GYOYa4rGwydbYjIVbGA5pXJZ7Wyr0Zf5rYUElVTqKzpWE9voVvffIPT8YgjkdLYKNei18m8jokgdRTqcVfLO6hlVRJoCT3lFyk7b0rc21De0j8Fega682QvMEdPuolK4Uvi6NE2eISrl4hU8rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkWJq2Gn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkWJq2Gn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3642D1F000FF;
	Sat, 12 Sep 2026 09:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207062;
	bh=F66iqsb5NKYQUNeGdh7I1nojU2SzSsa5Ko53iG4RSFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qkWJq2GnzKYgRz/TI/F1Wzne0eLwCBhxuSNEthkVjasFdtFWSPL7V1RoElfkD6WEG
	 K9p9NgROcmuI9dp2tNWtt9nVxAfS9sG5orU9GTAzT+++UyyI3vM+JKibkSFZZtO5Jh
	 /thPZ/T7jtTbP0NqNy//jsFZ7gNc+sT8W2+z//fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Chung Chen <damon.chen@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0336/1518] wifi: rtw89: mlo: rearrange MLSR link decision flow
Date: Sat, 12 Sep 2026 08:41:45 +0200
Message-ID: <20260912065631.072186190@linuxfoundation.org>
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

From: Kuan-Chung Chen <damon.chen@realtek.com>

[ Upstream commit 7284f5be5d298c901be1fc9fda6a2476f5ffdbaf ]

The original MLSR link decision refers to RSSI, but it should be
based on the premise of an existing link. Otherwise, make a link
decision to select a new link from any available band.

Signed-off-by: Kuan-Chung Chen <damon.chen@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260429132625.1659182-2-pkshih@realtek.com
Stable-dep-of: 9bf6bd6ed5ac ("wifi: rtw89: 8852a: fix RSSI report when average beacon RSSI is not ready")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 5fd15fc840d8c..2c37b94256f91 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -4270,13 +4270,19 @@ static void rtw89_core_mlsr_link_decision(struct rtw89_dev *rtwdev,
 {
 	unsigned int sel_link_id = IEEE80211_MLD_MAX_NUM_LINKS;
 	struct ieee80211_vif *vif = rtwvif_to_vif(rtwvif);
+	u8 decided_bands = BIT(RTW89_BAND_NUM) - 1;
 	struct rtw89_vif_link *rtwvif_link;
 	const struct rtw89_chan *chan;
 	unsigned long usable_links;
 	unsigned int link_id;
-	u8 decided_bands;
 	u8 rssi;
 
+	usable_links = ieee80211_vif_usable_links(vif);
+
+	rtwvif_link = rtw89_get_designated_link(rtwvif);
+	if (unlikely(!rtwvif_link))
+		goto select;
+
 	rssi = ewma_rssi_read(&rtwdev->phystat.bcn_rssi);
 	if (unlikely(!rssi))
 		return;
@@ -4288,12 +4294,6 @@ static void rtw89_core_mlsr_link_decision(struct rtw89_dev *rtwdev,
 	else
 		return;
 
-	usable_links = ieee80211_vif_usable_links(vif);
-
-	rtwvif_link = rtw89_get_designated_link(rtwvif);
-	if (unlikely(!rtwvif_link))
-		goto select;
-
 	chan = rtw89_chan_get(rtwdev, rtwvif_link->chanctx_idx);
 	if (decided_bands & BIT(chan->band_type))
 		return;
-- 
2.53.0



