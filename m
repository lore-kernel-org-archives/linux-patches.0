Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5140A1DEFF7;
	Tue,  8 Oct 2024 13:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393173; cv=none; b=KKuH8UzVOL9ABKGF71dZwgxw91apazguL85XUq051Iigvpt1qFSGM7wQ9LxFvy836c0U5tDH+fje0NZI12/wOUt+7KrXJtPHon6GqT+Fqd6wncmQjUwEZ+aRD+MfuwKW22HS1Hd4W+/aaJaZqIwai0vKAzYyi6LE71yQpDT/O+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393173; c=relaxed/simple;
	bh=PFg3hwUj009zlmp8IUUrlw4X1bv+RZjrCwKhFsHsH2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcoMUubV6HCJ8BqYhJMsy8ja8QOMrnggZ1xLhMm1+T3CwSDVXk3akYnq8ljFrxcXbNk6MEscDqP8Tdu4lIgrT2i6GdyQnyDOZVQDdi5GX9phItaqdCsG2XcP/fYrtALL8tZ2wurJ2cjTv63mHe2h0d7s9pHe0FsF/wO3aTn0ObE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=koMfkv9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="koMfkv9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4396C4CEC7;
	Tue,  8 Oct 2024 13:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393173;
	bh=PFg3hwUj009zlmp8IUUrlw4X1bv+RZjrCwKhFsHsH2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=koMfkv9UxFGjhsvrIogQ1esdw669WdaT+KFYDBrqwuJQEj9WBCG+NeImaEVc9ottD
	 FbDi7JIVOFCDlfR2/+BMWadi9XRd5WqMzRg3XW583SFuFvjWfPY0bkSQc5Mqszu/Tj
	 D7H2mPgKzJKzbSfT1rT4mVZW+tg72PgEejOb3rgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/386] wifi: mt76: mt7915: disable tx worker during tx BA session enable/disable
Date: Tue,  8 Oct 2024 14:05:19 +0200
Message-ID: <20241008115632.373630583@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
index 272e55ef8e2d2..5fba103bfd65d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -688,13 +688,17 @@ int mt7915_mcu_add_tx_ba(struct mt7915_dev *dev,
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



