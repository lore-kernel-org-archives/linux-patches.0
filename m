Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168431DDA15;
	Tue,  8 Oct 2024 12:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391498; cv=none; b=jyfbVzTbscJSNEftooxnlA8jC1RgbKFbmKUyE8HBGekWCWMZmJvgjct1eJ6jdbJvz+zQ6r4s4OdvhWLvZinXoQ0hlaDAKDSyquO7wMCNdl8mNH9WQhggLg/F8BROtDmBGKipgkES9xCXzAibNKXssE7LQ24SxBzmOHx9sEZXlLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391498; c=relaxed/simple;
	bh=JU91iSpyq8mEQW/sp2AtesI29xiyt7imqjHTCc6wjK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3m/aXxQrtrpm1rO3N+LyIhRRsdoXi34ByuMYwnKGiDD319jDWbaCtSs5Xy3NEbgwVynGvBN3hv27cq3fdv/j8xvmHYo5ec6DtF/ft8NaiYecvKVBvnsdm2fkSlAqIhEWexdFL4eBOWOcEfvMYiAKF69n+HQVbi/LDLsDJqdLuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CgLHip+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CgLHip+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90647C4CEC7;
	Tue,  8 Oct 2024 12:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391498;
	bh=JU91iSpyq8mEQW/sp2AtesI29xiyt7imqjHTCc6wjK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CgLHip+9NSpE5tTTNpOux9rAt5uvvxTbAZUY9F3KpkpHozD8Vn4X/N5fHrlfF5Uiq
	 w28CaUi7TZ2DTn9lUShZ1VHdGiFfnuN0G/a8Gw1gayx5y9sfPvSAYIcuvnTdtT0TFf
	 xD3txK81sDqZ7qerxdyAzDLsmy83MIuBy4VyRXsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 106/558] wifi: mt76: mt7915: disable tx worker during tx BA session enable/disable
Date: Tue,  8 Oct 2024 14:02:16 +0200
Message-ID: <20241008115706.539658635@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 256cbd26fbafb30ba3314339106e5c594e9bd5f9 ]

Avoids firmware race condition.

Link: https://patch.msgid.link/20240827093011.18621-7-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 2185cd24e2e1c..2f4755820b3cd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -690,13 +690,17 @@ int mt7915_mcu_add_tx_ba(struct mt7915_dev *dev,
 {
 	struct mt7915_sta *msta = (struct mt7915_sta *)params->sta->drv_priv;
 	struct mt7915_vif *mvif = msta->vif;
+	int ret;
 
+	mt76_worker_disable(&dev->mt76.tx_worker);
 	if (enable && !params->amsdu)
 		msta->wcid.amsdu = false;
+	ret = mt76_connac_mcu_sta_ba(&dev->mt76, &mvif->mt76, params,
+				     MCU_EXT_CMD(STA_REC_UPDATE),
+				     enable, true);
+	mt76_worker_enable(&dev->mt76.tx_worker);
 
-	return mt76_connac_mcu_sta_ba(&dev->mt76, &mvif->mt76, params,
-				      MCU_EXT_CMD(STA_REC_UPDATE),
-				      enable, true);
+	return ret;
 }
 
 int mt7915_mcu_add_rx_ba(struct mt7915_dev *dev,
-- 
2.43.0



