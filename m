Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8ED381AE3;
	Sat, 12 Sep 2026 08:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200904; cv=none; b=oLqTXPsFBDGzNIsvpy9DkTh419zWfqDS+wXOU0fKg2lRdziPc7OuXzfGx7s5XQ4Zv9P34mUI9BHtRBIXmyGaIlUXIk2ds2J5z90kP6FVBvOYdSKT6W5oRCA3oAy7SqiraCBjOwDnvHWnVfl+SF5vZ2mqZTXr76dVztuq1ENb9GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200904; c=relaxed/simple;
	bh=RdKlkZzB1uTFaaFhdH6h8IBGlswv957I9AyeGGlk41w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHYL3yspxN4qkNjuiuA5Dww8UmtpdWW9tBNRCpsxxgzf4HQf4Z9EEy3eYKI1nPPr33s/PBOFIi/gtk8W5YPsTCmWqCDXcqaIgjd/aZGFYlalhZaA/40wi+x0YYIW+jc6qo0QWwIo7xwkjG4I8a4Fsu9j4c/czyyhzbNbGbNhP+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Garsgtjc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Garsgtjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF8D1F000FF;
	Sat, 12 Sep 2026 08:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200903;
	bh=ZxEiuc59YKTC/JH5YgdnlZiwwg24CD1YI9gkg4sBPDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GarsgtjceOznpTpMDfmUwyk2/j81YfMt7ms0au3OospTkU5t8WW66MJP/SusuR+4X
	 zAO8/m+qFAcrDc1x0H4kRUbJ4QASZVtwInYJSV0TQyfAXMOsKo4ZCqvY/ttRFsAT5W
	 hiH1Q7KpVRWQ6u3bjYHBoQCQRIHCe046QyWv04xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0886/1815] wifi: mt76: fix 4th chain ACK RSSI bitmask in sta_poll
Date: Sat, 12 Sep 2026 08:43:56 +0200
Message-ID: <20260912065709.718719732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 5caa622956166f6c445a384c7e964da4d553a501 ]

The per-chain response-frame RSSI values are packed one per byte, but the
4th chain was extracted with GENMASK(31, 14) instead of GENMASK(31, 24).
The wrong mask overlaps chains 1-3 and shifts by 14, producing a garbage
chain-3 value that corrupts ack_signal/avg_ack_signal on 4x4 radios.
Extract the correct byte.

Fixes: a71b648e3527 ("wifi: mt76: mt7915: add ack signal support")
Fixes: ea5d99d07fbf ("wifi: mt76: mt7996: enable ack signal support")
Fixes: 67fc7a304bf5 ("wifi: mt76: mt7921: add ack signal support")
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Link: https://patch.msgid.link/20260722082610.2699628-12-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 334c19ab2b22c..1913c7613909e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -221,7 +221,7 @@ static void mt7915_mac_sta_poll(struct mt7915_dev *dev)
 		rssi[0] = to_rssi(GENMASK(7, 0), val);
 		rssi[1] = to_rssi(GENMASK(15, 8), val);
 		rssi[2] = to_rssi(GENMASK(23, 16), val);
-		rssi[3] = to_rssi(GENMASK(31, 14), val);
+		rssi[3] = to_rssi(GENMASK(31, 24), val);
 
 		msta->ack_signal =
 			mt76_rx_signal(msta->vif->phy->mt76->antenna_mask, rssi);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 17014b1f91e0c..e69978184f68c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -156,7 +156,7 @@ static void mt7921_mac_sta_poll(struct mt792x_dev *dev)
 		rssi[0] = to_rssi(GENMASK(7, 0), val);
 		rssi[1] = to_rssi(GENMASK(15, 8), val);
 		rssi[2] = to_rssi(GENMASK(23, 16), val);
-		rssi[3] = to_rssi(GENMASK(31, 14), val);
+		rssi[3] = to_rssi(GENMASK(31, 24), val);
 
 		mlink->ack_signal =
 			mt76_rx_signal(msta->vif->phy->mt76->antenna_mask, rssi);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 9b58ffec36493..b52b678330604 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -145,7 +145,7 @@ static void mt7925_mac_sta_poll(struct mt792x_dev *dev)
 		rssi[0] = to_rssi(GENMASK(7, 0), val);
 		rssi[1] = to_rssi(GENMASK(15, 8), val);
 		rssi[2] = to_rssi(GENMASK(23, 16), val);
-		rssi[3] = to_rssi(GENMASK(31, 14), val);
+		rssi[3] = to_rssi(GENMASK(31, 24), val);
 
 		mlink->ack_signal =
 			mt76_rx_signal(msta->vif->phy->mt76->antenna_mask, rssi);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 6530fb9b45c1c..7024fadce2048 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -166,7 +166,7 @@ static void mt7996_mac_sta_poll(struct mt7996_dev *dev)
 		rssi[0] = to_rssi(GENMASK(7, 0), val);
 		rssi[1] = to_rssi(GENMASK(15, 8), val);
 		rssi[2] = to_rssi(GENMASK(23, 16), val);
-		rssi[3] = to_rssi(GENMASK(31, 14), val);
+		rssi[3] = to_rssi(GENMASK(31, 24), val);
 
 		mlink = rcu_dereference(msta->vif->mt76.link[wcid->link_id]);
 		if (mlink) {
-- 
2.53.0



