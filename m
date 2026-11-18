Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031346;
	b=HbRwNPjRBbmXkWD0AD4i3Fijv4yHNvrzkVgALBLjCB8DS3DbZRfT09Wmnr6jgUHNS2FN
	 /+jvqERPnVYM+EWXy9SoL8ZeHFXKiTqVDiKRlRJfHIeNj39bHqagOleXP7kK4NvTchdL2
	 jchWFptNXE5SbpBFabYXrczNOs13AGiSfJSnT2X4pih9eePfwyLA1C+oqRSkHhq/DtgEg
	 FuO4D6YqhhNa5KDev45M78SwKH9Gfw0fMTZj6eTN4EavdZdchvsSQM4oYfNqh4QTZK5YQ
	 gu1JJdOntsLmpJUD2iV5r+AlBdWsuQY/Y5j1m+8gweV0mPngTmlqzHtLYlCX8aTAkqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cDfGI6VFlmJsuG16M/bvsIoz9zOWGNEr6k7cHfFHULs=;
	b=3qiC+aBLgZRzcqI8pUm7jDoCNuClAg825Lkx1PS63r18BjnVs48QP3UbWrZxBdn/THex
	 TkT7hKxWttjszsqfMG8UkDNg1uP9KRBaYz3GqQ19uEfuM7oUQTItT+vrAQ08QZfy4+7EK
	 xyUeugoPtHbraCisDrGqXnmEZxiOLU4GRENEPGEf9WPFjBbVo81A4JKDauyXbFH8mU1d4
	 z3pcG5RcIpCTMPuHJMHm5VV0n8z8FX2hH+mPB4nShaoghHYUH22B/P2W+zjpPl5przr55
	 ZMgAx1GcHd5qS4hX95MkRQMv69HLaG52ZHyfOnpDhTL6NUplCD4NQd2MPlRDh1tluTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jl57mkdm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE38606A31C;
	Wed, 18 Nov 2026 19:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jl57mkdm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06D21F000C4;
	Wed, 18 Nov 2026 19:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031346;
	bh=cDfGI6VFlmJsuG16M/bvsIoz9zOWGNEr6k7cHfFHULs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jl57mkdmqHiMdWKIqq7lNpj/Rpbi7p3zs/5ToS40iXf7rEDb2LuZtunjShnc+rEid
	 7xWi/8RyXt5GKG6kXiyOKUM08ai0l1B/vSsrrgnyTBzd6EW0XxawntZQTGT0Mst763
	 cCC4BzugCVkPpSS89nf5vZShJ58NuhHEMDVVPfQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1027/1756] wifi: mac80211: limit injected HT/VHT MCSes
Date: Wed, 18 Nov 2026 15:52:34 +0100
Message-ID: <20261118150050.973943335@linuxfoundation.org>
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
index 2d0ec80f55b89..c6cc390f2fa00 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2151,6 +2151,27 @@ static bool ieee80211_rate_bw_usable(u16 rate_flags,
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
@@ -2345,14 +2366,20 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
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



