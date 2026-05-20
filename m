Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0539C3F54D4;
	Wed, 20 May 2026 18:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300088; cv=none; b=F/WYSqW5KuueGfHCxdyxmOocqXyKTqoZoMbjgH1TaKyRdq4zRP4qMI+1dJSJB2konEOdXGi2r36QmfBpLmPVquQP/Iox6iOSnSimdDT/P0iMaTunn+lHSl3RWJZDVritDbCAJWTkCgdm7yWzjmU1TJhW01VuIpRbAYsy4SBdGwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300088; c=relaxed/simple;
	bh=jJgpDioneoFMRsE1VlPkAoWJabE+GxR9p2aXnN0/QjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CA6gJEVCcrxw8/opAGvJtJVd9U2/2RNpKTfvRRn0sF6BUAEezun1AHpdssP3vmWCPRmSHeLU0rvFZJ5g4OhDcoSL/Rjp3WrZ+X1Wf/ITK+voyh3L45loD8v/5n80Ngp3jBlOSie1zW3LO/9frMiR+8883dEO5GHB/HnVwsJJW2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9Y5gASV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9Y5gASV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8280D1F00893;
	Wed, 20 May 2026 18:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300085;
	bh=7x0B1bMA6XdD3omTjjCMLbNmmUAjBi9OxYUcsb3cVb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9Y5gASVHpxY64eZMNPNS6QWjq7nf8FIHklzy2C2dXNWOSvWpdOyHiW5zJBZ12LcT
	 JgngTfiPAjS8tgS9JZH/j0So20JJwjsbOuNC7xmMX/cyZPipE5CoPna05s+zSqDuQA
	 B3SPI/AkyoUVfNRw+ROT0Cg7+JM8QMoyS/qpmJrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/666] wifi: mt76: mt7921: Reset ampdu_state state in case of failure in mt76_connac2_tx_check_aggr()
Date: Wed, 20 May 2026 18:14:13 +0200
Message-ID: <20260520162112.151064079@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

[ Upstream commit 53ffffeb9624ffab6d9a3b1da8635a23f1172b5e ]

Reset ampdu_state if ieee80211_start_tx_ba_session() fails in
mt76_connac2_tx_check_aggr(), otherwise the driver may incorrectly
assume aggregation is active and skip future BA setup attempts.

Fixes: 163f4d22c118 ("mt76: mt7921: add MAC support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20251216005930.9412-1-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index 268f414f0a023..05f2ff8e012b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -1135,8 +1135,10 @@ void mt76_connac2_tx_check_aggr(struct ieee80211_sta *sta, __le32 *txwi)
 		return;
 
 	wcid = (struct mt76_wcid *)sta->drv_priv;
-	if (!test_and_set_bit(tid, &wcid->ampdu_state))
-		ieee80211_start_tx_ba_session(sta, tid, 0);
+	if (!test_and_set_bit(tid, &wcid->ampdu_state)) {
+		if (ieee80211_start_tx_ba_session(sta, tid, 0))
+			clear_bit(tid, &wcid->ampdu_state);
+	}
 }
 EXPORT_SYMBOL_GPL(mt76_connac2_tx_check_aggr);
 
-- 
2.53.0



