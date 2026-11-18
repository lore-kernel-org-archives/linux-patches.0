Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018927;
	b=StsWyyqFZ9y+/qmIvWJCUWiC6i+1x3SYR34xQ8C9EaKc5TUD8vM/mm7RqNxUul6uvw4x
	 faJS+UZvTYYzvMSyLwXwwqO/jqB2XlkGzgBNy2U8LsJkCeZaxtCKFEoAFCjwRau+T/K2u
	 BBIn0IQugrJRFpkaSFtKnbMqdppq0vnG4AwKbMTFfDjEoeFFlbMbkD76fnO7OqWYLIF57
	 5UA5RzLZhD2EgOVMOsWVfuu6JXNe1WEaHMNteQ9Y6/jQOPcOsnU0qOspgy8Txb7iFKXGM
	 4PYJn+xQhVK2sKKlm5LI1GGJMVxxyM0/4lKuoPu7RpF6Y2BTCvPcLVlWau92hlh5Q0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WOMtKfTUZ9oSHOOvlXkYww/VdwGeBjA6E3a33NUYTeU=;
	b=wYmZ0p1pkWFKRYLrr1Bg2+Yz7GQRHHibxYDPlbeGeKSf5IUCweJejbIAsks39GGKUMCh
	 0Z51kS8WJR7QTiuvAmgG35btNc3GN8IEmchlhMQdTZMF5hJaZwe42X1nAkIrHPSUS2pEi
	 bCMb+OjtkI1NTpVnNCjVTOSVDoyOeRO+ps5jnYt3apxPosreyzY/dzfR6TbjZH9eDPyUa
	 2tj+9PJWmeYLwEImyKV//BXL06GGVkX13G1ogHdUga/GSxsfmFT5cFQcMaXiOYuSL4cwX
	 jwxXHn62d++/sftQOzPb0dVKTyoixIS9KoOSlHhf6RNrVNGkS2wlyknEmeCRgBAp9PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lphkw3OJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC5A606A31C;
	Wed, 18 Nov 2026 16:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lphkw3OJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4E01F000C4;
	Wed, 18 Nov 2026 16:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018927;
	bh=WOMtKfTUZ9oSHOOvlXkYww/VdwGeBjA6E3a33NUYTeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lphkw3OJeoShZhm7041VkbXQHYpNm/lvrJLnfcE4Z0RjHmPM5xCqo/y5nc3PjxZMK
	 HdSpSzei2HNWubXu3WGQ9TlvTaEtG5sQ0BsXAzABdT77uBcTjpgPTpOWpkUFWERFQL
	 a1JdCK0y2E4YzfzoRAgzROSisoY7zGmpWzAFqGy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1414/2651] wifi: mt76: mt7996: validate firmware event lengths before parsing
Date: Wed, 18 Nov 2026 15:44:14 +0100
Message-ID: <20261118150338.909331409@linuxfoundation.org>
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
index cd7587ce5b8a6..6acb8897feb83 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -572,21 +572,32 @@ mt7996_mcu_rx_log_message(struct mt7996_dev *dev, struct sk_buff *skb)
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
@@ -648,13 +659,38 @@ static void
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



