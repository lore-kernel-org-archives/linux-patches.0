Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874864D108;
	Sat,  3 Feb 2024 04:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933794; cv=none; b=pSbT0VrQk6HbkTqZOr4wID6IvmCXKgiRwiNzXpyfsoQceqmMtdvyrml9SoNINjKHEav9kKrcQx96u/w/+eJ54c6Q72T6rec1s6pIlUNwSXBv4XD3l1o0GHUxFkAdxkyrN3D08ew8cTHKxko44tq/kbi34gAcUOJrvexszYBaOE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933794; c=relaxed/simple;
	bh=jtYfOI9JyZ5IxKDX+ZxsmN1OFiJ6k+Q5JfWTlAgiKro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mthyWSZjra68hjDiWcS3Mh9POw6wI7Sdj5rDP0P7JfjYfd9uL8IDKYypcEwRWRifB96Q/+LK0ZJ31MrJNoNngxhL7hwgmwY3fY55fDa+kzqTUrrGEfw8ZEZj3XWliozZq251mYr632az7SJtuJ639jHQ56ZqDUPl7ZWJICsAKI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIiPBIEL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIiPBIEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5127AC433F1;
	Sat,  3 Feb 2024 04:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933794;
	bh=jtYfOI9JyZ5IxKDX+ZxsmN1OFiJ6k+Q5JfWTlAgiKro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIiPBIELySmMOmQK8RN4K17fpX5a/Hcn6bj/Rms2W+SoJpWt/R8I4pTwbuKR04Dz/
	 8LB1wTRshaTF6OUNBW2qo65dgVd7JS3ANlxz8vac2qYLci5zOKfsfN9cY38NhtunNo
	 7pKIRwLRsSi5vFVye9umpDizWl/VKoElinEZcSvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MeiChia Chiu <meichia.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 104/353] wifi: mt76: connac: fix EHT phy mode check
Date: Fri,  2 Feb 2024 20:03:42 -0800
Message-ID: <20240203035407.066131109@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: MeiChia Chiu <meichia.chiu@mediatek.com>

[ Upstream commit 2c2f50bf6407e1fd43a1a257916aeaa5ffdacd6c ]

Add a BSS eht_support check before returning EHT phy mode. Without this
patch, there might be an inconsistency where the softmac layer thinks
the BSS is in HE mode, while the FW thinks it is in EHT mode.

Signed-off-by: MeiChia Chiu <meichia.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index ae6bf3c968df..b475555097ff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1359,7 +1359,7 @@ u8 mt76_connac_get_phy_mode_ext(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	sband = phy->hw->wiphy->bands[band];
 	eht_cap = ieee80211_get_eht_iftype_cap(sband, vif->type);
 
-	if (!eht_cap || !eht_cap->has_eht)
+	if (!eht_cap || !eht_cap->has_eht || !vif->bss_conf.eht_support)
 		return mode;
 
 	switch (band) {
-- 
2.43.0



