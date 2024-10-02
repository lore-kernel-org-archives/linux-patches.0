Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8931D12E0;
	Wed,  2 Oct 2024 14:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879262; cv=none; b=eEX+CSZ9vIbezadDqbHUYekiDUiElWZ36fCikcXBVNn3Te1NI5sKOsrDnHN00AdMmMT9qzDrYO/yI47oBysdHH0Wf3x98FJJC/u6WmJjOANAu4jQLZ9OqZUzb9ru6WeI67J+8ECkEI5dxO5CZrgtkAJks2wpKLhVMpHIFSYSq0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879262; c=relaxed/simple;
	bh=KN0XLnyCiMpUeMvFHmNsP25z/9diYinDVuQSYhuzQQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYEZDv4ypx9R7ff6f4ILx7dmqq+yshe8gNGDsB+Be+HsdjUKMKoPXFGjJGKIr3UyIKXb7VsnrJPduUpmFEvsgOyOI8hrFJShVmV11W1PRit27K6YOlLiJo0ydhGCSWAXiIp15J8KYjVVP/blWrcwU2e6HtEecMzxC2RXt4tv/3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTCLhuRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTCLhuRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DD4C4CEC2;
	Wed,  2 Oct 2024 14:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879261;
	bh=KN0XLnyCiMpUeMvFHmNsP25z/9diYinDVuQSYhuzQQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTCLhuRLq0wv3ksQu9eo0J7ZktYNvzJQhC9FKfQQuT92xZiTDi3vhHGCu68LMXiGi
	 ul77fGk8WfAmg96gXjU8fUZ5KW9Rgy+kG543NgUtk8sZlxhXdDsR96YTdfRHuoA4eP
	 aOrrGrtQCufSGCdOD4AcwTfCDeIXcuLzOhHrLB60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/538] wifi: mt76: mt7996: ensure 4-byte alignment for beacon commands
Date: Wed,  2 Oct 2024 14:54:56 +0200
Message-ID: <20241002125754.453301344@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Benjamin Lin <benjamin-jw.lin@mediatek.com>

[ Upstream commit 5d197d37809b220616a0fb00856b9eeeafe1f69e ]

If TLV includes beacon content, its length might not be 4-byte aligned.
Make sure the length is aligned before sending beacon commands to FW.

Signed-off-by: Benjamin Lin <benjamin-jw.lin@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 9e461f4a2329 ("wifi: mt76: mt7996: fix uninitialized TLV data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 14 +++++---------
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h |  4 ++--
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 325bbe3415c25..6d9a92cafe484 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -520,13 +520,10 @@ void mt7996_mcu_rx_event(struct mt7996_dev *dev, struct sk_buff *skb)
 static struct tlv *
 mt7996_mcu_add_uni_tlv(struct sk_buff *skb, u16 tag, u16 len)
 {
-	struct tlv *ptlv, tlv = {
-		.tag = cpu_to_le16(tag),
-		.len = cpu_to_le16(len),
-	};
+	struct tlv *ptlv = skb_put(skb, len);
 
-	ptlv = skb_put(skb, len);
-	memcpy(ptlv, &tlv, sizeof(tlv));
+	ptlv->tag = cpu_to_le16(tag);
+	ptlv->len = cpu_to_le16(len);
 
 	return ptlv;
 }
@@ -2072,7 +2069,7 @@ int mt7996_mcu_add_beacon(struct ieee80211_hw *hw,
 	info = IEEE80211_SKB_CB(skb);
 	info->hw_queue |= FIELD_PREP(MT_TX_HW_QUEUE_PHY, phy->mt76->band_idx);
 
-	len = sizeof(*bcn) + MT_TXD_SIZE + skb->len;
+	len = ALIGN(sizeof(*bcn) + MT_TXD_SIZE + skb->len, 4);
 	tlv = mt7996_mcu_add_uni_tlv(rskb, UNI_BSS_INFO_BCN_CONTENT, len);
 	bcn = (struct bss_bcn_content_tlv *)tlv;
 	bcn->enable = en;
@@ -2141,8 +2138,7 @@ int mt7996_mcu_beacon_inband_discov(struct mt7996_dev *dev,
 	info->band = band;
 	info->hw_queue |= FIELD_PREP(MT_TX_HW_QUEUE_PHY, phy->mt76->band_idx);
 
-	len = sizeof(*discov) + MT_TXD_SIZE + skb->len;
-
+	len = ALIGN(sizeof(*discov) + MT_TXD_SIZE + skb->len, 4);
 	tlv = mt7996_mcu_add_uni_tlv(rskb, UNI_BSS_INFO_OFFLOAD, len);
 
 	discov = (struct bss_inband_discovery_tlv *)tlv;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index dc8d0a30c707c..58504b80eae8b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -587,10 +587,10 @@ enum {
 					 sizeof(struct sta_rec_hdr_trans) +	\
 					 sizeof(struct tlv))
 
-#define MT7996_MAX_BEACON_SIZE		1342
+#define MT7996_MAX_BEACON_SIZE		1338
 #define MT7996_BEACON_UPDATE_SIZE	(sizeof(struct bss_req_hdr) +		\
 					 sizeof(struct bss_bcn_content_tlv) +	\
-					 MT_TXD_SIZE +				\
+					 4 + MT_TXD_SIZE +			\
 					 sizeof(struct bss_bcn_cntdwn_tlv) +	\
 					 sizeof(struct bss_bcn_mbss_tlv))
 #define MT7996_MAX_BSS_OFFLOAD_SIZE	(MT7996_MAX_BEACON_SIZE +		\
-- 
2.43.0



