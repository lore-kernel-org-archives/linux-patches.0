Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76B43BB9F1;
	Sat, 17 Oct 2026 17:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258769; cv=none; b=Bo9AfA7ZCAYte/POGPHKwBk8pvN2XZ53ctomnnRyoBZNeoUFRpAmtA0lwPaK+tt9gQmZ3vN9z+tp7qdeEHTYRnvnDdxnWU9LreA9ABbAf1zFaLSilw+wuoSlhRIfU6bTr67FBM8oQItNm/lOsaWuLSqjUTF3X0lN6/UZr6/dAj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258769; c=relaxed/simple;
	bh=/AA5c5OHm8Y/ZL4RCrreT3XPwq0j56SpLfBY3Vrw1kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6WV3e/dXQ/H8oeiBi8Yl+obuxywlEbZ+CcvlR7Sh6fPyHSVV0CYd36u/e8Y0t7M8kWLH6XQgUg6vpyxyHhf1RMq71lPnI+Ev0OWR87SM8dSBOwfezikRW2brtIlj16Ne42MrKMdbsGaga+3KA4sJWDntj9RbtrXtvF8Cb1dG74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arXcExSv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arXcExSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105051F000C4;
	Sat, 17 Oct 2026 17:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258768;
	bh=h/6xen5+gWQYx+oj8J/TfeZXSGKFn+lIsGgsDaQtiKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=arXcExSvzvaeqMIL1Cy+s/ZvEYRtSvFmlKgNJqrff4zx3pI49qy/m35vCeM7S/zOH
	 o+XuMOm5wJCfc05Q6feE9STrQ3bzdyq/h5uMLRXYU/n2sVrM7YQtC7S/3BveKx3Xoy
	 ZI5BRW1EM+02iWF083eNpFxlztJg9uvtfyYpkneI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0993/1674] wifi: mt76: Fix memory leak after mt76_connac_mcu_alloc_sta_req()
Date: Sat, 17 Oct 2026 17:54:25 +0200
Message-ID: <20261017160456.607011944@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index ef1e68154bb61..c459b18ddc140 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1261,8 +1261,10 @@ int mt76_connac_mcu_sta_ba(struct mt76_dev *dev, struct mt76_vif *mvif,
 				    wtbl_hdr);
 
 	ret = mt76_connac_mcu_sta_wed_update(dev, skb);
-	if (ret)
+	if (ret) {
+		dev_kfree_skb(skb);
 		return ret;
+	}
 
 	ret = mt76_mcu_skb_send_msg(dev, skb, cmd, true);
 	if (ret)
@@ -1275,8 +1277,10 @@ int mt76_connac_mcu_sta_ba(struct mt76_dev *dev, struct mt76_vif *mvif,
 	mt76_connac_mcu_sta_ba_tlv(skb, params, enable, tx);
 
 	ret = mt76_connac_mcu_sta_wed_update(dev, skb);
-	if (ret)
+	if (ret) {
+		dev_kfree_skb(skb);
 		return ret;
+	}
 
 	return mt76_mcu_skb_send_msg(dev, skb, cmd, true);
 }
@@ -2775,12 +2779,16 @@ int mt76_connac_mcu_add_key(struct mt76_dev *dev, struct ieee80211_vif *vif,
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
index 6c0ae5715ca6c..e74ff483f2e18 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1717,8 +1717,10 @@ int mt7915_mcu_add_sta(struct mt7915_dev *dev, struct ieee80211_vif *vif,
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
-- 
2.53.0



