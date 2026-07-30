Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E256F44C670;
	Thu, 30 Jul 2026 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427457; cv=none; b=pQZbsrG5zorMTjiBOCAZXAp3yoNEMJIy7BrviAzVWGEpq1IHUZKDHy5AlqZwm/Aj85/GV2rPB9bBgShF8Y0KlJPcVT+skNIpWsaGIBOKc4cofdYdXnkcPL80NdUmaSO4CBTd2QiMC+iExP/BObXdsPDF72v4vwAoa24ZNw6UC3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427457; c=relaxed/simple;
	bh=sfOWsNj91B5ox4k0C8rjMowcUrJwAVeBDn2qEGG+7eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=goJHJ3cudByME8mPjgredmaH5hQocM/zXYFrI7MVGwpYPhWtRze48EvLTCzM+ky3gLeSb22vrJe0LZ/pVlYd1z4SCbRF4wRJbVkPOZcbzb6ciXU0CRHyieb2qhcnLXvLWXtITonsL0b1xHyJFnMRH+VzseAOMFvjSM8khlXtdXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGwZiUuu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGwZiUuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DB41F000E9;
	Thu, 30 Jul 2026 16:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427456;
	bh=RAXXbIrscQ5dyAwHitV3ODA60FycLjuGMgl9vk95UvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGwZiUuuC2dK6SpRy1BRdpu4HUwbeKzYZ8630nrtGjV/6X+dE6qx6arZBCq7jq7mF
	 eJIK7K2uwbEaORG0TFfC2n7C8QnP4Nbf7aBCD2JS6vHeyUH1bXlrnobgfrMKUx04MJ
	 OEeGBqAG9c9dKOL952XcakysLWfviQTG4Py1N5+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/484] wifi: mt76: connac: fix possible NULL-pointer deref in mt76_connac_mcu_uni_bss_he_tlv()
Date: Thu, 30 Jul 2026 16:11:12 +0200
Message-ID: <20260730141427.270153603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 2c1fb2335f5e3afb34f91bc07ecb63517c328090 ]

mt76_connac_get_he_phy_cap routine can theoretically return NULL so
check cap pointer before dereferencing it.

Fixes: d0e274af2f2e4 ("mt76: mt76_connac: create mcu library")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260621-mt76_connac_get_he_phy_cap-fix-v1-1-ed4ccf7a0363@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index a388078cdaa2ca..ef1e68154bb611 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1406,6 +1406,8 @@ mt76_connac_mcu_uni_bss_he_tlv(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	struct bss_info_uni_he *he;
 
 	cap = mt76_connac_get_he_phy_cap(phy, vif);
+	if (!cap)
+		return;
 
 	he = (struct bss_info_uni_he *)tlv;
 	he->he_pe_duration = vif->bss_conf.htc_trig_based_pkt_ext;
-- 
2.53.0



