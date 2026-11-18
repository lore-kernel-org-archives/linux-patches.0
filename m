Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041006;
	b=lbV7T4k3cEGwPqtyxPKlxNPyczsvKQATyZJHn0w81cGxlp7VM/gENNDtih8G7ZcjzOR3
	 VN8znfwqFaAEs5MVPqg59+sMfkd2I6Q9NjANWMa7dcAVQPxKpHsvhG7+1uLC/At2qHSo7
	 arWBG/SOoJqp3zpqrZlmtQ6Zngqa8e4O5Rfv1Bt53F36sVbNPn+cElb1zDsz6799MhjS5
	 CCUjSUWjuHkqz3ap2gdobU2dHbQt9u4SoHcAsM1QHa+rRYrG2h0bMK/w79xzxAuZhYGio
	 bm3wLSomCe6niKSi03mkVZ0LhV7JX5glKZPOTNidIPz4GW3CE4OsD5tj0NI9YIUOJeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DyIxE3ueySWFEAroKplSC74z3chQouiHPutIfd4ANo8=;
	b=iKw6tDD4jdpPMTp5/7hJg+gqdghVegZiIdPBHqe/0ACHOGQanwILKQhMQevAt1W7m7Lp
	 D6h/94hh/sqXbQXAc8PHVNQUQRb53nS39T5mVbB0mU97WKl33VtUdDmUl4t1nOBRgsqLY
	 Fr6wYHHWC3qMVt2+IYJ2bdpXEaAlyog6zf1RDNuENBbGfxEOD23p241Pc7C+e6tqmPse3
	 17sOmiRworUCKlwS+z90709YbYz8zmN5MeAPuW/v+JfEfkyIw8cJRIHHqoEVsfHWFNvh9
	 1vgZ7JvZfEuigxT+uau5He2Sq0ow99nY1VaBJUWAe9W6S2GzZkFy2gJqbug7BoFSYRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1K+8a+ER;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D46606A31C;
	Wed, 18 Nov 2026 22:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1K+8a+ER
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AE81F000C4;
	Wed, 18 Nov 2026 22:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041006;
	bh=DyIxE3ueySWFEAroKplSC74z3chQouiHPutIfd4ANo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1K+8a+ERzWRtMB43Um5nTmoo1YeUw1pyTZwAzJrjyumubKoaHEHik8NCcsdaBZ6eH
	 t3qMWhGQeEsY4BsJ0R2EhdZK0CG0pq/qxAGgmCWk60dao7nC1EEr3UKo9pJDWaKP3V
	 uSxtMxH9KfgeSR5ks3RPnlk8FUivBvGr3ls0FCSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2658/3318] wifi: mt76: mt7996: validate firmware event lengths before parsing
Date: Wed, 18 Nov 2026 15:54:40 +0100
Message-ID: <20261118150440.773871164@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4806a7916c1ef..276264c950a09 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -364,21 +364,32 @@ mt7996_mcu_rx_log_message(struct mt7996_dev *dev, struct sk_buff *skb)
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
@@ -491,13 +502,38 @@ static void
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



