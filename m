Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB858634E;
	Wed,  5 Feb 2025 14:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765551; cv=none; b=Ksx9SegKjHdpSV2O/+4skK4B8C+wzQQsf2CCKAZvOnOiIozwAJeyLdZM1gpqOZJaklMhOSfSdCDuw0fK37GNvqpUvo3zA5L4RBZXPDHiHPaFzWZbWClsFwodeM0BQnEf5pEc0mY4MsgvRIvEKEAcSEtt1ps5AaxNLdMrhiavsx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765551; c=relaxed/simple;
	bh=ItoF3bCKXiymyAh+fOZoG+eWk5IFl9ua0919NLFYvp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1o4zOQZT1ELw4jrPqsyWaBR4UhPNYi2Fpv+/dArz+Mh2PNUKs/SX2ZdkGz+ebIKBe0zvAXxkrp11PbCz8Omp2iAgkHQKPFTwIzUi7jtucketIPRyNF2CsOuEhSmR7g0Migfdww2wsG2ic6TGLdAjESYY6ht8L50+Y4geP/gJF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+UmwJHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+UmwJHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE2EC4CED1;
	Wed,  5 Feb 2025 14:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765551;
	bh=ItoF3bCKXiymyAh+fOZoG+eWk5IFl9ua0919NLFYvp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+UmwJHQEeleMFWz6q2V1LtwKLwWcEiQLVuCBnwZQyL/xK+bcyRfrGfII1TkRZozg
	 e0F+YALRiZG4ceCmwuBioJsWzBjE/pFQ++Bd/gB2QBI4YxtoL4jEFfeVwjDAJHWM5E
	 FQ2N65y3QKhDAXbrPfOC+uQClqHaOrUc4zb9EWj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 188/623] wifi: mt76: mt7925: Fix incorrect MLD address in bss_mld_tlv for MLO support
Date: Wed,  5 Feb 2025 14:38:50 +0100
Message-ID: <20250205134503.431323610@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 4d5427443595439c6cf5edfd9fb7224589f65b27 ]

For this TLV, the address should be set to the MLD address rather than
the link address.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-2-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 123a585098e3b..7105705113baa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2459,6 +2459,7 @@ static void
 mt7925_mcu_bss_mld_tlv(struct sk_buff *skb,
 		       struct ieee80211_bss_conf *link_conf)
 {
+	struct ieee80211_vif *vif = link_conf->vif;
 	struct mt792x_bss_conf *mconf = mt792x_link_conf_to_mconf(link_conf);
 	struct mt792x_vif *mvif = (struct mt792x_vif *)link_conf->vif->drv_priv;
 	struct bss_mld_tlv *mld;
@@ -2479,7 +2480,7 @@ mt7925_mcu_bss_mld_tlv(struct sk_buff *skb,
 	mld->eml_enable = !!(link_conf->vif->cfg.eml_cap &
 			     IEEE80211_EML_CAP_EMLSR_SUPP);
 
-	memcpy(mld->mac_addr, link_conf->addr, ETH_ALEN);
+	memcpy(mld->mac_addr, vif->addr, ETH_ALEN);
 }
 
 static void
-- 
2.39.5



