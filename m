Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025913;
	b=2AXi3s1JOLmSzLjkiOU6PSZYX0lcz+0+ChNgTGEGo1sEHKGZ2zstZLMQoX3jtkPiIxD5
	 3juZzh7ECArxsvFC9IzbitSt/1ZWABXCA7U3LX88BRMAU2eONOe9o+yDmuJuFBkiJdymg
	 pJHDRD/VGOmGhJ/iJhmYYOskBdD96IBYjbjap95IX0NVN1ABvPiTMAguRRE5EdXO7/od9
	 Ua3nW4dbXL2x5+SpqDLF6lfeiXuosmhFnk5oNSrSl9c9QjUXfwIHDmu774EivV1Vz5E2P
	 GqAIxgdMn9QpyxmHNJJcgCR+TDthmDmwvOdHYNEIMr+rOM60mZDxZWs+/mwOy7yNSGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rKRX6qHten2Tfdg3GIxN8p79SHOQIGtm5qwt8Wv2XV4=;
	b=hM+EzizO+TxBvwr1BwCfsXgtEzVHz9QQrj65XEhVVdDmWsYNLdVz9K0TdjkMtge8/jmV
	 IRQMTz11fJjG9Q5MvyLlKBVWXKoYMOpQFHMrbqrEjOGP4Xk+jni55eC9HXxjYzVLDK0rH
	 jyA/fzE/W1Bs5LP6ZzSxI6ti2zCaoCmfDv0S/Pe+yaVeX1X7alZnLgurauQqkrealdcQC
	 dXe+KAXbHPsOF82ixjGAsTd6D6WHxm8hF6EqtBqfSD3anbX+rK+W+nOB0pxIX6dRx0tFN
	 Mtd06tpTX4NFYOrhu8RwNCm2M5lcKFrUMKk4coTLmE983cUCDOjZ3CHgKGv1v2bI23g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OucG+CWB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA67606A320;
	Wed, 18 Nov 2026 18:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OucG+CWB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A0E1F000C4;
	Wed, 18 Nov 2026 18:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025913;
	bh=rKRX6qHten2Tfdg3GIxN8p79SHOQIGtm5qwt8Wv2XV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OucG+CWBv0+W7PiU456st272m6kBwQ7vCxozgGQc6sI47lX6Bu4Bbu4A4yke6WSBR
	 Wg7Hs4ijBYPay0HtfN6wN7Es3rtgtb0sdJxBSGIOpxK3PxshnlZLvklV3TNR257tPT
	 GwHvvXQ4H1XHjUVtCd0T7mf9K7X4twkM1VVY7a6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1196/2151] wifi: mt76: mt7996: validate firmware event lengths before parsing
Date: Wed, 18 Nov 2026 15:48:51 +0100
Message-ID: <20261118150205.781630375@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit c88f880c6430948492a4eee00d90e48fa800febf ]

Two unsolicited event handlers trusted firmware-provided lengths:
mt7996_mcu_rx_all_sta_info_event() looped over res->sta_num without
checking it against skb->len, reading the flex array out of bounds; and
mt7996_mcu_rx_log_message() could compute a negative or oversized length
from tlv->len and feed it to %.*s and the debugfs log path. Bound both
against the actual skb length.

Fixes: adde3eed4a75 ("wifi: mt76: mt7996: Add mcu commands for getting sta tx statistic")
Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 46 +++++++++++++++++--
 1 file changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 92f8a28cd4a51..0d35f238375c6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -446,21 +446,32 @@ mt7996_mcu_rx_log_message(struct mt7996_dev *dev, struct sk_buff *skb)
 {
 #define UNI_EVENT_FW_LOG_FORMAT 0
 	struct mt7996_mcu_rxd *rxd = (struct mt7996_mcu_rxd *)skb->data;
-	const char *data = (char *)&rxd[1] + 4, *type;
-	struct tlv *tlv = (struct tlv *)data;
+	const char *data, *type;
+	struct tlv *tlv;
 	int len;
 
+	if (skb->len < sizeof(*rxd))
+		return;
+
 	if (!(rxd->option & MCU_UNI_CMD_EVENT)) {
-		len = skb->len - sizeof(*rxd);
 		data = (char *)&rxd[1];
+		len = skb->len - sizeof(*rxd);
 		goto out;
 	}
 
+	if (skb->len < sizeof(*rxd) + 4 + sizeof(*tlv))
+		return;
+
+	tlv = (struct tlv *)((char *)&rxd[1] + 4);
 	if (le16_to_cpu(tlv->tag) != UNI_EVENT_FW_LOG_FORMAT)
 		return;
 
-	data += sizeof(*tlv) + 4;
+	if (le16_to_cpu(tlv->len) < sizeof(*tlv) + 4)
+		return;
+
+	data = (char *)tlv + sizeof(*tlv) + 4;
 	len = le16_to_cpu(tlv->len) - sizeof(*tlv) - 4;
+	len = min_t(int, len, skb->len - (int)(data - (char *)skb->data));
 
 out:
 	switch (rxd->s2d_index) {
@@ -573,13 +584,38 @@ static void
 mt7996_mcu_rx_all_sta_info_event(struct mt7996_dev *dev, struct sk_buff *skb)
 {
 	struct mt7996_mcu_all_sta_info_event *res;
+	u32 elem_size;
+	u16 sta_num;
 	u16 i;
 
+	if (skb->len < sizeof(struct mt7996_mcu_rxd))
+		return;
+
 	skb_pull(skb, sizeof(struct mt7996_mcu_rxd));
 
 	res = (struct mt7996_mcu_all_sta_info_event *)skb->data;
+	if (skb->len < sizeof(*res))
+		return;
+
+	sta_num = le16_to_cpu(res->sta_num);
+	switch (le16_to_cpu(res->tag)) {
+	case UNI_ALL_STA_TXRX_RATE:
+		elem_size = sizeof(res->rate[0]);
+		break;
+	case UNI_ALL_STA_TXRX_ADM_STAT:
+		elem_size = sizeof(res->adm_stat[0]);
+		break;
+	case UNI_ALL_STA_TXRX_MSDU_COUNT:
+		elem_size = sizeof(res->msdu_cnt[0]);
+		break;
+	default:
+		return;
+	}
+
+	if (sta_num > (skb->len - sizeof(*res)) / elem_size)
+		sta_num = (skb->len - sizeof(*res)) / elem_size;
 
-	for (i = 0; i < le16_to_cpu(res->sta_num); i++) {
+	for (i = 0; i < sta_num; i++) {
 		u8 ac;
 		u16 wlan_idx;
 		struct mt76_wcid *wcid;
-- 
2.53.0



