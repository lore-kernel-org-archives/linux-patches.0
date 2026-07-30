Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0384439526F;
	Thu, 30 Jul 2026 15:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425836; cv=none; b=L2LQc3z4EvVfj/XMdfum95NJNVXP+ezUYPJAxGIvV7/mYSA7LiN4NxqsItwNcO1J8nh5b/zIakAmTdW9HzJEIjHIYWO3MXQh6sjtBQhgaZjV10STtwoJdQ+kFnDzlh1+8bgjhZemFVuP2Ie//GeazGiFCnwl4gprxwHrzi+HUv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425836; c=relaxed/simple;
	bh=bAanFQRXdayZFvRpscBKWjK1XQkhAvVTB/PKc9gdEWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqtTOXz+jmj2aGZfCNvMWYqwFbGdRBavaF/GhwHo2iy4wGo3AfySs1W1KoepirayVF0IS7J8gdeUfN1WhNPFHY5hfTzaUcZLHTqrEjC6cruQzlYEc9TEe3sCwToCfT8q85bSk53spJLX8xYQYA5oqTp8ftIa7tEwV2M7Rr4QHLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrI1o2fC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrI1o2fC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE191F000E9;
	Thu, 30 Jul 2026 15:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425834;
	bh=2CJynhafWMhYMPBGGfxqvw1jn06jsisb1D83ZTv3L+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RrI1o2fCBBraEcGt22j+DOscrIX1q8G3GRn7x1aOXdvh4QHuxGaSzz2u7X0G9mvya
	 UBMOB5NtNXM0z+/cfT3ipUg8OyY9FiGi/VXdejmfvT7sdy1BIegXgY8WeHuFMSk/66
	 505pgwyrJZm3Z4HHPHr061wY5kbtOxN0+PltBJzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 208/602] wifi: mt76: mt7925: fix possible NULL-pointer deref in mt7925_mcu_bss_he_tlv()
Date: Thu, 30 Jul 2026 16:10:00 +0200
Message-ID: <20260730141440.327479529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 8d1b6738c1ab48c086b17e7994034aca94258931 ]

mt76_connac_get_he_phy_cap routine can theoretically return NULL so
check cap pointer before dereferencing it.

Fixes: c948b5da6bbec ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260621-mt76_connac_get_he_phy_cap-fix-v1-2-ed4ccf7a0363@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 1f113a618515e8..1fc1116d9becca 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2646,6 +2646,8 @@ mt7925_mcu_bss_he_tlv(struct sk_buff *skb, struct ieee80211_bss_conf *link_conf,
 	struct tlv *tlv;
 
 	cap = mt76_connac_get_he_phy_cap(phy->mt76, link_conf->vif);
+	if (!cap)
+		return;
 
 	tlv = mt76_connac_mcu_add_tlv(skb, UNI_BSS_INFO_HE_BASIC, sizeof(*he));
 
-- 
2.53.0



