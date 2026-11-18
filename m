Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025843;
	b=ttvMS9BaDWHeJqAvLa9TW/kvRKg6e5DQwWBp9OKKnftqIazLMMrR65Dzl9ZM2fnxudl0
	 7RkeVDGT9sjN+j8GdZlA/5a2kfzRyfi2ufmLqboIVEuGnuTKlM9focr1Op3swh+b8vcUI
	 Gzd5sYMsaQotw3MM/hTh8xixOOipIXqDsXSt3t2rqUi5DOctbxjXovhgDL18MPJbI50d2
	 Jy5vT1+Xb0SLDV2C5OleuVBvEsJ5yNymUArdv1Ra4yrm0O3vZh5XKXNgcLGAozHxr1IwT
	 OLKw5mR9PEfAHXva5wAL0hcX2ZMTQVRM8d0qiI5oXcfTVyj3vqfXxpxYI0LABV/cqSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2o/zdtQ3V6yQ10bMK+K/j8Dw+MJg8/ZRMapxplBFDCo=;
	b=xC/1eDTZxRRnGIZPRjXrFDo7SuUZ93q8XcA8JyCssS1G9bzffMmTa0HndifyuL9ZFW5j
	 b1j6spZDcyB+0YZ7Tzv4Di1g+pVZUT6zdiV+HpL424oaaA+flZNPK2wCwHH0wc26Sqi+7
	 uVjHpCqOJAKd2A+Z7k4kNDLNZ1NY6s9mJefqnzntzOIreS3Burfa7L35w6oIyyrCn1W5W
	 5AEyQZoyqrzOjk3R6T7rLyLBaO7zeImrPYM/BAkDG3Z6cbHaWsZCVSxMsxFFamZwFHCP4
	 X5Yjujvbj19Z+QBKjlg281UQp8kLpP81t2T+8fNDMx6c1/uF6iup7bAWAO1WQnVnVdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QAq0WnGj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8588E606A32C;
	Wed, 18 Nov 2026 18:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QAq0WnGj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11E11F000CB;
	Wed, 18 Nov 2026 18:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025843;
	bh=2o/zdtQ3V6yQ10bMK+K/j8Dw+MJg8/ZRMapxplBFDCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QAq0WnGjFwlpQ6LGrquj0I/ZhI40R4RrTX5qjjKKywYYrL5aPhO7xEl5XDoq9CbPM
	 KvfAKNxX5er8yfvHw4Hi1UOPhJXC/wfaE5NWGu7ILmbs7LgyeG4hPA/HtWJPS5HXCk
	 xGE+2Zu6QUFgsMHHs38gip0ePEmzMWPuzfHlapws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1223/2151] wifi: mt76: mt7996: guard station-only MLO TX handling
Date: Wed, 18 Nov 2026 15:49:18 +0100
Message-ID: <20261118150206.748497626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c49e3eeb0856e..af0fa82c6be30 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1092,7 +1092,7 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	if (!wcid)
 		wcid = &dev->mt76.global_wcid;
 
-	if ((is_8023 || ieee80211_is_data_qos(hdr->frame_control)) && sta->mlo &&
+	if (sta && (is_8023 || ieee80211_is_data_qos(hdr->frame_control)) && sta->mlo &&
 	    likely(tx_info->skb->protocol != cpu_to_be16(ETH_P_PAE))) {
 		u8 tid = tx_info->skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 
@@ -1132,7 +1132,7 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
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



