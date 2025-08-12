Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95E061FFE;
	Tue, 12 Aug 2025 18:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023777; cv=none; b=LcV04JNkPbWznx/McyknjKtjD8a133h4f8ceGCI84n2iaqbqDYas72fsCeYqaqPf0rfw/CiCDS0TkzMR2xKynvzJOHp4xQNP1oRNbid5LPXX4RJveCRdXJPuPZ6g1D6voyFZKhhhcW8uadfjLurNTUS2QBQEFp4LODIsla4J/Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023777; c=relaxed/simple;
	bh=pRH90TvtdM5KvJo3m/LOex0gqNqVr/a4gP//qrE0cMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjFPbLpkwDRb4IO1vJwmC+Gu53WG2KZraW8eOj9l5k1n7wteqqpLRy2RXPxIk4vzrBp4FHhpILK6Genq9rsTI9RhbFQQfOJtvoCmdlLZqcbp4rAcUtYNL+eIeVo96D30CNlSqKDULa5VEwW9+PAsCYwpGIobCModbAXI8W8WQVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yiVVgmnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiVVgmnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31795C4CEF0;
	Tue, 12 Aug 2025 18:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023777;
	bh=pRH90TvtdM5KvJo3m/LOex0gqNqVr/a4gP//qrE0cMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yiVVgmnI933PdQai+Vp3zNlJY5ahUzzXFCJ/eyRS4wUmqII6K0mkQqyQPazayG6mi
	 sklkRHD+J06hKy3n3lhc5nd3PCDpwXQnqeF1kwtsAgnzbQVQMljah83f6OLrBCstHF
	 drJYYG56fOf3xVUpWGegO0IYr+4EemgUY9bowLgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 179/627] wifi: mt76: mt7925: fix off by one in mt7925_mcu_hw_scan()
Date: Tue, 12 Aug 2025 19:27:54 +0200
Message-ID: <20250812173426.091633228@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit b3a431fe2e399b2e0cc5f43f7e9d63d63d3710ee ]

The ssid->ssids[] and sreq->ssids[] arrays have MT7925_RNR_SCAN_MAX_BSSIDS
elements so this >= needs to be > to prevent an out of bounds access.

Fixes: 8284815ca161 ("wifi: mt76: mt7925: add RNR scan support for 6GHz")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aDVT2tPhG_8T0Qla@stanley.mountain
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 8ac6fbb736ab..300c863f0e3e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2916,7 +2916,7 @@ int mt7925_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	for (i = 0; i < sreq->n_ssids; i++) {
 		if (!sreq->ssids[i].ssid_len)
 			continue;
-		if (i > MT7925_RNR_SCAN_MAX_BSSIDS)
+		if (i >= MT7925_RNR_SCAN_MAX_BSSIDS)
 			break;
 
 		ssid->ssids[n_ssids].ssid_len = cpu_to_le32(sreq->ssids[i].ssid_len);
@@ -2933,7 +2933,7 @@ int mt7925_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 		mt76_connac_mcu_build_rnr_scan_param(mdev, sreq);
 
 		for (j = 0; j < mdev->rnr.bssid_num; j++) {
-			if (j > MT7925_RNR_SCAN_MAX_BSSIDS)
+			if (j >= MT7925_RNR_SCAN_MAX_BSSIDS)
 				break;
 
 			tlv = mt76_connac_mcu_add_tlv(skb, UNI_SCAN_BSSID,
-- 
2.39.5



