Received: from n169-110.mail.139.com (n169-110.mail.139.com [120.232.169.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFD9279DC3
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 02:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776739396; cv=none; b=Kud7IdtwnB78VBgyq8vPNwn0TFGq83k1jIqhGw+boLhwhRCQzFRJAGRLAD+AxdFHmpZoy5VLPfM8LTrLiHvHXV1fmnyOApjheX1Xq0kLaGaU0C/S7goDb8j1AbiySOHK7/P1VjxK5oq5NuMf8ttdFruW6zv25VTwJ6wlP9RNBcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776739396; c=relaxed/simple;
	bh=nQlA5oloE69vE2YHeBxLDmuVKy01qwmMu0Wmqd+a0Ok=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RVWPvwcjspyjjD7iQB1byaVknavx9MLiMgduzeCftWJJvTaUET+mBtTKNXnX0btWFT7l2iZHQdvKmE/SYVGkmu9smkJ/KvEvdjw62lfsQr8F0a9W7EtJ7KYnqrx1lI+Q1cW8tcvmcnEObKYLGggnUQYkaYKM3Yy9d/k6bfh7nMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=f0/dCLKb; arc=none smtp.client-ip=120.232.169.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="f0/dCLKb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=f0/dCLKbJKv/5v2fSglsOneBu4l8pLH1zeC9oV/STwAfNX3R5Cp/gKhAL1eFp11j4iMpDngooajhu
	 j80Oc89m2rAC/2bYKjdiVFXT+mOCXCPC0QL9p/hUsalrM6zcyRamvcStBulKIjczKUrln1LeJOM1Yg
	 VP7PZdN04rrMg9dE=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-08-12086 (RichMail) with SMTP id 2f3669e6e4383ec-07482;
	Tue, 21 Apr 2026 10:43:09 +0800 (CST)
X-RM-TRANSID:2f3669e6e4383ec-07482
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	nbd@nbd.name
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	toke@toke.dk,
	kvalo@kernel.org,
	johannes@sipsolutions.net,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	nbd@openwrt.org,
	linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	johannes.berg@intel.com
Subject: [PATCH 6.6.y] wifi: mac80211: always free skb on ieee80211_tx_prepare_skb() failure
Date: Tue, 21 Apr 2026 10:43:09 +0800
Message-Id: <20260421024309.3131840-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit d5ad6ab61cbd89afdb60881f6274f74328af3ee9 ]

ieee80211_tx_prepare_skb() has three error paths, but only two of them
free the skb. The first error path (ieee80211_tx_prepare() returning
TX_DROP) does not free it, while invoke_tx_handlers() failure and the
fragmentation check both do.

Add kfree_skb() to the first error path so all three are consistent,
and remove the now-redundant frees in callers (ath9k, mt76,
mac80211_hwsim) to avoid double-free.

Document the skb ownership guarantee in the function's kdoc.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/20260314065455.2462900-1-nbd@nbd.name
Fixes: 06be6b149f7e ("mac80211: add ieee80211_tx_prepare_skb() helper function")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ Exclude changes to drivers/net/wireless/mediatek/mt76/scan.c as this file is first
 introduced by commit 31083e38548f("wifi: mt76: add code for emulating hardware scanning")
 after linux-6.14.]
Signed-off-by: Li hongliang <1468888505@139.com>
---
 drivers/net/wireless/ath/ath9k/channel.c      | 6 ++----
 drivers/net/wireless/virtual/mac80211_hwsim.c | 1 -
 include/net/mac80211.h                        | 4 ++++
 net/mac80211/tx.c                             | 4 +++-
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 571062f2e82a..ba8ec5112afe 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1011,7 +1011,7 @@ static void ath_scan_send_probe(struct ath_softc *sc,
 	skb_set_queue_mapping(skb, IEEE80211_AC_VO);
 
 	if (!ieee80211_tx_prepare_skb(sc->hw, vif, skb, band, NULL))
-		goto error;
+		return;
 
 	txctl.txq = sc->tx.txq_map[IEEE80211_AC_VO];
 	if (ath_tx_start(sc->hw, skb, &txctl))
@@ -1124,10 +1124,8 @@ ath_chanctx_send_vif_ps_frame(struct ath_softc *sc, struct ath_vif *avp,
 
 		skb->priority = 7;
 		skb_set_queue_mapping(skb, IEEE80211_AC_VO);
-		if (!ieee80211_tx_prepare_skb(sc->hw, vif, skb, band, &sta)) {
-			dev_kfree_skb_any(skb);
+		if (!ieee80211_tx_prepare_skb(sc->hw, vif, skb, band, &sta))
 			return false;
-		}
 		break;
 	default:
 		return false;
diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index 1214e7dcc812..bf12ff0ab06a 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -2892,7 +2892,6 @@ static void hw_scan_work(struct work_struct *work)
 						      hwsim->tmp_chan->band,
 						      NULL)) {
 				rcu_read_unlock();
-				kfree_skb(probe);
 				continue;
 			}
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index adaa1b2323d2..85d785060e76 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -7032,6 +7032,10 @@ void ieee80211_report_wowlan_wakeup(struct ieee80211_vif *vif,
  * @band: the band to transmit on
  * @sta: optional pointer to get the station to send the frame to
  *
+ * Return: %true if the skb was prepared, %false otherwise.
+ * On failure, the skb is freed by this function; callers must not
+ * free it again.
+ *
  * Note: must be called under RCU lock
  */
 bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7eddcb6f9645..2a708132320c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1911,8 +1911,10 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 	struct ieee80211_tx_data tx;
 	struct sk_buff *skb2;
 
-	if (ieee80211_tx_prepare(sdata, &tx, NULL, skb) == TX_DROP)
+	if (ieee80211_tx_prepare(sdata, &tx, NULL, skb) == TX_DROP) {
+		kfree_skb(skb);
 		return false;
+	}
 
 	info->band = band;
 	info->control.vif = vif;
-- 
2.34.1


