Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B312E47125B;
	Tue, 21 Jul 2026 17:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656485; cv=none; b=AZECkyEA0XRwAS63Pp+ABQvIYU4T1cIm3h7ZZguZDWx2G9iUIfJ/QkoYhkpp5JG54Z0ag3IEYb/MbI2qTJivXthCG1Zz4aU1LZLr46wvQAgPmgSC98egXPhcvyxlc2wQXQN/JGp+KOwsbL1AkU/hz0y4l9JxNCPtOdu+EQ63/Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656485; c=relaxed/simple;
	bh=8i5Dx1miJG96Jd0PvH55jGkwdMgBRRXuRv3yXMpmd0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9F3OPQP2W0mLAxF8NmnQdhPx3Oab5fc5LgxiSe+lEB5NL0eru9s5N87js9BrB9CTYXoAIJcyiFRZQzaNZ5qksssEEhmz0U5EqDcmKgKa3xmomljmr8PCZgwHK93+BGGkkAZMu82T2WJl9dMOUev0vEgYtJX99UsDjK6C5QkdHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVRlEkFB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVRlEkFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA481F00A3A;
	Tue, 21 Jul 2026 17:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656484;
	bh=CW4BzEFdb+IORD79tBDCuJhmhtm1+MJGq1irqMiQ0q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVRlEkFB/FjfPPA4hOhvmlmgb9/UbjrQsg8NuuGNryBVlJpPV33wu7vOygcmllu4+
	 WTcWanMT5DN3fJST92JdQHCkQ5eveTo63t+xhpTBgbIJ3BMzTks4qmYe3cMD2DW9AI
	 4b0aR5qeEaIX1FUkQE+sO4cpITIodQlGj2GvOJ3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Ting Hsieh <yao-ting.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0404/1611] wifi: mt76: mt7925: keep TX BA state in the primary WCID
Date: Tue, 21 Jul 2026 17:08:40 +0200
Message-ID: <20260721152524.330388281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit d3c854068bad22a25db6515f12784f64c663fed2 ]

For MLO, the same TID can run over different links. Keeping TX BA state in
a link WCID makes the state depend on which link starts aggregation first.

Store it in the primary WCID instead, so the BA state stays stable across
links.

Fixes: 44eb173bdd4f ("wifi: mt76: mt7925: add link handling in mt7925_txwi_free")
Tested-by: Yao Ting Hsieh <yao-ting.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20260425154721.738101-1-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 0608f0c1fd2c29..86de9ba6cde4f3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -840,7 +840,6 @@ static void mt7925_tx_check_aggr(struct ieee80211_sta *sta, struct sk_buff *skb,
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_link_sta *link_sta;
-	struct mt792x_link_sta *mlink;
 	struct mt792x_sta *msta;
 	bool is_8023;
 	u16 fc, tid;
@@ -879,14 +878,14 @@ static void mt7925_tx_check_aggr(struct ieee80211_sta *sta, struct sk_buff *skb,
 
 	msta = (struct mt792x_sta *)sta->drv_priv;
 
-	if (sta->mlo && msta->deflink_id != IEEE80211_LINK_UNSPECIFIED)
-		mlink = rcu_dereference(msta->link[msta->deflink_id]);
-	else
-		mlink = &msta->deflink;
-
-	if (!test_and_set_bit(tid, &mlink->wcid.ampdu_state)) {
+	/* Packets belonging to the same TID can be transmitted over multiple
+	 * links. Keep the TX BA session state in the primary link so all links
+	 * share the same AMPDU bookkeeping.
+	 */
+	if (!test_and_set_bit(tid, &msta->deflink.wcid.ampdu_state)) {
 		if (ieee80211_start_tx_ba_session(sta, tid, 0))
-			clear_bit(tid, &mlink->wcid.ampdu_state);
+			clear_bit(tid, &msta->deflink.wcid.ampdu_state);
+
 	}
 }
 
-- 
2.53.0



