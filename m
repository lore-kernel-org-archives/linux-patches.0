Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A26D3A9629;
	Fri,  4 Sep 2026 05:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500333; cv=none; b=P9NQLrN9FMDvbap2uwg6AosU/bv/kkTM9eLmGz57caeZZutIvzKnoxBxlVWI+IxEWaf3nBlBEfNzD9Icoek1Elf0w6qfhZGWkqzh9O2vLqMDg3iPPUSqXgSdhJxu2b0W9srw3ihWp+oBY0TRgRf++mMjqc3KVfmmPP3IZWjiEJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500333; c=relaxed/simple;
	bh=DFKdlPAZJH3OLRLHE8zFgWTWpTjwL9Zxh9AVF8cVhYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDAPFR0DJyjWeNug43OiOxoaIWN3DDnii4beLTVDGsILsUTOyqrvALoHqKnfyXbixwU/pUzXf8enuKOmd/8G3WoUbDZ17Xq1uUuLhpoY7w8nG5/veatAmoM+inBxBhDCK83BP1EUSnVydr+0Br8U2fQoVoicQC1J4DGocnPm/Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0gUIfNZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0gUIfNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBBD1F00A3D;
	Fri,  4 Sep 2026 05:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500332;
	bh=G00Cwh9lfC7DEfTa8hTzbsV7CiXr14OHGa1ygxcHRbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0gUIfNZgAP0s/hkobMEsbhBYR7q0Hcwyz1kT4/qOEjxYT05jA6Y7htsb4JMXU+sD
	 DxIFPVgHfmbP9uCgVHqataPdiIwxatXWjYDK/s1Y6ltNtL4yxhpj1inci+ZojFBXIB
	 oETZqBasRUNTlbUwSUzvHxE+ImdwhChZc4tNXwM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/552] wifi: mt76: Fix memory leak after mt76_connac_mcu_alloc_sta_req()
Date: Fri,  4 Sep 2026 06:52:39 +0200
Message-ID: <20260904045747.877049359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

[ Upstream commit c41075ce8cf05ed8c0e7b7efef000dce548ffc42 ]

mt76_connac_mcu_alloc_sta_req() allocates an skb which is expected to
be freed eventually by mt76_mcu_skb_send_msg(). However, currently if
an intermediate function fails before sending, the allocated skb is
leaked.

Specifically, mt76_connac_mcu_sta_wed_update() and
mt76_connac_mcu_sta_key_tlv() may fail, leading to an immediate memory
leak in the error path.

Fix this by explicitly freeing the skb in these error paths.
Commit 7c0f63fe37a5 ("wifi: mt76: mt7996: fix memory leak on
mt7996_mcu_sta_key_tlv error") made a similar change.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: d1369e515efe ("wifi: mt76: connac: introduce mt76_connac_mcu_sta_wed_update utility routine")
Fixes: 6683d988089c ("mt76: connac: move mt76_connac_mcu_add_key in connac module")
Fixes: 4f831d18d12d ("wifi: mt76: mt7915: enable WED RX support")
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20260116144919.1482558-1-zilin@seu.edu.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c | 16 ++++++++++++----
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c  |  4 +++-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c  |  4 +++-
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 2aa7b711c774e..46e337307c3d8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1295,8 +1295,10 @@ int mt76_connac_mcu_sta_ba(struct mt76_dev *dev, struct mt76_vif_link *mvif,
 				    wtbl_hdr);
 
 	ret = mt76_connac_mcu_sta_wed_update(dev, skb);
-	if (ret)
+	if (ret) {
+		dev_kfree_skb(skb);
 		return ret;
+	}
 
 	ret = mt76_mcu_skb_send_msg(dev, skb, cmd, true);
 	if (ret)
@@ -1309,8 +1311,10 @@ int mt76_connac_mcu_sta_ba(struct mt76_dev *dev, struct mt76_vif_link *mvif,
 	mt76_connac_mcu_sta_ba_tlv(skb, params, enable, tx);
 
 	ret = mt76_connac_mcu_sta_wed_update(dev, skb);
-	if (ret)
+	if (ret) {
+		dev_kfree_skb(skb);
 		return ret;
+	}
 
 	return mt76_mcu_skb_send_msg(dev, skb, cmd, true);
 }
@@ -2766,12 +2770,16 @@ int mt76_connac_mcu_add_key(struct mt76_dev *dev, struct ieee80211_vif *vif,
 		return PTR_ERR(skb);
 
 	ret = mt76_connac_mcu_sta_key_tlv(sta_key_conf, skb, key, cmd);
-	if (ret)
+	if (ret) {
+		dev_kfree_skb(skb);
 		return ret;
+	}
 
 	ret = mt76_connac_mcu_sta_wed_update(dev, skb);
-	if (ret)
+	if (ret) {
+		dev_kfree_skb(skb);
 		return ret;
+	}
 
 	return mt76_mcu_skb_send_msg(dev, skb, mcu_cmd, true);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index f60e2eaea2af4..bd121eec51651 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1773,8 +1773,10 @@ int mt7915_mcu_add_sta(struct mt7915_dev *dev, struct ieee80211_vif *vif,
 	}
 out:
 	ret = mt76_connac_mcu_sta_wed_update(&dev->mt76, skb);
-	if (ret)
+	if (ret) {
+		dev_kfree_skb(skb);
 		return ret;
+	}
 
 	return mt76_mcu_skb_send_msg(&dev->mt76, skb,
 				     MCU_EXT_CMD(STA_REC_UPDATE), true);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 647efa963db48..bc19e800b41c9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1290,8 +1290,10 @@ int mt7925_mcu_add_key(struct mt76_dev *dev, struct ieee80211_vif *vif,
 		return PTR_ERR(skb);
 
 	ret = mt7925_mcu_sta_key_tlv(wcid, sta_key_conf, skb, key, cmd, msta);
-	if (ret)
+	if (ret) {
+		dev_kfree_skb(skb);
 		return ret;
+	}
 
 	return mt76_mcu_skb_send_msg(dev, skb, mcu_cmd, true);
 }
-- 
2.53.0



