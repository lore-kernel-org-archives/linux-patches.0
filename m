Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637BD33E347;
	Fri, 24 Apr 2026 13:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037942; cv=none; b=BLtrY7TBwW2KR0CsTgYW5ELKT22WlBsaWKZmZ8HBo+FQwsBxGt/r5Cv/0xL7WHJ4Yp/7EBa/2Dw3nG9G/2JVBjQQQJP/8HSnW7NcKB+ZzNxO7IpoCkMJegH5ikoeurpzJjbVoQE+O+ONFHKbZbML7UnaQe+vxTDxAh7HlgW7vj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037942; c=relaxed/simple;
	bh=g4hi8mzWjRaiI84Gma+5B5Rb0F1ckTsMdl9iV2frB8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W70lHlCxWVOPBigcEaYQ772+Uk9lsW7GsC4aPCwLQPeIPKn/WQfTXSk5eJQ+fgoKIYDuvOFxu3lTTY0+SZvk5CVAbtde+q2oZWODsvwKB1w790JUO/QsyQ4eqUnQiBfYisfPqwCYwxqLMiP4wN8ynVFmkxDwAwPMQYiGeDg2eKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xuTkK689; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xuTkK689"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB16C19425;
	Fri, 24 Apr 2026 13:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037942;
	bh=g4hi8mzWjRaiI84Gma+5B5Rb0F1ckTsMdl9iV2frB8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xuTkK689F0GLWXwrVaoV7fZ1Q8kstWHZwk+7Jx5sinGJTbJHEuTnV3MYEL9mKZgOY
	 3zQnRtuB1sVwwG75BnWTvBXguDuZm2OzVYQWtvxJf5cCh7ggPFrpuuKeBNvZnFJIEp
	 bNSIGsLgSyW+HWSU0gMhquFM4yOqUcj6Jn/tIrwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Li hongliang <1468888505@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/166] wifi: mac80211: always free skb on ieee80211_tx_prepare_skb() failure
Date: Fri, 24 Apr 2026 15:30:44 +0200
Message-ID: <20260424132600.130441339@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/channel.c      | 6 ++----
 drivers/net/wireless/virtual/mac80211_hwsim.c | 1 -
 include/net/mac80211.h                        | 4 ++++
 net/mac80211/tx.c                             | 4 +++-
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 571062f2e82a7..ba8ec5112afe8 100644
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
index 1214e7dcc8124..bf12ff0ab06ab 100644
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
index adaa1b2323d2c..85d785060e761 100644
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
index 7eddcb6f96455..2a708132320c4 100644
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
2.53.0



