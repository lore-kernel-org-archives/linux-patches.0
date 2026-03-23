Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82143A9D9D;
	Mon, 23 Mar 2026 13:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274273; cv=none; b=GEN81IyI3HRD0+9kypvB6uxDk9ktrsFtmhcI/l9vZGspoxWhJCtk20FYiK370eTN9IXiboJgqi8vAKvxp33dz7CSDZiiokzGO29osW+ybkgOEiYdUXF/GZ5uZiycnLkaP3NVgMl6Fmw2wTVKz5DcPrjM5Tz0PO+jJb4wJrDNKh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274273; c=relaxed/simple;
	bh=rpa3nbdM+S1c5PFS54kpGERYfUQYSYT4ODzRQFh9mSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/NO+711TPqVI2fR6wLuKTcOZJOPh8k3TTCTGpQXi0E9D7lWZ9aWILraI1JSbyxMgrJMEkh5HsbhINeiozF7vNRthOHbDk1MYz1bWHtTkbZ4PqNbfVHLAS2V5x6b5CRPVQvCKJjKP8bRDr4+ZmPU7yJ5GHmx7rCo2UcyLDQrj4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YA7mNqaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YA7mNqaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF80C4CEF7;
	Mon, 23 Mar 2026 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274273;
	bh=rpa3nbdM+S1c5PFS54kpGERYfUQYSYT4ODzRQFh9mSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YA7mNqawhBCaqXDTYKARs1p0mK/Pt/ECWZZyHP2DB/BuP5tmiVY8cfoBAlEzltuVd
	 JdXC55oiIgx3oUDLHHAHZwsln1QP6s6nEQsdgaNNXAPuxSdcIyOp/BJcErcEIKD0WD
	 2T5uH/ZCY8tcLxjQyIwPHki/EtononzVXoxsJoXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 163/220] wifi: mac80211: always free skb on ieee80211_tx_prepare_skb() failure
Date: Mon, 23 Mar 2026 14:45:40 +0100
Message-ID: <20260323134509.712213301@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/channel.c      | 6 ++----
 drivers/net/wireless/mediatek/mt76/scan.c     | 4 +---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 1 -
 include/net/mac80211.h                        | 4 +++-
 net/mac80211/tx.c                             | 4 +++-
 5 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 121e51ce1bc0e..8b27d8cc086ab 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1006,7 +1006,7 @@ static void ath_scan_send_probe(struct ath_softc *sc,
 	skb_set_queue_mapping(skb, IEEE80211_AC_VO);
 
 	if (!ieee80211_tx_prepare_skb(sc->hw, vif, skb, band, NULL))
-		goto error;
+		return;
 
 	txctl.txq = sc->tx.txq_map[IEEE80211_AC_VO];
 	if (ath_tx_start(sc->hw, skb, &txctl))
@@ -1119,10 +1119,8 @@ ath_chanctx_send_vif_ps_frame(struct ath_softc *sc, struct ath_vif *avp,
 
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
diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index ff9176cdee3de..63b0447e55c15 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -63,10 +63,8 @@ mt76_scan_send_probe(struct mt76_dev *dev, struct cfg80211_ssid *ssid)
 
 	rcu_read_lock();
 
-	if (!ieee80211_tx_prepare_skb(phy->hw, vif, skb, band, NULL)) {
-		ieee80211_free_txskb(phy->hw, skb);
+	if (!ieee80211_tx_prepare_skb(phy->hw, vif, skb, band, NULL))
 		goto out;
-	}
 
 	info = IEEE80211_SKB_CB(skb);
 	if (req->no_cck)
diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index 79cc63272134d..cfbd0c50be1c9 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -3021,7 +3021,6 @@ static void hw_scan_work(struct work_struct *work)
 						      hwsim->tmp_chan->band,
 						      NULL)) {
 				rcu_read_unlock();
-				kfree_skb(probe);
 				continue;
 			}
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c2e49542626c8..706f87c6d905a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -7291,7 +7291,9 @@ void ieee80211_report_wowlan_wakeup(struct ieee80211_vif *vif,
  * @band: the band to transmit on
  * @sta: optional pointer to get the station to send the frame to
  *
- * Return: %true if the skb was prepared, %false otherwise
+ * Return: %true if the skb was prepared, %false otherwise.
+ * On failure, the skb is freed by this function; callers must not
+ * free it again.
  *
  * Note: must be called under RCU lock
  */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1b55e83404135..0692fbb6c489e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1898,8 +1898,10 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
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
2.51.0



