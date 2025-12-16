Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1805136CE10;
	Tue, 16 Dec 2025 12:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888003; cv=none; b=rhWwejOgy/Y2HaNlMUje5IqA4UXNeko857j6Eec8jyaUSp4MKYF2SGcHiuf8I4QZ6tC72v9rnFWP3WjIDDfcwNOGrqvO4QKCJqjsLEFhsNSHH0Tg8meladXsfnF0CEXqYOsaA17QyuuKYY9n+Y76F63obozT1GBmNLVheGs4m6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888003; c=relaxed/simple;
	bh=GJuVW/slRD/+uEJ+F0e7Oe1OPr7zLom5uYiw0aEWs18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eu+nuj3VkFKfzww6Va/5uW3X3mqEPhaXnR5ZJaOMQ+MS7w2hpNJ7uDtRZuYw6wsFkMGzcmjsiVCvylnhMZcbl/DhU8Y1AhS0f0H0o1mw6gt17Aab3Gy8REZV7yt/90wKZZaewJncK4fRExwgrbhqAi979spZLWan+l9OZcAosm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f97Di9Ox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f97Di9Ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B30FC4CEF1;
	Tue, 16 Dec 2025 12:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888003;
	bh=GJuVW/slRD/+uEJ+F0e7Oe1OPr7zLom5uYiw0aEWs18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f97Di9OxuCN44Z20wSI/3FZ0QNnrB5OSrKvakG39dreXsIfrIjXTjLxEBz8GCxspQ
	 rMEJthCZpj2g3mzD6c4QBAZAseY5/mvSTfEjWQOyPeiXtAOgmAZjmE9TTC7BFM0mTC
	 YKL89FWs27DE+6Pqvo4MpX/40LeYj7YyHISPptS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 402/614] mt76: mt7615: Fix memory leak in mt7615_mcu_wtbl_sta_add()
Date: Tue, 16 Dec 2025 12:12:49 +0100
Message-ID: <20251216111415.941069655@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 53d1548612670aa8b5d89745116cc33d9d172863 ]

In mt7615_mcu_wtbl_sta_add(), an skb sskb is allocated. If the
subsequent call to mt76_connac_mcu_alloc_wtbl_req() fails, the function
returns an error without freeing sskb, leading to a memory leak.

Fix this by calling dev_kfree_skb() on sskb in the error handling path
to ensure it is properly released.

Fixes: 99c457d902cf9 ("mt76: mt7615: move mt7615_mcu_set_bmc to mt7615_mcu_ops")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251113062415.103611-1-zilin@seu.edu.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 4064e193d4dec..08ee2e861c4e2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -874,8 +874,10 @@ mt7615_mcu_wtbl_sta_add(struct mt7615_phy *phy, struct ieee80211_vif *vif,
 	wtbl_hdr = mt76_connac_mcu_alloc_wtbl_req(&dev->mt76, &msta->wcid,
 						  WTBL_RESET_AND_SET, NULL,
 						  &wskb);
-	if (IS_ERR(wtbl_hdr))
+	if (IS_ERR(wtbl_hdr)) {
+		dev_kfree_skb(sskb);
 		return PTR_ERR(wtbl_hdr);
+	}
 
 	if (enable) {
 		mt76_connac_mcu_wtbl_generic_tlv(&dev->mt76, wskb, vif, sta,
-- 
2.51.0



