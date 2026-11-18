Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019063;
	b=yiajS+u+f5xs5vpx9pTAoI7eW9VMCKocTHH4MObqwGLZpMV/EVurT3in6ePLBQGApu4e
	 dAQtAK0q3jr94i9gpPjmw3v6hBj1mgJUnpTDLcPIxCMCRo+KJRnQJ1uK1OKV9S4T6iM8I
	 4A7Hj86C45cWxFyx0GwzNQPM5kTtf/4eUE3dpCueXFzHkCgbgF7VQEVOx++bY9ZXP9AjJ
	 G/E8Ph66rPgaEmuAqXMOMVA1d5AUVvdK2iLuXmsmynFSjDBx6SyOFzY4uHVlNWcGzUd9m
	 0Hbfwuv1E3CrlTbClfMFDhvaV2n5TlTQL8O6AkYsTbgxCOQamjcNrTll5lLgtwGu53Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/W7G/Xlm7tnkGwBngZBg99PzPvkVaTnznBd/HNzP2nI=;
	b=w36CB1ozfLtgBTG+EONFfvk7Kjaq/lKE/amAS4e8odGv2igaPDrMi2VWgsgfvjSJSOG6
	 U8IzVEiLAUacGbbcw2VfwUSnZJvqARxmKxMrkH6sPFjTnaqlmV155gS7EjvkU+9rvrY1R
	 aJ3FJYlzzyJ29wzuOuh0kxwL2t+U9BYyefixbVuh9dXMnqCWh60bkcqf+3csrtYgkTHEB
	 XaV0kaQgGBH2U2Y6e005+aNDYAATn4Yj0AQKJg0WIMCGb2h4nLM0Ip3Rs+oi00s3a21vt
	 HAvZeDM66c3U/SzUZWyipvCKMrU1Bc5/Nu0DsJO/EIBzkbWf2Ti1eVtfjwXuwk2cOzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=00zwTLd1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CE660A2600;
	Wed, 18 Nov 2026 16:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=00zwTLd1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F9F1F000CB;
	Wed, 18 Nov 2026 16:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019063;
	bh=/W7G/Xlm7tnkGwBngZBg99PzPvkVaTnznBd/HNzP2nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=00zwTLd1S3Q8L3jNASyeJHAA6nFBEZwr19D9jRwshms4B3UreDjDdkBi3bPMegTBT
	 xuN9v1fibcEtEYdo4oIcioRkRovddQVUFLJkTavYyrXidIq6E6KSjXDK2RhGLnfUGf
	 FjzoVXS7n1/g47+ebsoLT3Ap6WsAMTVtpGNl5ay4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1462/2651] wifi: mt76: mt7996: guard station-only MLO TX handling
Date: Wed, 18 Nov 2026 15:45:02 +0100
Message-ID: <20261118150340.667340211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit fb03c4204498f300ffa3324f2e90df5742a2984d ]

Pending frames can be retried after their station is no longer
available. Require a station for both MLO-specific branches and retain
the existing non-station transmission path for valid vif traffic.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 7ef0c7ad735b ("wifi: mt76: mt7996: Implement MLD address translation for EAPOL")
Fixes: 85cd5534a3f2 ("wifi: mt76: mt7996: use correct link_id when filling TXD and TXP")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Link: https://patch.msgid.link/20260911060922.94383-1-bolin.liu@seu.edu.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 42c0c53f10238..eb39526548e8a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1057,7 +1057,7 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	if (!wcid)
 		wcid = &dev->mt76.global_wcid;
 
-	if ((is_8023 || ieee80211_is_data_qos(hdr->frame_control)) && sta->mlo &&
+	if (sta && (is_8023 || ieee80211_is_data_qos(hdr->frame_control)) && sta->mlo &&
 	    likely(tx_info->skb->protocol != cpu_to_be16(ETH_P_PAE))) {
 		u8 tid = tx_info->skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 
@@ -1097,7 +1097,7 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	 * compatible with 802.11 EAPOL frame, we do the translation by
 	 * software
 	 */
-	if (tx_info->skb->protocol == cpu_to_be16(ETH_P_PAE) && sta->mlo) {
+	if (sta && tx_info->skb->protocol == cpu_to_be16(ETH_P_PAE) && sta->mlo) {
 		struct ieee80211_hdr *hdr = (void *)tx_info->skb->data;
 		struct ieee80211_bss_conf *link_conf;
 		struct ieee80211_link_sta *link_sta;
-- 
2.53.0



