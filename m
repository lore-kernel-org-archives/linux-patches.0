Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047870;
	b=fKEmqla2xj84r772Qbs2IDhk3YL4f5Enl5OG9ZulwDAd+Ak8+FiOFJhKbyfkUaANfKUI
	 meyML4lDJ1KfEd2slHv/bkfqRVtOEMVdDVAxGJuMHS63HZUOszEoFoXw6SgtdJHaZ+GS8
	 DWYzacDwIlFqe6XHAIb6lGNHnJTm9VpFX0DqMt2D4Q73Tw6FFKArdRKtFvaQoUjDq5o7g
	 xK950uPS/S3ACUaKHIWU7A/tyWw5dXjQQF0ylaGY1mZVT84ab/NSUEvwt1/SqLdm/vPje
	 ZrZgF1p8QgvSdeefx4ezr/MAe3k54CJp6T14yhqqVIv56JIqL3lbLpHtevLfPIRc2Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZBOJRTU6Lq3ykPqeW83nFJk1hBVoihUgy4l/J2RYilU=;
	b=1iVldlWfNgj2VDy2H7nS6bXyKfM6fcv332XXcitlWM6vCxOL9t0MH7jukcT/hDZ3hzDy
	 RT9k69H83O9atvNXLaYlm7BB0wEZgntxt8hAwxLvkqbJhN4BTZbLuj+1mdkUbtbQpWWfA
	 VATgTMnNnfaJwTSYznPup3TUbt2V1SiZG2s9er0kib7+WR8WXhtqRA3t/5A27L8eNk8tM
	 uep/oynG3tGbqEbEZljQ8lKAbNZrgSA1pxaaqDqdSyM9DvAJdbznez+Q0+MlvPeHm/MQi
	 GkMwMyVJRJiml9Nr/ulVOxbz7IF9AEDykLftMZlB3C7wJ4ikvRDsDHL8pv3Wsfb9ziw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XD2gJjQL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D0C606A320;
	Thu, 19 Nov 2026 00:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XD2gJjQL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119E41F000C4;
	Thu, 19 Nov 2026 00:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047870;
	bh=ZBOJRTU6Lq3ykPqeW83nFJk1hBVoihUgy4l/J2RYilU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XD2gJjQLuxveADTVNqlV6oIwE+gMK+lc4GwYnsQujvF00wom8H3CG3aGWRNp/yntg
	 mkpab1N+OtLNd4R3shTiVkm+W+cZECEDFz5jlo2WyToYrytyO/KARQyt7JDhDzFjvN
	 FH8YHqFYmO5e/yyMrZCVkzryghZm+loNLXZ3WhTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1793/2857] wifi: mac80211: fix unauthorised port check for encap offload
Date: Wed, 18 Nov 2026 15:47:07 +0100
Message-ID: <20261118150305.824836993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d59b9bf7df49367e01b06e82dd0f6e7ad3be493c ]

The check in ieee80211_tx_dequeue() reads frame_control, addr1 and
addr2 out of the skb, but for encapsulation offload that's just a
random part of the ethernet addresses, so dropping depends on bits
in the destination address. This is obviously wrong.

Refactor the check and short-circuit for ethernet format frames,
it only needs the port-control flag check since those are locally
generated and not forwarded frames.

Fixes: 50ff477a8639 ("mac80211: add 802.11 encapsulation offloading support")
Link: https://patch.msgid.link/20260802105818.dd5da579813d.I51ed0121154bb652bebc97bb0597b1fae9ac978f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 48 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 028e5d25d005f..9fd867722ef9b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3749,6 +3749,38 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	return true;
 }
 
+static bool ieee80211_drop_unauth_port(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+	struct ieee80211_hdr *hdr;
+
+	if (likely(test_sta_flag(tx->sta, WLAN_STA_AUTHORIZED)))
+		return false;
+
+	if (info->flags & IEEE80211_TX_CTL_INJECTED)
+		return false;
+
+	if (ieee80211_vif_is_mesh(&tx->sdata->vif) ||
+	    tx->sdata->vif.type == NL80211_IFTYPE_OCB)
+		return false;
+
+	/* no need to check forwarding here */
+	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
+		return !(info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO);
+
+	hdr = (struct ieee80211_hdr *)tx->skb->data;
+
+	if (!ieee80211_is_data_present(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1))
+		return false;
+
+	if ((info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO) &&
+	    ieee80211_is_our_addr(tx->sdata, hdr->addr2, NULL))
+		return false;
+
+	return true;
+}
+
 struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 				     struct ieee80211_txq *txq)
 {
@@ -3815,20 +3847,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 
 	if (txq->sta) {
 		tx.sta = container_of(txq->sta, struct sta_info, sta);
-		/*
-		 * Drop unicast frames to unauthorised stations unless they are
-		 * injected frames or EAPOL frames from the local station.
-		 */
-		if (unlikely(!(info->flags & IEEE80211_TX_CTL_INJECTED) &&
-			     ieee80211_is_data_present(hdr->frame_control) &&
-			     !ieee80211_vif_is_mesh(&tx.sdata->vif) &&
-			     tx.sdata->vif.type != NL80211_IFTYPE_OCB &&
-			     !is_multicast_ether_addr(hdr->addr1) &&
-			     !test_sta_flag(tx.sta, WLAN_STA_AUTHORIZED) &&
-			     (!(info->control.flags &
-				IEEE80211_TX_CTRL_PORT_CTRL_PROTO) ||
-			      !ieee80211_is_our_addr(tx.sdata, hdr->addr2,
-						     NULL)))) {
+
+		if (unlikely(ieee80211_drop_unauth_port(&tx))) {
 			I802_DEBUG_INC(local->tx_handlers_drop_unauth_port);
 			ieee80211_free_txskb(&local->hw, skb);
 			goto begin;
-- 
2.53.0



