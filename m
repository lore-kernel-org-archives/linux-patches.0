Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E379135AC18;
	Wed, 20 May 2026 17:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297623; cv=none; b=saCN+CzzT1GbPM/z45+FIK1KXMu63KrpeQi61VDoeLT1dnklNl0rho6tFxEacdZbOfUs7oFa5phDgFHKsLtJf5RyL8+Utrxkc4IPV8cp1AN0S2YLirvjcs4cwBSbF/ANOtzZYcHXBdAV3wq6Cix1YdlIjv13ubkX0eBU4n53F7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297623; c=relaxed/simple;
	bh=64PBuveBW6cZavJumq9IPsvzqsGjRsc7Hx+G0hOkV+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mwn9Hk1ZMkv1lP8/mCoaKLS/mV2Ir1v2XlmFa9qkArrYw5yu+CpbyuUUB2JlKck7LY9RxO2BobD3tqAvWAOnxSpjvgmi+F2Nh9GufyaGW794Dk0RwLmPN3RndAspAgAXJYLG8gpDc2DGDLnJPdHGslNtRV2y0vZl2H7KMV2N2E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCsiBvWQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCsiBvWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5631A1F000E9;
	Wed, 20 May 2026 17:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297621;
	bh=OkRAF2M74PZuejHTUsJBfo0YaRwb7FH/hDdf0zbQcsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TCsiBvWQy9Gy4rTFCnA9tAbt1ZFHUhQudnl+OUmKDTFRPHwz4HsD3uy0dWN5PpBE1
	 3rSrZGTq18K7xOG/7AbuaZ2XTx7NQhiwjIpT/HYzJCdGcoZksIf5AMCVV98Zm4J5Ww
	 rrumVu5LRwqBWgP7sIhuMqBULPhQ6koviqbPAUUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/957] wifi: mt76: mt7925: prevent NULL pointer dereference in mt7925_tx_check_aggr()
Date: Wed, 20 May 2026 18:09:27 +0200
Message-ID: <20260520162136.382551998@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 83ae3a18ba957257b4c406273d2da2caeea2b439 ]

Move the NULL check for 'sta' before dereferencing it to prevent a
possible crash.

Fixes: 44eb173bdd4f ("wifi: mt76: mt7925: add link handling in mt7925_txwi_free")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250904030649.655436-4-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index a048ab1feef05..f12b8db739653 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -845,11 +845,14 @@ static void mt7925_tx_check_aggr(struct ieee80211_sta *sta, struct sk_buff *skb,
 	bool is_8023;
 	u16 fc, tid;
 
+	if (!sta)
+		return;
+
 	link_sta = rcu_dereference(sta->link[wcid->link_id]);
 	if (!link_sta)
 		return;
 
-	if (!sta || !(link_sta->ht_cap.ht_supported || link_sta->he_cap.has_he))
+	if (!(link_sta->ht_cap.ht_supported || link_sta->he_cap.has_he))
 		return;
 
 	tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
-- 
2.53.0



