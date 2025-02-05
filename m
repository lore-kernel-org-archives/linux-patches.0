Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F66E155382;
	Wed,  5 Feb 2025 14:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765017; cv=none; b=hHKdyUi82jjyPwMn1HXWOP6rViY7blLUGufSJjrA3KAe/AWxe3ROyD57ppVuaRxSrrADDuEYP9r+O1rxXIfO1ZcvvsEBIbi4xtCqrBuiMUsZz4lUCOFyjbE6RRkvwxxM3+jnKVsWsCtPjFRTCPMmgkYFoFsIRyiiIV1MmPc/m4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765017; c=relaxed/simple;
	bh=GEdC4XlvH0JHY8XvUo0hG7KXKYwVCzYdttXZ2dohJwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abLqylSxXfG7PPmE1i3vGDeZtlLpPZ2ObRkh5p/LaS3K8IZS2A4qlU5i0bdqMhy6UetbQ5nMk3+aBD6zzqrciw4OKoyzmxQPEYJGmZDXNnojET6wqWi0o9+/VPHwvAOE1tZ+EyliCryuRXHdS3O+iA2MEOBNESt55Ht7pwPRfpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOVQtqeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOVQtqeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0F1C4CEE2;
	Wed,  5 Feb 2025 14:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765017;
	bh=GEdC4XlvH0JHY8XvUo0hG7KXKYwVCzYdttXZ2dohJwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOVQtqeGWGBQnorZAdE1ywA7t68BvUPgnPPNMr3qQkNrFIlymxuw0CuceBFBsaCp5
	 WsPLG5UWuoc18vd2+/bM+O3gJsRA+kVUkMjQ2idR2B5rtqMa3QhLbdyu8TDkp9y7+C
	 +5An+J00fJHEHOGCv5TNfpB1s3cKVoqscUBZrch8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/590] wifi: mt76: mt7925: Fix incorrect MLD address in bss_mld_tlv for MLO support
Date: Wed,  5 Feb 2025 14:38:57 +0100
Message-ID: <20250205134502.242971255@linuxfoundation.org>
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



