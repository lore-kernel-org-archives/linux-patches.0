Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218E31519A4;
	Wed,  5 Feb 2025 14:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764976; cv=none; b=rp+Y2gpgRwTcMS43eo0u7ANB1AtZGAEuFBG06TaTkldoXxVt8OwxBnqrF4jIEyexkuCfSDbRNuVz3SdHqZRnJyKz45MYiy6fjG/UVkTF98EwS9B3nd1OXa/T/WulY51T1AFtT9GOeECfnyD94uzKEU4rT1N+72+UN+evLutYfw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764976; c=relaxed/simple;
	bh=iVcDyTNfYqxWnQYUzRy1YK5RQCL2UnAypsyGaA6mggg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCu2SZd5G0RPX0/EHyj435QWPO7i4iy5+CHkwOukoOs9AGxsXJeuqfo/6QbX5OCOmRGvmc6/Uz0I3uLGAXlw6l26oS9bwpKnwXdm8dw6L3mDqqEWzc2NZYm5cyCE8eXknLw6jiI9FseFZV33FyfhGK4168ClVzHEwU9jDDMwIJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V99f8olB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V99f8olB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98794C4CED1;
	Wed,  5 Feb 2025 14:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764976;
	bh=iVcDyTNfYqxWnQYUzRy1YK5RQCL2UnAypsyGaA6mggg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V99f8olBie4D6xInewf55OuI/eosK/LmDxr40QSz1+XHQboeGx5goqsUUyCTiyvdP
	 /V6VUxrkLFAKpy/hy7OkgwqUvRhMMCL75cFJV4CvWl56VH93/6VO0KcMXGK5Lk3gGT
	 acANFfdOAoAeHQ7D1dNxooYd9kEpl8AEHIUvXgMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 178/590] wifi: mt76: mt7925: fix the invalid ip address for arp offload
Date: Wed,  5 Feb 2025 14:38:53 +0100
Message-ID: <20250205134502.091388042@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 113d469e7e23579a64b0fbb2eadf9228763092be ]

The wrong ieee80211_vif will lead to get invalid ip address and
the correct ieee80211_vif can be obtained from ieee80211_bss_conf.

Fixes: 147324292979 ("wifi: mt76: mt7925: add link handling in the BSS_CHANGED_ARP_FILTER handler")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20241107053005.10558-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index b43617dbd5fde..123a585098e3b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -123,10 +123,8 @@ EXPORT_SYMBOL_GPL(mt7925_mcu_regval);
 int mt7925_mcu_update_arp_filter(struct mt76_dev *dev,
 				 struct ieee80211_bss_conf *link_conf)
 {
-	struct ieee80211_vif *mvif = container_of((void *)link_conf->vif,
-						  struct ieee80211_vif,
-						  drv_priv);
 	struct mt792x_bss_conf *mconf = mt792x_link_conf_to_mconf(link_conf);
+	struct ieee80211_vif *mvif = link_conf->vif;
 	struct sk_buff *skb;
 	int i, len = min_t(int, mvif->cfg.arp_addr_cnt,
 			   IEEE80211_BSS_ARP_ADDR_LIST_LEN);
-- 
2.39.5



