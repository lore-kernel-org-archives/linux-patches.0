Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAF2126C02;
	Sun,  7 Sep 2025 20:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277925; cv=none; b=k0lgPhYb8Wx+HEeCPbIhbzvz7KYAVpaw3NUF6PtJjBffCxI83lmEWvpXif8Od1DIsEhBW5tDd7WNbYSKIGDJIoGSwoZmejD4vIhIKwQCPozdO9umu1PBllSmq0g0MmmoXt3RE/9OuAgNLZ05KytEwnM5SWhmFSJflwdKHxrWOmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277925; c=relaxed/simple;
	bh=oU7hjnPAoJL7VUGMVBaMcutCpnxivep30iz5n+aL1LA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9un8u1U3bmjrBmNevjGBudeHOmq7ZQsEAXolB+FEi+KRGRu+VsLM0yqNT7x5QnFoGnGHlt+sbMxd69geZesAtuZJMTkuH5M2l7T6UPErEmNGP1exXyg2er8s8Y9FXA1cZOIa4wWFyLUCGvwxlv9rjsM2UAlRhlC3UQkfDO9L3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xYC4GJKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xYC4GJKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E45C4CEF0;
	Sun,  7 Sep 2025 20:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277924;
	bh=oU7hjnPAoJL7VUGMVBaMcutCpnxivep30iz5n+aL1LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xYC4GJKdutgkF9EVEt+0EEAufwicgRydeOl1MAE4ux5JVT7ca/0hgcyN2Cc94c260
	 WrwdKSkdwSdoy3tJknnjGW8Ap92zyC2ZHBPJrIImyRx0MJ2Mmlx+a+dBGpIMRqweLJ
	 lme5aaew7LDm8f3uMwO8SQViMPr928r6EEeMF7Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Inbar <inbartdev@gmail.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.16 122/183] wifi: mt76: mt7925: skip EHT MLD TLV on non-MLD and pass conn_state for sta_cmd
Date: Sun,  7 Sep 2025 21:59:09 +0200
Message-ID: <20250907195618.689914264@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit dd6e89cad9951acef3723f3f21b2e892a23b371b upstream.

Return early in mt7925_mcu_sta_eht_mld_tlv() for non-MLD vifs to avoid bogus
MLD TLVs, and pass the proper connection state to sta_basic TLV.

Cc: stable@vger.kernel.org
Fixes: cb1353ef3473 ("wifi: mt76: mt7925: integrate *mlo_sta_cmd and *sta_cmd")
Reported-by: Tal Inbar <inbartdev@gmail.com>
Tested-by: Tal Inbar <inbartdev@gmail.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250818030201.997940-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1834,13 +1834,13 @@ mt7925_mcu_sta_eht_mld_tlv(struct sk_buf
 	struct tlv *tlv;
 	u16 eml_cap;
 
+	if (!ieee80211_vif_is_mld(vif))
+		return;
+
 	tlv = mt76_connac_mcu_add_tlv(skb, STA_REC_EHT_MLD, sizeof(*eht_mld));
 	eht_mld = (struct sta_rec_eht_mld *)tlv;
 	eht_mld->mld_type = 0xff;
 
-	if (!ieee80211_vif_is_mld(vif))
-		return;
-
 	ext_capa = cfg80211_get_iftype_ext_capa(wiphy,
 						ieee80211_vif_type_p2p(vif));
 	if (!ext_capa)
@@ -1912,6 +1912,7 @@ mt7925_mcu_sta_cmd(struct mt76_phy *phy,
 	struct mt76_dev *dev = phy->dev;
 	struct mt792x_bss_conf *mconf;
 	struct sk_buff *skb;
+	int conn_state;
 
 	mconf = mt792x_vif_to_link(mvif, info->wcid->link_id);
 
@@ -1920,10 +1921,13 @@ mt7925_mcu_sta_cmd(struct mt76_phy *phy,
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
+	conn_state = info->enable ? CONN_STATE_PORT_SECURE :
+				    CONN_STATE_DISCONNECT;
+
 	if (info->enable && info->link_sta) {
 		mt76_connac_mcu_sta_basic_tlv(dev, skb, info->link_conf,
 					      info->link_sta,
-					      info->enable, info->newly);
+					      conn_state, info->newly);
 		mt7925_mcu_sta_phy_tlv(skb, info->vif, info->link_sta);
 		mt7925_mcu_sta_ht_tlv(skb, info->link_sta);
 		mt7925_mcu_sta_vht_tlv(skb, info->link_sta);


