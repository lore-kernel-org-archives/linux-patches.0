Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015651;
	b=BTjH23ByxMqMZJebSehVdUssCk/7qk9Iq512sGsHvD2QiNjNv7pFRGYpodrqRV6FxUwN
	 XlU/zkTNaGkSup9PX7E5+D9QSPZO7dSA9HMcmKD81PEorwKDcuDfpQxMhQy51otOP04wQ
	 saut2naEslF3KKbbIVpygN3AO8N2LO21AFVgzK6t/a5LAeuqyEZCCFXgwpPUUclZsgRsf
	 1SxAn6qXi8QNSP/HgooJ03IMn5Po5cp3v38A/cKBw9vz8XExenh4UIeWsxdoWWI90VFOh
	 6HKV68x/CjGz3R1ApEFZqOigIsQwT96PRZO1G5yIoM1p4480zWpj9ljwzrfKKi8aNGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D3d8Zu+ACZkbV3Ul3/B0dO9MMeZxzitruo5UVgH79xU=;
	b=IhmJ1nMQXJDOB4MsZGFg5ewqnmGJX8oXTKk1W+ERJT/tzsPl4UxM2pi6m2ieJfDYaAcM
	 63LxcH8+3BEUIlw0zTAqikwm/ZpwxVrNglgB7ktngIJbqZ5OKkf8yKifVtE5Cw5BMyq5H
	 aO5dBGp7VXewSiVm5m78r/mP+hfBOCYM2T87Opbsujax15p3phlLZOFMk/xtMaGHGuw25
	 2ZfBRPBSnmPeQ50SND8qRqEcrF/PICW1/q2VLBfy57ugDE3LELnFhoA9IaXmX4fN7DVwG
	 un4Ie4DuEay9zEuTn817Sy3BrA2crrRt5e4SdqdC1iJ+wvvS7uLkxpSHTnfERDiklVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+xOI1vl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0DF606A337;
	Wed, 18 Nov 2026 15:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+xOI1vl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8F91F000C4;
	Wed, 18 Nov 2026 15:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015651;
	bh=D3d8Zu+ACZkbV3Ul3/B0dO9MMeZxzitruo5UVgH79xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+xOI1vlg81u3CoAS0l4Cr9DozgON+ySD/jOugMHfxINGz4VEUJCY6//wx5vfjQB4
	 gt3Z3uTOoWQW1kh04m/Y2J/eDnqzMUJRgGnI8Vk4MjTr7MCyls4rxaLJcyS+JjlaY0
	 sKPOtWae8ADXC3jIOQBM/ExYuyje4ya7El//g+QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0208/2651] wifi: mac80211: fix unauthorised port check for encap offload
Date: Wed, 18 Nov 2026 15:24:08 +0100
Message-ID: <20261118150255.362785357@linuxfoundation.org>
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
index 27bae2a4fa86e..cfa77d4fd96f5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3923,6 +3923,38 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
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
@@ -3989,20 +4021,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 
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



