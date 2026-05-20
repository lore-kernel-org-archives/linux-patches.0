Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C8E369999;
	Wed, 20 May 2026 17:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297652; cv=none; b=p681TdZ1+RHugQx5J0pR7eQE4zijdRfoAygCWXNvOgV7/ztuaBDdgyP5Z6oWl8YzT8wL6CMz+95yXJr0qrCgGGOm/E/41/MHa8FSu4SI5MpxFTgDfWFwaJAW0yrfVF7LYIpi0SgewyeKDR0EDdDMclzpi+IoDS1ofvOpSWxj8E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297652; c=relaxed/simple;
	bh=VHT/WHa4O75MmOt22FzYl1vJy4XRpSjRJsTSZn4Wv/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwqRLwzASicg8SYX4+A7sgT06O51vZ4EgA/fKgrNF27/Ejm9dQFo0k414Dl0acDRdraHjUfrz9sX948Y66vhmQnCJD6KCYaC2/Md0Nuga1K2chZXDJ2gnnu5kRBH0HnaFueCD3In4Y9RwqU7AgRH81zLF4lI+pwO0YhqwBdgVxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBDZrzlb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBDZrzlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7423C1F00897;
	Wed, 20 May 2026 17:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297651;
	bh=tOXr/5UhgGf0L/A04Ibn1U+DAWc+MxYLQ4WZnvUHHdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBDZrzlbm9UhU3NDZ2Wsf62/mJuIY4EGjNvKFvJMneQe6s1HLri7lMRGBXiobQiE3
	 /1F4ZrArdblCaszcXHDArUFZzia9cO0jPIxK0UREJKNRZ15fQDRFhEktOk8s5soj9K
	 iWyD75Q/g5uAY5dWlTScEqJVI5ZH1QfM3RtZiXlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 085/957] wifi: mt76: mt7925: prevent NULL vif dereference in mt7925_mac_write_txwi
Date: Wed, 20 May 2026 18:09:28 +0200
Message-ID: <20260520162136.403738277@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 962eb04e67552be406c906c83099c1d736aae3b6 ]

Check for a NULL `vif` before accessing `ieee80211_vif_is_mld(vif)` to
avoid a potential kernel panic in scenarios where `vif` might not be
initialized.

Fixes: ebb1406813c6 ("wifi: mt76: mt7925: add link handling to txwi")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250904030649.655436-3-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index f12b8db739653..0608f0c1fd2c2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -803,8 +803,8 @@ mt7925_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 	txwi[5] = cpu_to_le32(val);
 
 	val = MT_TXD6_DAS | FIELD_PREP(MT_TXD6_MSDU_CNT, 1);
-	if (!ieee80211_vif_is_mld(vif) ||
-	    (q_idx >= MT_LMAC_ALTX0 && q_idx <= MT_LMAC_BCN0))
+	if (vif && (!ieee80211_vif_is_mld(vif) ||
+	    (q_idx >= MT_LMAC_ALTX0 && q_idx <= MT_LMAC_BCN0)))
 		val |= MT_TXD6_DIS_MAT;
 	txwi[6] = cpu_to_le32(val);
 	txwi[7] = 0;
-- 
2.53.0



