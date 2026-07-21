Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0F33955F4;
	Tue, 21 Jul 2026 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649457; cv=none; b=WwINlCr3ppkWuGRI3wtkflEg9Q3b/SblCfdkB4TLjlc7f9hZLSnBZpXobYs0lDpU2XXr3fgHOf2y7d6okYwOpcjH9h4LeTNDDb6p78Msm7eO/f5PdqEKbnQKoB7h+VF5+NF5iKwuSBrRxa6BH/cGBg4aUC8RoPig7DkaLypkK4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649457; c=relaxed/simple;
	bh=ppO66pg/OjW+BNmS+BeYbeFm+BqRHtnNOasiVuLbUZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpjean/yvV5P30BV5QC2DizUwprq0L1MzEXXght9Pg+pWcHj2ib+raTQT+FqhKrbiH4f2Q2yyTUtTJMrsT7DBsw7ERtvZ6LKSay+T8N1031FfBgcBipGq1wJLAo+ewlyyLovMVsmpnHuMNVtHaXlFvGqfEE7YzCp3BvdEa1uP98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdhDcsNF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdhDcsNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E84A1F000E9;
	Tue, 21 Jul 2026 15:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649455;
	bh=jrl9ulaGZL56/XOO0ID8ctZ36fTlS19lw9TtEnTPiSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cdhDcsNFgWV4NCtjQ0gwMggRSrrSagclVdo+C+6ZstUt0tQf0/gUQN8n0QXwvPZgR
	 P1+DpgIEl1d+t6L0URrPP2sri9RNEYhYoxgUgUidhInVxRCXVgaOvZ4qxTLp3cwk6S
	 bMeWTjtFv3TyXPsNtdVw5+tXJM9s5VnfcxeEuLFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Ting Hsieh <yao-ting.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0584/2077] wifi: mt76: mt7925: keep TX BA state in the primary WCID
Date: Tue, 21 Jul 2026 17:04:17 +0200
Message-ID: <20260721152606.587105709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index c47bd812b66b9c..f025c0efeda217 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -841,7 +841,6 @@ static void mt7925_tx_check_aggr(struct ieee80211_sta *sta, struct sk_buff *skb,
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_link_sta *link_sta;
-	struct mt792x_link_sta *mlink;
 	struct mt792x_sta *msta;
 	bool is_8023;
 	u16 fc, tid;
@@ -880,14 +879,14 @@ static void mt7925_tx_check_aggr(struct ieee80211_sta *sta, struct sk_buff *skb,
 
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



