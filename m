Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5BC157E61;
	Tue,  9 Jul 2024 11:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523561; cv=none; b=JL8y/Zd8kGco1NrZFl0nZCDU2PuNArR4SQa6vSJzLcP2Yklh59dia6JyYVLIES8if519IkPjNVvvZ+47i6x3ns/bh7P62Y6uz4P2YqI0uRhTu5CegkFk5nlBy+PY8MAsSo22QIkg4Z8zFEBsJjdLjntgVqt3FGhU67m0p8MWSoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523561; c=relaxed/simple;
	bh=3a8/ybVDGA+sdlJH04V6lo0dXA32Xkk8QrJdiVle5DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1icP83pKKbldT6XInRz/qaBMoH7xB2sfVZyR5I+iM4V7Hrcyarnxw/tflX9Xq8t58jdke3RwVBJJ/FZxcjDcNUydKZBcz+zhRVIemhVv5q4dKSrD3K9bJrHZAkapvdBjoZe6qmAmrwnsDFCo60T8/cPnk5lt1DAgrNyoaTDrAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HO0iA6yT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HO0iA6yT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69E1C3277B;
	Tue,  9 Jul 2024 11:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523561;
	bh=3a8/ybVDGA+sdlJH04V6lo0dXA32Xkk8QrJdiVle5DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HO0iA6yTdXmW8pGGch12nddJKJY7W+caktjmQZyp+tr4eIxoUWqxJshehvESdwLUk
	 gkLCFNW3QTQIdbziHBAgf8EJSC692CgI/gpYte2uwXlJF44j8CC5KxxHKzytAihjok
	 c17c3a2Kv9NSw7FkRUplT4WIwGXAjCnzo8b/O8uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/139] wifi: mt76: mt7996: add sanity checks for background radar trigger
Date: Tue,  9 Jul 2024 13:08:53 +0200
Message-ID: <20240709110659.445091273@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit ec55d8e7dfea92daff87f5c01689633f8c4e6a62 ]

Check if background radar is enabled or not before manually triggering it,
and also add more checks in radar detected event.

Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c | 5 +++++
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c     | 5 ++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
index 4d40ec7ff57f5..630520c21a47f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
@@ -225,6 +225,11 @@ mt7996_radar_trigger(void *data, u64 val)
 	if (val > MT_RX_SEL2)
 		return -EINVAL;
 
+	if (val == MT_RX_SEL2 && !dev->rdd2_phy) {
+		dev_err(dev->mt76.dev, "Background radar is not enabled\n");
+		return -EINVAL;
+	}
+
 	return mt7996_mcu_rdd_cmd(dev, RDD_RADAR_EMULATE,
 				  val, 0, 0);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index b4ea7d0a7f5a0..b66f712e1b17b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -339,7 +339,10 @@ mt7996_mcu_rx_radar_detected(struct mt7996_dev *dev, struct sk_buff *skb)
 	if (r->band_idx >= ARRAY_SIZE(dev->mt76.phys))
 		return;
 
-	if (dev->rdd2_phy && r->band_idx == MT_RX_SEL2)
+	if (r->band_idx == MT_RX_SEL2 && !dev->rdd2_phy)
+		return;
+
+	if (r->band_idx == MT_RX_SEL2)
 		mphy = dev->rdd2_phy->mt76;
 	else
 		mphy = dev->mt76.phys[r->band_idx];
-- 
2.43.0



