Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029212;
	b=or+rL6O6KMkwjmstnRqm+cuStfuti9tY17UmCXhpPShSKesmDkYtNqsa3WrNiImoHch7
	 OwoNBddzpZw7jhQ2afl0OjnOXklgEjolDasuLgm7OZLeuPWW4j7SWTtyGR06DgONSsioI
	 QeOaigJ1HTOIyiL+7+JlhGxSFL9OEu148yKw+cJS44VfdKorkeTxUlwmt8aHbVsQMOl4d
	 8RyN7Uyc6V37LUVDJXBPJmGZFphFDam+NuKBBq6w2uh1iWqbACB5Irlio5TWXsqL9CQNL
	 q6Wg+fxH9YNUhqO8fQhCVZjljFxN/QccGiQpqhLTbC6e9HLzid0AeGLP0HeIvG14noQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BZ4Y0kdHRQ1G7/X6btteKRdSqIbe4k7Bkj24hr9MJY4=;
	b=XwO+ldr90i5pC8bPhBczuhXCp5m/db9w3/+DslMna8vVVBZgtxUD/N62/44rPHGKbfre
	 G7uH3itJG5igml8TV6kiw+RzRQNgLH7GxZDT6/NHtV9EsZJDwUTKtKYVf2m+89XT+9J5N
	 YRBgaf71pmyK2UcjPxPboex7n4xD3EMXwOjxJrf7NC+GZDCMDJsVckfW5iIHKmBHIDODJ
	 EnKfnihHuXaXGQ4IN85kGsipyOTC1dAUWFWsQJ8XPMp/WMcITAkveNzpm3hSH5ubhlpeW
	 rvyPZWk/nW5PXr9cY/41Kxoz+ROxz0yR5791IM67P1rNxVxb0SHJ01sIACkLWdZZenA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yygeHQas;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA522606A325;
	Wed, 18 Nov 2026 19:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yygeHQas
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069251F000C6;
	Wed, 18 Nov 2026 19:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029212;
	bh=BZ4Y0kdHRQ1G7/X6btteKRdSqIbe4k7Bkj24hr9MJY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yygeHQasGApP7IjYM+M9W5f+BwhN2xFZ0NrZCvOC0bYevtBZKZycu+ju3ynFSwety
	 AFVmFc0PmU7r5xjWn9+en7ZgvcLGpTtQJZj4EY/TEbdKxJRCdMtyy47l9HzEniY27y
	 hWwbbkqU5b7V8d+SVM7EvKNh7C/IxrCYXP7StudY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0219/1756] wifi: mac80211: fix unauthorised port check for encap offload
Date: Wed, 18 Nov 2026 15:39:06 +0100
Message-ID: <20261118150017.028542418@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fff9ea0dba079..bacc732df0c6d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3864,6 +3864,38 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
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
@@ -3930,20 +3962,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 
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



