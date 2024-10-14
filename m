Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E6F1C2327;
	Mon, 14 Oct 2024 15:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918904; cv=none; b=IBdfgfxcALFsiHH5F1NuorySo6oQGVq9thJOCQu543A2zXzxpKeYKcAglofaHKYVDxYLr61NanxcmNGY16vkmFtx9zOcUe/Z2WZtQa4oWenIQT/lAp1AFT3k8TYE1uXncHDG9UYX6MzojQM+r5PsdZDNcAEtQqvFoCjWWXKFIb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918904; c=relaxed/simple;
	bh=r4wLQCaBtvNXoo0kE0XuovDa4m2vqiyUsMEm/vdEAZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBhPOOwABFVHQ2fOWLRtSxpHwlRk50svIuhU+DrfQ7C0/Mz8TjO2irq5E7AAYvzTc1uOfyeUeIYLjka1CqdX0KEuH0oWxtEDoM/xaUXJBGwWOmpVBdLY5suefekUofIxBCua63D0I3Jw9nxRdyDlZ0oRw1XKbt4K9plNxDoIdNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFPM+gIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFPM+gIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B01C4CEC3;
	Mon, 14 Oct 2024 15:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918904;
	bh=r4wLQCaBtvNXoo0kE0XuovDa4m2vqiyUsMEm/vdEAZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFPM+gILHQbJuoXDA6o6ajPGCd7hHUOA+d5YbJj61Iu16oRwhKiQikPJqneQrFLQW
	 vw4ic3tfsPy44XCoTfh9h5WnOlipaN3jDlEJRU90/IaJQ2i8i1nP3OJsP0fzKayu9i
	 HcpJq/HjK0sChkvcMa9JlSymKX49LpHFCNHEdEIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 429/798] wifi: mt76: mt7915: disable tx worker during tx BA session enable/disable
Date: Mon, 14 Oct 2024 16:16:23 +0200
Message-ID: <20241014141234.807985256@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 65f07cc2acdd4..44fbfe3775e06 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -661,13 +661,17 @@ int mt7915_mcu_add_tx_ba(struct mt7915_dev *dev,
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



