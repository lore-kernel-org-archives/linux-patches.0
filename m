Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E4A24E4C3;
	Thu,  2 Jul 2026 16:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011248; cv=none; b=gFL2N2QiR0U+aESt9QbuMiMcN4GuPamyNRd+z/2jcdNXT8EZM2kLvjxNIE4eP9w9Vedh6p0C+Jq8u5eZqsR4UYRSrDZ768Q2/mBYuGJOcsLUndceb4owIwWxuToLVTm8OdySZYHiogADa+XTPropWZwg2Wu/xr3hTWTcCNXkW4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011248; c=relaxed/simple;
	bh=Len9UJGcsrW9LUIyN+d1YJPUyL0baduf42KmhsI2mFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSJEFeJ50WrStDEfE/Icp3JrAZ/TbkTJAoRXWdXa4plutuWg+UP1QBlYHcZz04nfrwrySHAa3SX0Hza053+QA4Z6pb6pC8b8t60eGVda8L2c6eLxMAllYI2GhcnIWEZH1BtdUnFuLwopETqF+8tPbPG/Ir/saP6/5DWCPs2WJhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ss8YYIug; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ss8YYIug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777421F000E9;
	Thu,  2 Jul 2026 16:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011247;
	bh=aWdoQSqTZxq1mAxTQnk/WJvDrPW7Fcja8Il4D4jkHYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ss8YYIugcdNk/qwGKhv0JAccL3NapzoyMrBoYsQXWyVIlejC19Eq0D9XC8weIJ0+k
	 4qYpsS6miYxqvNchZ4mW/PdZ6dt7HlSM9/rwl8jYCHraYztd87Fe+XOiy0QTGhTwvS
	 KNcmBfxSnmtF8uMg4MxdnogB9AovN2AkhVWLfWuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiajia Liu <liujiajia@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.18 035/108] wifi: mt76: add wcid publish check in mt76_sta_add
Date: Thu,  2 Jul 2026 18:20:32 +0200
Message-ID: <20260702155112.835474091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

From: Jiajia Liu <liujiajia@kylinos.cn>

commit 20b126920a259df4d7dcae19fcfe2c57a74d6b2e upstream.

Since mt7925_mac_sta_add publishes wcid, add publish check in mt76_sta_add
to avoid reinitializing the wcid->poll_list.

Found dev->sta_poll_list corruption when using mt7925 and 7.1-rc4.
According to the corruption information, prev->next was changed to itself.

wlan0: disconnect from AP 90:fb:5d:94:8b:e3 for new auth to 90:fb:5d:94:8b:e2
wlan0: authenticate with 90:fb:5d:94:8b:e2 (local address=84:9e:56:9c:7e:6b)
wlan0: send auth to 90:fb:5d:94:8b:e2 (try 1/3)
 slab kmalloc-8k start ffff8c80958a6000 pointer offset 4160 size 8192
list_add corruption. prev->next should be next (ffff8c808a7488f8), but was ffff8c80958a7040. (prev=ffff8c80958a7040).

 mt76_wcid_add_poll+0x95/0xd0 [mt76]
 mt7925_mac_add_txs.part.0+0xa5/0xe0 [mt7925_common]
 mt7925_rx_check+0xa7/0xc0 [mt7925_common]
 mt76_dma_rx_poll+0x50d/0x790 [mt76]
 mt792x_poll_rx+0x52/0xe0 [mt792x_lib]

Signed-off-by: Jiajia Liu <liujiajia@kylinos.cn>
Link: https://patch.msgid.link/20260528033814.46418-1-liujiajia@kylinos.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1568,6 +1568,7 @@ mt76_sta_add(struct mt76_phy *phy, struc
 {
 	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
 	struct mt76_dev *dev = phy->dev;
+	struct mt76_wcid *published;
 	int ret;
 	int i;
 
@@ -1587,11 +1588,19 @@ mt76_sta_add(struct mt76_phy *phy, struc
 		mtxq->wcid = wcid->idx;
 	}
 
-	ewma_signal_init(&wcid->rssi);
-	rcu_assign_pointer(dev->wcid[wcid->idx], wcid);
+	published = rcu_dereference_protected(dev->wcid[wcid->idx],
+					      lockdep_is_held(&dev->mutex));
+	if (published != wcid) {
+		WARN_ON_ONCE(published);
+		ewma_signal_init(&wcid->rssi);
+		rcu_assign_pointer(dev->wcid[wcid->idx], wcid);
+		mt76_wcid_init(wcid, phy->band_idx);
+	} else {
+		wcid->phy_idx = phy->band_idx;
+	}
+
 	phy->num_sta++;
 
-	mt76_wcid_init(wcid, phy->band_idx);
 out:
 	mutex_unlock(&dev->mutex);
 


