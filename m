Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49E37080D;
	Fri,  4 Sep 2026 06:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501969; cv=none; b=SnU6RxkrcSJ5Sgz7wEk2NLQTedYwJDbisOzCjYtaOneqXZcwSwKkfPcifa1vDkSNmeLQCiZW7Xh2XrGpcx0AY1hyQ71Q3x6HyAkHY2c0jp3BxotkPjLKlCgAXbRpzGJbvcb/OiknKlx8a/VNn+5uzJO+qP9rMoqyMejIIbB2Bs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501969; c=relaxed/simple;
	bh=6svRBWFB9JMMWQtpv9EDGz1Q8/johDRNl2SWos5+t0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ya04t7FbX2n3bzdKaHMrAIXAbH044aaDLdwzL4o8q84Hgerii3LN22tp7UgvnCDV9L5lNjbxuO+EAH+vT9c75yyqd//q+D4KOoPAM98xUpek7znpv/1BQZFqCYJveKBBeebzyax1gG2P/CZGEDQvOROawoKrO5/A3G3T4QEX7Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wI5VY+mA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wI5VY+mA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2911F00A3D;
	Fri,  4 Sep 2026 06:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501967;
	bh=eBivam/ZiB/JBUp0JkmGaC5xofjsDBImT/UXJr3leVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wI5VY+mA5ImfXSZj23Nc92q6e2Z6OMIATINrfWIaxFNhZcJ6yPd6qtmTBGOWWHPco
	 w2pbnZa5IOGu2Mn3EuWG5Ji+8i55vyZsVgOphcCoch9SJXUi4gmsdmpKB1Lr1Swvo0
	 WrP4bpQ04gukpVlIZWa93GtyomZ0msu+E05KmGW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/403] wifi: mt76: Fix memory leak after mt76_connac_mcu_alloc_sta_req()
Date: Fri,  4 Sep 2026 06:56:50 +0200
Message-ID: <20260904045734.977628328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
index b1a7fbedffac5..f60fe27ab3f9d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1289,8 +1289,10 @@ int mt76_connac_mcu_sta_ba(struct mt76_dev *dev, struct mt76_vif *mvif,
 				    wtbl_hdr);
 
 	ret = mt76_connac_mcu_sta_wed_update(dev, skb);
-	if (ret)
+	if (ret) {
+		dev_kfree_skb(skb);
 		return ret;
+	}
 
 	ret = mt76_mcu_skb_send_msg(dev, skb, cmd, true);
 	if (ret)
@@ -1303,8 +1305,10 @@ int mt76_connac_mcu_sta_ba(struct mt76_dev *dev, struct mt76_vif *mvif,
 	mt76_connac_mcu_sta_ba_tlv(skb, params, enable, tx);
 
 	ret = mt76_connac_mcu_sta_wed_update(dev, skb);
-	if (ret)
+	if (ret) {
+		dev_kfree_skb(skb);
 		return ret;
+	}
 
 	return mt76_mcu_skb_send_msg(dev, skb, cmd, true);
 }
@@ -2697,12 +2701,16 @@ int mt76_connac_mcu_add_key(struct mt76_dev *dev, struct ieee80211_vif *vif,
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
index d622d7c7bee41..32e9c0960657a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1729,8 +1729,10 @@ int mt7915_mcu_add_sta(struct mt7915_dev *dev, struct ieee80211_vif *vif,
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
index 1fc1116d9becc..910775a2c39fe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1239,8 +1239,10 @@ int mt7925_mcu_add_key(struct mt76_dev *dev, struct ieee80211_vif *vif,
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



