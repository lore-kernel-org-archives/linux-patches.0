Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0F31A2632;
	Tue, 17 Jun 2025 16:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177383; cv=none; b=Q3uPzocjxXSHU4Gu9gAnE7M5iCgTnSnjslgNFe8XM89vU7MOElUoAYSNaBwiNaUBRiQFk/WcNkGgQnHIgibqzsC3Lu9LMAdUAO0s9KLpRjz6b4h8mbXcMV7gXpUXKj47PyycJu7sk5Qak3uofdgo0vBqo6XbrkDm53Ha66S2/M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177383; c=relaxed/simple;
	bh=aWzZXZwNhnOyL1wmgrQ4kXz7n2hwSQAPZ6S1OOdbJY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htSSLUULe2PzAnCJaAzCnpZKaX5VjCMgB6c5L9AjJn1O0Qhh///0efj1CCS3cVHKMyPy+LHBwPoR4iTHbFN6sCKpE1qfE/sW6snaMg7CWcnl+3QGHmQnWA7kb2s24/DNSjOD1aqoO9y/iIgpU3zDxOHB39qZpkJ8+hm4PZuHiUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNOpp/gV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNOpp/gV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E83C4CEE3;
	Tue, 17 Jun 2025 16:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177382;
	bh=aWzZXZwNhnOyL1wmgrQ4kXz7n2hwSQAPZ6S1OOdbJY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNOpp/gV7Ks93HXXLLMJG47U4TVgTEtkjt9930ji8slzNI5MRtfnuYgjGTavy4Nmc
	 Doai7lI418Q+FHoWqQamZ8ZPu6jqqc8B9qOPaQoM/0ARtIFoyuOgENES0GX4aA4V2p
	 qiNbyEd8EfX578QYFVTIumQ0gSUtJtkD93ypc72k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 298/780] wifi: mt76: mt7925: prevent multiple scan commands
Date: Tue, 17 Jun 2025 17:20:06 +0200
Message-ID: <20250617152503.602208585@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 122f270aca2c86d7de264ab67161c845e0691d73 ]

Add a check to ensure only one scan command is active at a time
by testing the MT76_HW_SCANNING state.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250414013954.1151774-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 14b1f603fb622..8eaba8c07a62a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2790,6 +2790,9 @@ int mt7925_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	struct tlv *tlv;
 	int max_len;
 
+	if (test_bit(MT76_HW_SCANNING, &phy->state))
+		return -EBUSY;
+
 	max_len = sizeof(*hdr) + sizeof(*req) + sizeof(*ssid) +
 				sizeof(*bssid) + sizeof(*chan_info) +
 				sizeof(*misc) + sizeof(*ie);
-- 
2.39.5



