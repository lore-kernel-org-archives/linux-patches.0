Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3FE36D518;
	Tue, 16 Dec 2025 12:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888032; cv=none; b=lFUqbFQnBzNLyoBeKlfGyW7+hws5L2jEroeC2RTW1rPvTFNgarUYzSlJSn9xfHPfQzeYyzbybcTv3wVYyfXngXHmwyYOXb2cnB8JWRbNLbkRp4bPlNB2e44qLZRX7s3d/+xAHt42bcszhH1oygDIPzcl3orh8Ozy/1WhwExHCGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888032; c=relaxed/simple;
	bh=xVrJoLfAdElO4kuFJFm2Yg4NOV6/tV/n5njFFxl6NXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzGzU5mFasBSUFCLcp4Fis0lOv873JNcJUoLQWDKK1vDQHxabdXAqc2lOgylLTSGrEetkKIMOJ0P2fNOfpBJqFaqg21SQnpJZo5hr9ozzDYb9AKqbS1Z7E//qMwelvCig942h04teDCO4SumU/Kmoc4RdhTLq6JzncyUTkFboYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rm1ubgXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rm1ubgXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7B1C4CEF1;
	Tue, 16 Dec 2025 12:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888032;
	bh=xVrJoLfAdElO4kuFJFm2Yg4NOV6/tV/n5njFFxl6NXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rm1ubgXe6lq6z7f5ImT5ElVSsFgp7HHnx1pnhqxU+/BH+ocbi3e/zF6j/hiRE/wS0
	 URGPa1/01veUh1GboKTF5bVW4FR68417fCB4JxM7oL5ZK1zfBBWsaBLzysdWbP2Qh9
	 kdVOgKEcZ5mIfESgERTkcim6r8zx8CkyxDEJu00k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 384/614] wifi: mt76: mt7996: Remove unnecessary link_id checks in mt7996_tx
Date: Tue, 16 Dec 2025 12:12:31 +0100
Message-ID: <20251216111415.282302208@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 084922069ceac4d594c06b76a80352139fd15f4d ]

Remove unnecessary link_id checks in mt7996_tx routine since if the link
identifier provided by mac80211 is unspecified the value will be
overwritten at the beginning on the function.

Fixes: f940c9b7aef6 ("wifi: mt76: mt7996: Set proper link destination address in mt7996_tx()")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250924-mt76_tx_unnecessary-check-v1-1-e595930a5662@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index b53ca702591c6..2b52d057287a1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1339,12 +1339,10 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 	}
 
 	if (mvif) {
-		struct mt76_vif_link *mlink = &mvif->deflink.mt76;
+		struct mt76_vif_link *mlink;
 
-		if (link_id < IEEE80211_LINK_UNSPECIFIED)
-			mlink = rcu_dereference(mvif->mt76.link[link_id]);
-
-		if (mlink->wcid)
+		mlink = rcu_dereference(mvif->mt76.link[link_id]);
+		if (mlink && mlink->wcid)
 			wcid = mlink->wcid;
 
 		if (mvif->mt76.roc_phy &&
@@ -1352,7 +1350,7 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 			mphy = mvif->mt76.roc_phy;
 			if (mphy->roc_link)
 				wcid = mphy->roc_link->wcid;
-		} else {
+		} else if (mlink) {
 			mphy = mt76_vif_link_phy(mlink);
 		}
 	}
@@ -1362,7 +1360,7 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 		goto unlock;
 	}
 
-	if (msta && link_id < IEEE80211_LINK_UNSPECIFIED) {
+	if (msta) {
 		struct mt7996_sta_link *msta_link;
 
 		msta_link = rcu_dereference(msta->link[link_id]);
-- 
2.51.0



