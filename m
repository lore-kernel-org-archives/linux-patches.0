Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039294;
	b=0gBQyeGN+1NRb4f8v//TRhFjaY7fKlqK7RRNj34TdcKxP8xA+j7vKbKAIeF0T1+GgPB3
	 BgN/obSqX/qw2OoYILO9TayEC4TQI78R8xYOfE/+P0ILVgx/aZhRpgHb+HsOP3LCvybQd
	 KTaB2mCnn5WjsyjnNsWylCicpiUJbXeGz7ZjI0Pnwe2O41eyE+elBGUcsZ+4prR7y2nCZ
	 phuvnqiDDZWITpyMv2ccwFsZiYD/AYDNz2vvCdgxbWn8oYoIZYwGQ/WEEfERnHdVMuxZx
	 7zsrPDoYZ0Zq3REpTvCsdBtQKo+miXH/9P10BJ8G44zsIaeAmYOGUBNsONmLcAxZD9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AeJmiXlzSKxaTqfTU+LWnHtTlEOwozzMi62HGCoe7yU=;
	b=YlT6K1fADSlJKaHdaM33j+lPL6hv4s6jVhorvt0V47xo+J/TeheH7dJcMyrKchkSTY0c
	 bAFDNv7QUmfJ9VuMPKouz8f/dQds+dRJnHPCNpXMSyt19CINrqQPw5Hn5YvVCq13iqeOY
	 z4niIJuw7IQLXcFkNbbxbKRBNTXSYC5GLST0Ydw4RuJnbSFEXtH2Jg9L3nqHspJEVW40X
	 zyrbOX/3EVOnfuXtb1YX419T6NwCSQxf1gpwi0ehH4rHW2KrVBObSC6n55HfP8mTiqG0p
	 pmh98mbu7Hjvf/hixwWEl/xYo5vDIC5AyS31g/aN8W0yWsYXUERpwVn/sF7QVaaWJvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zuaz53D4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1992A606A320;
	Wed, 18 Nov 2026 22:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zuaz53D4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5951F000C4;
	Wed, 18 Nov 2026 22:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039294;
	bh=AeJmiXlzSKxaTqfTU+LWnHtTlEOwozzMi62HGCoe7yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zuaz53D49966A25YH8uxFWOeIEnYuUjtvu9ihH4omKaUTSQreJIRTXg/AxrBEBZxk
	 msriIEqLxhuJU/UKnvlyu5XYPvuEUYt0F165Eb5WOXvZla5u96QcGf7rpuTO1nUSJG
	 vCRFJ2ptdZhMHOYSBvYQzBbLA04qBXfyyIX2u6CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2047/3318] wifi: mac80211: fix unauthorised port check for encap offload
Date: Wed, 18 Nov 2026 15:44:29 +0100
Message-ID: <20261118150423.453959141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c0e9ed8ec1d19..683d8194b7f4f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3831,6 +3831,38 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
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
@@ -3897,20 +3929,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 
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



