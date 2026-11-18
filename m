Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026155;
	b=FCA53cXpPBTFXYtHork5Jr/u8jh2dayX0ALSjNb1oHpibhnIMUBuIIVU1B7u5T7bHnZ6
	 EjAXEZ1dsrD4AM2nW8ctHk2IgQ6+fU4nIFnSTn+EZMCGigWxlglfFubBaFMnOemspqGaP
	 RkyJ3w8bGvY8YopAIwD3IVTBz1SmjMA0eNhfGICc8QKZaSpKQiGtbBQlpI/W2qvhsQFyc
	 HRCwnceOMnHWarI/fLC2Y4taOZ4mc7l8U4C7bkHIJhzHmMcHlegOzActkoHDIWPraVFpW
	 JOzGD8ZG2b+oMwK9Tn6CjCcdICqXFzX1D211L/ik/xZ4KMt0ZIw+Z+5G/hXbx0Br/pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0UwIIlm07e39gNf3oMoK38yIIVTs3uwTrWZx3SDv1Z0=;
	b=usTxOAOav6bKieprAbmoGbsKMtlHC50UrI6vCa+JsGj/psTOk3SpJq9k0a56uElSMiEy
	 bHpM3EtCNn4JjxnahWVLhYaFi05wypdwO/KJn4XxJzi/AtOK4PrIUmzh3wZCD8JkwOdXA
	 I469u2+X2o4y9Jrj1n7kg2SKl43WT+pHhrBB4nvCuf+CYUK00V9ilkM49g4f5ABPB6CYT
	 EhUxOZl6mmrxxnhDgzxoukxQiMwC9AdL1Mz1LsuKETCJLXWOmFsE18f/Dcvx0ImhSXEb+
	 qCf3YdDpm8GBkweaI0Vxo2vfGbNkTKo1H7D0cQIJtzRWayvqBX3VkMuwh8SOBiISXVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u8LLN36R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A969606A32A;
	Wed, 18 Nov 2026 18:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u8LLN36R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA911F000C5;
	Wed, 18 Nov 2026 18:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026155;
	bh=0UwIIlm07e39gNf3oMoK38yIIVTs3uwTrWZx3SDv1Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8LLN36RJtYU1RfZh1I1whF+kP+masV3/gizXjI5gWaTXXAaVbkeQn9apG8VqGnxd
	 d3Rt+tJ8q4j/1CYT9v9y6zlCadRxyiIAxwjjnkW8RRyfvDSwRJc67z/Gt03xOvAC2W
	 vpb6NelRvhQCyge2KWygwLqRjnZP/LYFMIain24Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1293/2151] wifi: mac80211: limit injected HT/VHT MCSes
Date: Wed, 18 Nov 2026 15:50:28 +0100
Message-ID: <20261118150209.223063401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 22d8e38161c722fe6e7ffb2a4c7fadab0f111271 ]

With radiotap injection the HT/VHT MCSes can be just
about anything, but that can later get problematic.

Limit them to the rates the device reports, which is
presumably going to be a subset of what mac80211 can
do, except for HT MCS 32 which some devices report as
supported, but then TX status can't deal with it.

If it's not supported just ignore the config.

Assisted-by: LLM
Fixes: dfdfc2beb0dd ("mac80211: Parse legacy and HT rate in injected frames")
Fixes: 646e76bb5daf ("mac80211: parse VHT info in injected frames")
Link: https://patch.msgid.link/20261005224950.68e210b8487a.I2ee0e4664c54cf31002eb9e4f5190fd05ff4130f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f5743e20a45bd..cdbce28631483 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2150,6 +2150,27 @@ static bool ieee80211_rate_bw_usable(u16 rate_flags,
 	return width <= cfg80211_chandef_get_width(chandef);
 }
 
+static bool
+ieee80211_vht_tx_rate_supported(const struct ieee80211_sta_vht_cap *vht_cap,
+				u8 mcs, u8 nss)
+{
+	u16 map = le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map);
+
+	if (!vht_cap->vht_supported)
+		return false;
+
+	switch ((map >> (2 * (nss - 1))) & 3) {
+	case IEEE80211_VHT_MCS_SUPPORT_0_7:
+		return mcs <= 7;
+	case IEEE80211_VHT_MCS_SUPPORT_0_8:
+		return mcs <= 8;
+	case IEEE80211_VHT_MCS_SUPPORT_0_9:
+		return mcs <= 9;
+	default:
+		return false;
+	}
+}
+
 bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 				 struct net_device *dev,
 				 const struct cfg80211_chan_def *chandef)
@@ -2344,14 +2365,20 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 					hweight8(info->control.antennas))
 				info->control.antennas = 0;
 
-			info->control.rates[0].idx = rate;
+			/* MCS 32 and up aren't handled, e.g. by TX status */
+			if (sband && sband->ht_cap.ht_supported && rate < 32 &&
+			    sband->ht_cap.mcs.rx_mask[rate / 8] & BIT(rate % 8))
+				info->control.rates[0].idx = rate;
 		} else if (rate_flags & IEEE80211_TX_RC_VHT_MCS) {
 			/* reset antennas if not enough */
 			if (vht_nss > hweight8(info->control.antennas))
 				info->control.antennas = 0;
 
-			ieee80211_rate_set_vht(info->control.rates, vht_mcs,
-					       vht_nss);
+			if (sband &&
+			    ieee80211_vht_tx_rate_supported(&sband->vht_cap,
+							    vht_mcs, vht_nss))
+				ieee80211_rate_set_vht(info->control.rates,
+						       vht_mcs, vht_nss);
 		} else if (sband) {
 			for (i = 0; i < sband->n_bitrates; i++) {
 				if (rate * 5 != sband->bitrates[i].bitrate)
-- 
2.53.0



