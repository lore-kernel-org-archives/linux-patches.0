Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D23E43C7A2;
	Thu, 30 Jul 2026 14:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422001; cv=none; b=PKJIQoZEnKqo6PjfwbTB75ChWicXa8lpJzL4sOTX41uvVUOfzwqDHwGlyOhWMh5ZchhgtuFTFLeCwlahy4KC1TXOa0pE9yCfs7ByxtIrztMVcjUbxIqSgvfwVNxSw7Exiq0rb3yz0sAHgwgYCjz2UoCmW3WDcSoCFRiET0BWMig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422001; c=relaxed/simple;
	bh=CdVxe+PBBAz3CjtRVfUluh81wqJ7X+l58HvYhzVkC6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIo2kJhrwgaP0kb4gMFktO8Pxoezy8//H8SDKoXy+TzAkUvnafWqbL6nL5FWSW5vPJYfXWBoLMJ7IaBXMup998/wuJncX3d2C0bD13CCUV7jY8Tugvy4sRxS1C+helcplXwLah5Z3vVlrUSj3fqpav25qjzO37VslmBqyk2Cs5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJHEdAqe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJHEdAqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587C11F000E9;
	Thu, 30 Jul 2026 14:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421999;
	bh=dTj9td7xwDBWALUwzTGE19uLgfNc30TXWwBr+mMMTB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJHEdAqe9TEfm79tgeI8gxdhig2/hqQq+nWtLq6ATmXEpN7AcYMdF0dyASRriXdjF
	 CZCF8Vlp95WAZlHEoMnpqraVS62UzUTxeaNVYUT1bSNTXoUJLKP6fQf8issTPQ4PoW
	 thIEzUQPPBGEAk8OaHnLOOC4J08XzGWT/TJM3NzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 291/744] wifi: mt76: connac: fix possible NULL-pointer deref in mt76_connac_mcu_uni_bss_he_tlv()
Date: Thu, 30 Jul 2026 16:09:24 +0200
Message-ID: <20260730141450.475913130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 2c1fb2335f5e3afb34f91bc07ecb63517c328090 ]

mt76_connac_get_he_phy_cap routine can theoretically return NULL so
check cap pointer before dereferencing it.

Fixes: d0e274af2f2e4 ("mt76: mt76_connac: create mcu library")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260621-mt76_connac_get_he_phy_cap-fix-v1-1-ed4ccf7a0363@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 89bd52ea8bf704..ca290ccb6fd692 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1446,6 +1446,8 @@ mt76_connac_mcu_uni_bss_he_tlv(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	struct bss_info_uni_he *he;
 
 	cap = mt76_connac_get_he_phy_cap(phy, vif);
+	if (!cap)
+		return;
 
 	he = (struct bss_info_uni_he *)tlv;
 	he->he_pe_duration = vif->bss_conf.htc_trig_based_pkt_ext;
-- 
2.53.0



