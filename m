Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019023;
	b=QMvYBzMKeIAVus2wZcy6QWWiQCKnet3ETUItzaHEWjToEGWTnS1E6ozzmrOQG9KAFBcV
	 oduefy90gJGmXMk8OBV0W+tFYv/M5rDp5XpdJ9kIYlNCPF1Bn8HqVj6wnKkOWHSvJ4HNZ
	 tTolGM0cPwn1GXIG7RC2ndykjt6YwRoZCC4sb1wf5VP1VgnaO2OzfAfk5eQ0S+Gf7hPfc
	 mxg+fI3xz0Z7n9k1oAad29BtL/TIoN7OFfZFYFs8IiNf9oQ38tEWsr6OsiCzXX8NErVND
	 ZNx9d8MScvMn4QhpvZke/hmYn0nd4jgWpHlLCczuOz3sSbGjeXRBr+Q7xqFy90F890g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Qxs6yXyOUx9AT1w9X69D1yyiTIh40crSYnw6fKpKd0=;
	b=OIfFOjA9I36TKTLAicsre/05A2YP4gTe0tx7oTn489OC1FD46eMJyU/5xk9ljCkveOf5
	 tw3ICbgGa/Il2NZeF7N5VBpUT9nEP8WJ/tl+gbpcHm/ewp9v529UBQBYKWw14L3F2pxlx
	 k+ichKSC+EOae193mtCnAo34T2/LIgJxxqCLepyIz2cmcEy0gsvE6b+M+DDiRw2/5OYuO
	 Zm56Y3bNmVBI8w87fNRsa2ut1CmcB4WZFlaU6D4pvg5kTIX4juG7ddyMG30weaPHlmGRB
	 6ulKWuvvTMZwETl6ESes2MyVxDwG25EQz9aL2GEW0+q8XrDzZk3hsEmhD9lyVWXEddw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KEfwQHzh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76BB606A32C;
	Wed, 18 Nov 2026 16:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KEfwQHzh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4631F000C6;
	Wed, 18 Nov 2026 16:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019023;
	bh=2Qxs6yXyOUx9AT1w9X69D1yyiTIh40crSYnw6fKpKd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEfwQHzh2+CtTx1Q1ZZHojWoVetNV4SxjGMsCPxDnk5fkCDDCPLyGWD6cC3fejGv1
	 JtlWgh8Z4yPh0FSyLO1LKQZNZcQL1R+f6DgWc9QJYZqtekYV6mKlEkEdZaDVaf1tZV
	 X51fD2T9SEFO3CQHRs1WpO7bVopQB7aunKeH65Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1449/2651] wifi: mt76: mt7921: keep the join ROC until the station is authorized
Date: Wed, 18 Nov 2026 15:44:49 +0100
Message-ID: <20261118150340.207124226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Anthony Agarro <markanthonyagarro@gmail.com>

[ Upstream commit 6f591a4bb5d9a6a4a28f3f2fd77f394ddbcc4e05 ]

When an association succeeds mac80211 calls mgd_complete_tx(), and
mt7921 aborts the join ROC there. The AP starts the 4-way handshake
right away, so the abort lands where message 3 arrives. On an MT7922
this loses message 3 often enough to matter: the supplicant sends
message 2 (acked), never receives message 3, and the connection ends
with reason 15 (4WAY_HANDSHAKE_TIMEOUT) after about 3.3 s. The mt7925
capture in the linked issue shows the same ordering: abort, message 2
out, then message 3 retried by the AP several times without an answer.

Keep the ROC after a successful (re)association on a station interface
and release it when the station is authorized, on disassociation, or
when the station is removed. The ROC timer still ends it if none of
that happens. The state lives in a flag in struct mt792x_vif so that an
unrelated ROC, for example a user remain-on-channel, is never aborted
by the authorize hook.

Tested on an MT7922 (PCIe), kernel 7.3.0-rc4, WPA3-SAE AP, two rounds
of 20 disconnect/reconnect cycles per build in the same boot, unpatched
and patched in ABAB order:

  unpatched   34 of 73 association attempts: M1 rx, M2 tx acked,
              no M3, reason 15
  patched      0 of 40

Delaying the abort by 20 ms before it made no difference (8 of 29),
and delaying 20 ms after it removed the failures (0 of 20), so what
matters is where the abort lands relative to the handshake. The
firmware behaviour after the abort is inferred from these outcomes, not
observed directly.

Not tested: MT7921 and other connac2 parts, USB and SDIO, APs other
than the one above, open or WPA2 networks, scheduled scan, suspend and
resume.

Fixes: 41ac53c899bd ("wifi: mt76: mt7921: introduce chanctx support")
Link: https://github.com/morrownr/mt76/issues/106
Signed-off-by: Mark Anthony Agarro <markanthonyagarro@gmail.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20261005203846.239445-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/main.c    | 17 +++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt792x.h     |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index d041df807f615..09574d4417cd7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -863,6 +863,12 @@ int mt7921_mac_sta_event(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	if (sta->aid > MT7921_MAX_AID)
 		return -ENOENT;
 
+	if (mvif->roc_join_held && !sta->tdls &&
+	    (ev == MT76_STA_EVENT_AUTHORIZE || ev == MT76_STA_EVENT_DISASSOC)) {
+		mvif->roc_join_held = false;
+		mt7921_abort_roc(mvif->phy, mvif);
+	}
+
 	if (ev != MT76_STA_EVENT_ASSOC)
 	    return 0;
 
@@ -904,6 +910,7 @@ void mt7921_mac_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 		struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 
 		mvif->wep_sta = NULL;
+		mvif->roc_join_held = false;
 		ewma_rssi_init(&mvif->bss_conf.rssi);
 		if (!sta->tdls)
 			mt76_connac_mcu_uni_add_bss(&dev->mphy, vif,
@@ -1446,6 +1453,16 @@ static void mt7921_mgd_complete_tx(struct ieee80211_hw *hw,
 {
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 
+	/* Keep the join ROC until the station is authorized, so that it
+	 * covers the 4-way handshake. mt7921_mac_sta_event() releases it.
+	 */
+	if (vif->type == NL80211_IFTYPE_STATION && info->success &&
+	    (info->subtype == IEEE80211_STYPE_ASSOC_REQ ||
+	     info->subtype == IEEE80211_STYPE_REASSOC_REQ)) {
+		mvif->roc_join_held = true;
+		return;
+	}
+
 	mt7921_abort_roc(mvif->phy, mvif);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 49c7b69584800..7b838a8655be6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -191,6 +191,7 @@ struct mt792x_vif {
 	struct mt792x_sta *wep_sta;
 
 	struct mt792x_phy *phy;
+	bool roc_join_held; /* join ROC kept until the STA is authorized */
 	u16 valid_links;
 	u8 deflink_id;
 	enum mt792x_mlo_pm_state mlo_pm_state;
-- 
2.53.0



