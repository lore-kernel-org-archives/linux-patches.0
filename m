Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2225B1DF246;
	Sun,  7 Sep 2025 20:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277491; cv=none; b=ahqRk9Z4ccxMraBR4TxQu+1tnYx6WtiAcrzKG/7Rodkd+/t1v8vS55v3yo4NKtAqK0XTGp5H1s1YizRcXBaM3w3r5bSZXIxV+TbF2HKc5xiJ+/jPF4T0fu9aDnQvXiRcOp+sFvoSVSWED3pRfBGwxKTmpCrommbDNXarXxoHLMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277491; c=relaxed/simple;
	bh=W2ptkzTShpI+ACNEns4ZfqhAjc6vYYabOsSaGl8aP7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsHa+VQTwHpC8LmiyivzccBV2qaldQkyTQhfRz6o5nwqPFV9q+dFl7q/AgAoLzithPmGNif3DLuq8xwVIJhLwzsCmBkpL/1f6jMeYI67Uf/Rn7fRG2FYcXJEhW8r2r0L0V3qdjGeuWXkegVhOAiAFf0IZfkJGTGB11vTFBH7Cgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFD5hhNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFD5hhNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC35C4CEF0;
	Sun,  7 Sep 2025 20:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277490;
	bh=W2ptkzTShpI+ACNEns4ZfqhAjc6vYYabOsSaGl8aP7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFD5hhNSDiJ/gkPFtTPH1nA8pzri7j3LPHNaWwkEuF3JqNz+vDeZzQSFxSYYEV3uR
	 cgN7UgrBOTMAVWFfh6/Zv8TtKslRTyxbXW1FjZ5qnr7Ovg8/WNt/v5x8m0zPGa2qKF
	 WDQkXzVJOEdT0fBxqn1Ne2o0K98Ss6+VcDW5RKVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 032/183] wifi: mt76: mt7921: dont disconnect when CSA to DFS chan
Date: Sun,  7 Sep 2025 21:57:39 +0200
Message-ID: <20250907195616.539473739@linuxfoundation.org>
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

From: Janusz Dziedzic <janusz.dziedzic@gmail.com>

[ Upstream commit 87f38519d27a514c9909f84b8f1334125df9778e ]

When station mode, don't disconnect when we get
channel switch from AP to DFS channel. Most APs
send CSA request after pass background CAC. In other
case we should disconnect after detect beacon miss.

Without patch when we get CSA to DFS channel get:
"kernel: wlo1: preparing for channel switch failed, disconnecting"

Fixes: 8aa2f59260eb ("wifi: mt76: mt7921: introduce CSA support")
Signed-off-by: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Link: https://patch.msgid.link/20250716165443.28354-1-janusz.dziedzic@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 77f73ae1d7ecc..f6b431c422ebc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1457,11 +1457,8 @@ static int mt7921_pre_channel_switch(struct ieee80211_hw *hw,
 	if (vif->type != NL80211_IFTYPE_STATION || !vif->cfg.assoc)
 		return -EOPNOTSUPP;
 
-	/* Avoid beacon loss due to the CAC(Channel Availability Check) time
-	 * of the AP.
-	 */
 	if (!cfg80211_chandef_usable(hw->wiphy, &chsw->chandef,
-				     IEEE80211_CHAN_RADAR))
+				     IEEE80211_CHAN_DISABLED))
 		return -EOPNOTSUPP;
 
 	return 0;
-- 
2.50.1



